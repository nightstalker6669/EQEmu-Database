# PEQ RoF2 Deathknell Tower database

This matched seed adds the four encounters and their chest loot to owned Deathknell expeditions. Use the matching server build and canonical quests pinned in SOURCE-CONTENT-BINDING.json. NATIVE-QUALIFICATIONS.json describes test coverage and its limits.

Import full.sql into a fresh empty database with MariaDB 10.11. It includes the published r32 seed and the Tower catalog in order. Existing volumes and in-place upgrades are outside this package. Use a matching runtime configuration with Prophecy of Ro content enabled.

The seed contains the static catalog. Players, login records, live expeditions, temporary QA helpers and test state are excluded.
