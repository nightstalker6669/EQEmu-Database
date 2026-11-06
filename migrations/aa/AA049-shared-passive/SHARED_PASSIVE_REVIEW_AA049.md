# Remaining shared passive review: AA049

This unit reviewed four new dated pages through May 31, 2013. One shared melee rank qualifies for a source proposal; three contracts remain held. One unchanged Hastened Banestrike page was also reread and is excluded from the new-page count. These are unit counts, not completeness measures.

AA049 adds Burst of Power ability 3833 rank 19, native ID 12592: cost 15, level 93, Veil of Alaris. The [November 30, 2012 revision](https://everquest.allakhazam.com/wiki/EQ:Burst_of_Power?oldid=451572) has a distinct Berserker/Monk/Ranger/Warrior table and specifies five points of triple-attack skill cap per rank. The native rank-18 effect is SPA 247, cumulative 90, skill 76. The proposed effect is cumulative 95, skill 76. Current source maps skill 76 to Triple Attack, retains the greatest cap addition and adds it in the client skill-cap calculation.

The ability name has a trailing space, retained exactly. Native type 2, class mask 32841 and all other eligibility metadata remain unchanged. Separate Bard/Beastlord, Rogue and knight lines on the page do not authorize a class or effect merge. Rank 20 has dated purchase fields but no authenticated native identity here.

The three held contracts are [Companion's Agility](https://everquest.allakhazam.com/wiki/EQ:Companion%27s_Agility?oldid=454864), [Overpowering Strikes](https://everquest.allakhazam.com/wiki/EQ:Overpowering_Strikes?oldid=448970) and the separate hybrid [Gift of Mana](https://everquest.allakhazam.com/wiki/EQ:Gift_of_Mana?oldid=449708). Their immediate successors lack required purchase fields or matching ordinal contracts. Gift of Mana has a period/native class-header discrepancy; no mask change is proposed.

Preparation creates one guarded transaction and rollback. Forward checks authenticate the exact ability/predecessor/effects/prerequisite preimages, absent target identities and exact postimages. It inserts one rank and one effect, with no new prerequisites or existing ability/spell/character writes. Rollback removes only those two rows and refuses removal if a character owns rank 19 or higher of native root 6409.

Validation is dated rendered evidence, read-only current database metadata, static native encoding and generated-payload review. SQL has not been applied. Builds and native triple-attack skill-cap acceptance are separate and unproven. Banestrike's earned delivery, target and actor dependencies remain held under the existing contract.
