# An Expedition Gone Awry: first-completion component

This restores the original Rupkerr task as920131, with minimum80, the missing expedition, native journal49186, a Lizardman Patroller encounter and delivery to existing Rupkerr700075. The [original quest](https://everquest.allakhazam.com/db/quest/5125) has period2010 reports establishing five Dream Motes and regular patroller kills, a2011 accepted80/refused79 report, and a2012 report placing the attacker at the looter. The following quest's different journal49187 is not substituted.

Completion grants five native Dream Motes through currency22 and the existing fixed/common task reward ledger: one reward3839201311/type4/data22/amount5. Direct task currency points and physical Mote rewards remain empty, preventing a second payout. The currency representation uses the existing native Dream Mote mapping; exact original payout presentation is not independently proved. Native faction+10, cash and experience use the ordinary task completion path. There is no manual item deletion, currency summon or second reward consumer in Lua.

Existing froglok corpses700141 are class62 loot containers, opened through the native `/open` path. Their eight placements, existing journal loot and all actors/stats remain unchanged. The task's exploration box is a labelled configurable approximation around those existing corpses. Its initial explore/loot/kill objectives run together, followed by final delivery; exact original unlock ordering is unrecovered. All four existing Lizardman Patroller type IDs can satisfy the kill, following the reported regular-patroller alternative.

The zone-local player hook reacts only to native task920131 journal activity1 reaching count1, with an additional in-memory journal presence check. Native task update follows the inventory call and loot objective credit; vetoable pre-loot EVENT_LOOT is not used. It spawns the existing700142 family template at the looter and adds hate. The spawned entity receives task/character ownership metadata for bounded inspection/cleanup. Do not delete unrelated world patrollers by template ID:700142 already has ordinary placements. No persistent NPC/spawn/loot row is created or changed. Spawn failure is logged without a guessed credit/refund/retry; the native task can still use an ordinary patroller kill. Exact original despawn timing remains unrecovered.

`feerrott2/player.lua` is local and currently has no competing local/versioned/fallback player script. QuestParserCollection dispatches global player hooks separately, so `global/global_player.lua` is preserved and is not manually called again. The Rupkerr script reuses the installed task-only native delivery helper unchanged. This is the ordinary native event/delivery path, not a durable item-GUID receipt or generic crash-atomic consume/award contract. It does not solve Cursed Cure's separate mid-task exchange.

This component permits the first completion only. A datedJanuary27,2013 report says six hours, while the current guide says five; later2013 reports describe chain-dependent replay. No authentic complete chain-replay condition is implemented here, so repeat is disabled rather than inventing an unconditional Mote farm. The six-hour native completion-clock field is retained for future integration, without claiming the original clock start. Native completed-task recording is enabled and preserved. This does not claim the original quest was never repeatable.

Other explicit parameters: current reports disagree between158 and315 platinum;158 is the selected configurable cash default. Experience is a configurable1percent level-based reward capped at85(-8501), not recovered original numeric XP. Faction+10 is supported by the current guide and dated general non-kill-task policy. Existing Feerrott GM80 access and the remainder of the original quest chain remain unfinished and unchanged. No achievement criteria, global scripts, new C++ event or new framework is introduced.

`python3 apply_database.py` prints an offline plan. Coordinated apply requires PyMySQL, private EQEmu configuration, installed quest root and a new private receipt directory. It checks task/reward/timer namespaces and dangling reward consumers, existing helper hash/callback absence, native currency/journal/actors/faction, corpse footprint/loot and zone access. Ten rows are inserted in one transaction with durable preimages and full postimage readback. New runtime files are `quests/feerrott2/700075.lua`, `quests/feerrott2/player.lua` and `quests/lua_modules/rof2_hot_expedition.lua`; all must be installed exclusively without replacing callbacks or the shared helper.

Publication precedes deployment. Coordinate all normal process TaskManager task/reward catalogs plus fresh affected Feerrott quest VM through JARVIS; fresh NPC loading alone does not refresh process-local task catalogs. Preserve the active tester, with no own global restart/repop or client input. Prepared-only receipts must be reconciled against exact rows before further action. Rollback must refuse changed definitions/new consumers or task users/progress and must never erase legitimate player items, currency, faction or history. Native quest, spawn, loot, payout and persistence acceptance remain untested by this source checkpoint.

## Native catalog binding correction

The first eight-row deployment omitted reward_sets and reward_sources. Build’s actual TaskManager readback caught has_reward_selection=false; no native reward availability was established. The complete fresh-install package now includes enabled reward_set920131 and source_type2(Task)/source_id920131→set920131, for ten total rows. Existing options/entry/reward are retained. No reward_source_entries automatic payout is introduced. The current native LoadTaskRewardSets loads the shared catalog through these explicit bindings; equal task/set identifiers alone do not create a binding.

For the already installed eight-row component only, repair_reward_bindings.py guards their exact unchanged postimages and absent bindings/consumers, durably backs up and inserts only the two missing binding rows in one transaction, then verifies all ten rows. It refuses conflicting or already repaired state. The ordinary fresh installer must not be rerun against the installed component. Cache reload follows successful repair and independent readback through JARVIS/Build.

## Applied status,2026-11-04

First8inserts committed; actualcatalogfailure exposed missingnativebindings; corrected2bindingtransaction committed; all10fullpostimages+independentreadbackPASS

3exclusiveLua files installed/hashmatched; reviewedhelperunchanged/globalplayerdispatchpreserved

BuildXORBB-CLEANUP-EXPEDITION-001 actualworld+all6zones task920131/fouractivities loaded; all6rewardselectiontrue/commonoption1->3839201311/type4/currency22/amount5,140sets. Managednormalstartup2026-11-04T11:35:18Z; api27 NOTissued/no redundantreload. Feerrott700unloaded,nextordinarybootfreshVM.

False

Firstcompletiononly; originalcompletechainreplayunimplemented
