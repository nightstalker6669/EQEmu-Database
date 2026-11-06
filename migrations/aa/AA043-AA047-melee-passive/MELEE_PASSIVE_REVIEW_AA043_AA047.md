# Bard, Rogue, Monk and Ranger passive review: AA043–AA047

This source review examined 68 new dated pages through May 31, 2013: Bard 15, Rogue 16, Monk 17 and Ranger 20. Five Ranger prefixes qualify for guarded proposals; 63 source contracts remain held. These counts describe this unit, not coverage or completeness.

| Packet | Ability / native rank | Purchase fields | Effect |
| --- | --- | --- | --- |
| AA043 | Hunter's Attack Power 35 / 13125 | free, level 89, HoT | SPA 2: ATK 140 |
| AA044 | Bow Mastery 9 / 10746 | cost 6, level 89, HoT | SPA 220: damage 240, Archery 7 |
| AA045 | Hastened Group Guardian of the Forest 3 / 10716 | cost 15, level 90, HoT | SPA 264: 270 seconds, ability 873 |
| AA046 | Hastened Harmonious Arrow 3 / 10732 | cost 12, level 90, HoT | SPA 264: 30 seconds, ability 870 |
| AA047 | Hastened Cover Tracks 5 / 14133 | cost 9, level 93, VoA | SPA 264: 300 seconds, ability 2234 |

Hunter's Attack Power uses the dated description's four ATK per rank and native predecessor 136. Its historical automatic delivery is not implemented or proven here; existing auto-grant metadata is retained without grants or a core change.

Bow Mastery retains the dated rank-9 cost of six literally. Cumulative 240 is reconstructed from the period's later 35-point increment and native 135/170/205 prefix, rather than an original AA export.

Group Guardian haste is ten percent per rank. The native target has a 900-second base cooldown, so rank 3 encodes 270 seconds. The existing rank 2 is 180. The forward transaction checks target ability 873/root 6755 and the observed timer-42, 900-second base rows. Harmonious Arrow explicitly adds ten seconds per rank; Cover Tracks adds sixty. The current cooldown consumer adds SPA 264 base values as seconds for the matching ability ID. Preserve native spell zero for AA045/AA046, and minus one for the others.

The dated sources are:

- [Hunter's Attack Power](https://everquest.allakhazam.com/wiki/EQ:Hunter's_Attack_Power?oldid=419461), revision 2012-03-29 09:26:04.
- [Bow Mastery](https://everquest.allakhazam.com/wiki/EQ:Bow_Mastery?oldid=448480), revision 2012-11-08 16:00:34.
- [Hastened Group Guardian of the Forest](https://everquest.allakhazam.com/wiki/EQ:Hastened_Group_Guardian_of_the_Forest?oldid=448497), revision 2012-11-08 16:41:58.
- [Hastened Harmonious Arrow](https://everquest.allakhazam.com/wiki/EQ:Hastened_Harmonious_Arrow?oldid=448499), revision 2012-11-08 16:43:43.
- [Hastened Cover Tracks](https://everquest.allakhazam.com/wiki/EQ:Hastened_Cover_Tracks?oldid=448494), revision 2012-11-08 16:33:10.

Each proposal inserts one rank and one effect. Existing predecessor rows and raw prerequisites remain unchanged and continue through native inheritance. No new prerequisite rows are needed. Each has its own exact-preimage, absent-target transaction and exact-postimage rollback that refuses removal once a character owns the newly reachable ordinal or higher. No abilities, spells, player state, shared source or runtime are changed by preparation.

The remaining pages lack authenticated purchase fields, effect values, or native identities. Headshot has a period/native ordinal mismatch, so a period rank number is not substituted into the native chain. Scout mastery copy errors do not authorize changing native identities. Unknown higher native IDs stay held.

Validation is limited to dated rendered pages, read-only database metadata, current static consumers and generated payload review. SQL has not been applied. Build, automatic grants, reuse behavior and native gameplay acceptance remain unproven.
