-- RRC010: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC010 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC010 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC010 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC010 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc010_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc010_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc010_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc010_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3091250,CONVERT(0x526567616c2048616674 USING utf8mb4),64,0,282,0,0,CONVERT(0x526f463b20436f6d70656e6469756d7320526567616c20576561706f6e204372656174696f6e20507449493b205252433031302e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091251,CONVERT(0x526567616c2048616e646c65 USING utf8mb4),64,0,282,0,0,CONVERT(0x526f463b20436f6d70656e6469756d7320526567616c20576561706f6e204372656174696f6e20507449493b205252433031302e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091252,CONVERT(0x526567616c204c6f6e672048616674 USING utf8mb4),64,0,282,0,0,CONVERT(0x526f463b20436f6d70656e6469756d7320526567616c20576561706f6e204372656174696f6e20507449493b205252433031302e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091253,CONVERT(0x526567616c2053686f72742048616674 USING utf8mb4),64,0,282,0,0,CONVERT(0x526f463b20436f6d70656e6469756d7320526567616c20576561706f6e204372656174696f6e20507449493b205252433031302e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091254,CONVERT(0x526567616c205374616666 USING utf8mb4),64,0,284,0,0,CONVERT(0x526f463b20436f6d70656e6469756d7320526567616c20576561706f6e204372656174696f6e20507449493b205252433031302e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091255,CONVERT(0x53636f7263686564204261726273 USING utf8mb4),63,0,282,0,0,CONVERT(0x526f463b20436f6d70656e6469756d7320526567616c20576561706f6e204372656174696f6e20507449493b205252433031302e USING utf8mb4),0,135562,0,1,19,-1,NULL,NULL),
(3091256,CONVERT(0x53636f7263686564205374756473 USING utf8mb4),63,0,282,0,0,CONVERT(0x526f463b20436f6d70656e6469756d7320526567616c20576561706f6e204372656174696f6e20507449493b205252433031302e USING utf8mb4),0,135562,0,1,19,-1,NULL,NULL),
(3091257,CONVERT(0x4265666f756c65642048696c742057726170 USING utf8mb4),61,0,282,0,0,CONVERT(0x526f463b20436f6d70656e6469756d7320526567616c20576561706f6e204372656174696f6e20507449493b205252433031302e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL);
INSERT INTO rrc010_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3091250,135437,1,0,0,0,0),
(3091250,38513,1,1,1,0,0),
(3091250,134653,0,0,1,1,0),
(3091250,8084,0,0,1,1,0),
(3091250,8086,1,1,1,0,0),
(3091250,18,0,0,0,0,1),
(3091251,135441,1,0,0,0,0),
(3091251,38511,1,1,1,0,0),
(3091251,134653,0,0,1,1,0),
(3091251,8084,0,0,1,1,0),
(3091251,8086,1,1,1,0,0),
(3091251,18,0,0,0,0,1),
(3091252,135438,1,0,0,0,0),
(3091252,38515,1,1,1,0,0),
(3091252,134653,0,0,1,1,0),
(3091252,8084,0,0,1,1,0),
(3091252,8086,1,1,1,0,0),
(3091252,18,0,0,0,0,1),
(3091253,135436,1,0,0,0,0),
(3091253,38512,1,1,1,0,0),
(3091253,134653,0,0,1,1,0),
(3091253,8084,0,0,1,1,0),
(3091253,8086,1,1,1,0,0),
(3091253,18,0,0,0,0,1),
(3091254,135440,1,0,0,0,0),
(3091254,134653,0,0,1,1,0),
(3091254,8084,0,0,1,1,0),
(3091254,8086,1,1,1,0,0),
(3091254,18,0,0,0,0,1),
(3091255,135432,1,0,0,0,0),
(3091255,12011,1,1,1,0,0),
(3091255,134654,0,0,1,1,0),
(3091255,17,0,0,0,0,1),
(3091256,135433,1,0,0,0,0),
(3091256,134654,0,0,1,1,0),
(3091256,10489,1,1,1,0,0),
(3091256,17,0,0,0,0,1),
(3091257,135435,1,0,0,0,0),
(3091257,134652,0,0,1,1,0),
(3091257,65259,1,1,1,0,0),
(3091257,16,0,0,0,0,1);
INSERT INTO rrc010_items (`id`,`name`) VALUES
(8084,CONVERT(0x4461726b776f6f6420426f77205374616666 USING utf8mb4)),
(8086,CONVERT(0x506c616e696e6720546f6f6c USING utf8mb4)),
(10489,CONVERT(0x536d697468792048616d6d6572 USING utf8mb4)),
(12011,CONVERT(0x46696c65 USING utf8mb4)),
(17908,CONVERT(0x536d616c6c20536577696e67204b6974 USING utf8mb4)),
(17909,CONVERT(0x466f726765 USING utf8mb4)),
(17910,CONVERT(0x466c65746368696e67204b6974 USING utf8mb4)),
(38511,CONVERT(0x32204b6e6f74204d6561737572696e6720537472696e67 USING utf8mb4)),
(38512,CONVERT(0x33204b6e6f74204d6561737572696e6720537472696e67 USING utf8mb4)),
(38513,CONVERT(0x34204b6e6f74204d6561737572696e6720537472696e67 USING utf8mb4)),
(38515,CONVERT(0x36204b6e6f74204d6561737572696e6720537472696e67 USING utf8mb4)),
(65259,CONVERT(0x4869636b6f72792048616e646c656420536865617273 USING utf8mb4)),
(134652,CONVERT(0x4265666f756c656420416e696d616c2050656c74 USING utf8mb4)),
(134653,CONVERT(0x4265666f756c65642053696c6b USING utf8mb4)),
(134654,CONVERT(0x53636f7263686564204f7265 USING utf8mb4)),
(135432,CONVERT(0x53636f7263686564204261726273 USING utf8mb4)),
(135433,CONVERT(0x53636f7263686564205374756473 USING utf8mb4)),
(135435,CONVERT(0x4265666f756c65642048696c742057726170 USING utf8mb4)),
(135436,CONVERT(0x526567616c2053686f72742048616674 USING utf8mb4)),
(135437,CONVERT(0x526567616c2048616674 USING utf8mb4)),
(135438,CONVERT(0x526567616c204c6f6e672048616674 USING utf8mb4)),
(135440,CONVERT(0x526567616c205374616666 USING utf8mb4)),
(135441,CONVERT(0x526567616c2048616e646c65 USING utf8mb4)),
(135562,CONVERT(0x526567616c20576561706f6e20536d697468696e67 USING utf8mb4));
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc010_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc010_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC010 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE itemclass=1 AND ((id=17910 AND bagtype=18 AND bagslots=8) OR (id=17909 AND bagtype=17 AND bagslots=10) OR (id=17908 AND bagtype=16 AND bagslots=2)))<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC010 ordinary18 17 16 container dependency mismatch'; END IF;
 IF NOT EXISTS(SELECT 1 FROM items WHERE id=135562 AND itemclass=2 AND booktype=0 AND BINARY filename=BINARY 'TSSKU20WeaponSm100') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC010 optional scribe book metadata mismatch'; END IF;
 IF already_present<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC010 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc010_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC010 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc010_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC010 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc010_recipes q ON q.id=r.recipe_id LEFT JOIN rrc010_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC010 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc010_recipes q ON q.id=r.recipe_id)<>41 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC010 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc010_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC010 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc010_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc010_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-8 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-41 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC010 rollback count mismatch'; END IF;
 DROP TEMPORARY TABLE rrc010_entries;
 DROP TEMPORARY TABLE rrc010_recipes;
 DROP TEMPORARY TABLE rrc010_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC010' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
