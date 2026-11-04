# Proposed PoK route for three older rank I spells

This is an unapplied source proposal. It adds one existing native scroll to each of three existing PoK merchants, using the later vendor route introduced in 2012. **The individual RoF-era inventory memberships are inferred from dated provider roles, the original vendor expansion and current named stock. They are not individually dated stock captures.** Original TSS/SoF rank I quest or drop sources remain unresolved; this proposal does not claim to implement those sources.

| Native spell | Class and level | Existing NPC / merchant | Item | Proposed slot | Preserved native base price |
|---|---|---|---|---|---|
| Drink of Decomposition 10276 | SHD 73 | Reaver Praden 202185 | 78613 | 1 | 246416 copper |
| Nature's Burning Wrath 14358 | DRU 80 | Wanderer Thermon 202215 | 115358 | 1 | 392568 copper |
| Tangleweave Energy 15477 | WIZ 80 | Channeler Keatrem 202175 | 116477 | 1 | 393888 copper |

All three active-era merchants currently have empty dedicated stock namespaces. Their normal PoK placements already require expansion 18 and admit expansion 19. They are distinct from the older same-name actors 202338/202499/202504, whose placements end at expansion 17 and whose stock remains untouched. Source selection follows exact active references and era bounds, rather than choosing the first matching name. No actor, placement, class, price or spell definition is edited, and no new NPC is created. Only these three scrolls are proposed; the full modern vendor inventories are not imported.

## Evidence and limits

Reaver Praden's July 9, 2012 comment explicitly describes her level 71–80 role; current NPC10098 stock names Drink of Decomposition. Wanderer Thermon's original April 17, 2012 revision422349 explicitly says Druid Spells71–80; current NPC10184 lists Nature's Burning Wrath. Channeler Keatrem's April 15, 2012 revision422080 explicitly says Wizard Spells71–80; current NPC10077 lists Tangleweave Energy. The contemporary March16,2012 patch expands PoK inventories to most ordinary spells/tomes/songs, excluding Ancients and advanced ranks.

These sources support a qualified later PoK acquisition candidate. Earlier comments about bazaar copies or casting sometimes refer to rank II or omit rank, and Seridyn's rank II stock must not be substituted for rank I. **Wraithguard's Vengeance is excluded** because positive cut-spell and later-2016 availability reports prevent using modern stock alone as RoF release proof. The same caution applies if stronger contradictory period evidence is later recovered for these three rows. Do not describe this proposal as recovered original per-item May2013 stock or original mission implementation.

New rows require expansion18 for the 2012 merchant route. The ordinary native PoK stock policy is selected as a numerical local default: standing-1100, standard platinum/status/class filters, no Alaran requirement or alternate currency. Because the selected merchants are empty, this policy is explicitly taken from the previously reviewed ordinary PoK cohort; it is not falsely described as inherited existing stock on these three actors. Native positive item prices and all original spell fields remain unchanged. Current Live effect values are not imported. Drink's native CastRestriction105 is already present; no removal of its plant restriction is proposed.

## Guarded application and recovery

Publication and coordinator review must precede application. Running `python3 apply_database.py` only prints an offline plan. A later coordinated --apply requires private --config and a fresh --receipt-dir. The helper guards the exact three full actors, sole merchant consumers, selected placements, complete item/spell definitions and empty merchant namespaces. It verifies native mappings, ranks, levels and positive prices, requires a transactional merchant table and saves a durable exclusive backup before inserting three rows in one transaction. It compares the complete resulting stock before commit. `--readback` independently checks those three complete stock lists and all preserved definitions and references.

A prepared-only or uncertain commit must be reconciled against exact postimages before any new mutation; never retry blindly. Rollback may remove only the three exact owned stock rows with unchanged actors, definitions, consumers and no new dependent state. Never overwrite old-era merchant lists or erase player purchases. JARVIS/Build owns any later PoK merchant freshness. No task, achievement, player, C++ or quest script changes accompany this proposal. No native purchase, learning, placement or spell-casting acceptance is claimed.
