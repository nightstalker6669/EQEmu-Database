-- RRC103: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC103 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC103 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC103 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC103 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc103_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc103_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc103_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc103_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3094022,CONVERT(0x53696d706c65204172726f77 USING utf8mb4),64,0,31,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204372657363656e74526561636820747261696e696e67207265636f6e737472756374696f6e3b205252433130332e USING utf8mb4),2,0,0,1,12,-1,NULL,NULL),
(3094023,CONVERT(0x53696d706c65204172726f7768656164 USING utf8mb4),64,0,54,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204372657363656e74526561636820747261696e696e67207265636f6e737472756374696f6e3b205252433130332e USING utf8mb4),2,0,0,1,12,-1,NULL,NULL),
(3094024,CONVERT(0x53696d706c6520426f77 USING utf8mb4),64,0,38,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204372657363656e74526561636820747261696e696e67207265636f6e737472756374696f6e3b205252433130332e USING utf8mb4),2,0,0,1,12,-1,NULL,NULL),
(3094025,CONVERT(0x53696d706c6520426f777374617665 USING utf8mb4),64,0,46,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204372657363656e74526561636820747261696e696e67207265636f6e737472756374696f6e3b205252433130332e USING utf8mb4),2,0,0,1,12,-1,NULL,NULL);
INSERT INTO rrc103_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3094022,98267,0,0,1,1,0),
(3094022,98274,0,0,1,1,0),
(3094022,98288,0,0,1,1,0),
(3094022,98264,1,0,0,0,0),
(3094022,17189,0,0,0,0,1),
(3094022,17762,0,0,0,0,1),
(3094022,17910,0,0,0,0,1),
(3094023,58072,0,0,1,1,0),
(3094023,98276,0,0,1,1,0),
(3094023,98267,1,0,0,0,0),
(3094023,17189,0,0,0,0,1),
(3094023,17762,0,0,0,0,1),
(3094023,17910,0,0,0,0,1),
(3094024,98271,0,0,1,1,0),
(3094024,98272,0,0,1,1,0),
(3094024,98270,1,0,0,0,0),
(3094024,17189,0,0,0,0,1),
(3094024,17762,0,0,0,0,1),
(3094024,17910,0,0,0,0,1),
(3094025,58077,0,0,1,1,0),
(3094025,98276,0,0,1,1,0),
(3094025,98271,1,0,0,0,0),
(3094025,17189,0,0,0,0,1),
(3094025,17762,0,0,0,0,1),
(3094025,17910,0,0,0,0,1);
INSERT INTO rrc103_items (`id`,`name`) VALUES
(17189,CONVERT(0x436f6c6c61707369626c6520466c65746368696e67204b6974 USING utf8mb4)),
(17762,CONVERT(0x506c616e617220466c65746368696e67204b6974 USING utf8mb4)),
(17910,CONVERT(0x466c65746368696e67204b6974 USING utf8mb4)),
(58072,CONVERT(0x53616c7661676564204172726f7768656164 USING utf8mb4)),
(58077,CONVERT(0x53636176656e67656420426f77205374616666 USING utf8mb4)),
(98264,CONVERT(0x53696d706c65204172726f77 USING utf8mb4)),
(98267,CONVERT(0x53696d706c65204172726f7768656164 USING utf8mb4)),
(98270,CONVERT(0x53696d706c6520426f77 USING utf8mb4)),
(98271,CONVERT(0x53696d706c6520426f77205374616666 USING utf8mb4)),
(98272,CONVERT(0x53696d706c6520426f7720537472696e67 USING utf8mb4)),
(98274,CONVERT(0x53696d706c6520466c65746368696e67 USING utf8mb4)),
(98276,CONVERT(0x53696d706c6520486f6e696e672053746f6e65 USING utf8mb4)),
(98288,CONVERT(0x53696d706c65205368616674 USING utf8mb4));
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc103_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc103_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC103 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17189 AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC103 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17762 AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC103 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17910 AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC103 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=58072 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC103 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=58077 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC103 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=98264 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC103 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=98267 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC103 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=98270 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC103 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=98271 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC103 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=98272 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC103 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=98274 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC103 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=98276 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC103 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=98288 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC103 native item semantics mismatch'; END IF;
 IF already_present<>4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC103 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc103_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC103 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc103_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC103 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc103_recipes q ON q.id=r.recipe_id LEFT JOIN rrc103_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC103 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc103_recipes q ON q.id=r.recipe_id)<>25 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC103 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc103_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC103 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc103_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc103_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-4 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-25 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC103 rollback count mismatch'; END IF;
 DROP TEMPORARY TABLE rrc103_entries;
 DROP TEMPORARY TABLE rrc103_recipes;
 DROP TEMPORARY TABLE rrc103_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC103' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
