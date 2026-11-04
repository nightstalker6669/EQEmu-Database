# Database release coverage — incomplete

**EQEmu-Database does not yet include all project SQL changes.** Its initial publications cover baseline provenance, selected merchant tools/contracts and five applied AA batches. These are selected segments, not a complete server database release.

| Area | Current database-release coverage | Remaining reconciliation |
|---|---|---|
| Tradeskills | Missing; owner reports2628added recipes/14302entries through075 | Exact applied revisions/order, corrections and later batches |
| Housing |111filefoundation batch includes90housingSQL source files | Owner applied receipts, corrections and later changes |
| Achievements | Main content packages missing | Full package dependency/install/activation ledger; disabledproposals separate |
| Spells | Selected109merchant inserts represented;3later inserts staged | Full acquisition/faction/rune/item migrations and corrected helpers |
| AAs |001/003/004/005/008 applied SQL published,260selected rows | Later SQL updates;006/009/010installedLua/code tracked separately |
| Fellowship |4SQL source migrations staged | Applied receipt mapping and policy/code dependencies |
| Mercenaries |4SQL source migrations staged | Catalogue/Journeyman deltas and runtime/content role mapping |
| Shrouds |13SQL source migrations staged | Applied receipts, templates/AA corrections, runtime-state exclusions |

Source staging, publication, SQL application, engine/schema readiness, installed scripts/cache and native acceptance are distinct. This ledger does not infer installation from source presence or treat every disabled SQL filename as an unapplied proposal. Retained owner receipts determine applied status. Xorbb9345 is reviewed/syntax-valid but remains unapplied and outside the applied release.

NPC contributions stay with their owning content packages: PoK providers with Spells; unappliedXorbb profiles with Achievements. They must not be counted as independent extra migrations. Housing/session infrastructure precedes Fellowship/Mercenary/Shroud code paths; content_db and actual runtime schemas can differ.

Our own SQL updates can be published independently of unresolved original clone/archive redistribution terms. A complete content snapshot needs the explicit table/row scope described in SNAPSHOT-SCOPE.md; no raw live dump, account, character, inventory, custody, credential or QA state will be published. No runtime actions or new fixtures are part of release assembly.
