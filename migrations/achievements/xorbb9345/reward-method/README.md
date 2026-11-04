# Xorbb mercenary selectable rewards

Migration9345 defines reward_method6 for tasks3040477–3040487. The deployed engine defines METHODSELECT3 and only admits method3 tasks into its selectable reward catalogue. A task therefore loads without its selectable set. Existing source_type2 bindings/options/rewards are retained.

This additive correction applies **after eleven-task activation**. `apply.sql` changes only method6to3 with all21 canonical task columns guarded, including enabled1. It preserves migration9345 history/checksum, amounts, bindings, activities, housing and player state. Three disabled partisan tasks are outside this correction.

The operator uses its existing strict transaction: snapshot the11 rows, execute apply once, require affected_rows11, then require readback.sql results11method3/0method6 before COMMIT. Otherwise ROLLBACK and stop. No transaction controls, DDL, routines, schema/registry/version updates or retries are embedded; this is not a standalone mysql-import script. Unknown outcomes require reconciliation.

Build then uses its existing task/reward reload and checks actual memory for all11 selectable sets. Reuse completed migration/parser/build evidence; native gameplay/reward acceptance remains pending.

`rollback.sql` requires all11 exact active method3 postimages and reverses only method3to6. Require affected_rows11 and reverse readback0method3/11method6 before COMMIT. Never reset activation or earned state as rollback.
