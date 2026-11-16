PEQ RoF2 — Kithicor, earned Void C and Journeyman III

Qualified matched database artifact, prepared 2026-11-15. GitHub owns commit/push/release as one coordinated source, quest, database and release-inputs batch. Source capture is37nativefiles/18quests from r11 on accepted r24base99c11623. Final Git integration commit is recorded separately by GitHub; the exact source hashes are in SOURCE-MANIFEST.json.

Fresh installation: full.sql is ONLY for a new empty peq_full database on MariaDB10.11. It replaces tables. The sanitized seed contains459base tables,oneview and3052212public static rows, including1100Kithicor rows with six ordinary-Give victual NPCs atclass1. No serving database dump was used. Existing published content and331Housing JSON files are preserved. The fresh snapshot restores canonical native public FLOAT values after text dump/import.

Existing player volumes: back up and stop the server; follow migrations/kithicor/UPGRADE-CONTRACT.json. Apply001 additive feature migration, verify postconditions, then002 exact managed old-ready seed-digest transition. Do not import full.sql, reseed, adopt an unknown marker, use --force or blindly retry partialDDL. The separate003class-only integration body is for a compatible existing feature and is not a standalone SQL script.

Four private runtime tables are schema-only and empty by sanitized construction. No QA/player/inventory/bank/history/occurrence/mercenary contract/journal values or counts are published. No QAstatus/GM/level/position fixture is included. The development damage-cap override is excluded: public Combat:LevelToStopDamageCaps remains0. Original external RoF2 assets/maps and the matched source/quest cohort remain required.

Native qualification: six tasks, both real shared recipients, earned original Door20→VoidC, native vendor purchase/scribe and ordinary J3 healer offer/hire passed.

- Both physical r8 escort stages/refugee gates and both recipients native shared rewards passed. Positioning fixtures are separate from walking/admission proof.
- The r11 Colonel homing fix has source, focused mock and staged-file qualification only; a fresh full native r11 walk was not observed.
- Guard614 was observed walking then homing; causes for615/616 remain unproven. No all-guard-walk GO is claimed.
- Peer NPC-ready return remains unproven; peer used its owned AA exit.

These bounds are part of the accepted qualification, not claims of unobserved native behavior. See SOURCE-CONTENT-BINDING.json, NATIVE-QUALIFICATIONS.json and VALIDATION.json.
