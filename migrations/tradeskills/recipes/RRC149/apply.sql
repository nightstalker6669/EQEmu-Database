-- RRC149:Four existing trivial fields only; exact selected current preimages required.
DELIMITER //
BEGIN NOT ATOMIC
 DECLARE own_transaction BOOLEAN DEFAULT FALSE;
 DECLARE recipes_before BIGINT DEFAULT 0;
 DECLARE entries_before BIGINT DEFAULT 0;
 DECLARE locked_rows BIGINT DEFAULT 0;
 DECLARE changed_rows BIGINT DEFAULT 0;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN IF own_transaction THEN ROLLBACK;END IF;RESIGNAL;END;
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC149 target/transaction mismatch';END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC149 strict mode required';END IF;
 IF(SELECT COUNT(*)FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE()AND TABLE_NAME IN('tradeskill_recipe','tradeskill_recipe_entries')AND ENGINE='InnoDB')<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC149 InnoDB mismatch';END IF;
 CREATE TEMPORARY TABLE rrc149_before LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc149_after LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc149_entries LIKE tradeskill_recipe_entries;
 INSERT INTO rrc149_before(`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`)VALUES
(4508,CONVERT(0x466f726765642056656c69756d2053687572696b656e USING utf8mb4),63,0,90,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(4509,CONVERT(0x466f726765642056656c69756d205468726f77696e6720417865 USING utf8mb4),63,0,107,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(4510,CONVERT(0x466f726765642056656c69756d205468726f77696e67204b6e696665 USING utf8mb4),63,0,79,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(4511,CONVERT(0x466f726765642056656c69756d205468726f77696e67205370656172 USING utf8mb4),63,0,105,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc149_after(`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`)VALUES
(4508,CONVERT(0x466f726765642056656c69756d2053687572696b656e USING utf8mb4),63,0,104,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(4509,CONVERT(0x466f726765642056656c69756d205468726f77696e6720417865 USING utf8mb4),63,0,102,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(4510,CONVERT(0x466f726765642056656c69756d205468726f77696e67204b6e696665 USING utf8mb4),63,0,98,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(4511,CONVERT(0x466f726765642056656c69756d205468726f77696e67205370656172 USING utf8mb4),63,0,106,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc149_entries(`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`)VALUES
(44037,4508,22083,0,0,1,1,0),
(44038,4508,22095,0,0,1,1,0),
(44039,4508,22564,0,0,1,1,0),
(44040,4508,8346,20,0,0,0,0),
(44041,4508,17,0,0,0,0,1),
(44042,4509,22084,0,0,1,1,0),
(44043,4509,22095,0,0,1,1,0),
(44044,4509,22564,0,0,1,1,0),
(44045,4509,8347,15,0,0,0,0),
(44046,4509,17,0,0,0,0,1),
(44047,4510,22081,0,0,1,1,0),
(44048,4510,22095,0,0,1,1,0),
(44049,4510,22564,0,0,1,1,0),
(44050,4510,8344,20,0,0,0,0),
(44051,4510,17,0,0,0,0,1),
(44052,4511,22082,0,0,1,1,0),
(44053,4511,22095,0,0,1,1,0),
(44054,4511,22564,0,0,1,1,0),
(44055,4511,8345,15,0,0,0,0),
(44056,4511,17,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*)INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*)INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe r JOIN rrc149_before e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC149 missing definitions';END IF;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe_entries r JOIN rrc149_entries e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>20 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC149 missing entries';END IF;
 IF EXISTS(SELECT 1 FROM rrc149_before e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC149 definition mismatch';END IF;
 IF EXISTS(SELECT 1 FROM rrc149_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc149_before p ON p.id=r.recipe_id)<>20 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC149 preserved entry mismatch';END IF;
 UPDATE tradeskill_recipe r JOIN rrc149_after e ON r.id=e.id SET r.trivial=e.trivial;
 SET changed_rows=ROW_COUNT();
 IF changed_rows<>4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC149 changed row mismatch';END IF;
 IF EXISTS(SELECT 1 FROM rrc149_after e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC149 definition mismatch';END IF;
 IF EXISTS(SELECT 1 FROM rrc149_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc149_before p ON p.id=r.recipe_id)<>20 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC149 preserved entry mismatch';END IF;
 IF(SELECT COUNT(*)FROM tradeskill_recipe)<>recipes_before OR(SELECT COUNT(*)FROM tradeskill_recipe_entries)<>entries_before THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC149 row count drift';END IF;
 DROP TEMPORARY TABLE rrc149_before;
 DROP TEMPORARY TABLE rrc149_after;
 DROP TEMPORARY TABLE rrc149_entries;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC149',changed_rows,recipes_before,(SELECT COUNT(*)FROM tradeskill_recipe),entries_before,(SELECT COUNT(*)FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
