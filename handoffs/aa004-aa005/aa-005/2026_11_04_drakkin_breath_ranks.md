# Restore the six Drakkin breath rank chains

Abilities 590–595 currently retain only one rank apiece, despite each first row
pointing to a missing successor. The retained legacy AA catalog declares fifteen
ranks for every line and contains all ninety explicit spell and 300-second reuse
mappings in `aa_actions`.

The May 31, 2013 EQEmu source at commit
`a1080fdb2de4d7400cec72438c14f8ac66b87a4d`, `zone/AA.cpp`, generates rank identities
from the declared base ID plus rank offset. Combined with the retained definitions,
this establishes these native rank ranges without allocating or guessing IDs:

| Ability | Rank range | Legacy spell range |
| --- | --- | --- |
| Breath of Atathus, 590 | 5150–5164 | 11112–11126 |
| Breath of Draton'ra, 591 | 5165–5179 | 11127–11141 |
| Breath of Osh'vir, 592 | 5180–5194 | 11142–11156 |
| Breath of Venesh, 593 | 5195–5209 | 11157–11171 |
| Breath of Mysaphar, 594 | 5210–5224 | 11172–11186 |
| Breath of Keikolin, 595 | 5225–5239 | 11187–11201 |

The SQL adds the missing eighty-four rank rows. Each spell mapping comes from its
explicit legacy action record, rather than arithmetic on spell IDs. Cost remains
zero and reuse remains 300 seconds. Existing ability and first-rank rows are
preserved, including grant-only acquisition and the current timer group 22.
No passive effects or prerequisites are invented for these activated ranks.

Required levels 10, 15, …, 75 for ranks 2–15 are **local reconstruction defaults**
following contemporaneous quest progression reports. Exact original rank packets
are not recovered. Other metadata follows each existing first-rank template.
In particular this restoration preserves the current expansion 3 tag; correcting
TSS-era tags and race/heritage masks is a separate evidence-backed proposal.
Retained legacy data is emulator provenance, not an authenticated native capture.

The guarded MariaDB transaction compares complete affected preimages under locks,
adds exactly eighty-four rows and verifies the complete postimages before commit.
An exception rolls back and is rethrown. Preserve the paired backup and rollback;
any later rollback after acquisition requires coordinator review and must preserve
ownership. No quest, NPC, spell definition or player record changes are included.
Restored definitions do not grant abilities or prove acquisition/native behavior.
