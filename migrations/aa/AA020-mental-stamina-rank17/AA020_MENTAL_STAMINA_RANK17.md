# AA020: Mental Stamina rank 17

Source proposal only. Publication and Database application are separately coordinator routed. No SQL execution, runtime writes, build, cache refresh or native test took place during preparation.

The rendered [January 6, 2013 revision](https://everquest.allakhazam.com/wiki/EQ:Mental_Stamina?oldid=454893), timestamp07:53:09, gives50mana per rank before16 and100additionalmana per rank starting16. Rank16 costs10 at level91/Veil of Alaris; rank17 costs10 at level92/Veil of Alaris. Thus the supported cumulative amount advances850→950mana. Later rows18–20 have requirements, but their native IDs are not authenticated. RoF rows21–25 have unknown cost/level in this revision.

Fresh read-only observations confirm ability1208/root8210 and rank16/native13318, explicitly next13319. Target13319 has no rank/effect/prerequisite rows; predecessor prerequisites are empty. Its sole effect is slot1 SPA97 base1=850/base2=0, agreeing with the period description.

Add rank13319 with previous13318, cost10, level92, expansion18 and finite next=-1. Inherit native title/description8210, hotkeys-1, passive spell=-1 and zero timer/recast fields. Copy its one effect slot with SPA97 base1=950 and unchanged base2=0. Native encoding reuse is a qualified reconstruction default, not a period packet or runtime acceptance claim. The finite next=-1 does not establish historical termination; no later IDs are invented.

The MariaDB anonymous block uses one transaction with rollback/resignal on error. It guards the exact ability, predecessor and effect, zero predecessor prerequisites, target absence in all three rank tables and exact inserted postimages. Delta: one rank and one effect. No existing-row, ability, ownership, points or charge changes.

Rollback requires the exact new row/effect and zero target prerequisites, and refuses if any root8210 owner has17or more ranks. It deletes only the new rank/effect, never player data. Later dependencies or drift require coordinator review.

Evidence: rendered dated history/revision, retained inventory and bounded fresh read-only predecessor/target observations. Database requires its separate exact GO after publication. Native gameplay acceptance remains unclaimed.
