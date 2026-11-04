#!/usr/bin/env python3
"""Plan/apply the spell content overlay; never start or reload game services."""
import argparse
import datetime
import hashlib
import json
import math
import os
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def equal(left, right):
    if isinstance(left, (datetime.date, datetime.datetime)):
        left = str(left)
    if isinstance(left, (int, float)) and isinstance(right, (int, float)):
        return math.isclose(left, right, rel_tol=1e-6, abs_tol=1e-6)
    return left == right


def sql_key(key):
    return " AND ".join(f"`{name}`=%s" for name in key), tuple(key.values())


def check_merchant_requirements(cursor, payload):
    """Refuse missing gain routes, shared lists, or unreviewed merchant edits."""
    for rule in payload.get("required_rules", []):
        cursor.execute("SELECT rule_value FROM rule_values WHERE rule_name=%s", (rule["rule_name"],))
        if any(str(r["rule_value"]).strip() != str(rule["value"]) for r in cursor.fetchall()):
            raise RuntimeError(f"Faction threshold rule differs: {rule['rule_name']}")
    for requirement in payload.get("required_merchant_consumers", []):
        cursor.execute("SELECT id,name FROM npc_types WHERE merchant_id=%s ORDER BY id FOR UPDATE",
                       (requirement["merchantid"],))
        if cursor.fetchall() != requirement["npcs"]:
            raise RuntimeError(f"Merchant list consumers differ: {requirement['merchantid']}")
    for requirement in payload.get("required_merchant_inventories", []):
        cursor.execute("SELECT * FROM merchantlist WHERE merchantid=%s ORDER BY slot FOR UPDATE",
                       (requirement["merchantid"],))
        actual = cursor.fetchall()
        if actual != requirement["before"] and actual != requirement["after"]:
            raise RuntimeError(f"Merchant inventory was customized: {requirement['merchantid']}")
    for faction in payload.get("required_gain_factions", []):
        cursor.execute("SELECT id FROM tasks WHERE enabled=1 AND repeatable=1 "
                       "AND faction_reward=%s AND faction_amount>0 LIMIT 1", (faction,))
        task = cursor.fetchone()
        cursor.execute("SELECT n.id FROM npc_faction_entries e "
                       "JOIN npc_types n ON n.npc_faction_id=e.npc_faction_id "
                       "JOIN spawnentry se ON se.npcID=n.id "
                       "JOIN spawn2 s ON s.spawngroupID=se.spawngroupID "
                       "WHERE e.faction_id=%s AND e.value>0 AND se.chance>0 LIMIT 1", (faction,))
        if not task and not cursor.fetchone():
            raise RuntimeError(f"No existing repeatable task or spawned kill faction gain route: {faction}")
    for spell in payload.get("required_spells", []):
        fields = list(spell)
        cursor.execute("SELECT " + ",".join(f"`{f}`" for f in fields) +
                       " FROM spells_new WHERE id=%s", (spell["id"],))
        if cursor.fetchone() != spell:
            raise RuntimeError(f"Dated merchant spell identity differs: {spell['id']}")


