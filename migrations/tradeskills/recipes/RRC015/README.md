# RRC015 Research Combat Spellbook

Adds the missing Research variant of Combat Spellbook: Mystic Ash x1, Piece of Parchment x5, Writing Ink x1; yield1, trivial375. Requires scribing Merchant Alliance Tradebook81108. The source has no explicit minimum Research skill, so skillneeded remains0.

Only the five source-linked named research kits are allowed. There is no generic BagType11 entry. The existing Tailoring3091271 variant is preserved with full recipe and logical entry guards; only this exact existing variant may share output81122.

Source: https://www.eqtraders.com/items/show_item.php?item=40423 . Current game-authored Tradebook names both Research and Tailoring methods. The April29,2013 player report at https://pixelnomad.ca/2013/04/ supports book availability; the current rendering has a later2019 edit. Maintained/current and cached item pages support identities and formula values, not immutable May2013 numeric receipts. Four kit identities use cached primary pages; Song kit and formula refs have retained direct HTML.

MariaDB10.11 source proposal only. Apply is additive and exact-reapply guarded; rollback requires the whole unchanged target and refuses learned references. Named kit masks/capacity, book identity, target postimages, output/name collisions and global count deltas are checked. No character, item, rule, cap or engine changes. Book scribing does not retroactively grant this new recipe to prior readers; no character backfill is included.

Not rehearsed, applied, or native accepted. The private handoff defines18 bounded fixture cases including postinsert rollback and counterpart conservation. GitHub publication, rehearsal and production windows follow coordinator routing.
