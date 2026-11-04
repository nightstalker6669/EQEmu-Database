> **Current integrated fork:** use [the current branch installation guide](../../../../docs/rof2/INSTALL.md). This document preserves the original release’s source baseline and evidence. Its source patches are already integrated and must not be reapplied here.

# Installation

## Reproduce the source baseline

Requires Git, Python 3.9 or newer and the normal upstream EQEmu CMake build environment. Use LF checkouts and separate package directories:

```sh
git -c core.autocrlf=false clone https://github.com/EQEmu/EQEmu.git EQEmu
git -C EQEmu checkout --detach 8175ae61874cbf20d7b05102821f6f8a4f4d1c39
git -c core.autocrlf=false clone https://github.com/nightstalker6669/eqemu-rof2-housing.git housing
git -C housing checkout --detach 9aad4cc0857bdd14677dd45ab24f3eafe20d489b
git -c core.autocrlf=false clone https://github.com/nightstalker6669/eqemu-rof2-fellowship.git fellowship
git -C fellowship checkout --detach 9382453264f4f84ac7e83a9ee5c9c9a1391c6017
git -c core.autocrlf=false clone https://github.com/nightstalker6669/eqemu-rof2-mercenaries.git mercenaries
python3 housing/tools/apply_overlay.py EQEmu --check
python3 housing/tools/apply_overlay.py EQEmu --apply
python3 fellowship/tools/apply_overlay.py EQEmu --check
python3 fellowship/tools/apply_overlay.py EQEmu --apply
python3 mercenaries/tools/apply_overlay.py EQEmu --check
python3 mercenaries/tools/apply_overlay.py EQEmu --apply
```

Keep upstream HEAD unchanged between these steps. The installer expects the exact uncommitted housing + fellowship overlays, checks all prerequisite modified/new paths and hashes, validates package files, checks the integration patch and rejects existing new-file destinations. It will refuse a different companion revision or unrelated source changes. For a customized server, reconstruct this baseline separately and manually review integration into your branch rather than bypassing failures.

Housing supplies shared authenticated inventory admission and pending-operation schemas/APIs. Fellowship supplies the published combined-source baseline and DBcore stable-connection-storage fix. Install their documented schemas and setup first, including session admission; mercenary saves and dismissal need these guards even when charging is disabled. Read both companion installation guides. No companion source or personal server configuration is bundled here.

## Content, schema and activation

Back up databases and installed binaries/configuration first. The existing upstream `utils/sql/merc_tables_bootstrap.sql` is the pinned optional standard catalogue (SHA-256 `18106ea9cb70bd933a2e3ac57dac015c5c140b3c95a219e604bb7cb2bc04efd1`). It is already present in upstream, so this package does not duplicate it. It contains destructive DROP statements including owned rows/buffs: do not import it wholesale over an established mercenary installation. Review and supply missing tables/content instead. The ordinary upstream `world mercs:enable` downloads content; inspect its source/version before relying on it for a pinned installation.

Once standard catalogue tables and shared infrastructure exist:

1. Run `utils/sql/mercenary/001_owned_roster.sql` against the character database. Duplicate owner/slot pairs fail migration and require explicit operator resolution; no contracts are silently discarded.
2. Run `003_passive_upkeep.sql` against the character database.
3. Run `004_zone_permissions.sql` against the content database. It adds `zone.allow_mercs`, default allowed; choose actual restricted zone/version rows explicitly. Reload static zone data or restart zones after edits.
4. Review `002_enable_rof2.sql`, select the actual ruleset and apply its rule updates to the character database. With split databases, its separate catalogue-linked `npc_types`/`merc_merchant_entries` update belongs in the content database: do not run the whole activation file against either database alone.

The activation selects AllowMercs=true, capacity3 and level fallback, and updates only suitably titled, catalogue-linked liaisons to class71. A class71 NPC without matching catalogue joins cannot provide offers. Existing purchase/upkeep price flags default false and remain independent; select your intended policy explicitly. Do not alter unrelated expansion masks just to expose mercenaries. See [GAMEPLAY.md](GAMEPLAY.md) for all rules, expected catalogue counts, pricing, resources and level/spell fallback.

## Build and deploy

Build both world and zone in the normal configured upstream environment, for example:

```sh
cmake --build /path/to/configured-build --target world zone -j2
```

Stop the server through its supervisor, preserve the prior binaries and active mapping file, deploy the matching world/zone binaries and mercenary mappings from `utils/patches/patch_RoF2.conf`, then restart through the supervisor. Do not replace independently supervised children. Canonical opcodes and client-facing layouts must come from the same build. A rule reload alone does not populate missing loaded catalogue/stance/spell maps.

Use the matching May10 2013 RoF2 client (SHA-256 in the protocol reference); client assets are not supplied. Confirm liaison catalogue, initial hire/stance and group HP; switching, suspension, upkeep and relog persistence under your operator policy. Follow the companion guides for ordinary deployment and shared-session schema requirements.

## Rollback

Use the preserved source/binary/configuration baseline and stop new logins before rollback. Preserve current contracts, buffs, currencies and backups; restoring only old executables does not reverse committed gameplay transactions. The additive migrations should not be automatically dropped: existing owned rows and passive elapsed values are durable data. Review data compatibility before any schema reversal. Installation tooling never edits databases, configures services or starts processes.
