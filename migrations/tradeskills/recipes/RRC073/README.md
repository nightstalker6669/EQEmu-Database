# RRC073 two solution vial-return corrections

Adds four explicit return rows to existing Runic Vellum Solution12233 and Fine Runic Paper Solution12239. Each maintained primary formula returns Empty Vial10062x1 and Dirty Empty Vial93618x2 on both success and failure. The current database recipes already match source ingredients, outputs, trivial243 and five physical kits, but omit those vial returns.

Two full recipe definitions and all30 old entries are guarded and preserved. Learning2, ingredient quantities, existing output/kit links and acid/water salvage0 remain unchanged. Four new noncontainer rows encode the exact success/failure counts; both vial items are native stackable/maxcharges0. Rollback requires the exact34-entry postimage and removes only those four rows. No new recipe IDs or primary output producers are created.

These current maintained return facts are qualified: exact May2013 return behavior was not independently established. This patch is ordered after RRC072, whose common-vial producer guards were captured before this correction. No item, NPC/task, spell, player or native action is included.

Source: https://www.eqtraders.com/recipes/recipe_page.php?article=395&rsa=Spell+Research&sub=suspension
