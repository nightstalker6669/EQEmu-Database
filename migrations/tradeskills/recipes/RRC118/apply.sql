-- RRC118: two existing output IDs only. Fresh dedicated strict MariaDB session.
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
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC118 target/transaction mismatch'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC118 strict mode required'; END IF;
 IF(SELECT COUNT(*)FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE()AND TABLE_NAME IN('tradeskill_recipe','tradeskill_recipe_entries','items')AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC118 InnoDB mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc118_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc118_before LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc118_after LIKE tradeskill_recipe_entries;
 INSERT INTO rrc118_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(7041,CONVERT(0x436c617373203320426f6e6520486f6f6b6564204172726f77 USING utf8mb4),64,0,102,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7042,CONVERT(0x436c617373203320426f6e6520486f6f6b6564204172726f77 USING utf8mb4),64,0,102,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc118_before (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(66434,7041,8052,0,0,1,1,0),
(66435,7041,8056,0,0,1,1,0),
(66436,7041,8061,0,0,1,1,0),
(66437,7041,8066,0,0,1,1,0),
(66438,7041,8598,5,0,0,0,0),
(66439,7041,17128,0,0,0,0,1),
(66440,7041,17189,0,0,0,0,1),
(66441,7041,17762,0,0,0,0,1),
(66442,7041,17910,0,0,0,0,1),
(66443,7041,66163,0,0,0,0,1),
(66444,7042,8051,0,0,1,1,0),
(66445,7042,8056,0,0,1,1,0),
(66446,7042,8061,0,0,1,1,0),
(66447,7042,8066,0,0,1,1,0),
(66448,7042,8670,5,0,0,0,0),
(66449,7042,17128,0,0,0,0,1),
(66450,7042,17189,0,0,0,0,1),
(66451,7042,17762,0,0,0,0,1),
(66452,7042,17910,0,0,0,0,1),
(66453,7042,66163,0,0,0,0,1);
 INSERT INTO rrc118_after (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(66434,7041,8052,0,0,1,1,0),
(66435,7041,8056,0,0,1,1,0),
(66436,7041,8061,0,0,1,1,0),
(66437,7041,8066,0,0,1,1,0),
(66438,7041,8670,5,0,0,0,0),
(66439,7041,17128,0,0,0,0,1),
(66440,7041,17189,0,0,0,0,1),
(66441,7041,17762,0,0,0,0,1),
(66442,7041,17910,0,0,0,0,1),
(66443,7041,66163,0,0,0,0,1),
(66444,7042,8051,0,0,1,1,0),
(66445,7042,8056,0,0,1,1,0),
(66446,7042,8061,0,0,1,1,0),
(66447,7042,8066,0,0,1,1,0),
(66448,7042,8598,5,0,0,0,0),
(66449,7042,17128,0,0,0,0,1),
(66450,7042,17189,0,0,0,0,1),
(66451,7042,17762,0,0,0,0,1),
(66452,7042,17910,0,0,0,0,1),
(66453,7042,66163,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*)INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*)INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe r JOIN rrc118_recipes e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC118 definition/peer missing'; END IF;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe_entries r JOIN rrc118_before e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>20 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC118 target/peer entries missing'; END IF;
 IF EXISTS(SELECT 1 FROM rrc118_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC118 definition/peer drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc118_before e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc118_recipes p ON p.id=r.recipe_id)<>20 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC118 preimage mismatch'; END IF;
 IF(SELECT COUNT(*)FROM items WHERE (`id` <=> 8598 AND BINARY Name=BINARY CONVERT(0x434c415353203320426f6e6520486f6f6b6564204172726f77 USING utf8mb4) AND `itemclass` <=> 0 AND `itemtype` <=> 27 AND `damage` <=> 4 AND `delay` <=> 0 AND `range` <=> 25 AND `size` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `classes` <=> 285 AND `races` <=> 65535 AND `slots` <=> 4194304 AND `reqlevel` <=> 0 AND `reclevel` <=> 0) OR (`id` <=> 8670 AND BINARY Name=BINARY CONVERT(0x434c415353203320426f6e6520486f6f6b6564204172726f77 USING utf8mb4) AND `itemclass` <=> 0 AND `itemtype` <=> 27 AND `damage` <=> 4 AND `delay` <=> 0 AND `range` <=> 50 AND `size` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `classes` <=> 285 AND `races` <=> 65535 AND `slots` <=> 4194304 AND `reqlevel` <=> 0 AND `reclevel` <=> 0) OR (`id` <=> 8051 AND BINARY Name=BINARY CONVERT(0x4d656469756d2047726f6f7665204e6f636b73 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `range` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0) OR (`id` <=> 8052 AND BINARY Name=BINARY CONVERT(0x536d616c6c2047726f6f7665204e6f636b73 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `range` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0))<>4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC118 native item identity/range drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.iscontainer=0 AND e.successcount>e.componentcount AND e.item_id IN(8598,8670)AND NOT EXISTS(SELECT 1 FROM rrc118_recipes p WHERE p.id=e.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC118 output-producer universe drift'; END IF;
 UPDATE tradeskill_recipe_entries r JOIN rrc118_after e ON r.id=e.id SET r.item_id=e.item_id WHERE r.id IN(66438,66448);
 SET changed_rows=ROW_COUNT();
 IF changed_rows<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC118 changed-row mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc118_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC118 definition/peer drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc118_after e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc118_recipes p ON p.id=r.recipe_id)<>20 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC118 postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.iscontainer=0 AND e.successcount>e.componentcount AND e.item_id IN(8598,8670)AND NOT EXISTS(SELECT 1 FROM rrc118_recipes p WHERE p.id=e.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC118 output-producer universe drift'; END IF;
 IF(SELECT COUNT(*)FROM tradeskill_recipe)<>recipes_before OR(SELECT COUNT(*)FROM tradeskill_recipe_entries)<>entries_before THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC118 global row-count drift'; END IF;
 DROP TEMPORARY TABLE rrc118_before;
 DROP TEMPORARY TABLE rrc118_after;
 DROP TEMPORARY TABLE rrc118_recipes;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC118',changed_rows,recipes_before,(SELECT COUNT(*)FROM tradeskill_recipe),entries_before,(SELECT COUNT(*)FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
