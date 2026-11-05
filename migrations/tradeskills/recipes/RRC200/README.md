# RRC200 OoW Worm Wine casks

1 proposed recipes/6entries.

One retained OoW Brewing source view15608 Cask of Worm Wine. A finite charged-output source disposition with explicit primary initial charges and preserved returns, not a general maximum-charge default. Pending coordinator acceptance of this exact mapping before publication/application.

Primary16686 explicitly identifies EQ75810 Cask of Worm Wine, Charges8, physical Yield1; primary16321 identifies EQ75804 Bottle of Worm Wine, Charges1. Both profiles do not report stackability. Actual native fields confirm nonstackable MaxCharges8 output and nonstackable MaxCharges1 input; IDs and item fields unchanged.

Source yieldsONE physical cask withEIGHT initial charges plusEIGHT corks andEIGHT empty bottles. Native success parameter for75810 is8 because TradeskillExecute passes successcount directly to SummonItem and a positive count is used as charges for one nonstackable CreateItem instance. No default MaxCharges inference. Returns16598/16851 use8 physical stack units each, authenticated stackable/nativecapacity>=8. Source physical quantities remain separately recorded from native charge parameters.

Source consumes8 separate nonstackable one-charge Worm Wine bottles plus1Cask,9physical slots total. Static current GetTradeRecipe counts occupied container slots; normal combine clears these physical inputs. Auto combine iterates componentcount8 and deletes each nonstackable input instance whole. No stacking or partial-charge reuse invented. No native acceptance is claimed from this static proof.

Source explicitly says15(No-Fail), mapped trivial15/nofail1. Current source nofail branch makes chance100 and bypasses success-odds query. No inferred probability or default trivial used. No failure returns stated; consumed-salvage follows new-record policy but no-fail means normal failure is not expected.

Positive maintained OoW8 Brewing manufacturing family. Floor8/max-1 labelled reconstruction, not immutable May2013 exact fields or introduction proof. Other charged/recharge/era/actor/source holds unchanged.

Source omits mandatory learning, minimum, actor and quest gates. Ordinary skillneeded0/must_learn0/book0/quest0/enabled1 labelled policies; no item/quest/player/core changes.

Source directly permits ordinary Brew Barrel type19. Tanaan/placeable/guild/unspecified barrel alternatives held. Bloodroot cask remains separate Tanaan-only station hold; its metadata does not authorize an ordinary barrel substitution.

Five exact fresh native item-field dependencies guarded. Necessary bounded current all-state/all-skill full-input and name checks found zero matches. Full all-success output-use universe includes returned empty bottles/corks:24 recipes/184 entries captured and guarded unchanged. Exact new ID vacancy, full postimages, deltas and learned references guarded.

Source proposal only pending explicit finite quantity disposition, coordinator publication and exact SQL GO. Reader/research tab closed. No tests/build/runtime/native combine, drinking, charge-depletion or unpacking acceptance claims; other holds/full-scope incompleteness retained.

Source: https://www.eqtraders.com/recipes/recipe_page.php?article=265&rsa=Brewing&sub=OoW
Primary identity: https://www.eqtraders.com/items/show_item.php?item=16686
Primary identity: https://www.eqtraders.com/items/show_item.php?item=16321
