-- RRC102: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC102 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC102 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC102 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC102 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc102_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc102_parents LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc102_parent_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc102_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc102_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc102_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3094019,CONVERT(0x46697368626f6e652044617274732028477265656e2047696c6c20426f6e657329 USING utf8mb4),64,0,162,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792046697368626f6e65204461727420696e70757420726f7574653b205252433130322e USING utf8mb4),0,0,0,1,-1,-1,NULL,NULL),
(3094020,CONVERT(0x46697368626f6e6520446172747320285468756e6465722053616c6d6f6e20426f6e657329 USING utf8mb4),64,0,162,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792046697368626f6e65204461727420696e70757420726f7574653b205252433130322e USING utf8mb4),0,0,0,1,-1,-1,NULL,NULL),
(3094021,CONVERT(0x46697368626f6e6520446172747320284e696768746d61726520436963686c696420426f6e657329 USING utf8mb4),64,0,162,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792046697368626f6e65204461727420696e70757420726f7574653b205252433130322e USING utf8mb4),0,0,0,1,-1,-1,NULL,NULL);
INSERT INTO rrc102_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3094019,23578,5,0,0,0,0),
(3094019,23577,1,1,1,0,0),
(3094019,24494,0,0,1,1,0),
(3094019,17189,0,0,0,0,1),
(3094019,17762,0,0,0,0,1),
(3094019,17910,0,0,0,0,1),
(3094020,23578,5,0,0,0,0),
(3094020,23577,1,1,1,0,0),
(3094020,24495,0,0,1,1,0),
(3094020,17189,0,0,0,0,1),
(3094020,17762,0,0,0,0,1),
(3094020,17910,0,0,0,0,1),
(3094021,23578,5,0,0,0,0),
(3094021,23577,1,1,1,0,0),
(3094021,29171,0,0,1,1,0),
(3094021,17189,0,0,0,0,1),
(3094021,17762,0,0,0,0,1),
(3094021,17910,0,0,0,0,1);
INSERT INTO rrc102_items (`id`,`name`) VALUES
(17189,CONVERT(0x436f6c6c61707369626c6520466c65746368696e67204b6974 USING utf8mb4)),
(17762,CONVERT(0x506c616e617220466c65746368696e67204b6974 USING utf8mb4)),
(17910,CONVERT(0x466c65746368696e67204b6974 USING utf8mb4)),
(23577,CONVERT(0x46697368626f6e65204461727420546f6f6c USING utf8mb4)),
(23578,CONVERT(0x46697368626f6e65204461727473 USING utf8mb4)),
(24494,CONVERT(0x477265656e2047696c6c20426f6e6573 USING utf8mb4)),
(24495,CONVERT(0x5468756e6465722053616c6d6f6e20426f6e6573 USING utf8mb4)),
(29171,CONVERT(0x4e696768746d61726520436963686c696420426f6e6573 USING utf8mb4));
INSERT INTO rrc102_parents (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(7311,CONVERT(0x46697368626f6e65204461727473 USING utf8mb4),64,0,162,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7312,CONVERT(0x46697368626f6e65204461727473 USING utf8mb4),64,0,162,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7544,CONVERT(0x57686974746c65642046697368626f6e65204461727473 USING utf8mb4),64,0,182,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
INSERT INTO rrc102_parent_entries (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(69112,7311,23577,1,1,1,0,0),
(69113,7311,24497,0,0,1,1,0),
(69114,7311,23578,5,0,0,0,0),
(69117,7311,17128,0,0,0,0,1),
(69118,7311,17189,0,0,0,0,1),
(69119,7311,17762,0,0,0,0,1),
(69120,7311,17910,0,0,0,0,1),
(69121,7311,66163,0,0,0,0,1),
(69122,7312,23577,1,1,1,0,0),
(69123,7312,29173,0,0,1,1,0),
(69124,7312,23578,5,0,0,0,0),
(69127,7312,17128,0,0,0,0,1),
(69128,7312,17189,0,0,0,0,1),
(69129,7312,17762,0,0,0,0,1),
(69130,7312,17910,0,0,0,0,1),
(69131,7312,66163,0,0,0,0,1),
(71065,7544,23577,1,1,1,0,0),
(71066,7544,24496,0,0,1,1,0),
(71067,7544,23579,5,0,0,0,0),
(71070,7544,17128,0,0,0,0,1),
(71071,7544,17189,0,0,0,0,1),
(71072,7544,17762,0,0,0,0,1),
(71073,7544,17910,0,0,0,0,1),
(71074,7544,66163,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF EXISTS(SELECT 1 FROM rrc102_parents e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC102 existing dart recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc102_parent_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc102_parents p ON p.id=r.recipe_id)<>24 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC102 existing dart entries drift'; END IF;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc102_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc102_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC102 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=17189 AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC102 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=17762 AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC102 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=17910 AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC102 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=23577 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC102 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=23578 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 49629 AND `races` <=> 65535 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC102 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=24494 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC102 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=24495 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC102 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=29171 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC102 native item semantics mismatch'; END IF;
 IF already_present<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC102 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc102_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC102 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc102_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC102 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc102_recipes q ON q.id=r.recipe_id LEFT JOIN rrc102_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC102 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc102_recipes q ON q.id=r.recipe_id)<>18 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC102 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc102_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC102 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc102_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc102_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-3 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-18 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC102 rollback count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc102_parents e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC102 existing dart recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc102_parent_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc102_parents p ON p.id=r.recipe_id)<>24 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC102 existing dart entries drift'; END IF;
 DROP TEMPORARY TABLE rrc102_parents;
 DROP TEMPORARY TABLE rrc102_parent_entries;
 DROP TEMPORARY TABLE rrc102_entries;
 DROP TEMPORARY TABLE rrc102_recipes;
 DROP TEMPORARY TABLE rrc102_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC102' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
