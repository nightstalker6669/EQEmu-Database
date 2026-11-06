# Healer passive review — AA041

Seventeen new dated pages across Cleric and Druid passive units through May31,2013 yield one qualified reconstruction and16 held successor contracts. Prior holds and applied scopes are reused separately.

[Wrath of the Forest Walker, November3,2012](https://everquest.allakhazam.com/wiki/EQ:Wrath_of_the_Forest_Walker?oldid=447382) lists rank2 at cost11, level92, Veil of Alaris. Native rank14244/ordinal1 has cost9/level91 and points to14245. Add14245 only, with SPA286 flat damage200 and four native focus-limit rows copied unchanged. Existing Alaran Advanced1685/1 stays inherited; ability mask32, ownership root14244 and string fields14244 remain unchanged.

The magnitude needs an explicit evidence qualification. The dated player note tentatively describes100point increments and reports testing the first two ranks with a low-level spell, item clicks and pet-summoning spells. Reading its wording as increments per AA rank is an inference supported by that first-two-ranks context and the current native first-rank SPA286 value100. The selected second-rank reconstruction is200. It is not a value extracted from an original AA export or proven by fresh native acceptance. Preserve this qualification in review and any application receipt.

Current source defines SPA286 as FcDamageAmt, a flat spell-damage modifier. Preserve the native filters138/base0,143/base1,348/base1 and411/base64, including their base2 values. This proposal changes no existing filters, prerequisites, abilities, spells or players. It adds one rank and five effect rows. Higher native identities remain unknown even where the period table has purchase fields; next_id=-1 is a bounded reconstruction endpoint.

The forward transaction guards exact ability, predecessor, effects, prerequisites, target absence and inserted postimages. Rollback removes only the exact new rows and refuses while root14244 ownership has reached ordinal2 or higher. Database owns execution under coordinator GO. Coalesce these three public additions with compatible pending AA packets after reviewing the magnitude qualification.

Cleric Focused Celestial Regeneration's reuse-reduction rank2 has cost13 but an unknown level; do not infer93. Recourse of Life20 has cost6/level90/HoT but no authenticated triggered-heal identity. The other16 held source contracts have incomplete purchase fields, successor rows or effect bindings. No SQL application, source integration, build, cache refresh or client test was performed.
