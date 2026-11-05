-- RRC113: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
-- Source recipe facts/provenance: batch.public.json. No engine/updater/version/rule changes.
-- Anonymous compound block: no permanent helper procedure or migration table.
DELIMITER //
BEGIN NOT ATOMIC
 DECLARE own_transaction BOOLEAN DEFAULT FALSE;
 DECLARE parent_locked_rows BIGINT DEFAULT 0;
 DECLARE already_present INT DEFAULT 0;
 DECLARE recipes_before BIGINT DEFAULT 0;
 DECLARE entries_before BIGINT DEFAULT 0;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION
 BEGIN
  IF own_transaction THEN ROLLBACK; END IF;
  RESIGNAL;
 END;
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc113_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc113_parents LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc113_parent_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc113_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc113_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc113_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3094439,CONVERT(0x434c415353203620447261676f726e2053696c76657220546970204172726f772028536d616c6c2047726f6f766529 USING utf8mb4),64,0,228,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204f6f5720466c65746368696e67207265636f6e737472756374696f6e3b205252433131332e USING utf8mb4),0,0,0,1,8,-1,NULL,NULL),
(3094440,CONVERT(0x526f7567682042617a7520426f6e65205265637572766520426f77202868656d7029 USING utf8mb4),64,0,268,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204f6f5720466c65746368696e67207265636f6e737472756374696f6e3b205252433131332e USING utf8mb4),0,0,0,1,8,-1,NULL,NULL),
(3094441,CONVERT(0x5368617065642042617a7520426f6e65205265637572766520426f77202868656d7029 USING utf8mb4),64,0,268,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204f6f5720466c65746368696e67207265636f6e737472756374696f6e3b205252433131332e USING utf8mb4),0,0,0,1,8,-1,NULL,NULL),
(3094442,CONVERT(0x5368617065642042617a7520426f6e6520312d43616d20426f77202868656d7029 USING utf8mb4),64,0,282,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204f6f5720466c65746368696e67207265636f6e737472756374696f6e3b205252433131332e USING utf8mb4),0,0,0,1,8,-1,NULL,NULL),
(3094443,CONVERT(0x5368617065642042617a7520426f6e6520436f6d706f756e6420426f7720286c696e656e29 USING utf8mb4),64,0,302,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204f6f5720466c65746368696e67207265636f6e737472756374696f6e3b205252433131332e USING utf8mb4),0,0,0,1,8,-1,NULL,NULL);
INSERT INTO rrc113_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3094439,75583,10,0,0,0,0),
(3094439,72092,0,0,1,1,0),
(3094439,8069,0,0,1,1,0),
(3094439,8057,0,0,1,1,0),
(3094439,8052,0,0,1,1,0),
(3094439,17189,0,0,0,0,1),
(3094439,17762,0,0,0,0,1),
(3094439,17910,0,0,0,0,1),
(3094440,75665,1,0,0,0,0),
(3094440,72095,0,0,1,1,0),
(3094440,8088,0,0,1,1,0),
(3094440,17189,0,0,0,0,1),
(3094440,17762,0,0,0,0,1),
(3094440,17910,0,0,0,0,1),
(3094441,75673,1,0,0,0,0),
(3094441,72095,0,0,1,1,0),
(3094441,8088,0,0,1,1,0),
(3094441,8086,1,1,1,0,0),
(3094441,17189,0,0,0,0,1),
(3094441,17762,0,0,0,0,1),
(3094441,17910,0,0,0,0,1),
(3094442,75685,1,0,0,0,0),
(3094442,72095,0,0,1,1,0),
(3094442,8088,0,0,1,1,0),
(3094442,8086,1,1,1,0,0),
(3094442,8087,0,0,1,1,0),
(3094442,17189,0,0,0,0,1),
(3094442,17762,0,0,0,0,1),
(3094442,17910,0,0,0,0,1),
(3094443,75698,1,0,0,0,0),
(3094443,72095,0,0,1,1,0),
(3094443,8089,0,0,1,1,0),
(3094443,8086,1,1,1,0,0),
(3094443,8087,0,0,2,2,0),
(3094443,17189,0,0,0,0,1),
(3094443,17762,0,0,0,0,1),
(3094443,17910,0,0,0,0,1);
INSERT INTO rrc113_items (`id`,`name`) VALUES
(8052,CONVERT(0x536d616c6c2047726f6f7665204e6f636b73 USING utf8mb4)),
(8057,CONVERT(0x53696c76657220546970706564204172726f776865616473 USING utf8mb4)),
(8069,CONVERT(0x536574206f6620436572616d6963204172726f772056616e6573 USING utf8mb4)),
(8086,CONVERT(0x506c616e696e6720546f6f6c USING utf8mb4)),
(8087,CONVERT(0x5374616e6461726420426f772043616d USING utf8mb4)),
(8088,CONVERT(0x48656d70205477696e65 USING utf8mb4)),
(8089,CONVERT(0x4c696e656e20537472696e67 USING utf8mb4)),
(17189,CONVERT(0x436f6c6c61707369626c6520466c65746368696e67204b6974 USING utf8mb4)),
(17762,CONVERT(0x506c616e617220466c65746368696e67204b6974 USING utf8mb4)),
(17910,CONVERT(0x466c65746368696e67204b6974 USING utf8mb4)),
(72092,CONVERT(0x447261676f726e2057696e6720426f6e6573 USING utf8mb4)),
(72095,CONVERT(0x42617a7520426f6e65 USING utf8mb4)),
(75583,CONVERT(0x434c415353203620447261676f726e2053696c76657220546970204172726f77 USING utf8mb4)),
(75665,CONVERT(0x526f7567682042617a7520426f6e65205265637572766520426f77 USING utf8mb4)),
(75673,CONVERT(0x5368617065642042617a7520426f6e65205265637572766520426f77 USING utf8mb4)),
(75685,CONVERT(0x5368617065642042617a7520426f6e6520312d43616d20426f77 USING utf8mb4)),
(75698,CONVERT(0x5368617065642042617a7520426f6e6520436f6d706f756e6420426f77 USING utf8mb4));
INSERT INTO rrc113_parents (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(7259,CONVERT(0x436c617373203620447261676f726e2053696c76657220546970204172726f7720286c6172676529 USING utf8mb4),64,0,228,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7348,CONVERT(0x526f7567682042617a7520426f6e65205265637572766520426f77 USING utf8mb4),64,0,268,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7450,CONVERT(0x5368617065642042617a7520426f6e6520312d63616d20426f77 USING utf8mb4),64,0,282,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7451,CONVERT(0x5368617065642042617a7520426f6e6520436f6d706f756e6420426f77 USING utf8mb4),64,0,302,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7452,CONVERT(0x5368617065642042617a7520426f6e65205265637572766520426f77 USING utf8mb4),64,0,268,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
INSERT INTO rrc113_parent_entries (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(68614,7259,8050,0,0,1,1,0),
(68615,7259,8057,0,0,1,1,0),
(68616,7259,8069,0,0,1,1,0),
(68617,7259,72092,0,0,1,1,0),
(68618,7259,75581,10,0,0,0,0),
(68619,7259,17128,0,0,0,0,1),
(68620,7259,17189,0,0,0,0,1),
(68621,7259,17762,0,0,0,0,1),
(68622,7259,17910,0,0,0,0,1),
(68623,7259,66163,0,0,0,0,1),
(69411,7348,72094,0,0,1,1,0),
(69412,7348,72095,0,0,1,1,0),
(69413,7348,75668,1,0,0,0,0),
(69414,7348,17128,0,0,0,0,1),
(69415,7348,17189,0,0,0,0,1),
(69416,7348,17762,0,0,0,0,1),
(69417,7348,17910,0,0,0,0,1),
(69418,7348,66163,0,0,0,0,1),
(70246,7450,8086,1,1,1,0,0),
(70247,7450,8087,0,0,1,1,0),
(70248,7450,72094,0,0,1,1,0),
(70249,7450,72095,0,0,1,1,0),
(70251,7450,75688,1,0,0,0,0),
(70252,7450,17128,0,0,0,0,1),
(70253,7450,17189,0,0,0,0,1),
(70254,7450,17762,0,0,0,0,1),
(70255,7450,17910,0,0,0,0,1),
(70256,7450,66163,0,0,0,0,1),
(70257,7451,8087,0,0,2,2,0),
(70258,7451,8086,1,1,1,0,0),
(70259,7451,72094,0,0,1,1,0),
(70260,7451,72095,0,0,1,1,0),
(70262,7451,75700,1,0,0,0,0),
(70263,7451,17128,0,0,0,0,1),
(70264,7451,17189,0,0,0,0,1),
(70265,7451,17762,0,0,0,0,1),
(70266,7451,17910,0,0,0,0,1),
(70267,7451,66163,0,0,0,0,1),
(70268,7452,8086,1,1,1,0,0),
(70269,7452,72094,0,0,1,1,0),
(70270,7452,72095,0,0,1,1,0),
(70272,7452,75676,1,0,0,0,0),
(70274,7452,17128,0,0,0,0,1),
(70275,7452,17189,0,0,0,0,1),
(70276,7452,17762,0,0,0,0,1),
(70277,7452,17910,0,0,0,0,1),
(70278,7452,66163,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*)INTO parent_locked_rows FROM tradeskill_recipe r JOIN rrc113_parents p ON p.id=r.id FOR UPDATE;
 IF parent_locked_rows<>5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 RRC112parent missing'; END IF;
 SELECT COUNT(*)INTO parent_locked_rows FROM tradeskill_recipe_entries r JOIN rrc113_parents p ON p.id=r.recipe_id FOR UPDATE;
 IF parent_locked_rows<>47 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 RRC112parent entries missing'; END IF;
 IF EXISTS(SELECT 1 FROM rrc113_parents e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 RRC112postimage definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc113_parent_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc113_parents p ON p.id=r.recipe_id)<>47 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 RRC112postimage entry drift'; END IF;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc113_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc113_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=8052 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `range` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=8057 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `range` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=8069 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `range` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=8086 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `range` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=8087 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `range` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=8088 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `range` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=8089 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `range` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17189 AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `damage` <=> 0 AND `range` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> -1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17762 AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `damage` <=> 0 AND `range` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17910 AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `damage` <=> 0 AND `range` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=72092 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `range` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=72095 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `range` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=75583 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 27 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 9 AND `range` <=> 100 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `delay` <=> 0 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `slots` <=> 4194304)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=75665 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 30 AND `range` <=> 150 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `delay` <=> 64 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `slots` <=> 2048)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=75673 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 28 AND `range` <=> 150 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `delay` <=> 55 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `slots` <=> 2048)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=75685 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 27 AND `range` <=> 175 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `delay` <=> 50 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `slots` <=> 2048)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=75698 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 25 AND `range` <=> 200 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `delay` <=> 41 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `slots` <=> 2048)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 native item semantics mismatch'; END IF;
 IF already_present<>5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc113_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc113_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc113_recipes q ON q.id=r.recipe_id LEFT JOIN rrc113_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc113_recipes q ON q.id=r.recipe_id)<>37 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc113_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc113_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc113_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-5 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-37 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 rollback count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc113_parents e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 RRC112postimage definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc113_parent_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc113_parents p ON p.id=r.recipe_id)<>47 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC113 RRC112postimage entry drift'; END IF;
 DROP TEMPORARY TABLE rrc113_parent_entries;
 DROP TEMPORARY TABLE rrc113_parents;
 DROP TEMPORARY TABLE rrc113_entries;
 DROP TEMPORARY TABLE rrc113_recipes;
 DROP TEMPORARY TABLE rrc113_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC113' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
