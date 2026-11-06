# AA024: Guardian of the Forest rank 19

Source proposal only. Publication and Database application remain coordinator routed. Preparation did not execute SQL, edit spell content, build, deploy, refresh caches or perform native testing.

The rendered [November 8, 2012 revision](https://everquest.allakhazam.com/wiki/EQ:Guardian_of_the_Forest?oldid=448491), timestamp 16:25:24, identifies Ranger activated ability 184 with a 15-minute reuse. Rank 18 costs 12 at level 88/House of Thule and casts spell 23640. Rank 19 costs 12 at level 89/House of Thule and explicitly casts spell 23641. Level 89 is taken from this actual row; it is not interpolated from a generic three-rank expansion pattern.

The visible history's earlier November 8 edit note says expansion labels were filled to match spell-ID groupings. The selected HoT value also agrees with inherited native predecessor expansion 17. This is a qualified period/native encoding selection, not independent proof of an original packet's era field. Later native AA rank IDs remain unknown even where the dated page provides later costs, levels and spell bindings.

Fresh read-only observations confirm ability 184/root 545 and predecessor 10760/rank 18 explicitly pointing to missing 10761. The predecessor has zero AA effect/prerequisite rows; target 10761 is absent from all three rank tables. Existing spell 23641 has the name Guardian of the Forest.

Add exactly rank 10761 with previous 10760, cost 12, level 89, expansion 17, spell 23641 and finite next=-1. Inherit native hotkey/title/description fields 545, AA timer type 3 and reuse 900 seconds. Add no AA effects or prerequisites. The later rank-21 Alaran requirement does not add a prerequisite to this rank-19 payload.

The period spell binding is authenticated by the dated table. Every field or effect of the currently installed spell row is not thereby certified historical. No spell-content repair, new mechanic or native acceptance is included. The finite next=-1 bounds this reconstruction and does not establish historical termination or authorize guessing later IDs.

The MariaDB anonymous block guards exact ability/predecessor preimages, zero predecessor effects/prerequisites, target absence, existing spell 23641/name identity and the exact inserted rank postimage in one transaction with rollback/resignal on error. The spell check verifies identity, not a full spell-content preimage. Delta: one rank and zero effects/prerequisites; no existing-row, ability, spell, ownership, points or charge edits.

Rollback requires the exact new rank, zero target effects/prerequisites and no root 545 owner with 19 or more ranks. It removes only the new AA rank. Spell 23641 and player data remain untouched; subsequent dependencies or drift require coordinator review.

Evidence: rendered dated history/revision, retained inventory and bounded fresh read-only observations. Database application requires its separate exact GO after publication. Build and native gameplay acceptance remain separate work.
