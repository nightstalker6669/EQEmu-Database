# RoF2 spells

Database and quest content repairs for class spells through Rain of Fear, targeting the May 10, 2013 RoF2 client. This branch contains the spell work completed so far. It does **not** establish exact Live implementation of every spell.

The branch inherits `rof2-shared-core` commit `b3f795ea642d810d0af75dca39d6dd1f28826385` on upstream `develop` commit `c9c8747ac949deddb140d196d241fa4e777500c7`. The spell layer adds spell content and original acquisition scripts. Merchant language eligibility, task policies, durable reward IDs, ground-target aura placement and shutdown cleanup are inherited from this core. Public files exclude client assets, private character data, credentials, logs, test fixtures and server binaries.

## Included content

| Stage | Content |
| --- | --- |
| `001-exigent-items` | Three missing summoned Exigent Servant/Minion items: 64981, 64983 and 64984 |
| `002-rank1-vendors` | 574 distinct RoF rank I spells/tomes, 599 merchant rows across eight existing Shard's Landing vendors, and Magus Burlshin's Crystal Circle Builders faction binding |
| `003-pets-and-auras` | **Optional estimated reconstruction:** 202 missing pet template names, 3,084 pet/focus variants and corresponding unspawned NPC templates, 30 AI headers/entries, and 258 aura definitions |
| `005-voa-language` | 182 sourced Argath stock entries and Alaran language gates on 159 existing entries, covering 336 distinct rank I spells across eight merchants |
| `004-kerk-motes` | Kerkaz's script, ten physical Dreadmote/Terrormote delivery tasks, class-filtered native reward choices covering 1,108 distinct rank II/III spells/tomes, and two missing scroll items |
| `006-ordered-runes` | Original ordered exchanges for 284 SoF and 57 Underfoot rank III rewards, four quest/module files and the missing Drifting Haze III scroll |
| `007-voa-scrolls-and-tasks` | 454 verified missing scroll items and ten original Cantrip/Periapt delivery tasks covering 1,021 spells, with per-task Alaran admission and learned-bundle filtering |

| `008-hot-fragment-exchanges` | 287 verified missing HoT scrolls, eight original fragment exchanges covering 801 spells, and Dream Delvers bindings for the two existing teachers |

| `009-legacy-exchanges` | 143 TSS class rewards from original ordered runes, and 57 original Underfoot named-gem exchanges using existing items/drops |
| `010-sod-runes-and-downgrades` | 282 sourced SoD class/rune rewards, restoration of the original Plane of Time NPC, and four original SoF/SoD rune downgrade recipes |

Stage 003 includes measured historical anchors where available, but all reconstructed pet NPCs contain estimated secondary statistics. Aura ranges, timings and visual templates also include estimates. It is excluded by the installer's default selection. The [pet model](provenance/pet-model.json) and [aura model](provenance/aura-model.json) identify the scope and sources. These estimates must not be presented as recovered Live balance.

Kerkaz uses the original acquisition route: say `dreadmote` or `terrormote`, accept the matching task, deliver the physical mote, then choose a reward in the native window. Documented two- and three-scroll bundles remain one choice. The original mote can be selected back. There is no alternate-currency exchange merchant or added trade-down conversion. Hail/description text is paraphrased; this is not an exact dialogue transcript recovery.

