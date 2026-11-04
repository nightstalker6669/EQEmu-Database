-- RRC078: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC078 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC078 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC078 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC078 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc078_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc078_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc078_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc078_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3093638,CONVERT(0x526f756768205072696d6572 USING utf8mb4),58,0,243,0,0,CONVERT(0x5072696d617279205072696d6572207072657061726174696f6e3b206578697374696e6720546f6d652042696e64696e67204b697420726f757465206f6e6c793b205252433037382e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093639,CONVERT(0x5072696d6572 USING utf8mb4),58,0,243,0,0,CONVERT(0x5072696d617279205072696d6572207072657061726174696f6e3b206578697374696e6720546f6d652042696e64696e67204b697420726f757465206f6e6c793b205252433037382e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093640,CONVERT(0x46696e65205072696d6572 USING utf8mb4),58,0,243,0,0,CONVERT(0x5072696d617279205072696d6572207072657061726174696f6e3b206578697374696e6720546f6d652042696e64696e67204b697420726f757465206f6e6c793b205252433037382e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093641,CONVERT(0x52756e6963205072696d6572 USING utf8mb4),58,0,243,0,0,CONVERT(0x5072696d617279205072696d6572207072657061726174696f6e3b206578697374696e6720546f6d652042696e64696e67204b697420726f757465206f6e6c793b205252433037382e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093642,CONVERT(0x46696e652052756e6963205072696d6572 USING utf8mb4),58,0,243,0,0,CONVERT(0x5072696d617279205072696d6572207072657061726174696f6e3b206578697374696e6720546f6d652042696e64696e67204b697420726f757465206f6e6c793b205252433037382e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL);
INSERT INTO rrc078_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3093638,90312,1,0,0,0,0),
(3093638,93617,0,0,1,1,0),
(3093638,90317,0,0,1,1,0),
(3093638,90322,0,0,1,1,0),
(3093638,41554,0,0,1,1,0),
(3093638,41555,0,0,0,0,1),
(3093639,90313,1,0,0,0,0),
(3093639,93617,0,0,1,1,0),
(3093639,90318,0,0,1,1,0),
(3093639,90323,0,0,1,1,0),
(3093639,41554,0,0,1,1,0),
(3093639,41555,0,0,0,0,1),
(3093640,90314,1,0,0,0,0),
(3093640,93617,0,0,1,1,0),
(3093640,90319,0,0,1,1,0),
(3093640,90324,0,0,1,1,0),
(3093640,41554,0,0,1,1,0),
(3093640,41555,0,0,0,0,1),
(3093641,90315,1,0,0,0,0),
(3093641,93617,0,0,1,1,0),
(3093641,90320,0,0,1,1,0),
(3093641,90325,0,0,1,1,0),
(3093641,41554,0,0,1,1,0),
(3093641,41555,0,0,0,0,1),
(3093642,90316,1,0,0,0,0),
(3093642,93617,0,0,1,1,0),
(3093642,90321,0,0,1,1,0),
(3093642,90326,0,0,1,1,0),
(3093642,41554,0,0,1,1,0),
(3093642,41555,0,0,0,0,1);
INSERT INTO rrc078_items (`id`,`name`) VALUES
(41554,CONVERT(0x546f6d6520436f76657220537570706c696573 USING utf8mb4)),
(41555,CONVERT(0x546f6d652042696e64696e67204b6974 USING utf8mb4)),
(90312,CONVERT(0x526f756768205072696d6572 USING utf8mb4)),
(90313,CONVERT(0x5072696d6572 USING utf8mb4)),
(90314,CONVERT(0x46696e65205072696d6572 USING utf8mb4)),
(90315,CONVERT(0x52756e6963205072696d6572 USING utf8mb4)),
(90316,CONVERT(0x46696e652052756e6963205072696d6572 USING utf8mb4)),
(90317,CONVERT(0x526f7567682043686172746120417263616e756d20536f6c7574696f6e USING utf8mb4)),
(90318,CONVERT(0x43686172746120417263616e756d20536f6c7574696f6e USING utf8mb4)),
(90319,CONVERT(0x46696e652043686172746120417263616e756d20536f6c7574696f6e USING utf8mb4)),
(90320,CONVERT(0x52756e69632043686172746120417263616e756d20536f6c7574696f6e USING utf8mb4)),
(90321,CONVERT(0x46696e652052756e69632043686172746120417263616e756d20536f6c7574696f6e USING utf8mb4)),
(90322,CONVERT(0x536d756467656420526f7567682043686172746120417263616e756d USING utf8mb4)),
(90323,CONVERT(0x536f6f74792043686172746120417263616e756d USING utf8mb4)),
(90324,CONVERT(0x536f6f74792046696e652043686172746120417263616e756d USING utf8mb4)),
(90325,CONVERT(0x536d75646765642052756e69632043686172746120417263616e756d USING utf8mb4)),
(90326,CONVERT(0x537461696e65642046696e652052756e69632043686172746120417263616e756d USING utf8mb4)),
(93617,CONVERT(0x43656c65737469616c20436c65616e736572 USING utf8mb4));
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc078_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc078_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC078 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=41555 AND itemclass=1 AND bagtype=11 AND bagslots=10 AND bagsize=3 AND classes=33089)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC078 native kit mismatch'; END IF; IF (SELECT COUNT(*) FROM items WHERE (id=90312 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=93617 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=90317 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=90322 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=41554 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=90313 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=90318 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=90323 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=90314 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=90319 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=90324 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=90315 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=90320 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=90325 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=90316 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=90321 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=90326 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360))<>17 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC078 input/output semantics mismatch'; END IF;
 IF already_present<>5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC078 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc078_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC078 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc078_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC078 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc078_recipes q ON q.id=r.recipe_id LEFT JOIN rrc078_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC078 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc078_recipes q ON q.id=r.recipe_id)<>30 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC078 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc078_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC078 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc078_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc078_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-5 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-30 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC078 rollback count mismatch'; END IF;
 DROP TEMPORARY TABLE rrc078_entries;
 DROP TEMPORARY TABLE rrc078_recipes;
 DROP TEMPORARY TABLE rrc078_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC078' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
