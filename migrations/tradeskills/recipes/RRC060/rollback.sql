-- RRC060: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC060 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC060 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC060 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC060 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc060_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc060_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc060_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc060_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3093575,CONVERT(0x45726f6e277320546872656164656420576562 USING utf8mb4),61,0,400,0,0,CONVERT(0x536f462045726f6e3b206d616e6461746f7279206e617469766520626f6f6b206c6561726e696e673b205252433036302e USING utf8mb4),1,36471,0,1,14,-1,NULL,NULL),
(3093576,CONVERT(0x45726f6e277320436572616d69632053657474696e67 USING utf8mb4),69,0,50,0,0,CONVERT(0x536f462045726f6e3b206d616e6461746f7279206e617469766520626f6f6b206c6561726e696e673b205252433036302e USING utf8mb4),1,36459,0,1,14,-1,NULL,NULL),
(3093577,CONVERT(0x556e66697265642045726f6e277320436572616d69632053657474696e67 USING utf8mb4),69,0,400,0,0,CONVERT(0x536f462045726f6e3b206d616e6461746f7279206e617469766520626f6f6b206c6561726e696e673b205252433036302e USING utf8mb4),1,36459,0,1,14,-1,NULL,NULL),
(3093578,CONVERT(0x536f6f7420426f756e6420436572616d696320436c6179 USING utf8mb4),69,0,100,0,0,CONVERT(0x536f462045726f6e3b206d616e6461746f7279206e617469766520626f6f6b206c6561726e696e673b205252433036302e USING utf8mb4),1,36459,0,1,14,-1,NULL,NULL),
(3093579,CONVERT(0x536861646f777370696b65204172726f7720546970 USING utf8mb4),63,0,100,0,0,CONVERT(0x536f462045726f6e3b206d616e6461746f7279206e617469766520626f6f6b206c6561726e696e673b205252433036302e USING utf8mb4),1,36588,0,1,14,-1,NULL,NULL),
(3093580,CONVERT(0x536861646f777370696b65204172726f77 USING utf8mb4),64,0,400,0,0,CONVERT(0x536f462045726f6e3b206d616e6461746f7279206e617469766520626f6f6b206c6561726e696e673b205252433036302e USING utf8mb4),1,36588,0,1,14,-1,NULL,NULL);
INSERT INTO rrc060_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3093575,36631,1,0,0,0,0),
(3093575,36630,1,1,1,0,0),
(3093575,36629,0,0,1,1,0),
(3093575,16,0,0,0,0,1),
(3093576,36527,1,0,0,0,0),
(3093576,16908,0,0,1,1,0),
(3093576,36526,0,0,1,1,0),
(3093576,22,0,0,0,0,1),
(3093577,36526,1,0,0,0,0),
(3093577,36525,0,0,1,1,0),
(3093577,13006,0,0,1,1,0),
(3093577,21,0,0,0,0,1),
(3093578,36525,1,0,0,0,0),
(3093578,36510,0,0,7,7,0),
(3093578,13006,0,0,1,1,0),
(3093578,21,0,0,0,0,1),
(3093579,36591,1,0,0,0,0),
(3093579,9650,0,0,1,1,0),
(3093579,36593,1,1,1,0,0),
(3093579,33438,0,0,1,1,0),
(3093579,17,0,0,0,0,1),
(3093580,36592,1,0,0,0,0),
(3093580,8062,0,0,1,1,0),
(3093580,8069,0,0,1,1,0),
(3093580,36591,0,0,1,1,0),
(3093580,8052,0,0,1,1,0),
(3093580,36589,0,0,1,1,0),
(3093580,10250,0,0,1,1,0),
(3093580,18,0,0,0,0,1);
INSERT INTO rrc060_items (`id`,`name`) VALUES
(8052,CONVERT(0x536d616c6c2047726f6f7665204e6f636b73 USING utf8mb4)),
(8062,CONVERT(0x42756e646c656420436572616d6963204172726f7720536861667473 USING utf8mb4)),
(8069,CONVERT(0x536574206f6620436572616d6963204172726f772056616e6573 USING utf8mb4)),
(9650,CONVERT(0x43656c65737469616c20457373656e6365 USING utf8mb4)),
(10250,CONVERT(0x5669616c206f6620566973636f7573204d616e61 USING utf8mb4)),
(13006,CONVERT(0x576174657220466c61736b USING utf8mb4)),
(16908,CONVERT(0x48696768205175616c69747920466972696e67205368656574 USING utf8mb4)),
(17165,CONVERT(0x436f6c6c61707369626c6520536577696e67204b6974 USING utf8mb4)),
(17768,CONVERT(0x506c616e617220536577696e67204b6974 USING utf8mb4)),
(17863,CONVERT(0x436f6c6461696e2054616e6e657273204b6974 USING utf8mb4)),
(17880,CONVERT(0x4c6172676520536577696e67204b6974 USING utf8mb4)),
(17909,CONVERT(0x466f726765 USING utf8mb4)),
(17910,CONVERT(0x466c65746368696e67204b6974 USING utf8mb4)),
(17966,CONVERT(0x44656c75786520536577696e67204b6974 USING utf8mb4)),
(33438,CONVERT(0x536d616c6c205069656365206f662048696768205175616c69747920537465656c USING utf8mb4)),
(36459,CONVERT(0x45726f6e277320436572616d69632053657474696e67204e6f746573 USING utf8mb4)),
(36471,CONVERT(0x45726f6e277320546872656164 USING utf8mb4)),
(36510,CONVERT(0x547769746368696e6720536f6f74 USING utf8mb4)),
(36525,CONVERT(0x536f6f7420426f756e6420436572616d696320436c6179 USING utf8mb4)),
(36526,CONVERT(0x556e66697265642045726f6e277320436572616d69632053657474696e67 USING utf8mb4)),
(36527,CONVERT(0x45726f6e277320436572616d69632053657474696e67 USING utf8mb4)),
(36588,CONVERT(0x4d616b696e6720536861646f777370696b65204172726f7773 USING utf8mb4)),
(36589,CONVERT(0x537769726c696e6720536861646f7720457373656e6365 USING utf8mb4)),
(36591,CONVERT(0x536861646f777370696b65204172726f7720546970 USING utf8mb4)),
(36592,CONVERT(0x536861646f777370696b65204172726f77 USING utf8mb4)),
(36593,CONVERT(0x536861646f777370696b65204172726f7720546970204d6f6c64 USING utf8mb4)),
(36629,CONVERT(0x53706f6f6c206f6620456e657267697a65642042726f776e6965204861697220546872656164 USING utf8mb4)),
(36630,CONVERT(0x45726f6e277320546872656164656420576562205061747465726e USING utf8mb4)),
(36631,CONVERT(0x45726f6e277320546872656164656420576562 USING utf8mb4)),
(54254,CONVERT(0x4b696c6e USING utf8mb4)),
(54257,CONVERT(0x506f747465727920576865656c USING utf8mb4));
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc060_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc060_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC060 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE itemclass=1 AND ((id=54254 AND bagtype=22 AND bagslots=10) OR(id=54257 AND bagtype=21 AND bagslots=10) OR(id=17966 AND bagtype=16 AND bagslots=10) OR(id IN(17880,17768,17863,17165) AND bagtype=16 AND bagslots=8) OR(id=17909 AND bagtype=17 AND bagslots=10) OR(id=17910 AND bagtype=18 AND bagslots=8)))<>9 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC060 native container mismatch'; END IF;
 IF already_present<>6 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC060 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc060_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC060 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc060_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC060 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc060_recipes q ON q.id=r.recipe_id LEFT JOIN rrc060_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC060 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc060_recipes q ON q.id=r.recipe_id)<>29 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC060 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc060_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC060 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc060_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc060_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-6 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-29 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC060 rollback count mismatch'; END IF;
 DROP TEMPORARY TABLE rrc060_entries;
 DROP TEMPORARY TABLE rrc060_recipes;
 DROP TEMPORARY TABLE rrc060_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC060' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
