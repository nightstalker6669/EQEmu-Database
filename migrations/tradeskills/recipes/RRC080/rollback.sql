-- RRC080: one existing ingredient ID only; fresh dedicated MariaDB CLI session.
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
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC080 invalid transaction/target'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC080 strict mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC080 InnoDB mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc080_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc080_before LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc080_after LIKE tradeskill_recipe_entries;
 INSERT INTO rrc080_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(12129,CONVERT(0x5370656c6c3a20466f637573204d617373204372756465205370656c6c636173746572277320457373656e6365 USING utf8mb4),58,0,62,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc080_before (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(144747,12129,93557,0,0,1,1,0),
(144748,12129,93542,0,0,1,1,0),
(144749,12129,93560,0,0,1,1,0),
(144750,12129,93574,0,0,1,1,0),
(144751,12129,97768,0,0,1,1,0),
(144752,12129,93526,0,0,1,1,0),
(144753,12129,36379,1,0,0,0,0),
(144754,12129,93492,0,0,0,0,1);
 INSERT INTO rrc080_after (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(144747,12129,93557,0,0,1,1,0),
(144748,12129,93542,0,0,1,1,0),
(144749,12129,93560,0,0,1,1,0),
(144750,12129,93574,0,0,1,1,0),
(144751,12129,97767,0,0,1,1,0),
(144752,12129,93526,0,0,1,1,0),
(144753,12129,36379,1,0,0,0,0),
(144754,12129,93492,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO locked_rows FROM tradeskill_recipe r JOIN rrc080_recipes e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC080 recipe missing'; END IF;
 SELECT COUNT(*) INTO locked_rows FROM tradeskill_recipe_entries r JOIN rrc080_before e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC080 entry missing'; END IF;
 IF EXISTS(SELECT 1 FROM rrc080_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC080 recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc080_before e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc080_recipes p ON p.id=r.recipe_id)<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC080 preimage mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE (id=97767 AND BINARY Name=BINARY CONVERT(0x536d6f6f746820526f7567682048696465 USING utf8mb4) AND size=1 AND itemclass=0 AND stackable=1 AND maxcharges=0) OR (id=97768 AND BINARY Name=BINARY CONVERT(0x5072697374696e6520526f7567682048696465 USING utf8mb4) AND size=1 AND itemclass=0 AND stackable=1 AND maxcharges=0))<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC080 page identity/size mismatch'; END IF;
 UPDATE tradeskill_recipe_entries r JOIN rrc080_after e ON r.id=e.id SET r.item_id=e.item_id WHERE r.id IN (144751);
 SET changed_rows=ROW_COUNT();
 IF changed_rows<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC080 changed-row mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc080_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC080 recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc080_after e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc080_recipes p ON p.id=r.recipe_id)<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC080 postimage mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC080 row-count mismatch'; END IF;
 DROP TEMPORARY TABLE rrc080_before;
 DROP TEMPORARY TABLE rrc080_after;
 DROP TEMPORARY TABLE rrc080_recipes;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC080',changed_rows,recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe),entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
