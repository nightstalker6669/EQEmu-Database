#!/usr/bin/env python3
"""Scent joint content source. Default offline; does not install quest files."""
import argparse
import hashlib
import json
import os
from datetime import datetime, timezone
from decimal import Decimal
from pathlib import Path

ROOT = Path(__file__).resolve().parent
ROUTINE = 'source_scent_npc_conditional_apply'
NPC_SQL = 'be75bdbad4dbbebbddccd8f4ab39c80d10f37bd81efa3d7a13e5634d3fbfb672'
DELIVERY = '85eeb3d426a98e70dd923e9e2bf87ff344c0bf24ecc54ab6d6edc84e924f71a9'
KEYS = {
    'npc_types': ['id'], 'spawngroup': ['id'], 'spawnentry': ['spawngroupID', 'npcID'],
    'spawn2': ['id'], 'loottable': ['id'], 'loottable_entries': ['loottable_id', 'lootdrop_id'],
    'lootdrop': ['id'], 'lootdrop_entries': ['lootdrop_id', 'item_id'],
    'spawn_conditions': ['zone', 'id'], 'dynamic_zone_templates': ['id'], 'tasks': ['id'],
    'task_activities': ['taskid', 'activityid'], 'rewards': ['reward_id'],
    'reward_sets': ['reward_set_id'], 'reward_sources': ['source_type', 'source_id'],
    'reward_options': ['reward_set_id', 'option_id'],
    'reward_option_entries': ['reward_set_id', 'option_id', 'sequence'],
}


def require(ok, message):
    if not ok:
        raise RuntimeError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def equal(a, b):
    if isinstance(a, dict) and isinstance(b, dict):
        return a.keys() == b.keys() and all(equal(a[k], b[k]) for k in a)
    if isinstance(a, list) and isinstance(b, list):
        return len(a) == len(b) and all(equal(x, y) for x, y in zip(a, b))
    if isinstance(a, (int, float, Decimal)) and isinstance(b, (int, float, Decimal)):
        return Decimal(str(a)) == Decimal(str(b))
    if isinstance(a, datetime):
        a = str(a)
    if isinstance(b, datetime):
        b = str(b)
    return a == b


def save(path, value):
    with os.fdopen(os.open(path, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600), 'w') as f:
        json.dump(value, f, indent=2, default=str)
        f.write('\n')
        f.flush()
        os.fsync(f.fileno())
    fd = os.open(path.parent, os.O_RDONLY | os.O_DIRECTORY)
    try:
        os.fsync(fd)
    finally:
        os.close(fd)


def references(cur, refs, lock=False):
    for name, guard in refs.items():
        cur.execute(guard['query'] + (' LOCK IN SHARE MODE' if lock else ''))
        require(equal(cur.fetchall(), guard['rows']), 'Reference drift: ' + name)


