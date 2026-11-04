# Ekaterina — Save the Queen

This content package adds all five **Ekaterina's Lament** tasks and their five achievement requirements: Ekaterina's Lament, It Can't Be the Queen, Find the Cure, Parts For a Cure, and Tunare Save the Queen. It uses the original Ekaterina, Ramona and Queen Nhyalea NPCs, existing creature drops, and the confirmed **Flowing Watersilk Robe** reward.

**Source candidate: not installed or verified in game.** These tasks use the branch's existing native achievement/task opcodes and structures; this package adds no new protocol mapping.

## Quest behavior

The northern waterfall supplies a real water sample when an active player reaches it. Ekaterina then sends the player to investigate three locations and defeat the three specified creature groups. Every original level variant of those creatures can count.

Ramona requires fresh Puma Paw, Mountain Recluse Venom Sac and Snake Fang loot from **Blackfeather Roost**. Existing items found elsewhere cannot satisfy those loot objectives. Existing native drop tables stay unchanged. After the actual ingredient hand-ins, Ramona supplies the antidote; Ekaterina asks the player to deliver a cure to the Queen.

The final actual antidote hand-in starts the Queen's attack. Existing nearby guards assist; protectors can cast genuine Complete Healing, as reported in 2009. Killing the Queen without first delivering the cure does not complete the task. Returning to Ekaterina finishes it and grants the native item/XP reward.

Occupied cursors and failed supply creation do not silently advance the sample or antidote objective. Banked quest objects are retrieved rather than duplicated. If an accepted final quest has lost its antidote, request **cure** from Ekaterina. Scripts do not grant kill credit, substitute inventory counts for loot events, or finish quests from a timer.

## Complete installation

Use the matching `rof2-achievements` engine and the existing Mesa inventory/Blightfire hand-in modules. Run `install.py --help` for the supported arguments. The installer requires the database client and dump commands as JSON argument arrays, the server quest directory, and a new backup directory outside that quest directory.

Without `--apply`, it checks affected script compatibility without writing. With `--apply`, it backs up the affected content rows and scripts, runs **both required SQL files**, composes the global hooks, and installs the complete script manifest. Custom scripts or aliases require composition; unexpected content is never silently overwritten. Player and housing tables are not modified.

Linux and Akk-stack installations can pass their local/container database commands. Native Windows users can run `py -3 install.py` and pass full paths to the MariaDB/MySQL client and dump utilities. Paths with spaces are handled as separate JSON array arguments. Use a client option file for credentials. Native Windows runtime execution remains unverified.

Install with the affected runtime stopped or safely coordinated; restart services after a fresh installation so NPC spawn hooks and native task caches load together. The installer does not control services. Do not retry a partial installation blindly: retain and inspect the saved error and backups first.

For rollback, stop the affected runtime, restore the backed-up quest scripts, run `040-disable-save-queen.sql`, then `020-rollback-staged.sql`. Rollback refuses altered rows or active task references and does not delete player completion history or earned rewards.

## Historical evidence and limits

The five walkthroughs were entered in October 2006. Their period comments confirm locations, fresh Roost loot requirements, the rare Snake Fang drop, and protector Complete Healing. Research and configurable server defaults are recorded in `provenance/`.

Original raw XP and numerical faction rewards are unavailable. XP uses the approved labelled 1,000-XP default; unverified faction amounts are omitted. Original admission minima and exact trigger/assist/casting tolerances are unverified and labelled accordingly. The fourth task's final “return with the cure” is implemented as an actual antidote delivery; its original native activity-type record has not been recovered. The parent achievement's independent reward configuration is preserved.
