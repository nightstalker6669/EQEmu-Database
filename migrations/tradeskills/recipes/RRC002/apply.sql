-- RRC002: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC002 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC002 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC002 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC002 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc002_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc002_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc002_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc002_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3091020,CONVERT(0x42726577206f662074686520506c616e6573 USING utf8mb4),65,0,402,0,0,CONVERT(0x526f463b20455154432061727469636c653536313b20446976696e65204472696e6b733b205252433030322070726f76656e616e63652e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091021,CONVERT(0x43617a6963277320426c6f6f64 USING utf8mb4),65,0,448,0,0,CONVERT(0x526f463b20455154432061727469636c653536313b20446976696e65204472696e6b733b205252433030322070726f76656e616e63652e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091022,CONVERT(0x506c616e617220456e6572677920416c65 USING utf8mb4),65,0,155,0,0,CONVERT(0x526f463b20455154432061727469636c653536313b20446976696e65204472696e6b733b205252433030322070726f76656e616e63652e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091023,CONVERT(0x506c616e617220456e6572677920436f66666565 USING utf8mb4),65,0,148,0,0,CONVERT(0x526f463b20455154432061727469636c653536313b20446976696e65204472696e6b733b205252433030322070726f76656e616e63652e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091024,CONVERT(0x506c616e617220456e65726779204a75696365 USING utf8mb4),65,0,148,0,0,CONVERT(0x526f463b20455154432061727469636c653536313b20446976696e65204472696e6b733b205252433030322070726f76656e616e63652e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091025,CONVERT(0x506c616e617220456e65726779204e6f737472756d USING utf8mb4),65,0,475,0,0,CONVERT(0x526f463b20455154432061727469636c653536313b20446976696e65204472696e6b733b205252433030322070726f76656e616e63652e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091026,CONVERT(0x506c616e617220456e657267792053706972697473 USING utf8mb4),65,0,162,0,0,CONVERT(0x526f463b20455154432061727469636c653536313b20446976696e65204472696e6b733b205252433030322070726f76656e616e63652e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091027,CONVERT(0x506c616e617220456e6572677920546561 USING utf8mb4),65,0,122,0,0,CONVERT(0x526f463b20455154432061727469636c653536313b20446976696e65204472696e6b733b205252433030322070726f76656e616e63652e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091028,CONVERT(0x506c616e6172204f766572646f7365 USING utf8mb4),65,0,415,0,0,CONVERT(0x526f463b20455154432061727469636c653536313b20446976696e65204472696e6b733b205252433030322070726f76656e616e63652e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3091029,CONVERT(0x546561206f6620746865205368617264 USING utf8mb4),65,0,382,0,0,CONVERT(0x526f463b20455154432061727469636c653536313b20446976696e65204472696e6b733b205252433030322070726f76656e616e63652e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL);
INSERT INTO rrc002_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3091020,76330,1,0,0,0,0),
(3091020,15961,0,0,1,1,0),
(3091020,13046,0,0,1,1,0),
(3091020,76322,0,0,2,2,0),
(3091020,13425,0,0,1,1,0),
(3091020,58153,0,0,1,1,0),
(3091020,13006,0,0,1,1,0),
(3091020,19,0,0,0,0,1),
(3091021,76333,1,0,0,0,0),
(3091021,16598,0,0,1,1,0),
(3091021,16851,0,0,1,1,0),
(3091021,46979,0,0,2,2,0),
(3091021,13046,0,0,1,1,0),
(3091021,16592,0,0,1,1,0),
(3091021,76322,0,0,3,3,0),
(3091021,16597,0,0,1,1,0),
(3091021,19,0,0,0,0,1),
(3091022,76324,1,0,0,0,0),
(3091022,16590,0,0,1,1,0),
(3091022,16598,0,0,1,1,0),
(3091022,16851,0,0,1,1,0),
(3091022,16595,0,0,1,1,0),
(3091022,76322,0,0,1,1,0),
(3091022,13006,0,0,1,1,0),
(3091022,19,0,0,0,0,1),
(3091023,76325,1,0,0,0,0),
(3091023,13087,0,0,1,1,0),
(3091023,15961,0,0,1,1,0),
(3091023,60294,0,0,1,1,0),
(3091023,76322,0,0,1,1,0),
(3091023,13006,0,0,1,1,0),
(3091023,19,0,0,0,0,1),
(3091024,76326,1,0,0,0,0),
(3091024,13045,0,0,2,2,0),
(3091024,16592,0,0,2,2,0),
(3091024,76322,0,0,1,1,0),
(3091024,19,0,0,0,0,1),
(3091025,76329,1,0,0,0,0),
(3091025,76322,0,0,1,1,0),
(3091025,37537,0,0,1,1,0),
(3091025,9644,0,0,1,1,0),
(3091025,16582,0,0,1,1,0),
(3091025,13006,0,0,1,1,0),
(3091025,19,0,0,0,0,1),
(3091026,76327,1,0,0,0,0),
(3091026,16590,0,0,1,1,0),
(3091026,16598,0,0,1,1,0),
(3091026,16851,0,0,1,1,0),
(3091026,76322,0,0,1,1,0),
(3091026,13006,0,0,1,1,0),
(3091026,19,0,0,0,0,1),
(3091027,76328,1,0,0,0,0),
(3091027,76322,0,0,1,1,0),
(3091027,58153,0,0,1,1,0),
(3091027,13006,0,0,1,1,0),
(3091027,19,0,0,0,0,1),
(3091028,76332,1,0,0,0,0),
(3091028,16590,0,0,1,1,0),
(3091028,76322,0,0,3,3,0),
(3091028,16599,0,0,1,1,0),
(3091028,13006,0,0,1,1,0),
(3091028,19,0,0,0,0,1),
(3091029,76334,1,0,0,0,0),
(3091029,58281,0,0,1,1,0),
(3091029,76322,0,0,3,3,0),
(3091029,58153,0,0,1,1,0),
(3091029,13006,0,0,1,1,0),
(3091029,19,0,0,0,0,1);
INSERT INTO rrc002_items (`id`,`name`) VALUES
(9644,CONVERT(0x536f6461205761746572 USING utf8mb4)),
(13006,CONVERT(0x576174657220466c61736b USING utf8mb4)),
(13045,CONVERT(0x42657272696573 USING utf8mb4)),
(13046,CONVERT(0x4672756974 USING utf8mb4)),
(13087,CONVERT(0x426f74746c65206f66204d696c6b USING utf8mb4)),
(13425,CONVERT(0x537069636573 USING utf8mb4)),
(15961,CONVERT(0x437570206f66205375676172 USING utf8mb4)),
(16582,CONVERT(0x566f646b61 USING utf8mb4)),
(16590,CONVERT(0x4261726c6579 USING utf8mb4)),
(16592,CONVERT(0x477261706573 USING utf8mb4)),
(16595,CONVERT(0x4d616c74 USING utf8mb4)),
(16597,CONVERT(0x57696e65205965617374 USING utf8mb4)),
(16598,CONVERT(0x426f74746c65 USING utf8mb4)),
(16599,CONVERT(0x53686f74676c617373 USING utf8mb4)),
(16851,CONVERT(0x436f726b USING utf8mb4)),
(37537,CONVERT(0x5175696e696e65 USING utf8mb4)),
(46979,CONVERT(0x447265616d2044757374 USING utf8mb4)),
(58153,CONVERT(0x5461656c6f7369616e20546561204c6561766573 USING utf8mb4)),
(58281,CONVERT(0x4c656d6f6e USING utf8mb4)),
(60294,CONVERT(0x47656e6572696320436f66666565204265616e73 USING utf8mb4)),
(76322,CONVERT(0x506c616e617220456e65726779205368617264 USING utf8mb4)),
(76324,CONVERT(0x506c616e617220456e6572677920416c65 USING utf8mb4)),
(76325,CONVERT(0x506c616e617220456e6572677920436f66666565 USING utf8mb4)),
(76326,CONVERT(0x506c616e617220456e65726779204a75696365 USING utf8mb4)),
(76327,CONVERT(0x506c616e617220456e657267792053706972697473 USING utf8mb4)),
(76328,CONVERT(0x506c616e617220456e6572677920546561 USING utf8mb4)),
(76329,CONVERT(0x506c616e617220456e65726779204e6f737472756d USING utf8mb4)),
(76330,CONVERT(0x42726577206f662074686520506c616e6573 USING utf8mb4)),
(76332,CONVERT(0x506c616e6172204f766572646f7365 USING utf8mb4)),
(76333,CONVERT(0x43617a6963277320426c6f6f64 USING utf8mb4)),
(76334,CONVERT(0x546561206f6620746865205368617264 USING utf8mb4));
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc002_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc002_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC002 item identity/dependency mismatch'; END IF;
 IF NOT EXISTS(SELECT 1 FROM items WHERE id=17911 AND itemclass=1 AND bagtype=19 AND bagslots=10) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC002 ordinary10-slot Brew Barrel dependency mismatch'; END IF;
 IF already_present NOT IN (0,10) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC002 partial batch or ID collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r JOIN rrc002_recipes e ON r.tradeskill=e.tradeskill AND r.name=e.name WHERE r.id<>e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC002 existing recipe-name collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc002_entries e ON r.item_id=e.item_id JOIN rrc002_recipes q ON e.recipe_id=q.id AND q.name=(SELECT Name FROM items WHERE id=e.item_id) WHERE e.successcount>0 AND r.successcount>0 AND r.iscontainer=0 AND r.recipe_id<>e.recipe_id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC002 existing output recipe collision'; END IF;
 IF already_present=0 THEN
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc002_recipes e ON r.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC002 orphan target entries collision'; END IF;
 INSERT INTO tradeskill_recipe (id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled) SELECT id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled FROM rrc002_recipes;
 INSERT INTO tradeskill_recipe_entries (recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer) SELECT recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer FROM rrc002_entries;
 END IF;
 IF EXISTS(SELECT 1 FROM rrc002_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC002 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc002_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC002 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc002_recipes q ON q.id=r.recipe_id LEFT JOIN rrc002_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC002 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc002_recipes q ON q.id=r.recipe_id)<>68 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC002 target entry multiplicity mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before+IF(already_present=0,10,0) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before+IF(already_present=0,68,0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC002 unexpected table row-count delta'; END IF;
 DROP TEMPORARY TABLE rrc002_entries;
 DROP TEMPORARY TABLE rrc002_recipes;
 DROP TEMPORARY TABLE rrc002_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC002' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
