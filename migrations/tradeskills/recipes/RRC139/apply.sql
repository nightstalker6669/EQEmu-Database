-- RRC139:Two existing trivial fields only; exact selected current preimages required.
DELIMITER //
BEGIN NOT ATOMIC
 DECLARE own_transaction BOOLEAN DEFAULT FALSE;
 DECLARE recipes_before BIGINT DEFAULT 0;
 DECLARE entries_before BIGINT DEFAULT 0;
 DECLARE locked_rows BIGINT DEFAULT 0;
 DECLARE changed_rows BIGINT DEFAULT 0;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN IF own_transaction THEN ROLLBACK;END IF;RESIGNAL;END;
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC139 target/transaction mismatch';END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC139 strict mode required';END IF;
 IF(SELECT COUNT(*)FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE()AND TABLE_NAME IN('tradeskill_recipe','tradeskill_recipe_entries')AND ENGINE='InnoDB')<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC139 InnoDB mismatch';END IF;
 CREATE TEMPORARY TABLE rrc139_before LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc139_after LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc139_entries LIKE tradeskill_recipe_entries;
 INSERT INTO rrc139_before(`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`)VALUES
(348,CONVERT(0x417a696d75746820496e64696361746976652043756972617373 USING utf8mb4),57,0,275,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(484,CONVERT(0x50657270657475616c204169722050756d70 USING utf8mb4),57,0,168,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc139_after(`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`)VALUES
(348,CONVERT(0x417a696d75746820496e64696361746976652043756972617373 USING utf8mb4),57,0,268,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(484,CONVERT(0x50657270657475616c204169722050756d70 USING utf8mb4),57,0,170,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc139_entries(`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`)VALUES
(2685,348,4004,0,0,1,1,0),
(2686,348,9179,0,0,1,1,0),
(2687,348,9181,0,0,1,1,0),
(2688,348,9184,0,0,1,1,0),
(2689,348,16867,0,0,1,1,0),
(2690,348,8996,1,0,0,0,0),
(2691,348,17276,0,0,0,0,1),
(2692,348,17877,0,0,0,0,1),
(2693,348,17902,0,0,0,0,1),
(3772,484,7483,0,0,1,1,0),
(3773,484,9179,0,0,1,1,0),
(3774,484,9184,0,0,1,1,0),
(3775,484,9195,0,0,1,1,0),
(3776,484,16858,0,0,1,1,0),
(3777,484,9196,1,0,0,0,0),
(3778,484,17276,0,0,0,0,1),
(3779,484,17877,0,0,0,0,1),
(3780,484,17902,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*)INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*)INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe r JOIN rrc139_before e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC139 missing definitions';END IF;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe_entries r JOIN rrc139_entries e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>18 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC139 missing entries';END IF;
 IF EXISTS(SELECT 1 FROM rrc139_before e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC139 definition mismatch';END IF;
 IF EXISTS(SELECT 1 FROM rrc139_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc139_before p ON p.id=r.recipe_id)<>18 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC139 preserved entry mismatch';END IF;
 UPDATE tradeskill_recipe r JOIN rrc139_after e ON r.id=e.id SET r.trivial=e.trivial;
 SET changed_rows=ROW_COUNT();
 IF changed_rows<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC139 changed row mismatch';END IF;
 IF EXISTS(SELECT 1 FROM rrc139_after e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC139 definition mismatch';END IF;
 IF EXISTS(SELECT 1 FROM rrc139_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc139_before p ON p.id=r.recipe_id)<>18 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC139 preserved entry mismatch';END IF;
 IF(SELECT COUNT(*)FROM tradeskill_recipe)<>recipes_before OR(SELECT COUNT(*)FROM tradeskill_recipe_entries)<>entries_before THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC139 row count drift';END IF;
 DROP TEMPORARY TABLE rrc139_before;
 DROP TEMPORARY TABLE rrc139_after;
 DROP TEMPORARY TABLE rrc139_entries;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC139',changed_rows,recipes_before,(SELECT COUNT(*)FROM tradeskill_recipe),entries_before,(SELECT COUNT(*)FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
