-- RRC122: seven existing tool success-return fields only. Fresh dedicated strict MariaDB session.
DELIMITER //
BEGIN NOT ATOMIC
 DECLARE own_transaction BOOLEAN DEFAULT FALSE;
 DECLARE recipes_before BIGINT DEFAULT 0;
 DECLARE entries_before BIGINT DEFAULT 0;
 DECLARE locked_rows BIGINT DEFAULT 0;
 DECLARE changed_rows BIGINT DEFAULT 0;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
  IF own_transaction THEN ROLLBACK; END IF;
  RESIGNAL;
 END;
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC122 target/transaction mismatch'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC122 strict mode required'; END IF;
 IF(SELECT COUNT(*)FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE()AND TABLE_NAME IN('tradeskill_recipe','tradeskill_recipe_entries','items')AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC122 InnoDB mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc122_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc122_before LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc122_after LIKE tradeskill_recipe_entries;
 INSERT INTO rrc122_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(6897,CONVERT(0x436172766564205368616465776f6f6420312d63616d20426f77 USING utf8mb4),64,0,275,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(6900,CONVERT(0x436172766564205368616465776f6f6420312d63616d20426f77 USING utf8mb4),64,0,275,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(6908,CONVERT(0x436172766564205368616465776f6f64205265637572766520426f77 USING utf8mb4),64,0,275,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(6911,CONVERT(0x436172766564205368616465776f6f64205265637572766520426f77 USING utf8mb4),64,0,275,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7509,CONVERT(0x536861706564205368616465776f6f6420312d63616d20426f77 USING utf8mb4),64,0,275,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7512,CONVERT(0x536861706564205368616465776f6f6420312d63616d20426f77 USING utf8mb4),64,0,275,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7515,CONVERT(0x536861706564205368616465776f6f6420312d63616d20426f77 USING utf8mb4),64,0,275,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc122_before (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(65011,6897,8085,1,1,1,0,0),
(65012,6897,8087,0,0,1,1,0),
(65013,6897,8089,0,0,1,1,0),
(65014,6897,10917,0,0,1,1,0),
(65015,6897,10931,1,0,0,0,0),
(65017,6897,17128,0,0,0,0,1),
(65018,6897,17189,0,0,0,0,1),
(65019,6897,17762,0,0,0,0,1),
(65020,6897,17910,0,0,0,0,1),
(65021,6897,66163,0,0,0,0,1),
(65038,6900,8085,1,1,1,0,0),
(65039,6900,8087,0,0,1,1,0),
(65040,6900,8090,0,0,1,1,0),
(65041,6900,10917,0,0,1,1,0),
(65042,6900,10940,1,0,0,0,0),
(65044,6900,17128,0,0,0,0,1),
(65045,6900,17189,0,0,0,0,1),
(65046,6900,17762,0,0,0,0,1),
(65047,6900,17910,0,0,0,0,1),
(65048,6900,66163,0,0,0,0,1),
(65113,6908,8085,1,1,1,0,0),
(65114,6908,8089,0,0,1,1,0),
(65115,6908,10917,0,0,1,1,0),
(65116,6908,10930,1,0,0,0,0),
(65118,6908,17128,0,0,0,0,1),
(65119,6908,17189,0,0,0,0,1),
(65120,6908,17762,0,0,0,0,1),
(65121,6908,17910,0,0,0,0,1),
(65122,6908,66163,0,0,0,0,1),
(65139,6911,8085,1,1,1,0,0),
(65140,6911,8090,0,0,1,1,0),
(65141,6911,10917,0,0,1,1,0),
(65142,6911,10939,1,0,0,0,0),
(65144,6911,17128,0,0,0,0,1),
(65145,6911,17189,0,0,0,0,1),
(65146,6911,17762,0,0,0,0,1),
(65147,6911,17910,0,0,0,0,1),
(65148,6911,66163,0,0,0,0,1),
(70787,7509,8086,1,1,1,0,0),
(70788,7509,8087,0,0,1,1,0),
(70789,7509,8088,0,0,1,1,0),
(70790,7509,10917,0,0,1,1,0),
(70791,7509,10925,1,0,0,0,0),
(70793,7509,17128,0,0,0,0,1),
(70794,7509,17189,0,0,0,0,1),
(70795,7509,17762,0,0,0,0,1),
(70796,7509,17910,0,0,0,0,1),
(70797,7509,66163,0,0,0,0,1),
(70814,7512,8086,1,1,1,0,0),
(70815,7512,8087,0,0,1,1,0),
(70816,7512,8089,0,0,1,1,0),
(70817,7512,10917,0,0,1,1,0),
(70818,7512,10934,1,0,0,0,0),
(70820,7512,17128,0,0,0,0,1),
(70821,7512,17189,0,0,0,0,1),
(70822,7512,17762,0,0,0,0,1),
(70823,7512,17910,0,0,0,0,1),
(70824,7512,66163,0,0,0,0,1),
(70841,7515,8086,1,1,1,0,0),
(70842,7515,8087,0,0,1,1,0),
(70843,7515,8090,0,0,1,1,0),
(70844,7515,10917,0,0,1,1,0),
(70845,7515,10943,1,0,0,0,0),
(70847,7515,17128,0,0,0,0,1),
(70848,7515,17189,0,0,0,0,1),
(70849,7515,17762,0,0,0,0,1),
(70850,7515,17910,0,0,0,0,1),
(70851,7515,66163,0,0,0,0,1);
 INSERT INTO rrc122_after (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(65011,6897,8085,0,1,1,0,0),
(65012,6897,8087,0,0,1,1,0),
(65013,6897,8089,0,0,1,1,0),
(65014,6897,10917,0,0,1,1,0),
(65015,6897,10931,1,0,0,0,0),
(65017,6897,17128,0,0,0,0,1),
(65018,6897,17189,0,0,0,0,1),
(65019,6897,17762,0,0,0,0,1),
(65020,6897,17910,0,0,0,0,1),
(65021,6897,66163,0,0,0,0,1),
(65038,6900,8085,0,1,1,0,0),
(65039,6900,8087,0,0,1,1,0),
(65040,6900,8090,0,0,1,1,0),
(65041,6900,10917,0,0,1,1,0),
(65042,6900,10940,1,0,0,0,0),
(65044,6900,17128,0,0,0,0,1),
(65045,6900,17189,0,0,0,0,1),
(65046,6900,17762,0,0,0,0,1),
(65047,6900,17910,0,0,0,0,1),
(65048,6900,66163,0,0,0,0,1),
(65113,6908,8085,0,1,1,0,0),
(65114,6908,8089,0,0,1,1,0),
(65115,6908,10917,0,0,1,1,0),
(65116,6908,10930,1,0,0,0,0),
(65118,6908,17128,0,0,0,0,1),
(65119,6908,17189,0,0,0,0,1),
(65120,6908,17762,0,0,0,0,1),
(65121,6908,17910,0,0,0,0,1),
(65122,6908,66163,0,0,0,0,1),
(65139,6911,8085,0,1,1,0,0),
(65140,6911,8090,0,0,1,1,0),
(65141,6911,10917,0,0,1,1,0),
(65142,6911,10939,1,0,0,0,0),
(65144,6911,17128,0,0,0,0,1),
(65145,6911,17189,0,0,0,0,1),
(65146,6911,17762,0,0,0,0,1),
(65147,6911,17910,0,0,0,0,1),
(65148,6911,66163,0,0,0,0,1),
(70787,7509,8086,0,1,1,0,0),
(70788,7509,8087,0,0,1,1,0),
(70789,7509,8088,0,0,1,1,0),
(70790,7509,10917,0,0,1,1,0),
(70791,7509,10925,1,0,0,0,0),
(70793,7509,17128,0,0,0,0,1),
(70794,7509,17189,0,0,0,0,1),
(70795,7509,17762,0,0,0,0,1),
(70796,7509,17910,0,0,0,0,1),
(70797,7509,66163,0,0,0,0,1),
(70814,7512,8086,0,1,1,0,0),
(70815,7512,8087,0,0,1,1,0),
(70816,7512,8089,0,0,1,1,0),
(70817,7512,10917,0,0,1,1,0),
(70818,7512,10934,1,0,0,0,0),
(70820,7512,17128,0,0,0,0,1),
(70821,7512,17189,0,0,0,0,1),
(70822,7512,17762,0,0,0,0,1),
(70823,7512,17910,0,0,0,0,1),
(70824,7512,66163,0,0,0,0,1),
(70841,7515,8086,0,1,1,0,0),
(70842,7515,8087,0,0,1,1,0),
(70843,7515,8090,0,0,1,1,0),
(70844,7515,10917,0,0,1,1,0),
(70845,7515,10943,1,0,0,0,0),
(70847,7515,17128,0,0,0,0,1),
(70848,7515,17189,0,0,0,0,1),
(70849,7515,17762,0,0,0,0,1),
(70850,7515,17910,0,0,0,0,1),
(70851,7515,66163,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*)INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*)INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe r JOIN rrc122_recipes e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>7 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC122 definition/peer missing'; END IF;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe_entries r JOIN rrc122_before e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>68 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC122 target/peer entries missing'; END IF;
 IF EXISTS(SELECT 1 FROM rrc122_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC122 definition/peer drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc122_before e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc122_recipes p ON p.id=r.recipe_id)<>68 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC122 preimage mismatch'; END IF;
 IF(SELECT COUNT(*)FROM items WHERE (`id` <=> 8085 AND BINARY Name=BINARY CONVERT(0x57686974746c696e6720426c616465 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0) OR (`id` <=> 8086 AND BINARY Name=BINARY CONVERT(0x506c616e696e6720546f6f6c USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0) OR (`id` <=> 8087 AND BINARY Name=BINARY CONVERT(0x5374616e6461726420426f772043616d USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0) OR (`id` <=> 8089 AND BINARY Name=BINARY CONVERT(0x4c696e656e20537472696e67 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0) OR (`id` <=> 8090 AND BINARY Name=BINARY CONVERT(0x53696c6b20537472696e67 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0) OR (`id` <=> 10917 AND BINARY Name=BINARY CONVERT(0x5368616465776f6f6420426f77205374616666 USING utf8mb4) AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0) OR (`id` <=> 10925 AND BINARY Name=BINARY CONVERT(0x536861706564205368616465776f6f6420312d43616d20426f77 USING utf8mb4) AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 24 AND `delay` <=> 52 AND `range` <=> 175 AND `slots` <=> 2048 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0) OR (`id` <=> 10930 AND BINARY Name=BINARY CONVERT(0x436172766564205368616465776f6f64205265637572766520426f77 USING utf8mb4) AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 25 AND `delay` <=> 58 AND `range` <=> 150 AND `slots` <=> 2048 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0) OR (`id` <=> 10931 AND BINARY Name=BINARY CONVERT(0x436172766564205368616465776f6f6420312d43616d20426f77 USING utf8mb4) AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 24 AND `delay` <=> 53 AND `range` <=> 175 AND `slots` <=> 2048 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0) OR (`id` <=> 10934 AND BINARY Name=BINARY CONVERT(0x536861706564205368616465776f6f6420312d43616d20426f77 USING utf8mb4) AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 23 AND `delay` <=> 48 AND `range` <=> 175 AND `slots` <=> 2048 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0) OR (`id` <=> 10939 AND BINARY Name=BINARY CONVERT(0x436172766564205368616465776f6f64205265637572766520426f77 USING utf8mb4) AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 24 AND `delay` <=> 54 AND `range` <=> 150 AND `slots` <=> 2048 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0) OR (`id` <=> 10940 AND BINARY Name=BINARY CONVERT(0x436172766564205368616465776f6f6420312d43616d20426f77 USING utf8mb4) AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 23 AND `delay` <=> 49 AND `range` <=> 175 AND `slots` <=> 2048 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0) OR (`id` <=> 10943 AND BINARY Name=BINARY CONVERT(0x536861706564205368616465776f6f6420312d43616d20426f77 USING utf8mb4) AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 22 AND `delay` <=> 44 AND `range` <=> 175 AND `slots` <=> 2048 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0) OR (`id` <=> 8088 AND BINARY Name=BINARY CONVERT(0x48656d70205477696e65 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0))<>14 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC122 native item identity/range drift'; END IF;
 UPDATE tradeskill_recipe_entries r JOIN rrc122_after e ON r.id=e.id SET r.successcount=e.successcount WHERE r.id IN(65011,65038,65113,65139,70787,70814,70841);
 SET changed_rows=ROW_COUNT();
 IF changed_rows<>7 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC122 changed-row mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc122_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC122 definition/peer drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc122_after e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc122_recipes p ON p.id=r.recipe_id)<>68 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC122 postimage mismatch'; END IF;
 IF(SELECT COUNT(*)FROM tradeskill_recipe)<>recipes_before OR(SELECT COUNT(*)FROM tradeskill_recipe_entries)<>entries_before THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC122 global row-count drift'; END IF;
 DROP TEMPORARY TABLE rrc122_before;
 DROP TEMPORARY TABLE rrc122_after;
 DROP TEMPORARY TABLE rrc122_recipes;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC122',changed_rows,recipes_before,(SELECT COUNT(*)FROM tradeskill_recipe),entries_before,(SELECT COUNT(*)FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
