-- RRC058: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC058 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC058 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC058 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC058 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc058_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc058_parents LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc058_parent_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc058_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc058_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc058_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3093530,CONVERT(0x427265776d6173746572277320436f6d706f6e656e74204261672028457373656e636529 USING utf8mb4),65,0,0,1,0,CONVERT(0x566f41204361727279616c6c20736f757263652076617269616e74733b2063616e6f6e6963616c20436f6d706f6e656e7442616720766965773b205252433035382e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3093531,CONVERT(0x44656e6d6f74686572277320436f6d706f6e656e742042616720285361746368656c29 USING utf8mb4),60,0,0,1,0,CONVERT(0x566f41204361727279616c6c20736f757263652076617269616e74733b2063616e6f6e6963616c20436f6d706f6e656e7442616720766965773b205252433035382e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3093532,CONVERT(0x44656e6d6f74686572277320436f6d706f6e656e74204261672028457373656e636529 USING utf8mb4),60,0,0,1,0,CONVERT(0x566f41204361727279616c6c20736f757263652076617269616e74733b2063616e6f6e6963616c20436f6d706f6e656e7442616720766965773b205252433035382e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL);
INSERT INTO rrc058_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3093530,67636,1,0,0,0,0),
(3093530,96972,0,0,1,1,0),
(3093530,96963,1,0,0,0,0),
(3093530,19,0,0,0,0,1),
(3093531,67635,1,0,0,0,0),
(3093531,96960,0,0,1,1,0),
(3093531,96962,1,0,0,0,0),
(3093531,15,0,0,0,0,1),
(3093532,67635,1,0,0,0,0),
(3093532,96972,0,0,1,1,0),
(3093532,96962,1,0,0,0,0),
(3093532,15,0,0,0,0,1);
INSERT INTO rrc058_items (`id`,`name`) VALUES
(17911,CONVERT(0x42726577696e672042617272656c USING utf8mb4)),
(54256,CONVERT(0x4f76656e USING utf8mb4)),
(67635,CONVERT(0x44656e6d6f74686572277320436f6d706f6e656e7420426167 USING utf8mb4)),
(67636,CONVERT(0x427265776d6173746572277320436f6d706f6e656e7420426167 USING utf8mb4)),
(95211,CONVERT(0x426567696e6e65722042616b65722043617272792d416c6c USING utf8mb4)),
(95212,CONVERT(0x41707072656e746963652042616b65722043617272792d416c6c USING utf8mb4)),
(95213,CONVERT(0x46726573686d616e2042616b65722043617272792d416c6c USING utf8mb4)),
(95214,CONVERT(0x4a6f75726e65796d616e2042616b65722043617272792d416c6c USING utf8mb4)),
(95215,CONVERT(0x4578706572742042616b65722043617272792d416c6c USING utf8mb4)),
(95216,CONVERT(0x4d61737465722042616b65722043617272792d416c6c USING utf8mb4)),
(95217,CONVERT(0x426567696e6e6572204272657765722043617272792d416c6c USING utf8mb4)),
(95218,CONVERT(0x41707072656e74696365204272657765722043617272792d416c6c USING utf8mb4)),
(95219,CONVERT(0x46726573686d616e204272657765722043617272792d416c6c USING utf8mb4)),
(95220,CONVERT(0x4a6f75726e65796d616e204272657765722043617272792d416c6c USING utf8mb4)),
(95221,CONVERT(0x457870657274204272657765722043617272792d416c6c USING utf8mb4)),
(95222,CONVERT(0x4d6173746572204272657765722043617272792d416c6c USING utf8mb4)),
(96960,CONVERT(0x4172746973616e205361746368656c USING utf8mb4)),
(96962,CONVERT(0x44656e6d6f7468657227732043617272792d416c6c USING utf8mb4)),
(96963,CONVERT(0x427265776d617374657227732043617272792d416c6c USING utf8mb4)),
(96972,CONVERT(0x4172746973616e20457373656e6365 USING utf8mb4));
INSERT INTO rrc058_parents (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3093251,CONVERT(0x427265776d6173746572277320436f6d706f6e656e7420426167 USING utf8mb4),65,0,0,1,0,CONVERT(0x536f442d55462d486f542d566f413b207072696d6172792042726577696e673b205252433035342e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL);
INSERT INTO rrc058_parent_entries (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(30419829,3093251,67636,1,0,0,0,0),
(30419830,3093251,96960,0,0,1,1,0),
(30419831,3093251,96963,1,0,0,0,0),
(30419832,3093251,19,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF EXISTS(SELECT 1 FROM rrc058_parents e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC058 existing BrewSatchel peer changed'; END IF;
 IF EXISTS(SELECT 1 FROM rrc058_parent_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc058_parents p ON p.id=r.recipe_id)<>4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC058 existing BrewSatchel entries changed'; END IF;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc058_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc058_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC058 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE itemclass=1 AND bagslots=10 AND ((id=54256 AND bagtype=15) OR (id=17911 AND bagtype=19)))<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC058 oven/brew container mismatch'; END IF; IF (SELECT COUNT(*) FROM items WHERE id IN (95211,95212,95213,95214,95215,95216,96962) AND loregroup=95211)<>7 OR (SELECT COUNT(*) FROM items WHERE id IN (95217,95218,95219,95220,95221,95222,96963) AND loregroup=95217)<>7 OR (SELECT COUNT(*) FROM items WHERE id IN (67635,67636) AND itemclass=1 AND bagtype=58 AND bagslots=24 AND loregroup=-1)<>2 OR (SELECT COUNT(*) FROM items WHERE id IN (96962,96963) AND itemclass=1 AND bagtype=1 AND bagslots=12)<>2 OR (SELECT COUNT(*) FROM items WHERE id=96960 AND itemclass=1 AND bagtype=1 AND bagslots=12)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC058 carryall lore/capacity dependency mismatch'; END IF;
 IF already_present NOT IN (0,3) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC058 partial batch or ID collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r JOIN rrc058_recipes e ON r.tradeskill=e.tradeskill AND r.name=e.name WHERE r.id<>e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC058 existing recipe-name collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc058_entries e ON r.item_id=e.item_id JOIN rrc058_recipes q ON e.recipe_id=q.id WHERE e.successcount>0 AND e.componentcount=0 AND e.iscontainer=0 AND r.successcount>r.componentcount AND r.iscontainer=0 AND r.recipe_id<>e.recipe_id AND NOT((e.item_id=67635 AND e.recipe_id IN (3093531,3093532) AND r.recipe_id IN (3093531,3093532)) OR (e.item_id=96962 AND e.recipe_id IN (3093531,3093532) AND r.recipe_id IN (3093531,3093532)) OR (e.item_id=67636 AND e.recipe_id IN (3093530) AND r.recipe_id IN (3093251)) OR (e.item_id=96963 AND e.recipe_id IN (3093530) AND r.recipe_id IN (3093251)))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC058 existing output recipe collision'; END IF;
 IF already_present=0 THEN
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc058_recipes e ON r.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC058 orphan target entries collision'; END IF;
 INSERT INTO tradeskill_recipe (id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled) SELECT id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled FROM rrc058_recipes;
 INSERT INTO tradeskill_recipe_entries (recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer) SELECT recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer FROM rrc058_entries;
 END IF;
 IF EXISTS(SELECT 1 FROM rrc058_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC058 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc058_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC058 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc058_recipes q ON q.id=r.recipe_id LEFT JOIN rrc058_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC058 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc058_recipes q ON q.id=r.recipe_id)<>12 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC058 target entry multiplicity mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before+IF(already_present=0,3,0) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before+IF(already_present=0,12,0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC058 unexpected table row-count delta'; END IF;
 IF EXISTS(SELECT 1 FROM rrc058_parents e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC058 existing BrewSatchel peer changed'; END IF;
 IF EXISTS(SELECT 1 FROM rrc058_parent_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc058_parents p ON p.id=r.recipe_id)<>4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC058 existing BrewSatchel entries changed'; END IF;
 DROP TEMPORARY TABLE rrc058_parents;
 DROP TEMPORARY TABLE rrc058_parent_entries;
 DROP TEMPORARY TABLE rrc058_entries;
 DROP TEMPORARY TABLE rrc058_recipes;
 DROP TEMPORARY TABLE rrc058_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC058' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
