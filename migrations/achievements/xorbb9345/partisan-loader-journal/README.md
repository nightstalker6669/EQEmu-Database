# Xorbb partisan reward and journal correction

This follow-up fixes the same two authoring defects already found and repaired in the eleven Xorbb mercenary quests: selectable rewards must use native `METHODSELECT=3`, and script-controlled objectives need a visible journal type. It covers only the three **disabled** partisan quests: The Halfling Trail, We Have to Go Deeper, and Escape From the Prison of Xorbb.

Exactly three task rows change `reward_method` from6 to3. Four objectives—crater rock, ladder pickup, kitchen stew and spit ham—change `activitytype` from0 (`None`) to5 (`Explore`), retaining `goalmethod=2`. The existing quest scripts still control these objectives; ordinary exploration cannot advance them. Type5 is an emulator display repair, not a claim about original Live packet metadata.

Migration9345 is already applied and must remain unchanged. These scripts are a separate additive correction. No task, reward set, achievement, or script readiness is enabled. The remaining geometry and actual quest acceptance work is still required before activation.

The database operator must capture full rows, use one strict transaction, run the two updates in order, require exactly3 then4 changed rows, and compare every full postimage with its saved preimage. Only the stated fields may differ. The SQL guards all21 authored task columns and all18 authored objective columns; objective updates additionally require their own complete disabled task postimage. Untouched physical schema-extension columns must also match before commit. A mismatch requires rollback and investigation; do not relax guards or retry partial writes. `rollback.sql` reverses the two updates under exact inverse guards. `readback.sql` selects all physical columns at the seven affected identities.

This package is source only until the database owner records application and readback. It requires no server restart or special test run while these quests remain disabled. Use the normal scheduled cache refresh and the existing full partisan milestone for later native journal/reward verification. It contains no player-state, inventory, housing, migration-journal or schema writes.
