-- RRC005: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC005 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC005 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC005 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC005 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc005_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc005_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc005_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc005_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3091102,CONVERT(0x476f6f2047756e USING utf8mb4),57,0,368,0,0,CONVERT(0x526f463b20455154432061727469636c653536363b2046756e20776974682046656172204d616368696e65733b205252433030352e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091103,CONVERT(0x476f6f2047756e20416d6d756e6974696f6e USING utf8mb4),57,0,168,0,0,CONVERT(0x526f463b20455154432061727469636c653536363b2046756e20776974682046656172204d616368696e65733b205252433030352e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091104,CONVERT(0x496e7374616e7420426576657261676520427265776572 USING utf8mb4),57,0,335,0,0,CONVERT(0x526f463b20455154432061727469636c653536363b2046756e20776974682046656172204d616368696e65733b205252433030352e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091105,CONVERT(0x506c616e617220446973746f7274696f6e20446576696365 USING utf8mb4),57,0,395,0,0,CONVERT(0x526f463b20455154432061727469636c653536363b2046756e20776974682046656172204d616368696e65733b205252433030352e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091106,CONVERT(0x537465616d4a6574205061636b USING utf8mb4),57,0,402,0,0,CONVERT(0x526f463b20455154432061727469636c653536363b2046756e20776974682046656172204d616368696e65733b205252433030352e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091107,CONVERT(0x546572726f7220537465616d626c616465 USING utf8mb4),57,0,428,0,0,CONVERT(0x526f463b20455154432061727469636c653536363b2046756e20776974682046656172204d616368696e65733b205252433030352e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091108,CONVERT(0x5469636b20546f636b20426c61737420426f6d62 USING utf8mb4),57,0,335,0,0,CONVERT(0x526f463b20455154432061727469636c653536363b2046756e20776974682046656172204d616368696e65733b205252433030352e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091109,CONVERT(0x5469636b20546f636b204665617220426f6d62 USING utf8mb4),57,0,335,0,0,CONVERT(0x526f463b20455154432061727469636c653536363b2046756e20776974682046656172204d616368696e65733b205252433030352e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091110,CONVERT(0x5469636b20546f636b20537469636b7920426f6d62 USING utf8mb4),57,0,335,0,0,CONVERT(0x526f463b20455154432061727469636c653536363b2046756e20776974682046656172204d616368696e65733b205252433030352e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL);
INSERT INTO rrc005_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3091102,76435,1,0,0,0,0),
(3091102,16598,0,0,1,1,0),
(3091102,16858,0,0,1,1,0),
(3091102,10481,0,0,1,1,0),
(3091102,72016,0,0,1,1,0),
(3091102,16850,0,0,1,1,0),
(3091102,76322,0,0,1,1,0),
(3091102,72046,0,0,1,1,0),
(3091102,9194,0,0,1,1,0),
(3091102,10,0,0,0,0,1),
(3091103,76436,25,0,0,0,0),
(3091103,16598,0,0,1,1,0),
(3091103,76336,0,0,3,3,0),
(3091103,13006,0,0,3,3,0),
(3091103,10,0,0,0,0,1),
(3091104,76434,1,0,0,0,0),
(3091104,63244,0,0,1,1,0),
(3091104,10481,0,0,3,3,0),
(3091104,72016,0,0,1,1,0),
(3091104,9181,0,0,1,1,0),
(3091104,16850,0,0,1,1,0),
(3091104,76322,0,0,1,1,0),
(3091104,72046,0,0,1,1,0),
(3091104,10,0,0,0,0,1),
(3091105,76437,1,0,0,0,0),
(3091105,7483,0,0,1,1,0),
(3091105,63244,0,0,1,1,0),
(3091105,10481,0,0,1,1,0),
(3091105,72016,0,0,1,1,0),
(3091105,16888,0,0,1,1,0),
(3091105,16850,0,0,1,1,0),
(3091105,76322,0,0,3,3,0),
(3091105,16860,0,0,1,1,0),
(3091105,10,0,0,0,0,1),
(3091106,76432,1,0,0,0,0),
(3091106,16858,0,0,1,1,0),
(3091106,63244,0,0,2,2,0),
(3091106,10481,0,0,1,1,0),
(3091106,13004,0,0,1,1,0),
(3091106,76322,0,0,1,1,0),
(3091106,16891,0,0,2,2,0),
(3091106,10,0,0,0,0,1),
(3091107,76433,1,0,0,0,0),
(3091107,7483,0,0,1,1,0),
(3091107,46979,0,0,3,3,0),
(3091107,16858,0,0,1,1,0),
(3091107,10481,0,0,1,1,0),
(3091107,16888,0,0,1,1,0),
(3091107,76322,0,0,3,3,0),
(3091107,10,0,0,0,0,1),
(3091108,76440,10,0,0,0,0),
(3091108,93664,0,0,3,3,0),
(3091108,76322,0,0,2,2,0),
(3091108,34469,0,0,3,3,0),
(3091108,10,0,0,0,0,1),
(3091109,76438,10,0,0,0,0),
(3091109,46979,0,0,1,1,0),
(3091109,93664,0,0,3,3,0),
(3091109,76322,0,0,1,1,0),
(3091109,34469,0,0,3,3,0),
(3091109,10,0,0,0,0,1),
(3091110,76439,10,0,0,0,0),
(3091110,93664,0,0,3,3,0),
(3091110,76322,0,0,1,1,0),
(3091110,76336,0,0,1,1,0),
(3091110,34469,0,0,3,3,0),
(3091110,10,0,0,0,0,1);
INSERT INTO rrc005_items (`id`,`name`) VALUES
(7483,CONVERT(0x4375726564204c65617468657220547562696e67 USING utf8mb4)),
(9181,CONVERT(0x4d616e612042617474657279202d20436c61737320536978 USING utf8mb4)),
(9194,CONVERT(0x537465656c20436173696e67 USING utf8mb4)),
(10481,CONVERT(0x48696768205175616c697479205368656574204d6574616c USING utf8mb4)),
(13004,CONVERT(0x4c61726765204c616e7465726e USING utf8mb4)),
(13006,CONVERT(0x576174657220466c61736b USING utf8mb4)),
(16598,CONVERT(0x426f74746c65 USING utf8mb4)),
(16850,CONVERT(0x4d6574616c20526f64 USING utf8mb4)),
(16858,CONVERT(0x4765617273 USING utf8mb4)),
(16860,CONVERT(0x5265666c656374697665205368617264 USING utf8mb4)),
(16888,CONVERT(0x4d6574616c2046617374656e696e67 USING utf8mb4)),
(16891,CONVERT(0x536861726b736b696e20547562696e67 USING utf8mb4)),
(17877,CONVERT(0x44656c75786520546f6f6c626f78 USING utf8mb4)),
(34469,CONVERT(0x53756c6675726f757320436f616c USING utf8mb4)),
(46979,CONVERT(0x447265616d2044757374 USING utf8mb4)),
(63244,CONVERT(0x476e6f6d697368204865617420536f75726365 USING utf8mb4)),
(72016,CONVERT(0x4d61676e6574697a656420426f6c7473 USING utf8mb4)),
(72046,CONVERT(0x537465616d2d706f776572656420506973746f6e USING utf8mb4)),
(76322,CONVERT(0x506c616e617220456e65726779205368617264 USING utf8mb4)),
(76336,CONVERT(0x506c616e617220476f6f USING utf8mb4)),
(76432,CONVERT(0x537465616d6a6574205061636b USING utf8mb4)),
(76433,CONVERT(0x546572726f7220537465616d626c616465 USING utf8mb4)),
(76434,CONVERT(0x496e7374616e7420426576657261676520427265776572 USING utf8mb4)),
(76435,CONVERT(0x476f6f2047756e USING utf8mb4)),
(76436,CONVERT(0x476f6f2047756e20416d6d756e6974696f6e USING utf8mb4)),
(76437,CONVERT(0x506c616e617220446973746f7274696f6e20446576696365 USING utf8mb4)),
(76438,CONVERT(0x5469636b20546f636b204665617220426f6d62 USING utf8mb4)),
(76439,CONVERT(0x5469636b20546f636b20537469636b7920426f6d62 USING utf8mb4)),
(76440,CONVERT(0x5469636b20546f636b20426c61737420426f6d62 USING utf8mb4)),
(93664,CONVERT(0x48696768205175616c69747920436172626f6e20506f77646572 USING utf8mb4));
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc005_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc005_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC005 item identity/dependency mismatch'; END IF;
 IF NOT EXISTS(SELECT 1 FROM items WHERE id=17877 AND itemclass=1 AND bagtype=10 AND bagslots=10) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC005 ordinary10-slot Deluxe Toolbox dependency mismatch'; END IF;
 IF already_present NOT IN (0,9) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC005 partial batch or ID collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r JOIN rrc005_recipes e ON r.tradeskill=e.tradeskill AND r.name=e.name WHERE r.id<>e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC005 existing recipe-name collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc005_entries e ON r.item_id=e.item_id JOIN rrc005_recipes q ON e.recipe_id=q.id WHERE e.successcount>0 AND e.componentcount=0 AND e.iscontainer=0 AND r.successcount>0 AND r.iscontainer=0 AND r.recipe_id<>e.recipe_id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC005 existing output recipe collision'; END IF;
 IF already_present=0 THEN
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc005_recipes e ON r.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC005 orphan target entries collision'; END IF;
 INSERT INTO tradeskill_recipe (id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled) SELECT id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled FROM rrc005_recipes;
 INSERT INTO tradeskill_recipe_entries (recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer) SELECT recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer FROM rrc005_entries;
 END IF;
 IF EXISTS(SELECT 1 FROM rrc005_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC005 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc005_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC005 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc005_recipes q ON q.id=r.recipe_id LEFT JOIN rrc005_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC005 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc005_recipes q ON q.id=r.recipe_id)<>67 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC005 target entry multiplicity mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before+IF(already_present=0,9,0) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before+IF(already_present=0,67,0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC005 unexpected table row-count delta'; END IF;
 DROP TEMPORARY TABLE rrc005_entries;
 DROP TEMPORARY TABLE rrc005_recipes;
 DROP TEMPORARY TABLE rrc005_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC005' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
