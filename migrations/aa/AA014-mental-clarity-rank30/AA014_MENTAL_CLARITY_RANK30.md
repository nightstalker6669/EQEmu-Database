# Mental Clarity rank 30 (AA-014)

Finite source proposal for ability 224, native rank 13314, prepared under the coordinator's standing authorization to batch similarly qualified missing-rank proposals with documented inherited encoding defaults. Publication and database execution remain separate; the Database owner requires the published revision and exact coordinator GO. No application, cache refresh, build, or native acceptance is claimed.

## Period evidence and selected defaults

The [January 6, 2013 wiki revision](https://everquest.allakhazam.com/wiki/EQ:Mental_Clarity?oldid=454892) states one point of natural mana regeneration per ability level. Its rank 30 row lists cost 8, level 91, Veil of Alaris. Level 91 is the displayed requirement; it is not extrapolated to 92. The loaded rank 29 (13313) matches the period cost, level, era, and regeneration 29 and explicitly points to missing native rank 13314.

Retain the predecessor's passive fields and effect encoding: slot 1, SPA 15, base2=0. Advance base1 from 29 to period-supported 30. This is inherited local encoding, not an authenticated period packet capture. No prerequisite rows are added. Set next_id=-1 as a finite reconstruction boundary until a later native ID is authenticated; this does not claim rank 30 was historically terminal. Ranks 31 through 33 have period values but unknown native IDs and remain held. RoF ranks 34 through 38 have unknown period requirements and are excluded.

## Application and rollback

Forward script: `utils/sql/aa/2026_11_05_mental_clarity_rank30.sql`. It adds one rank and one effect. It changes no existing rows, ability definitions, ownership, points, or charges. Use a MariaDB client supporting DELIMITER and BEGIN NOT ATOMIC. Exact ability and predecessor preimages, the predecessor effect, zero predecessor prerequisites, absent target rows, and exact inserted postimages are checked in one transaction. Any mismatch signals an error and rolls back. Retain the execution receipt and verify committed rows through the Database owner's normal process.

Rollback script: `utils/sql/aa/rollback/2026_11_05_mental_clarity_rank30.sql`. It requires exact target postimages, no target prerequisites, and no character ownership of root 658 at rank 30 or higher. It deletes only the newly added rank and effect. A refusal requires coordinator resolution; it never edits player data.

## Validation boundary

Prepared from the pinned period page and fresh bounded read-only database observations. Neither script has been executed here. No test campaign, runtime loading, purchase behavior, or mana-regeneration acceptance is claimed.
