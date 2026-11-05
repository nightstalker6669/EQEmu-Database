# Combat Stability rank 40 (AA-013)

Source proposal for ability 33, native rank 8441. Publication does not authorize execution. The Database owner applies this only after coordinator GO against the published revision. No database application, cache refresh, build, or native acceptance is claimed.

## Evidence and accepted defaults

The [November 9, 2012 wiki revision](https://everquest.allakhazam.com/wiki/EQ:Combat_Stability?oldid=448882) lists rank 40 at level 92, cost 13, Veil of Alaris, and magnitude 67 in its Mit% column. The loaded rank 39 (8440) explicitly points to absent native rank 8441; the target ID is not allocated by sequence.

The coordinator accepted retaining the predecessor's passive fields and effect encoding: slot 1, SPA 259, base2=0, changing base1 from 66 to the period-supported 67. This is an inherited local encoding, not authenticated period packet evidence or a claim of universal 67 percent melee damage reduction. No prerequisite rows are added. Set next_id=-1 as a finite reconstruction boundary until a later native ID is authenticated. This does not claim rank 40 was historically terminal.

Ranks 41 through 43 have period-supported values but no authenticated native IDs. They remain held; do not infer 8442 or later IDs. Later wiki additions, including guessed linear values for subsequent ranks, are excluded.

## Application and rollback

Forward script: `utils/sql/aa/2026_11_05_combat_stability_rank40.sql`. It adds one rank and one effect, with no existing-row changes and no ability, ownership, points, or charges writes. Use a MariaDB client supporting DELIMITER and BEGIN NOT ATOMIC. The script checks exact ability and predecessor preimages, the predecessor effect, zero predecessor prerequisites, absent target rows, and exact inserted postimages in one transaction. A mismatch signals an error and rolls back. Preserve the execution receipt and verify committed rows through the Database owner's normal process.

Rollback script: `utils/sql/aa/rollback/2026_11_05_combat_stability_rank40.sql`. It requires exact inserted postimages, no target prerequisites, and no character ownership of root 122 at rank 40 or higher. It removes only the newly added rank and effect. A refusal requires coordinator resolution; the script never edits player data.

## Validation boundary

Preparation uses retained period evidence and bounded read-only database observations. No extra research or test pass was requested for the accepted defaults. Neither script has been executed here. Runtime loading, purchase behavior, and mitigation behavior remain separate native acceptance work after authorized application.
