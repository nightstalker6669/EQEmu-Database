-- RRC037: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
-- Source recipe facts/provenance: batch.public.json. No engine/updater/version/rule changes.
-- Anonymous compound block: no permanent helper procedure or migration table.
DELIMITER //
BEGIN NOT ATOMIC
 DECLARE own_transaction BOOLEAN DEFAULT FALSE;
 DECLARE already_present INT DEFAULT 0;
 DECLARE recipes_before BIGINT DEFAULT 0;
 DECLARE entries_before BIGINT DEFAULT 0;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION
 BEGIN
  IF own_transaction THEN ROLLBACK; END IF;
  RESIGNAL;
 END;
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC037 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC037 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC037 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC037 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc037_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc037_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc037_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc037_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3092444,CONVERT(0x5472696f2053657474696e6720546f6f6c USING utf8mb4),68,0,15,1,0,CONVERT(0x506f52206d616e75666163747572696e6720746f6f6c732f676c6173733b204551544320646972656374207072696d61727920726f77733b205252433033372e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3092445,CONVERT(0x44756f2053657474696e6720546f6f6c USING utf8mb4),68,0,15,1,0,CONVERT(0x506f52206d616e75666163747572696e6720746f6f6c732f676c6173733b204551544320646972656374207072696d61727920726f77733b205252433033372e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3092446,CONVERT(0x536f6c6f2053657474696e6720546f6f6c USING utf8mb4),68,0,15,1,0,CONVERT(0x506f52206d616e75666163747572696e6720746f6f6c732f676c6173733b204551544320646972656374207072696d61727920726f77733b205252433033372e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL);
INSERT INTO rrc037_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3092444,37805,1,0,0,0,0),
(3092444,37804,0,0,1,1,0),
(3092444,20,0,0,0,0,1),
(3092445,37804,1,0,0,0,0),
(3092445,37803,0,0,1,1,0),
(3092445,20,0,0,0,0,1),
(3092446,37803,1,0,0,0,0),
(3092446,95832,0,0,1,1,0),
(3092446,20,0,0,0,0,1);
INSERT INTO rrc037_items (`id`,`name`) VALUES
(17187,CONVERT(0x436f6c6c61707369626c65204a6577656c65722773204b6974 USING utf8mb4)),
(17764,CONVERT(0x506c616e6172204a6577656c65722773204b6974 USING utf8mb4)),
(17912,CONVERT(0x4a6577656c65722773204b6974 USING utf8mb4)),
(37803,CONVERT(0x536f6c6f2053657474696e6720546f6f6c USING utf8mb4)),
(37804,CONVERT(0x44756f2053657474696e6720546f6f6c USING utf8mb4)),
(37805,CONVERT(0x5472696f2053657474696e6720546f6f6c USING utf8mb4)),
(62480,CONVERT(0x5265696e666f72636564204a6577656c65722773204b6974 USING utf8mb4)),
(95832,CONVERT(0x4d617271756973652043757420546f6f6c USING utf8mb4));
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc037_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc037_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC037 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE itemclass=1 AND classes=65535 AND races=131071 AND ((id=17912 AND bagtype=20 AND bagslots=4) OR (id IN (17764,17187,62480) AND bagtype=20 AND bagslots=6)))<>4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC037 jewelry kit dependency mismatch'; END IF;
 IF already_present NOT IN (0,3) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC037 partial batch or ID collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r JOIN rrc037_recipes e ON r.tradeskill=e.tradeskill AND r.name=e.name WHERE r.id<>e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC037 existing recipe-name collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc037_entries e ON r.item_id=e.item_id JOIN rrc037_recipes q ON e.recipe_id=q.id WHERE e.successcount>0 AND e.componentcount=0 AND e.iscontainer=0 AND r.successcount>r.componentcount AND r.iscontainer=0 AND r.recipe_id<>e.recipe_id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC037 existing output recipe collision'; END IF;
 IF already_present=0 THEN
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc037_recipes e ON r.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC037 orphan target entries collision'; END IF;
 INSERT INTO tradeskill_recipe (id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled) SELECT id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled FROM rrc037_recipes;
 INSERT INTO tradeskill_recipe_entries (recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer) SELECT recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer FROM rrc037_entries;
 END IF;
 IF EXISTS(SELECT 1 FROM rrc037_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC037 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc037_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC037 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc037_recipes q ON q.id=r.recipe_id LEFT JOIN rrc037_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC037 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc037_recipes q ON q.id=r.recipe_id)<>9 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC037 target entry multiplicity mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before+IF(already_present=0,3,0) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before+IF(already_present=0,9,0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC037 unexpected table row-count delta'; END IF;
 DROP TEMPORARY TABLE rrc037_entries;
 DROP TEMPORARY TABLE rrc037_recipes;
 DROP TEMPORARY TABLE rrc037_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC037' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
