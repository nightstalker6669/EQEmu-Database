-- RRC129: one explicit Xakra tooth component; fresh dedicated strict MariaDB session.
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
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC129 invalid target/transaction';END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC129 strict mode required';END IF;
 IF(SELECT COUNT(*)FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE()AND TABLE_NAME IN('tradeskill_recipe','tradeskill_recipe_entries','items')AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC129 InnoDB mismatch';END IF;
 CREATE TEMPORARY TABLE rrc129_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc129_before LIKE tradeskill_recipe_entries;
 INSERT INTO rrc129_recipes(`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`)VALUES
(7545,CONVERT(0x58616b726120546f6f74682044617274 USING utf8mb4),64,0,46,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc129_before(`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`)VALUES
(71075,7545,3467,1,1,1,0,0),
(71076,7545,3468,0,0,1,1,0),
(71077,7545,3463,1,0,0,0,0),
(71080,7545,17128,0,0,0,0,1),
(71081,7545,17189,0,0,0,0,1),
(71082,7545,17762,0,0,0,0,1),
(71083,7545,17910,0,0,0,0,1),
(71084,7545,66163,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*)INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*)INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe WHERE id=7545 FOR UPDATE;
 IF locked_rows<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC129 recipe missing';END IF;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe_entries WHERE recipe_id=7545 FOR UPDATE;
 IF locked_rows<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC129 target entry multiplicity';END IF;
 IF EXISTS(SELECT 1 FROM rrc129_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC129 recipe drift';END IF;
 IF EXISTS(SELECT 1 FROM rrc129_before e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries WHERE recipe_id=7545)<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC129 old entry/count drift';END IF;
 IF(SELECT COUNT(*)FROM tradeskill_recipe_entries WHERE `recipe_id` <=> 7545 AND `item_id` <=> 3462 AND `successcount` <=> 0 AND `failcount` <=> 0 AND `componentcount` <=> 1 AND `salvagecount` <=> 1 AND `iscontainer` <=> 0)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC129 named kit state mismatch';END IF;
 IF(SELECT COUNT(*)FROM items WHERE `id` <=> 3462 AND BINARY Name=BINARY CONVERT(0x58616b726120746f6f7468 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `races` <=> 0 AND `classes` <=> 0 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC129 native semantics drift';END IF;
 IF(SELECT COUNT(*)FROM items WHERE `id` <=> 3463 AND BINARY Name=BINARY CONVERT(0x58616b726120746f6f74682064617274 USING utf8mb4) AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `races` <=> 13066 AND `classes` <=> 65535 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC129 native semantics drift';END IF;
 IF(SELECT COUNT(*)FROM items WHERE `id` <=> 3467 AND BINARY Name=BINARY CONVERT(0x58616b72612044617274204372616674696e6720546f6f6c USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `races` <=> 0 AND `classes` <=> 0 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC129 native semantics drift';END IF;
 IF(SELECT COUNT(*)FROM items WHERE `id` <=> 3468 AND BINARY Name=BINARY CONVERT(0x4772696d6c696e6720426f6e65205368616674 USING utf8mb4) AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `races` <=> 0 AND `classes` <=> 0 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC129 native semantics drift';END IF;
 IF(SELECT COUNT(*)FROM items WHERE `id` <=> 17128 AND BINARY Name=BINARY CONVERT(0x466569726044616c20466c65746368696e67204b6974 USING utf8mb4) AND `size` <=> 4 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 18 AND `bagslots` <=> 10 AND `bagsize` <=> 3 AND `races` <=> 65544 AND `classes` <=> 65535 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC129 native semantics drift';END IF;
 IF(SELECT COUNT(*)FROM items WHERE `id` <=> 17189 AND BINARY Name=BINARY CONVERT(0x436f6c6c61707369626c6520466c65746368696e67204b6974 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `races` <=> 131071 AND `classes` <=> 65535 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC129 native semantics drift';END IF;
 IF(SELECT COUNT(*)FROM items WHERE `id` <=> 17762 AND BINARY Name=BINARY CONVERT(0x506c616e617220466c65746368696e67204b6974 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `races` <=> 131071 AND `classes` <=> 65535 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC129 native semantics drift';END IF;
 IF(SELECT COUNT(*)FROM items WHERE `id` <=> 17910 AND BINARY Name=BINARY CONVERT(0x466c65746368696e67204b6974 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `races` <=> 131071 AND `classes` <=> 65535 AND `deity` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC129 native semantics drift';END IF;
 IF(SELECT COUNT(*)FROM items WHERE `id` <=> 66163 AND BINARY Name=BINARY CONVERT(0x5375726566616c6c20466c65746368696e67204b6974 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 4 AND `races` <=> 131071 AND `classes` <=> 65535 AND `deity` <=> 128)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC129 native semantics drift';END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=3462 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>7545 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=3 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=3468)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=3467)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=3462)=1)THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC129 selected fullinput collision';END IF;
 INSERT INTO tradeskill_recipe_entries(`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`)VALUES
(7545,3462,0,0,1,1,0);
 SET changed_rows=ROW_COUNT();
 IF changed_rows<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC129 changed-row mismatch';END IF;
 IF EXISTS(SELECT 1 FROM rrc129_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC129 recipe drift';END IF;
 IF EXISTS(SELECT 1 FROM rrc129_before e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries WHERE recipe_id=7545)<>9 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC129 old entry/count drift';END IF;
 IF(SELECT COUNT(*)FROM tradeskill_recipe_entries WHERE `recipe_id` <=> 7545 AND `item_id` <=> 3462 AND `successcount` <=> 0 AND `failcount` <=> 0 AND `componentcount` <=> 1 AND `salvagecount` <=> 1 AND `iscontainer` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC129 named kit state mismatch';END IF;
 IF(SELECT COUNT(*)FROM tradeskill_recipe)<>recipes_before OR(SELECT COUNT(*)FROM tradeskill_recipe_entries)<>entries_before+1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC129 global row-count delta';END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=3462 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>7545 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=3 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=3468)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=3467)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=3462)=1)THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC129 selected fullinput collision';END IF;
 DROP TEMPORARY TABLE rrc129_before;
 DROP TEMPORARY TABLE rrc129_recipes;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC129',changed_rows,recipes_before,(SELECT COUNT(*)FROM tradeskill_recipe),entries_before,(SELECT COUNT(*)FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
