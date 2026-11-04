# Sunderock quests for the May 2013 achievement catalogue

This batch supplies the 15 Sunderock Hero’s Journey quest routes, their 56 objectives, and the four parent reward families. It uses existing original NPCs and item routes wherever they are present. The minimum-level and repeatability decisions, confirmed rewards and source references are recorded in `provenance/quest-decisions.json`.

**Status: all 15 routes and all four parent item reward paths passed native checks on the combined Linux server.** The full historical achievement project is not complete. Exact original faction amounts for the Captain chain and Elite’s Insignia remain unresolved; numeric faction grants are not implemented. The Mine’s historical raid-access flag and the downstream Sergeant Kazzar raids are not implemented by this package. Courier formation, oozebud size/combat and exploration volumes contain explicitly identified reconstruction or existing PEQ settings.

## Included

- Captain Zheren’s six-task chain, beginning at the original Blightfire crossroads sign.
- Anaglass’s four-task springs cycle, including real pod children and the period three-elemental objective.
- Both Rites of Passage tasks, including an actual ground egg with stage-dependent pickup.
- The Missing Caravan through the original barrel’s native `/open` and corpse-loot route.
- Beasts of Sunderock and Elite’s Insignia, with actual item custody and hand-ins.
- Four parent achievement reward families, including the two-ring Rites bundle.

The [protocol guide](PROTOCOL.md) links the achievement opcodes and packet structures. This content batch adds no new wire opcode.

## Installation

First install the matching [achievement engine](../../ENGINE.md) and earlier Blightfire content. The existing quest modules and current database schema are required; the installer checks them. Python 3 and MariaDB with enforced CHECK constraints are required. Native Windows execution has not been verified.

1. Inspect the target database and quest directory. Use your own protected database options file; keep passwords out of command history.

   ```sh
   python3 install.py --mysql-command-json '["mariadb","--defaults-extra-file=/secure/eqemu.cnf","peq"]' --quests /path/to/server/quests
   ```

2. Stop all game and content writers. Back up the server configuration as part of your normal server maintenance. Confirm that the running binaries match this branch’s achievement engine.

3. Apply the **whole batch** with a fresh backup directory. The dump command must select the same database as the client command.

   ```sh
   python3 install.py --mysql-command-json '["mariadb","--defaults-extra-file=/secure/eqemu.cnf","peq"]' --dump-command-json '["mariadb-dump","--defaults-extra-file=/secure/eqemu.cnf","peq"]' --quests /path/to/server/quests --backup /private/backups/sunderock-before-install --apply --services-stopped --matching-engine-installed
   ```

   Windows uses the same argument structure with Python and MariaDB executable/options-file paths appropriate to that server. This is a source/content installer, not a replacement Windows server binary.

The installer includes all database changes, quest composition and activation. It saves a full private database dump and the exact prior versions of changed quest files. Database changes use one transaction; a deliberate row-guard failure rolls back the whole database batch and restores composed quest files. A connection failure near commit can leave its outcome uncertain: keep writers stopped and inspect the database against the backup before restarting.

Rerunning the same complete package is supported. Conflicting original NPC rows, owned content rows, alternate quest owners or existing custom hand-in handlers require an explicit merge; they are not silently overwritten. Use `--additional-quests` for additional quest roots so conflicts are checked there too. Start the server only after installation succeeds, then verify gameplay.

## Historical boundaries and remaining work

The cut-off is May 31, 2013. Later maximum-level headers, the later eight-elemental counter, and the later final-hail description for Elite’s Insignia are excluded. Original sources establish XP but not exact XP amounts for several tasks; those tasks use the approved, labelled PEQ-style default of 1,000 XP. No XP is invented for The Missing Caravan or the Crusade lead-in.

The native test runner’s high-damage gear, GM travel, private records and player data are not part of this package. Script parsing and disposable-database installation prove those specific checks; they do not prove historical encounter balance or every native quest route.

## Verified gameplay and limits

All 15 task completions and their criterion records were saved, along with all four children of the Sunderock aggregate. Each parent reward choice and each of the five awarded items was recorded once. The Rites parent correctly awards two rings. The Anaglass cycle offered its first task again without deleting prior completion history. See [native coverage](provenance/native-status.json).

Checks used native kills, actual corpse loot, ground pickup, exploration, hand-ins and reward windows. Private GM travel and high-damage equipment accelerated the checks; one scoped zone repop accelerated original respawns. These checks do not establish historical combat balance, natural respawn cadence, every class reward alternative, Windows execution or multiplayer acquisition races.

This is a working quest/objective/item-reward milestone with explicitly unfinished faction and raid-progression side effects. It is not a claim that all historical achievements or TSS raid access are complete. [Historical limitations](provenance/quest-decisions.json) distinguish recovered values from reconstruction and configurable server policies.
