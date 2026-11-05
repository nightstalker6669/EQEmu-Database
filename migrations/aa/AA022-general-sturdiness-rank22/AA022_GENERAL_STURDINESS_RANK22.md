# AA022: General Sturdiness rank 22

Source proposal only, prepared under the coordinator's explicit selection of the pre-cutoff level requirement. Publication and Database application are separate routed steps. No SQL execution, build, deployment, cache refresh or native test occurred during preparation.

The rendered [November 9, 2012 revision](https://everquest.allakhazam.com/wiki/EQ:General_Sturdiness?oldid=448895), timestamp 15:24:52, gives 100 HP per rank through rank 20 and 200 HP per rank beginning rank 21. Rank 21 costs 8 at level 91/Veil of Alaris; rank 22 costs 8 at level 92/Veil of Alaris. The cumulative amount therefore advances from 2,200 to 2,400 HP.

## Qualified level selection

The same page's history contains a December 3, 2015 note saying rank 22 was edited to level 91, confirmed. That post-cutoff note does not establish whether the earlier 92 was a transcription error or whether requirements changed later. The coordinator selected the actual pre-cutoff revision's level 92 for this reconstruction while retaining that ambiguity. This does not claim the original server/client level field has been independently proven. The later 91 value is not imported silently.

## Native target and guards

Fresh read-only observations confirm ability 3801/root 6119 and predecessor 8448/rank 21 explicitly pointing to missing 8449. Target 8449 has no rank, effect or prerequisite rows. The predecessor has no prerequisite rows and exactly slot 1 SPA69 base1=2200/base2=0, consistent with the dated description.

Add rank 8449 with previous 8448, cost 8, selected level 92, expansion 18 and finite next=-1. Inherit native title/description 6119, hotkeys -1, passive spell=-1 and zero timer/recast fields. Retain its one SPA69 slot with base1=2400 and unchanged base2=0. This native encoding reuse is a qualified reconstruction default, not authenticated period packet data or runtime acceptance.

The finite next=-1 bounds the supported addition and does not claim historical termination. Later native IDs remain unauthenticated even where the dated page supplies later requirements.

The MariaDB anonymous block guards exact ability/predecessor/effect preimages, zero predecessor prerequisites, target absence in all three rank tables, and exact inserted postimages in one transaction with rollback/resignal on error. Delta: one rank, one effect, no new prerequisite, and no existing-row, ability, ownership, points or charge edits.

Rollback requires the exact new rank/effect, no target prerequisites and no root 6119 owner with 22 or more ranks. It deletes only the added rank/effect, never player data. Any later dependencies or drift require coordinator review.

Evidence consists of the actual rendered dated history/revision, retained inventory, bounded fresh read-only observations and the coordinator's explicit level selection. Database application requires its separate exact GO after publication. Native gameplay acceptance remains unclaimed.
