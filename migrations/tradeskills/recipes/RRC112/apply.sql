-- RRC112: five existing output IDs only. Fresh dedicated strict MariaDB session.
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
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC112 target/transaction mismatch'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC112 strict mode required'; END IF;
 IF(SELECT COUNT(*)FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE()AND TABLE_NAME IN('tradeskill_recipe','tradeskill_recipe_entries','items')AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC112 InnoDB mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc112_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc112_before LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc112_after LIKE tradeskill_recipe_entries;
 INSERT INTO rrc112_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(7259,CONVERT(0x436c617373203620447261676f726e2053696c76657220546970204172726f7720286c6172676529 USING utf8mb4),64,0,228,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7348,CONVERT(0x526f7567682042617a7520426f6e65205265637572766520426f77 USING utf8mb4),64,0,268,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7450,CONVERT(0x5368617065642042617a7520426f6e6520312d63616d20426f77 USING utf8mb4),64,0,282,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7451,CONVERT(0x5368617065642042617a7520426f6e6520436f6d706f756e6420426f77 USING utf8mb4),64,0,302,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7452,CONVERT(0x5368617065642042617a7520426f6e65205265637572766520426f77 USING utf8mb4),64,0,268,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc112_before (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(68614,7259,8050,0,0,1,1,0),
(68615,7259,8057,0,0,1,1,0),
(68616,7259,8069,0,0,1,1,0),
(68617,7259,72092,0,0,1,1,0),
(68618,7259,75583,10,0,0,0,0),
(68619,7259,17128,0,0,0,0,1),
(68620,7259,17189,0,0,0,0,1),
(68621,7259,17762,0,0,0,0,1),
(68622,7259,17910,0,0,0,0,1),
(68623,7259,66163,0,0,0,0,1),
(69411,7348,72094,0,0,1,1,0),
(69412,7348,72095,0,0,1,1,0),
(69413,7348,75665,1,0,0,0,0),
(69414,7348,17128,0,0,0,0,1),
(69415,7348,17189,0,0,0,0,1),
(69416,7348,17762,0,0,0,0,1),
(69417,7348,17910,0,0,0,0,1),
(69418,7348,66163,0,0,0,0,1),
(70246,7450,8086,1,1,1,0,0),
(70247,7450,8087,0,0,1,1,0),
(70248,7450,72094,0,0,1,1,0),
(70249,7450,72095,0,0,1,1,0),
(70251,7450,75685,1,0,0,0,0),
(70252,7450,17128,0,0,0,0,1),
(70253,7450,17189,0,0,0,0,1),
(70254,7450,17762,0,0,0,0,1),
(70255,7450,17910,0,0,0,0,1),
(70256,7450,66163,0,0,0,0,1),
(70257,7451,8087,0,0,2,2,0),
(70258,7451,8086,1,1,1,0,0),
(70259,7451,72094,0,0,1,1,0),
(70260,7451,72095,0,0,1,1,0),
(70262,7451,75698,1,0,0,0,0),
(70263,7451,17128,0,0,0,0,1),
(70264,7451,17189,0,0,0,0,1),
(70265,7451,17762,0,0,0,0,1),
(70266,7451,17910,0,0,0,0,1),
(70267,7451,66163,0,0,0,0,1),
(70268,7452,8086,1,1,1,0,0),
(70269,7452,72094,0,0,1,1,0),
(70270,7452,72095,0,0,1,1,0),
(70272,7452,75673,1,0,0,0,0),
(70274,7452,17128,0,0,0,0,1),
(70275,7452,17189,0,0,0,0,1),
(70276,7452,17762,0,0,0,0,1),
(70277,7452,17910,0,0,0,0,1),
(70278,7452,66163,0,0,0,0,1);
 INSERT INTO rrc112_after (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(68614,7259,8050,0,0,1,1,0),
(68615,7259,8057,0,0,1,1,0),
(68616,7259,8069,0,0,1,1,0),
(68617,7259,72092,0,0,1,1,0),
(68618,7259,75581,10,0,0,0,0),
(68619,7259,17128,0,0,0,0,1),
(68620,7259,17189,0,0,0,0,1),
(68621,7259,17762,0,0,0,0,1),
(68622,7259,17910,0,0,0,0,1),
(68623,7259,66163,0,0,0,0,1),
(69411,7348,72094,0,0,1,1,0),
(69412,7348,72095,0,0,1,1,0),
(69413,7348,75668,1,0,0,0,0),
(69414,7348,17128,0,0,0,0,1),
(69415,7348,17189,0,0,0,0,1),
(69416,7348,17762,0,0,0,0,1),
(69417,7348,17910,0,0,0,0,1),
(69418,7348,66163,0,0,0,0,1),
(70246,7450,8086,1,1,1,0,0),
(70247,7450,8087,0,0,1,1,0),
(70248,7450,72094,0,0,1,1,0),
(70249,7450,72095,0,0,1,1,0),
(70251,7450,75688,1,0,0,0,0),
(70252,7450,17128,0,0,0,0,1),
(70253,7450,17189,0,0,0,0,1),
(70254,7450,17762,0,0,0,0,1),
(70255,7450,17910,0,0,0,0,1),
(70256,7450,66163,0,0,0,0,1),
(70257,7451,8087,0,0,2,2,0),
(70258,7451,8086,1,1,1,0,0),
(70259,7451,72094,0,0,1,1,0),
(70260,7451,72095,0,0,1,1,0),
(70262,7451,75700,1,0,0,0,0),
(70263,7451,17128,0,0,0,0,1),
(70264,7451,17189,0,0,0,0,1),
(70265,7451,17762,0,0,0,0,1),
(70266,7451,17910,0,0,0,0,1),
(70267,7451,66163,0,0,0,0,1),
(70268,7452,8086,1,1,1,0,0),
(70269,7452,72094,0,0,1,1,0),
(70270,7452,72095,0,0,1,1,0),
(70272,7452,75676,1,0,0,0,0),
(70274,7452,17128,0,0,0,0,1),
(70275,7452,17189,0,0,0,0,1),
(70276,7452,17762,0,0,0,0,1),
(70277,7452,17910,0,0,0,0,1),
(70278,7452,66163,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*)INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*)INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe r JOIN rrc112_recipes e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC112 definition/peer missing'; END IF;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe_entries r JOIN rrc112_before e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>47 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC112 target/peer entries missing'; END IF;
 IF EXISTS(SELECT 1 FROM rrc112_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC112 definition/peer drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc112_before e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc112_recipes p ON p.id=r.recipe_id)<>47 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC112 preimage mismatch'; END IF;
 IF(SELECT COUNT(*)FROM items WHERE (`id` <=> 75581 AND BINARY Name=BINARY CONVERT(0x434c415353203620447261676f726e2053696c76657220546970204172726f77 USING utf8mb4) AND `itemclass` <=> 0 AND `itemtype` <=> 27 AND `damage` <=> 9 AND `delay` <=> 0 AND `range` <=> 50 AND `size` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `classes` <=> 285 AND `races` <=> 65535 AND `slots` <=> 4194304 AND `reqlevel` <=> 0 AND `reclevel` <=> 0) OR (`id` <=> 75583 AND BINARY Name=BINARY CONVERT(0x434c415353203620447261676f726e2053696c76657220546970204172726f77 USING utf8mb4) AND `itemclass` <=> 0 AND `itemtype` <=> 27 AND `damage` <=> 9 AND `delay` <=> 0 AND `range` <=> 100 AND `size` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `classes` <=> 285 AND `races` <=> 65535 AND `slots` <=> 4194304 AND `reqlevel` <=> 0 AND `reclevel` <=> 0) OR (`id` <=> 75665 AND BINARY Name=BINARY CONVERT(0x526f7567682042617a7520426f6e65205265637572766520426f77 USING utf8mb4) AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `damage` <=> 30 AND `delay` <=> 64 AND `range` <=> 150 AND `size` <=> 3 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `classes` <=> 285 AND `races` <=> 65535 AND `slots` <=> 2048 AND `reqlevel` <=> 0 AND `reclevel` <=> 0) OR (`id` <=> 75668 AND BINARY Name=BINARY CONVERT(0x526f7567682042617a7520426f6e65205265637572766520426f77 USING utf8mb4) AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `damage` <=> 28 AND `delay` <=> 52 AND `range` <=> 150 AND `size` <=> 3 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `classes` <=> 285 AND `races` <=> 65535 AND `slots` <=> 2048 AND `reqlevel` <=> 0 AND `reclevel` <=> 0) OR (`id` <=> 75673 AND BINARY Name=BINARY CONVERT(0x5368617065642042617a7520426f6e65205265637572766520426f77 USING utf8mb4) AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `damage` <=> 28 AND `delay` <=> 55 AND `range` <=> 150 AND `size` <=> 3 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `classes` <=> 285 AND `races` <=> 65535 AND `slots` <=> 2048 AND `reqlevel` <=> 0 AND `reclevel` <=> 0) OR (`id` <=> 75676 AND BINARY Name=BINARY CONVERT(0x5368617065642042617a7520426f6e65205265637572766520426f77 USING utf8mb4) AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `damage` <=> 26 AND `delay` <=> 43 AND `range` <=> 150 AND `size` <=> 3 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `classes` <=> 285 AND `races` <=> 65535 AND `slots` <=> 2048 AND `reqlevel` <=> 0 AND `reclevel` <=> 0) OR (`id` <=> 75685 AND BINARY Name=BINARY CONVERT(0x5368617065642042617a7520426f6e6520312d43616d20426f77 USING utf8mb4) AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `damage` <=> 27 AND `delay` <=> 50 AND `range` <=> 175 AND `size` <=> 3 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `classes` <=> 285 AND `races` <=> 65535 AND `slots` <=> 2048 AND `reqlevel` <=> 0 AND `reclevel` <=> 0) OR (`id` <=> 75688 AND BINARY Name=BINARY CONVERT(0x5368617065642042617a7520426f6e6520312d43616d20426f77 USING utf8mb4) AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `damage` <=> 25 AND `delay` <=> 38 AND `range` <=> 175 AND `size` <=> 3 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `classes` <=> 285 AND `races` <=> 65535 AND `slots` <=> 2048 AND `reqlevel` <=> 0 AND `reclevel` <=> 0) OR (`id` <=> 75698 AND BINARY Name=BINARY CONVERT(0x5368617065642042617a7520426f6e6520436f6d706f756e6420426f77 USING utf8mb4) AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `damage` <=> 25 AND `delay` <=> 41 AND `range` <=> 200 AND `size` <=> 3 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `classes` <=> 285 AND `races` <=> 65535 AND `slots` <=> 2048 AND `reqlevel` <=> 0 AND `reclevel` <=> 0) OR (`id` <=> 75700 AND BINARY Name=BINARY CONVERT(0x5368617065642042617a7520426f6e6520436f6d706f756e6420426f77 USING utf8mb4) AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `damage` <=> 24 AND `delay` <=> 33 AND `range` <=> 200 AND `size` <=> 3 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `classes` <=> 285 AND `races` <=> 65535 AND `slots` <=> 2048 AND `reqlevel` <=> 0 AND `reclevel` <=> 0))<>10 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC112 native item identity/range drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.iscontainer=0 AND e.successcount>e.componentcount AND e.item_id IN(75581,75583,75665,75668,75673,75676,75685,75688,75698,75700)AND NOT EXISTS(SELECT 1 FROM rrc112_recipes p WHERE p.id=e.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC112 output-producer universe drift'; END IF;
 UPDATE tradeskill_recipe_entries r JOIN rrc112_after e ON r.id=e.id SET r.item_id=e.item_id WHERE r.id IN(68618,69413,70251,70262,70272);
 SET changed_rows=ROW_COUNT();
 IF changed_rows<>5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC112 changed-row mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc112_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC112 definition/peer drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc112_after e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc112_recipes p ON p.id=r.recipe_id)<>47 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC112 postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.iscontainer=0 AND e.successcount>e.componentcount AND e.item_id IN(75581,75583,75665,75668,75673,75676,75685,75688,75698,75700)AND NOT EXISTS(SELECT 1 FROM rrc112_recipes p WHERE p.id=e.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC112 output-producer universe drift'; END IF;
 IF(SELECT COUNT(*)FROM tradeskill_recipe)<>recipes_before OR(SELECT COUNT(*)FROM tradeskill_recipe_entries)<>entries_before THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC112 global row-count drift'; END IF;
 DROP TEMPORARY TABLE rrc112_before;
 DROP TEMPORARY TABLE rrc112_after;
 DROP TEMPORARY TABLE rrc112_recipes;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC112',changed_rows,recipes_before,(SELECT COUNT(*)FROM tradeskill_recipe),entries_before,(SELECT COUNT(*)FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
