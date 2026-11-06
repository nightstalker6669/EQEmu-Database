# AA023: Auspice of the Hunter rank 15

Source proposal only. Publication and Database application remain coordinator routed. Preparation did not execute SQL, change spell content, build, deploy, refresh caches or perform native testing.

The rendered [November 8, 2012 revision](https://everquest.allakhazam.com/wiki/EQ:Auspice_of_the_Hunter?oldid=448479), timestamp 16:00:11, identifies Ranger activated ability 462 with a 15-minute reuse. Rank 14 costs 12 at level 88/House of Thule and casts spell 23553. Rank 15 costs 15 at level 90/House of Thule and explicitly casts spell 23554. The dated table also supplies later VoA requirements/bindings, but later native AA rank IDs have not been authenticated.

Fresh read-only observations confirm ability 462/root 1345 and predecessor 10741/rank 14 explicitly pointing to missing 10742. The predecessor has no AA effect or prerequisite rows, and target 10742 is absent from all three rank tables. Spell 23554 already exists with the name Auspice of the Hunter; its current cast time is 1,000 ms and spell-row recast is zero. The AA timer supplies reuse independently.

Add exactly rank 10742 with previous 10741, cost 15, level 90, expansion 17, spell 23554 and finite next=-1. Inherit native hotkey/title/description fields 1345, AA timer type 6 and reuse 900 seconds. Add no AA effects or prerequisites. Rank 16's later Alaran requirement is outside this rank-15 payload.

This authenticates the rank's period spell binding and reuses the existing native timer layout. It does not certify every field or effect of the currently installed spell row as historical. No spell-content repair or new mechanic is included. Native behavior and client acceptance remain separate evidence. The finite next=-1 does not establish historical termination or authorize guessing later IDs.

The MariaDB anonymous block guards the exact ability/predecessor, zero predecessor effects/prerequisites, target absence, existing spell 23554/name identity and exact new rank postimage in one transaction with rollback/resignal on error. The spell check verifies identity and does not overwrite or assert a full spell-content preimage. Delta: one AA rank; zero AA effects, prerequisites, existing-row, ability, spell or player-data edits.

Rollback requires the exact new row, zero target effects/prerequisites and no root 1345 owner with 15 or more ranks. It removes only the new AA rank and leaves spell 23554 and player data untouched. Any subsequent dependencies or drift require coordinator review.

Evidence consists of the rendered dated history/revision, retained inventory and bounded fresh read-only observations. Database application requires a separate exact GO after publication. No build, cache campaign or native test is part of this package.
