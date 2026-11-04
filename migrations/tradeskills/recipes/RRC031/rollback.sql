-- RRC031: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC031 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC031 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC031 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC031 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc031_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc031_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc031_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc031_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3091908,CONVERT(0x436c756d70206f6620446f756768202853616e6420536e616b652045676729 USING utf8mb4),60,0,17,0,0,CONVERT(0x446f44483b20455154432061727469636c653334363b20646f7567682f65676720696e7075742076617269616e74733b205252433033312e USING utf8mb4),0,0,0,1,10,-1,NULL,NULL),
(3091909,CONVERT(0x45676720426174746572202853746f6e6520536e616b652045676729 USING utf8mb4),60,0,17,0,0,CONVERT(0x446f44483b20455154432061727469636c653334363b20646f7567682f65676720696e7075742076617269616e74733b205252433033312e USING utf8mb4),0,0,0,1,10,-1,NULL,NULL),
(3091910,CONVERT(0x45676720426174746572202853616e6420536e616b652045676729 USING utf8mb4),60,0,17,0,0,CONVERT(0x446f44483b20455154432061727469636c653334363b20646f7567682f65676720696e7075742076617269616e74733b205252433033312e USING utf8mb4),0,0,0,1,10,-1,NULL,NULL),
(3091911,CONVERT(0x4d69786564204567672028477265656e20536e616b652045676729 USING utf8mb4),60,0,17,0,0,CONVERT(0x446f44483b20455154432061727469636c653334363b20646f7567682f65676720696e7075742076617269616e74733b205252433033312e USING utf8mb4),0,0,0,1,10,-1,NULL,NULL);
INSERT INTO rrc031_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3091908,13090,1,0,0,0,0),
(3091908,13087,0,0,1,1,0),
(3091908,13193,0,0,1,1,0),
(3091908,32645,0,0,1,1,0),
(3091908,14,0,0,0,0,1),
(3091909,67741,1,0,0,0,0),
(3091909,13087,0,0,1,1,0),
(3091909,32643,0,0,1,1,0),
(3091909,14,0,0,0,0,1),
(3091910,67741,1,0,0,0,0),
(3091910,13087,0,0,1,1,0),
(3091910,32645,0,0,1,1,0),
(3091910,14,0,0,0,0,1),
(3091911,96731,1,0,0,0,0),
(3091911,9727,1,1,1,0,0),
(3091911,32644,0,0,1,1,0),
(3091911,14,0,0,0,0,1);
INSERT INTO rrc031_items (`id`,`name`) VALUES
(9727,CONVERT(0x44616972792053706f6f6e USING utf8mb4)),
(13087,CONVERT(0x426f74746c65206f66204d696c6b USING utf8mb4)),
(13090,CONVERT(0x436c756d70206f6620446f756768 USING utf8mb4)),
(13193,CONVERT(0x437570206f6620466c6f7572 USING utf8mb4)),
(17906,CONVERT(0x4d6978696e6720426f776c USING utf8mb4)),
(32643,CONVERT(0x53746f6e6520536e616b6520456767 USING utf8mb4)),
(32644,CONVERT(0x477265656e20536e616b6520456767 USING utf8mb4)),
(32645,CONVERT(0x53616e6420536e616b6520456767 USING utf8mb4)),
(67741,CONVERT(0x45676720426174746572 USING utf8mb4)),
(96731,CONVERT(0x4d6978656420456767 USING utf8mb4));
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc031_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc031_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC031 item identity/dependency mismatch'; END IF;
 IF NOT EXISTS(SELECT 1 FROM items WHERE id=17906 AND itemclass=1 AND bagtype=14 AND bagslots=10) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC031 mixing bowl dependency mismatch'; END IF;
 IF already_present<>4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC031 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc031_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC031 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc031_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC031 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc031_recipes q ON q.id=r.recipe_id LEFT JOIN rrc031_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC031 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc031_recipes q ON q.id=r.recipe_id)<>17 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC031 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc031_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC031 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc031_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc031_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-4 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-17 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC031 rollback count mismatch'; END IF;
 DROP TEMPORARY TABLE rrc031_entries;
 DROP TEMPORARY TABLE rrc031_recipes;
 DROP TEMPORARY TABLE rrc031_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC031' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
