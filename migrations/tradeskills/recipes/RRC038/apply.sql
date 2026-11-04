-- RRC038: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC038 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC038 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC038 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC038 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc038_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc038_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc038_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc038_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3092447,CONVERT(0x42726577657220436572616d696320436c6179 USING utf8mb4),65,0,262,0,0,CONVERT(0x5453533b20455154432061727469636c653339393b2042726577696e673b205252433033382e USING utf8mb4),0,0,0,1,12,-1,NULL,NULL),
(3092448,CONVERT(0x4372657363656e7420457373656e6365 USING utf8mb4),65,0,122,0,0,CONVERT(0x5453533b20455154432061727469636c653339393b2042726577696e673b205252433033382e USING utf8mb4),0,0,0,1,12,-1,NULL,NULL),
(3092449,CONVERT(0x4477617276656e20486561767920526564204265616e20416c65 USING utf8mb4),65,0,152,0,0,CONVERT(0x5453533b20455154432061727469636c653339393b2042726577696e673b205252433033382e USING utf8mb4),0,0,0,1,12,-1,NULL,NULL),
(3092450,CONVERT(0x4477617276656e204c6967687420526564204265616e20416c65 USING utf8mb4),65,0,139,0,0,CONVERT(0x5453533b20455154432061727469636c653339393b2042726577696e673b205252433033382e USING utf8mb4),0,0,0,1,12,-1,NULL,NULL),
(3092451,CONVERT(0x4d696e6f74617572204865617679205061696e746564204265616e20416c65 USING utf8mb4),65,0,258,0,0,CONVERT(0x5453533b20455154432061727469636c653339393b2042726577696e673b205252433033382e USING utf8mb4),0,0,0,1,12,-1,NULL,NULL),
(3092452,CONVERT(0x4d696e6f74617572204c69676874205061696e746564204265616e20416c65 USING utf8mb4),65,0,204,0,0,CONVERT(0x5453533b20455154432061727469636c653339393b2042726577696e673b205252433033382e USING utf8mb4),0,0,0,1,12,-1,NULL,NULL);
INSERT INTO rrc038_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3092447,97952,1,0,0,0,0),
(3092447,16590,0,0,1,1,0),
(3092447,97277,0,0,1,1,0),
(3092447,16595,0,0,1,1,0),
(3092447,16948,0,0,1,1,0),
(3092447,13006,0,0,1,1,0),
(3092447,19,0,0,0,0,1),
(3092448,98455,1,0,0,0,0),
(3092448,97267,0,0,1,1,0),
(3092448,13006,0,0,1,1,0),
(3092448,19,0,0,0,0,1),
(3092449,98238,1,0,0,0,0),
(3092449,22536,0,0,2,2,0),
(3092449,16580,0,0,1,1,0),
(3092449,98228,0,0,2,2,0),
(3092449,98221,0,0,2,2,0),
(3092449,98217,0,0,1,1,0),
(3092449,16596,0,0,2,2,0),
(3092449,19,0,0,0,0,1),
(3092450,98244,8,0,0,0,0),
(3092450,16580,1,1,1,0,0),
(3092450,98238,0,0,4,4,0),
(3092450,19175,0,0,4,4,0),
(3092450,98229,2,0,0,0,0),
(3092450,19,0,0,0,0,1),
(3092451,98243,1,0,0,0,0),
(3092451,16580,0,0,1,1,0),
(3092451,98228,0,0,2,2,0),
(3092451,19198,0,0,2,2,0),
(3092451,98223,0,0,2,2,0),
(3092451,98217,0,0,1,1,0),
(3092451,16596,0,0,2,2,0),
(3092451,19,0,0,0,0,1),
(3092452,98249,8,0,0,0,0),
(3092452,16580,1,1,1,0,0),
(3092452,98243,0,0,4,4,0),
(3092452,19175,0,0,4,4,0),
(3092452,98229,2,0,0,0,0),
(3092452,19,0,0,0,0,1);
INSERT INTO rrc038_items (`id`,`name`) VALUES
(13006,CONVERT(0x576174657220466c61736b USING utf8mb4)),
(16580,CONVERT(0x4361736b USING utf8mb4)),
(16590,CONVERT(0x4261726c6579 USING utf8mb4)),
(16595,CONVERT(0x4d616c74 USING utf8mb4)),
(16596,CONVERT(0x5965617374 USING utf8mb4)),
(16948,CONVERT(0x536d616c6c20426c6f636b206f66204d6167696320436c6179 USING utf8mb4)),
(17179,CONVERT(0x506f727461626c65204472696e6b2042617272656c USING utf8mb4)),
(17521,CONVERT(0x436f6c6c61707369626c652044697374696c6c657279 USING utf8mb4)),
(17911,CONVERT(0x42726577696e672042617272656c USING utf8mb4)),
(19175,CONVERT(0x4f74686d697220416c67616520416c65 USING utf8mb4)),
(19198,CONVERT(0x4d696e6f74617572204865726f27732042726577 USING utf8mb4)),
(22536,CONVERT(0x3278204272657765642032782053746f7574204477617276656e20416c65 USING utf8mb4)),
(97267,CONVERT(0x4372657363656e74205065726368 USING utf8mb4)),
(97277,CONVERT(0x426173696c69736b205363616c65 USING utf8mb4)),
(97952,CONVERT(0x42726577657220436572616d696320436c6179 USING utf8mb4)),
(98217,CONVERT(0x5375676172205379727570 USING utf8mb4)),
(98221,CONVERT(0x53706963656420526564204265616e73 USING utf8mb4)),
(98223,CONVERT(0x537069636564205061696e746564204265616e73 USING utf8mb4)),
(98228,CONVERT(0x43686f707065642053706963656420426c6f6f642053617573616765 USING utf8mb4)),
(98229,CONVERT(0x476c6f62206f6620456469626c65204d75636b USING utf8mb4)),
(98238,CONVERT(0x4477617276656e20486561767920526564204265616e20416c65 USING utf8mb4)),
(98243,CONVERT(0x4d696e6f74617572204865617679205061696e746564204265616e20416c65 USING utf8mb4)),
(98244,CONVERT(0x4477617276656e204c6967687420526564204265616e20416c65 USING utf8mb4)),
(98249,CONVERT(0x4d696e6f74617572204c69676874205061696e746564204265616e20416c65 USING utf8mb4)),
(98455,CONVERT(0x4372657363656e7420457373656e6365 USING utf8mb4));
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc038_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc038_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC038 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE itemclass=1 AND bagtype=19 AND ((id=17911 AND bagslots=10) OR (id IN (17179,17521) AND bagslots=4)))<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC038 brewing container dependency mismatch'; END IF;
 IF already_present NOT IN (0,6) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC038 partial batch or ID collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r JOIN rrc038_recipes e ON r.tradeskill=e.tradeskill AND r.name=e.name WHERE r.id<>e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC038 existing recipe-name collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc038_entries e ON r.item_id=e.item_id JOIN rrc038_recipes q ON e.recipe_id=q.id WHERE e.successcount>0 AND e.componentcount=0 AND e.iscontainer=0 AND r.successcount>r.componentcount AND r.iscontainer=0 AND r.recipe_id<>e.recipe_id AND NOT((e.item_id=98229 AND e.recipe_id IN (3092450,3092452) AND r.recipe_id IN (3092450,3092452)))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC038 existing output recipe collision'; END IF;
 IF already_present=0 THEN
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc038_recipes e ON r.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC038 orphan target entries collision'; END IF;
 INSERT INTO tradeskill_recipe (id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled) SELECT id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled FROM rrc038_recipes;
 INSERT INTO tradeskill_recipe_entries (recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer) SELECT recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer FROM rrc038_entries;
 END IF;
 IF EXISTS(SELECT 1 FROM rrc038_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC038 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc038_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC038 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc038_recipes q ON q.id=r.recipe_id LEFT JOIN rrc038_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC038 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc038_recipes q ON q.id=r.recipe_id)<>39 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC038 target entry multiplicity mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before+IF(already_present=0,6,0) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before+IF(already_present=0,39,0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC038 unexpected table row-count delta'; END IF;
 DROP TEMPORARY TABLE rrc038_entries;
 DROP TEMPORARY TABLE rrc038_recipes;
 DROP TEMPORARY TABLE rrc038_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC038' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
