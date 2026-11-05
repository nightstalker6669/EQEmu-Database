# Delay Death rank 32 (AA-016)

Finite source proposal for ability 335, native rank 8431, prepared under the coordinator's standing authorization to batch similarly qualified proposals using documented inherited encoding defaults. Publication and database execution are separate; the Database owner requires the published revision and exact coordinator GO. No application, cache refresh, build, or native acceptance is claimed.

## Evidence and selected defaults

The [May 10, 2013 wiki revision](https://everquest.allakhazam.com/wiki/EQ:Delay_Death?oldid=463609) lists rank 32 at cost 10, level 92, Veil of Alaris. Its description gives 50 HP per rank through rank 30, then 100 HP per rank. Thus rank 31 yields 1600 HP and rank 32 yields 1700 HP below the ordinary death threshold. These numbers are derived from the period description, not read from a packet. The loaded rank 31 (8430) matches cost 10, level 91, era, and magnitude 1600 and explicitly points to missing native rank 8431.

Retain predecessor passive fields and effect encoding: slot 1, SPA 328, base2=0, advancing base1 from 1600 to 1700. This is inherited local encoding. No prerequisite rows are added. Set next_id=-1 as a finite reconstruction boundary until a later native ID is authenticated; this does not claim rank 32 was historically terminal. Ranks 33 through 35 have period requirements but unknown native IDs and remain held. Later placeholder requirements and July 2013 extrapolations are excluded. This proposal does not change unconsciousness mechanics.

## Application and rollback

Forward script: `utils/sql/aa/2026_11_05_delay_death_rank32.sql`. It adds one rank and one effect and changes no existing rows, ability definitions, ownership, points, or charges. Use a MariaDB client supporting DELIMITER and BEGIN NOT ATOMIC. Exact ability and predecessor preimages, the predecessor effect, zero predecessor prerequisites, absent target rows, and exact inserted postimages are checked in one transaction. A mismatch signals an error and rolls back. Retain the execution receipt and verify committed rows through the Database owner's normal process.

Rollback script: `utils/sql/aa/rollback/2026_11_05_delay_death_rank32.sql`. It requires exact inserted postimages, no target prerequisites, and no character ownership of root 1026 at rank 32 or higher. It deletes only the newly added rank and effect. A refusal requires coordinator resolution; it never edits player data.

## Validation boundary

Prepared from the pinned period page and fresh bounded read-only database observations. Neither script has been executed here. No test campaign, runtime loading, purchase behavior, or death-threshold native acceptance is claimed.
