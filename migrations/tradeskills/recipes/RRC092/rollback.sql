-- RRC092: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC092 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC092 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC092 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC092 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc092_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc092_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc092_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc092_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3093966,CONVERT(0x536f6e673a2057686973706572736f6e67206f6620566573686d6120526b2e204949 USING utf8mb4),58,0,380,0,0,CONVERT(0x5072696d617279204261726420506170657220736f6e6720666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f7574653b205252433039322e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093967,CONVERT(0x536f6e673a2041656c667269632773204c617374204c756c6c61627920526b2e204949 USING utf8mb4),58,0,382,0,0,CONVERT(0x5072696d617279204261726420506170657220736f6e6720666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f7574653b205252433039322e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL);
INSERT INTO rrc092_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3093966,78739,1,0,0,0,0),
(3093966,93555,0,0,1,1,0),
(3093966,93590,0,0,1,1,0),
(3093966,93539,0,0,1,1,0),
(3093966,93525,0,0,1,1,0),
(3093966,97820,0,0,1,1,0),
(3093966,93492,0,0,0,0,1),
(3093967,78751,1,0,0,0,0),
(3093967,93555,0,0,1,1,0),
(3093967,93560,0,0,1,1,0),
(3093967,93590,0,0,1,1,0),
(3093967,93539,0,0,1,1,0),
(3093967,93525,0,0,1,1,0),
(3093967,97820,0,0,1,1,0),
(3093967,93492,0,0,0,0,1);
INSERT INTO rrc092_items (`id`,`name`) VALUES
(78739,CONVERT(0x536f6e673a2057686973706572736f6e67206f6620566573686d6120526b2e204949 USING utf8mb4)),
(78751,CONVERT(0x536f6e673a2041656c667269632773204c617374204c756c6c61627920526b2e204949 USING utf8mb4)),
(93492,CONVERT(0x5370656c6c205265736561726368204b6974 USING utf8mb4)),
(93525,CONVERT(0x5175696c6c206f6620746865204d61657374726f USING utf8mb4)),
(93539,CONVERT(0x4c75636c696e277320496e6b204164646974697665 USING utf8mb4)),
(93555,CONVERT(0x446562696c69746174696e6720546869636b656e6572 USING utf8mb4)),
(93560,CONVERT(0x496e6b206f66204472757a7a696c20526f USING utf8mb4)),
(93590,CONVERT(0x496e6b206f66205472616e7175696c697479 USING utf8mb4)),
(97820,CONVERT(0x526f756768205061706572 USING utf8mb4));
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc092_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc092_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC092 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93492 AND itemclass=1 AND bagtype=11 AND bagslots=10 AND bagsize=3 AND classes=15360)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC092 native kit mismatch'; END IF; IF (SELECT COUNT(*) FROM items WHERE (id=78739 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=128) OR (id=93555 AND size=0 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=93590 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=93539 AND size=0 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=93525 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=97820 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=78751 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=128) OR (id=93560 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360))<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC092 input/output semantics mismatch'; END IF; IF (SELECT COUNT(*) FROM items WHERE (id=78739 AND itemtype=20 AND scrolleffect=10402 AND scrolllevel=0 AND reqlevel=0) OR (id=78751 AND itemtype=20 AND scrolleffect=10414 AND scrolllevel=0 AND reqlevel=0))<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC092 Tome spell binding mismatch'; END IF;
 IF already_present<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC092 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc092_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC092 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc092_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC092 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc092_recipes q ON q.id=r.recipe_id LEFT JOIN rrc092_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC092 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc092_recipes q ON q.id=r.recipe_id)<>15 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC092 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc092_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC092 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc092_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc092_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-2 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-15 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC092 rollback count mismatch'; END IF;
 DROP TEMPORARY TABLE rrc092_entries;
 DROP TEMPORARY TABLE rrc092_recipes;
 DROP TEMPORARY TABLE rrc092_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC092' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
