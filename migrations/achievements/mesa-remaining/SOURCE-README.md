# Goru`kar Mesa: armor, gifts and living encounters

This extends the earlier Mesa package with **36 quests, 277 activities, 27 recipes and 36 achievement bindings across four additional historical achievement definitions**. It includes Moving Up the Ranks armor, Madu's armor materials, Marilena's hunts, Tudor's drinks, Ciodaru and Kathryn's gift/defense chain, and Dorina and Simu's gifts/escort. Four researched parent achievement reward sets add ten class-filtered armor choices.

**[Quest/reward provenance](provenance/)** · **[Runtime coverage and limits](provenance/native-status.json)** · **[Achievement opcodes and packet structures](../../protocol/README.md)**

The cutoff is **May 31, 2013**. This is server content for the existing achievement/task/reward protocol. It introduces no new opcode value or packet structure.

## Install the whole extension

Use this branch's already integrated achievement engine and schema. Do not reapply the archived engine patches. Install its required earlier content packages, including `mesa`, first. Keep a full database/quest backup, disconnect players and stop game services; leave MariaDB running until installation finishes.

Python3 and the MariaDB client/dump utilities work with native Linux, native Windows and Akk-stack. The installer checks the release and quest conflicts, backs up affected content tables and quest files, imports **every SQL file in one client session**, and installs every script and callback hook. The default invocation checks only; adding `--apply` performs the complete upgrade.

### Linux

Use a protected MariaDB options file rather than putting a password on the command line. Replace all example paths and the database name:

```sh
python3 install.py \
  --mysql-command-json '["mariadb","--defaults-extra-file=/private/eq.cnf","peq"]' \
  --quests /path/to/server/quests

python3 install.py \
  --mysql-command-json '["mariadb","--defaults-extra-file=/private/eq.cnf","peq"]' \
  --dump-command-json '["mariadb-dump","--defaults-extra-file=/private/eq.cnf","peq"]' \
  --quests /path/to/server/quests \
  --backup /path/to/backups/mesa-complete --apply
```

### Native Windows

Use native Windows server executables and Python3; the commands do not require WSL. Run from this package directory in PowerShell:

```powershell
py -3 install.py --mysql-command-json '["C:/MariaDB/bin/mariadb.exe","--defaults-extra-file=C:/private/eq.cnf","peq"]' --quests C:/EQEmu/server/quests

py -3 install.py --mysql-command-json '["C:/MariaDB/bin/mariadb.exe","--defaults-extra-file=C:/private/eq.cnf","peq"]' --dump-command-json '["C:/MariaDB/bin/mariadb-dump.exe","--defaults-extra-file=C:/private/eq.cnf","peq"]' --quests C:/EQEmu/server/quests --backup C:/EQEmu/backups/mesa-complete --apply
```

Native Windows execution has not been performed for this content release.

### Akk-stack

Run the installer on the host and target the host quest directory mounted into the server. Set both command arrays to your stack's database service, for example:

```sh
python3 install.py \
  --mysql-command-json '["docker","compose","exec","-T","mariadb","mariadb","--defaults-extra-file=/private/eq.cnf","peq"]' \
  --dump-command-json '["docker","compose","exec","-T","mariadb","mariadb-dump","--defaults-extra-file=/private/eq.cnf","peq"]' \
  --quests /host/path/to/server/quests \
  --backup /host/path/to/backups/mesa-complete --apply
```

Run from the stack directory using an absolute path to `install.py`, so Docker Compose finds its configuration. The options file must be accessible inside the database container. Change the service/database names to match your installation.

After a successful installation, deploy the matching server build and restart **all game services** before reconnecting players. The installer does not control running processes. If any guarded SQL or script check fails, keep players disconnected and resolve the conflict or restore the backup before retrying. It never silently overwrites unknown custom scripts.

## Reconstructed values are explicit

- Quest XP defaults to the user-approved configurable **1,000XP** where the historical amount is unknown. No unknown cash/AA/faction award is invented.
- Original Fantoma mechanics and appearance are researched; exact historical probabilities remain unrecovered. The default rare replacement is **2%** on each of 21 original wolf pools, with a **100% pelt** and **50/50 gear selection**. These are configurable emulator defaults, not recovered Live rates. Original spawn locations, grids and timers remain intact. Fantoma is not guaranteed by accepting a quest.
- Missing scene combat values, proc chance, timing/range tolerances and Simu's walking route use documented configurable reconstructions. Confirmed mechanics include ordered thug/grabber kills, a real retry, delayed waves, the actual final corpse note, and a living escort with an ambush.
- The original scaling earring is preserved and grows with quest completion. Researched endpoints and the first researched/inferred increment are distinguished from approved intermediate percentage defaults.

Read [scene settings](provenance/scene-settings.json), [Fantoma settings](provenance/fantoma-settings.json), and the quest specifications before changing values. Initial SQL session overrides must be set before their corresponding SQL file; changing an already installed profile requires a reviewed migration because ownership guards deliberately reject drift.

No account, character, inventory, guild ownership or housing data is included. Public files exclude private fixtures, logs, captures, client assets and test programs. Earlier unresolved Mesa capture mechanics and unconfirmed Welcome/Pranks reward variants remain documented in the preceding `mesa` package; this extension does not claim those gaps are complete.
