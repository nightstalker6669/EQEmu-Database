# Dragonscale Hills achievement quests

This package supplies the 15 quests for **Assisting the Ak'Anon Strike Force V**, **Challenges of Dragonscale**, and **Ladies of the Light**. It includes their task journals, achievement bindings, NPC scripts, quest item sources and the rescue encounter.

It is a complete installation. Apply the quest scripts and database changes together through the installer. Installing individual files can leave objectives impossible to finish.

**Release status:** all 15 quests completed in the native RoF2 client; all 15 criteria, all three achievement families and the earned rewards survived a fresh login. Private GM travel and shortened fights accelerated verification; this does not establish exact original combat balance or spawn rates.

Native gameplay used the local combined schema9336 runtime. Native regressions for the branch's newly adopted schema9338 shared engine remain a separate deployment milestone; this content release does not claim them.

## What it contains

| Quest family | Included quests |
| --- | --- |
| Farm and strike force | Three Farm Clean Up tasks, Forgetful Nanzie, A Horse of Course, Construction Junction, Rise of the Machines, I Can Fly |
| Challenges | Kicking Tail, Falrazim's Waggin Tongue, Darwin's Award |
| Ladies of the Light | The Moonfires' Burning Desires, Mash Brownies, The Rescue, The Queen's Demise |

The package adds 15 tasks and 43 objectives. Existing quest givers retain their native positions. Lelluran uses nightmare placeholders in Loping Plains; Agilica triggers two owned guards. The crystal and canvas groundspawns keep their original locations and receive the proper quest item bindings. Falrazim drops his tongue.

These quests use the existing RoF2 task and achievement protocol. **The recovered opcodes and packet structures remain available in the [protocol documentation](../../protocol/)**; this content batch adds no opcode or wire-layout changes. The unfinished Oculus parent chain is not enabled by these leaf quests.

## Install the complete package

Use the matching `rof2-achievements` engine and its normal database migrations. Keep your existing housing, characters and unrelated quest content. The installer adds preserving callbacks and rejects conflicting ownership or changed spawn data rather than replacing custom work silently.

1. Schedule a maintenance window and stop the game services. Leave MariaDB running.
2. Prepare two command arrays: one for the MariaDB client and one for `mariadb-dump`, both selecting the intended database. Prefer a protected MariaDB option file for credentials. Do not place passwords in this repository.
3. Inspect the installation first:

```sh
python3 install.py \
  --mysql-command-json '["mariadb","--defaults-extra-file=/private/eqemu.cnf","peq"]' \
  --quests /path/to/server/quests
```

4. If inspection passes, apply the whole package with a new backup directory:

```sh
python3 install.py \
  --mysql-command-json '["mariadb","--defaults-extra-file=/private/eqemu.cnf","peq"]' \
  --dump-command-json '["mariadb-dump","--defaults-extra-file=/private/eqemu.cnf","peq"]' \
  --quests /path/to/server/quests \
  --backup /path/outside/quests/dragonscale-before \
  --services-stopped --matching-engine-installed --apply
```

The installer checks payload hashes, makes database and quest backups, composes the callbacks, and applies the database changes in one guarded transaction. It does not start or stop services. Inspect its receipt, then restart the matching server so the task cache, quest modules, spawns and ground items load together.

If your server uses additional quest search roots, pass each one with `--additional-quests`. A custom NPC, spell or hand-in owner requires an explicit merge; a failed ownership check is not an instruction to delete that owner.

The examples show the command syntax for a Python/MariaDB environment. They do not claim native Windows acceptance. Keep this package within the branch's supported installation route; Python availability alone does not establish platform support.

## Historical evidence and server defaults

The catalogue cutoff is **May 31, 2013**. [Research decisions](provenance/research-decisions.json) retain dated evidence and contradictions instead of treating current Live headers as original data.

- Confirmed quest XP uses the approved, labelled PEQ-style default of 1,000 where the original raw amount is unknown. Kicking Tail receives no invented XP or faction reward.
- Farm gears require the three farm tasks accepted together and completed in one persistent cycle, following the direct period report. A later period summary says one task; that conflict remains documented. Already-owned lore rewards do not block XP or faction.
- Darwin's Award requires fresh acquisition, following the direct 2010 report. Other period reports disagree on pre-looting.
- Kindly and warmly eligibility follows the running engine's faction rules. Existing **character faction rows are preserved**. The missing NPC faction links are restored, with labelled starting-base and unrecovered kill-hit defaults in [the faction policy](data/faction-restoration.json). That includes a reconstructed Ladies base of -300 and hostile Darkvine/Wind Nymph bases. Actual standing also includes the server's existing race, class, deity, spell and item modifiers. Exact original raw values are not claimed. Edit the policy and run `python3 configure_factions.py` before inspection to regenerate its guarded SQL and affected payload hashes; the command does not contact the database. Custom existing NPC links or faction bases require an explicit merge.
- Lelluran's 5% placeholder weight, inherited PEQ combat baseline, spell timing, guard lifetime and placement allowances are labelled reconstructions. [World restoration data](data/world-restoration.json) identifies them. The runtime Lua data carries the banner and guard settings; spawn weights live in the database payload.

Normal NPC kills, actual corpse/ground-item looting, physical hand-ins and native task persistence provide the ordinary objectives. Banner credit requires the successful consumed-item cast at the claim site. For Kicking Tail, finish the ten-minotaur objective before killing Higoren; the engine's existing first-matching-activity rule is preserved. Guard credit requires the current claimant's triggered actors; a repeated hail cannot accumulate guards or grant free kills.

Backups can contain private account and character data. Keep them outside your public checkout and retain the prior matching engine for a coordinated rollback.

The banner uses the engine's authenticated completed-item-cast fields (`cast_item_id`, `cast_item_slot`, `cast_item_charge_consumed`) on `event_cast`. The item must actually be consumed; ordinary casts and interrupted clicks cannot substitute. This requires the published achievement engine with those fields.
