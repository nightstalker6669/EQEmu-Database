# Dragons of Norrath two-handed piercing reward repair

Power of the Dark Reign (ability 474, rank 1364) and Power of the Keepers
(ability 479, rank 1369) currently give their 40% melee critical-chance modifier
to individual weapon skills, including 1H Piercing, but omit 2H Piercing.
The SQL adds that same modifier for skill 77 to each existing rank.

The retained RoF2 `eqnews.txt` records the April 17, 2013 extension of applicable
AAs to two-handed piercing. Its SHA-256 is recorded in the private application
manifest. The retained client title/description strings 1364 and 1369 describe
both rewards as affecting melee critical hits. EQEmu `common/skills.h` identifies
2H Piercing as skill 77, and `Mob::ApplyAABonuses` handles SPA 169 for that skill.
Slot 15 is a free emulator storage slot; it is not an asserted original wire slot.

The application owner must compare the complete ability, rank, prerequisite and
effect preimages; require no existing SPA169/skill77 or occupied slot15 on either
rank; then insert and verify exactly two rows in one transaction. Stop on any
unexpected state or error. Preserve all original rows and player data. The paired
private rollback removes only the exact two inserted rows.

This changes AA data only. Acquisition, costs, rank identities and eligibility
are preserved. The data has not been deployed or accepted in a native client.
