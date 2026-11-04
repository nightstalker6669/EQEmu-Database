-- RRC101: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC101 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC101 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC101 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC101 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc101_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc101_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc101_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc101_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3094018,CONVERT(0x4368756d USING utf8mb4),55,0,75,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204368756d207265636f6e737472756374696f6e3b206e617469766533333634383b205252433130312e USING utf8mb4),0,0,0,1,13,-1,NULL,NULL);
INSERT INTO rrc101_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3094018,33648,11,0,0,0,0),
(3094018,32057,0,0,1,1,0),
(3094018,9753,1,1,1,0,0),
(3094018,13019,0,0,1,1,0),
(3094018,32062,0,0,1,1,0),
(3094018,32058,0,0,1,1,0),
(3094018,32063,0,0,1,1,0),
(3094018,17048,0,0,0,0,1),
(3094018,17163,0,0,0,0,1);
INSERT INTO rrc101_items (`id`,`name`) VALUES
(9753,CONVERT(0x46696c6c6574696e67204b6e696665 USING utf8mb4)),
(13019,CONVERT(0x46726573682046697368 USING utf8mb4)),
(17048,CONVERT(0x5461636b6c6520426f78 USING utf8mb4)),
(17163,CONVERT(0x436f6c6c61707369626c65205461636b6c6520426f78 USING utf8mb4)),
(32057,CONVERT(0x42617272656e2043726f616b6572 USING utf8mb4)),
(32058,CONVERT(0x5365617065726368 USING utf8mb4)),
(32062,CONVERT(0x48657272696e67 USING utf8mb4)),
(32063,CONVERT(0x5370726174 USING utf8mb4)),
(33648,CONVERT(0x4368756d USING utf8mb4));
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc101_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc101_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC101 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=9753 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC101 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=13019 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 14 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC101 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=17048 AND `size` <=> 2 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 46 AND `bagslots` <=> 6 AND `bagsize` <=> 2 AND `classes` <=> 65535)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC101 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=17163 AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 46 AND `bagslots` <=> 6 AND `bagsize` <=> 3 AND `classes` <=> 65535)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC101 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=32057 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC101 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=32058 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC101 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=32062 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC101 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=32063 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC101 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=33648 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 14 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC101 native item semantics mismatch'; END IF;
 IF already_present NOT IN (0,1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC101 partial batch or ID collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r JOIN rrc101_recipes e ON r.tradeskill=e.tradeskill AND r.name=e.name WHERE r.id<>e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC101 existing recipe-name collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc101_entries e ON r.item_id=e.item_id JOIN rrc101_recipes q ON e.recipe_id=q.id WHERE e.successcount>e.componentcount AND e.iscontainer=0 AND r.successcount>r.componentcount AND r.iscontainer=0 AND r.recipe_id<>e.recipe_id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC101 existing output recipe collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>3094018 AND (SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=6 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=32057 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=9753 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=13019 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=32062 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=32058 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=32063 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries k WHERE k.recipe_id=r.id AND k.iscontainer=1 AND k.item_id IN(17048,17163,46))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC101 complete input/effective box collision'; END IF;
 IF already_present=0 THEN
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc101_recipes e ON r.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC101 orphan target entries collision'; END IF;
 INSERT INTO tradeskill_recipe (id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled) SELECT id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled FROM rrc101_recipes;
 INSERT INTO tradeskill_recipe_entries (recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer) SELECT recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer FROM rrc101_entries;
 END IF;
 IF EXISTS(SELECT 1 FROM rrc101_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC101 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc101_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC101 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc101_recipes q ON q.id=r.recipe_id LEFT JOIN rrc101_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC101 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc101_recipes q ON q.id=r.recipe_id)<>9 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC101 target entry multiplicity mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before+IF(already_present=0,1,0) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before+IF(already_present=0,9,0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC101 unexpected table row-count delta'; END IF;
 DROP TEMPORARY TABLE rrc101_entries;
 DROP TEMPORARY TABLE rrc101_recipes;
 DROP TEMPORARY TABLE rrc101_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC101' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
