-- RRC004: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC004 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC004 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC004 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC004 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc004_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc004_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc004_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc004_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3091094,CONVERT(0x434c415353203920537465656c2046656172626f6e65204172726f7720284d656469756d2047726f6f766529 USING utf8mb4),64,0,308,0,0,CONVERT(0x526f463b20455154432061727469636c653536323b204665617220506f776572656420466c65746368696e673b205252433030342e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091095,CONVERT(0x434c415353203920537465656c2046656172626f6e65204172726f772028536d616c6c2047726f6f766529 USING utf8mb4),64,0,308,0,0,CONVERT(0x526f463b20455154432061727469636c653536323b204665617220506f776572656420466c65746368696e673b205252433030342e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091096,CONVERT(0x434c415353203920537465656c2046656172626f6e65204172726f7720284c617267652047726f6f766529 USING utf8mb4),64,0,308,0,0,CONVERT(0x526f463b20455154432061727469636c653536323b204665617220506f776572656420466c65746368696e673b205252433030342e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091097,CONVERT(0x434c415353203920537465656c205368617264706f696e74204172726f7720284c617267652047726f6f766529 USING utf8mb4),64,0,322,0,0,CONVERT(0x526f463b20455154432061727469636c653536323b204665617220506f776572656420466c65746368696e673b205252433030342e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091098,CONVERT(0x434c415353203920537465656c205368617264706f696e74204172726f7720284d656469756d2047726f6f766529 USING utf8mb4),64,0,322,0,0,CONVERT(0x526f463b20455154432061727469636c653536323b204665617220506f776572656420466c65746368696e673b205252433030342e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091099,CONVERT(0x434c415353203920537465656c205368617264706f696e74204172726f772028536d616c6c2047726f6f766529 USING utf8mb4),64,0,322,0,0,CONVERT(0x526f463b20455154432061727469636c653536323b204665617220506f776572656420466c65746368696e673b205252433030342e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091100,CONVERT(0x546572726f722043726f7373626f77 USING utf8mb4),64,0,375,0,0,CONVERT(0x526f463b20455154432061727469636c653536323b204665617220506f776572656420466c65746368696e673b205252433030342e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091101,CONVERT(0x546572726f722043726f7373626f7720426f6c7473 USING utf8mb4),64,0,335,0,0,CONVERT(0x526f463b20455154432061727469636c653536323b204665617220506f776572656420466c65746368696e673b205252433030342e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL);
INSERT INTO rrc004_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3091094,135316,10,0,0,0,0),
(3091094,135313,0,0,1,1,0),
(3091094,8063,0,0,1,1,0),
(3091094,8051,0,0,1,1,0),
(3091094,135312,0,0,1,1,0),
(3091094,18,0,0,0,0,1),
(3091095,135317,10,0,0,0,0),
(3091095,135313,0,0,1,1,0),
(3091095,8063,0,0,1,1,0),
(3091095,8052,0,0,1,1,0),
(3091095,135312,0,0,1,1,0),
(3091095,18,0,0,0,0,1),
(3091096,135315,10,0,0,0,0),
(3091096,135313,0,0,1,1,0),
(3091096,8063,0,0,1,1,0),
(3091096,8050,0,0,1,1,0),
(3091096,135312,0,0,1,1,0),
(3091096,18,0,0,0,0,1),
(3091097,135318,10,0,0,0,0),
(3091097,8063,0,0,1,1,0),
(3091097,135314,0,0,1,1,0),
(3091097,8050,0,0,1,1,0),
(3091097,135312,0,0,1,1,0),
(3091097,18,0,0,0,0,1),
(3091098,135319,10,0,0,0,0),
(3091098,8063,0,0,1,1,0),
(3091098,135314,0,0,1,1,0),
(3091098,8051,0,0,1,1,0),
(3091098,135312,0,0,1,1,0),
(3091098,18,0,0,0,0,1),
(3091099,135320,10,0,0,0,0),
(3091099,8063,0,0,1,1,0),
(3091099,135314,0,0,1,1,0),
(3091099,8052,0,0,1,1,0),
(3091099,135312,0,0,1,1,0),
(3091099,18,0,0,0,0,1),
(3091100,135321,1,0,0,0,0),
(3091100,8084,0,0,1,1,0),
(3091100,45173,0,0,1,1,0),
(3091100,16858,0,0,1,1,0),
(3091100,76322,0,0,5,5,0),
(3091100,8086,1,1,1,0,0),
(3091100,8090,0,0,1,1,0),
(3091100,18,0,0,0,0,1),
(3091101,135322,10,0,0,0,0),
(3091101,8063,0,0,1,1,0),
(3091101,135314,0,0,1,1,0),
(3091101,8050,0,0,1,1,0),
(3091101,76322,0,0,1,1,0),
(3091101,135312,0,0,1,1,0),
(3091101,18,0,0,0,0,1);
INSERT INTO rrc004_items (`id`,`name`) VALUES
(8050,CONVERT(0x4c617267652047726f6f7665204e6f636b73 USING utf8mb4)),
(8051,CONVERT(0x4d656469756d2047726f6f7665204e6f636b73 USING utf8mb4)),
(8052,CONVERT(0x536d616c6c2047726f6f7665204e6f636b73 USING utf8mb4)),
(8063,CONVERT(0x42756e646c656420537465656c204172726f7720536861667473 USING utf8mb4)),
(8084,CONVERT(0x4461726b776f6f6420426f77205374616666 USING utf8mb4)),
(8086,CONVERT(0x506c616e696e6720546f6f6c USING utf8mb4)),
(8090,CONVERT(0x53696c6b20537472696e67 USING utf8mb4)),
(16858,CONVERT(0x4765617273 USING utf8mb4)),
(17128,CONVERT(0x466569726044616c20466c65746368696e67204b6974 USING utf8mb4)),
(45173,CONVERT(0x457863657074696f6e616c2053616e647061706572 USING utf8mb4)),
(76322,CONVERT(0x506c616e617220456e65726779205368617264 USING utf8mb4)),
(135312,CONVERT(0x5461696e7465642046656174686572 USING utf8mb4)),
(135313,CONVERT(0x416e696d616c2046656172626f6e65 USING utf8mb4)),
(135314,CONVERT(0x467261637475726564205368617264 USING utf8mb4)),
(135315,CONVERT(0x434c415353203920537465656c2046656172626f6e65204172726f77 USING utf8mb4)),
(135316,CONVERT(0x434c415353203920537465656c2046656172626f6e65204172726f77 USING utf8mb4)),
(135317,CONVERT(0x434c415353203920537465656c2046656172626f6e65204172726f77 USING utf8mb4)),
(135318,CONVERT(0x434c415353203920537465656c205368617264706f696e74204172726f77 USING utf8mb4)),
(135319,CONVERT(0x434c415353203920537465656c205368617264706f696e74204172726f77 USING utf8mb4)),
(135320,CONVERT(0x434c415353203920537465656c205368617264706f696e74204172726f77 USING utf8mb4)),
(135321,CONVERT(0x546572726f722043726f7373626f77 USING utf8mb4)),
(135322,CONVERT(0x546572726f722043726f7373626f7720426f6c7473 USING utf8mb4));
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc004_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc004_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC004 item identity/dependency mismatch'; END IF;
 IF NOT EXISTS(SELECT 1 FROM items WHERE id=17128 AND itemclass=1 AND bagtype=18 AND bagslots=10) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC004 ordinary10-slot Fletching Kit dependency mismatch'; END IF;
 IF already_present NOT IN (0,8) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC004 partial batch or ID collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r JOIN rrc004_recipes e ON r.tradeskill=e.tradeskill AND r.name=e.name WHERE r.id<>e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC004 existing recipe-name collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc004_entries e ON r.item_id=e.item_id JOIN rrc004_recipes q ON e.recipe_id=q.id WHERE e.successcount>0 AND e.componentcount=0 AND e.iscontainer=0 AND r.successcount>0 AND r.iscontainer=0 AND r.recipe_id<>e.recipe_id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC004 existing output recipe collision'; END IF;
 IF already_present=0 THEN
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc004_recipes e ON r.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC004 orphan target entries collision'; END IF;
 INSERT INTO tradeskill_recipe (id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled) SELECT id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled FROM rrc004_recipes;
 INSERT INTO tradeskill_recipe_entries (recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer) SELECT recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer FROM rrc004_entries;
 END IF;
 IF EXISTS(SELECT 1 FROM rrc004_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC004 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc004_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC004 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc004_recipes q ON q.id=r.recipe_id LEFT JOIN rrc004_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC004 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc004_recipes q ON q.id=r.recipe_id)<>51 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC004 target entry multiplicity mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before+IF(already_present=0,8,0) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before+IF(already_present=0,51,0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC004 unexpected table row-count delta'; END IF;
 DROP TEMPORARY TABLE rrc004_entries;
 DROP TEMPORARY TABLE rrc004_recipes;
 DROP TEMPORARY TABLE rrc004_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC004' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
