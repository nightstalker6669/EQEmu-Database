-- RRC095: four existing ingredient ID fields only; fresh dedicated MariaDB CLI session.
DELIMITER //
BEGIN NOT ATOMIC
 DECLARE own_transaction BOOLEAN DEFAULT FALSE;
 DECLARE recipes_before BIGINT DEFAULT 0;
 DECLARE entries_before BIGINT DEFAULT 0;
 DECLARE locked_rows BIGINT DEFAULT 0;
 DECLARE changed_rows BIGINT DEFAULT 0;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
  IF own_transaction THEN ROLLBACK; END IF;
  RESIGNAL;
 END;
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC095 invalid transaction/target'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC095 strict mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC095 InnoDB mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc095_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc095_before LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc095_after LIKE tradeskill_recipe_entries;
 INSERT INTO rrc095_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(11329,CONVERT(0x5370656c6c3a20526565626f2773204c657373657220436c65616e73696e67 USING utf8mb4),58,0,48,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(11330,CONVERT(0x5370656c6c3a2057756767616e2773204c657373657220446973636f6d626f62756c6174696f6e USING utf8mb4),58,0,48,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(11331,CONVERT(0x5370656c6c3a2057756767616e2773204c6573736572204578747269636174696f6e USING utf8mb4),58,0,48,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(11334,CONVERT(0x5370656c6c3a204d696e6f722053756d6d6f6e696e673a205761746572 USING utf8mb4),58,0,49,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc095_before (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(138844,11329,93555,0,0,1,1,0),
(138845,11329,93587,0,0,1,1,0),
(138846,11329,93539,0,0,1,1,0),
(138847,11329,97768,0,0,1,1,0),
(138848,11329,93516,0,0,1,1,0),
(138849,11329,59690,1,0,0,0,0),
(138850,11329,93492,0,0,0,0,1),
(138851,11330,93555,0,0,1,1,0),
(138852,11330,93589,0,0,1,1,0),
(138853,11330,93539,0,0,1,1,0),
(138854,11330,97768,0,0,1,1,0),
(138855,11330,93526,0,0,1,1,0),
(138856,11330,59672,1,0,0,0,0),
(138857,11330,93492,0,0,0,0,1),
(138858,11331,93555,0,0,1,1,0),
(138859,11331,93587,0,0,1,1,0),
(138860,11331,93539,0,0,1,1,0),
(138861,11331,97768,0,0,1,1,0),
(138862,11331,93526,0,0,1,1,0),
(138863,11331,59684,1,0,0,0,0),
(138864,11331,93492,0,0,0,0,1),
(138879,11334,93557,0,0,1,1,0),
(138880,11334,93542,0,0,1,1,0),
(138881,11334,93559,0,0,1,1,0),
(138882,11334,93583,0,0,1,1,0),
(138883,11334,97768,0,0,1,1,0),
(138884,11334,93515,0,0,1,1,0),
(138885,11334,15336,1,0,0,0,0),
(138886,11334,93492,0,0,0,0,1);
 INSERT INTO rrc095_after (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(138844,11329,93555,0,0,1,1,0),
(138845,11329,93587,0,0,1,1,0),
(138846,11329,93539,0,0,1,1,0),
(138847,11329,97767,0,0,1,1,0),
(138848,11329,93516,0,0,1,1,0),
(138849,11329,59690,1,0,0,0,0),
(138850,11329,93492,0,0,0,0,1),
(138851,11330,93555,0,0,1,1,0),
(138852,11330,93589,0,0,1,1,0),
(138853,11330,93539,0,0,1,1,0),
(138854,11330,97767,0,0,1,1,0),
(138855,11330,93526,0,0,1,1,0),
(138856,11330,59672,1,0,0,0,0),
(138857,11330,93492,0,0,0,0,1),
(138858,11331,93555,0,0,1,1,0),
(138859,11331,93587,0,0,1,1,0),
(138860,11331,93539,0,0,1,1,0),
(138861,11331,97767,0,0,1,1,0),
(138862,11331,93526,0,0,1,1,0),
(138863,11331,59684,1,0,0,0,0),
(138864,11331,93492,0,0,0,0,1),
(138879,11334,93557,0,0,1,1,0),
(138880,11334,93542,0,0,1,1,0),
(138881,11334,93559,0,0,1,1,0),
(138882,11334,93583,0,0,1,1,0),
(138883,11334,97767,0,0,1,1,0),
(138884,11334,93515,0,0,1,1,0),
(138885,11334,15336,1,0,0,0,0),
(138886,11334,93492,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO locked_rows FROM tradeskill_recipe r JOIN rrc095_recipes e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC095 recipe missing'; END IF;
 SELECT COUNT(*) INTO locked_rows FROM tradeskill_recipe_entries r JOIN rrc095_before e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>29 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC095 entry missing'; END IF;
 IF EXISTS(SELECT 1 FROM rrc095_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC095 recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc095_before e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc095_recipes p ON p.id=r.recipe_id)<>29 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC095 preimage mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE (id=97767 AND BINARY Name=BINARY CONVERT(0x536d6f6f746820526f7567682048696465 USING utf8mb4) AND size=1 AND itemclass=0 AND stackable=1 AND maxcharges=0) OR (id=97768 AND BINARY Name=BINARY CONVERT(0x5072697374696e6520526f7567682048696465 USING utf8mb4) AND size=1 AND itemclass=0 AND stackable=1 AND maxcharges=0))<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC095 page identity/size mismatch'; END IF;
 IF(SELECT COUNT(*)FROM items WHERE id=93492 AND itemclass=1 AND bagtype=11 AND bagslots=10 AND bagsize=3 AND classes=15360)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC095 native kit mismatch';END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>11329 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=5 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93555 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93587 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93539 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97767 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93516 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND(k.item_id=i.id OR k.item_id=i.bagtype)WHERE i.itemclass=1 AND(i.id=93492 OR i.bagtype=11)))THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC095 complete input effective kit collision';END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>11330 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=5 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93555 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93589 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93539 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97767 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93526 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND(k.item_id=i.id OR k.item_id=i.bagtype)WHERE i.itemclass=1 AND(i.id=93492 OR i.bagtype=11)))THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC095 complete input effective kit collision';END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>11331 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=5 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93555 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93587 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93539 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97767 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93526 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND(k.item_id=i.id OR k.item_id=i.bagtype)WHERE i.itemclass=1 AND(i.id=93492 OR i.bagtype=11)))THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC095 complete input effective kit collision';END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>11334 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=6 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93557 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93542 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93559 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93583 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97767 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93515 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND(k.item_id=i.id OR k.item_id=i.bagtype)WHERE i.itemclass=1 AND(i.id=93492 OR i.bagtype=11)))THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC095 complete input effective kit collision';END IF;
 UPDATE tradeskill_recipe_entries r JOIN rrc095_after e ON r.id=e.id SET r.item_id=e.item_id WHERE r.id IN (138847,138854,138861,138883);
 SET changed_rows=ROW_COUNT();
 IF changed_rows<>4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC095 changed-row mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc095_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC095 recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc095_after e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc095_recipes p ON p.id=r.recipe_id)<>29 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC095 postimage mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC095 row-count mismatch'; END IF;
 DROP TEMPORARY TABLE rrc095_before;
 DROP TEMPORARY TABLE rrc095_after;
 DROP TEMPORARY TABLE rrc095_recipes;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC095',changed_rows,recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe),entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
