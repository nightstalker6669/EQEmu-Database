-- RRC076: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC076 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC076 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC076 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC076 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc076_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc076_parents LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc076_parent_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc076_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc076_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc076_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3093629,CONVERT(0x4162696c6974793a20456e6368616e7420416c6172616e204d6574616c USING utf8mb4),58,0,135,0,0,CONVERT(0x5072696d617279206162696c6974792d626f6f6b20666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f757465206f6e6c793b205252433037362e USING utf8mb4),2,0,0,1,18,-1,NULL,NULL),
(3093630,CONVERT(0x4162696c6974793a204d61737320456e6368616e7420416c6172616e204d6574616c USING utf8mb4),58,0,148,0,0,CONVERT(0x5072696d617279206162696c6974792d626f6f6b20666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f757465206f6e6c793b205252433037362e USING utf8mb4),2,0,0,1,18,-1,NULL,NULL),
(3093631,CONVERT(0x4162696c6974793a20456e6368616e7420506c616e617220416c6c6f79 USING utf8mb4),58,0,135,0,0,CONVERT(0x5072696d617279206162696c6974792d626f6f6b20666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f757465206f6e6c793b205252433037362e USING utf8mb4),2,0,0,1,19,-1,NULL,NULL),
(3093632,CONVERT(0x4162696c6974793a204d61737320456e6368616e7420506c616e617220416c6c6f79 USING utf8mb4),58,0,148,0,0,CONVERT(0x5072696d617279206162696c6974792d626f6f6b20666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f757465206f6e6c793b205252433037362e USING utf8mb4),2,0,0,1,19,-1,NULL,NULL);
INSERT INTO rrc076_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3093629,64554,1,0,0,0,0),
(3093629,64546,0,0,1,1,0),
(3093629,93542,0,0,1,1,0),
(3093629,93560,0,0,1,1,0),
(3093629,93553,0,0,1,1,0),
(3093629,93514,0,0,1,1,0),
(3093629,93502,0,0,1,1,0),
(3093629,93492,0,0,0,0,1),
(3093630,64555,1,0,0,0,0),
(3093630,64546,0,0,1,1,0),
(3093630,97815,0,0,1,1,0),
(3093630,93542,0,0,1,1,0),
(3093630,93560,0,0,1,1,0),
(3093630,93574,0,0,1,1,0),
(3093630,93553,0,0,1,1,0),
(3093630,93514,0,0,1,1,0),
(3093630,93492,0,0,0,0,1),
(3093631,76276,1,0,0,0,0),
(3093631,93542,0,0,1,1,0),
(3093631,93560,0,0,1,1,0),
(3093631,93553,0,0,1,1,0),
(3093631,76322,0,0,1,1,0),
(3093631,93514,0,0,1,1,0),
(3093631,76281,0,0,1,1,0),
(3093631,93492,0,0,0,0,1),
(3093632,76277,1,0,0,0,0),
(3093632,76282,0,0,1,1,0),
(3093632,93542,0,0,1,1,0),
(3093632,93560,0,0,1,1,0),
(3093632,93574,0,0,1,1,0),
(3093632,93553,0,0,1,1,0),
(3093632,76322,0,0,1,1,0),
(3093632,93514,0,0,1,1,0),
(3093632,93492,0,0,0,0,1);
INSERT INTO rrc076_items (`id`,`name`) VALUES
(64546,CONVERT(0x457373656e6365206f6620416c61726973 USING utf8mb4)),
(64554,CONVERT(0x4162696c6974793a20456e6368616e7420416c6172616e204d6574616c USING utf8mb4)),
(64555,CONVERT(0x4162696c6974793a204d61737320456e6368616e7420416c6172616e204d6574616c USING utf8mb4)),
(76276,CONVERT(0x4162696c6974793a20456e6368616e7420506c616e617220416c6c6f79 USING utf8mb4)),
(76277,CONVERT(0x4162696c6974793a204d61737320456e6368616e7420506c616e617220416c6c6f79 USING utf8mb4)),
(76281,CONVERT(0x52756e6963204e756d656e20506c61717565 USING utf8mb4)),
(76282,CONVERT(0x46696e652052756e6963204e756d656e20506c61717565 USING utf8mb4)),
(76322,CONVERT(0x506c616e617220456e65726779205368617264 USING utf8mb4)),
(93492,CONVERT(0x5370656c6c205265736561726368204b6974 USING utf8mb4)),
(93502,CONVERT(0x52756e69632050617263686d656e74 USING utf8mb4)),
(93514,CONVERT(0x5175696c6c206f662074686520436f6572636572 USING utf8mb4)),
(93542,CONVERT(0x496e6b204164646974697665206f6620746865204e616d656c657373 USING utf8mb4)),
(93553,CONVERT(0x496e7669676f726174696e6720546869636b656e6572 USING utf8mb4)),
(93560,CONVERT(0x496e6b206f66204472757a7a696c20526f USING utf8mb4)),
(93574,CONVERT(0x496e6b206f6620507265787573 USING utf8mb4)),
(97815,CONVERT(0x46696e652052756e69632050617263686d656e74 USING utf8mb4));
INSERT INTO rrc076_parents (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(12774,CONVERT(0x4162696c6974793a20456e6368616e74204665796d6574616c USING utf8mb4),58,0,132,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12775,CONVERT(0x4162696c6974793a204d61737320456e6368616e74204665796d6574616c USING utf8mb4),58,0,144,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL);
INSERT INTO rrc076_parent_entries (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(149994,12774,46979,0,0,1,1,0),
(149995,12774,93542,0,0,1,1,0),
(149996,12774,93560,0,0,1,1,0),
(149997,12774,93553,0,0,1,1,0),
(149998,12774,93514,0,0,1,1,0),
(149999,12774,93502,0,0,1,1,0),
(150000,12774,81136,1,0,0,0,0),
(150001,12774,93492,0,0,0,0,1),
(150002,12775,46979,0,0,1,1,0),
(150003,12775,97815,0,0,1,1,0),
(150004,12775,93542,0,0,1,1,0),
(150005,12775,93560,0,0,1,1,0),
(150006,12775,93574,0,0,1,1,0),
(150007,12775,93553,0,0,1,1,0),
(150008,12775,93514,0,0,1,1,0),
(150009,12775,81137,1,0,0,0,0),
(150010,12775,93492,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF EXISTS(SELECT 1 FROM rrc076_parents e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC076 prototype drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc076_parent_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc076_parents p ON p.id=r.recipe_id)<>17 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC076 prototype entries drift'; END IF;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc076_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc076_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC076 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93492 AND itemclass=1 AND bagtype=11 AND bagslots=10 AND bagsize=3 AND classes=15360)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC076 native kit mismatch'; END IF; IF (SELECT COUNT(*) FROM items WHERE (id=64554 AND size=1 AND stackable=1 AND maxcharges=1) OR (id=64546 AND size=0 AND stackable=1 AND maxcharges=0) OR (id=93542 AND size=0 AND stackable=1 AND maxcharges=0) OR (id=93560 AND size=1 AND stackable=1 AND maxcharges=0) OR (id=93553 AND size=0 AND stackable=1 AND maxcharges=0) OR (id=93514 AND size=1 AND stackable=1 AND maxcharges=0) OR (id=93502 AND size=1 AND stackable=1 AND maxcharges=0) OR (id=64555 AND size=1 AND stackable=1 AND maxcharges=1) OR (id=97815 AND size=1 AND stackable=1 AND maxcharges=0) OR (id=93574 AND size=1 AND stackable=1 AND maxcharges=0) OR (id=76276 AND size=1 AND stackable=1 AND maxcharges=1) OR (id=76322 AND size=0 AND stackable=1 AND maxcharges=0) OR (id=76281 AND size=1 AND stackable=1 AND maxcharges=0) OR (id=76277 AND size=1 AND stackable=1 AND maxcharges=1) OR (id=76282 AND size=1 AND stackable=1 AND maxcharges=0))<>15 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC076 input/output semantics mismatch'; END IF; IF (SELECT COUNT(*) FROM items WHERE classes=8192 AND stackable=1 AND maxcharges=1 AND clickeffect=11370 AND clicktype=3 AND ((id=64554 AND ScriptFileID=20561 AND reqlevel=90 AND clicklevel2=80) OR (id=64555 AND ScriptFileID=20562 AND reqlevel=91 AND clicklevel2=81) OR (id=76276 AND ScriptFileID=22568 AND reqlevel=95 AND clicklevel2=85) OR (id=76277 AND ScriptFileID=22569 AND reqlevel=96 AND clicklevel2=86)))<>4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC076 book acquisition metadata drift'; END IF;
 IF already_present NOT IN (0,4) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC076 partial batch or ID collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r JOIN rrc076_recipes e ON r.tradeskill=e.tradeskill AND r.name=e.name WHERE r.id<>e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC076 existing recipe-name collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc076_entries e ON r.item_id=e.item_id JOIN rrc076_recipes q ON e.recipe_id=q.id WHERE e.successcount>e.componentcount AND e.iscontainer=0 AND r.successcount>r.componentcount AND r.iscontainer=0 AND r.recipe_id<>e.recipe_id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC076 existing output recipe collision'; END IF;
 IF already_present=0 THEN
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc076_recipes e ON r.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC076 orphan target entries collision'; END IF;
 INSERT INTO tradeskill_recipe (id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled) SELECT id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled FROM rrc076_recipes;
 INSERT INTO tradeskill_recipe_entries (recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer) SELECT recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer FROM rrc076_entries;
 END IF;
 IF EXISTS(SELECT 1 FROM rrc076_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC076 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc076_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC076 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc076_recipes q ON q.id=r.recipe_id LEFT JOIN rrc076_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC076 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc076_recipes q ON q.id=r.recipe_id)<>34 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC076 target entry multiplicity mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before+IF(already_present=0,4,0) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before+IF(already_present=0,34,0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC076 unexpected table row-count delta'; END IF;
 IF EXISTS(SELECT 1 FROM rrc076_parents e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC076 prototype drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc076_parent_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc076_parents p ON p.id=r.recipe_id)<>17 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC076 prototype entries drift'; END IF;
 DROP TEMPORARY TABLE rrc076_parents;
 DROP TEMPORARY TABLE rrc076_parent_entries;
 DROP TEMPORARY TABLE rrc076_entries;
 DROP TEMPORARY TABLE rrc076_recipes;
 DROP TEMPORARY TABLE rrc076_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC076' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
