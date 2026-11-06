# Ranger activated AA rank batch: AA025–AA028

Source-ready reconstruction of four supported native rank targets. Delta: four AA ranks, zero AA effects and one prerequisite. No existing row, ability, spell, ownership, point or charge edits. Preparation used read-only queries and isolated artifacts; no SQL application, source integration, build, cache campaign or native test occurred.

| Packet | Ability / rank | Native target | Cost | Level | Era | Spell | AA timer / seconds | Prerequisite handling |
| --- | --- | ---: | ---: | ---: | --- | ---: | --- | --- |
| AA025 | Frost Arrows 10 | 13536 | 11 | 91 | VoA | 30778 | 5/180 | Add Alaran1685/1 |
| AA026 | Poison Arrows 3 | 10738 | 12 | 90 | HoT | 23634 | 5/180 | None |
| AA027 | Outrider's Accuracy 8 | 14113 | 12 | 93 | VoA | 32330 | 7/600 | Inherit 1685/1 |
| AA028 | Group Guardian of the Forest 5 | 13543 | 15 | 92 | VoA | 30785 | 42/900 | Inherit 184/3, 1685/1 |

## Evidence and selected defaults

Each predecessor explicitly points to its proposed native target. Fresh read-only observations found all four targets absent from rank/effect/prerequisite tables and confirmed exact predecessor metadata, raw prerequisites and matching existing spell names. Individual period rows supply each proposed cost, level, era and spell ID:

- AA025: [Frost Arrows dated revision](https://everquest.allakhazam.com/wiki/EQ:Frost_Arrows?oldid=448487), 2012-11-08 16:14:38.
- AA026: [Poison Arrows dated revision](https://everquest.allakhazam.com/wiki/EQ:Poison_Arrows?oldid=448510), 2012-11-08 17:07:39.
- AA027: [Outrider's Accuracy dated revision](https://everquest.allakhazam.com/wiki/EQ:Outrider's_Accuracy?oldid=444911), 2012-10-16 23:27:44.
- AA028: [Group Guardian of the Forest dated revision](https://everquest.allakhazam.com/wiki/EQ:Group_Guardian_of_the_Forest?oldid=448496), 2012-11-08 16:38:02.

Reuse and timer types are inherited from the corresponding native predecessors and agree with the dated cooldown descriptions. Hotkey/title/description fields are also inherited. These are qualified native encoding defaults, not original packet certification. Every next=-1 is a finite reconstruction boundary, not historical termination; later AA rank IDs remain unauthenticated.

Frost Arrows explicitly introduces Alaran Advanced 1 at this rank. Its SQL adds only prerequisite1685/1 and guards the existing prerequisite ability and first rank14018. Outrider's Accuracy retains the predecessor's existing Alaran1685/1 requirement. Group Guardian retains both Guardian184/3 and Alaran1685/1. Native loader prerequisite inheritance carries those existing requirements into the new ranks; no redundant rows or weakened gates are introduced.

The dated spell bindings are supported; complete historical parity of every installed spell field/effect is not claimed. Spell identity guards check ID/name and do not overwrite spell content. Activation, proc behavior, pet behavior and client acceptance are not established by this source package.

## Application and rollback boundaries

Four separate one-use SQL transactions preserve exact packet boundaries. Each guards exact ability/predecessor metadata, exact predecessor prerequisites, zero predecessor effects, target absence, existing bound spell identity and exact inserted postimages. Frost additionally guards its new prerequisite postimage. Publication can batch the compatible files in one commit; Database application and its aggregate receipt remain separately coordinator routed. After a partial application, retain the applied subset and do not replay successful one-use packets.

Each rollback requires its exact new rank, expected target effect/prerequisite rows and no owner of the corresponding root with the newly reachable rank or higher. It deletes only its added rank and, for Frost, its added prerequisite. Player data and spell rows remain untouched. Later dependencies or drift require coordinator resolution. Existing AA023/AA024 are excluded from this batch; their previously routed artifacts must not be replayed.

## Held related candidate

Pack Hunt 8 has period cost13/level92/VoA/spell32361 and explicit native target13547. In the MCP-selected peq_housing_test database, spell32361 references pet type packhunt8, while a lookup for packhunt7/packhunt8 returns zero pet rows despite3,508 total pets. The core TemporaryPets consumer requires that lookup. This is a qualified current-database dependency observation, not a native failure claim; the serving content-database configuration was not authenticated. AA029 is not included. Its serving database and pet/NPC dependency need content-owner resolution before an AA proposal.
