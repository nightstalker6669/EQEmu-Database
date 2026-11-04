# RRC062 Alchemy Empty Vial return correction

Proposes correcting six existing Alchemy recipes: the five Black Extract variants (1224–1228) and Sarcoscypha Extract (1398). The maintained primary formulas explicitly return Empty Vial (10062) on failure. The existing rows instead have failcount 0 and salvagecount 1. Change those fields to 1 and 0 so the failed combine returns the vial, without treating that same vial as an additional salvage candidate.

All six recipe definitions and their 48 full entries, including entry IDs, are guarded before and after the update. Exactly six rows change. Ingredient quantities, outputs, trivials, gates, container links, other fields, and global row counts are preserved. The other seven dye formulas already match the source; existing Poison and Brewing counterparts remain unchanged because this source evidence is specific to Alchemy.

This is a maintained-source discrepancy correction, not independently established May 2013 failure behavior. No new recipes, entries, items, player writes, or runtime changes are included. One authorized application requires affected-row backup and exact readback. Rollback accepts the exact postimage and restores the original six field pairs.

Source: https://www.eqtraders.com/recipes/recipe_page.php?article=290&rsa=Alchemy&sub=fpdye
