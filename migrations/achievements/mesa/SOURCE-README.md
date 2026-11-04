# Goru`kar Mesa: quests, pranks and research

This package adds **19 playable quests and 19 achievement bindings**, with NPC scripts, original resource interactions, confirmed rewards and saved progression. All nineteen enabled quests completed in native RoF2 gameplay. Their progress, the completed Pranks achievement and claimed rewards survived a real client exit and fresh login.

It defines one additional quest, **Minohten are a menace!**, but keeps that capture/rescue scene disabled. Its original holding position, blindness spell and physical containment are unresolved. **Welcome to the Mesa therefore remains incomplete**; the package does not grant its missing component or invent its head reward.

| Quest giver | Enabled quests | What works |
|---|---:|---|
| Costica | 3 | Minohten camp exploration, mushroom-sack theft, tents and scouts |
| Sorin | 3 | Tuffein food, weapon racks, Moors rock collection and food replacement |
| Devan | 4 | Fruit, vegetables and beer; wildlife; fresh supplies; nymphs |
| Iulia | 2 | Burning stick, moving bush and actual Napaea wing drops |
| Nedelcu | 2 | Lake-stone pickup, moving rock and actual Oread hair drops |
| Scout Madu | 5 | Research, sequential hostile parlay, cross-zone pollen quest, dust wand, diplomacy and Bigone |

Original NPC placements and weighted loot tables are retained. The tent uses the client's five-stage **DEST_TNT_G** resource; a static tent model cannot safely handle damage. The beer source is the original brewing-barrel world object, preserving its crafting behavior. Missing edible supply items can be recollected while delivery is pending without repeating acquisition credit.

## Install the complete package

Install the repository's [engine/schema foundation](../../ENGINE.md), including **patches 0001 through 0009**, and the Crescent, Bixie and Stone Hive packages first. Patch0009 fixes global task reloads skipping idle zone processes. For an existing eight-patch installation, the new engine change requires rebuilding `world`; the quest changes are Lua/Perl and SQL.

1. Build the required engine update. Back up the database and quest directory. Disconnect players and **stop all game services, leaving MariaDB running**. Keep players disconnected until the complete upgrade succeeds.
2. From this folder, run both preflights with Python 3 and a protected MariaDB options file:

   ```sh
   python3 preflight.py --mysql-command-json '["mariadb","--defaults-extra-file=/private/eq.cnf","peq"]'
   python3 apply_quests.py --quests /path/to/quests
   ```

   Substitute your actual database and paths. The checks identify incompatible content before installation; merge custom scripts rather than removing the guards.
3. Import **all four SQL files**, in this order, into the same database:

   | Order | File | Purpose |
   |---|---|---|
   | 1 | `sql/010-catalogue.sql` | Two achievement definitions, categories and components |
   | 2 | `sql/020-quests.sql` | Twenty definitions, nineteen enabled tasks, 83 activities and bindings |
   | 3 | `sql/030-scenes.sql` | Existing tent-model correction and lake-stone pickup |
   | 4 | `sql/040-parent-rewards.sql` | Confirmed quest and Pranks reward configuration |

   Use your SQL client's file-import facility and stop on the first error. The disabled capture definition is required catalogue data, not an optional install step.
4. Install the entire script set with a **new backup folder outside the quest tree**:

   ```sh
   python3 apply_quests.py --quests /path/to/quests --apply --backup /path/to/backups/mesa
   ```

5. Deploy the patched engine, restart **all** game services, then reconnect. This refreshes every zone process. After future task edits, patched global task reloads also refresh idle processes.

The installer verifies release hashes, preserves known earlier NPC scripts and lower-priority Hemfar callbacks, and chains existing global player/NPC handlers. It refuses unknown conflicting scripts. SQL contains no character, inventory, guild or housing table data. No client files need changing.

### Native Windows servers

Use native Windows server executables, Python 3 and your MariaDB client; WSL is not required:

```powershell
py -3 preflight.py --mysql-command-json '["C:/MariaDB/bin/mariadb.exe","--defaults-extra-file=C:/private/eq.cnf","peq"]'
py -3 apply_quests.py --quests C:/EQEmu/server/quests
py -3 apply_quests.py --quests C:/EQEmu/server/quests --apply --backup C:/EQEmu/backups/mesa
```

Import the same four SQL files before installing the scripts. Build the engine with your native Windows workflow and restart all game services. Native Windows execution has not been performed for this release.

### Akk-stack

Use the stack's normal source/build workflow for the engine update. While game services are stopped and MariaDB remains available, run the database check from the stack directory, for example:

```sh
python3 /path/to/mesa/preflight.py --mysql-command-json '["docker","compose","exec","-T","mariadb","mariadb","--defaults-extra-file=/private/eq.cnf","peq"]'
```

The options-file path must exist inside the database container. Import the same four SQL files. Run `apply_quests.py` against the **host directory mounted as the server's active quest directory**, using a host backup directory. Adjust service/database names and restart all game services after deploying the engine and complete content.

## Fidelity and remaining work

The [quest specification](provenance/quest-specification.json) and [research decisions](provenance/research-decisions.json) record historical sources and conflicts. The cutoff is **May 31, 2013**. Quest XP uses the explicitly approved **1,000 XP configurable PEQ-style default** where original amounts are unknown. Proximity sizes, object relocation anchors and the short dust calm duration include labelled reconstructions; see [scene data](provenance/scene-data.json).

Pranks includes researched class-filtered rewards for fifteen classes. Original Berserker handling and Welcome's exact head variants remain unconfigured. Madu's complete five-quest cycle must be repeated for another Scout Stone; the native first-cycle completion and restart offer were verified. [Native verification status](provenance/native-status.json) separates gameplay, offline checks, installation and remaining limits.

## Opcodes and structures are included

The repository's [achievement/reward protocol reference](../../protocol/README.md) includes the twelve mappings and packet layouts. This package also documents its [world-object and door packets](PROTOCOL.md). These are existing mappings; Mesa introduces no new opcode value or packet layout.

Public files exclude tests, captures, logs, private character/account fixtures and client assets.
