-- RRC142: two existing output IDs only. Fresh dedicated strict MariaDB session.
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
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC142 target/transaction mismatch'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC142 strict mode required'; END IF;
 IF(SELECT COUNT(*)FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE()AND TABLE_NAME IN('tradeskill_recipe','tradeskill_recipe_entries','items')AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC142 InnoDB mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc142_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc142_before LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc142_after LIKE tradeskill_recipe_entries;
 INSERT INTO rrc142_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(7471,CONVERT(0x536861706564204461726b776f6f64205265637572766520426f77 USING utf8mb4),64,0,15,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7473,CONVERT(0x536861706564204461726b776f6f64205265637572766520426f77 USING utf8mb4),64,0,215,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7474,CONVERT(0x536861706564204461726b776f6f64205265637572766520426f77 USING utf8mb4),64,0,15,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7477,CONVERT(0x536861706564204461726b776f6f64205265637572766520426f77 USING utf8mb4),64,0,15,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7478,CONVERT(0x536861706564204461726b776f6f64205265637572766520426f77 USING utf8mb4),64,0,15,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7516,CONVERT(0x536861706564205368616465776f6f6420436f6d706f756e6420426f77202868656d7029 USING utf8mb4),64,0,282,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7519,CONVERT(0x536861706564205368616465776f6f6420436f6d706f756e6420426f77202873696e657729 USING utf8mb4),64,0,282,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(27869,CONVERT(0x536861706564204461726b776f6f64205265637572766520426f77 USING utf8mb4),64,0,215,0,0,'',0,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc142_before (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(70442,7471,8088,0,0,1,1,0),
(70443,7471,8842,1,0,1,1,0),
(70445,7471,17128,0,0,0,0,1),
(70446,7471,17189,0,0,0,0,1),
(70447,7471,17762,0,0,0,0,1),
(70448,7471,17910,0,0,0,0,1),
(70449,7471,66163,0,0,0,0,1),
(70458,7473,8086,1,1,1,0,0),
(70459,7473,8084,0,0,1,1,0),
(70460,7473,8088,0,0,1,1,0),
(70462,7473,8842,1,0,0,0,0),
(70463,7473,17128,0,0,0,0,1),
(70464,7473,17189,0,0,0,0,1),
(70465,7473,17762,0,0,0,0,1),
(70466,7473,17910,0,0,0,0,1),
(70467,7473,66163,0,0,0,0,1),
(70468,7474,8089,0,0,1,1,0),
(70469,7474,8842,1,0,1,1,0),
(70471,7474,17128,0,0,0,0,1),
(70472,7474,17189,0,0,0,0,1),
(70473,7474,17762,0,0,0,0,1),
(70474,7474,17910,0,0,0,0,1),
(70475,7474,66163,0,0,0,0,1),
(70494,7477,8090,0,0,1,1,0),
(70495,7477,8842,1,0,1,1,0),
(70497,7477,17128,0,0,0,0,1),
(70498,7477,17189,0,0,0,0,1),
(70499,7477,17762,0,0,0,0,1),
(70500,7477,17910,0,0,0,0,1),
(70501,7477,66163,0,0,0,0,1),
(70502,7478,72094,0,0,1,1,0),
(70503,7478,8842,1,0,1,1,0),
(70505,7478,17128,0,0,0,0,1),
(70506,7478,17189,0,0,0,0,1),
(70507,7478,17762,0,0,0,0,1),
(70508,7478,17910,0,0,0,0,1),
(70509,7478,66163,0,0,0,0,1),
(70852,7516,8087,0,0,2,2,0),
(70853,7516,8086,1,1,1,0,0),
(70854,7516,8088,0,0,1,1,0),
(70855,7516,10917,0,0,1,1,0),
(70857,7516,10926,1,0,0,0,0),
(70859,7516,17189,0,0,0,0,1),
(70860,7516,17762,0,0,0,0,1),
(70861,7516,17910,0,0,0,0,1),
(70882,7519,8087,0,0,2,2,0),
(70883,7519,8086,1,1,1,0,0),
(70884,7519,10917,0,0,1,1,0),
(70885,7519,72094,0,0,1,1,0),
(70887,7519,10926,1,0,0,0,0),
(70889,7519,17189,0,0,0,0,1),
(70890,7519,17762,0,0,0,0,1),
(70891,7519,17910,0,0,0,0,1),
(278231,27869,8086,1,1,1,0,0),
(278232,27869,8084,0,0,1,1,0),
(278233,27869,72094,0,0,1,1,0),
(278234,27869,8842,1,0,0,0,0),
(278235,27869,17128,0,0,0,0,1),
(278236,27869,17189,0,0,0,0,1),
(278237,27869,17762,0,0,0,0,1),
(278238,27869,17910,0,0,0,0,1),
(278239,27869,66163,0,0,0,0,1);
 INSERT INTO rrc142_after (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(70442,7471,8088,0,0,1,1,0),
(70443,7471,8842,1,0,1,1,0),
(70445,7471,17128,0,0,0,0,1),
(70446,7471,17189,0,0,0,0,1),
(70447,7471,17762,0,0,0,0,1),
(70448,7471,17910,0,0,0,0,1),
(70449,7471,66163,0,0,0,0,1),
(70458,7473,8086,1,1,1,0,0),
(70459,7473,8084,0,0,1,1,0),
(70460,7473,8088,0,0,1,1,0),
(70462,7473,8842,1,0,0,0,0),
(70463,7473,17128,0,0,0,0,1),
(70464,7473,17189,0,0,0,0,1),
(70465,7473,17762,0,0,0,0,1),
(70466,7473,17910,0,0,0,0,1),
(70467,7473,66163,0,0,0,0,1),
(70468,7474,8089,0,0,1,1,0),
(70469,7474,8842,1,0,1,1,0),
(70471,7474,17128,0,0,0,0,1),
(70472,7474,17189,0,0,0,0,1),
(70473,7474,17762,0,0,0,0,1),
(70474,7474,17910,0,0,0,0,1),
(70475,7474,66163,0,0,0,0,1),
(70494,7477,8090,0,0,1,1,0),
(70495,7477,8842,1,0,1,1,0),
(70497,7477,17128,0,0,0,0,1),
(70498,7477,17189,0,0,0,0,1),
(70499,7477,17762,0,0,0,0,1),
(70500,7477,17910,0,0,0,0,1),
(70501,7477,66163,0,0,0,0,1),
(70502,7478,72094,0,0,1,1,0),
(70503,7478,8842,1,0,1,1,0),
(70505,7478,17128,0,0,0,0,1),
(70506,7478,17189,0,0,0,0,1),
(70507,7478,17762,0,0,0,0,1),
(70508,7478,17910,0,0,0,0,1),
(70509,7478,66163,0,0,0,0,1),
(70852,7516,8087,0,0,2,2,0),
(70853,7516,8086,1,1,1,0,0),
(70854,7516,8088,0,0,1,1,0),
(70855,7516,10917,0,0,1,1,0),
(70857,7516,10926,1,0,0,0,0),
(70859,7516,17189,0,0,0,0,1),
(70860,7516,17762,0,0,0,0,1),
(70861,7516,17910,0,0,0,0,1),
(70882,7519,8087,0,0,2,2,0),
(70883,7519,8086,1,1,1,0,0),
(70884,7519,10917,0,0,1,1,0),
(70885,7519,72094,0,0,1,1,0),
(70887,7519,75730,1,0,0,0,0),
(70889,7519,17189,0,0,0,0,1),
(70890,7519,17762,0,0,0,0,1),
(70891,7519,17910,0,0,0,0,1),
(278231,27869,8086,1,1,1,0,0),
(278232,27869,8084,0,0,1,1,0),
(278233,27869,72094,0,0,1,1,0),
(278234,27869,75719,1,0,0,0,0),
(278235,27869,17128,0,0,0,0,1),
(278236,27869,17189,0,0,0,0,1),
(278237,27869,17762,0,0,0,0,1),
(278238,27869,17910,0,0,0,0,1),
(278239,27869,66163,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*)INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*)INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe r JOIN rrc142_recipes e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC142 definition/peer missing'; END IF;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe_entries r JOIN rrc142_before e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>62 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC142 target/peer entries missing'; END IF;
 IF EXISTS(SELECT 1 FROM rrc142_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC142 definition/peer drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc142_before e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc142_recipes p ON p.id=r.recipe_id)<>62 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC142 preimage mismatch'; END IF;
 IF(SELECT COUNT(*)FROM items WHERE (`id` <=> 8084 AND BINARY Name=BINARY CONVERT(0x4461726b776f6f6420426f77205374616666 USING utf8mb4) AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0) OR (`id` <=> 8086 AND BINARY Name=BINARY CONVERT(0x506c616e696e6720546f6f6c USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0) OR (`id` <=> 8087 AND BINARY Name=BINARY CONVERT(0x5374616e6461726420426f772043616d USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0) OR (`id` <=> 8842 AND BINARY Name=BINARY CONVERT(0x536861706564204461726b776f6f64205265637572766520426f77 USING utf8mb4) AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 23 AND `delay` <=> 59 AND `range` <=> 150 AND `slots` <=> 2048 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0) OR (`id` <=> 10917 AND BINARY Name=BINARY CONVERT(0x5368616465776f6f6420426f77205374616666 USING utf8mb4) AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0) OR (`id` <=> 10926 AND BINARY Name=BINARY CONVERT(0x536861706564205368616465776f6f6420436f6d706f756e6420426f77 USING utf8mb4) AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 23 AND `delay` <=> 47 AND `range` <=> 200 AND `slots` <=> 2048 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0) OR (`id` <=> 17128 AND BINARY Name=BINARY CONVERT(0x466569726044616c20466c65746368696e67204b6974 USING utf8mb4) AND `size` <=> 4 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 18 AND `bagslots` <=> 10 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 65544 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0) OR (`id` <=> 17189 AND BINARY Name=BINARY CONVERT(0x436f6c6c61707369626c6520466c65746368696e67204b6974 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> -1 AND `filename` <=> '' AND `booktype` <=> 0) OR (`id` <=> 17762 AND BINARY Name=BINARY CONVERT(0x506c616e617220466c65746368696e67204b6974 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0) OR (`id` <=> 17910 AND BINARY Name=BINARY CONVERT(0x466c65746368696e67204b6974 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0) OR (`id` <=> 66163 AND BINARY Name=BINARY CONVERT(0x5375726566616c6c20466c65746368696e67204b6974 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 4 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 128 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0) OR (`id` <=> 72094 AND BINARY Name=BINARY CONVERT(0x4d75726b676c696465722053696e6577 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0) OR (`id` <=> 75719 AND BINARY Name=BINARY CONVERT(0x536861706564204461726b776f6f64205265637572766520426f77 USING utf8mb4) AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 23 AND `delay` <=> 55 AND `range` <=> 150 AND `slots` <=> 2048 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0) OR (`id` <=> 75730 AND BINARY Name=BINARY CONVERT(0x536861706564205368616465776f6f6420436f6d706f756e6420426f77 USING utf8mb4) AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 23 AND `delay` <=> 43 AND `range` <=> 200 AND `slots` <=> 2048 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0))<>14 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC142 native item identity/range drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.iscontainer=0 AND e.successcount>0 AND e.item_id IN(8842,10926,75719,75730)AND NOT EXISTS(SELECT 1 FROM rrc142_recipes p WHERE p.id=e.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC142 output-producer universe drift'; END IF;
 IF(SELECT COUNT(DISTINCT a.recipe_id)FROM tradeskill_recipe_entries a WHERE a.item_id=72094 AND a.componentcount>0 AND a.iscontainer=0 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=a.recipe_id AND e.iscontainer=0)=3 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=a.recipe_id AND e.iscontainer=0 AND e.item_id=8086)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=a.recipe_id AND e.iscontainer=0 AND e.item_id=8084)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=a.recipe_id AND e.iscontainer=0 AND e.item_id=72094)=1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC142 full input universe drift';END IF;
 IF(SELECT COUNT(DISTINCT a.recipe_id)FROM tradeskill_recipe_entries a WHERE a.item_id=72094 AND a.componentcount>0 AND a.iscontainer=0 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=a.recipe_id AND e.iscontainer=0)=5 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=a.recipe_id AND e.iscontainer=0 AND e.item_id=8087)=2 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=a.recipe_id AND e.iscontainer=0 AND e.item_id=8086)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=a.recipe_id AND e.iscontainer=0 AND e.item_id=10917)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=a.recipe_id AND e.iscontainer=0 AND e.item_id=72094)=1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC142 full input universe drift';END IF;
 UPDATE tradeskill_recipe_entries r JOIN rrc142_after e ON r.id=e.id SET r.item_id=e.item_id WHERE r.id IN(70887,278234);
 SET changed_rows=ROW_COUNT();
 IF changed_rows<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC142 changed-row mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc142_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC142 definition/peer drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc142_after e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc142_recipes p ON p.id=r.recipe_id)<>62 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC142 postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.iscontainer=0 AND e.successcount>0 AND e.item_id IN(8842,10926,75719,75730)AND NOT EXISTS(SELECT 1 FROM rrc142_recipes p WHERE p.id=e.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC142 output-producer universe drift'; END IF;
 IF(SELECT COUNT(DISTINCT a.recipe_id)FROM tradeskill_recipe_entries a WHERE a.item_id=72094 AND a.componentcount>0 AND a.iscontainer=0 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=a.recipe_id AND e.iscontainer=0)=3 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=a.recipe_id AND e.iscontainer=0 AND e.item_id=8086)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=a.recipe_id AND e.iscontainer=0 AND e.item_id=8084)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=a.recipe_id AND e.iscontainer=0 AND e.item_id=72094)=1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC142 full input universe drift';END IF;
 IF(SELECT COUNT(DISTINCT a.recipe_id)FROM tradeskill_recipe_entries a WHERE a.item_id=72094 AND a.componentcount>0 AND a.iscontainer=0 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=a.recipe_id AND e.iscontainer=0)=5 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=a.recipe_id AND e.iscontainer=0 AND e.item_id=8087)=2 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=a.recipe_id AND e.iscontainer=0 AND e.item_id=8086)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=a.recipe_id AND e.iscontainer=0 AND e.item_id=10917)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=a.recipe_id AND e.iscontainer=0 AND e.item_id=72094)=1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC142 full input universe drift';END IF;
 IF(SELECT COUNT(*)FROM tradeskill_recipe)<>recipes_before OR(SELECT COUNT(*)FROM tradeskill_recipe_entries)<>entries_before THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC142 global row-count drift'; END IF;
 DROP TEMPORARY TABLE rrc142_before;
 DROP TEMPORARY TABLE rrc142_after;
 DROP TEMPORARY TABLE rrc142_recipes;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC142',changed_rows,recipes_before,(SELECT COUNT(*)FROM tradeskill_recipe),entries_before,(SELECT COUNT(*)FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
