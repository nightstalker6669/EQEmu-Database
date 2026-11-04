-- RRC042: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC042 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC042 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC042 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC042 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc042_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc042_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc042_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc042_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3092634,CONVERT(0x416c6368656d69737420436572616d696320436c6179 USING utf8mb4),59,0,262,0,0,CONVERT(0x54535320636861726d20636c617920696e7075743b2045515443207072696d617279206d616e75666163747572653b205252433034322e USING utf8mb4),0,0,0,1,12,-1,NULL,NULL),
(3092635,CONVERT(0x466c65746368657220436572616d696320436c6179 USING utf8mb4),62,0,262,0,0,CONVERT(0x54535320636861726d20636c617920696e7075743b2045515443207072696d617279206d616e75666163747572653b205252433034322e USING utf8mb4),0,0,0,1,12,-1,NULL,NULL),
(3092636,CONVERT(0x536d69746820436572616d696320436c6179 USING utf8mb4),63,0,262,0,0,CONVERT(0x54535320636861726d20636c617920696e7075743b2045515443207072696d617279206d616e75666163747572653b205252433034322e USING utf8mb4),0,0,0,1,12,-1,NULL,NULL),
(3092637,CONVERT(0x5461696c6f7220436572616d696320436c6179 USING utf8mb4),61,0,262,0,0,CONVERT(0x54535320636861726d20636c617920696e7075743b2045515443207072696d617279206d616e75666163747572653b205252433034322e USING utf8mb4),0,0,0,1,12,-1,NULL,NULL),
(3092638,CONVERT(0x546f7869636f6c6f6769737420436572616d696320436c6179 USING utf8mb4),56,0,262,0,0,CONVERT(0x54535320636861726d20636c617920696e7075743b2045515443207072696d617279206d616e75666163747572653b205252433034322e USING utf8mb4),0,0,0,1,12,-1,NULL,NULL);
INSERT INTO rrc042_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3092634,97950,1,0,0,0,0),
(3092634,16524,0,0,1,1,0),
(3092634,16518,0,0,3,3,0),
(3092634,22183,0,0,1,1,0),
(3092634,97275,0,0,1,1,0),
(3092634,16948,0,0,1,1,0),
(3092634,9,0,0,0,0,1),
(3092635,97953,1,0,0,0,0),
(3092635,29992,0,0,1,1,0),
(3092635,63244,0,0,1,1,0),
(3092635,97278,0,0,1,1,0),
(3092635,16948,0,0,1,1,0),
(3092635,18,0,0,0,0,1),
(3092636,97958,1,0,0,0,0),
(3092636,12011,0,1,1,0,0),
(3092636,16948,0,0,1,1,0),
(3092636,10468,0,0,1,1,0),
(3092636,97283,0,0,1,1,0),
(3092636,13006,0,0,1,1,0),
(3092636,17,0,0,0,0,1),
(3092637,97959,1,0,0,0,0),
(3092637,16482,0,0,1,1,0),
(3092637,16486,0,0,1,1,0),
(3092637,16948,0,0,1,1,0),
(3092637,13041,0,0,1,1,0),
(3092637,13099,0,0,1,1,0),
(3092637,97284,0,0,1,1,0),
(3092637,16,0,0,0,0,1),
(3092638,97960,1,0,0,0,0),
(3092638,16988,0,0,1,1,0),
(3092638,97285,0,0,1,1,0),
(3092638,16820,0,0,1,1,0),
(3092638,16948,0,0,1,1,0),
(3092638,16550,0,0,1,1,0),
(3092638,12,0,0,0,0,1);
INSERT INTO rrc042_items (`id`,`name`) VALUES
(10468,CONVERT(0x536d616c6c20427269636b206f662048696768205175616c697479204f7265 USING utf8mb4)),
(12011,CONVERT(0x46696c65 USING utf8mb4)),
(13006,CONVERT(0x576174657220466c61736b USING utf8mb4)),
(13041,CONVERT(0x5370696465722053696c6b USING utf8mb4)),
(13099,CONVERT(0x5370696465726c696e672053696c6b USING utf8mb4)),
(16482,CONVERT(0x53696c6b20537761746368 USING utf8mb4)),
(16486,CONVERT(0x53696c6b20546872656164 USING utf8mb4)),
(16518,CONVERT(0x427572646f636b20526f6f74 USING utf8mb4)),
(16524,CONVERT(0x42756762616e65 USING utf8mb4)),
(16550,CONVERT(0x536f6f742048656d6c6f636b USING utf8mb4)),
(16820,CONVERT(0x5265642048656c6c65626f7265 USING utf8mb4)),
(16948,CONVERT(0x536d616c6c20426c6f636b206f66204d6167696320436c6179 USING utf8mb4)),
(16988,CONVERT(0x5075747269642042696c65 USING utf8mb4)),
(17139,CONVERT(0x4d6172626c65204d6f7274617220616e6420506573746c65 USING utf8mb4)),
(17165,CONVERT(0x436f6c6c61707369626c6520536577696e67204b6974 USING utf8mb4)),
(17189,CONVERT(0x436f6c6c61707369626c6520466c65746368696e67204b6974 USING utf8mb4)),
(17190,CONVERT(0x436f6c6c61707369626c65204d6f7274617220616e6420506573746c65 USING utf8mb4)),
(17762,CONVERT(0x506c616e617220466c65746368696e67204b6974 USING utf8mb4)),
(17768,CONVERT(0x506c616e617220536577696e67204b6974 USING utf8mb4)),
(17770,CONVERT(0x466f6c6461626c65204d65646963696e6520426167 USING utf8mb4)),
(17771,CONVERT(0x466f6c6461626c65205265696e666f72636564204d65646963696e6520426167 USING utf8mb4)),
(17811,CONVERT(0x5265696e666f72636564204d65646963696e6520426167 USING utf8mb4)),
(17863,CONVERT(0x436f6c6461696e2054616e6e657273204b6974 USING utf8mb4)),
(17880,CONVERT(0x4c6172676520536577696e67204b6974 USING utf8mb4)),
(17901,CONVERT(0x4d65646963696e6520426167 USING utf8mb4)),
(17904,CONVERT(0x4d6f7274617220616e6420506573746c65 USING utf8mb4)),
(17908,CONVERT(0x536d616c6c20536577696e67204b6974 USING utf8mb4)),
(17909,CONVERT(0x466f726765 USING utf8mb4)),
(17910,CONVERT(0x466c65746368696e67204b6974 USING utf8mb4)),
(17966,CONVERT(0x44656c75786520536577696e67204b6974 USING utf8mb4)),
(22183,CONVERT(0x4475736b676c6f772056696e65 USING utf8mb4)),
(29992,CONVERT(0x436c756d70206f6620576178 USING utf8mb4)),
(63244,CONVERT(0x476e6f6d697368204865617420536f75726365 USING utf8mb4)),
(97275,CONVERT(0x4d65646963696e616c204d6f7373 USING utf8mb4)),
(97278,CONVERT(0x4c656f7061726420496e74657374696e6573 USING utf8mb4)),
(97283,CONVERT(0x53746570706573204f7265 USING utf8mb4)),
(97284,CONVERT(0x57617370205370696465722053696c6b USING utf8mb4)),
(97285,CONVERT(0x52617a6f726261636b2056656e6f6d20536163 USING utf8mb4)),
(97950,CONVERT(0x416c6368656d69737420436572616d696320436c6179 USING utf8mb4)),
(97953,CONVERT(0x466c65746368657220436572616d696320436c6179 USING utf8mb4)),
(97958,CONVERT(0x536d69746820436572616d696320436c6179 USING utf8mb4)),
(97959,CONVERT(0x5461696c6f7220436572616d696320436c6179 USING utf8mb4)),
(97960,CONVERT(0x546f7869636f6c6f6769737420436572616d696320436c6179 USING utf8mb4));
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc042_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc042_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC042 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE itemclass=1 AND ((id=17901 AND bagtype=9 AND bagslots=8) OR (id=17811 AND bagtype=9 AND bagslots=10) OR (id=17770 AND bagtype=9 AND bagslots=8) OR (id=17771 AND bagtype=9 AND bagslots=10) OR (id=17910 AND bagtype=18 AND bagslots=8) OR (id=17762 AND bagtype=18 AND bagslots=8) OR (id=17189 AND bagtype=18 AND bagslots=8) OR (id=17908 AND bagtype=16 AND bagslots=2) OR (id=17966 AND bagtype=16 AND bagslots=10) OR (id=17880 AND bagtype=16 AND bagslots=8) OR (id=17768 AND bagtype=16 AND bagslots=8) OR (id=17863 AND bagtype=16 AND bagslots=8) OR (id=17165 AND bagtype=16 AND bagslots=8) OR (id=17904 AND bagtype=12 AND bagslots=6) OR (id=17139 AND bagtype=12 AND bagslots=10) OR (id=17190 AND bagtype=12 AND bagslots=6) OR (id=17909 AND bagtype=17 AND bagslots=10)))<>17 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC042 native container mismatch'; END IF;
 IF already_present<>5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC042 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc042_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC042 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc042_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC042 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc042_recipes q ON q.id=r.recipe_id LEFT JOIN rrc042_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC042 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc042_recipes q ON q.id=r.recipe_id)<>35 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC042 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc042_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC042 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc042_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc042_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-5 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-35 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC042 rollback count mismatch'; END IF;
 DROP TEMPORARY TABLE rrc042_entries;
 DROP TEMPORARY TABLE rrc042_recipes;
 DROP TEMPORARY TABLE rrc042_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC042' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
