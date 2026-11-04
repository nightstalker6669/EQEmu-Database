# Centaur’s Troubles in Gorukar Mesa

This package adds the complete four-quest route from **Scout Madu to Klassr**: exploration, hunting, investigation and defeating the Shade of Corruption. It includes **15 objectives, four achievement links, the final choice of one Fieldstrider reward, and the centaurs’ corruption-state changes**.

**Deployment and the combined in-game check are still pending.** Existing task/reward machinery is reused; no C++ build or client modification is introduced by this content package.

[Achievement opcodes and packet structures](../../protocol/README.md) · [Historical research](provenance/research.json) · [Exact server settings and labelled defaults](provenance/server-settings.json)

## What players do

1. Hail Madu and ask about **centaur**. Find the friendly camp, speak with Klassr, defeat four widows, eight highland snakes and two harpies, then report back.
2. Ask Klassr about **trust** or say **willing**. Defeat eight generic centaurs while the original Shade is alive, then report back. Named NPCs and the friendly camp’s guards are excluded.
3. Ask about **research**. Visit four ordered locations and return.
4. Offer to **kill the shade**. Defeat it and return for one item: a **Fieldstrider Chain Belt, Ceremonial Mantle or Blanket**.

Madu retains his existing armor and Dromrek quests. Klassr’s dialogue follows the current step. Only one quest in this chain can be active at once; later stages require their predecessor. Living centaurs change population/reaction when corruption changes; already-dead spawns keep their normal timers.

## Install everything together

Use the `rof2-achievements` branch with its achievement catalogue, reward engine, and earlier `mesa`/`mesa-remaining` content installed. You need **Python3, MariaDB and its dump utility**. Stop game services before applying this upgrade; leave MariaDB running. Run from this package directory, replacing the example paths and database name.

The installer backs up **affected rows and quest files**, imports every required forward SQL file and installs/composes every script. There are no optional pieces to select. It never starts or stops services.

### Linux

```sh
python3 install.py \
  --mysql-command-json '["mariadb","--defaults-extra-file=/private/eq.cnf","peq"]' \
  --dump-command-json '["mariadb-dump","--defaults-extra-file=/private/eq.cnf","peq"]' \
  --quests /path/to/server/quests \
  --backup /path/to/backups/mesa-centaur --apply
```

### Native Windows

Run in PowerShell; WSL is not required:

```powershell
py -3 install.py --mysql-command-json '["C:/MariaDB/bin/mariadb.exe","--defaults-extra-file=C:/private/eq.cnf","peq"]' --dump-command-json '["C:/MariaDB/bin/mariadb-dump.exe","--defaults-extra-file=C:/private/eq.cnf","peq"]' --quests C:/EQEmu/server/quests --backup C:/EQEmu/backups/mesa-centaur --apply
```

Native Windows execution of this package has not been performed.

### Akk-stack

Run from your stack directory, using the installer’s absolute path. Match your database service and host quest mount:

```sh
python3 /path/to/mesa-centaur/install.py \
  --mysql-command-json '["docker","compose","exec","-T","mariadb","mariadb","--defaults-extra-file=/private/eq.cnf","peq"]' \
  --dump-command-json '["docker","compose","exec","-T","mariadb","mariadb-dump","--defaults-extra-file=/private/eq.cnf","peq"]' \
  --quests /host/path/to/server/quests \
  --backup /host/path/to/backups/mesa-centaur --apply
```

After successful installation, restart game services before reconnecting. If installation stops, inspect the saved error and backups while services remain stopped; do not blindly repeat a partly completed upgrade.

## Historical accuracy and defaults

The cutoff is **May 31, 2013**. Period reports establish the quest chain, counts, exploration points, Shade-dependent kills, summoning, root/snare immunity, ordinary see-invisibility, named spells and final reward choices.

Some numbers remain reconstructed. They are documented rather than presented as original Live data:

- Quest XP defaults to **1,000**; existing modifiers and caps apply. XP is granted at completion, with no second XP grant when claiming the item.
- Exploration bounds use tolerances around period-reported positions. Generic centaur eligibility follows the broad April2012 report and the original spawn/type inventory.
- Shade HP/minimum damage use PEQ/native defaults. The377 damage cap is a proxy from an observed period hit, not recovered raw Live database data.
- Its40–45minute respawn interval follows a March2013 report; the distribution is reconstructed. The200-unit corruption aura reuses the native spell range; the original environmental extent is unknown.
- Internal reaction groups reproduce baseline hostile/indifferent behavior, but do not model personalized historical Fieldstrider/Foulblood reputation. Unknown quest faction-award amounts are omitted. No original admission minimum is asserted; unrestricted admission is a server policy.
- Original spell-selection frequencies and exact summoning timing remain unverified. Existing native AI/core defaults are used.

The achievement’s parent reward is separate from the final task item choice and remains outside this package’s completion claim.

## Recovery and evidence

Required forward SQL is **010 → 030 → 050 → 070**. Exact reverse operations are **080 → 060 → 040 → 020**; use only the stages appropriate to the completed installation, with game services stopped. Player achievement progress, task history, reward ledgers, inventory and housing are not deleted by these scripts.

Earlier task and reaction-group SQL rehearsals passed; the initial task rollback FLOAT comparison failure was retained and corrected. Later target/profile/default additions reuse that mechanism and have not been separately rehearsed. Source checks are not native gameplay acceptance. Tests, raw captures, private player data and client assets are excluded from this package.
