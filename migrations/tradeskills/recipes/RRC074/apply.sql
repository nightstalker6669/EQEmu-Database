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
 CREATE TEMPORARY TABLE rrc074_parents LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc074_parent_entries LIKE tradeskill_recipe_entries;
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
INSERT INTO rrc074_parents (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(10174,CONVERT(0x4d6167692052756e65202862657a6129 USING utf8mb4),58,0,0,1,0,CONVERT(0x43726561746564206279206a6f6c69676172696f USING utf8mb4),0,0,0,1,-1,-1,NULL,NULL),
(10175,CONVERT(0x4d6167692052756e65202862657a6129 USING utf8mb4),58,0,0,1,0,CONVERT(0x43726561746564206279206a6f6c69676172696f USING utf8mb4),0,0,0,1,-1,-1,NULL,NULL),
(10176,CONVERT(0x4d6167692052756e65202862657a6129 USING utf8mb4),58,0,0,1,0,CONVERT(0x43726561746564206279206a6f6c69676172696f USING utf8mb4),0,0,0,1,-1,-1,NULL,NULL),
(10177,CONVERT(0x4d6167692052756e65202862657a6129 USING utf8mb4),58,0,0,1,0,CONVERT(0x43726561746564206279206a6f6c69676172696f USING utf8mb4),0,0,0,1,-1,-1,NULL,NULL);
INSERT INTO rrc074_parent_entries (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(4699,10174,6350,0,0,1,1,0),
(4700,10174,10025,0,0,1,1,0),
(4701,10174,13051,1,0,1,1,0),
(4702,10174,13063,0,0,1,1,0),
(4703,10174,16539,0,0,1,1,0),
(4705,10174,15915,1,0,0,0,0),
(4706,10174,17504,0,0,0,0,1),
(4707,10175,6351,0,0,1,1,0),
(4708,10175,10025,0,0,1,1,0),
(4709,10175,13051,1,0,1,1,0),
(4710,10175,13063,0,0,1,1,0),
(4711,10175,16539,0,0,1,1,0),
(4713,10175,15915,1,0,0,0,0),
(4714,10175,17504,0,0,0,0,1),
(4715,10176,6352,0,0,1,1,0),
(4716,10176,10025,0,0,1,1,0),
(4717,10176,13051,1,0,1,1,0),
(4718,10176,13063,0,0,1,1,0),
(4719,10176,16539,0,0,1,1,0),
(4721,10176,15915,1,0,0,0,0),
(4722,10176,17504,0,0,0,0,1),
(4723,10177,6941,0,0,1,1,0),
(4724,10177,10025,0,0,1,1,0),
(4725,10177,13051,1,0,1,1,0),
(4726,10177,13063,0,0,1,1,0),
(4727,10177,16539,0,0,1,1,0),
(4729,10177,15915,1,0,0,0,0),
(4730,10177,17504,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF EXISTS(SELECT 1 FROM rrc074_parents e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 old variant drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc074_parent_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc074_parents p ON p.id=r.recipe_id)<>28 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 old variant entries drift'; END IF;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc074_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc074_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=17504 AND itemclass=1 AND bagtype=29 AND bagslots=6 AND bagsize=4 AND classes=65535)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 Concordance mismatch'; END IF; IF (SELECT COUNT(*) FROM items WHERE (id=15915 AND size=0 AND stackable=1 AND maxcharges=0) OR (id=7350 AND size=1 AND stackable=0 AND maxcharges=0) OR (id=16539 AND size=1 AND stackable=0 AND maxcharges=0) OR (id=13063 AND size=0 AND stackable=1 AND maxcharges=0) OR (id=13051 AND size=0 AND stackable=1 AND maxcharges=0) OR (id=10025 AND size=0 AND stackable=1 AND maxcharges=0))<>6 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 input/output semantics mismatch'; END IF;
 IF already_present NOT IN (0,1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 partial batch or ID collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r JOIN rrc074_recipes e ON r.tradeskill=e.tradeskill AND r.name=e.name WHERE r.id<>e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 existing recipe-name collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc074_entries e ON r.item_id=e.item_id JOIN rrc074_recipes q ON e.recipe_id=q.id WHERE e.successcount>e.componentcount AND e.iscontainer=0 AND r.successcount>r.componentcount AND r.iscontainer=0 AND r.recipe_id<>e.recipe_id AND NOT(e.item_id=15915 AND r.recipe_id IN (10174,10175,10176,10177))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 existing output recipe collision'; END IF;
 IF already_present=0 THEN
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc074_recipes e ON r.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 orphan target entries collision'; END IF;
 INSERT INTO tradeskill_recipe (id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled) SELECT id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled FROM rrc074_recipes;
 INSERT INTO tradeskill_recipe_entries (recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer) SELECT recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer FROM rrc074_entries;
 END IF;
 IF EXISTS(SELECT 1 FROM rrc074_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc074_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc074_recipes q ON q.id=r.recipe_id LEFT JOIN rrc074_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc074_recipes q ON q.id=r.recipe_id)<>7 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 target entry multiplicity mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before+IF(already_present=0,1,0) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before+IF(already_present=0,7,0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 unexpected table row-count delta'; END IF;
 IF EXISTS(SELECT 1 FROM rrc074_parents e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 old variant drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc074_parent_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc074_parents p ON p.id=r.recipe_id)<>28 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC074 old variant entries drift'; END IF;
 DROP TEMPORARY TABLE rrc074_parents;
 DROP TEMPORARY TABLE rrc074_parent_entries;
 DROP TEMPORARY TABLE rrc074_entries;
 DROP TEMPORARY TABLE rrc074_recipes;
 DROP TEMPORARY TABLE rrc074_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC074' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
