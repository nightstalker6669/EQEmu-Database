# Hemmet's original TSS Ranger stock

Hemmet, Master Sureshot already exists as NPC399084 in The Steppes with an existing placement, but his merchant binding points at shared placeholder999999. This repair gives that same NPC a dedicated merchant399084 containing the fifteen original items listed in a [December16,2006 merchant chat log](https://everquest.allakhazam.com/db/npc/22418#msg1166280414165521327). It creates no NPC, spawn, substitute vendor, spell, item, or quest. The shared placeholder and all its consumers remain untouched.

All fifteen scroll/tome definitions already exist and map to rank I Ranger spells at levels71–75. Original spell names in the period log match the current database, including Potameid Salve and Cloud of Wasps; modern Allakhazam display aliases Potamide Salve/Wasp Swarm do not justify changing IDs or spell names. This package changes only fifteen merchant rows and this NPC's merchant_id. Learning levels remain in spells_new; zero item scrolllevel fields are not automatically rewritten into guessed item metadata.

Prices retain the existing positive item base prices and native merchant charisma/faction calculation. They are an implementation baseline, not proof of exact May2013 prices. A June5,2013 reprice log is later than the target boundary and is not silently treated as original. No global item price changes are made. Standard merchant purchase defaults are explicit: no invented language, class-purchase, progression, or level-purchase restriction. The item and spell still control which class can learn each spell.

The source lives outside manifest.stages. `python3 apply_database.py` prints an offline plan. Manual coordinated apply requires PyMySQL, a private EQEmu config, and a fresh private receipt directory:

```sh
python3 apply_database.py --apply --config /private/eqemu_config.json --receipt-dir /private/hemmet-restoration
```

The helper requires peq_housing_test, exact full NPC preimage, unchanged native item/spell identities and Ranger levels, positive prices, transactional storage, and no rows or consumers of reserved merchant399084. It saves a durable NPC/empty-stock backup, inserts fifteen rows, changes the one binding in a transaction, and verifies full postimages before commit. It never writes merchant999999 or player rows. A prepared-only receipt must be reconciled against actual rows before further action. Reversal must refuse changed NPC/stock rows or new merchant consumers; do not restore player property.

After publication and commit, coordinate fresh affected NPC/merchant-cache availability for The Steppes399. Preserve existing placements and other owners' encounters; no global repop, broad installer, client takeover, or new test suite is needed. Native purchase acceptance remains separate from database/cache proof.

## Applied status, November4,2026

The fifteen stock rows and one NPC binding are committed. Full postimages and an independent item/spell/Ranger-level join passed. Build confirmed TheSteppes399 is not loaded and its next ordinary zone initialization will read the new NPC binding and merchant stock. No extra restart/repop or native purchase was performed. Shared999999 and other NPCs, item/spell definitions, placements and player state remain unchanged. Exact historical price parity is still not claimed.
