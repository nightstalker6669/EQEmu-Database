# Vergalid Mines: quests and achievement rewards

This package adds **17 quests, 56 objectives, four achievement groups and their item rewards** to the integrated RoF2 server. It includes the original quest givers, corpse drops, treasure chest, bait encounters, inner-mine shard passage and shared Unearthed Power encounter. The historical cutoff is **May 31, 2013**.

Use the **whole package installer** below. It installs the journal, acquisition routes, actors, quest callbacks and activation together; none of these parts is optional. This is an addition to the matching achievement engine and existing content, not a replacement PEQ database.

| Achievement family | Included quests | Parent reward family |
|---|---|---|
| Disrupting the Mines | Earthy Extermination I–III; Drakkin Blood; Kill the Miners; Gygun’s Last Request; Gygun’s Treasure | Class-appropriate Elaborate Consigned chest armor |
| Exploring Vergalid | Lost Souls I–II; Duskmold | Elaborate Consigned head armor |
| Togswell’s Experiments | Serric Lives; Handle With Care; Bile From Below | Elaborate Soldier’s or Scryer’s Facemask |
| The Depths of Vergalid | Unearthed Power; Into the Void; Nhemen’s Secret; The Ancient Tablet | Paired Soldier’s or Scryer’s earrings |

**Opcodes and structures are available:** [protocol guide](PROTOCOL.md) · [complete RoF2 achievement protocol reference](../../protocol/README.md). This content uses existing messages and adds no new opcode or packet field.

## Before installing

1. Use this branch’s matching engine and required achievement/shared-task schema migrations. Follow the [branch installation guide](../../../../../docs/rof2/INSTALL.md) and [engine guide](../../ENGINE.md). The restricted shard item-cast event support is already integrated; do not reapply archived source patches.
2. Install the earlier required achievement content, including the Blightfire delivery and JSON modules. Keep existing zone scripts, including Vergalid’s elevator `player.pl`.
3. Back up the database, quests, binaries and opcode files. Stop world, zones and all other writers before applying this upgrade.
4. Have Python 3, a MariaDB/MySQL client and its matching dump tool available. Put credentials in a protected private client configuration file; keep them out of commands and the repository.

The installer checks exact database content and callback conflicts. Custom or incompatible preimages require a deliberate merge. Do not remove guards or import an entire database to bypass a conflict.

## Inspect the package

From this directory:

```sh
python3 install.py --inspect-package
```

This reads package integrity and readiness without connecting to a database. For native Windows use `py -3` in place of `python3`.

## Linux installation

Create two **private local** JSON files containing command argument arrays. For example, `mysql-command.json`:

```json
["mariadb", "--defaults-extra-file=/secure/private-db.cnf", "peq"]
```

And `dump-command.json`:

```json
["mariadb-dump", "--defaults-extra-file=/secure/private-db.cnf", "peq"]
```

Replace the database and paths with your server’s actual values. The private configuration must select the intended host/user and credentials. First inspect the database and quest composition:

```sh
python3 install.py \
  --mysql-command-json "$(cat mysql-command.json)" \
  --quests /srv/eqemu/quests
```

After stopping writers and deploying the matching engine, install every component together:

```sh
python3 install.py \
  --mysql-command-json "$(cat mysql-command.json)" \
  --dump-command-json "$(cat dump-command.json)" \
  --quests /srv/eqemu/quests \
  --backup /srv/backups/vergalid-first-install \
  --services-stopped --matching-engine-installed --apply
```

The backup directory must be new and outside the quest tree. Use `--additional-quests` for an additional existing quest search root when your server uses one; conflicting callbacks must be resolved first.

## Native Windows installation

Use the same installer with Python 3 and native MariaDB/MySQL tools. JSON arrays support executable paths with spaces. A private `mysql-command.json` might contain:

```json
["C:\\MariaDB\\bin\\mariadb.exe", "--defaults-extra-file=C:\\private\\eqemu-db.cnf", "peq"]
```

