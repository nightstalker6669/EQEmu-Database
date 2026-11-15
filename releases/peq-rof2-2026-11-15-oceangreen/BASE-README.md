# PEQ RoF2 full database + mercenary86–100 cohort — 2026-11-07

**NEW EMPTY DATABASE ONLY. This dump replaces tables; NOT a player-preserving upgrade.**

MariaDB10.11 (assembled10.11.19): create an empty database using your own credentials, then import:

```sh
mariadb -u root -p -e "CREATE DATABASE peq CHARACTER SET latin1;"
mariadb -u root -p --max-allowed-packet=256M peq < full.sql
```

Fullschema9338/bots0/custom0,448tables+1view,3,050,609rows. Recipes remain34,486/261,389. Base is the verified sanitized PEQ-RoF2-full-2026-11-07.zip (SHA2566cdc90e335c90bcb1427067063326dfb4de04c2e3afd3d6ee1367c1107b4e1d8), preserving all prior completedcontent,emptyaccount/player/custody/operationdomains,42excludedQA-onlyShrouds,disabledunfinishedfeatures andall331portableHousingJSON bytes/freshunownedcatalogue. TABLE-INVENTORY.json lists each table. No serving DB connection, live application, restart or currentprivate DB dump was performed.

This ONE completed source/content cohort adds600mercenary statrows (40NPCvariants×15levels86–100),188spell-repertoire entries,and40focus-inventory extensions. Exactly50oldspellranges now stopat85; their through85definitions andallotherold3table rows/cells are unchanged. Finalcounts:merc_stats4000,merc_spell_list_entries625,merc_inventory81. SQL changes only those3contenttables; no contracts/ownedmercs/buffs/wallets/rules/shareditem/sharedspell definitions. MERCENARY86-100-CONTENT.json preserves exactfinalrowdata andqualifications. SourceSQL SHA2566ad8f950c178e9c1d84658387c521dc33695572fd8926c30a711aff44e50790f;manifest78710b4716455c626cc62189cca8eacd252d2ce796adc018c0b4dd18657aace9;completepatcha5b2b0022a9b339fbed6d45d9823090236dd2638b0cb5f2c2d8e6d4f8d7d1816 overcodebasec642eb178b8a0a9881812c2b3d3f188acb1217d8. Final cohort featurecheckpoint is `nightstalker6669/EQEmu` rof2-mercenaries commit5178edd73a4204f863b298fa9328e19205da5f56. Final develop native merc.cpp postimage must match11ac144556a3caa91e9ab33bd31e937a9a30c2ab1f117265c32a77b30db99c91; Root/GitHub binds finalintegration separately. OldDBsource945e9f1b is BASEprovenance only; newcontent is bound by feature5178edd7 plus exactSQL/manifest/patch and artifact hashes.

Stats are bounded per-field75/80/85 quadratic reconstruction with monotonic tierenvelopes and selectedJIII–V110/120/130% policy—not historical Live numbers. Spells use currentloaded/client-matched class/level/RkI–II definitions and reconstructed through-RoF repertoire; immutableMay2013definitions/NPCcasts are unauthenticated. Positive rogue spellranges andexistingfocusdefinitions are finalSQL-bound; this is not nativeAI/focus/gameplay acceptance. Requires matched completed merc.cpp exact-cost/roguelevel86+ code changes plus existing integrated310/312actor/Housing/reward/quest/opcode code. Build's combinedrelease pins code/binaries separately. Do not pair this data with old mercenary code.

`housing-runtime-content/` is unchanged:163portable room/capacity bindings,content-only registries/reviewedpolicy andfreshcratemetadata. SQL retains unownedSunrise75plots/76nativenodes/instance101/catalogue`installed:peq-rof2-full-20261106`;no productionidentitygraph. CopyJSON into the matching freshserverworkingdirectory and supply authenticatedoriginalRoF2archives/maps separately. Housingactivation bindsDATABASE(). Generate freshsharedmemory normally on the newtarget;SQL alone supplies no binaries/quests/clientassets.

PriorLOCALrecipefallbacks/2Dwarfquantity2/stewUNCONFIRMED/tier-inference/DNC/3unsupportedlimits and unfinishednaturaltype99/final7trophy evolution remain unchanged; COMPLETED-RECIPE-UPDATES.json is carried unchanged from the base. No rank/item piecemealexports, speculative recipes or unfinisheddrafts were enabled.

full.sql SHA256: `2985a52a017a77bde5bbbe5cfe835ad83351ecbb858dbf07405904f0a1759fdf`

Verification: exact600/188/50/40 postimages, alloutside-cohort3table cells unchanged, allother tablecounts unchanged,fullinventory,331HousingJSONbyteidentity,ZIPCRC/memberhashes. Servingapplication remains separatelyheld for Root's matcheddeployment GO. This artifact is fresh-install data prepared for ONE coherentcode+SQL/docs+DBreleasepin developpush/CIbuild.
