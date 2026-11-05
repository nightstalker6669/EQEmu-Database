# Twinheal rank 5 (AA-017)

Finite source proposal for ability 385, native rank 13412, prepared under the coordinator's standing authorization to batch similarly qualified proposals using documented inherited encoding defaults. Publication and database execution are separate; the Database owner requires the published revision and exact coordinator GO. No application, cache refresh, build, or native acceptance is claimed.

## Period evidence and selected defaults

The [November 10, 2012 wiki revision](https://everquest.allakhazam.com/wiki/EQ:Twinheal?oldid=448990) lists rank 5 at cost 18, level 95, Veil of Alaris. Its description gives one percent healing twincast chance per rank and excludes heal-over-time spells. The loaded rank 4 (13411) has chance 4, cost 15, level 92, and explicitly points to missing native rank 13412. The period cost sequence through rank 4 matches the retained chain; the page leaves intermediate level requirements unknown.

Retain all eight predecessor focus and limiter slots and passive fields, including spell=0. Change only slot 1, SPA 399, base1 from 4 to period-supported 5; retain base2=0 and every other effect value. This is inherited local encoding, not an authenticated period packet capture or native proof of limiter behavior. No prerequisite rows are added. Set next_id=-1 as a finite reconstruction boundary until a later native ID is authenticated; this does not claim rank 5 was historically terminal. Later rank identities and requirements remain held; July 2013 additions are excluded from cutoff proof.

## Application and rollback

Forward script: `utils/sql/aa/2026_11_05_twinheal_rank5.sql`. It adds one rank and eight effects. It changes no existing rows, ability definitions, ownership, points, or charges. Use a MariaDB client supporting DELIMITER and BEGIN NOT ATOMIC. Exact ability and predecessor preimages, all eight predecessor effects, zero predecessor prerequisites, absent target rows, and exact inserted postimages are checked in one transaction. Any mismatch signals an error and rolls back. Retain the execution receipt and verify committed rows through the Database owner's normal process.

Rollback script: `utils/sql/aa/rollback/2026_11_05_twinheal_rank5.sql`. It requires exact target postimages, no target prerequisites, and no character ownership of root 12652 at rank 5 or higher. It deletes only the newly added rank and effects. A refusal requires coordinator resolution; it never edits player data.

## Validation boundary

Prepared from the pinned period page, retained native snapshot, and fresh bounded read-only predecessor/target/effect/prerequisite observations. Neither script has been executed here. No test campaign, runtime loading, purchase, healing twincast, or heal-over-time exclusion acceptance is claimed.
