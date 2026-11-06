# Beastlord and Paladin passive review: AA048

This unit reviewed 32 new dated pages through May 31, 2013: Beastlord 14 and Paladin 18. One rank qualifies for a guarded source proposal; 31 source contracts remain held. Seven earlier Beastlord holds were reused. This is a unit count, not a coverage denominator.

AA048 adds Hastened Empathic Fury (ability 454) rank 2, native ID 12823: cost 12, level 88, House of Thule. The [dated February 2, 2013 source](https://everquest.allakhazam.com/wiki/EQ:Hastened_Empathic_Fury?oldid=456303) supplies these fields and ten percent reuse reduction per rank.

The native first rank has two distinct SPA 310 focus blocks: 153000 milliseconds for exact spell 8233, and 120000 milliseconds for groups 2439/2539 with class filter 32768. Current spell metadata gives base cooldowns 1530000 and 1200000 milliseconds respectively, matching the first-rank ten percent. The proposed cumulative twenty percent is 306000 and 240000 milliseconds. All four native filters remain unchanged. The current AA focus evaluator handles separate focus blocks and converts SPA 310 milliseconds to seconds.

Qualification: the dated description names Empathic Fury. Existing Savage Fury/Rage group filters are retained as native compatibility scope; their presence does not authenticate full historical family coverage. The transaction checks the observed cooldown metadata before inserting the rank and six effects. It preserves native spell zero and all eligibility metadata. No existing ability, spell or character rows are written.

Each forward transaction checks exact predecessor/effect/prerequisite preimages, absent target identities and exact postimages. Its rollback deletes only the seven new rows and refuses removal if a character owns the newly reachable ordinal or higher. No new prerequisite rows are needed.

The held pages have missing purchase fields, effect values or matching native successor contracts. A listed first-rank cost or an explicit per-rank effect does not establish missing later purchase fields. Partial tables do not prove a historical maximum. The Slay Undead page stops at rank nine while the native prefix already has ten; no successor is inferred.

Validation consists of dated rendered source pages, read-only database metadata, static focus-consumer inspection and generated payload review. SQL has not been applied; no build or native reuse acceptance is claimed. Higher native rank IDs and source fields remain held.
