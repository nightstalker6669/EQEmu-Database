-- RRC036: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC036 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC036 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC036 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC036 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc036_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc036_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc036_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc036_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3092436,CONVERT(0x48616c662d4d6f6f6e2043757420546f6f6c USING utf8mb4),68,0,15,1,0,CONVERT(0x506f52206d616e75666163747572696e6720746f6f6c732f676c6173733b204551544320646972656374207072696d61727920726f77733b205252433033362e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3092437,CONVERT(0x4a6577656c65727320476c617373 USING utf8mb4),68,0,20,0,0,CONVERT(0x506f52206d616e75666163747572696e6720746f6f6c732f676c6173733b204551544320646972656374207072696d61727920726f77733b205252433033362e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3092438,CONVERT(0x4d617271756973652043757420546f6f6c USING utf8mb4),68,0,15,1,0,CONVERT(0x506f52206d616e75666163747572696e6720746f6f6c732f676c6173733b204551544320646972656374207072696d61727920726f77733b205252433033362e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3092439,CONVERT(0x4f76616c2043757420546f6f6c USING utf8mb4),68,0,15,1,0,CONVERT(0x506f52206d616e75666163747572696e6720746f6f6c732f676c6173733b204551544320646972656374207072696d61727920726f77733b205252433033362e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3092440,CONVERT(0x506561722043757420546f6f6c USING utf8mb4),68,0,15,1,0,CONVERT(0x506f52206d616e75666163747572696e6720746f6f6c732f676c6173733b204551544320646972656374207072696d61727920726f77733b205252433033362e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3092441,CONVERT(0x526f756e642043757420546f6f6c USING utf8mb4),68,0,15,1,0,CONVERT(0x506f52206d616e75666163747572696e6720746f6f6c732f676c6173733b204551544320646972656374207072696d61727920726f77733b205252433033362e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3092442,CONVERT(0x5371756172652043757420546f6f6c USING utf8mb4),68,0,15,1,0,CONVERT(0x506f52206d616e75666163747572696e6720746f6f6c732f676c6173733b204551544320646972656374207072696d61727920726f77733b205252433033362e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3092443,CONVERT(0x5472696c6c696f6e2043757420546f6f6c USING utf8mb4),68,0,15,1,0,CONVERT(0x506f52206d616e75666163747572696e6720746f6f6c732f676c6173733b204551544320646972656374207072696d61727920726f77733b205252433033362e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL);
INSERT INTO rrc036_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3092436,95829,1,0,0,0,0),
(3092436,95828,0,0,1,1,0),
(3092436,20,0,0,0,0,1),
(3092437,95833,1,0,0,0,0),
(3092437,95835,0,0,1,1,0),
(3092437,95834,0,0,1,1,0),
(3092437,20,0,0,0,0,1),
(3092438,95832,1,0,0,0,0),
(3092438,95831,0,0,1,1,0),
(3092438,20,0,0,0,0,1),
(3092439,95828,1,0,0,0,0),
(3092439,95827,0,0,1,1,0),
(3092439,20,0,0,0,0,1),
(3092440,95831,1,0,0,0,0),
(3092440,95830,0,0,1,1,0),
(3092440,20,0,0,0,0,1),
(3092441,95827,1,0,0,0,0),
(3092441,95826,0,0,1,1,0),
(3092441,20,0,0,0,0,1),
(3092442,95826,1,0,0,0,0),
(3092442,37805,0,0,1,1,0),
(3092442,20,0,0,0,0,1),
(3092443,95830,1,0,0,0,0),
(3092443,95829,0,0,1,1,0),
(3092443,20,0,0,0,0,1);
INSERT INTO rrc036_items (`id`,`name`) VALUES
(17187,CONVERT(0x436f6c6c61707369626c65204a6577656c65722773204b6974 USING utf8mb4)),
(17764,CONVERT(0x506c616e6172204a6577656c65722773204b6974 USING utf8mb4)),
(17912,CONVERT(0x4a6577656c65722773204b6974 USING utf8mb4)),
(37805,CONVERT(0x5472696f2053657474696e6720546f6f6c USING utf8mb4)),
(62480,CONVERT(0x5265696e666f72636564204a6577656c65722773204b6974 USING utf8mb4)),
(95826,CONVERT(0x5371756172652043757420546f6f6c USING utf8mb4)),
(95827,CONVERT(0x526f756e642043757420546f6f6c USING utf8mb4)),
(95828,CONVERT(0x4f76616c2043757420546f6f6c USING utf8mb4)),
(95829,CONVERT(0x48616c662d4d6f6f6e2043757420546f6f6c USING utf8mb4)),
(95830,CONVERT(0x5472696c696f6e2043757420546f6f6c USING utf8mb4)),
(95831,CONVERT(0x506561722043757420546f6f6c USING utf8mb4)),
(95832,CONVERT(0x4d617271756973652043757420546f6f6c USING utf8mb4)),
(95833,CONVERT(0x4a6577656c65727320476c617373 USING utf8mb4)),
(95834,CONVERT(0x4a6577656c65727320476c617373204c656e73 USING utf8mb4)),
(95835,CONVERT(0x4a6577656c65727320476c61737320437570 USING utf8mb4));
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc036_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc036_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC036 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE itemclass=1 AND classes=65535 AND races=131071 AND ((id=17912 AND bagtype=20 AND bagslots=4) OR (id IN (17764,17187,62480) AND bagtype=20 AND bagslots=6)))<>4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC036 jewelry kit dependency mismatch'; END IF;
 IF already_present<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC036 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc036_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC036 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc036_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC036 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc036_recipes q ON q.id=r.recipe_id LEFT JOIN rrc036_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC036 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc036_recipes q ON q.id=r.recipe_id)<>25 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC036 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc036_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC036 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc036_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc036_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-8 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-25 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC036 rollback count mismatch'; END IF;
 DROP TEMPORARY TABLE rrc036_entries;
 DROP TEMPORARY TABLE rrc036_recipes;
 DROP TEMPORARY TABLE rrc036_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC036' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
