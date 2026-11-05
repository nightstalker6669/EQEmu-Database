# AA021: Improved Burst of Life rank 5

Source proposal only. Publication and Database application remain coordinator routed. Preparation did not execute SQL, build, deploy, refresh caches or perform native testing.

The rendered [November 10, 2012 revision](https://everquest.allakhazam.com/wiki/EQ:Improved_Burst_of_Life?oldid=448969), timestamp 06:44:52 (history 06:44:53), describes a Cleric passive adding 1,000 HP of effectiveness to Burst of Life per rank. Rank 4 costs 12 at level 89/House of Thule; rank 5 costs 15 at level 90/House of Thule. The cumulative bonus therefore advances from 4,000 to 5,000 HP. Its first rank requires Burst of Life 1. Later rows 6–10 have period requirements, but their native IDs remain unauthenticated.

Fresh read-only observations confirm ability 999/root 7765 and predecessor 7768/rank 4 explicitly pointing to missing 7769. The target has no rank, effect or prerequisite rows. Predecessor 7768 has three effect slots and exactly prerequisite 7689/1 (Burst of Life). The native loader merges predecessor prerequisites into successor ranks, so the requirement remains enforced without adding a redundant prerequisite row.

Add rank 7769 with previous 7768, cost 15, level 90, expansion 17 and finite next=-1. Preserve inherited title/description 7765, hotkeys -1, passive spell=0 and zero timer/recast fields. Retain all three effect slots: advance only slot 1 SPA392 base1 from 4000 to 5000, keeping base2=0; preserve slot 2 SPA139 spell 21820 and slot 3 SPA411 base1=4. The existing native focus/filter encoding is a qualified inheritance default, not authenticated period packet contents or native acceptance. No filter redesign is proposed.

The finite next=-1 bounds this reconstruction. It does not claim that historical rank 5 was terminal or authorize guessing later native IDs.

The MariaDB anonymous block checks the exact ability, predecessor, all three effects and prerequisite 7689/1, then target absence and exact inserted postimages in one transaction with rollback/resignal on error. Delta: one rank, three effects and zero prerequisites; no existing-row, ability, ownership, points or charge changes.

Rollback requires the exact new row/effects, no target prerequisites, and no root 7765 owner with five or more ranks. It removes only the new rank and its three effects; player data remains untouched. Later dependencies or drift must be reconciled by the coordinator.

Evidence consists of the rendered dated history/revision, preserved inventory and bounded fresh read-only observations. Database application requires a separate exact GO after publication. Native gameplay acceptance remains unclaimed.
