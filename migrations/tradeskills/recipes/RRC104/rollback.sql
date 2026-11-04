-- RRC104: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC104 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC104 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC104 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC104 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc104_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc104_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc104_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc104_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3094026,CONVERT(0x576f6f6420537472697073 USING utf8mb4),64,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727931307468416e6e697665727361727920466c65746368696e67207265636f6e737472756374696f6e3b205252433130342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3094027,CONVERT(0x576f76656e204261736b6574 USING utf8mb4),64,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727931307468416e6e697665727361727920466c65746368696e67207265636f6e737472756374696f6e3b205252433130342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL);
INSERT INTO rrc104_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3094026,42895,4,0,0,0,0),
(3094026,42898,0,0,1,1,0),
(3094026,8080,0,0,1,1,0),
(3094026,8086,1,1,1,0,0),
(3094026,75856,0,0,1,1,0),
(3094026,13006,0,0,1,1,0),
(3094026,17189,0,0,0,0,1),
(3094026,17762,0,0,0,0,1),
(3094026,17910,0,0,0,0,1),
(3094027,42896,1,0,0,0,0),
(3094027,75856,0,0,1,1,0),
(3094027,13006,0,0,1,1,0),
(3094027,42895,0,0,4,4,0),
(3094027,17189,0,0,0,0,1),
(3094027,17762,0,0,0,0,1),
(3094027,17910,0,0,0,0,1);
INSERT INTO rrc104_items (`id`,`name`) VALUES
(8080,CONVERT(0x4869636b6f727920426f77205374616666 USING utf8mb4)),
(8086,CONVERT(0x506c616e696e6720546f6f6c USING utf8mb4)),
(13006,CONVERT(0x576174657220466c61736b USING utf8mb4)),
(17189,CONVERT(0x436f6c6c61707369626c6520466c65746368696e67204b6974 USING utf8mb4)),
(17762,CONVERT(0x506c616e617220466c65746368696e67204b6974 USING utf8mb4)),
(17910,CONVERT(0x466c65746368696e67204b6974 USING utf8mb4)),
(42895,CONVERT(0x576f6f6420537472697073 USING utf8mb4)),
(42896,CONVERT(0x576f76656e204261736b6574 USING utf8mb4)),
(42898,CONVERT(0x436f6e7369676e65642054616e61616e2047696e6b6f USING utf8mb4)),
(75856,CONVERT(0x526f636b2053616c74 USING utf8mb4));
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc104_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc104_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC104 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=8080 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC104 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=8086 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC104 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=13006 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 15 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC104 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17189 AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC104 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17762 AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC104 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17910 AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC104 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=42895 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC104 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=42896 AND `size` <=> 2 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 13 AND `bagslots` <=> 6 AND `bagsize` <=> 2 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC104 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=42898 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC104 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=75856 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC104 native item semantics mismatch'; END IF;
 IF already_present<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC104 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc104_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC104 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc104_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC104 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc104_recipes q ON q.id=r.recipe_id LEFT JOIN rrc104_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC104 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc104_recipes q ON q.id=r.recipe_id)<>16 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC104 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc104_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC104 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc104_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc104_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-2 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-16 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC104 rollback count mismatch'; END IF;
 DROP TEMPORARY TABLE rrc104_entries;
 DROP TEMPORARY TABLE rrc104_recipes;
 DROP TEMPORARY TABLE rrc104_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC104' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
