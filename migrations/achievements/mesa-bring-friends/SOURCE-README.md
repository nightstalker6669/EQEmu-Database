# Bring Friends — Goru`kar Mesa

This package reconstructs **A Bad Dream**, **Oh No!**, **Stand With Us**, and **They are Coming!**, with their four achievement requirements. It includes the NPC scripts, three scripted encounters, native objectives and confirmed Windwillow necklace/bauble rewards.

**Status: source candidate, not installed or verified in game.** Historical sources and labelled configurable estimates are in `provenance/`. This is content using the achievement branch's existing protocol; it adds no new opcode or packet structure. See the branch's protocol documentation for those definitions.

## What happens in game

* Hanook's three tasks investigate the Tuffein, confront Glasson and defend the Windwillow. Follow the dialogue links in order.
* Existing Tuffein creatures retain their original database Trinket drops. Five real loot events and five real deliveries are required; merely having items in inventory cannot finish the loot objective.
* Glasson and five guards appear once per shared-task identity. Orders can drop on Glasson or his guards, without a guaranteed drop. Restart the shared task if needed.
* The tree defense sends three waves of three attackers. Original friendly defenders can kill them; player kill credit is not mandatory. Attackers reaching the tree fail the defense.
* Peretaenu's raiders approach from the lowlands. Killing the captain is sufficient. Remaining raiders continue moving and fighting; the captain can escape if ignored.
* Native task completion supplies XP, item rewards, achievement credit and persistence. No script bypasses completion or grants objectives from an elapsed timer alone.

## Install the whole package

Use the matching `rof2-achievements` engine and its existing Roost/Mesa content. Preserve your database and quest backups. Install while the affected zone is unoccupied or game services are stopped, then restart services for a complete fresh installation. The installer does not stop or start services.

Run Python 3's `install.py` with:

* `--quests`: your server's quest folder.
* `--mysql-command-json`: a JSON array for your MariaDB/MySQL client, including connection options and database name. It must read SQL from standard input.
* `--dump-command-json`: the corresponding dump command, with connection options and database name. The installer appends the affected table and filter.
* `--backup`: a **new** backup directory outside the quest folder.
* `--apply`: install all required database and script components.

Without `--apply`, the installer checks affected script compatibility without writing. With it, the installer backs up only affected content rows and replaced scripts, runs both required SQL migrations, installs the full script manifest and records its result. Do not cherry-pick individual files. Existing custom NPC or controller scripts require composition if their bytes differ from the reviewed baseline; the installer stops instead of overwriting them.

Linux and Akk-stack users should point the JSON commands at their database client (inside their database container when appropriate). Native Windows users can run `py -3 install.py`; JSON command arrays support full paths to `mariadb.exe`/`mariadb-dump.exe`, including paths containing spaces. Use a database client option file for credentials rather than putting a password in shared commands. Windows runtime execution has not yet been verified.

For rollback, first stop the affected runtime and restore backed-up quest files. Run `040-disable-bring-friends.sql`, then `020-rollback-staged.sql`. Rollback refuses altered content or live task/spawn references and never deletes earned player records. If an installation stops partway, inspect its saved error and backup before recovery; do not retry blindly.

## Fidelity and configurable values

Confirmed mechanics and rewards are separated from estimates. Original HP, several spawn/trigger coordinates, wave timing and Orders percentages were not recovered. Their defaults are explicit in `provenance/encounter-defaults.json` and `provenance/npc-profiles.json`. Navigation-surface placement is evidence of terrain support, **not** proof of a traversable full route or an original Live coordinate. Shared tasks use a labelled six-hour duration inferred from period timer reports and later explicit values. Unknown original XP uses the approved 1,000-XP configurable PEQ-style default. Unverified faction award amounts are omitted.
