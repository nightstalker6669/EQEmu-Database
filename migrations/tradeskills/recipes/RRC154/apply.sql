-- RRC154:Eight existing trivial fields only; exact selected current preimages required.
DELIMITER //
BEGIN NOT ATOMIC
 DECLARE own_transaction BOOLEAN DEFAULT FALSE;
 DECLARE recipes_before BIGINT DEFAULT 0;
 DECLARE entries_before BIGINT DEFAULT 0;
 DECLARE locked_rows BIGINT DEFAULT 0;
 DECLARE changed_rows BIGINT DEFAULT 0;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN IF own_transaction THEN ROLLBACK;END IF;RESIGNAL;END;
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC154 target/transaction mismatch';END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC154 strict mode required';END IF;
 IF(SELECT COUNT(*)FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE()AND TABLE_NAME IN('tradeskill_recipe','tradeskill_recipe_entries')AND ENGINE='InnoDB')<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC154 InnoDB mismatch';END IF;
 CREATE TEMPORARY TABLE rrc154_before LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc154_after LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc154_entries LIKE tradeskill_recipe_entries;
 INSERT INTO rrc154_before(`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`)VALUES
(3557,CONVERT(0x416372796c696120506c6174652053706c696e74656420436c6f616b USING utf8mb4),63,0,238,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(3558,CONVERT(0x416372796c696120506c6174652056616d627261636573 USING utf8mb4),63,0,225,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(3559,CONVERT(0x416372796c696120506c617465205669736f72 USING utf8mb4),63,0,214,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5085,CONVERT(0x4c6172676520416372796c696120506c6174652053706c696e74656420436c6f616b USING utf8mb4),63,0,238,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5086,CONVERT(0x4c6172676520416372796c696120506c6174652056616d627261636573 USING utf8mb4),63,0,225,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5087,CONVERT(0x4c6172676520416372796c696120506c617465205669736f72 USING utf8mb4),63,0,214,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(6068,CONVERT(0x536d616c6c20416372796c696120506c6174652053706c696e74656420436c6f616b USING utf8mb4),63,0,238,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(6070,CONVERT(0x536d616c6c20416372796c696120506c617465205669736f72 USING utf8mb4),63,0,214,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc154_after(`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`)VALUES
(3557,CONVERT(0x416372796c696120506c6174652053706c696e74656420436c6f616b USING utf8mb4),63,0,228,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(3558,CONVERT(0x416372796c696120506c6174652056616d627261636573 USING utf8mb4),63,0,228,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(3559,CONVERT(0x416372796c696120506c617465205669736f72 USING utf8mb4),63,0,216,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5085,CONVERT(0x4c6172676520416372796c696120506c6174652053706c696e74656420436c6f616b USING utf8mb4),63,0,228,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5086,CONVERT(0x4c6172676520416372796c696120506c6174652056616d627261636573 USING utf8mb4),63,0,228,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5087,CONVERT(0x4c6172676520416372796c696120506c617465205669736f72 USING utf8mb4),63,0,216,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(6068,CONVERT(0x536d616c6c20416372796c696120506c6174652053706c696e74656420436c6f616b USING utf8mb4),63,0,228,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(6070,CONVERT(0x536d616c6c20416372796c696120506c617465205669736f72 USING utf8mb4),63,0,216,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc154_entries(`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`)VALUES
(36492,3557,23535,0,0,3,3,0),
(36493,3557,11397,1,1,1,0,0),
(36494,3557,11398,0,0,1,1,0),
(36495,3557,11590,0,0,1,1,0),
(36496,3557,16488,0,0,1,1,0),
(36497,3557,22056,0,0,1,1,0),
(36499,3557,22434,1,0,0,0,0),
(36501,3557,17,0,0,0,0,1),
(36502,3558,23535,0,0,2,2,0),
(36503,3558,11397,1,1,1,0,0),
(36504,3558,11398,0,0,1,1,0),
(36505,3558,11590,0,0,1,1,0),
(36506,3558,16488,0,0,1,1,0),
(36507,3558,22007,0,0,1,1,0),
(36509,3558,22436,1,0,0,0,0),
(36511,3558,17,0,0,0,0,1),
(36512,3559,11397,1,1,1,0,0),
(36513,3559,11398,0,0,1,1,0),
(36514,3559,11590,0,0,1,1,0),
(36515,3559,16488,0,0,1,1,0),
(36516,3559,22004,0,0,1,1,0),
(36517,3559,23535,0,0,1,1,0),
(36519,3559,22430,1,0,0,0,0),
(36521,3559,17,0,0,0,0,1),
(49862,5085,23535,0,0,3,3,0),
(49863,5085,11397,1,1,1,0,0),
(49864,5085,11398,0,0,1,1,0),
(49865,5085,11590,0,0,1,1,0),
(49866,5085,16488,0,0,1,1,0),
(49867,5085,22057,0,0,1,1,0),
(49869,5085,22458,1,0,0,0,0),
(49871,5085,17,0,0,0,0,1),
(49872,5086,23535,0,0,2,2,0),
(49873,5086,11397,1,1,1,0,0),
(49874,5086,11398,0,0,1,1,0),
(49875,5086,11590,0,0,1,1,0),
(49876,5086,16488,0,0,1,1,0),
(49877,5086,22013,0,0,1,1,0),
(49879,5086,22460,1,0,0,0,0),
(49881,5086,17,0,0,0,0,1),
(49882,5087,11397,1,1,1,0,0),
(49883,5087,11398,0,0,1,1,0),
(49884,5087,11590,0,0,1,1,0),
(49885,5087,16488,0,0,1,1,0),
(49886,5087,22010,0,0,1,1,0),
(49887,5087,23535,0,0,1,1,0),
(49889,5087,22454,1,0,0,0,0),
(49891,5087,17,0,0,0,0,1),
(58709,6068,23535,0,0,3,3,0),
(58710,6068,11397,1,1,1,0,0),
(58711,6068,11398,0,0,1,1,0),
(58712,6068,11590,0,0,1,1,0),
(58713,6068,16488,0,0,1,1,0),
(58714,6068,22055,0,0,1,1,0),
(58716,6068,22446,1,0,0,0,0),
(58718,6068,17,0,0,0,0,1),
(58729,6070,11397,1,1,1,0,0),
(58730,6070,11398,0,0,1,1,0),
(58731,6070,11590,0,0,1,1,0),
(58732,6070,16488,0,0,1,1,0),
(58733,6070,22022,0,0,1,1,0),
(58734,6070,23535,0,0,1,1,0),
(58736,6070,22442,1,0,0,0,0),
(58738,6070,17,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*)INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*)INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe r JOIN rrc154_before e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC154 missing definitions';END IF;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe_entries r JOIN rrc154_entries e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>64 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC154 missing entries';END IF;
 IF EXISTS(SELECT 1 FROM rrc154_before e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC154 definition mismatch';END IF;
 IF EXISTS(SELECT 1 FROM rrc154_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc154_before p ON p.id=r.recipe_id)<>64 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC154 preserved entry mismatch';END IF;
 UPDATE tradeskill_recipe r JOIN rrc154_after e ON r.id=e.id SET r.trivial=e.trivial;
 SET changed_rows=ROW_COUNT();
 IF changed_rows<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC154 changed row mismatch';END IF;
 IF EXISTS(SELECT 1 FROM rrc154_after e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC154 definition mismatch';END IF;
 IF EXISTS(SELECT 1 FROM rrc154_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc154_before p ON p.id=r.recipe_id)<>64 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC154 preserved entry mismatch';END IF;
 IF(SELECT COUNT(*)FROM tradeskill_recipe)<>recipes_before OR(SELECT COUNT(*)FROM tradeskill_recipe_entries)<>entries_before THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC154 row count drift';END IF;
 DROP TEMPORARY TABLE rrc154_before;
 DROP TEMPORARY TABLE rrc154_after;
 DROP TEMPORARY TABLE rrc154_entries;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC154',changed_rows,recipes_before,(SELECT COUNT(*)FROM tradeskill_recipe),entries_before,(SELECT COUNT(*)FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
