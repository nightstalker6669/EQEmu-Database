-- RRC126: one existing output yield field only. Fresh dedicated strict MariaDB session.
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
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC126 target/transaction mismatch'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC126 strict mode required'; END IF;
 IF(SELECT COUNT(*)FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE()AND TABLE_NAME IN('tradeskill_recipe','tradeskill_recipe_entries','items')AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC126 InnoDB mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc126_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc126_before LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc126_after LIKE tradeskill_recipe_entries;
 INSERT INTO rrc126_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(7295,CONVERT(0x436c617373203720447261676f726e20446973636f726420546970204172726f772028736d616c6c29 USING utf8mb4),64,0,255,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc126_before (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(68974,7295,8052,0,0,1,1,0),
(68975,7295,63862,0,0,1,1,0),
(68976,7295,72092,0,0,1,1,0),
(68977,7295,72093,0,0,1,1,0),
(68978,7295,75604,10,0,0,0,0),
(68979,7295,17128,0,0,0,0,1),
(68980,7295,17189,0,0,0,0,1),
(68981,7295,17762,0,0,0,0,1),
(68982,7295,17910,0,0,0,0,1),
(68983,7295,66163,0,0,0,0,1);
 INSERT INTO rrc126_after (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(68974,7295,8052,0,0,1,1,0),
(68975,7295,63862,0,0,1,1,0),
(68976,7295,72092,0,0,1,1,0),
(68977,7295,72093,0,0,1,1,0),
(68978,7295,75604,1,0,0,0,0),
(68979,7295,17128,0,0,0,0,1),
(68980,7295,17189,0,0,0,0,1),
(68981,7295,17762,0,0,0,0,1),
(68982,7295,17910,0,0,0,0,1),
(68983,7295,66163,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*)INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*)INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe r JOIN rrc126_recipes e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC126 definition/peer missing'; END IF;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe_entries r JOIN rrc126_before e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>10 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC126 target/peer entries missing'; END IF;
 IF EXISTS(SELECT 1 FROM rrc126_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC126 definition/peer drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc126_before e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc126_recipes p ON p.id=r.recipe_id)<>10 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC126 preimage mismatch'; END IF;
 IF(SELECT COUNT(*)FROM items WHERE (`id` <=> 75604 AND BINARY Name=BINARY CONVERT(0x434c415353203720447261676f726e20446973636f726420546970204172726f77 USING utf8mb4) AND `itemclass` <=> 0 AND `itemtype` <=> 27 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `damage` <=> 11 AND `delay` <=> 0 AND `range` <=> 125 AND `races` <=> 65535 AND `classes` <=> 285 AND `deity` <=> 0))<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC126 native item identity/range drift'; END IF;
 UPDATE tradeskill_recipe_entries r JOIN rrc126_after e ON r.id=e.id SET r.successcount=e.successcount WHERE r.id IN(68978);
 SET changed_rows=ROW_COUNT();
 IF changed_rows<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC126 changed-row mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc126_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC126 definition/peer drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc126_after e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc126_recipes p ON p.id=r.recipe_id)<>10 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC126 postimage mismatch'; END IF;
 IF(SELECT COUNT(*)FROM tradeskill_recipe)<>recipes_before OR(SELECT COUNT(*)FROM tradeskill_recipe_entries)<>entries_before THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC126 global row-count drift'; END IF;
 DROP TEMPORARY TABLE rrc126_before;
 DROP TEMPORARY TABLE rrc126_after;
 DROP TEMPORARY TABLE rrc126_recipes;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC126',changed_rows,recipes_before,(SELECT COUNT(*)FROM tradeskill_recipe),entries_before,(SELECT COUNT(*)FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
