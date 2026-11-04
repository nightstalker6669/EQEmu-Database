-- Whole-stock Halon conversion: all106 original rows priced together.
-- Current merchant-table values are labelled corroboration; period values and
-- explicit unknowns are recorded in data/merchant-prices.json and provenance.
-- No current-only extra stock is imported. Native buy/sell code owns currency.
SET NAMES utf8mb4;
SET SESSION check_constraint_checks=1;
DROP TEMPORARY TABLE IF EXISTS `_tbs_halon_stock`;
CREATE TEMPORARY TABLE `_tbs_halon_stock` LIKE merchantlist;
INSERT INTO `_tbs_halon_stock`(`merchantid`,`slot`,`item`,`faction_required`,`level_required`,`min_status`,`max_status`,`alt_currency_cost`,`classes_required`,`probability`,`bucket_name`,`bucket_value`,`bucket_comparison`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(423124,1,78119,0,0,0,255,100,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,2,78182,-1100,0,0,255,250,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,3,78254,0,0,0,255,150,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,4,78363,0,0,0,255,100,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,5,78471,-1100,0,0,255,300,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,6,78564,-1100,0,0,255,300,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,7,78710,0,0,0,255,100,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,8,78723,-1100,0,0,255,200,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,9,79066,0,0,0,255,100,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,10,79072,-1100,0,0,255,200,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,11,79199,-1100,0,0,255,200,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,12,79327,-1100,0,0,255,250,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,13,79330,0,0,0,255,150,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,14,79333,-1100,0,0,255,200,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,15,79336,-1100,0,0,255,300,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,16,79339,0,0,0,255,100,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,17,79342,-1100,0,0,255,300,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,18,79345,-1100,0,0,255,200,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,19,79348,-1100,0,0,255,250,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,20,79351,-1100,0,0,255,300,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,21,79354,0,0,0,255,150,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,22,79357,-1100,0,0,255,300,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,23,79360,0,0,0,255,100,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,24,79363,0,0,0,255,150,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,25,79366,-1100,0,0,255,250,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,26,79369,-1100,0,0,255,200,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,27,79372,0,0,0,255,150,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,28,79375,-1100,0,0,255,250,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,29,79378,-1100,0,0,255,300,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,30,79381,-1100,0,0,255,300,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,31,79384,-1100,0,0,255,250,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,32,79387,0,0,0,255,150,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,33,79390,0,0,0,255,100,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,34,79393,0,0,0,255,100,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,35,79396,-1100,0,0,255,350,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,36,79399,-1100,0,0,255,200,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,37,79402,0,0,0,255,100,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,38,79405,0,0,0,255,100,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,39,79408,-1100,0,0,255,200,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,40,79411,-1100,0,0,255,300,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,41,79414,0,0,0,255,100,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,42,79417,-1100,0,0,255,300,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,43,79420,-1100,0,0,255,200,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,44,79423,-1100,0,0,255,250,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,45,79426,0,0,0,255,150,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,46,79429,-1100,0,0,255,300,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,47,79432,-1100,0,0,255,200,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,48,79435,0,0,0,255,100,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,49,79438,0,0,0,255,150,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,50,79441,-1100,0,0,255,250,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,51,79444,-1100,0,0,255,250,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,52,79447,-1100,0,0,255,250,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,53,79450,-1100,0,0,255,250,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,54,79918,0,0,0,255,10,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,55,80300,0,0,0,255,150,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,56,80301,0,0,0,255,150,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,57,80302,0,0,0,255,150,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,58,80303,0,0,0,255,150,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,59,80304,0,0,0,255,175,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,60,80305,0,0,0,255,175,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,61,80306,0,0,0,255,175,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,62,80307,0,0,0,255,175,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,63,80308,0,0,0,255,200,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,64,80309,0,0,0,255,200,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,65,80310,0,0,0,255,200,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,66,80311,0,0,0,255,200,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,67,80312,-1100,0,0,255,225,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,68,80313,-1100,0,0,255,225,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,69,80314,-1100,0,0,255,225,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,70,80315,-1100,0,0,255,225,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,71,80316,-1100,0,0,255,250,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,72,80317,-1100,0,0,255,250,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,73,80318,-1100,0,0,255,250,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,74,80319,-1100,0,0,255,250,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,75,80320,-1100,0,0,255,300,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,76,80321,-1100,0,0,255,300,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,77,80322,-1100,0,0,255,300,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,78,80323,-1100,0,0,255,300,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,79,80324,-1100,0,0,255,350,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,80,80325,-1100,0,0,255,350,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,81,80326,-1100,0,0,255,350,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,82,80327,-1100,0,0,255,350,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,83,80344,-1100,0,0,255,350,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,84,80345,-1100,0,0,255,350,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,85,80347,-1100,0,0,255,350,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,86,80348,-1100,0,0,255,400,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,87,80349,-1100,0,0,255,400,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,88,80350,-1100,0,0,255,400,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,89,80351,-1100,0,0,255,400,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,90,80352,-1100,0,0,255,450,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,91,80353,-1100,0,0,255,450,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,92,80354,-1100,0,0,255,450,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,93,80355,-1100,0,0,255,450,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,94,80357,-1100,0,0,255,200,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,95,80360,-1100,0,0,255,250,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,96,80362,-1100,0,0,255,350,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,97,80365,-1100,0,0,255,250,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,98,80370,-1100,0,0,255,250,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,99,80373,-1100,0,0,255,250,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,100,80376,-1100,0,0,255,250,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,101,80700,0,0,0,255,10,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,102,80701,0,0,0,255,10,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,103,80702,0,0,0,255,10,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,104,80703,0,0,0,255,10,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,105,80705,-1100,0,0,255,10,65535,100,'','',0,-1,-1,NULL,NULL),
(423124,106,80706,-1100,0,0,255,10,65535,100,'','',0,-1,-1,NULL,NULL);
START TRANSACTION;
SELECT id FROM npc_types WHERE id=423124 FOR UPDATE;
SELECT merchantid FROM merchantlist WHERE merchantid=423124 FOR UPDATE;
SELECT id FROM npc_faction WHERE id=423124 FOR UPDATE;
SET @tbs_halon_ok=IF(COALESCE(@buriedsea_whole_batch_reviewed,0)=1
 AND (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN('npc_types','merchantlist','npc_faction') AND ENGINE='InnoDB')=3
 AND (SELECT COUNT(*) FROM alternate_currency WHERE id=10 AND item_id=79910)=1
 AND (SELECT COUNT(*) FROM items WHERE id IN(79910,79918))=2
 AND (SELECT COUNT(*) FROM faction_list WHERE id=1169 AND base=0)=1
 AND (SELECT COUNT(*) FROM npc_types WHERE id=423124 AND name='#Halon_Griere' AND class=70 AND merchant_id=423124
  AND ((alt_currency_id=0 AND npc_faction_id=0)OR(alt_currency_id=10 AND npc_faction_id=423124)))=1
 AND NOT EXISTS(SELECT 1 FROM npc_faction WHERE id=423124 AND NOT(name<=>'Buried Sea Halon Blacksail Smugglers' AND primaryfaction=1169 AND ignore_primary_assist=1))
 AND NOT EXISTS(SELECT 1 FROM npc_faction_entries WHERE npc_faction_id=423124)
 AND (SELECT COUNT(*) FROM merchantlist WHERE merchantid=423124)=106
 AND (SELECT COUNT(*) FROM merchantlist a JOIN `_tbs_halon_stock` e ON a.merchantid=e.merchantid AND a.slot=e.slot WHERE a.`merchantid`<=>e.`merchantid` AND a.`slot`<=>e.`slot` AND a.`item`<=>e.`item` AND a.`level_required`<=>e.`level_required` AND a.`min_status`<=>e.`min_status` AND a.`max_status`<=>e.`max_status` AND a.`classes_required`<=>e.`classes_required` AND a.`probability`<=>e.`probability` AND a.`bucket_name`<=>e.`bucket_name` AND a.`bucket_value`<=>e.`bucket_value` AND a.`bucket_comparison`<=>e.`bucket_comparison` AND a.`min_expansion`<=>e.`min_expansion` AND a.`max_expansion`<=>e.`max_expansion` AND a.`content_flags`<=>e.`content_flags` AND a.`content_flags_disabled`<=>e.`content_flags_disabled` AND ((a.alt_currency_cost=0 AND a.faction_required=-1100) OR(a.alt_currency_cost=e.alt_currency_cost AND a.faction_required=e.faction_required)))=106
 AND NOT EXISTS(SELECT 1 FROM `_tbs_halon_stock` e LEFT JOIN items i ON i.id=e.item WHERE i.id IS NULL),1,0);
DROP TEMPORARY TABLE IF EXISTS `_tbs_halon_guard`;
CREATE TEMPORARY TABLE `_tbs_halon_guard`(ok INT NOT NULL CHECK(ok=1));
INSERT INTO `_tbs_halon_guard` VALUES(@tbs_halon_ok);
INSERT INTO npc_faction(id,name,primaryfaction,ignore_primary_assist)
 SELECT 423124,'Buried Sea Halon Blacksail Smugglers',1169,1 FROM DUAL WHERE @tbs_halon_ok=1 AND NOT EXISTS(SELECT 1 FROM npc_faction WHERE id=423124);
UPDATE merchantlist a JOIN `_tbs_halon_stock` e ON a.merchantid=e.merchantid AND a.slot=e.slot
 SET a.alt_currency_cost=e.alt_currency_cost,a.faction_required=e.faction_required WHERE @tbs_halon_ok=1;
UPDATE npc_types SET alt_currency_id=10,npc_faction_id=423124 WHERE id=423124 AND @tbs_halon_ok=1;
COMMIT;
