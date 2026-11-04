# RRC067 Elf Essence and Crescent salty-water Poison routes

Adds the missing Make Poison route for Elf Essence and the salty-water variants of Simple Solvent and Simple Universal Suspension. Elf Essence's primary item page and Crown of Deceit guide explicitly list both a Rogue mortar route and a Baking mixing-bowl route. Existing Baking recipe 1872 stays unchanged. The new mortar recipe consumes its four source components, including the physical Elf Essence Recipe paper, and yields one with trivial 15/no-fail.

The two Crescent Reach formulas use Vial of Salty Sea Water (98263), distinct from the existing Abysmal-water variants 304/305. Names follow the explicit Learned As labels. Each yields one, with trivials 38 and 31. The TSS guide instructs an initial manual experiment and learning on success before auto-combine. Native must_learn=2 implements that flow; no mandatory book or invented NPC teaching is added.

Exact source kit links are preserved. Elf Essence uses Mortar and Pestle 17904. The salty variants use 17904, 17110, 17139, and 17190. Acrylia Mortar 17110 has native bagtype 30; the others use 12. Their existing types, capacities, and ingredient-size compatibility are guarded. Core Rogue restrictions remain intact.

Three old producer definitions and 17 full entries are guarded before/after. Old recipes, quantities, trivials, learning flags, and container links remain unchanged. Enchanted Velium Powder's existing numeric difference and the explicitly unconfirmed Reddish-Brown Powder are separate holds.

IDs 3093611–3093613 contain three recipes and 20 entries. Crown guide metadata shows creation in 2003/modification in 2010; the Crescent guide was created in 2006 and modified in 2021. These current mutable views support qualified PoP/TSS context, not immutable historical snapshots or native client acceptance. No NPC, item, player, or runtime changes are included. Use guarded transaction, affected-row backup/readback, and batch-limited rollback.

Sources:

- https://www.eqtraders.com/recipes/recipe_page.php?article=383&rsa=Make+Poison&sub=quest
- https://www.eqtraders.com/articles/article_page.php?article=q56
- https://www.eqtraders.com/articles/article_page.php?article=q248
