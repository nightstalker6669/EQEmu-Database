# Original Meat for Eat faction task component

This restores Lerg's original task as920130 in Feerrott700, using the existing NPC700000, gorilla matrons700016, patriarchs700013 and Gorilla Meat17576. The [October20,2010 transcript](https://everquest.allakhazam.com/db/quest/5133#msg128754977813724180) establishes killing2 matrons, killing7 patriarchs, looting3 meat and giving3 to Lerg. The request keyword is `join`. No NPC, spawn, item definition or drop table is created or changed.

This is a Dream Delvers faction precursor to spell purchasing, not a Dream Mote payout route. It awards+5 faction680 through native task completion, with no item/currency reward. The [May21,2011 faction table](https://www.eqmagetower.com/forums/viewtopic.php?t=3346#p19219) describes kill tasks as+5; the [current task guide](https://hot.eqresource.com/meatforeat.php) also lists+5, experience, minimum80, unlimited duration and a5-hour lockout. Individual current guide fields are not claimed independently period-dated. No Dream Motes are invented for this task.

Explicit configurable defaults: minimum80 and5-hour replay follow the current guide; native replay begins after completion. Kill/loot activities run together, then final delivery unlocks; exact original phase ordering is unrecovered. Experience is a labelled1percent level-based default capped at85, encoded-8501 by the native task reward format, rather than an invented claim about original numeric XP. Cash0 follows the current guide's reward list. Maximum level is unrestricted. Existing Feerrott GM80 access, actor balance/placements and achievement criteria remain unchanged; this component does not complete all ordinary HoT access or natural Dream Mote acquisition.

The new numeric NPC script belongs at `quests/feerrott2/700000.lua`. It uses native task selection and the unchanged, already deployed `achievement_native_delivery_handin` helper. That helper reads native delivered counts, makes one script hand-in check when needed and one return attempt; shared-core94e5f727 custody reconciliation prevents returning units already credited by native Deliver. This is a generic task-only delivery dependency, despite its existing filename. Do not copy, edit or fork its implementation here. Do not install beside a conflicting numeric/name Lerg script or a separate physical hand-in consumer.

This uses ordinary native Deliver/fixed task completion. It does not claim a generic crash-atomic consume-and-award operation, and does not solve Cursed Cure's mid-task four-item exchange. No manual item deletion, scripted faction grant, fabricated refund or second reward consumer is added.

`python3 apply_database.py` prints an offline plan. Manual coordinated apply requires PyMySQL, private EQEmu configuration, the installed quest root and a new private receipt directory:

```sh
python3 apply_database.py --apply --config /private/eqemu_config.json --quest-root /private/server/quests --receipt-dir /private/meat-for-eat
```

The helper requires exact target, task/title/activity/timer namespace absence, native actor/item/faction identities, unchanged zone access and the reviewed installed delivery helper hash. It durably records the empty-row backup and five after-images, inserts one task/four activities in a transaction and verifies full postimages. Native task/spell/item IDs are separate namespaces. This is outside manifest.stages and does not run a broad installer or new test suite.

Publication precedes coordinated database/script deployment. TaskManager caches tasks at process startup, so a fresh Feerrott NPC/quest VM alone does not prove task920130 is loaded: coordinate normal serving-process task-catalog freshness after the active tester releases its window. Do not globally restart/repop or take client input. A prepared-only receipt must be reconciled against actual rows before further action. Rollback must refuse changed definitions or new task users/progress; never erase player task history, legitimate items, faction or currency. Native task acceptance, kills, loot, hand-in, rewards and replay remain untested by this source checkpoint.

## Applied status, 2026-11-04

COMMITTED5inserts:task920130+4activities; fullpostimages and independentreadbackpassed

Exclusivefeerrott2/700000.lua installed; reviewed85eeb3 deliveryhelper unchanged

BuildMEAT-FOR-EAT-CATALOG-001 authenticatedapi27 actualworld+all6taskcatalogs task920130/exact4activities and rewardcatalogs loaded; Feerrottunloaded nextordinaryfreshVM

Nativefaction680+5; NO DreamMotes

Player/global/actor/loot/GM80 unchanged

False
