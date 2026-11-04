# Kerafyrm's Favor missing prerequisite rank

Kerafyrm's Favor (ability 509) currently stops at rank 12890, whose next-rank
reference is 12891. That record is missing, while Kerafyrm's Prismatic Familiar
rank 12892 requires three ranks of ability 509. The current two-rank chain cannot
satisfy that prerequisite.

This repair restores the already referenced identity 12891. It uses explicitly
selected **local reconstruction defaults**, not a recovered May 2013 rank record:

- Cost 2, copied from both preceding ranks.
- Required level 90, selected within the existing House of Thule expansion 17.
- Other metadata and the no-op effect follow the preceding rank's template.
- Prerequisite ability 508 rank 1 (Druzzil's Mystical Blessing), reconstructed
  from the sequence in which ranks 1 and 2 require E'ci's Icy Blessing and
  Ro's Fiery Blessing respectively.

The existing rank 12892 prerequisite 509/3 is retained. The loader inherits the
earlier ranks' prerequisites, so the repaired chain retains those requirements.
No existing cost, spell definition, ownership, AA points or grant is rewritten.

Provenance is the existing rank links, prerequisite rows and retained RoF2 client
description of Kerafyrm's Favor as opening the path to the familiar. Both retained
PEQ catalogs contain the same dangling link. They establish the structural gap,
not the exact historical values selected here. Original rank 3 cost, level and
prerequisite remain open to replacement by authenticated period evidence.

The companion SQL is a MariaDB compound block using an InnoDB transaction. It
checks complete affected preimages under locks, inserts exactly three rows,
checks complete postimages, then commits. Any SQL exception rolls back and is
rethrown. Existing or changed target data causes a stop; do not automatically
retry. Retain the paired application backup/rollback before applying. This is
source-only until coordinated application, cache freshness and validation.
