-- RRC074: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc074_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc074_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc074_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc074_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3093628,CONVERT(0x4d6167692052756e65202842657a6129202846696e6520537465656c2044616767657229 USING utf8mb4),58,0,0,1,0,CONVERT(0x4578706c696369742046696e6520537465656c20446167676572207072696d6172792076617269616e743b20696e68657269746564206e6f6661696c2066616d696c7920656e636f64696e673b205252433037342e USING utf8mb4),0,0,0,1,-1,-1,NULL,NULL);
INSERT INTO rrc074_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3093628,15915,1,0,0,0,0),
(3093628,7350,0,0,1,1,0),
(3093628,16539,0,0,1,1,0),
(3093628,13063,0,0,1,1,0),
(3093628,13051,1,1,1,0,0),
(3093628,10025,0,0,1,1,0),
(3093628,17504,0,0,0,0,1);
INSERT INTO rrc074_items (`id`,`name`) VALUES
(7350,CONVERT(0x46696e6520537465656c20446167676572 USING utf8mb4)),
(10025,CONVERT(0x546f70617a USING utf8mb4)),
(13051,CONVERT(0x5175696c6c USING utf8mb4)),
(13063,CONVERT(0x5069656365206f662050617263686d656e74 USING utf8mb4)),
(15915,CONVERT(0x4d6167692052756e65202842657a6129 USING utf8mb4)),
(16539,CONVERT(0x48696c6c204769616e7420546f6573 USING utf8mb4)),
(17504,CONVERT(0x436f6e636f7264616e6365206f66205265736561726368 USING utf8mb4));
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc074_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc074_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=17504 AND itemclass=1 AND bagtype=29 AND bagslots=6 AND bagsize=4 AND classes=65535)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 Concordance mismatch'; END IF; IF (SELECT COUNT(*) FROM items WHERE (id=15915 AND size=0 AND stackable=1 AND maxcharges=0) OR (id=7350 AND size=1 AND stackable=0 AND maxcharges=0) OR (id=16539 AND size=1 AND stackable=0 AND maxcharges=0) OR (id=13063 AND size=0 AND stackable=1 AND maxcharges=0) OR (id=13051 AND size=0 AND stackable=1 AND maxcharges=0) OR (id=10025 AND size=0 AND stackable=1 AND maxcharges=0))<>6 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 input/output semantics mismatch'; END IF;
 IF already_present<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc074_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc074_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc074_recipes q ON q.id=r.recipe_id LEFT JOIN rrc074_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc074_recipes q ON q.id=r.recipe_id)<>7 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc074_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc074_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc074_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-1 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-7 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 rollback count mismatch'; END IF;
 DROP TEMPORARY TABLE rrc074_entries;
 DROP TEMPORARY TABLE rrc074_recipes;
 DROP TEMPORARY TABLE rrc074_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC074' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
