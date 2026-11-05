# RRC121 Basic Bows output corrections

43existing full-input routes produce the wrong primary-linked physical bow. For example6806takes the CarvedDarkwood/linen body but produces8839hemp; source-linked8848has native damage23/delay60 versus8839damage24/delay64. This proposal corrects only the output identity.

| Existing recipe | Source formula | Current output | Primary output | Other discrepancies held |
|---|---|---|---|---|
|6806|Carved Darkwood Recurve Bow (linen)|8839|8848|SOURCE_OMITS_STORED_INPUT_RETURN_SCOPE|
|6897|Carved Shadewood 1-Cam Bow (linen)|10922|10931|TRIVIAL, EXPLICIT_RETURN|
|6900|Carved Shadewood 1-Cam Bow (silk)|10922|10940|TRIVIAL, EXPLICIT_RETURN|
|6902|Carved Shadewood Compound Bow (linen)|10923|10932||
|6903|Carved Shadewood Compound Bow (silk)|10923|10941||
|6908|Carved Shadewood Recurve Bow (linen)|10921|10930|TRIVIAL, EXPLICIT_RETURN|
|6911|Carved Shadewood Recurve Bow (silk)|10921|10939|TRIVIAL, EXPLICIT_RETURN|
|7342|Rough Ashwood Recurve Bow (linen)|8809|8812|TRIVIAL|
|7345|Rough Ashwood Recurve Bow (silk)|8809|8815|TRIVIAL|
|7354|Rough Darkwood 1-Cam Bow (linen)|8837|8846||
|7357|Rough Darkwood 1-Cam Bow (silk)|8837|8855||
|7363|Rough Darkwood Compound Bow (linen)|8838|8847||
|7366|Rough Darkwood Compound Bow (silk)|8838|8856||
|7372|Rough Darkwood Recurve Bow (linen)|8836|8845||
|7375|Rough Darkwood Recurve Bow (silk)|8836|8854||
|7379|Rough Elm Recurve Bow (linen)|8803|8805||
|7382|Rough Elm Recurve Bow (silk)|8803|8807||
|7390|Rough Hickory Recurve Bow (linen)|8800|8801|TRIVIAL|
|7393|Rough Hickory Recurve Bow (silk)|8800|8802||
|7399|Rough Oak 1-Cam Bow (linen)|8819|8825|TRIVIAL|
|7402|Rough Oak 1-Cam Bow (Silk)|8819|8831|TRIVIAL|
|7408|Rough Oak Recurve Bow (Linen)|8818|8824||
|7411|Rough Oak Recurve Bow (Silk)|8818|8830||
|7426|Rough Shadewood 1-Cam Bow (linen)|10919|10928|TRIVIAL|
|7429|Rough Shadewood 1-Cam Bow (silk)|10919|10937|TRIVIAL|
|7431|Rough Shadewood Compound Bow (linen)|10920|10929||
|7432|Rough Shadewood Compound Bow (silk)|10920|10938||
|7444|Shaped Ashwood Recurve Bow (linen)|8811|8814|SOURCE_OMITS_STORED_INPUT_RETURN_SCOPE|
|7447|Shaped Ashwood Recurve Bow (silk)|8811|8817|SOURCE_OMITS_STORED_INPUT_RETURN_SCOPE|
|7458|Shaped Darkwood 1-Cam Bow (linen)|8843|8852||
|7461|Shaped Darkwood 1-Cam Bow (silk)|8843|8861|SOURCE_OMITS_STORED_INPUT_RETURN_SCOPE|
|7467|Shaped Darkwood Compound Bow (linen)|8844|8853|SOURCE_OMITS_STORED_INPUT_RETURN_SCOPE|
|7470|Shaped Darkwood Compound Bow (silk)|8844|8862||
|7476|Shaped Darkwood Recurve Bow (linen)|8842|8851|SOURCE_OMITS_STORED_INPUT_RETURN_SCOPE|
|7479|Shaped Darkwood Recurve Bow (silk)|8842|8860|SOURCE_OMITS_STORED_INPUT_RETURN_SCOPE|
|7485|Shaped Oak 1-Cam Bow (linen)|8823|8829|TRIVIAL|
|7488|Shaped Oak 1-Cam Bow (silk)|8823|8835|TRIVIAL|
|7494|Shaped Oak Recurve Bow (linen)|8822|8828||
|7497|Shaped Oak Recurve Bow (silk)|8822|8834||
|7512|Shaped Shadewood 1-Cam Bow (linen)|10925|10934|TRIVIAL, EXPLICIT_RETURN|
|7515|Shaped Shadewood 1-Cam Bow (silk)|10925|10943|TRIVIAL, EXPLICIT_RETURN|
|7517|Shaped Shadewood Compound Bow (linen)|10926|10935||
|7518|Shaped Shadewood Compound Bow (silk)|10926|10944||

Maintained-primary Basic Bows output-ID correction only, not immutable historical per-field or native crafting proof.43existing exact-input bodies currently yield a different physical bow, commonly the hemp variant for a silk/linen input. Retained primary item links identify distinct native physical outputs even when display names match. Change only43existing output item_id fields; outputquantity1, all628entryIDs/roles/returns/salvage,74definitions/trivials/kits/minimum/learning/content gates preserved. Other explicit/omitted return and trivial discrepancies remain held, not silently normalized or called verified alternate formulas. No newrecipe/ingredient path/availability floor, retroactive playeritemreplacement/refund or actor acceptance.

Focused readback reuses the74documentedBasicBowsholds:43selected allskill/allstate fullinput checks each identify only its originalrecipe.74selected-output producers/628entries/76nativeitemrecords pinned.31peer definitions and their entries remain unchanged. All retained primary identity HTML hashes verified; no refetch/global scan. Fullpre/postimages, indexed fullinput and outputproducer-universe guards, nativephysical semantics and0rowdelta guard apply/rollback. NoSQLinvocation/rehearsal/tests/runtime. NeedsCoordinator correction disposition, exactGitHubpublication andseparateSQLGO.

Source: https://www.eqtraders.com/recipes/recipe_page.php?article=41&rsa=Fletching&sub=bow
