# Drakkin breath race and heritage restrictions

This separate migration changes only twelve fields on abilities 590 through 595: set each race mask to Drakkin (32768), and heritage masks to 1, 2, 4, 8, 16 and 32 respectively. It does not change AA ranks, spells, timers, expansion tags, acquisition quests or player ownership.

The retained legacy definitions encode these six abilities as category 8 with `aa_expansion` values 523 through 528. In cutoff source commit `a1080fdb2de4d7400cec72438c14f8ac66b87a4d`, `zone/AA.cpp` lines 1217–1235 interpret those values as base race 522 (Drakkin) and `GetDrakkinHeritage()+523`. This legacy field encodes racial eligibility, rather than an expansion number. The current server uses explicit race and heritage bitmasks for the same checks.

The existing rows instead allow every player race and heritage. A focused existing-owner check found one non-Drakkin character holding rank 1 of all six abilities. The selected policy enforces the historically supported restrictions for all characters, including that existing owner, with no grandfather exception. All six abilities will fail the normal eligibility checks for that character. Their six ownership rows remain intact; no deletion, refund, free grant or player rewrite is part of this migration.

The migration checks the exact six target race/heritage preimages and postimages in one guarded transaction. Historical source supports these restrictions. It does not establish the authenticity of the currently inherited expansion 3 or timer 22, restore missing quest grants, or prove native AA-book and activation behavior. The separate AA005 rank restoration remains independent.

The human policy decision selected this source package for publication and coordinated application. This document does not establish database application, cache freshness or native acceptance. The reverse migration restores only the same twelve reviewed eligibility fields, with exact postimage guards; it does not rewrite player ownership.
