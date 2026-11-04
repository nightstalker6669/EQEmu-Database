-- RRC070: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC070 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC070 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC070 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC070 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc070_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc070_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc070_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc070_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3093614,CONVERT(0x52756e6564204c65706572746f6c6f746820426f6e65205365676d656e74 USING utf8mb4),58,0,188,0,0,CONVERT(0x5072696d61727920526573656172636820717565737420666f726d756c613b207175616c696669656420506f502f446f444820636f6e746578743b205252433037302e USING utf8mb4),0,0,0,1,4,-1,NULL,NULL),
(3093615,CONVERT(0x5461747465726564204d656368616e6f696e737472756374696f6e2028436f6e66696775726174696f6e29 USING utf8mb4),58,0,15,1,0,CONVERT(0x5072696d61727920526573656172636820717565737420666f726d756c613b207175616c696669656420506f502f446f444820636f6e746578743b205252433037302e USING utf8mb4),0,0,0,1,10,-1,NULL,NULL),
(3093616,CONVERT(0x5461747465726564204d656368616e6f696e737472756374696f6e20284d656368616e6f7461626c657429 USING utf8mb4),58,0,15,1,0,CONVERT(0x5072696d61727920526573656172636820717565737420666f726d756c613b207175616c696669656420506f502f446f444820636f6e746578743b205252433037302e USING utf8mb4),0,0,0,1,10,-1,NULL,NULL),
(3093617,CONVERT(0x5461747465726564204d656368616e6f696e737472756374696f6e202841647669736f727920426f6f6b29 USING utf8mb4),58,0,15,1,0,CONVERT(0x5072696d61727920526573656172636820717565737420666f726d756c613b207175616c696669656420506f502f446f444820636f6e746578743b205252433037302e USING utf8mb4),0,0,0,1,10,-1,NULL,NULL);
INSERT INTO rrc070_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3093614,29488,1,0,0,0,0),
(3093614,29348,0,0,1,1,0),
(3093614,29487,0,0,1,1,0),
(3093614,93492,0,0,0,0,1),
(3093614,41555,0,0,0,0,1),
(3093614,41631,0,0,0,0,1),
(3093614,41632,0,0,0,0,1),
(3093614,41633,0,0,0,0,1),
(3093615,33297,1,0,0,0,0),
(3093615,32737,0,0,1,1,0),
(3093615,32735,0,0,1,1,0),
(3093615,32736,0,0,1,1,0),
(3093615,32734,0,0,1,1,0),
(3093615,93492,0,0,0,0,1),
(3093616,33296,1,0,0,0,0),
(3093616,32733,0,0,1,1,0),
(3093616,32731,0,0,1,1,0),
(3093616,32732,0,0,1,1,0),
(3093616,93492,0,0,0,0,1),
(3093617,33298,1,0,0,0,0),
(3093617,32739,0,0,1,1,0),
(3093617,32738,0,0,1,1,0),
(3093617,32740,0,0,1,1,0),
(3093617,93492,0,0,0,0,1);
INSERT INTO rrc070_items (`id`,`name`) VALUES
(29348,CONVERT(0x426c6f6f642052756e6520496e6b USING utf8mb4)),
(29487,CONVERT(0x4c65706572746f6c6f746820426f6e65205365676d656e74 USING utf8mb4)),
(29488,CONVERT(0x52756e6564204c65706572746f6c6f746820426f6e65205365676d656e74 USING utf8mb4)),
(32731,CONVERT(0x4d656368616e6f696e737472756374696f6e20536372617073 USING utf8mb4)),
(32732,CONVERT(0x4d656368616e6f696e737472756374696f6e20536372617073 USING utf8mb4)),
(32733,CONVERT(0x4d656368616e6f696e737472756374696f6e20536372617073 USING utf8mb4)),
(32734,CONVERT(0x4d656368616e6f696e737472756374696f6e20536372617073 USING utf8mb4)),
(32735,CONVERT(0x4d656368616e6f696e737472756374696f6e20536372617073 USING utf8mb4)),
(32736,CONVERT(0x4d656368616e6f696e737472756374696f6e20536372617073 USING utf8mb4)),
(32737,CONVERT(0x4d656368616e6f696e737472756374696f6e20536372617073 USING utf8mb4)),
(32738,CONVERT(0x4d656368616e6f696e737472756374696f6e20536372617073 USING utf8mb4)),
(32739,CONVERT(0x4d656368616e6f696e737472756374696f6e20536372617073 USING utf8mb4)),
(32740,CONVERT(0x4d656368616e6f696e737472756374696f6e20536372617073 USING utf8mb4)),
(33296,CONVERT(0x5461747465726564204d656368616e6f696e737472756374696f6e USING utf8mb4)),
(33297,CONVERT(0x5461747465726564204d656368616e6f696e737472756374696f6e USING utf8mb4)),
(33298,CONVERT(0x5461747465726564204d656368616e6f696e737472756374696f6e USING utf8mb4)),
(41555,CONVERT(0x546f6d652042696e64696e67204b6974 USING utf8mb4)),
(41631,CONVERT(0x5072617965722057726974696e67204b6974 USING utf8mb4)),
(41632,CONVERT(0x487962726964205265736561726368204b6974 USING utf8mb4)),
(41633,CONVERT(0x536f6e672057726974696e67204b6974 USING utf8mb4)),
(93492,CONVERT(0x5370656c6c205265736561726368204b6974 USING utf8mb4));
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc070_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc070_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC070 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE itemclass=1 AND bagtype=11 AND bagslots=10 AND bagsize=3 AND ((id=93492 AND classes=15360) OR (id=41555 AND classes=33089) OR (id=41631 AND classes=16930) OR (id=41632 AND classes=16412) OR (id=41633 AND classes=128)))<>5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC070 native kit mismatch'; END IF; IF (SELECT COUNT(*) FROM items WHERE (id=29488 AND size=1 AND stackable=1 AND maxcharges=0) OR (id=29348 AND size=0 AND stackable=1 AND maxcharges=0) OR (id=29487 AND size=1 AND stackable=1 AND maxcharges=0) OR (id=33297 AND size=1 AND stackable=1 AND maxcharges=0) OR (id=32737 AND size=0 AND stackable=1 AND maxcharges=0) OR (id=32735 AND size=0 AND stackable=1 AND maxcharges=0) OR (id=32736 AND size=0 AND stackable=1 AND maxcharges=0) OR (id=32734 AND size=0 AND stackable=1 AND maxcharges=0) OR (id=33296 AND size=1 AND stackable=1 AND maxcharges=0) OR (id=32733 AND size=0 AND stackable=1 AND maxcharges=0) OR (id=32731 AND size=0 AND stackable=1 AND maxcharges=0) OR (id=32732 AND size=0 AND stackable=1 AND maxcharges=0) OR (id=33298 AND size=1 AND stackable=1 AND maxcharges=0) OR (id=32739 AND size=0 AND stackable=1 AND maxcharges=0) OR (id=32738 AND size=0 AND stackable=1 AND maxcharges=0) OR (id=32740 AND size=0 AND stackable=1 AND maxcharges=0))<>16 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC070 ingredient/output semantics mismatch'; END IF;
 IF already_present<>4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC070 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc070_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC070 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc070_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC070 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc070_recipes q ON q.id=r.recipe_id LEFT JOIN rrc070_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC070 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc070_recipes q ON q.id=r.recipe_id)<>24 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC070 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc070_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC070 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc070_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc070_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-4 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-24 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC070 rollback count mismatch'; END IF;
 DROP TEMPORARY TABLE rrc070_entries;
 DROP TEMPORARY TABLE rrc070_recipes;
 DROP TEMPORARY TABLE rrc070_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC070' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
