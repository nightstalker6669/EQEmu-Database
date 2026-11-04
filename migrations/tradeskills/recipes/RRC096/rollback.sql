-- RRC096: five existing ingredient ID fields only; fresh dedicated MariaDB CLI session.
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
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC096 invalid transaction/target'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC096 strict mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC096 InnoDB mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc096_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc096_before LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc096_after LIKE tradeskill_recipe_entries;
 INSERT INTO rrc096_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(11326,CONVERT(0x5370656c6c3a20496f6e792773204c657373657220436c65616e73696e67 USING utf8mb4),58,0,48,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(11327,CONVERT(0x5370656c6c3a20496f6e792773204c65737365722045786f726369736d USING utf8mb4),58,0,48,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(11328,CONVERT(0x5370656c6c3a2050726f6a656374204c696768746e696e67 USING utf8mb4),58,0,48,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(11332,CONVERT(0x5370656c6c3a2058616c6972696c616e2773204c657373657220446973636f6d626f62756c6174696f6e USING utf8mb4),58,0,48,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(11333,CONVERT(0x5370656c6c3a2058616c6972696c616e2773204c6573736572204578747269636174696f6e USING utf8mb4),58,0,48,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc096_before (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(138823,11326,93555,0,0,1,1,0),
(138824,11326,93587,0,0,1,1,0),
(138825,11326,93539,0,0,1,1,0),
(138826,11326,97768,0,0,1,1,0),
(138827,11326,93518,0,0,1,1,0),
(138828,11326,59687,1,0,0,0,0),
(138829,11326,93492,0,0,0,0,1),
(138830,11327,93555,0,0,1,1,0),
(138831,11327,93589,0,0,1,1,0),
(138832,11327,93539,0,0,1,1,0),
(138833,11327,97768,0,0,1,1,0),
(138834,11327,93518,0,0,1,1,0),
(138835,11327,59675,1,0,0,0,0),
(138836,11327,93492,0,0,0,0,1),
(138837,11328,93546,0,0,1,1,0),
(138838,11328,93587,0,0,1,1,0),
(138839,11328,93539,0,0,1,1,0),
(138840,11328,97768,0,0,1,1,0),
(138841,11328,93517,0,0,1,1,0),
(138842,11328,16318,1,0,0,0,0),
(138843,11328,93492,0,0,0,0,1),
(138865,11332,93555,0,0,1,1,0),
(138866,11332,93589,0,0,1,1,0),
(138867,11332,93539,0,0,1,1,0),
(138868,11332,97768,0,0,1,1,0),
(138869,11332,93517,0,0,1,1,0),
(138870,11332,59669,1,0,0,0,0),
(138871,11332,93492,0,0,0,0,1),
(138872,11333,93555,0,0,1,1,0),
(138873,11333,93587,0,0,1,1,0),
(138874,11333,93539,0,0,1,1,0),
(138875,11333,97768,0,0,1,1,0),
(138876,11333,93517,0,0,1,1,0),
(138877,11333,59681,1,0,0,0,0),
(138878,11333,93492,0,0,0,0,1);
 INSERT INTO rrc096_after (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(138823,11326,93555,0,0,1,1,0),
(138824,11326,93587,0,0,1,1,0),
(138825,11326,93539,0,0,1,1,0),
(138826,11326,97767,0,0,1,1,0),
(138827,11326,93518,0,0,1,1,0),
(138828,11326,59687,1,0,0,0,0),
(138829,11326,93492,0,0,0,0,1),
(138830,11327,93555,0,0,1,1,0),
(138831,11327,93589,0,0,1,1,0),
(138832,11327,93539,0,0,1,1,0),
(138833,11327,97767,0,0,1,1,0),
(138834,11327,93518,0,0,1,1,0),
(138835,11327,59675,1,0,0,0,0),
(138836,11327,93492,0,0,0,0,1),
(138837,11328,93546,0,0,1,1,0),
(138838,11328,93587,0,0,1,1,0),
(138839,11328,93539,0,0,1,1,0),
(138840,11328,97767,0,0,1,1,0),
(138841,11328,93517,0,0,1,1,0),
(138842,11328,16318,1,0,0,0,0),
(138843,11328,93492,0,0,0,0,1),
(138865,11332,93555,0,0,1,1,0),
(138866,11332,93589,0,0,1,1,0),
(138867,11332,93539,0,0,1,1,0),
(138868,11332,97767,0,0,1,1,0),
(138869,11332,93517,0,0,1,1,0),
(138870,11332,59669,1,0,0,0,0),
(138871,11332,93492,0,0,0,0,1),
(138872,11333,93555,0,0,1,1,0),
(138873,11333,93587,0,0,1,1,0),
(138874,11333,93539,0,0,1,1,0),
(138875,11333,97767,0,0,1,1,0),
(138876,11333,93517,0,0,1,1,0),
(138877,11333,59681,1,0,0,0,0),
(138878,11333,93492,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO locked_rows FROM tradeskill_recipe r JOIN rrc096_recipes e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC096 recipe missing'; END IF;
 SELECT COUNT(*) INTO locked_rows FROM tradeskill_recipe_entries r JOIN rrc096_before e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>35 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC096 entry missing'; END IF;
 IF EXISTS(SELECT 1 FROM rrc096_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC096 recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc096_before e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc096_recipes p ON p.id=r.recipe_id)<>35 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC096 preimage mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE (id=97767 AND BINARY Name=BINARY CONVERT(0x536d6f6f746820526f7567682048696465 USING utf8mb4) AND size=1 AND itemclass=0 AND stackable=1 AND maxcharges=0) OR (id=97768 AND BINARY Name=BINARY CONVERT(0x5072697374696e6520526f7567682048696465 USING utf8mb4) AND size=1 AND itemclass=0 AND stackable=1 AND maxcharges=0))<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC096 page identity/size mismatch'; END IF;
 IF(SELECT COUNT(*)FROM items WHERE id=93492 AND itemclass=1 AND bagtype=11 AND bagslots=10 AND bagsize=3 AND classes=15360)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC096 native kit mismatch';END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>11326 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=5 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93555 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93587 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93539 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97767 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93518 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND(k.item_id=i.id OR k.item_id=i.bagtype)WHERE i.itemclass=1 AND(i.id=93492 OR i.bagtype=11)))THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC096 complete input effective kit collision';END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>11327 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=5 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93555 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93589 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93539 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97767 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93518 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND(k.item_id=i.id OR k.item_id=i.bagtype)WHERE i.itemclass=1 AND(i.id=93492 OR i.bagtype=11)))THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC096 complete input effective kit collision';END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>11328 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=5 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93546 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93587 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93539 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97767 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93517 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND(k.item_id=i.id OR k.item_id=i.bagtype)WHERE i.itemclass=1 AND(i.id=93492 OR i.bagtype=11)))THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC096 complete input effective kit collision';END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>11332 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=5 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93555 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93589 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93539 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97767 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93517 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND(k.item_id=i.id OR k.item_id=i.bagtype)WHERE i.itemclass=1 AND(i.id=93492 OR i.bagtype=11)))THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC096 complete input effective kit collision';END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>11333 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=5 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93555 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93587 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93539 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97767 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93517 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND(k.item_id=i.id OR k.item_id=i.bagtype)WHERE i.itemclass=1 AND(i.id=93492 OR i.bagtype=11)))THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC096 complete input effective kit collision';END IF;
 UPDATE tradeskill_recipe_entries r JOIN rrc096_after e ON r.id=e.id SET r.item_id=e.item_id WHERE r.id IN (138826,138833,138840,138868,138875);
 SET changed_rows=ROW_COUNT();
 IF changed_rows<>5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC096 changed-row mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc096_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC096 recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc096_after e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc096_recipes p ON p.id=r.recipe_id)<>35 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC096 postimage mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC096 row-count mismatch'; END IF;
 DROP TEMPORARY TABLE rrc096_before;
 DROP TEMPORARY TABLE rrc096_after;
 DROP TEMPORARY TABLE rrc096_recipes;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC096',changed_rows,recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe),entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
