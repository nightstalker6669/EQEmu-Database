# Bard Burst of Power rank 12

The existing Bard Burst of Power line (ability 3837) has eleven reachable ranks.
Its last row, 12598, points to missing native rank 12599. Allegretto of Battle
(ability 809) requires twelve ranks, so that prerequisite cannot currently be met.

The repair adds the already referenced rank 12599 and its SPA247 triple-attack
skill-cap effect. The retained client description 6540 states five points per
rank; the preceding two effects are 50 and 55. Rank 12 therefore supplies 60
points for skill 76. No new skill mechanic or native identity is invented.

Cost 13 and required level 95 are **local reconstruction defaults**, continuing
the existing VoA costs 9/11 and levels 91/93. Other metadata follows rank 12598.
Expansion 18 follows that chain; the exact original missing row has not been
recovered. The restored known chain terminates here; this does not authenticate
or recreate any further upgrades.

Existing Allegretto prerequisites 3837/12 and 1685/1 remain unchanged. The SQL
checks complete affected preimages under locks, inserts exactly two rows and
checks complete postimages before committing. An exception rolls back and is
rethrown. Stop on unexpected state; do not retry automatically. Retain the paired
backup and rollback. No player ownership, existing row or spell/core definition
changes are included. Offline traversal reaches twelve ranks; SQL execution,
cache freshness and native acceptance remain separate steps.
