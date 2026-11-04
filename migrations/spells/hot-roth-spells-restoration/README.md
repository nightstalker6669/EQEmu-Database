# Original Rotharran spell stock

This repair enables the existing Rotharran Radhelm NPC700070, merchant700070 in Feerrott700, with native Dream Mote currency22/item52149 and existing faction group920680/primary Dream Delvers680. It restores197 verified spell items:150 existing stock rows receive faction/cost corrections and47 rows are added. These include194 rank I spells and three illusion spells with their source-specific standing requirements. It changes no NPC identity, placement, spell learning level, item definition, player currency, faction value, inventory or lease.

Ordinary rank I purchases require Indifferent standing. Scarecrow requires Amiable, Amygdalan Kindly, and Royal Guardian Warmly, following the retained per-item source table. The existing faction base0 and all sixteen playable-race modifiers of-100 are preserved. No custom completion flag or automatic faction grant is substituted for these native checks.

All selected prices are30 Dream Motes. Most are supported by the per-item source table and period general rank I reports. Rilfed's Swift Sickness has a conflicting source-table0, while guides give general30/200 values. Its30 is an explicit configurable reconstruction default; zero is not interpreted as a verified free price. The source table's per-item gates are not all independently dated; Royal Guardian has additional retained period corroboration. These limitations remain labelled in provenance.

The158 other existing stock rows are preserved, including every item/cost/gate field and their original NULL flags in the durable backup. They receive only the required content flag `rof2_hot_nonspell_verified`, which must remain undefined/disabled until their own original costs and progression are implemented. This is an explicit reversible implementation filter, not a recovered original unlock rule. Do not enable that flag as a bulk shortcut: incomplete non-spell costs/progression remain a separate content gap.

This filter preserves the actual unavailable baseline. Rotharran is class70/currency0 before repair. Both alternate-currency request and purchase paths reject currency0, while normal shop request and purchase require class41. No Rotharran quest override was found and no other NPC consumes merchant700070. Thus there is no working ordinary non-spell shop being restricted. Both native merchant loaders apply ContentFilterCriteria before building the alternate merchant list, and purchases search that same filtered list. After repair,197 spell items fit below the255-item packet limit; filtered non-spell rows cannot be purchased by simply supplying their item IDs.

`python3 apply_database.py` prints an offline plan. Manual coordinated apply requires PyMySQL, a private EQEmu config and a fresh private receipt directory:

```sh
python3 apply_database.py --apply --config /private/eqemu_config.json --receipt-dir /private/rotharran-spells
```

The helper requires peq_housing_test, exact full NPC/308-stock preimages, the sole merchant consumer, absent pending flag, exact native currency binding/item, faction/group/race modifiers, and197 item/spell/class-level identities. It writes a durable backup, applies308 narrow stock updates,47 inserts and one NPC patch in a transaction, and verifies full postimages before commit. Mutation tables must be transactional. This package lives outside manifest.stages and uses no broad installer or new test suite.

Before deployment, preserve the current tester and coordinate affected Feerrott NPC/merchant cache freshness. No global repop or player-state change is included. A prepared-only receipt must be reconciled against exact live rows before further action; never retry blindly. Any rollback must match receipt postimages, refuse intervening edits/new merchant consumers, restore only these definitions/NULL flags, and preserve all legitimately acquired items/currency history. Native purchase/debit and original natural Dream Mote acquisition remain separate from database/cache availability proof.

## Applied status, November4,2026

The356-write database transaction committed with full postimages and independent NPC/stock-group readback. All197 spell rows cost30;194 require Indifferent and the three illusion thresholds are100/500/750. The158 other definitions remain intact behind the undefined pending flag. Faction base, sixteen race modifiers, other consumers and player state were not changed. Build confirmed Feerrott700 is unloaded and all six process content-flag caches exclude the pending flag; the deployed filter admits197 and excludes158 for the next ordinary fresh boot. No extra restart/repop, native purchase or currency debit was performed. Rilfed’s price remains a labelled default, and original natural Dream Mote acquisition/non-spell progression remain unfinished.
