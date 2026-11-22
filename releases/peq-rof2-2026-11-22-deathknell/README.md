# PEQ RoF2 Deathknell database

This fresh-install seed includes the native-tested earned Deathknell route through entry to the owned Tower of Deathknell. Pair it with the matching server build and canonical quests pinned in SOURCE-CONTENT-BINDING.json. The scope and test limits are recorded in NATIVE-QUALIFICATIONS.json.

Import full.sql into a fresh empty database with MariaDB 10.11. The file already includes all seven Deathknell catalog inputs. Existing database volumes and in-place upgrades are outside this release. The seed contains empty player, login, encounter-state and raid-credit tables.

The matching runtime configuration must enable Prophecy of Ro content. The seed retains the published base expansion setting. Inherited documents and migration files are included for provenance.
