# RRC075 exact Yaeth page inputs for two LoY swatches

Corrects only the ingredient item IDs on existing Argli Scribed Swatch518 and Visage Scribed Swatch947. Their linked primary formulas explicitly require Yaeth page73 right65410 and page78 right65412; the database uses lookalike IDs65411/65413. Native display names alone are identical, so the retained primary linked IDs identify the intended ingredients. Quantities and every other field are preserved.

Two recipe definitions and34 full entries are guarded before/after; exactly two item_id fields update. A bounded all-skill active exact-input/effective-container review found no collision, and the application repeats that concrete collision guard. New-page sizes are no larger than the old inputs. Existing output/trivial142/learning0/salvage and all legacy/Spell Research kit links remain unchanged; the current five-kit-versus-legacy history conflicts are separate holds. No new kit links, IDs, items, player, NPC/task, spell or native changes are included.

The maintained LoY primary category and its2005 modification metadata supply qualified context, not an immutable May2013 record of every field. Native acceptance is untested. Apply once with exact affected backup/readback; rollback accepts the exact postimage and restores the two original ingredient IDs without changing row counts.

Source: https://www.eqtraders.com/recipes/recipe_page.php?article=125&rsa=Spell+Research&sub=loyek
