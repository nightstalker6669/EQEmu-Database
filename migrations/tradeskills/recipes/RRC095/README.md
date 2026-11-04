# RRC095 four Pristine Rough Hide inputs

Corrects one ingredient item ID in each existing recipe11329,11330,11331 and11334: Smooth Rough Hide97767 becomes primary-linked Pristine Rough Hide97768. These are Reebo's Lesser Cleansing, Wuggan's Lesser Discombobulation, Wuggan's Lesser Extrication and Minor Summoning: Water. Each linked maintained-primary formula independently specifies the replacement; this is not inferred from adjacent recipes or the previous080 correction.

Exactly four entry.item_id fields change (138847,138854,138861,138883). All four definitions and29fullentries are guarded before/after. Outputs, quantities, success/failure, salvage, trivials, nofail, learning/minimums and93492kit remain exact. Both hides have verified identity and capacity semantics; the native kit mask15360 remains unchanged. Four bounded all-skill enabled complete-input/effective-kit lookups found no collision. Apply repeats those guards; rollback checks the restored old-input signatures as well.

This is maintained-primary recipe correction, not independent immutable May2013 per-field proof or native crafting acceptance. No recipe/item additions, other kit links, spell/AA/NPC/task/player/runtime changes, output substitutions or resolution of absent starter-scroll IDs are included. Apply once with exact affected backup/readback; rollback accepts only the exact postimage and restores the old input IDs without changing row counts.

Sources:

- https://www.eqtraders.com/recipes/recipe_page.php?article=121&rsa=Spell+Research&sub=Magician
- https://www.eqtraders.com/recipes/recipe_page.php?article=122&rsa=Spell+Research&sub=Necromancer
