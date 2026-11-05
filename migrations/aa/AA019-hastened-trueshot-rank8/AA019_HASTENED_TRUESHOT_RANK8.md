# AA019: Hastened Trueshot rank 8

Source proposal only; publication and Database application remain coordinator routed. Preparation did not execute SQL, build, deploy, refresh caches or perform a native test.

The rendered [November 8, 2012 revision](https://everquest.allakhazam.com/wiki/EQ:Hastened_Trueshot?oldid=448500), timestamp16:46:00, describes a Ranger passive reducing Trueshot or Aimshot reuse by six minutes per rank. Rank7 costs9 at level91/Veil of Alaris and requires Alaran Advanced1; rank8 costs12 at level95/Veil of Alaris.

Fresh read-only observations confirm ability3803/root6355 and predecessor14101/rank7 explicitly pointing to missing14263. The target has no rank, effect or prerequisite rows. The predecessor has seven effect slots and exactly prerequisite1685/1. The current native loader merges predecessor prerequisites into successors, so this existing requirement remains in force without a new redundant prerequisite row.

Add exactly rank14263 with previous14101, cost12, level95, expansion18 and finite next=-1. Preserve inherited title/description6355, hotkeys-1, passive spell=-1 and zero timer/recast fields. Retain all seven effect slots. Advance both existing SPA310 base1 fields2520000→2880000milliseconds (eight times six minutes), keeping base2=0. Preserve SPA139 spell4506 and the four SPA385 group limits11122/11222/11322/11522. Current `CalcAAFocus` converts SPA310 milliseconds to seconds and assigns its value; these identical retained slots do not add their values together.

The duplicate SPA310 layout and all filters are qualified inheritance defaults, not authenticated period packet contents or native acceptance. This proposal does not redesign or normalize them. `next=-1` bounds the supported reconstruction and does not prove historical termination.

The MariaDB anonymous block guards the exact ability, predecessor, all seven effects and prerequisite1685/1, then target absence and exact inserted postimages in one transaction with rollback/resignal on failure. Delta: one rank, seven effects, zero prerequisites and no existing-row, ability or player-data edits.

Rollback requires the exact new row/effects, no target prerequisites, and no root6355 owner with eight or more ranks. It removes only the new rank and seven effects. It never deletes or alters ownership, points or charges. Later dependencies or drift require coordinator review.

Evidence consists of the rendered dated page, retained inventory, bounded fresh read-only observations and source inspection of focus units and prerequisite inheritance. Database application requires its separate exact GO after publication. Runtime behavior remains unaccepted.
