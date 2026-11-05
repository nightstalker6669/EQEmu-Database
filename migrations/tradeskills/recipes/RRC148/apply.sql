-- RRC148:One existing no-fail field only; exact selected current preimages required.
DELIMITER //
BEGIN NOT ATOMIC
 DECLARE own_transaction BOOLEAN DEFAULT FALSE;
 DECLARE recipes_before BIGINT DEFAULT 0;
 DECLARE entries_before BIGINT DEFAULT 0;
 DECLARE locked_rows BIGINT DEFAULT 0;
 DECLARE changed_rows BIGINT DEFAULT 0;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN IF own_transaction THEN ROLLBACK;END IF;RESIGNAL;END;
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC148 target/transaction mismatch';END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC148 strict mode required';END IF;
 IF(SELECT COUNT(*)FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE()AND TABLE_NAME IN('tradeskill_recipe','tradeskill_recipe_entries')AND ENGINE='InnoDB')<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC148 InnoDB mismatch';END IF;
 CREATE TEMPORARY TABLE rrc148_before LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc148_after LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc148_entries LIKE tradeskill_recipe_entries;
 INSERT INTO rrc148_before(`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`)VALUES
(5400,CONVERT(0x4c697a6172647363616c6520506c617465205368656574 USING utf8mb4),63,0,15,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc148_after(`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`)VALUES
(5400,CONVERT(0x4c697a6172647363616c6520506c617465205368656574 USING utf8mb4),63,0,15,1,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc148_entries(`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`)VALUES
(52372,5400,27752,0,0,2,2,0),
(52373,5400,27756,0,0,1,1,0),
(52374,5400,27759,1,0,0,0,0),
(52375,5400,17,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*)INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*)INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe r JOIN rrc148_before e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC148 missing definitions';END IF;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe_entries r JOIN rrc148_entries e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC148 missing entries';END IF;
 IF EXISTS(SELECT 1 FROM rrc148_before e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC148 definition mismatch';END IF;
 IF EXISTS(SELECT 1 FROM rrc148_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc148_before p ON p.id=r.recipe_id)<>4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC148 preserved entry mismatch';END IF;
 UPDATE tradeskill_recipe r JOIN rrc148_after e ON r.id=e.id SET r.nofail=e.nofail;
 SET changed_rows=ROW_COUNT();
 IF changed_rows<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC148 changed row mismatch';END IF;
 IF EXISTS(SELECT 1 FROM rrc148_after e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC148 definition mismatch';END IF;
 IF EXISTS(SELECT 1 FROM rrc148_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc148_before p ON p.id=r.recipe_id)<>4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC148 preserved entry mismatch';END IF;
 IF(SELECT COUNT(*)FROM tradeskill_recipe)<>recipes_before OR(SELECT COUNT(*)FROM tradeskill_recipe_entries)<>entries_before THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC148 row count drift';END IF;
 DROP TEMPORARY TABLE rrc148_before;
 DROP TEMPORARY TABLE rrc148_after;
 DROP TEMPORARY TABLE rrc148_entries;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC148',changed_rows,recipes_before,(SELECT COUNT(*)FROM tradeskill_recipe),entries_before,(SELECT COUNT(*)FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
