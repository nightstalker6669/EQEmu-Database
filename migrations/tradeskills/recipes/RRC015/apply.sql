-- RRC015: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC015 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC015 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC015 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC015 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc015_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc015_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc015_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc015_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3091284,CONVERT(0x436f6d626174205370656c6c626f6f6b USING utf8mb4),58,0,375,0,0,CONVERT(0x526f463b204d65726368616e7420416c6c69616e6365205472616465626f6f6b2052657365617263683b205252433031352e USING utf8mb4),1,81108,0,1,19,-1,NULL,NULL);
INSERT INTO rrc015_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3091284,81122,1,0,0,0,0),
(3091284,14246,0,0,1,1,0),
(3091284,13063,0,0,5,5,0),
(3091284,81132,0,0,1,1,0),
(3091284,93492,0,0,0,0,1),
(3091284,41555,0,0,0,0,1),
(3091284,41631,0,0,0,0,1),
(3091284,41632,0,0,0,0,1),
(3091284,41633,0,0,0,0,1);
INSERT INTO rrc015_items (`id`,`name`) VALUES
(13063,CONVERT(0x5069656365206f662050617263686d656e74 USING utf8mb4)),
(14246,CONVERT(0x4d797374696320417368 USING utf8mb4)),
(41555,CONVERT(0x546f6d652042696e64696e67204b6974 USING utf8mb4)),
(41631,CONVERT(0x5072617965722057726974696e67204b6974 USING utf8mb4)),
(41632,CONVERT(0x487962726964205265736561726368204b6974 USING utf8mb4)),
(41633,CONVERT(0x536f6e672057726974696e67204b6974 USING utf8mb4)),
(81108,CONVERT(0x4d65726368616e7420416c6c69616e6365205472616465626f6f6b USING utf8mb4)),
(81122,CONVERT(0x436f6d626174205370656c6c626f6f6b USING utf8mb4)),
(81132,CONVERT(0x57726974696e6720496e6b USING utf8mb4)),
(93492,CONVERT(0x5370656c6c205265736561726368204b6974 USING utf8mb4));
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF NOT EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.`id` <=> 3091271 AND r.`name` <=> CONVERT(0x436f6d626174205370656c6c626f6f6b USING utf8mb4) AND r.`tradeskill` <=> 61 AND r.`skillneeded` <=> 300 AND r.`trivial` <=> 375 AND r.`nofail` <=> 0 AND r.`replace_container` <=> 0 AND r.`notes` <=> CONVERT(0x526f463b204d65726368616e7420416c6c69616e6365205472616465626f6f6b3b205252433031322e USING utf8mb4) AND r.`must_learn` <=> 1 AND r.`learned_by_item_id` <=> 81108 AND r.`quest` <=> 0 AND r.`enabled` <=> 1 AND r.`min_expansion` <=> 19 AND r.`max_expansion` <=> -1 AND r.`content_flags` <=> NULL AND r.`content_flags_disabled` <=> NULL) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries WHERE recipe_id=3091271)<>5 OR NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.`recipe_id` <=> 3091271 AND e.`item_id` <=> 81122 AND e.`successcount` <=> 1 AND e.`failcount` <=> 0 AND e.`componentcount` <=> 0 AND e.`salvagecount` <=> 0 AND e.`iscontainer` <=> 0) OR NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.`recipe_id` <=> 3091271 AND e.`item_id` <=> 14246 AND e.`successcount` <=> 0 AND e.`failcount` <=> 0 AND e.`componentcount` <=> 1 AND e.`salvagecount` <=> 1 AND e.`iscontainer` <=> 0) OR NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.`recipe_id` <=> 3091271 AND e.`item_id` <=> 13063 AND e.`successcount` <=> 0 AND e.`failcount` <=> 0 AND e.`componentcount` <=> 5 AND e.`salvagecount` <=> 5 AND e.`iscontainer` <=> 0) OR NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.`recipe_id` <=> 3091271 AND e.`item_id` <=> 81132 AND e.`successcount` <=> 0 AND e.`failcount` <=> 0 AND e.`componentcount` <=> 1 AND e.`salvagecount` <=> 1 AND e.`iscontainer` <=> 0) OR NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.`recipe_id` <=> 3091271 AND e.`item_id` <=> 16 AND e.`successcount` <=> 0 AND e.`failcount` <=> 0 AND e.`componentcount` <=> 0 AND e.`salvagecount` <=> 0 AND e.`iscontainer` <=> 1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC015 exact Tailoring counterpart mismatch'; END IF;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc015_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc015_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC015 item identity/dependency mismatch'; END IF;
 IF NOT EXISTS(SELECT 1 FROM items i WHERE i.`id` <=> 93492 AND i.`itemclass` <=> 1 AND i.`bagtype` <=> 11 AND i.`bagslots` <=> 10 AND i.`classes` <=> 15360 AND i.`races` <=> 131071) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC015 exact named kit mismatch'; END IF;
 IF NOT EXISTS(SELECT 1 FROM items i WHERE i.`id` <=> 41555 AND i.`itemclass` <=> 1 AND i.`bagtype` <=> 11 AND i.`bagslots` <=> 10 AND i.`classes` <=> 33089 AND i.`races` <=> 131071) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC015 exact named kit mismatch'; END IF;
 IF NOT EXISTS(SELECT 1 FROM items i WHERE i.`id` <=> 41631 AND i.`itemclass` <=> 1 AND i.`bagtype` <=> 11 AND i.`bagslots` <=> 10 AND i.`classes` <=> 16930 AND i.`races` <=> 131071) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC015 exact named kit mismatch'; END IF;
 IF NOT EXISTS(SELECT 1 FROM items i WHERE i.`id` <=> 41632 AND i.`itemclass` <=> 1 AND i.`bagtype` <=> 11 AND i.`bagslots` <=> 10 AND i.`classes` <=> 16412 AND i.`races` <=> 131071) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC015 exact named kit mismatch'; END IF;
 IF NOT EXISTS(SELECT 1 FROM items i WHERE i.`id` <=> 41633 AND i.`itemclass` <=> 1 AND i.`bagtype` <=> 11 AND i.`bagslots` <=> 10 AND i.`classes` <=> 128 AND i.`races` <=> 131071) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC015 exact named kit mismatch'; END IF;
 IF NOT EXISTS(SELECT 1 FROM items WHERE id=81108 AND itemclass=2 AND itemtype=60 AND booktype=0 AND classes=65535 AND BINARY filename=BINARY 'TSQMATradebook') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC015 mandatory book mismatch'; END IF;
 IF already_present NOT IN (0,1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC015 partial batch or ID collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r JOIN rrc015_recipes e ON r.tradeskill=e.tradeskill AND r.name=e.name WHERE r.id<>e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC015 existing recipe-name collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc015_entries e ON r.item_id=e.item_id JOIN rrc015_recipes q ON e.recipe_id=q.id WHERE e.successcount>0 AND e.componentcount=0 AND e.iscontainer=0 AND r.successcount>0 AND r.iscontainer=0 AND r.recipe_id<>e.recipe_id AND NOT(e.recipe_id=3091284 AND r.recipe_id=3091271 AND e.item_id=81122)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC015 existing output recipe collision'; END IF;
 IF already_present=0 THEN
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc015_recipes e ON r.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC015 orphan target entries collision'; END IF;
 INSERT INTO tradeskill_recipe (id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled) SELECT id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled FROM rrc015_recipes;
 INSERT INTO tradeskill_recipe_entries (recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer) SELECT recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer FROM rrc015_entries;
 END IF;
 IF EXISTS(SELECT 1 FROM rrc015_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC015 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc015_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC015 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc015_recipes q ON q.id=r.recipe_id LEFT JOIN rrc015_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC015 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc015_recipes q ON q.id=r.recipe_id)<>9 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC015 target entry multiplicity mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before+IF(already_present=0,1,0) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before+IF(already_present=0,9,0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC015 unexpected table row-count delta'; END IF;
 IF NOT EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.`id` <=> 3091271 AND r.`name` <=> CONVERT(0x436f6d626174205370656c6c626f6f6b USING utf8mb4) AND r.`tradeskill` <=> 61 AND r.`skillneeded` <=> 300 AND r.`trivial` <=> 375 AND r.`nofail` <=> 0 AND r.`replace_container` <=> 0 AND r.`notes` <=> CONVERT(0x526f463b204d65726368616e7420416c6c69616e6365205472616465626f6f6b3b205252433031322e USING utf8mb4) AND r.`must_learn` <=> 1 AND r.`learned_by_item_id` <=> 81108 AND r.`quest` <=> 0 AND r.`enabled` <=> 1 AND r.`min_expansion` <=> 19 AND r.`max_expansion` <=> -1 AND r.`content_flags` <=> NULL AND r.`content_flags_disabled` <=> NULL) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries WHERE recipe_id=3091271)<>5 OR NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.`recipe_id` <=> 3091271 AND e.`item_id` <=> 81122 AND e.`successcount` <=> 1 AND e.`failcount` <=> 0 AND e.`componentcount` <=> 0 AND e.`salvagecount` <=> 0 AND e.`iscontainer` <=> 0) OR NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.`recipe_id` <=> 3091271 AND e.`item_id` <=> 14246 AND e.`successcount` <=> 0 AND e.`failcount` <=> 0 AND e.`componentcount` <=> 1 AND e.`salvagecount` <=> 1 AND e.`iscontainer` <=> 0) OR NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.`recipe_id` <=> 3091271 AND e.`item_id` <=> 13063 AND e.`successcount` <=> 0 AND e.`failcount` <=> 0 AND e.`componentcount` <=> 5 AND e.`salvagecount` <=> 5 AND e.`iscontainer` <=> 0) OR NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.`recipe_id` <=> 3091271 AND e.`item_id` <=> 81132 AND e.`successcount` <=> 0 AND e.`failcount` <=> 0 AND e.`componentcount` <=> 1 AND e.`salvagecount` <=> 1 AND e.`iscontainer` <=> 0) OR NOT EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.`recipe_id` <=> 3091271 AND e.`item_id` <=> 16 AND e.`successcount` <=> 0 AND e.`failcount` <=> 0 AND e.`componentcount` <=> 0 AND e.`salvagecount` <=> 0 AND e.`iscontainer` <=> 1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC015 exact Tailoring counterpart mismatch'; END IF;
 DROP TEMPORARY TABLE rrc015_entries;
 DROP TEMPORARY TABLE rrc015_recipes;
 DROP TEMPORARY TABLE rrc015_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC015' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
