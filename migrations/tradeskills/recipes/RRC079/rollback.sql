-- RRC079: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC079 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC079 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC079 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC079 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc079_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc079_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc079_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc079_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3093643,CONVERT(0x456d707479205669616c USING utf8mb4),58,0,15,1,0,CONVERT(0x5072696d6172792064697274792d7669616c20636c65616e696e6720666f726d756c613b206578706c69636974205370656c6c205265736561726368204b697420726f7574653b205252433037392e USING utf8mb4),2,0,0,1,10,-1,NULL,NULL);
INSERT INTO rrc079_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3093643,10062,4,0,0,0,0),
(3093643,93618,0,1,1,0,0),
(3093643,93510,0,3,3,0,0),
(3093643,93492,0,0,0,0,1);
INSERT INTO rrc079_items (`id`,`name`) VALUES
(10062,CONVERT(0x456d707479205669616c USING utf8mb4)),
(93492,CONVERT(0x5370656c6c205265736561726368204b6974 USING utf8mb4)),
(93510,CONVERT(0x5669616c206f662050757265205761746572 USING utf8mb4)),
(93618,CONVERT(0x446972747920456d707479205669616c USING utf8mb4));
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc079_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc079_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC079 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93492 AND itemclass=1 AND bagtype=11 AND bagslots=10 AND bagsize=3 AND classes=15360)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC079 native kit mismatch'; END IF; IF (SELECT COUNT(*) FROM items WHERE (id=10062 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=65535) OR (id=93510 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=93618 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=65535))<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC079 input/output semantics mismatch'; END IF;
 IF already_present<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC079 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc079_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC079 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc079_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC079 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc079_recipes q ON q.id=r.recipe_id LEFT JOIN rrc079_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC079 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc079_recipes q ON q.id=r.recipe_id)<>4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC079 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc079_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC079 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc079_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc079_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-1 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC079 rollback count mismatch'; END IF;
 DROP TEMPORARY TABLE rrc079_entries;
 DROP TEMPORARY TABLE rrc079_recipes;
 DROP TEMPORARY TABLE rrc079_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC079' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
