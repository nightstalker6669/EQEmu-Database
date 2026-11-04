# Buried Sea: island quests, rewards and Jonas Dagmire’s hand

This package supplies the seven Hero’s Journey island quest families and the supporting Mer’s Lost Love currency mission. It targets achievements present by May 31, 2013.

**Native RoF2 milestone passed on Linux:** all 39 island quests, all 27 bone rewards, the Cleric reward from each of the seven armor sets, Mer’s three-member mission and all seven hand-assembly recipes completed. The final hand and saved achievement/reward state survived logout/login. One member performed Mer’s physical voyage while all three received the shared payout. Other armor choices and native Windows gameplay were not individually tested. This milestone does not complete the entire May 2013 achievement catalogue.

## What is included

| Feature | Included behavior |
|---|---|
| Seven island families | 39 native quests and 180 objectives, using their original quest givers |
| Armor rewards | Seven achievement reward sets, 34 class-filtered armor options |
| Skeletal hand | All 27 pieces, seven consumed-compound recipes, durable final-hand achievement credit |
| Merchant | Halon’s complete 106-item stock, Doubloon currency and faction requirements |
| Encounters | Slop/coralisk scene, Silverlip’s brigands and actual corpse drops |
| World sources | Scoped task chests, water/fire totem sources and 36 landmark volumes |
| Mer’s Lost Love | A six-hour shared mission, 3–6 members, average level 70, actual ship/ticket and an owned mission instance |
| Return journey | Original clickable rowboat and ferry routes; no invented direct return to Mer |

Native tasks handle ordinary kills, loot, carried collection and hand-ins. Scripts implement scene mechanics and landmark checks. Reward delivery uses the engine’s persisted occurrence and selection records. Repeating a quest does not unlock extra bones by pretending it was a different quest.

## Install the complete package

1. Build and install the matching `rof2-achievements` engine with its schema migrations through **9335**. This requires the native reward-selection and progression support plus the new boat passenger and owned shared-instance APIs. A stock EQEmu binary cannot run these scripts correctly.
2. Stop server writers and back up the database and quest roots. The installer makes its own additional backup when applying. It does not stop or start services or replace binaries.
3. Run `install.py` without `--apply` to inspect your installation. Supply a MariaDB client command that selects your database and a quest root. Add every secondary quest root with `--additional-quests` so dispatch conflicts can be detected.
4. Apply with a new backup directory, a matching database dump command, `--services-stopped` and `--matching-engine-installed`. Every SQL file, module and callback is required. Application activates the full package; there is no partial or optional-content mode.
5. Check each RoF2 client with `python3 repair_client_ships.py --client /path/to/RoF2`. If ship entries are missing, run the same command with `--apply`, then re-enter Buried Sea. This preserves existing entries and backs up the file. The original local `b04.eqg`, `b05.eqg` and `b06.eqg` assets are required; no client assets are distributed. On Windows, use `py -3` and your Windows client path. Without these entries, this RoF2 client renders the return ferry as a human and cannot board it.
6. Start the matching server and perform native gameplay acceptance before advertising the package as verified.

Linux example, with credentials supplied by your private MariaDB client option file:

```bash
python3 install.py \
  --mysql-command-json '["mariadb","--defaults-extra-file=/private/eqemu.cnf","peq"]' \
  --quests /srv/eqemu/quests
```

Apply the same inspected package:

```bash
python3 install.py \
  --mysql-command-json '["mariadb","--defaults-extra-file=/private/eqemu.cnf","peq"]' \
  --dump-command-json '["mariadb-dump","--defaults-extra-file=/private/eqemu.cnf","peq"]' \
  --quests /srv/eqemu/quests \
  --backup /srv/backups/buriedsea-before-install \
  --apply --services-stopped --matching-engine-installed
```

For Docker/akk-stack, supply a JSON command array that invokes the database client inside the database container, selecting the intended database. Quest paths must point to the host’s mounted quest directory. Use the matching container build for the engine; the installer does not select a container or deployment automatically.

For native Windows, use Python 3 and the native MariaDB client/dump executables in these command arrays, with Windows paths for `--quests` and `--backup`. PowerShell can construct arrays with `ConvertTo-Json -Compress`. Use a matching native Windows engine build. The content installer uses Python filesystem operations and does not depend on Linux process tools. Native Windows gameplay acceptance has not been performed.

## Existing servers and recovery

The installer checks payload hashes, required schema, native identities and script dispatch conflicts. Unknown custom hand-in owners, alternate named/Perl callbacks, changed managed modules or conflicting content rows require an explicit merge. Existing housing/player state is outside this package’s writes.

SQL imports and activation run in one transaction. Exact reapplication is supported. The composer retains existing callbacks and stores their preimages. If SQL fails, it restores the composed quest files. If a connection fails near commit, the database outcome can be uncertain: keep writers stopped and inspect the private installation receipt and database backup before retrying. Never use a database client’s `--force` mode.

## Opcodes and structures

The server exposes passenger information already present in **RoF2 `OP_ClientUpdate` (`0x7dfc`)**. Its canonical movement payload is **46 bytes**, with `vehicle_id` at offset **4**. There is no client executable patch or new opcode mapping. The client model-list repair described above is needed when the original ship assets are not loaded in Buried Sea.

See [transport packet layout and script APIs](../../../../../docs/rof2/transport-passenger-state.md) for the field layout, freshness rule, exact shared-task instance ownership checks and average-level admission policy. Existing achievement and reward protocol documentation remains in the [protocol directory](../../protocol/).

## Historical evidence and remaining limits

[Parent reward provenance](provenance/parent-rewards.json) links the pre-cutoff archives for all seven island rewards. Allakhazam’s external item IDs are mapped by name to native server item IDs; they are not interchangeable.

Missing XP, faction, encounter HP/rates/lifetimes and some scene geometry use approved, labelled emulator defaults where documented in the included data/provenance. These are not recovered original server values. Quest dialogue is paraphrased. Original positions/routes are preserved where the native database supplies them.

Known limits that still need research or native acceptance:

- The exact original chest population/rotation is incomplete; eleven existing scoped chests are supported.
- One inherited jaguar spawn has an invalid height. Its original corrected location is not recovered; the package does not guess a replacement. See [world-source limits](provenance/known-world-limits.json).
- The tavern’s shark-jaws anchor is confirmed in the native RoF2 model. The four selected sirens are confirmed in the native underwater pool scene; their exact historical per-spawn identities remain a labelled reconstruction.
- Mer’s documented 40-Doubloon payout is implemented; the original popularity/scaling formula is unknown. Its faction amount uses labelled current corroboration. No unconfirmed mission XP is invented.
- Armor class filters use native equipment masks. Original reward-window masks and any two-bracer quantity are unverified; each configured option grants one item.
- The final-hand achievement credits the real item, including an installed augment. The period page says no reward, while a period comment mentions weapons without an exact option list. No speculative final weapon reward is configured.
- Native acceptance covered three-member admission, one member’s outward ticketed voyage, four actual siren corpses, the rowboat, the original return/incoming ferries, all three automatic 40-Doubloon payouts, physical currency creation/trade/reclaim, seven paid compounds/combines and one combined logout/login. Privileged travel, damage and a scoped respawn accelerated the checks; original combat balance, ferry timers and ordinary travel pathing are not certified.
- Loose final-hand ownership was verified natively. Installed-augment ownership is implemented by the engine scanner; native augmentation insertion was not exercised in this batch.

Never treat modern Live observations as automatic proof of May 2013 behavior.
