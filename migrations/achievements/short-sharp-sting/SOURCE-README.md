# Short Sharp Sting — complete quest package

**Released milestone: all four quests completed in native RoF2.** The complete package was deployed with the matching container handler. Quest completions, item rewards and the eligible parent reward were checked across logout/login. Historical uncertainties and configurable emulator defaults remain labelled below.

This package restores these Hero’s Journey requirements:

| Quest | What the player does | Item reward |
|---|---|---|
| Buzz on the Bixies | Find the Prankster, defeat three copies, confront the original and report to Avellone | XP |
| The Festering Combs | Gather five honeycomb and deliver them to Avellone | Fertilizing Shovel |
| Jokes on You | Find the prisoners, loot a fresh clue and defeat the imposter | Ten potions **or** the disguise scroll |
| The Bixie Evolution | Open the journal, loot seven pages and assemble the book | Tome of Bixie Evolution |

The four quests provide **18 objectives**, four achievement bindings, the missing journal recipe and the parent achievement’s four armour reward options. The installer installs the complete package together. Existing NPC placements and weighted drops are retained. Confirmed mechanics and rewards, later corroboration, uncertain historical details and labelled XP defaults are distinguished in [family provenance](family-provenance.json) and [journal provenance](journal-provenance.json).

## Labelled faction defaults

The original sources establish bad bixie standing and kill-faction directions, but do not establish the exact May 2013 raw threshold or every kill amount. The approved emulator defaults are **Legion raw standing ≤ −1500**, **−1 Drones**, **−1 Legion**, and **+1 Crystalwing per supported kill**. From zero, the default Legion threshold takes 1500 ordinary kills before modifiers. These are configurable policy values, not recovered Live numbers.

The package adds kill routes to 26 existing NPC types in Moors/Stone Hive and to the quest copies. It changes only `npc_faction_id` on existing actors. Their combat stats, drops, spawns and existing group-zero aggro/assist behavior are preserved. The original Prankster keeps its existing no-hit faction group; the copies supply the documented hits. This is not a complete reconstruction of every faction assignment in the zones.

To choose different labelled values **before installing**, run (Windows: replace `python3` with `py -3`):

```sh
python3 configure_factions.py --maximum-raw-faction -1500 --drones-hit -1 --legion-hit -1 --crystalwing-hit 1
```

The tool regenerates the policy, SQL, row contract, reviewed gate, Lua settings and release manifest without connecting to a database. Do not edit generated SQL separately. Reconfiguring an already-installed server to different kill amounts requires a reviewed migration; the installer refuses conflicting existing rows. See [faction policy](faction-policy.json) and [route provenance](faction-routes.json).

## Before installation

Use the updated `rof2-achievements` engine, or the matching `rof2-integration` branch for a server using the combined features. Retain your existing server features and the complete earlier Stone Hive content foundation. Build and deploy the matching engine using your server’s normal build process. Its RoF2 container decoder and existing quest/task APIs are required; inspecting source files cannot prove an old running binary was replaced.

You need Python3.9 or newer, MariaDB, and its command-line client. Use a protected database options file instead of placing a password in the command. Keep your normal server backups. This installer additionally saves the **affected content rows and changed quest files**; that targeted backup is not a full database dump.

The installer’s default operation is a read-only preflight. It checks release hashes, engine source prerequisites, original NPC/item/placement/drop identities, existing reserved content and callback conflicts. It preserves the existing global callbacks by composing both required hook fragments. Custom scripts and alternative Lua/Perl callbacks require a reviewed merge.

## Linux

Run from this package directory. Change the example paths and database name:

```sh
python3 install.py --quests /srv/eqemu/quests --server-source /srv/EQEmu --mysql-command-json '["mariadb","--defaults-extra-file=/private/eq.cnf","--batch","--raw","--skip-column-names","peq"]'
```

Once the preflight and review are ready, disconnect players and **stop all game services while leaving MariaDB running**. Apply the same command with a new backup folder:

