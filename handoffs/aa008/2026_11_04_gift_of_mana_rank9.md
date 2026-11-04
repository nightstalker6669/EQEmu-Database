# Restore referenced Gift of Mana rank 9

Gracious Gift of Mana requires nine ranks of Gift of Mana, but ability 495 currently has only eight loaded ranks. Its final row, 13295, explicitly references missing native rank 14491. This proposal uses that existing identity and preserves the nine-rank prerequisite.

The restored rank continues the current level-band proc mechanic. It copies all 144 effects from rank 13295 and appends a 24-row band for spells of levels 96 through 100. The four blocks retain the existing chance, minimum-mana and spell-type filters. Each new block references existing spell 32475, `Gift of Mana 96 to 100`, in place of spell 30644, `Gift of Mana 91 to 95`. No spell definition changes.

This effect set is a **selected local reconstruction of an established mechanic**, rather than a recovered original rank 14491 record. Cost 12, required level 96, expansion 19, inherited SID/passive metadata and termination at the known rank are selected reconstruction defaults. Original client descriptions corroborate the general mana proc but retain older level wording; they do not establish the exact missing rank's values.

The loader inherits prerequisites from preceding ranks. No prerequisite row needs to be added or weakened; the existing root prerequisite remains effective. The migration guards full affected preimages and postimages, inserts one rank and 168 effects, and preserves existing ranks, prerequisites and ownership. A guarded rollback is retained separately.

Offline structure checks confirm the nine-rank chain, the explicit referenced identity and preservation of the prior 144 effects on the restored rank. Current database spell identity checks confirm that both proc spells exist. These are source/configuration facts. The coordinator selected this reconstruction for source publication. This document does not establish database application, historical native authentication or native purchase/proc acceptance.
