-- RRC029 additive manual and named-kit links; dedicated strict MariaDB10.11 session.
DELIMITER //
BEGIN NOT ATOMIC
 DECLARE own_transaction BOOLEAN DEFAULT FALSE;
 DECLARE already_present INT DEFAULT 0;
 DECLARE recipes_before BIGINT;
 DECLARE entries_before BIGINT;
 DECLARE locked_rows INT;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN IF own_transaction THEN ROLLBACK; END IF; RESIGNAL; END;
 IF @@in_transaction<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC029 requires fresh session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC029 strict SQL required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC029 InnoDB foundation mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc029_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc029_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc029_base_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc029_base_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc029_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc029_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3091808,CONVERT(0x536372696e646974652773204d656368616e6f696e737472756374696f6e204d616e75616c USING utf8mb4),58,0,0,1,0,CONVERT(0x446f44483b20455154432061727469636c653334393b204e6f204661696c20436f6d62696e652c207472697669616c3020636f6e76656e74696f6e616c3b205252433032392e USING utf8mb4),0,0,0,1,10,-1,NULL,NULL);
INSERT INTO rrc029_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3091808,33295,1,0,0,0,0),
(3091808,33306,0,0,1,1,0),
(3091808,33307,0,0,1,1,0),
(3091808,33308,0,0,1,1,0),
(3091808,33309,0,0,1,1,0),
(3091808,33310,0,0,1,1,0),
(3091808,93492,0,0,0,0,1),
(10960,41555,0,0,0,0,1),
(10960,41631,0,0,0,0,1),
(10960,41632,0,0,0,0,1),
(10960,41633,0,0,0,0,1),
(10959,41555,0,0,0,0,1),
(10959,41631,0,0,0,0,1),
(10959,41632,0,0,0,0,1),
(10959,41633,0,0,0,0,1),
(10961,41555,0,0,0,0,1),
(10961,41631,0,0,0,0,1),
(10961,41632,0,0,0,0,1),
(10961,41633,0,0,0,0,1),
(10962,41555,0,0,0,0,1),
(10962,41631,0,0,0,0,1),
(10962,41632,0,0,0,0,1),
(10962,41633,0,0,0,0,1),
(10958,41555,0,0,0,0,1),
(10958,41631,0,0,0,0,1),
(10958,41632,0,0,0,0,1),
(10958,41633,0,0,0,0,1);
INSERT INTO rrc029_base_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(10958,CONVERT(0x5669616c204f6620566973636f7573204d616e61 USING utf8mb4),58,0,102,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(10959,CONVERT(0x5669616c204f6620436c6f756479204d616e61 USING utf8mb4),58,0,126,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(10960,CONVERT(0x5669616c204f6620436c656172204d616e61 USING utf8mb4),58,0,151,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(10961,CONVERT(0x5669616c204f662044697374696c6c6564204d616e61 USING utf8mb4),58,0,176,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(10962,CONVERT(0x5669616c204f66205075726966696564204d616e61 USING utf8mb4),58,0,200,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL);
INSERT INTO rrc029_base_entries (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(135898,10958,10250,1,0,0,0,0),
(135899,10958,9650,0,0,1,1,0),
(135900,10958,97042,0,0,1,1,0),
(135901,10958,10024,0,0,2,2,0),
(135902,10958,16965,0,0,1,1,0),
(135903,10958,93492,0,0,0,0,1),
(135904,10959,10251,1,0,0,0,0),
(135905,10959,9650,0,0,1,1,0),
(135906,10959,97042,0,0,1,1,0),
(135907,10959,10028,0,0,2,2,0),
(135908,10959,16965,0,0,1,1,0),
(135909,10959,93492,0,0,0,0,1),
(135910,10960,10252,1,0,0,0,0),
(135911,10960,9650,0,0,1,1,0),
(135912,10960,97042,0,0,1,1,0),
(135913,10960,10029,0,0,2,2,0),
(135914,10960,16965,0,0,1,1,0),
(135915,10960,93492,0,0,0,0,1),
(135916,10961,10253,1,0,0,0,0),
(135917,10961,9650,0,0,1,1,0),
(135918,10961,97042,0,0,2,2,0),
(135919,10961,16965,0,0,1,1,0),
(135920,10961,10034,0,0,3,3,0),
(135921,10961,93492,0,0,0,0,1),
(135922,10962,10254,1,0,0,0,0),
(135923,10962,9650,0,0,1,1,0),
(135924,10962,97042,0,0,3,3,0),
(135925,10962,16965,0,0,1,1,0),
(135926,10962,10035,0,0,5,5,0),
(135927,10962,93492,0,0,0,0,1);
INSERT INTO rrc029_items (`id`,`name`) VALUES
(33295,CONVERT(0x536372696e646974652773204d656368616e6f696e737472756374696f6e204d616e75616c USING utf8mb4)),
(33306,CONVERT(0x536372696e646974652773204d656368616e6f696e737472756374696f6e204d616e75616c20506167652031 USING utf8mb4)),
(33307,CONVERT(0x536372696e646974652773204d656368616e6f696e737472756374696f6e204d616e75616c20506167652032 USING utf8mb4)),
(33308,CONVERT(0x536372696e646974652773204d656368616e6f696e737472756374696f6e204d616e75616c20506167652033 USING utf8mb4)),
(33309,CONVERT(0x536372696e646974652773204d656368616e6f696e737472756374696f6e204d616e75616c20506167652034 USING utf8mb4)),
(33310,CONVERT(0x536372696e646974652773204d656368616e6f696e737472756374696f6e204d616e75616c20506167652035 USING utf8mb4)),
(41555,CONVERT(0x546f6d652042696e64696e67204b6974 USING utf8mb4)),
(41631,CONVERT(0x5072617965722057726974696e67204b6974 USING utf8mb4)),
(41632,CONVERT(0x487962726964205265736561726368204b6974 USING utf8mb4)),
(41633,CONVERT(0x536f6e672057726974696e67204b6974 USING utf8mb4)),
(93492,CONVERT(0x5370656c6c205265736561726368204b6974 USING utf8mb4));
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO locked_rows FROM tradeskill_recipe WHERE id IN (10958,10959,10960,10961,10962,3091808) FOR UPDATE;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe WHERE id=3091808;
 IF EXISTS(SELECT 1 FROM rrc029_base_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC029 original vial recipe changed'; END IF;
 IF EXISTS(SELECT 1 FROM rrc029_base_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC029 original vial entry changed'; END IF;
 IF EXISTS(SELECT 1 FROM rrc029_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC029 item dependency mismatch'; END IF;
 IF NOT EXISTS(SELECT 1 FROM items WHERE `id`=93492 AND `itemclass`=1 AND `bagtype`=11 AND `bagslots`=10 AND `classes`=15360 AND `races`=131071) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC029 named kit metadata mismatch'; END IF;
 IF NOT EXISTS(SELECT 1 FROM items WHERE `id`=41555 AND `itemclass`=1 AND `bagtype`=11 AND `bagslots`=10 AND `classes`=33089 AND `races`=131071) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC029 named kit metadata mismatch'; END IF;
 IF NOT EXISTS(SELECT 1 FROM items WHERE `id`=41631 AND `itemclass`=1 AND `bagtype`=11 AND `bagslots`=10 AND `classes`=16930 AND `races`=131071) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC029 named kit metadata mismatch'; END IF;
 IF NOT EXISTS(SELECT 1 FROM items WHERE `id`=41632 AND `itemclass`=1 AND `bagtype`=11 AND `bagslots`=10 AND `classes`=16412 AND `races`=131071) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC029 named kit metadata mismatch'; END IF;
 IF NOT EXISTS(SELECT 1 FROM items WHERE `id`=41633 AND `itemclass`=1 AND `bagtype`=11 AND `bagslots`=10 AND `classes`=128 AND `races`=131071) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC029 named kit metadata mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r JOIN rrc029_recipes e ON r.tradeskill=e.tradeskill AND r.name=e.name WHERE r.id<>e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC029 recipe name collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE item_id=33295 AND successcount>componentcount AND iscontainer=0 AND recipe_id<>3091808) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC029 manual net producer collision'; END IF;
 IF already_present=0 THEN
 IF EXISTS(SELECT 1 FROM rrc029_base_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC029 original vial recipe changed'; END IF;
 IF EXISTS(SELECT 1 FROM rrc029_base_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC029 original vial entry changed'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe WHERE id=3091808)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC029 manual presence mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries WHERE recipe_id IN (10958,10959,10960,10961,10962,3091808))<>30 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC029 affected entry count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r WHERE r.recipe_id IN (10958,10959,10960,10961,10962,3091808) AND NOT EXISTS(SELECT 1 FROM rrc029_base_entries e WHERE r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC029 foreign affected entries'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list WHERE recipe_id=3091808) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC029 orphan learned reference'; END IF;
 INSERT INTO tradeskill_recipe (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) SELECT `id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled` FROM rrc029_recipes;
 INSERT INTO tradeskill_recipe_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) SELECT `recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer` FROM rrc029_entries;
 END IF;
 IF EXISTS(SELECT 1 FROM rrc029_base_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC029 original vial recipe changed'; END IF;
 IF EXISTS(SELECT 1 FROM rrc029_base_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC029 original vial entry changed'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe WHERE id=3091808)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC029 manual presence mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries WHERE recipe_id IN (10958,10959,10960,10961,10962,3091808))<>57 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC029 affected entry count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r WHERE r.recipe_id IN (10958,10959,10960,10961,10962,3091808) AND NOT EXISTS(SELECT 1 FROM rrc029_base_entries e WHERE r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`) AND NOT EXISTS(SELECT 1 FROM rrc029_entries e WHERE r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC029 foreign affected entries'; END IF;
 IF EXISTS(SELECT 1 FROM rrc029_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC029 manual postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc029_entries e WHERE (SELECT COUNT(*) FROM tradeskill_recipe_entries r WHERE r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)<>1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC029 added entry multiplicity mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before+IF(already_present=0,1,0) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before+IF(already_present=0,27,0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC029 unexpected table count delta'; END IF;
 DROP TEMPORARY TABLE rrc029_entries;
 DROP TEMPORARY TABLE rrc029_recipes;
 DROP TEMPORARY TABLE rrc029_base_entries;
 DROP TEMPORARY TABLE rrc029_base_recipes;
 DROP TEMPORARY TABLE rrc029_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC029' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
