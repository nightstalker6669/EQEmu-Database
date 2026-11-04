-- RRC067: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC067 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC067 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC067 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC067 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc067_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc067_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc067_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc067_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3093611,CONVERT(0x456c6620457373656e6365 USING utf8mb4),56,0,15,1,0,CONVERT(0x5072696d61727920506f69736f6e20717565737420666f726d756c613b206578697374696e672070656572206775617264733b205252433036372e USING utf8mb4),0,0,0,1,4,-1,NULL,NULL),
(3093612,CONVERT(0x53696d706c6520536f6c76656e7420285669616c206f662053616c74792053656120576174657229 USING utf8mb4),56,0,38,0,0,CONVERT(0x5072696d61727920506f69736f6e20717565737420666f726d756c613b206578697374696e672070656572206775617264733b205252433036372e USING utf8mb4),2,0,0,1,12,-1,NULL,NULL),
(3093613,CONVERT(0x53696d706c6520556e6976657273616c2053757370656e73696f6e20285669616c206f662053616c74792053656120576174657229 USING utf8mb4),56,0,31,0,0,CONVERT(0x5072696d61727920506f69736f6e20717565737420666f726d756c613b206578697374696e672070656572206775617264733b205252433036372e USING utf8mb4),2,0,0,1,12,-1,NULL,NULL);
INSERT INTO rrc067_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3093611,11274,1,0,0,0,0),
(3093611,9650,0,0,1,1,0),
(3093611,13422,0,0,1,1,0),
(3093611,18499,0,0,1,1,0),
(3093611,13421,0,0,1,1,0),
(3093611,17904,0,0,0,0,1),
(3093612,58122,1,0,0,0,0),
(3093612,58060,0,0,1,1,0),
(3093612,98263,0,0,1,1,0),
(3093612,17904,0,0,0,0,1),
(3093612,17110,0,0,0,0,1),
(3093612,17139,0,0,0,0,1),
(3093612,17190,0,0,0,0,1),
(3093613,58130,1,0,0,0,0),
(3093613,58128,0,0,1,1,0),
(3093613,98263,0,0,1,1,0),
(3093613,17904,0,0,0,0,1),
(3093613,17110,0,0,0,0,1),
(3093613,17139,0,0,0,0,1),
(3093613,17190,0,0,0,0,1);
INSERT INTO rrc067_items (`id`,`name`) VALUES
(9650,CONVERT(0x43656c65737469616c20457373656e6365 USING utf8mb4)),
(11274,CONVERT(0x456c6620457373656e6365 USING utf8mb4)),
(13421,CONVERT(0x576f6f6420456c66205061727473 USING utf8mb4)),
(13422,CONVERT(0x4461726b20456c66205061727473 USING utf8mb4)),
(17110,CONVERT(0x416372796c6961204d6f7274617220616e6420506573746c65 USING utf8mb4)),
(17139,CONVERT(0x4d6172626c65204d6f7274617220616e6420506573746c65 USING utf8mb4)),
(17190,CONVERT(0x436f6c6c61707369626c65204d6f7274617220616e6420506573746c65 USING utf8mb4)),
(17904,CONVERT(0x4d6f7274617220616e6420506573746c65 USING utf8mb4)),
(18499,CONVERT(0x456c6620457373656e636520526563697065 USING utf8mb4)),
(58060,CONVERT(0x4f756e6365206f66204d696c642041636964 USING utf8mb4)),
(58122,CONVERT(0x53696d706c6520536f6c76656e74 USING utf8mb4)),
(58128,CONVERT(0x53696d706c6520546869636b656e6572 USING utf8mb4)),
(58130,CONVERT(0x53696d706c6520556e6976657273616c2053757370656e73696f6e USING utf8mb4)),
(98263,CONVERT(0x5669616c206f662053616c747920536561205761746572 USING utf8mb4));
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc067_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc067_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC067 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE itemclass=1 AND ((id=17110 AND bagtype=30 AND bagslots=8 AND bagsize=2) OR (id=17139 AND bagtype=12 AND bagslots=10 AND bagsize=3) OR (id=17190 AND bagtype=12 AND bagslots=6 AND bagsize=3) OR (id=17904 AND bagtype=12 AND bagslots=6 AND bagsize=3)))<>4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC067 native kit mismatch'; END IF; IF (SELECT COUNT(*) FROM items WHERE (id=9650 AND size=1) OR (id=13421 AND size=1) OR (id=13422 AND size=1) OR (id=18499 AND size=1) OR (id=58060 AND size=1) OR (id=58128 AND size=1) OR (id=98263 AND size=1))<>7 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC067 ingredient size mismatch'; END IF;
 IF already_present<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC067 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc067_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC067 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc067_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC067 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc067_recipes q ON q.id=r.recipe_id LEFT JOIN rrc067_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC067 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc067_recipes q ON q.id=r.recipe_id)<>20 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC067 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc067_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC067 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc067_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc067_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-3 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-20 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC067 rollback count mismatch'; END IF;
 DROP TEMPORARY TABLE rrc067_entries;
 DROP TEMPORARY TABLE rrc067_recipes;
 DROP TEMPORARY TABLE rrc067_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC067' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
