# Steppes achievement quests (RoF2)

This package contains the 13 original Steppes quest routes, their three Hero's Journey achievement definitions, NPC/ground-item content, encounter scripts and rewards. Historical scope ends May 31, 2013. Sources and approved emulator defaults are separated in `provenance/`.

**Verified quest milestone:** all thirteen routes and all three parent reward paths passed native completion and reward checks. The crypt also passed three-player admission, native removal/rejoin and a completed-member reconnect. Native Gnoll late-join boundaries, the recurring supply pickup issue and Windows installer execution remain open. See `provenance/native-status.json` for verified coverage and known limitations. A successful import is not gameplay verification.

## What installs

- Every SQL file, including task/achievement activation and the researched Gnoll late-join policy.
- Seven Lua modules, eight giver callback additions, and global player/NPC hooks.
- Real native task objectives, loot, hand-ins and rewards; scene scripts supply the encounter-specific behavior.
- No accounts, player progress, housing data, test weapons, client assets or packet captures.

The matching engine changes are required: shared reward occurrence identity, strict admission/completion persistence, extended item-cast events, Lua scene APIs and recurring ground-item terrain height. Build and deploy this feature branch's engine before starting players on the imported content. A database schema check cannot establish which executable is running.

Earlier achievement content must already supply `achievement_quest_mesa_inventory`, `achievement_quest_blightfire` and `json`. Existing giver/global callbacks are retained. The installer stops for conflicting alternate scripts or modified managed modules.

## Install

Use Python 3 and MariaDB command-line clients. Run from this directory. Credentials belong in a private MariaDB option file or environment-backed wrapper, not in the command array or shell history.

First run a read-only check, substituting your paths and database:

```sh
python3 install.py \
  --quests /srv/eqemu/quests \
  --mysql-command-json '["mariadb","--defaults-extra-file=/secure/eqemu.cnf","peq"]'
```

Stop all game/content writers, take your normal server backup, and deploy the matching built engine. Then install the complete package:

```sh
python3 install.py \
  --quests /srv/eqemu/quests \
  --mysql-command-json '["mariadb","--defaults-extra-file=/secure/eqemu.cnf","peq"]' \
  --dump-command-json '["mariadb-dump","--defaults-extra-file=/secure/eqemu.cnf","peq"]' \
  --backup /secure/backups/steppes-new-directory \
  --services-stopped --matching-engine-installed --apply
```

The backup directory must be new and outside every quest root. The installer makes a **full private database dump**, backs up changed callbacks, then imports all content and activation. Never publish this backup. It does not stop, start or restart services.

Pass each additional configured quest root as `--additional-quests /path` so shadowing scripts are checked. Resolve reported custom-script conflicts deliberately; do not bypass guards or use MariaDB `--force`.

For akk-stack, use a wrapper around your stack's MariaDB container as the command-array executable and point `--quests` at the host's mounted quest directory. The wrapper must forward extra arguments and standard input unchanged. Do not copy this machine's private runtime paths or credentials.

The Python tools use portable filesystem/subprocess APIs. Native Windows can supply `mariadb.exe`, `mariadb-dump.exe` and a Windows quest path in the JSON arrays; quote backslashes as JSON requires. Native Windows execution of this Steppes installer has not yet been verified. Use the branch's native Windows engine build instructions, rather than a Linux executable.

## Recovery and verification

On any SQL error, keep writers stopped. MariaDB DDL is not transactional: restore `database-before.sql` into the same database and restore changed quest paths from the `quests/` backup before retrying. `installation.json` identifies the reached phase. Do not resume a partial import blindly.

On success, start the matching engine and verify quest selection, objectives, completion, achievement credit and rewards on your server. Existing IDs/content drift is guarded; custom deployments can require a reviewed merge.

No new wire opcode is claimed by this content package. The feature branch retains its achievement opcode mappings and packet structures in the protocol documentation and `common/patches`/common structure definitions. Shared-task and item-cast fixes use those existing protocol paths.

## Sources and defaults

`quests.json` and `catalogue.json` record quest/catalogue provenance. `historical-levels-xp.json`, `defaults.json`, `defaults-sources.json` and `effective-scene-settings.json` identify best-supported historical levels and approved configurable defaults for unavailable XP/combat/placement data. Confirmed values take precedence. The adjacent portal-repair/raid continuation is separate from these achievements and remains disabled.
