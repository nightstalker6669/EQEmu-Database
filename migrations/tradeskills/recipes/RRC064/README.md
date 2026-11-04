# RRC064 Make Poison dye returns and Marble Mortar links

Corrects two existing Empty Vial failure/salvage pairs and adds ten container links to existing dye recipes. The Make Poison primary catalogue was reviewed separately from Alchemy. Of its eleven dye formulas, nine already match all non-container roles; two Black Extract variants lack the explicit Empty Vial failure return. Their entry IDs 1563 and 1569 change only failcount 0 to 1 and salvagecount 1 to 0.

Ten source formulas explicitly list Marble Mortar and Pestle (17139), but their database recipes only have the other mortar links. Add one container entry to recipes 214–218, 243, 255, 282, 290, and 296. Russet Extract (295) has no explicit Marble Mortar link in this source view and remains unchanged. Native 17139 is an existing ten-slot Make Poison container (bagtype 12); no item definition changes.

All eleven recipe definitions and 66 full existing entries are guarded. Existing fields change only in the two reviewed vial pairs; exactly ten container rows are inserted. Recipe IDs, names, inputs, outputs, yields, trivials, skill/learning settings, old container links, other-skill counterparts, and player records remain unchanged. Rollback requires the exact 76-entry postimage, removes only the ten added links, and restores the two field pairs.

This is a qualified maintained-source correction; exact May 2013 return/container behavior was not independently established. No new recipes, item allocations, runtime code, or native client actions are included. Application requires affected-row backup and exact readback; no new rehearsal suite.

Source: https://www.eqtraders.com/recipes/recipe_page.php?article=290&rsa=Make+Poison&sub=fpdye