def postimages(cur, inserts):
    result = {}
    for table, rows in inserts.items():
        result[table] = []
        for row in rows:
            keys = KEYS[table]
            cur.execute('SELECT * FROM `' + table + '` WHERE ' +
                        ' AND '.join('`' + k + '`=%s' for k in keys), tuple(row[k] for k in keys))
            found = cur.fetchall()
            require(len(found) == 1 and equal(found[0], row), 'Full postimage mismatch: ' + table)
            result[table].append(found[0])
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument('--define-routine', action='store_true')
    mode.add_argument('--apply', action='store_true')
    mode.add_argument('--verify', action='store_true')
    parser.add_argument('--config', type=Path)
    parser.add_argument('--quest-root', type=Path)
    parser.add_argument('--receipt-dir', type=Path)
    parser.add_argument('--expected-bundle-sha256')
    parser.add_argument('--host', default='127.0.0.1')
    parser.add_argument('--port', type=int, default=3306)
    args = parser.parse_args()
    data = json.loads((ROOT / 'combined-data.draft.json').read_text())['inserts']
    spells = json.loads((ROOT / 'task-reward-data.json').read_text())['inserts']
    if not (args.define_routine or args.apply or args.verify):
        print(json.dumps({'mode': 'offline_plan', 'database_connected': False,
                          'rows': {t: len(r) for t, r in data.items()}, 'quests_installed': False}))
        return
    require(args.config and args.receipt_dir, 'Live mode requires config and new receipt directory')
    require(args.expected_bundle_sha256 == sha(ROOT / 'bundle-manifest.json'), 'Exact published bundle required')
    bundle = json.loads((ROOT / 'bundle-manifest.json').read_text())
    for name, digest in bundle['files'].items():
        require(sha(ROOT / name) == digest, 'Bundle file drift: ' + name)
    sql_path = ROOT / 'npc-component/apply.sql.disabled'
    require(sha(sql_path) == NPC_SQL, 'Wrong NPC-owned routine revision')
    require(sum(map(len, data.values())) == 173 and sum(map(len, spells.values())) == 42,
            'Wrong joint scope')
    if args.apply:
        require(args.quest_root, 'Intended quest root required')
        require(sha(args.quest_root / 'lua_modules/achievement_native_delivery_handin.lua') == DELIVERY,
                'Shared native delivery helper drift')
        for name in bundle['runtime_files']:
            target = args.quest_root / name
            require(not target.exists() and not target.is_symlink(), 'Quest callback path occupied: ' + name)
    cfg = json.loads(args.config.read_text())['server']['database']
    require(cfg['db'] == 'peq_housing_test', 'Wrong configured target')
    args.receipt_dir.mkdir(parents=True, mode=0o700, exist_ok=False)
    import pymysql
    connection = pymysql.connect(host=args.host, port=args.port, user=cfg['username'],
                                 password=cfg['password'], database=cfg['db'], autocommit=False,
                                 cursorclass=pymysql.cursors.DictCursor)
    receipt = {'utc': datetime.now(timezone.utc).isoformat(), 'database': cfg['db'],
               'bundle_sha256': args.expected_bundle_sha256, 'intended_after': data,
               'quests_installed': False, 'before': {}}
    refs = json.loads((ROOT / 'reference-preimages.json').read_text())
    try:
        with connection.cursor() as cur:
            cur.execute('SELECT DATABASE() AS target')
            require(cur.fetchone()['target'] == 'peq_housing_test', 'Wrong live database')
            if args.define_routine:
                # DDL is isolated here. Never define/drop routines inside the joint transaction.
                cur.execute('SELECT ROUTINE_NAME FROM information_schema.ROUTINES WHERE '
                            'ROUTINE_SCHEMA=DATABASE() AND ROUTINE_NAME=%s', (ROUTINE,))
                require(not cur.fetchall(), 'Routine already exists; reconcile exact definition, do not replace')
                connection.rollback()
                sql = sql_path.read_text()
                body = sql.split('DELIMITER $$\n', 1)[1].split('$$', 1)[0].strip()
                receipt['status'] = 'PREPARED_ROUTINE_DEFINITION_ONLY_NO_CONTENT_WRITES'
                save(args.receipt_dir / 'prepared.json', receipt)
                cur.execute(body)
                receipt['status'] = 'ROUTINE_DEFINED_ONLY_NOT_CONTENT_APPLIED'
                save(args.receipt_dir / 'completed.json', receipt)
                return
            if args.verify:
                receipt['after'] = postimages(cur, data)
                references(cur, refs)
                connection.rollback()
                receipt['status'] = 'PASS_INDEPENDENT_173_ROW_READBACK_NOT_RUNTIME_ACCEPTANCE'
                save(args.receipt_dir / 'readback.json', receipt)
                print(receipt['status'])
                return
            connection.begin()
            for table, rows in data.items():
                cur.execute('SELECT ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() '
                            'AND TABLE_NAME=%s', (table,))
                require(cur.fetchone() == {'ENGINE': 'InnoDB'}, 'Nontransactional table: ' + table)
                cur.execute('SHOW COLUMNS FROM `' + table + '`')
                require({r['Field'] for r in cur.fetchall()} == set(rows[0]), 'Schema drift: ' + table)
            guards = json.loads((ROOT / 'namespace-preimages.json').read_text())['checks']
            for name, guard in guards.items():
                cur.execute(guard['query'] + ' FOR UPDATE')
                found = cur.fetchall()
                require(not found and not guard['rows'], 'Namespace/consumer collision: ' + name)
                receipt['before'][name] = found
            # NPC-owned finite guards, including condition references, are mirrored from
            # the pinned routine for full empty preimages before its first insert.
            for name, query in bundle['npc_namespace_guards'].items():
                cur.execute(query + ' FOR UPDATE')
                found = cur.fetchall()
                require(not found, 'NPC namespace/consumer collision: ' + name)
                receipt['before']['npc_' + name] = found
            for table in ['character_tasks', 'character_activities', 'completed_tasks']:
                cur.execute('SELECT taskid FROM `' + table + '` WHERE taskid=920136 LIMIT 1 FOR UPDATE')
                require(not cur.fetchall(), 'Existing legitimate progress/history: ' + table)
            references(cur, refs, lock=True)
            receipt['preserved_references'] = refs
            # Bind the live routine body too; a matching disk SQL alone proves no live definition.
            cur.execute('SHOW CREATE PROCEDURE ' + ROUTINE)
            definition = cur.fetchone()['Create Procedure']
            source = sql_path.read_text().split('CREATE PROCEDURE ', 1)[1].split('$$', 1)[0]
            require(definition[definition.index('BEGIN'):].strip() == source[source.index('BEGIN'):].strip(),
                    'Live routine body differs from published NPC source')
            save(args.receipt_dir / 'prepared.json', receipt)
            cur.execute('SET @scent_joint_source_authorized=1')
            cur.callproc(ROUTINE)
            while cur.nextset():
                pass
            for table, rows in spells.items():
                for row in rows:
                    columns = list(row)
                    cur.execute('INSERT INTO `' + table + '` (' + ','.join('`'+k+'`' for k in columns) +
                                ') VALUES (' + ','.join(['%s']*len(columns)) + ')', tuple(row[k] for k in columns))
                    require(cur.rowcount == 1, 'Unexpected insert count: ' + table)
            receipt['after'] = postimages(cur, data)
            references(cur, refs)
        connection.commit()
        receipt['status'] = 'COMMITTED_173_ROWS_QUESTS_NOT_INSTALLED_CACHE_NOT_REFRESHED'
        save(args.receipt_dir / 'completed.json', receipt)
        print(receipt['status'])
    except BaseException:
        connection.rollback()
        # Prepared-only or an uncertain commit/DDL result MUST be reconciled.
        # No automatic retry, guessed deletion, or player-state rollback.
        raise
    finally:
        connection.close()


if __name__ == '__main__':
    main()
