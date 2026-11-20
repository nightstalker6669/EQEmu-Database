# Depths of Darkhollow Normal database

This release includes 17 restored Normal quests, earned Dreadspire Keep entry, and the level 68, 69 and 70 class rewards. Brovil and Jarzarrad completions advance their Rakban details. The skull requirement remains in place.

Fall of Illsalin includes reconstructed shroud stats, loadouts, combat values, local recovery and XP tuning. The native qualification records directed RoF2 development play and identifies the verified outcomes.

## Install on a fresh empty database

Import `full.sql` into an empty MariaDB 10.11 database with a DELIMITER-aware client. It is a complete seed that replaces tables. Use the matched server, quest, opcode and RoF2 client inputs identified by the source manifest.

## Upgrade a Rathe r2 player volume

Back up the database and stop World, Zones and other database writers. Complete any active ordinary shroud return with the existing runtime before swapping server files. The four shroud escrow tables must match their legacy layouts and be empty, with no active shrouds. Preserve any unreconciled escrow and pause for recovery if those checks fail.

Apply the ordered definition and schema changes from the upgrade package using its checksum manifest. The Rathe r2 path first applies and verifies the level 69 baseline. The matching existing level 69 path starts after its independent verification. Keep the existing accounts, characters, inventory, archives and claims. Each DDL statement commits separately. Stop on any mismatch and inspect the resulting schema before taking further action.

## Server and RoF2 assets

Use the matching Zone shroud storage projections and client opcode asset. The runtime opcode file is `server/assets/patches/patch_RoF2.conf`. Rebuild both target datasets by running `shared_memory items spells` from the matching server directory and configuration against the upgraded database while World and Zones are stopped. Use the rebuilt item and spell files and verify the running processes map them after boot. Check item IDs 900100–900105 and spell IDs 42700–42702. Zone startup loads the matching AA and task data.

Append the three spell records and 15 display-string records to their matching RoF2 base files before launching the client. The upgrade contract pins both base hashes and both append payloads. Keep a rollback copy of each original client file.
