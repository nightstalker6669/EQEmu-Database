# RRC063 Powdered Glowrock manufacturing routes

Adds three missing recipes for Powdered Glowrock (33250): Alchemy in a medicine bag, Jewelcraft in a jeweler's kit, and Make Poison in a mortar and pestle. The retained primary item page explicitly lists all three routes with the same inputs and trivial 102. Each consumes one Glowrock (32694), requires a Gem Cutter (16883), and returns that cutter on success and failure. Yield is one. All 14 primary item references are present.

These are separate source skill/container routes. The existing Shaman/Alchemy level and Rogue/Make Poison core restrictions remain in place. No source book or minimum skill requirement is specified. Native container classes and capacities are guarded; two ingredients fit the smallest four-slot kit. A fresh all-skill net-output scan found no existing producer. Cutter returns have zero net output and do not create a powder-output collision.

IDs 3093605–3093607 contain three recipes and 12 entries. Maintained DoDH Smithing display-panel formulas use this powder, supplying an inherited by-DoDH availability estimate (expansion 10). That context is not an independently dated introduction of each manufacturing route or an immutable May 2013 export. Native client acceptance is not claimed.

Application uses a guarded additive transaction, affected-row backup/readback, and a rollback limited to this batch. No item, player, or runtime changes are included.

Sources:

- https://www.eqtraders.com/items/show_item.php?item=21347
- https://www.eqtraders.com/recipes/recipe_page.php?article=350&rsa=Smithing&sub=dodh