SoF Kalim`Kar and Underfoot Dwekvard use direct physical rune hand-ins. Each exchange gives the first unlearned spell or discipline in the documented class/rune order and returns unused items. They do not use selectable task rewards. Tjudawos’ Chant of Flame III remains unresolved: the guide lists it, but no scroll identity was recovered; no item ID or replacement reward was invented. See [ordered rune provenance](provenance/ordered-runes.json). This stage does not implement the separate faction vendors, Underfoot mission rewards or rank II gem drops.

Ground-target persistent auras are created once at the caster's selected ring position. Range, minimum range, finite coordinates and detrimental line of sight are checked before casting and again before creation. Ordinary caster auras and nonpersistent area spells retain their existing placement. Native gameplay acceptance remains pending.

HoT teachers use original Nebulous/Tangible fragment delivery tasks and Dream Delvers admission. Known spells remain visible, matching the contemporary descriptions. The rank III level 87/88 tasks are withheld because their faction admission could not be established. Three scroll identities and additional level 90 paladin pairing information remain unresolved; whole affected choices are omitted. Rotharran’s separate shop repair remains pending original progression missions and verified gates. See [HoT task provenance](provenance/hot-tasks.json).

## Engine ownership and dependency

The generic task reward catalogue, native selection window, permanent-class filtering and persisted delivery ledger are now inherited from [`rof2-shared-core` commit `b3f795ea642d810d0af75dca39d6dd1f28826385`](https://github.com/nightstalker6669/EQEmu/tree/b3f795ea642d810d0af75dca39d6dd1f28826385). Achievement progress, criteria, providers and quest content are not required or enabled by this branch.

The shared engine is already integrated into the normal source directories. Build this branch; do not merge an achievement branch or reapply historical source overlays. Run its matching updater through schema version 9338 and review the three original supplemental class/shared-task SQL files in [shared reward installation](../../../docs/rof2/SHARED-REWARDS.md). Migration IDs 9331–9334 and their original SQL are preserved. The compatibility migrations retain empty achievement schema scaffolding so a later achievement installation remains compatible; those empty tables do not activate achievements. The original migration 9335 is also retained. The shared core also owns the original 9336–9338 registrations for merchant language, personal exchange policies and durable reward state.

Stage 004 still requires the matching reward-capable binary; the content installer cannot attest which executable is running. A table-only installation on a stock `develop` binary is insufficient.

See [installation and rollback](docs/INSTALL.md), [research and limitations](docs/RESEARCH.md), and [verification scope](docs/VERIFICATION.md).

## Layout

- `data/`: canonical insert/update payloads; no full database dump.
- `quests/`: Kerkaz, ordered rune NPCs/module, The Sklyg and the two HoT teachers.
- `tools/install.py`: read-only planning by default, guarded transactional application, targeted backup and preserving quest-file installation.
- `sql/`: equivalent SQL and original content rollback scripts for review; the installer performs preflight that raw SQL lacks.
- `provenance/`: game-content sources, estimate models and the complete class/tier reward catalogue.

Upstream [GPLv3 licensing](../../../LICENSE.md) applies to the code. Source links identify external research; no external article archive or raw client resource catalogue is bundled.

## Offline acquisition batch

Stages 007 and 008 passed isolated installation, readback, idempotency and rollback validation. It has not been installed on the shared running server. Twenty rank III scroll identities remain unverified; the level 95 rank III shadowknight bundle catalogue explicitly lacks pairing information. Original item 132477 (Shared Savagery III) also conflicts with an inherited Scavenger Hunt Letter. The item and its choice are withheld while ownership/dependencies are researched. These gaps leave 25 source choices omitted. No synthetic scroll IDs, partial bundles or substitute acquisition routes were added.

The achievements maintainer extracted, independently built and published the complete generic engine in the pinned shared-core revision. This branch merges that actual published core while preserving the latest spell content. Review [batch validation](docs/VERIFICATION.md#offline-voa-and-engine-batch) before deployment.

## Further original acquisition routes

Stages 009/010 restore the TSS rune teacher and Underfoot rank II gem trader, plus the separate SoD Kalim in Plane of Time. SoD bard Whirring/Glowing and beastlord Glowing sequences remain wholly withheld because the order or a required scroll identity is unresolved. No missing reward is skipped to reach a later one. The SoD NPC uses independently corroborated public map-label coordinates and a neutral existing Kalim template; exact original heading/noncombat secondary statistics and native placement are not established. The four downgrade combines use the original Mechamagical Metamorpher. See [legacy](provenance/legacy-exchanges.json) and [SoD](provenance/sod-runes-and-downgrades.json) provenance.


Stage011 repairs four original SoF standard faction merchants with exact stock/consumer guards and receipt-owned rollback. Three factions lacking established gain routes remain withheld. See `docs/RESEARCH.md`, `docs/INSTALL.md`, and `provenance/sof-faction-merchants.json`; this does not complete all through-RoF acquisition or native acceptance.
