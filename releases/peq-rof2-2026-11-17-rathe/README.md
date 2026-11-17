# PEQ RoF2 — Rathe, Void E and Journeyman V

Match the server and eight Rathe quest files using the source manifest and release inputs.
The release covers seven group-progression tasks, Murdunk, earned Void E,
Korafax admission through the four group themes, and Journeyman V.
See NATIVE-QUALIFICATIONS.json for the observed routes and fixture limits.

Use MariaDB 10.11 with a DELIMITER-aware client that stops on the first error.
Choose exactly one database path:

- **Fresh empty database:** import full.sql. It contains the exact published
  Field of Scale seed plus Rathe with all five Disrupt definitions at step 1.
- **Existing published Field of Scale database without Rathe:** back up, stop
  writers, and run migrations/rathe/APPLY.sql against the selected database.
  Use the matching server before resuming gameplay. This migration installs
  final step 1 directly.
- **Existing Rathe with all five Disrupt definitions at step 0:** back up, stop
  writers, and run only migrations/rathe/002_disrupt_parallel_prior_rathe_only.sql.
  It changes five definition fields and preserves earned character progress.
  Refresh the task definitions before continuing gameplay.

The fresh import can replace tables and is for empty databases only.
The guarded upgrades stop on mismatches. Keep a receipt and inspect the result
before any recovery after an error. Managed EverForge volumes still carrying
the exact Field of Scale ready digest have a separate guarded marker transition
after final content is present. See migrations/rathe/UPGRADE-CONTRACT.json.

The seed preserves 463 tables, one view and all 331 existing Housing JSON
members. It contains 3,053,042 public static rows. It is built from released
data and public definitions. Player and operator databases, mercenary
contracts, QA tooling, and recovery backups are excluded.

Verification reuses applied database receipts and scoped native acceptance.
Package preparation does not establish a new fresh-import or runtime result.
