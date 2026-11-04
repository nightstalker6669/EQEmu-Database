# Cragbeak spell-mote provider reconstruction

This restores a usable Cragbeak encounter and a natural Dreadmote drop route on the existing NPC752234 in Shard's Landing. It retains the existing NPC/spawn identity and locations and uses native Echoing Screech33544. It adds no vendor, custom spell, extra spawn, Iremaw behavior, player grant, or task reward. It is a labelled reconstruction, not a claim to exact original combat balance or loot rates.

The [November30,2012 archived guide](https://everquest.allakhazam.com/wiki/EQ_Mob:Cragbeak?oldid=451419) documents a25-second screech and increasing damage with distance. The script casts the existing spell on the current hate target. Native target type32 keeps its target-centered range400 and caster-hate-list filtering; spell effects and distance scaling are not duplicated in Lua. First cast at25seconds is a configurable default. Combat end stops the timer. The two runtime destinations are `quests/shardslanding/752234.lua` and `quests/lua_modules/rof2_cragbeak_config.lua`; deployment must refuse conflicting existing numeric/name scripts or module files.

The database defaults are explicit in data.json: HP4.3million is inspired by the [February23,2013 player estimate](https://everquest.allakhazam.com/db/npc/41144#msg1361630047126992379). Melee2500–12569 is a balance reconstruction:12569 was an observed mitigated hit, and is not a recovered raw NPC stat. Other NPC fields retain the existing preimage, including faction, level, race, attack timing and spell-list bindings. These defaults can be tuned in source rather than delaying all implementation for unavailable exact values.

Reserved loottable30396003/lootdrop30397002 give a25percent chance of one native Minor/Lesser/Median/Greater Dreadmote, using equal configurable weights. Those item identities76550–76553 are verified and associated with Cragbeak's current catalogue. Neither25percent nor equal weighting is historical evidence. Glowing is not added without an association. Native `droplimit=1,mindrop=1` selects exactly one item when the table's25percent roll succeeds; it does not mean a guaranteed mote per kill. Existing non-mote loot is empty and remains a separate content gap; this does not claim complete equipment/cash loot parity.

`python3 apply_database.py` prints an offline plan. Manual coordinated apply requires PyMySQL, a private EQEmu config and a new receipt directory:

```sh
python3 apply_database.py --apply --config /private/eqemu_config.json --receipt-dir /private/cragbeak-db-repair
```

The helper requires peq_housing_test, exact full NPC/spell preimages, native mote identities, transactional tables, and absent reserved definitions/consumers. It backs up the actual NPC, writes seven loot rows and updates four NPC fields in one transaction, then checks full postimages before commit. No player or existing loot rows are changed. A prepared receipt without a completed receipt requires inspecting exact rows before any retry. Do not automatically remove loot definitions after copies could exist; any reversal must preserve new corpse/player property and refuse changed definitions or new consumers.

Publication precedes coordinated database/script deployment and a fresh affected zone/quest cache. Do not use a broad installer, force a repop into someone else's encounter, or overwrite another owner's scripts. Keep old spawned NPCs separate from proof of newly loaded stats. This directory is outside manifest.stages. Offline plan and source/API review are not compiled/runtime/native acceptance. Native input remains with the current tester.

This supersedes the earlier two-provider proposal's assumption that unknown Cragbeak balance/drop parameters must block every repair. Iremaw's missing entity/caster binding, original reward grouping and unknown item identities remain distinct evidence gaps.

## Applied status, November4,2026

The eight-write database transaction committed with exact postimages and independent NPC/loot readback. Both new runtime files were installed exclusively and hash-verified; no existing script was overwritten. Build confirmed ShardsLanding752 is unloaded and all six normal zone pointers are null, with zone initialization creating a fresh quest VM and first loot access loading the database. Thus the next ordinary fresh zone/spawn will load this reconstruction; no global repop/restart was performed for it. An actual native Cragbeak spawn, cast or loot result has not been observed. All configured estimates remain labelled, and non-mote loot parity remains incomplete.
