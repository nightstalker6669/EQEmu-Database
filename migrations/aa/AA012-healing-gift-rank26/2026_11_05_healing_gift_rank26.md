# Healing Gift rank 26 (AA-012)

Source proposal for ability 19, native rank 13303. Publication does not authorize execution. The Database owner applies this only after coordinator GO against the published revision. No database application, cache refresh, build, or native acceptance is claimed.

## Evidence and accepted defaults

The [May 6, 2013 wiki revision](https://everquest.allakhazam.com/wiki/EQ:Healing_Gift?oldid=463277) lists rank 26 at level 93, cost 12, Veil of Alaris, with a 45 percent exceptional-heal chance. The loaded rank 25 (13302) explicitly points to absent native rank 13303; the target ID is not allocated by sequence.

The coordinator accepted retaining the predecessor's passive fields and effect encoding: slot 1, SPA 274, base2=0, changing base1 from 44 to the period-supported 45. This encoding is inherited local data, not authenticated period packet evidence. No prerequisite rows are added. Set next_id=-1 as a finite reconstruction boundary until a later native ID is authenticated. This does not claim rank 26 was historically terminal.

Rank 27 has period-supported values but no authenticated native ID. It remains held; do not infer 13304. RoF ranks 28 to 30 have unknown cost and level in the pinned revision and are outside this proposal.

## Application and rollback

Forward script: `utils/sql/aa/2026_11_05_healing_gift_rank26.sql`. It adds one rank and one effect, with no existing-row changes and no ability, ownership, points, or charges writes. Use a MariaDB client supporting DELIMITER and BEGIN NOT ATOMIC. The script checks exact ability and predecessor preimages, the predecessor effect, zero predecessor prerequisites, absent target rows, and exact inserted postimages in one transaction. A mismatch signals an error and rolls back. Preserve the execution receipt and verify committed rows through the Database owner's normal process.

Rollback script: `utils/sql/aa/rollback/2026_11_05_healing_gift_rank26.sql`. It requires exact inserted postimages, no target prerequisites, and no character ownership of root 80 at rank 26 or higher. It removes only the newly added rank and effect. A refusal requires coordinator resolution; the script never edits player data.

## Validation boundary

Preparation uses retained period evidence and bounded read-only database observations. No additional research or test pass was requested for the accepted defaults. Neither script has been executed here. Runtime loading, purchase behavior, and exceptional healing behavior remain separate native acceptance work after authorized application.
