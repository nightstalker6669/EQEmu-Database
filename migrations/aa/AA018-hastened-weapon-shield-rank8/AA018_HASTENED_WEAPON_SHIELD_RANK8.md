# AA018: Hastened Weapon Shield rank 8

Source proposal only; publication and Database application remain coordinator routed. No SQL was executed during preparation, and no build, cache campaign or native test was performed.

## Period evidence

The rendered [November 8, 2012 revision](https://everquest.allakhazam.com/wiki/EQ:Hastened_Weapon_Shield?oldid=448503), timestamp16:48:34, describes a Ranger passive reducing Weapon Shield Discipline reuse by four minutes per rank. Rank7 costs9 at level88/House of Thule; rank8 costs9 at level90/House of Thule. Later ranks9–11 are listed, but their native IDs have not been authenticated. Their requirements do not authorize inventing IDs or extending this payload.

## Native target and selected encoding

Fresh read-only observations confirm ability871, root6751, and predecessor10770/rank7 with explicit next10771. Target10771 has no rank, effect or prerequisite rows. Predecessor10770 has no prerequisite rows and two effects: slot1 SPA310 base1=1680000/base2=0; slot2 SPA139 base1=4519/base2=0.

Add exactly rank10771 with previous10770, cost9, level90, expansion17 and next=-1. Preserve inherited title/description6751, hotkeys-1, passive spell=-1 and zero timer/recast fields. Copy both native effect slots, changing only SPA310 base1 to1920000 milliseconds (eight ranks times four minutes). Current `CalcAAFocus` converts this field from milliseconds to seconds; inherited SPA139 limits it to spell4519. This is qualified native encoding reuse, not a period packet or runtime acceptance claim.

`next=-1` bounds this finite reconstruction; it does not assert that historical rank8 was terminal. Rank9's dated Alaran Advanced prerequisite is outside this rank8 payload.

## Guards and rollback

The MariaDB anonymous block uses one transaction with rollback/resignal on error. It checks exact ability/predecessor/effect preimages, zero predecessor prerequisites, target absence in all three rank tables, and exact inserted postimages. Delta: one rank and two effects; no added prerequisites, existing-row edits, ability edits, ownership, points or charge writes.

Rollback requires the exact new rank/effects and no new prerequisites, and refuses if any root6751 owner has eight or more ranks. It removes only the new rank and its two effects. Player data remains untouched. A later dependency or source drift must be reconciled by the coordinator before use.

Preparation evidence includes the rendered dated page, preserved frozen inventory, fresh read-only predecessor/target observations and source field-unit inspection. Database application needs its separate exact GO after publication. Native gameplay acceptance remains unclaimed.