```sh
python3 install.py --quests /srv/eqemu/quests --server-source /srv/EQEmu --mysql-command-json '["mariadb","--defaults-extra-file=/private/eq.cnf","--batch","--raw","--skip-column-names","peq"]' --apply --backup /srv/eqemu-backups/short-sharp-sting-01
```

All five SQL files run in one transaction; the final activation is required. Do not import them individually. Repeating the installer with a new backup folder does not duplicate hooks or rewards. Known earlier script versions can be upgraded; unknown custom changes are refused.

## Native Windows servers

WSL and Docker are not required for a native Windows server. In PowerShell, use `py -3` and your MariaDB executable:

```powershell
py -3 install.py --quests C:/EQEmu/quests --server-source C:/src/EQEmu --mysql-command-json '["C:/MariaDB/bin/mariadb.exe","--defaults-extra-file=C:/private/eq.cnf","--batch","--raw","--skip-column-names","peq"]'
```

After stopping the Windows game executables, apply the identical command with:

```powershell
py -3 install.py --quests C:/EQEmu/quests --server-source C:/src/EQEmu --mysql-command-json '["C:/MariaDB/bin/mariadb.exe","--defaults-extra-file=C:/private/eq.cnf","--batch","--raw","--skip-column-names","peq"]' --apply --backup C:/EQEmu-backups/short-sharp-sting-01
```

Use a new backup folder each time. The installer uses native Windows process inspection and Python filesystem operations. **Native Windows execution has not yet been verified.** Linux installer checks do not establish MSVC build or Windows runtime acceptance.

## Akk-stack

Use the host quest directory mounted into the game container and the engine source used for the new binaries. Run from the stack directory so Docker Compose finds the intended stack:

```sh
python3 /path/to/package/install.py --quests /path/to/stack/server/quests --server-source /path/to/EQEmu --mysql-command-json '["docker","compose","exec","-T","mariadb","mariadb","--defaults-extra-file=/private/eq.cnf","--batch","--raw","--skip-column-names","peq"]'
```

Service names, mount paths and database names vary. After a successful preflight, stop the stack’s game service(s), retain MariaDB, and append `--apply --backup /path/to/backups/short-sharp-sting-01` to the same command. The backup directory belongs on the host outside the quest tree. Deploy the matching rebuilt engine, then restart all game services; a quest reload alone does not refresh every zone process’s task catalogue.

## Failure recovery and verification

On an ordinary SQL error, the content transaction rolls back and the installer restores the quest files it changed. If a connection is lost around COMMIT, it reads back the exact reserved rows before deciding whether the transaction committed. If that outcome cannot be determined, it leaves a receipt in the backup folder and tells you to keep services stopped. Do not restart game services into an unknown content/file state.

The installer does not write character, inventory, guild, housing, earned achievement or player-progress tables. Its process guard only inspects this server installation and never stops processes. Keep game services stopped until the installer finishes.

Offline installation, rollback and repeat-import checks passed. Native RoF2 checks covered all four quest completions, fresh loot credit, hand-ins, journal combination, reward selection, the faction gate and copy encounter, parent reward and relog persistence. Private QA used GM travel/combat gear, a summoned initial journal and per-instance appended drops on actors with existing acquisition routes. Database loot rates remained unchanged; natural farming time and historical balance are not established. The journal recipe uses `quest=0`, which the engine requires for normal output and TradeSkill task credit; the installer upgrades the exact known earlier `quest=1` row. Quest XP uses the approved, labelled1000XP PEQ-style defaults when the original amount is unknown; parent XP/AA/cash is not invented.

## Opcodes and structures

The repository includes the [RoF2 opcode and packet-structure reference](../../protocol/README.md). The journal-opening prerequisite uses original-client `OP_OpenContainer=0x06c8`, with a **12-byte inventory index payload**. Two original-client bag opens confirmed that layout. The decoded container handler, journal autoassignment, seven-page combine and resulting item reward passed native acceptance. No client files, private captures, tests or player data belong in the public package.
