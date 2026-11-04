-- RRC044: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC044 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC044 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC044 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC044 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc044_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc044_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc044_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc044_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3092662,CONVERT(0x4461726b2052756d USING utf8mb4),65,0,123,0,0,CONVERT(0x5442533b20455154432061727469636c653430393b2042726577696e673b205252433034342e USING utf8mb4),0,0,0,1,13,-1,NULL,NULL),
(3092663,CONVERT(0x46726565746964652050756e6368 USING utf8mb4),65,0,255,0,0,CONVERT(0x5442533b20455154432061727469636c653430393b2042726577696e673b205252433034342e USING utf8mb4),0,0,0,1,13,-1,NULL,NULL),
(3092664,CONVERT(0x46726565746964652052756d USING utf8mb4),65,0,150,0,0,CONVERT(0x5442533b20455154432061727469636c653430393b2042726577696e673b205252433034342e USING utf8mb4),0,0,0,1,13,-1,NULL,NULL),
(3092665,CONVERT(0x47726f6767 USING utf8mb4),65,0,30,0,0,CONVERT(0x5442533b20455154432061727469636c653430393b2042726577696e673b205252433034342e USING utf8mb4),0,0,0,1,13,-1,NULL,NULL),
(3092666,CONVERT(0x4c696768742052756d USING utf8mb4),65,0,136,0,0,CONVERT(0x5442533b20455154432061727469636c653430393b2042726577696e673b205252433034342e USING utf8mb4),0,0,0,1,13,-1,NULL,NULL),
(3092667,CONVERT(0x526f746775742052756d USING utf8mb4),65,0,110,0,0,CONVERT(0x5442533b20455154432061727469636c653430393b2042726577696e673b205252433034342e USING utf8mb4),0,0,0,1,13,-1,NULL,NULL),
(3092668,CONVERT(0x5370696365642052756d USING utf8mb4),65,0,136,0,0,CONVERT(0x5442533b20455154432061727469636c653430393b2042726577696e673b205252433034342e USING utf8mb4),0,0,0,1,13,-1,NULL,NULL);
INSERT INTO rrc044_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3092662,33636,1,0,0,0,0),
(3092662,16580,1,1,1,0,0),
(3092662,33642,0,0,1,1,0),
(3092662,16596,0,0,1,1,0),
(3092662,33633,1,0,0,0,0),
(3092662,19,0,0,0,0,1),
(3092663,33640,1,0,0,0,0),
(3092663,33638,0,0,1,1,0),
(3092663,33644,0,0,2,2,0),
(3092663,45584,0,0,2,2,0),
(3092663,32049,0,0,2,2,0),
(3092663,19,0,0,0,0,1),
(3092664,33638,1,0,0,0,0),
(3092664,16580,1,1,1,0,0),
(3092664,33633,0,0,1,1,0),
(3092664,33632,0,0,1,1,0),
(3092664,19,0,0,0,0,1),
(3092665,33639,1,0,0,0,0),
(3092665,33634,0,0,1,1,0),
(3092665,13006,0,0,3,3,0),
(3092665,19,0,0,0,0,1),
(3092666,33635,1,0,0,0,0),
(3092666,16580,1,1,1,0,0),
(3092666,33641,0,0,1,1,0),
(3092666,16596,0,0,1,1,0),
(3092666,33633,1,0,0,0,0),
(3092666,19,0,0,0,0,1),
(3092667,33634,1,0,0,0,0),
(3092667,33643,0,0,1,1,0),
(3092667,16580,1,1,1,0,0),
(3092667,16596,0,0,1,1,0),
(3092667,33633,1,0,0,0,0),
(3092667,19,0,0,0,0,1),
(3092668,33637,1,0,0,0,0),
(3092668,16580,1,1,1,0,0),
(3092668,33641,0,0,1,1,0),
(3092668,13425,0,0,1,1,0),
(3092668,16596,0,0,1,1,0),
(3092668,19,0,0,0,0,1);
INSERT INTO rrc044_items (`id`,`name`) VALUES
(13006,CONVERT(0x576174657220466c61736b USING utf8mb4)),
(13425,CONVERT(0x537069636573 USING utf8mb4)),
(16580,CONVERT(0x4361736b USING utf8mb4)),
(16596,CONVERT(0x5965617374 USING utf8mb4)),
(17179,CONVERT(0x506f727461626c65204472696e6b2042617272656c USING utf8mb4)),
(17521,CONVERT(0x436f6c6c61707369626c652044697374696c6c657279 USING utf8mb4)),
(17911,CONVERT(0x42726577696e672042617272656c USING utf8mb4)),
(32049,CONVERT(0x4f72616e6765 USING utf8mb4)),
(33632,CONVERT(0x537567617263616e65204a75696365 USING utf8mb4)),
(33633,CONVERT(0x44756e646572 USING utf8mb4)),
(33634,CONVERT(0x526f746775742052756d USING utf8mb4)),
(33635,CONVERT(0x4c696768742052756d USING utf8mb4)),
(33636,CONVERT(0x4461726b2052756d USING utf8mb4)),
(33637,CONVERT(0x5370696365642052756d USING utf8mb4)),
(33638,CONVERT(0x46726565746964652052756d USING utf8mb4)),
(33639,CONVERT(0x47726f6767 USING utf8mb4)),
(33640,CONVERT(0x46726565746964652050756e6368 USING utf8mb4)),
(33641,CONVERT(0x4d6f6c6173736573 USING utf8mb4)),
(33642,CONVERT(0x5365636f6e64204d6f6c6173736573 USING utf8mb4)),
(33643,CONVERT(0x426c61636b205374726170204d6f6c6173736573 USING utf8mb4)),
(33644,CONVERT(0x496365 USING utf8mb4)),
(45584,CONVERT(0x4c696d65 USING utf8mb4));
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc044_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc044_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC044 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE itemclass=1 AND bagtype=19 AND ((id=17911 AND bagslots=10) OR (id IN (17179,17521) AND bagslots=4)))<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC044 brewing container dependency mismatch'; END IF;
 IF already_present NOT IN (0,7) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC044 partial batch or ID collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r JOIN rrc044_recipes e ON r.tradeskill=e.tradeskill AND r.name=e.name WHERE r.id<>e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC044 existing recipe-name collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc044_entries e ON r.item_id=e.item_id JOIN rrc044_recipes q ON e.recipe_id=q.id WHERE e.successcount>0 AND e.componentcount=0 AND e.iscontainer=0 AND r.successcount>r.componentcount AND r.iscontainer=0 AND r.recipe_id<>e.recipe_id AND NOT((e.item_id=33633 AND e.recipe_id IN (3092662,3092666,3092667) AND r.recipe_id IN (3092662,3092666,3092667)))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC044 existing output recipe collision'; END IF;
 IF already_present=0 THEN
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc044_recipes e ON r.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC044 orphan target entries collision'; END IF;
 INSERT INTO tradeskill_recipe (id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled) SELECT id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled FROM rrc044_recipes;
 INSERT INTO tradeskill_recipe_entries (recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer) SELECT recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer FROM rrc044_entries;
 END IF;
 IF EXISTS(SELECT 1 FROM rrc044_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC044 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc044_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC044 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc044_recipes q ON q.id=r.recipe_id LEFT JOIN rrc044_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC044 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc044_recipes q ON q.id=r.recipe_id)<>39 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC044 target entry multiplicity mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before+IF(already_present=0,7,0) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before+IF(already_present=0,39,0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC044 unexpected table row-count delta'; END IF;
 DROP TEMPORARY TABLE rrc044_entries;
 DROP TEMPORARY TABLE rrc044_recipes;
 DROP TEMPORARY TABLE rrc044_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC044' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
