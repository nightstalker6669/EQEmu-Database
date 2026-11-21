# Depths of Darkhollow progression database

This release extends the published Darkhollow Normal database. Use the matching server and quest overlay in SOURCE-MANIFEST.json.

## Fresh installation

Import full.sql into an empty MariaDB 10.11 database with a DELIMITER-aware client. It replaces tables.

## Existing Darkhollow Normal database

Use the separate player-preserving upgrade and follow its UPGRADE-CONTRACT.json. Back up the volume, stop World, Zones and other database writers, and finish any active Frustrated Functionary journal before applying. Run the ordered preimage verification, additive schema, content transaction and readback. Keep all accounts, characters, items, task archives and earned claims. If a stage stops on a mismatch, check the matched baseline and which schema statements completed before proceeding.

Use the matched runtime and rebuild item and spell shared memory with `shared_memory items spells` before boot. The client append records inherited from Darkhollow Normal still apply to the supported original client baseline.
