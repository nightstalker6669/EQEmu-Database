-- RRC077: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC077 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC077 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC077 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC077 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc077_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc077_parents LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc077_parent_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc077_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc077_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc077_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3093633,CONVERT(0x526f756768205370656c6c205461626c6574 USING utf8mb4),58,0,243,0,0,CONVERT(0x5072696d617279207461626c657420726566696e656d656e743b206578697374696e67205370656c6c205265736561726368204b697420726f757465206f6e6c793b205252433037372e USING utf8mb4),2,0,0,1,18,-1,NULL,NULL),
(3093634,CONVERT(0x5370656c6c205461626c6574 USING utf8mb4),58,0,243,0,0,CONVERT(0x5072696d617279207461626c657420726566696e656d656e743b206578697374696e67205370656c6c205265736561726368204b697420726f757465206f6e6c793b205252433037372e USING utf8mb4),2,0,0,1,18,-1,NULL,NULL),
(3093635,CONVERT(0x46696e65205370656c6c205461626c6574 USING utf8mb4),58,0,243,0,0,CONVERT(0x5072696d617279207461626c657420726566696e656d656e743b206578697374696e67205370656c6c205265736561726368204b697420726f757465206f6e6c793b205252433037372e USING utf8mb4),2,0,0,1,18,-1,NULL,NULL),
(3093636,CONVERT(0x52756e6963205370656c6c205461626c6574 USING utf8mb4),58,0,243,0,0,CONVERT(0x5072696d617279207461626c657420726566696e656d656e743b206578697374696e67205370656c6c205265736561726368204b697420726f757465206f6e6c793b205252433037372e USING utf8mb4),2,0,0,1,18,-1,NULL,NULL),
(3093637,CONVERT(0x46696e652052756e6963205370656c6c205461626c6574 USING utf8mb4),58,0,243,0,0,CONVERT(0x5072696d617279207461626c657420726566696e656d656e743b206578697374696e67205370656c6c205265736561726368204b697420726f757465206f6e6c793b205252433037372e USING utf8mb4),2,0,0,1,18,-1,NULL,NULL);
INSERT INTO rrc077_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3093633,64900,1,0,0,0,0),
(3093633,93617,0,0,1,1,0),
(3093633,64910,0,0,1,1,0),
(3093633,64915,0,0,1,1,0),
(3093633,93492,0,0,0,0,1),
(3093634,64901,1,0,0,0,0),
(3093634,93617,0,0,1,1,0),
(3093634,64916,0,0,1,1,0),
(3093634,64911,0,0,1,1,0),
(3093634,93492,0,0,0,0,1),
(3093635,64902,1,0,0,0,0),
(3093635,93617,0,0,1,1,0),
(3093635,64912,0,0,1,1,0),
(3093635,64917,0,0,1,1,0),
(3093635,93492,0,0,0,0,1),
(3093636,64903,1,0,0,0,0),
(3093636,93617,0,0,1,1,0),
(3093636,64913,0,0,1,1,0),
(3093636,64918,0,0,1,1,0),
(3093636,93492,0,0,0,0,1),
(3093637,64904,1,0,0,0,0),
(3093637,93617,0,0,1,1,0),
(3093637,64914,0,0,1,1,0),
(3093637,64919,0,0,1,1,0),
(3093637,93492,0,0,0,0,1);
INSERT INTO rrc077_items (`id`,`name`) VALUES
(64900,CONVERT(0x526f756768205370656c6c205461626c6574 USING utf8mb4)),
(64901,CONVERT(0x5370656c6c205461626c6574 USING utf8mb4)),
(64902,CONVERT(0x46696e65205370656c6c205461626c6574 USING utf8mb4)),
(64903,CONVERT(0x52756e6963205370656c6c205461626c6574 USING utf8mb4)),
(64904,CONVERT(0x46696e652052756e6963205370656c6c205461626c6574 USING utf8mb4)),
(64910,CONVERT(0x526f756768205370656c6c205461626c657420536f6c7574696f6e USING utf8mb4)),
(64911,CONVERT(0x5370656c6c205461626c657420536f6c7574696f6e USING utf8mb4)),
(64912,CONVERT(0x46696e65205370656c6c205461626c657420536f6c7574696f6e USING utf8mb4)),
(64913,CONVERT(0x52756e6963205370656c6c205461626c657420536f6c7574696f6e USING utf8mb4)),
(64914,CONVERT(0x46696e652052756e6963205370656c6c205461626c657420536f6c7574696f6e USING utf8mb4)),
(64915,CONVERT(0x536d756467656420526f756768205370656c6c205461626c6574 USING utf8mb4)),
(64916,CONVERT(0x536f6f7479205370656c6c205461626c6574 USING utf8mb4)),
(64917,CONVERT(0x536f6f74792046696e65205370656c6c205461626c6574 USING utf8mb4)),
(64918,CONVERT(0x536d75646765642052756e6963205370656c6c205461626c6574 USING utf8mb4)),
(64919,CONVERT(0x537461696e65642046696e652052756e6963205370656c6c205461626c6574 USING utf8mb4)),
(93492,CONVERT(0x5370656c6c205265736561726368204b6974 USING utf8mb4)),
(93617,CONVERT(0x43656c65737469616c20436c65616e736572 USING utf8mb4));
INSERT INTO rrc077_parents (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(12805,CONVERT(0x526f7567682043686172746120417263616e756d USING utf8mb4),58,0,243,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12806,CONVERT(0x43686172746120417263616e756d USING utf8mb4),58,0,243,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12807,CONVERT(0x46696e652043686172746120417263616e756d USING utf8mb4),58,0,243,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12808,CONVERT(0x52756e69632043686172746120417263616e756d USING utf8mb4),58,0,243,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12809,CONVERT(0x46696e652052756e69632043686172746120417263616e756d USING utf8mb4),58,0,243,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL);
INSERT INTO rrc077_parent_entries (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(150236,12805,93617,0,0,1,1,0),
(150237,12805,90317,0,0,1,1,0),
(150238,12805,90322,0,0,1,1,0),
(150239,12805,93492,0,0,0,0,1),
(150240,12805,90307,1,0,0,0,0),
(150241,12805,41555,0,0,0,0,1),
(150242,12805,41631,0,0,0,0,1),
(150243,12805,41632,0,0,0,0,1),
(150244,12806,93617,0,0,1,1,0),
(150245,12806,90318,0,0,1,1,0),
(150246,12806,90323,0,0,1,1,0),
(150247,12806,90308,1,0,0,0,0),
(150248,12806,93492,0,0,0,0,1),
(150249,12806,41555,0,0,0,0,1),
(150250,12806,41631,0,0,0,0,1),
(150251,12806,41632,0,0,0,0,1),
(150252,12807,93617,0,0,1,1,0),
(150253,12807,90319,0,0,1,1,0),
(150254,12807,90324,0,0,1,1,0),
(150255,12807,90309,1,0,0,0,0),
(150256,12807,93492,0,0,0,0,1),
(150257,12807,41555,0,0,0,0,1),
(150258,12807,41631,0,0,0,0,1),
(150259,12807,41632,0,0,0,0,1),
(150260,12808,93617,0,0,1,1,0),
(150261,12808,90320,0,0,1,1,0),
(150262,12808,90325,0,0,1,1,0),
(150263,12808,90310,1,0,0,0,0),
(150264,12808,93492,0,0,0,0,1),
(150265,12808,41555,0,0,0,0,1),
(150266,12808,41631,0,0,0,0,1),
(150267,12808,41632,0,0,0,0,1),
(150268,12809,93617,0,0,1,1,0),
(150269,12809,90321,0,0,1,1,0),
(150270,12809,90326,0,0,1,1,0),
(150271,12809,90311,1,0,0,0,0),
(150272,12809,93492,0,0,0,0,1),
(150273,12809,41555,0,0,0,0,1),
(150274,12809,41631,0,0,0,0,1),
(150275,12809,41632,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF EXISTS(SELECT 1 FROM rrc077_parents e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC077 prototype drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc077_parent_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc077_parents p ON p.id=r.recipe_id)<>40 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC077 prototype entries drift'; END IF;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc077_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc077_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC077 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93492 AND itemclass=1 AND bagtype=11 AND bagslots=10 AND bagsize=3 AND classes=15360)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC077 native kit mismatch'; END IF; IF (SELECT COUNT(*) FROM items WHERE (id=64900 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=93617 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=64910 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=64915 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=64901 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=64916 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=64911 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=64902 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=64912 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=64917 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=64903 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=64913 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=64918 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=64904 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=64914 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=64919 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360))<>16 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC077 input/output semantics mismatch'; END IF;
 IF already_present NOT IN (0,5) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC077 partial batch or ID collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r JOIN rrc077_recipes e ON r.tradeskill=e.tradeskill AND r.name=e.name WHERE r.id<>e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC077 existing recipe-name collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc077_entries e ON r.item_id=e.item_id JOIN rrc077_recipes q ON e.recipe_id=q.id WHERE e.successcount>e.componentcount AND e.iscontainer=0 AND r.successcount>r.componentcount AND r.iscontainer=0 AND r.recipe_id<>e.recipe_id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC077 existing output recipe collision'; END IF;
 IF already_present=0 THEN
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc077_recipes e ON r.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC077 orphan target entries collision'; END IF;
 INSERT INTO tradeskill_recipe (id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled) SELECT id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled FROM rrc077_recipes;
 INSERT INTO tradeskill_recipe_entries (recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer) SELECT recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer FROM rrc077_entries;
 END IF;
 IF EXISTS(SELECT 1 FROM rrc077_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC077 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc077_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC077 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc077_recipes q ON q.id=r.recipe_id LEFT JOIN rrc077_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC077 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc077_recipes q ON q.id=r.recipe_id)<>25 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC077 target entry multiplicity mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before+IF(already_present=0,5,0) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before+IF(already_present=0,25,0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC077 unexpected table row-count delta'; END IF;
 IF EXISTS(SELECT 1 FROM rrc077_parents e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC077 prototype drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc077_parent_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc077_parents p ON p.id=r.recipe_id)<>40 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC077 prototype entries drift'; END IF;
 DROP TEMPORARY TABLE rrc077_parents;
 DROP TEMPORARY TABLE rrc077_parent_entries;
 DROP TEMPORARY TABLE rrc077_entries;
 DROP TEMPORARY TABLE rrc077_recipes;
 DROP TEMPORARY TABLE rrc077_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC077' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
