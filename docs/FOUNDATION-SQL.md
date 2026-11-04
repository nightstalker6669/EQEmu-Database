# Foundation SQL source coverage

This batch adds111existing project migration files: housing90 (explicit installer89 plus separate marker correction), fellowship4, mercenary4 and shroud13. These are our existing SQL source updates, not an upstream baseline archive or live database export. Exact retained application receipts are tracked separately; file publication does not assert every migration is installed. This is not a complete9328-to-current installer.

Each feature migration-manifest pins source hashes and preserves the owner's explicit order. Housing order is the existing installer dependency sequence, not numeric filename sorting. The separately documented personal marker correction has no place in the mandatory sequence and must only apply to its guarded preimage. Companion engine/session infrastructure and matching code are required.

Fellowship files001–003 create character/runtime storage;004 provides597campsite policy definitions coupled to compiled catalogue definitions. Housing inventory/session schemas precede fellowship. Never export fellowship membership, invitations, vitality or XP journal contents with a public snapshot.

Mercenary order is001owned roster,003passive upkeep,004zone permission, then deliberately selected002activation.001/003 and rule_values belong to runtime/character database;004zone permissions belong to content_db.002contains separate rule and catalogue-linked NPC operations: in split deployments its statements must be assigned to the actual respective connections, not run wholesale against either schema. The upstream merc_tables_bootstrap is deliberately excluded: it contains destructive owned-data DROP statements and is not a safe content-only update.

Shroud order explicitly omits002provisional test catalogue and010undistributed research. Included state/snapshot schema migrations create infrastructure, not populated player snapshots. Content upgrades require stopped/drained sessions and exact schema/namespace checks as documented by the owner. No recovery, escrow, bank, original-profile or ownership rows are exported. Historical Live captures and template/default qualifications remain in the original SQL/docs; names do not establish originalMay2013period facts.

SOURCE-INSTALL.md files preserve historical source installation context. Their relative companion links refer to the pinned original source layout; the active migration order and paths in this package come from each migration-manifest. Do not reapply historical C++ overlays to the integrated fork. Current deployment/source/code/native status is separate from SQL-source availability.

No SQL was executed, no client/native tests rerun, and no fixtures/imports created. Original baseline clone and archive redistribution questions stay explicit but do not block publication of our own existing changes. A future full content snapshot will use an explicit table/column scope; runtime/player/custody data are excluded.
