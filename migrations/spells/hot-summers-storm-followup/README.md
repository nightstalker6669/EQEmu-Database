# Summer's Storm: original Rotharran stock follow-up

The November10,2010 EverQuest patch notes explicitly added Spell: Summer's Storm to Rotharran Radhelm. The retained patch text is readable in [Bastion's preservation archive](https://bastiongame.com/library/patches/2010-11-10-1), which identifies two source-file occurrences. This is preserved original patch-note text on a modern third-party site, not an official server artifact or a dated snapshot of today's vendor page. The current EQResource Rotharran list omits this scroll; modern Allakhazam lists only PoK's Pathfinder Sweeneph. Those modern omissions do not override the explicit original addition.

Existing native item125184 teaches spell25495 to Ranger89, rankI. This restores only one row at merchant700070/slot356. It does not replace the modern catalogue or change any spell/item definition. The original individual price and standing were not recovered:30DreamMotes andIndifferent are labelled configurable defaults consistent with the restored ordinary rankI cohort. No exact historical price claim is made.

The existing native currency22→DreamMote52149 and faction680 binding remain unchanged. All355 prior stock rows, including158 unavailable nonspell rows behind the pending content flag, are preserved. After this addition there are198 available spell rows, within the native255 alternate-merchant packet limit. GM80 zone access, actors, loot, other consumers and player property remain unchanged. Original nonspell progression remains unfinished.

Default invocation of apply_database.py prints an offline plan without connecting. Coordinated manual apply requires a private configuration and new receipt directory. It guards the exact full current merchant catalogue, sole NPC consumer, complete item/spell/NPC preimages and native currency binding; requires an InnoDB merchant table; durably backs up preimages; inserts one row in one transaction and compares the full356-row postimage. Prepared-only receipts require reconciliation before any retry. No active installer stage or runtime Lua is introduced.

Source publication precedes any live apply. After actual apply, route affected merchant-cache freshness through JARVIS/Build under current tester ownership. No private restart, repop or client input. Source readiness is not native purchase/currency-debit acceptance.

## Applied status,2026-11-04

One row merchant700070slot356/item125184 committed; full356stockpostimage+independentreadbackPASS

Prior355exactunchanged;198spellrows/158pendingnonspellsfiltered

BuildSUMMER-STORM-CACHE-FRESHNESS-001: actualnativefilter198cost30spellrows/158heldexcluded;125184->25495/gate0verified;Feerrott700unloaded,nextordinaryfreshbootready,noreload/restartrequired

False

30Motes/Indifferentlabelledconfigurabledefaults

https://www.redguides.com/community/threads/everquest-game-update-notes-november-10-2010.23163/post-186930 contemporaryNov10,2010repost
