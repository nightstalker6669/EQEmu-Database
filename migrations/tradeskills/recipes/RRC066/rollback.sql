-- RRC066: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC066 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC066 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC066 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC066 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc066_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc066_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc066_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc066_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3093608,CONVERT(0x42697474657220466565646261636b USING utf8mb4),56,0,196,0,0,CONVERT(0x4f6f57206d61696e7461696e6564207072696d61727920666f726d756c613b205252433036362e USING utf8mb4),0,0,0,1,8,-1,NULL,NULL),
(3093609,CONVERT(0x467265657a696e6720466565646261636b USING utf8mb4),56,0,216,0,0,CONVERT(0x4f6f57206d61696e7461696e6564207072696d61727920666f726d756c613b205252433036362e USING utf8mb4),0,0,0,1,8,-1,NULL,NULL),
(3093610,CONVERT(0x56617363756c617220496e6665726e6f USING utf8mb4),56,0,347,0,0,CONVERT(0x4f6f57206d61696e7461696e6564207072696d61727920666f726d756c613b205252433036362e USING utf8mb4),0,0,0,1,8,-1,NULL,NULL);
INSERT INTO rrc066_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3093608,72616,2,0,0,0,0),
(3093608,24076,0,0,2,2,0),
(3093608,55825,0,0,1,1,0),
(3093608,55754,0,0,1,1,0),
(3093608,72073,0,0,1,1,0),
(3093608,12,0,0,0,0,1),
(3093609,72617,2,0,0,0,0),
(3093609,24076,0,0,2,2,0),
(3093609,55825,0,0,1,1,0),
(3093609,55754,0,0,1,1,0),
(3093609,72083,0,0,1,1,0),
(3093609,12,0,0,0,0,1),
(3093610,72610,2,0,0,0,0),
(3093610,72070,0,0,1,1,0),
(3093610,55814,0,0,1,1,0),
(3093610,16967,0,0,2,2,0),
(3093610,55779,0,0,1,1,0),
(3093610,12,0,0,0,0,1);
INSERT INTO rrc066_items (`id`,`name`) VALUES
(16967,CONVERT(0x5365616c656420506f69736f6e205669616c USING utf8mb4)),
(17139,CONVERT(0x4d6172626c65204d6f7274617220616e6420506573746c65 USING utf8mb4)),
(17190,CONVERT(0x436f6c6c61707369626c65204d6f7274617220616e6420506573746c65 USING utf8mb4)),
(17904,CONVERT(0x4d6f7274617220616e6420506573746c65 USING utf8mb4)),
(24076,CONVERT(0x416476616e63656420506f69736f6e205669616c USING utf8mb4)),
(55754,CONVERT(0x4368696d657261204c696f6e277320457965 USING utf8mb4)),
(55779,CONVERT(0x53696e67656420507972696c656e20546f6e677565 USING utf8mb4)),
(55814,CONVERT(0x4e6f63205461696c USING utf8mb4)),
(55825,CONVERT(0x426c6f6f642d46696c6c656420416e65756b204865617274 USING utf8mb4)),
(72070,CONVERT(0x4368696d65726120506f69736f6e205361636b USING utf8mb4)),
(72073,CONVERT(0x47656c696472616e20426c6f6f64 USING utf8mb4)),
(72083,CONVERT(0x47656c696472616e20486561727420426c6f6f64 USING utf8mb4)),
(72610,CONVERT(0x56617363756c617220496e6665726e6f USING utf8mb4)),
(72616,CONVERT(0x42697474657220466565646261636b USING utf8mb4)),
(72617,CONVERT(0x467265657a696e6720466565646261636b USING utf8mb4));
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc066_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc066_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC066 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE itemclass=1 AND bagtype=12 AND ((id IN(17904,17190) AND bagslots=6) OR(id=17139 AND bagslots=10)))<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC066 native mortar mismatch'; END IF;
 IF already_present<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC066 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc066_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC066 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc066_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC066 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc066_recipes q ON q.id=r.recipe_id LEFT JOIN rrc066_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC066 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc066_recipes q ON q.id=r.recipe_id)<>18 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC066 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc066_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC066 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc066_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc066_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-3 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-18 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC066 rollback count mismatch'; END IF;
 DROP TEMPORARY TABLE rrc066_entries;
 DROP TEMPORARY TABLE rrc066_recipes;
 DROP TEMPORARY TABLE rrc066_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC066' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
