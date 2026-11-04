# RRC059 SoF Tinkering and book-linked Eron formulas

Adds 42 missing formulas: 31 Tinkering, two Eron Brewing, and nine Eron Jewelcraft recipes. The 159 retained primary item references resolve to existing native items. Source quantities, yields, and tool returns are preserved. Of these recipes, 32 require learning from eight existing books, and ten ordinary Tinkering recipes allow experimentation. The 21 cultural recipes require skill 300; Eron's Configurable Setting and Simple Jewelry require 250. Other minimums are zero. The existing Gnome Tinkering restriction remains in the core.

The earlier claim that Eron's book texts were absent came from an incorrect lookup. `books.id` is numeric; `SharedDatabase::GetBook` looks up `books.name = items.filename`. All seven Eron texts and Elegant Gnomish Cultural Tinkering (item 35977, text 5016) exist. The SQL guards each item's filename, book ID, text hash, language, and unique book-name lookup before and after insertion. It writes recipe learning links without changing books, items, or player records. Static inspection confirms the existing ReadBook/ScribeRecipes path supports these bindings; native client scribing and combines have not been tested.

The authored books corroborate learning stages rather than every numeric formula. A dated November 22, 2007 primary forum report supports Blue and Clear Gem Grade Faycite for Eron's Second Setting, with trivial 250, despite ambiguous blue/green wording in the book. Book text is preserved. The maintained formulas and SoF expansion classification are qualified evidence, not an immutable May 2013 database export.

Container links preserve the source toolboxes, brewing barrel class, and exact Jewelcraft kit alternatives. Native anchors have the required four, six, eight, or ten slots; no formula exceeds ten ingredient units. Existing Split Purified Dragonscale Ore (3093107 and its three entries) is guarded for the Half Bar byproduct overlap. Other output collisions stop the transaction. `quest=0` permits ordinary crafted outputs and task updates; `must_learn` and `skillneeded` enforce the recipe requirements.

IDs 3093533–3093574 contain 42 recipes and 400 entries. Application uses a guarded transaction, affected-row backup and readback, and a rollback limited to this batch. No runtime, item, or player changes are included. This publication also corrects the RRC052 book-absence documentation without changing its SQL, recipes, or entries. The two Abysmal Nihilite quest-unlock gaps remain unresolved.

Sources:

- https://www.eqtraders.com/recipes/recipe_page.php?article=420&rsa=Jewelcraft&sub=sof
- https://www.eqtraders.com/recipes/recipe_page.php?article=423&rsa=Brewing&sub=sof
- https://www.eqtraders.com/recipes/recipe_page.php?article=537&rsa=Tinkering&sub=SOF
- https://mboards.eqtraders.com/eq/forum/tradeskills/quests-requiring-trade-skills/31395-the-sof-tradeskill-quest/page5

The first application stopped on a collation mismatch in the book guards. Independent readback confirmed rollback, with target rows absent and the existing producer unchanged. Revision 2 compares exact filenames and text hashes as bytes and preserves the native latin1 book-name lookup for uniqueness. Recipe and entry arrays, learning requirements, and rollback SQL are unchanged. A new application requires the corrected publication pin.