Make the matching `dump-command.json` with `mariadb-dump.exe`. In PowerShell, first inspect:

```powershell
py -3 .\install.py --mysql-command-json (Get-Content .\mysql-command.json -Raw) --quests C:\EQEmu\quests
```

With game services stopped and matching binaries deployed:

```powershell
py -3 .\install.py --mysql-command-json (Get-Content .\mysql-command.json -Raw) --dump-command-json (Get-Content .\dump-command.json -Raw) --quests C:\EQEmu\quests --backup C:\EQEmuBackups\vergalid-first-install --services-stopped --matching-engine-installed --apply
```

Native Windows execution has not been verified. The installer is portable Python; the Linux gameplay evidence below does not establish Windows runtime acceptance.

## Akk-stack installation

Use the same Linux workflow in your stack’s matching tools/container environment. Supply the database host and credentials through a private client file reachable there, and use paths visible **inside that environment** for quests and backups. Run the installer against the mounted active quest tree while game writers are stopped; the database service must remain available for the guarded transaction and dump. Keep backups on persistent storage. The installer neither chooses a Docker project nor starts/stops services for you.

## What installation changes

The installer takes a complete database dump, backs up exact quest bytes, composes the existing callbacks, and applies all four SQL phases in one transaction. Original spawn positions, respawn timers and patrol grids are preserved. Original placeholders remain alongside the added named outcomes. Unrelated items and quest files are preserved.

A failed SQL step restores the previous quest bytes. Keep writers stopped and inspect the installation receipt: a connection failure near commit can leave the database outcome uncertain. Review the full backup before restoring anything. Restart normal services only after a successful install and matching engine deployment.

## Native coverage and historical limits

All 17 quests completed through real native task objectives, actual kills, corpse loot, hand-ins and confirmed rewards. All four parent item reward paths were claimed on a Warrior, including both items in the paired-earring choice. The shard check covered an actual charged-item cast, permanent-key custody, refusal without a key and individual passage in both directions. The orb required combat; `/open` did not grant completion. See [coverage and limits](provenance/native-coverage.json) for persistence and exact scope.

These checks use private GM travel, QA equipment and bounded acquisition fixtures. Skullrend and Vu`Ryn kill/drop acceptance used temporary native-type spawns at reviewed placeholder positions; this does not prove natural rare-roll rates. Some ordinary acquisition checks appended only already-supported drops to individual NPCs before actual kills and looting. The database drop rates were not changed for those checks. No test harnesses, captures, player records or client assets are distributed.

Confirmed historical facts and labelled reconstruction choices are kept separate:

- The original head-reward **Consigned Cap family** is confirmed. Its four named variants use current corroboration and a pre-2013 item-family inference; exact historical variant associations and UI filtering were not independently captured.
- Original warrior/cleric guardian roles and level 74 are period-supported. Missing combat values, rare chances, guardian positions, replacement timing, orb HP and idle reset use explicitly approved configurable emulator defaults.
- The orb’s combat class and no-melee flags are server implementation policy. They preserve real killer attribution, stationary behavior and native task credit; the original class/ability list was not recovered.
- Geometry volumes, exact landing points and model binding retain their uncertainty. The Runed Orb model exists in the original RoF2 assets; this does not independently prove its original quest binding.
- Bile’s configured minimum 65 follows the best-supported earlier metadata with the conflict documented. XP defaults are used only where a period source confirms XP but omits its amount.
- Unearthed Power uses the period-confirmed native shared task with minimum one player. The current encounter passed with one member; full multiplayer orb acceptance and native Windows execution remain unverified.

[Historical decisions](provenance/quest-decisions.json) · [archive review](provenance/archive-reward-and-bait-review.json) · [approved defaults](provenance/approved-defaults.json) · [world policy](provenance/world-policy.json) · [model evidence](provenance/model-evidence.json).
