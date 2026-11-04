> **Current integrated fork:** use [the current branch installation guide](../../../../docs/rof2/INSTALL.md). This document preserves the original release’s source baseline and evidence. Its source patches are already integrated and must not be reapplied here.

# Installation

## Exact source dependencies

Requires Git, Python3.9 or newer (the installer uses `Path.is_relative_to`), and the normal upstream EQEmu build environment. Runtime requires the matching May 10, 2013 RoF2 client and reviewed PEQ item/spell content.

This version depends on the housing inventory/session implementation. It does **not** apply directly to stock EQEmu, and does not bundle the companion housing implementation. Housing itself has content/setup requirements; read its installation guide. The fellowship patch adds only fellowship changes and the DBcore stable-connection-storage fix required for safe reconnect behavior.

Use separate clean source directories, with LF checkout enabled:

```sh
git -c core.autocrlf=false clone https://github.com/EQEmu/EQEmu.git EQEmu
git -C EQEmu checkout --detach 8175ae61874cbf20d7b05102821f6f8a4f4d1c39
git -c core.autocrlf=false clone https://github.com/nightstalker6669/eqemu-rof2-housing.git housing
git -C housing checkout --detach 9aad4cc0857bdd14677dd45ab24f3eafe20d489b
git -c core.autocrlf=false clone https://github.com/nightstalker6669/eqemu-rof2-fellowship.git fellowship
python3 housing/tools/apply_overlay.py EQEmu --check
python3 housing/tools/apply_overlay.py EQEmu --apply
python3 fellowship/tools/apply_overlay.py EQEmu --check
python3 fellowship/tools/apply_overlay.py EQEmu --apply
```

Do not commit the housing overlay inside EQEmu between these steps: the fellowship installer expects upstream HEAD plus the exact uncommitted housing overlay. It validates all 506 prerequisite modified/new source paths, all package checksums, absent new fellowship destinations, and `git apply --check`. It refuses unrelated changes or another housing revision. It writes sources only, without running SQL, changing configuration, building, copying quests or restarting services. Keep an untouched source checkout and database backup for recovery.

For an existing customized server, use a separate exact-baseline checkout to review the patch and manually integrate against your own branch. Do not bypass checksum failures and assume compatibility.

## Database

Review and provision the pinned housing schemas and inventory admission infrastructure first. Its current inventory/session, custody, coin-pending and house-transition tables are prerequisites for paid campsite creation. Disabling housing is not a substitute for providing those tables and runtime session hooks.

Apply to the **character database** in order with a database client configured through your own secure credentials:

1. `overlay/utils/sql/fellowship/001_fellowships.sql`
2. `overlay/utils/sql/fellowship/002_vitality.sql`
3. `overlay/utils/sql/fellowship/003_xp_commits.sql`
4. `overlay/utils/sql/fellowship/004_campsite_catalogue.sql`

The first three use additive `CREATE TABLE IF NOT EXISTS`; the catalogue upserts597 policy definitions. They do not import accounts, characters, inventory, NPCs or merchant data. Re-running an upsert can replace catalogue metadata; review local customizations first. Existing incompatible table definitions are not repaired by `IF NOT EXISTS`.

Inventory, character, fellowship and journal tables participating in transactions must be InnoDB on the same database server. Configure the normal EQEmu database connection. The code creates dedicated connections using that configuration; no public credentials are provided. Membership and XP share a single `fellowship_guard` row. Missing/incomplete schema or uncertain commit outcomes fail closed. See [DATABASE.md](DATABASE.md).

The SQL catalogue mirrors compiled definitions in `common/fellowship/campsite_catalogue_data.inc`; editing SQL alone does not change gameplay recipes. Update and validate both when customizing.

## Content and client requirements

Use opcode mappings from the patched `utils/patches/patch_RoF2.conf` in the running server's active RoF2 mapping file; copying sources does not update an installed runtime mapping. The six fellowship mappings are documented in [OPCODES.md](../protocol/OPCODES.md). Existing channel-message, spawn, buff and travel protocols remain in use.

The compiled catalogue records exact kit and lumber item IDs. Each paid recipe needs one stackable itemtype58 kit and one lumber bundle. The complete recipe mapping is in the catalogue and SQL. Existing PoK suppliers in the development content supplied all 149 unique materials; this package does not guarantee every PEQ database has those merchant lists. Verify your own material items and vendors without importing the development database.

Fellowship Registration Insignia is item 34023; its click invokes spell 7618. `TryFellowshipCalling` handles the authenticated self-cast and applies normal destination admission checks. Item data retains the native15-minute cooldown. No new spell IDs are invented.

Numeric/melee camps require exact matching Standard spells7354–7371 and7607–7615. Support spells are7616/7617; appearance templates are7372–7399 and7601–7606. Complete numeric/melee template signatures are validated before use. Mismatched content makes those recipes unavailable rather than silently applying guessed bonuses. The operator supplies lawful matching spell/client data; no client spell archive is bundled.

Copy `quests/poknowledge/Randall_of_the_Fellows.lua` into your quest tree after reviewing any existing script. It supplies help and a replacement insignia. Use the existing matching NPC entry; no spawned verification NPC or account is included.

## Build and deploy

Build both world and zone through the normal upstream CMake configuration. The patch registers production common/zone sources; it adds no test runner. Use your existing supported build dependencies and feature flags, for example `cmake --build /path/to/configured-build --target world zone -j2`.

Stop the server through its normal supervisor, back up installed binaries/opcode mappings/quest script, deploy matching world+zone binaries and mappings, then restart through that supervisor. Do not replace supervised processes independently. Apply schemas before allowing character deletion or fellowship use; deletion cleanup deliberately fails closed if required fellowship cleanup cannot complete.

Verify native create/invite/MOTD/chat, a free camp with three nearby members, a representative paid recipe and exact material decrement, its effect disappearing out of range or on expiry, insignia travel, XP sharing/redemption and relog persistence. Native UI is RoF2-only; other clients receive a fellowship chat text fallback, not a new fellowship window.

## Rollback

Stop admission before changing versions. Retain database backups and durable fellowship/XP data; reverting binaries does not undo committed XP or material debits. Restore the matching pre-install binaries, opcode mappings and quest version together. To discard only a source installation, use a separate fresh checkout and repeat the pinned housing setup. The installer has no destructive rollback or schema-drop mode. Never blindly replay an uncertain award or debit.
