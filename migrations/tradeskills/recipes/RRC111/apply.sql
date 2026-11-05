-- RRC111: one explicit ordinary-kit link; fresh dedicated strict MariaDB session.
DELIMITER //
BEGIN NOT ATOMIC
 DECLARE own_transaction BOOLEAN DEFAULT FALSE;
 DECLARE recipes_before BIGINT DEFAULT 0;
 DECLARE entries_before BIGINT DEFAULT 0;
 DECLARE locked_rows BIGINT DEFAULT 0;
 DECLARE changed_rows BIGINT DEFAULT 0;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
  IF own_transaction THEN ROLLBACK;END IF;
  RESIGNAL;
 END;
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC111 invalid target/transaction';END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC111 strict mode required';END IF;
 IF(SELECT COUNT(*)FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE()AND TABLE_NAME IN('tradeskill_recipe','tradeskill_recipe_entries','items')AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC111 InnoDB mismatch';END IF;
 CREATE TEMPORARY TABLE rrc111_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc111_before LIKE tradeskill_recipe_entries;
 INSERT INTO rrc111_recipes(`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`)VALUES
(7300,CONVERT(0x436c617373203720537465656c2053696c76657220546970204172726f772028736d616c6c29 USING utf8mb4),64,0,228,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc111_before(`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`)VALUES
(69024,7300,8052,0,0,1,1,0),
(69025,7300,8057,0,0,1,1,0),
(69026,7300,8063,0,0,1,1,0),
(69027,7300,72093,0,0,1,1,0),
(69028,7300,75658,10,0,0,0,0),
(69029,7300,17762,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*)INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*)INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe WHERE id=7300 FOR UPDATE;
 IF locked_rows<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC111 recipe missing';END IF;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe_entries WHERE recipe_id=7300 FOR UPDATE;
 IF locked_rows<>6 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC111 target entry multiplicity';END IF;
 IF EXISTS(SELECT 1 FROM rrc111_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC111 recipe drift';END IF;
 IF EXISTS(SELECT 1 FROM rrc111_before e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries WHERE recipe_id=7300)<>6 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC111 old entry/count drift';END IF;
 IF(SELECT COUNT(*)FROM tradeskill_recipe_entries WHERE `recipe_id` <=> 7300 AND `item_id` <=> 17910 AND `successcount` <=> 0 AND `failcount` <=> 0 AND `componentcount` <=> 0 AND `salvagecount` <=> 0 AND `iscontainer` <=> 1)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC111 named kit state mismatch';END IF;
 IF(SELECT COUNT(*)FROM items WHERE `id` <=> 8052 AND BINARY Name=BINARY CONVERT(0x536d616c6c2047726f6f7665204e6f636b73 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `range` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC111 native semantics drift';END IF;
 IF(SELECT COUNT(*)FROM items WHERE `id` <=> 8057 AND BINARY Name=BINARY CONVERT(0x53696c76657220546970706564204172726f776865616473 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `range` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC111 native semantics drift';END IF;
 IF(SELECT COUNT(*)FROM items WHERE `id` <=> 8063 AND BINARY Name=BINARY CONVERT(0x42756e646c656420537465656c204172726f7720536861667473 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `range` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC111 native semantics drift';END IF;
 IF(SELECT COUNT(*)FROM items WHERE `id` <=> 17762 AND BINARY Name=BINARY CONVERT(0x506c616e617220466c65746368696e67204b6974 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `damage` <=> 0 AND `range` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC111 native semantics drift';END IF;
 IF(SELECT COUNT(*)FROM items WHERE `id` <=> 17910 AND BINARY Name=BINARY CONVERT(0x466c65746368696e67204b6974 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `damage` <=> 0 AND `range` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC111 native semantics drift';END IF;
 IF(SELECT COUNT(*)FROM items WHERE `id` <=> 72093 AND BINARY Name=BINARY CONVERT(0x476972706c616e204665617468657273 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `range` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC111 native semantics drift';END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72093 AND a.componentcount=1 AND a.iscontainer=0 AND r.enabled=1 AND r.id<>7300 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=4 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=8052 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=8057 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=8063 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72093 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries k WHERE k.recipe_id=r.id AND k.iscontainer=1 AND k.item_id IN(17910,18)))THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC111 new effective-kit collision';END IF;
 INSERT INTO tradeskill_recipe_entries(`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`)VALUES
(7300,17910,0,0,0,0,1);
 SET changed_rows=ROW_COUNT();
 IF changed_rows<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC111 changed-row mismatch';END IF;
 IF EXISTS(SELECT 1 FROM rrc111_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC111 recipe drift';END IF;
 IF EXISTS(SELECT 1 FROM rrc111_before e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries WHERE recipe_id=7300)<>7 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC111 old entry/count drift';END IF;
 IF(SELECT COUNT(*)FROM tradeskill_recipe_entries WHERE `recipe_id` <=> 7300 AND `item_id` <=> 17910 AND `successcount` <=> 0 AND `failcount` <=> 0 AND `componentcount` <=> 0 AND `salvagecount` <=> 0 AND `iscontainer` <=> 1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC111 named kit state mismatch';END IF;
 IF(SELECT COUNT(*)FROM tradeskill_recipe)<>recipes_before OR(SELECT COUNT(*)FROM tradeskill_recipe_entries)<>entries_before+1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC111 global row-count delta';END IF;
 DROP TEMPORARY TABLE rrc111_before;
 DROP TEMPORARY TABLE rrc111_recipes;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC111',changed_rows,recipes_before,(SELECT COUNT(*)FROM tradeskill_recipe),entries_before,(SELECT COUNT(*)FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
