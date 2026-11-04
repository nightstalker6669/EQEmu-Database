-- RRC081: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc081_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc081_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc081_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc081_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3093644,CONVERT(0x546f6d65206f66204563686f206f6620446563657074696f6e20526b2e204949 USING utf8mb4),58,0,440,0,0,CONVERT(0x5072696d617279204d6f6e6b205072696d657220746f6d6520666f726d756c613b206578697374696e6720546f6d652042696e64696e67204b697420726f7574653b205252433038312e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093645,CONVERT(0x546f6d65206f6620576865656c206f6620466973747320526b2e204949 USING utf8mb4),58,0,444,0,0,CONVERT(0x5072696d617279204d6f6e6b205072696d657220746f6d6520666f726d756c613b206578697374696e6720546f6d652042696e64696e67204b697420726f7574653b205252433038312e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093646,CONVERT(0x546f6d65206f66205368696d6d6572696e672053696c686f756574746520526b2e204949 USING utf8mb4),58,0,432,0,0,CONVERT(0x5072696d617279204d6f6e6b205072696d657220746f6d6520666f726d756c613b206578697374696e6720546f6d652042696e64696e67204b697420726f7574653b205252433038312e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093647,CONVERT(0x546f6d65206f66204d6f6d656e74206f66205472616e7175696c69747920526b2e204949 USING utf8mb4),58,0,450,0,0,CONVERT(0x5072696d617279204d6f6e6b205072696d657220746f6d6520666f726d756c613b206578697374696e6720546f6d652042696e64696e67204b697420726f7574653b205252433038312e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093648,CONVERT(0x546f6d65206f662041737472616c2050726f6a656374696f6e20526b2e204949 USING utf8mb4),58,0,436,0,0,CONVERT(0x5072696d617279204d6f6e6b205072696d657220746f6d6520666f726d756c613b206578697374696e6720546f6d652042696e64696e67204b697420726f7574653b205252433038312e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093649,CONVERT(0x546f6d65206f662044656c617920446561746820526b2e204949 USING utf8mb4),58,0,450,0,0,CONVERT(0x5072696d617279204d6f6e6b205072696d657220746f6d6520666f726d756c613b206578697374696e6720546f6d652042696e64696e67204b697420726f7574653b205252433038312e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093650,CONVERT(0x546f6d65206f66204372797374616c70616c6d204469736369706c696e6520526b2e204949 USING utf8mb4),58,0,444,0,0,CONVERT(0x5072696d617279204d6f6e6b205072696d657220746f6d6520666f726d756c613b206578697374696e6720546f6d652042696e64696e67204b697420726f7574653b205252433038312e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL);
INSERT INTO rrc081_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3093644,115785,1,0,0,0,0),
(3093644,93555,0,0,1,1,0),
(3093644,90314,0,0,1,1,0),
(3093644,93589,0,0,1,1,0),
(3093644,93590,0,0,1,1,0),
(3093644,41526,0,0,1,1,0),
(3093644,41534,0,0,1,1,0),
(3093644,41555,0,0,0,0,1),
(3093645,115797,1,0,0,0,0),
(3093645,93542,0,0,1,1,0),
(3093645,41544,0,0,3,3,0),
(3093645,41526,0,0,1,1,0),
(3093645,90315,0,0,1,1,0),
(3093645,41536,0,0,1,1,0),
(3093645,41555,0,0,0,0,1),
(3093646,115800,1,0,0,0,0),
(3093646,93555,0,0,1,1,0),
(3093646,93542,0,0,1,1,0),
(3093646,93590,0,0,1,1,0),
(3093646,41526,0,0,1,1,0),
(3093646,90312,0,0,1,1,0),
(3093646,41555,0,0,0,0,1),
(3093647,115803,1,0,0,0,0),
(3093647,90316,0,0,1,1,0),
(3093647,93542,0,0,1,1,0),
(3093647,93575,0,0,1,1,0),
(3093647,93578,0,0,1,1,0),
(3093647,93553,0,0,1,1,0),
(3093647,41526,0,0,1,1,0),
(3093647,41555,0,0,0,0,1),
(3093648,115812,1,0,0,0,0),
(3093648,93557,0,0,1,1,0),
(3093648,93542,0,0,1,1,0),
(3093648,93576,0,0,1,1,0),
(3093648,90313,0,0,1,1,0),
(3093648,41526,0,0,1,1,0),
(3093648,41555,0,0,0,0,1),
(3093649,115815,1,0,0,0,0),
(3093649,90316,0,0,1,1,0),
(3093649,93542,0,0,1,1,0),
(3093649,93573,0,0,1,1,0),
(3093649,93553,0,0,1,1,0),
(3093649,41526,0,0,1,1,0),
(3093649,41555,0,0,0,0,1),
(3093650,115821,1,0,0,0,0),
(3093650,93542,0,0,1,1,0),
(3093650,93578,0,0,2,2,0),
(3093650,93553,0,0,1,1,0),
(3093650,41526,0,0,1,1,0),
(3093650,90315,0,0,1,1,0),
(3093650,41555,0,0,0,0,1);
INSERT INTO rrc081_items (`id`,`name`) VALUES
(41526,CONVERT(0x5175696c6c206f6620746865205472616e7363656e64656e74 USING utf8mb4)),
(41534,CONVERT(0x52616c6c6f732720496e6b204164646974697665 USING utf8mb4)),
(41536,CONVERT(0x537472696b696e6720546869636b656e6572 USING utf8mb4)),
(41544,CONVERT(0x496e6b206f662046696e65737365 USING utf8mb4)),
(41555,CONVERT(0x546f6d652042696e64696e67204b6974 USING utf8mb4)),
(90312,CONVERT(0x526f756768205072696d6572 USING utf8mb4)),
(90313,CONVERT(0x5072696d6572 USING utf8mb4)),
(90314,CONVERT(0x46696e65205072696d6572 USING utf8mb4)),
(90315,CONVERT(0x52756e6963205072696d6572 USING utf8mb4)),
(90316,CONVERT(0x46696e652052756e6963205072696d6572 USING utf8mb4)),
(93542,CONVERT(0x496e6b204164646974697665206f6620746865204e616d656c657373 USING utf8mb4)),
(93553,CONVERT(0x496e7669676f726174696e6720546869636b656e6572 USING utf8mb4)),
(93555,CONVERT(0x446562696c69746174696e6720546869636b656e6572 USING utf8mb4)),
(93557,CONVERT(0x436f6e6a7572696e6720546869636b656e6572 USING utf8mb4)),
(93573,CONVERT(0x496e6b206f662054756e617265 USING utf8mb4)),
(93575,CONVERT(0x496e6b206f662074686520426f6172 USING utf8mb4)),
(93576,CONVERT(0x496e6b206f6620746865204561676c65 USING utf8mb4)),
(93578,CONVERT(0x496e6b206f66205a656b USING utf8mb4)),
(93589,CONVERT(0x496e6b206f6620466f7267657466756c6e657373 USING utf8mb4)),
(93590,CONVERT(0x496e6b206f66205472616e7175696c697479 USING utf8mb4)),
(115785,CONVERT(0x546f6d65206f66204563686f206f6620446563657074696f6e20526b2e204949 USING utf8mb4)),
(115797,CONVERT(0x546f6d65206f6620576865656c206f6620466973747320526b2e204949 USING utf8mb4)),
(115800,CONVERT(0x546f6d65206f66205368696d6d6572696e672053696c686f756574746520526b2e204949 USING utf8mb4)),
(115803,CONVERT(0x546f6d65206f66204d6f6d656e74206f66205472616e7175696c69747920526b2e204949 USING utf8mb4)),
(115812,CONVERT(0x546f6d65206f662041737472616c2050726f6a656374696f6e20526b2e204949 USING utf8mb4)),
(115815,CONVERT(0x546f6d65206f662044656c617920446561746820526b2e204949 USING utf8mb4)),
(115821,CONVERT(0x546f6d65206f66204372797374616c70616c6d204469736369706c696e6520526b2e204949 USING utf8mb4));
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc081_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc081_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=41555 AND itemclass=1 AND bagtype=11 AND bagslots=10 AND bagsize=3 AND classes=33089)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 native kit mismatch'; END IF; IF (SELECT COUNT(*) FROM items WHERE (id=115785 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=64) OR (id=93555 AND size=0 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=90314 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=93589 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=93590 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=41526 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=41534 AND size=0 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=115797 AND size=1 AND stackable=0 AND maxcharges=0 AND classes=64) OR (id=93542 AND size=0 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=41544 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=90315 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=41536 AND size=0 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=115800 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=64) OR (id=90312 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=115803 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=64) OR (id=90316 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=93575 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=93578 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=93553 AND size=0 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=115812 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=64) OR (id=93557 AND size=0 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=93576 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=90313 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=115815 AND size=1 AND stackable=0 AND maxcharges=0 AND classes=64) OR (id=93573 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=115821 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=64))<>26 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 input/output semantics mismatch'; END IF; IF (SELECT COUNT(*) FROM items WHERE (id=115785 AND itemtype=20 AND scrolleffect=14785 AND scrolllevel=0 AND reqlevel=0) OR (id=115797 AND itemtype=20 AND scrolleffect=14797 AND scrolllevel=0 AND reqlevel=0) OR (id=115800 AND itemtype=20 AND scrolleffect=14800 AND scrolllevel=0 AND reqlevel=0) OR (id=115803 AND itemtype=20 AND scrolleffect=14803 AND scrolllevel=0 AND reqlevel=0) OR (id=115812 AND itemtype=20 AND scrolleffect=14812 AND scrolllevel=0 AND reqlevel=0) OR (id=115815 AND itemtype=20 AND scrolleffect=14815 AND scrolllevel=0 AND reqlevel=0) OR (id=115821 AND itemtype=20 AND scrolleffect=14821 AND scrolllevel=0 AND reqlevel=0))<>7 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 Tome spell binding mismatch'; END IF;
 IF already_present<>7 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc081_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc081_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc081_recipes q ON q.id=r.recipe_id LEFT JOIN rrc081_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc081_recipes q ON q.id=r.recipe_id)<>51 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc081_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc081_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc081_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-7 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-51 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 rollback count mismatch'; END IF;
 DROP TEMPORARY TABLE rrc081_entries;
 DROP TEMPORARY TABLE rrc081_recipes;
 DROP TEMPORARY TABLE rrc081_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC081' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
