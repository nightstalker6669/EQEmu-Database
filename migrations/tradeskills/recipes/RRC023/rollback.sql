-- RRC023: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC023 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC023 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC023 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC023 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc023_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc023_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc023_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc023_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3091548,CONVERT(0x5461656c6f7369616e20446f75676820283229 USING utf8mb4),60,0,28,0,0,CONVERT(0x506f523b20455154432061727469636c6533373320646f75626c652d7969656c6420646f7567683b205252433032332e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3091549,CONVERT(0x5461656c6f7369616e204d6f756e7461696e20446f75676820283229 USING utf8mb4),60,0,38,0,0,CONVERT(0x506f523b20455154432061727469636c6533373320646f75626c652d7969656c6420646f7567683b205252433032332e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL);
INSERT INTO rrc023_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3091548,96732,2,0,0,0,0),
(3091548,67741,0,0,2,2,0),
(3091548,58155,0,0,2,2,0),
(3091548,14,0,0,0,0,1),
(3091549,96734,2,0,0,0,0),
(3091549,67741,0,0,2,2,0),
(3091549,58150,0,0,2,2,0),
(3091549,14,0,0,0,0,1);
INSERT INTO rrc023_items (`id`,`name`) VALUES
(17906,CONVERT(0x4d6978696e6720426f776c USING utf8mb4)),
(58150,CONVERT(0x5461656c6f7369616e204d6f756e7461696e20576865617420466c6f7572 USING utf8mb4)),
(58155,CONVERT(0x5461656c6f7369616e20576865617420466c6f7572 USING utf8mb4)),
(67741,CONVERT(0x45676720426174746572 USING utf8mb4)),
(96732,CONVERT(0x5461656c6f7369616e20446f756768 USING utf8mb4)),
(96734,CONVERT(0x5461656c6f7369616e204d6f756e7461696e20446f756768 USING utf8mb4));
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc023_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc023_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC023 item identity/dependency mismatch'; END IF;
 IF NOT EXISTS(SELECT 1 FROM items WHERE id=17906 AND itemclass=1 AND bagtype=14 AND bagslots=10) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC023 mixing bowl dependency mismatch'; END IF;
 IF already_present<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC023 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc023_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC023 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc023_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC023 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc023_recipes q ON q.id=r.recipe_id LEFT JOIN rrc023_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC023 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc023_recipes q ON q.id=r.recipe_id)<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC023 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc023_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC023 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc023_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc023_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-2 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC023 rollback count mismatch'; END IF;
 DROP TEMPORARY TABLE rrc023_entries;
 DROP TEMPORARY TABLE rrc023_recipes;
 DROP TEMPORARY TABLE rrc023_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC023' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
