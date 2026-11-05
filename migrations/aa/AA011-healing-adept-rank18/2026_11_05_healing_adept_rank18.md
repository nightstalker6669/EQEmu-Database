# Healing Adept rank 18 (AA-011)

Source proposal for ability 18, native rank 13298. Publication does not authorize database execution. The Database owner applies this only after coordinator GO against the published revision. No application, cache refresh, build, or native acceptance is claimed.

## Evidence and selected defaults

The [February 12, 2013 wiki revision](https://everquest.allakhazam.com/wiki/EQ:Healing_Adept?oldid=456707) lists rank 18 at level 95, cost 12, Veil of Alaris, with a 55 percent healing increase. The retained predecessor 13297 explicitly points to 13298. This identifies the missing rank without allocating a sequential ID.

The coordinator accepted the following qualified local encoding defaults: retain the predecessor's eight focus and limiter slots, change the two SPA 125 focus values from 52 to 55, and retain its other passive fields. The slot layout and limiters are inherited local encoding, not an authenticated period packet capture. No prerequisite rows are added. Set next_id to -1 as a finite reconstruction boundary until a later native ID is authenticated; this does not claim rank 18 was historically terminal. Later RoF ranks are outside this proposal because the pinned revision leaves their cost and level unknown.

## Changes and execution

The forward SQL adds one rank and eight effects. It changes no existing rows, abilities, ownership, AA points, or charges. Run the SQL as a MariaDB client script that supports DELIMITER and BEGIN NOT ATOMIC. It checks exact ability and predecessor preimages, all eight predecessor effects, absent target rows, and exact postimages in one transaction. Any mismatch signals an error and rolls back. Preserve the resulting execution receipt and verify committed rows through the Database owner's normal process.

Forward script: `utils/sql/aa/2026_11_05_healing_adept_rank18.sql`.

Rollback script: `utils/sql/aa/rollback/2026_11_05_healing_adept_rank18.sql`. Rollback requires exact inserted postimages and refuses if any character owns root 77 at rank 18 or higher. It removes only the newly inserted rank and effects. It never edits player data; resolve any refusal through the coordinator.

## Validation boundary

Offline payload construction and bounded read-only database observations support this proposal. These scripts have not been executed here. Runtime loading, purchase behavior, and healing behavior require separate native acceptance after authorized application. No additional research or test pass was requested for publication preparation.
