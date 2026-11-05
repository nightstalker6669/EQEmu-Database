# Expansive Mind rank 32 (AA-015)

Finite source proposal for ability 348, native rank 13282, prepared under the coordinator's standing authorization to batch similarly qualified missing-rank proposals using documented inherited encoding defaults. Publication and database execution are separate; the Database owner requires the published revision and exact coordinator GO. No application, cache refresh, build, or native acceptance is claimed.

## Period evidence and selected defaults

The [November 30, 2012 wiki revision](https://everquest.allakhazam.com/wiki/EQ:Expansive_Mind?oldid=451576) states that each rank raises the item mana regeneration cap by one point. Its rank 32 row lists cost 12, level 92, Veil of Alaris. The loaded rank 31 (13281) matches the period cost, level, era, and cap bonus 31 and explicitly points to missing native rank 13282.

Retain the predecessor's passive fields and effect encoding: slot 1, SPA 318, base2=0. Advance base1 from 31 to period-supported 32. This is inherited local encoding, not an authenticated period packet capture. No prerequisite rows are added. Set next_id=-1 as a finite reconstruction boundary until a later native ID is authenticated; this does not claim rank 32 was historically terminal. Ranks 33 through 35 have period values but unknown native IDs and remain held. RoF ranks 36 through 38 have unknown period requirements and are excluded.

## Application and rollback

Forward script: `utils/sql/aa/2026_11_05_expansive_mind_rank32.sql`. It adds one rank and one effect. It changes no existing rows, ability definitions, ownership, points, or charges. Use a MariaDB client supporting DELIMITER and BEGIN NOT ATOMIC. Exact ability and predecessor preimages, the predecessor effect, zero predecessor prerequisites, absent target rows, and exact inserted postimages are checked in one transaction. Any mismatch signals an error and rolls back. Retain the execution receipt and verify committed rows through the Database owner's normal process.

Rollback script: `utils/sql/aa/rollback/2026_11_05_expansive_mind_rank32.sql`. It requires exact target postimages, no target prerequisites, and no character ownership of root 1072 at rank 32 or higher. It deletes only the newly added rank and effect. A refusal requires coordinator resolution; it never edits player data.

## Validation boundary

Prepared from the pinned period page and fresh bounded read-only database observations. Neither script has been executed here. No test campaign, runtime loading, purchase behavior, or item mana cap acceptance is claimed.
