# Original Void B-G rank I vendor component

This restores77 verified native rank I spells to the six existing Zebuxoruk NPCs in VoidB–G, using native Chronobine currency15/item103000. The [original guide](https://www.raspersrealm.com/Everquest/SoD/themeVoid.html) explicitly describes each tab as new stock, so later versions retain earlier items:8/22/40/54/77/77 rows,278 total. Native merchant IDs460000–465000 are dedicated to the corresponding existing NPCs. Only merchant_id and alt_currency_id change on those six NPCs; their class70, identities, faction bindings and placements remain unchanged.

This is a vendor component, not completed ordinary progression. All seven existing Void zones retain min_status80. Authentic theme completion, group/raid counting, port selection and later access still need their original implementation. GM access is not evidence of ordinary availability. VoidA, rank III raid unlocks, other stock, zone access, NPC/spawn creation, items, spells and players are untouched. No unconditional VoidA shop or invented completion flag is introduced.

The77 identities and all class learning levels were matched against native spell/item records, correcting retained guide link/name mistakes rather than granting helper spells. A [May21,2009 report](https://everquest.allakhazam.com/db/spell/16918) explicitly places Overpowering Frenzy in VoidB. Other per-item guide entries are not individually period-dated. The source first-stage costs155/165/175/185/195 Chronobines remain explicit configurable guide values, not universally verified original prices. Later stages retain each item's first-stage cost. Disputed rank III predicates and the separate330-Chronobine rank III observation are not used for these rank I rows.

`python3 apply_database.py` prints an offline plan. Manual coordinated apply requires PyMySQL, a private EQEmu config and a new private receipt directory:

```sh
python3 apply_database.py --apply --config /private/eqemu_config.json --receipt-dir /private/void-ranki-stock
```

The helper requires peq_housing_test, transactional mutation tables, exact six-NPC preimages, empty reserved stock/consumer namespaces, unchanged VoidA/zone-access/placement preimages, native currency identity, and all77 item/spell/class-level identities. It backs up actual definitions/empty stock, inserts278 rows and updates six bindings in one transaction, then verifies full postimages before commit. A prepared-only receipt must be reconciled against actual rows before further action; never retry blindly.

Publication precedes deployment. Coordinate fresh affected Void NPC/merchant caches while preserving the active tester; no global repop, GM gate removal or broad installer is included. A rollback must match receipt postimages and refuse intervening edits/new merchant consumers, restoring only these definitions without altering acquired player property. This source is outside manifest.stages. Database/cache proof is not a native purchase or ordinary progression test.

## Applied status, 2026-11-04

COMMITTED284writes:278merchantrows+6NPCbindings; fullpostimages and independent77distinctrank1readbackpassed

BuildVOID-BG-CACHE-FRESHNESS-001: affected460-465unloaded; nextordinaryfreshboot DBmerchant/NPCloadready. Noextra reload/restart.

[8, 22, 40, 54, 77, 77]

VoidAempty/allsevenGM80zones/III/player/faction/spawns unchanged

False