def atomic_script_write(destination, content):
    """Replace a verified script on the same filesystem, preserving its mode."""
    mode = destination.stat().st_mode & 0o777
    fd, temporary = tempfile.mkstemp(prefix=".rof2-spells-", dir=destination.parent)
    try:
        with os.fdopen(fd, "wb") as handle:
            handle.write(content)
            handle.flush()
            os.fsync(handle.fileno())
        os.chmod(temporary, mode)
        os.replace(temporary, destination)
    finally:
        Path(temporary).unlink(missing_ok=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--db-config", type=Path, required=True,
                        help="Private JSON: host, port, user, password, database")
    parser.add_argument("--server", type=Path, required=True)
    parser.add_argument("--include-estimates", action="store_true",
                        help="Also select the explicitly estimated pet/aura reconstruction")
    parser.add_argument("--apply", action="store_true")
    parser.add_argument("--backup", type=Path,
                        help="New private backup directory; required with --apply")
    args = parser.parse_args()
    if args.apply and (not args.backup or args.backup.exists()):
        parser.error("--apply requires a new --backup directory")
    try:
        import pymysql
    except ImportError:
        parser.error("Install PyMySQL in a private virtual environment first")
    config = json.loads(args.db_config.read_text())
    allowed = {"host", "port", "user", "password", "database", "unix_socket"}
    if not set(config) <= allowed or not {"user", "database"} <= set(config):
        parser.error("Invalid database configuration fields")
    manifest = json.loads((ROOT / "manifest.json").read_text())
    selected = [s for s in manifest["stages"]
                if not s["contains_estimates"] or args.include_estimates]
    payloads = [json.loads((ROOT / s["path"]).read_text()) for s in selected]
    files = {s["path"]: hashlib.sha256((ROOT / s["path"]).read_bytes()).hexdigest()
             for s in selected}
    if any(files[s["path"]] != s["sha256"] for s in selected):
        parser.error("Content payload differs from its manifest checksum")
    if not (args.server / "quests").is_dir():
        parser.error("Expected existing server quests directory")
    stage_names = {s["name"] for s in selected}
    quest_files = []
    predecessors = {}
    for entry in manifest["quest_files"]:
        if entry["stage"] not in stage_names:
            continue
        relative = Path(entry["path"])
        if relative.is_absolute() or ".." in relative.parts or relative.parts[0] != "quests":
            parser.error("Invalid quest path in manifest")
        source, destination = ROOT / relative, args.server / relative
        npc_id = entry.get("npc_id")
        if npc_id:
            alternatives = [destination.with_suffix(".pl")]
            alternatives += [destination.parent / f"{npc_id}{suffix}" for suffix in (".lua", ".pl")]
            if any(p.exists() for p in alternatives):
                parser.error(f"Existing NPC quest takes precedence or conflicts; merge it first: {relative}")
        allowed_preimages = set(entry.get("previous_sha256", []))
        if destination.exists() and destination.read_bytes() != source.read_bytes():
            if hashlib.sha256(destination.read_bytes()).hexdigest() not in allowed_preimages:
                parser.error(f"Quest script already differs; merge it first: {relative}")
        predecessors[str(relative)] = allowed_preimages
        quest_files.append((relative, source, destination))
    connection = pymysql.connect(**config, autocommit=False,
                                 cursorclass=pymysql.cursors.DictCursor)
    inserts, updates, deletes, counts = [], [], [], {}
    scripts_created, scripts_updated, directories_created = [], [], []
    committed = False
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT GET_LOCK('rof2_spells_install',0) AS locked")
            if cursor.fetchone()["locked"] != 1:
                raise RuntimeError("Another spell content installer holds the lock")
            cursor.execute("SELECT version FROM db_version")
            versions = cursor.fetchall()
            if len(versions) != 1 or versions[0]["version"] < manifest["required_schema_version"]:
                raise RuntimeError("Run the matching server database updater before installing spell content")
            cursor.execute("SELECT id,last_id FROM reward_selection_wire_allocator")
            allocator = cursor.fetchall()
            if len(allocator) != 1 or allocator[0]["id"] != 1 or not 0 <= allocator[0]["last_id"] < 4294967295:
                raise RuntimeError("Invalid durable reward wire allocator; do not reset its high-water mark")
            tables = {table for p in payloads for table in p["inserts"]}
            tables.update(u["table"] for p in payloads for u in p["updates"])
            tables.update(d["table"] for p in payloads for d in p.get("deletes", []))
            for table in tables:
                cursor.execute("SHOW TABLE STATUS WHERE Name=%s", (table,))
                status = cursor.fetchone()
                if not status or status["Engine"].lower() != "innodb":
                    raise RuntimeError(f"{table} must exist and use InnoDB")
            # Exact schema preflight: missing custom/modern columns are not silently dropped.
            columns = {}
            for table in tables:
                cursor.execute(f"SHOW COLUMNS FROM `{table}`")
                columns[table] = {r["Field"] for r in cursor.fetchall()}
            for payload in payloads:
                check_merchant_requirements(cursor, payload)
                for npc in payload.get("required_npcs", []):
                    cursor.execute("SELECT id,name,merchant_id,class FROM npc_types WHERE id=%s FOR UPDATE", (npc["id"],))
                    if cursor.fetchone() != npc:
                        raise RuntimeError(f"Merchant NPC identity/binding differs: {npc['id']}")
                for faction in payload.get("required_factions", []):
                    cursor.execute("SELECT id,name FROM faction_list WHERE id=%s FOR UPDATE", (faction["id"],))
                    if cursor.fetchone() != faction:
                        raise RuntimeError(f"Faction identity differs: {faction['id']}")
                for item in payload.get("required_items", []):
                    fields = "id,Name,scrolleffect" if "Name" in item else "id,scrolleffect"
                    cursor.execute(f"SELECT {fields} FROM items WHERE id=%s FOR UPDATE", (item["id"],))
                    if cursor.fetchone() != item:
                        raise RuntimeError(f"Spell scroll identity differs: {item['id']}")
                for table, rows in payload["inserts"].items():
                    counts[table] = counts.get(table, 0) + len(rows)
                    pk = manifest["primary_keys"][table]
                    for row in rows:
                        missing = set(row) - columns[table]
                        if missing:
                            raise RuntimeError(f"Unsupported schema {table}: missing {sorted(missing)}")
                        key = {k: row[k] for k in pk}
                        where, values = sql_key(key)
                        cursor.execute(f"SELECT * FROM `{table}` WHERE {where} FOR UPDATE", values)
                        old = cursor.fetchone()
                        if old:
                            differing = [k for k, v in row.items() if not equal(old[k], v)]
                            if differing:
                                raise RuntimeError(f"Conflicting {table} key {key}: {differing}")
                        else:
                            inserts.append((table, row))
                for update in payload["updates"]:
                    table = update["table"]
                    fields = set(update["key"]) | set(update["identity"]) | set(update["before"]) | set(update["after"])
                    if fields - columns[table]:
                        raise RuntimeError(f"Unsupported schema {table}: missing {sorted(fields - columns[table])}")
                    where, values = sql_key(update["key"])
                    cursor.execute(f"SELECT * FROM `{table}` WHERE {where} FOR UPDATE", values)
                    old = cursor.fetchone()
                    if not old or any(old[k] != v for k, v in update["identity"].items()):
                        raise RuntimeError(f"Row identity differs in {table}: {update['key']}")
                    if all(equal(old[k], v) for k, v in update["after"].items()):
                        continue
                    if not all(equal(old[k], v) for k, v in update["before"].items()):
                        raise RuntimeError(f"Vendor binding was customized: {update['key']}")
                    updates.append(update)
                for deletion in payload.get("deletes", []):
                    table, key, before = deletion["table"], deletion["key"], deletion["before"]
                    if set(key) != set(manifest["primary_keys"][table]) or set(before) != columns[table]:
                        raise RuntimeError(f"Deletion requires exact primary key and full row preimage: {table}")
                    if any(before[k] != v for k, v in key.items()):
                        raise RuntimeError(f"Deletion key/preimage differ: {table}")
                    where, values = sql_key(key)
                    cursor.execute(f"SELECT * FROM `{table}` WHERE {where} FOR UPDATE", values)
                    old = cursor.fetchone()
                    if old is None:
                        continue
                    if old != before:
                        raise RuntimeError(f"Deletion preimage was customized: {table} {key}")
                    deletes.append(deletion)
            incoming = {}
            for payload in payloads:
                for table, rows in payload["inserts"].items():
                    if table in ("items", "npc_types", "npc_spells", "rewards", "npc_faction", "spawngroup", "tradeskill_recipe"):
                        field = "reward_id" if table == "rewards" else "id"
                        incoming.setdefault(table, set()).update(r[field] for r in rows)
            dependencies = {"items": set(), "npc_types": {752146},
                            "npc_spells": set(), "spells_new": set(), "spawngroup": set(),
                            "tradeskill_recipe": set(), "npc_faction": set(), "faction_list": set()}
            for payload in payloads:
                for table, rows in payload["inserts"].items():
                    for row in rows:
                        for target, field in {
                            "merchantlist": [("items", "item")],
                            "spawn2": [("spawngroup", "spawngroupID")],
                            "spawnentry": [("spawngroup", "spawngroupID"), ("npc_types", "npcID")],
                            "tradeskill_recipe_entries": [("tradeskill_recipe", "recipe_id"), ("items", "item_id")],
                            "pets": [("npc_types", "npcID")],
                            "auras": [("npc_types", "npc_type"), ("spells_new", "type"),
                                      ("spells_new", "spell_id")],
                            "npc_types": [("npc_spells", "npc_spells_id"),
                                          ("npc_faction", "npc_faction_id")],
                            "npc_faction": [("faction_list", "primaryfaction")],
                            "npc_spells_entries": [("spells_new", "spellid"),
                                                   ("npc_spells", "npc_spells_id")],
                            "items": [("spells_new", "scrolleffect"), ("spells_new", "clickeffect")],
                            "rewards": [("items", "reward_data_id")],
                        }.get(table, []):
                            value = row[field]
                            if value and value > 0:
                                dependencies[target].add(value)
            for table, ids in dependencies.items():
                needed = sorted(ids - incoming.get(table, set()))
                for start in range(0, len(needed), 400):
                    batch = needed[start:start + 400]
                    cursor.execute(f"SELECT id FROM `{table}` WHERE id IN (" +
                                   ",".join(["%s"] * len(batch)) + ")", batch)
                    missing = set(batch) - {r["id"] for r in cursor.fetchall()}
                    if missing:
                        raise RuntimeError(f"Missing {table} dependencies: {sorted(missing)}")
            cursor.execute("SELECT name FROM npc_types WHERE id=752146")
            if cursor.fetchone()["name"] != "#Tomekeeper_Kerkaz":
                raise RuntimeError("Kerkaz NPC identity differs")
            for name in ("TaskSystem:EnableTaskSystem", "Items:AlwaysReturnHandins"):
                cursor.execute("SELECT rule_value FROM rule_values WHERE rule_name=%s", (name,))
                if any(r["rule_value"].lower() not in ("true", "1") for r in cursor.fetchall()):
                    raise RuntimeError(f"Required rule has a disabled ruleset: {name}")
            # Validate each offered bundle against the dated spell catalogue.
            catalogues = {
                "004-kerk-motes": "provenance/kerk-rewards.json",
                "007-voa-scrolls-and-tasks": "provenance/voa-tasks.json",
                "008-hot-fragment-exchanges": "provenance/hot-tasks.json",
            }
            for stage, path in catalogues.items():
                if stage not in stage_names:
                    continue
                data = json.loads((ROOT / path).read_text())
                for task in data if isinstance(data, list) else data["catalogues"]:
                    for cls, choices in task["classes"].items():
                        for choice in choices:
                            for item in choice:
                                cursor.execute(f"SELECT name,rank,`classes{int(cls)}` AS level "
                                               "FROM spells_new WHERE id=%s", (item["spell_id"],))
                                if cursor.fetchone() != {"name": item["name"], "rank": task["rank"],
                                                          "level": task["level"]}:
                                    raise RuntimeError(f"Spell era/class/rank mismatch in {stage}: {item['spell_id']}")
            if "010-sod-runes-and-downgrades" in stage_names:
                sod = json.loads((ROOT / "provenance/sod-runes-and-downgrades.json").read_text())
                for item in sod["catalogue"]:
                    cursor.execute(f"SELECT name,rank,`classes{int(item['class'])}` AS level "
                                   "FROM spells_new WHERE id=%s", (item["spell_id"],))
                    if cursor.fetchone() != {"name": item["name"], "rank": 10, "level": item["level"]}:
                        raise RuntimeError(f"SoD rune spell identity differs: {item['spell_id']}")
            if "009-legacy-exchanges" in stage_names:
                legacy = json.loads((ROOT / "provenance/legacy-exchanges.json").read_text())
                for item in legacy["catalogues"]["tss"]:
                    cursor.execute(f"SELECT name,rank,`classes{int(item['class'])}` AS level "
                                   "FROM spells_new WHERE id=%s", (item["spell_id"],))
                    if cursor.fetchone() != {"name": item["name"], "rank": 10, "level": item["level"]}:
                        raise RuntimeError(f"Legacy rune spell identity differs: {item['spell_id']}")
                for item in legacy["catalogues"]["underfoot_gems"]:
                    for cls, level in item["class_levels"].items():
                        cursor.execute(f"SELECT name,rank,`classes{int(cls)}` AS level "
                                       "FROM spells_new WHERE id=%s", (item["spell_id"],))
                        if cursor.fetchone() != {"name": item["spell_name"], "rank": 5, "level": level}:
                            raise RuntimeError(f"Legacy gem spell identity differs: {item['spell_id']}")
            if "006-ordered-runes" in stage_names:
                ordered = json.loads((ROOT / "provenance/ordered-runes.json").read_text())
                for catalogue in ordered["catalogues"].values():
                    for item in catalogue:
                        cursor.execute(f"SELECT name,rank,`classes{int(item['class'])}` AS level "
                                       "FROM spells_new WHERE id=%s", (item["spell_id"],))
                        if cursor.fetchone() != {"name": item["name"], "rank": 10,
                                                  "level": item["level"]}:
                            raise RuntimeError(f"Ordered spell era/class/rank mismatch: {item['spell_id']}")
            report = {"stages": [s["name"] for s in selected], "content_rows": counts,
                      "new_rows": len(inserts), "vendor_updates": len(updates),
                      "rows_removed": len(deletes),
                      "quest_scripts_new": [str(r) for r, _, d in quest_files if not d.exists()],
                      "quest_scripts_updated": [str(r) for r, s, d in quest_files
                                                if d.exists() and d.read_bytes() != s.read_bytes()],
                      "quest_script_new": any(str(r) == "quests/shardslanding/#Tomekeeper_Kerkaz.lua" and not d.exists()
                                              for r, _, d in quest_files), "applied": False,
                      "payload_sha256": files}
            if not args.apply:
                print(json.dumps(report, indent=2))
                connection.rollback()
                return
            # No credentials are copied into the backup/receipt.
            args.backup.mkdir(parents=True, mode=0o700)
            backup = args.backup / "changes.json"
            fd = os.open(backup, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
            with os.fdopen(fd, "w") as handle:
                json.dump({"new_rows": inserts, "updates": updates,
                           "deleted_rows": deletes,
                           "quest_script_preimage": next((d.read_text() if d.exists() else None
                                                          for r, _, d in quest_files
                                                          if str(r) == "quests/shardslanding/#Tomekeeper_Kerkaz.lua"), None),
                           "quest_script_preimages": {str(r): d.read_text() if d.exists() else None
                                                       for r, _, d in quest_files}}, handle, default=str)
            for table, row in inserts:
                names = list(row)
                cursor.execute(f"INSERT INTO `{table}` (" + ",".join(f"`{k}`" for k in names) +
                               ") VALUES (" + ",".join(["%s"] * len(names)) + ")", tuple(row.values()))
            for update in updates:
                where, values = sql_key(update["key"])
                after = update["after"]
                cursor.execute(f"UPDATE `{update['table']}` SET " +
                               ",".join(f"`{k}`=%s" for k in after) + " WHERE " + where,
                               tuple(after.values()) + values)
            for deletion in deletes:
                where, values = sql_key(deletion["key"])
                cursor.execute(f"DELETE FROM `{deletion['table']}` WHERE {where}", values)
                if cursor.rowcount != 1:
                    raise RuntimeError("Guarded deletion did not remove exactly one row")
            for relative, source, destination in quest_files:
                if destination.exists():
                    original = destination.read_bytes()
                    if original != source.read_bytes():
                        if hashlib.sha256(original).hexdigest() not in predecessors[str(relative)]:
                            raise RuntimeError(f"Concurrent quest edit: {relative}")
                        # Only an explicitly recorded, byte-identical published predecessor
                        # may be upgraded. Its original bytes are in the private receipt.
                        atomic_script_write(destination, source.read_bytes())
                        scripts_updated.append((source, destination, original))
                    continue
                missing = []
                parent = destination.parent
                while not parent.exists():
                    missing.append(parent)
                    parent = parent.parent
                for parent in reversed(missing):
                    parent.mkdir()
                    directories_created.append(parent)
                # Exclusive creation preserves any concurrent quest edit.
                with destination.open("xb") as handle:
                    handle.write(source.read_bytes())
                scripts_created.append((source, destination))
            connection.commit()
            committed = True
            report["applied"] = True
            report["quest_scripts_sha256"] = {str(r): hashlib.sha256(s.read_bytes()).hexdigest()
                                              for r, s, _ in quest_files}
            report["quest_script_sha256"] = report["quest_scripts_sha256"].get(
                "quests/shardslanding/#Tomekeeper_Kerkaz.lua")
            (args.backup / "receipt.json").write_text(json.dumps(report, indent=2) + "\n")
            print(json.dumps(report, indent=2))
    except Exception:
        if not committed:
            connection.rollback()
            for source, destination, original in reversed(scripts_updated):
                if destination.exists() and destination.read_bytes() == source.read_bytes():
                    atomic_script_write(destination, original)
            for source, destination in reversed(scripts_created):
                if destination.exists() and destination.read_bytes() == source.read_bytes():
                    destination.unlink()
            for directory in reversed(directories_created):
                try:
                    directory.rmdir()
                except OSError:
                    pass
        raise
    finally:
        with connection.cursor() as cursor:
            cursor.execute("SELECT RELEASE_LOCK('rof2_spells_install')")
        connection.close()


if __name__ == "__main__":
    main()
