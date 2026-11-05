-- RRC152:Twelve existing trivial fields only; exact selected current preimages required.
DELIMITER //
BEGIN NOT ATOMIC
 DECLARE own_transaction BOOLEAN DEFAULT FALSE;
 DECLARE recipes_before BIGINT DEFAULT 0;
 DECLARE entries_before BIGINT DEFAULT 0;
 DECLARE locked_rows BIGINT DEFAULT 0;
 DECLARE changed_rows BIGINT DEFAULT 0;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN IF own_transaction THEN ROLLBACK;END IF;RESIGNAL;END;
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC152 target/transaction mismatch';END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC152 strict mode required';END IF;
 IF(SELECT COUNT(*)FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE()AND TABLE_NAME IN('tradeskill_recipe','tradeskill_recipe_entries')AND ENGINE='InnoDB')<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC152 InnoDB mismatch';END IF;
 CREATE TEMPORARY TABLE rrc152_before LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc152_after LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc152_entries LIKE tradeskill_recipe_entries;
 INSERT INTO rrc152_before(`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`)VALUES
(3537,CONVERT(0x416372796c696120436861696e2042726163656c6574 USING utf8mb4),63,0,155,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(3539,CONVERT(0x416372796c696120436861696e20436f6966 USING utf8mb4),63,0,206,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(3546,CONVERT(0x416372796c696120436861696e20536b697274 USING utf8mb4),63,0,195,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(3547,CONVERT(0x416372796c696120436861696e20536c6565766573 USING utf8mb4),63,0,202,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5066,CONVERT(0x4c6172676520416372796c696120436861696e2042726163656c6574 USING utf8mb4),63,0,155,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5068,CONVERT(0x4c6172676520416372796c696120436861696e20436f6966 USING utf8mb4),63,0,206,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5074,CONVERT(0x4c6172676520416372796c696120436861696e20536b697274 USING utf8mb4),63,0,195,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5075,CONVERT(0x4c6172676520416372796c696120436861696e20536c6565766573 USING utf8mb4),63,0,202,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(6050,CONVERT(0x536d616c6c20416372796c696120436861696e2042726163656c6574 USING utf8mb4),63,0,155,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(6052,CONVERT(0x536d616c6c20416372796c696120436861696e20436f6966 USING utf8mb4),63,0,206,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(6058,CONVERT(0x536d616c6c20416372796c696120436861696e20536b697274 USING utf8mb4),63,0,195,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(6059,CONVERT(0x536d616c6c20416372796c696120436861696e20536c6565766573 USING utf8mb4),63,0,202,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc152_after(`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`)VALUES
(3537,CONVERT(0x416372796c696120436861696e2042726163656c6574 USING utf8mb4),63,0,156,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(3539,CONVERT(0x416372796c696120436861696e20436f6966 USING utf8mb4),63,0,205,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(3546,CONVERT(0x416372796c696120436861696e20536b697274 USING utf8mb4),63,0,194,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(3547,CONVERT(0x416372796c696120436861696e20536c6565766573 USING utf8mb4),63,0,203,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5066,CONVERT(0x4c6172676520416372796c696120436861696e2042726163656c6574 USING utf8mb4),63,0,156,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5068,CONVERT(0x4c6172676520416372796c696120436861696e20436f6966 USING utf8mb4),63,0,205,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5074,CONVERT(0x4c6172676520416372796c696120436861696e20536b697274 USING utf8mb4),63,0,194,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5075,CONVERT(0x4c6172676520416372796c696120436861696e20536c6565766573 USING utf8mb4),63,0,203,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(6050,CONVERT(0x536d616c6c20416372796c696120436861696e2042726163656c6574 USING utf8mb4),63,0,156,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(6052,CONVERT(0x536d616c6c20416372796c696120436861696e20436f6966 USING utf8mb4),63,0,205,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(6058,CONVERT(0x536d616c6c20416372796c696120436861696e20536b697274 USING utf8mb4),63,0,194,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(6059,CONVERT(0x536d616c6c20416372796c696120436861696e20536c6565766573 USING utf8mb4),63,0,203,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc152_entries(`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`)VALUES
(36314,3537,6095,0,0,1,1,0),
(36315,3537,11397,1,1,1,0,0),
(36316,3537,11590,0,0,1,1,0),
(36317,3537,22041,0,0,1,1,0),
(36319,3537,22473,1,0,0,0,0),
(36321,3537,17,0,0,0,0,1),
(36330,3539,6095,0,0,2,2,0),
(36331,3539,11397,1,1,1,0,0),
(36332,3539,11590,0,0,1,1,0),
(36333,3539,22033,0,0,1,1,0),
(36335,3539,22465,1,0,0,0,0),
(36337,3539,17,0,0,0,0,1),
(36388,3546,6095,0,0,2,2,0),
(36389,3546,11397,1,1,1,0,0),
(36390,3546,11590,0,0,1,1,0),
(36391,3546,22039,0,0,1,1,0),
(36393,3546,22471,1,0,0,0,0),
(36395,3546,17,0,0,0,0,1),
(36396,3547,6095,0,0,2,2,0),
(36397,3547,11397,1,1,1,0,0),
(36398,3547,11590,0,0,1,1,0),
(36399,3547,22040,0,0,1,1,0),
(36401,3547,22472,1,0,0,0,0),
(36403,3547,17,0,0,0,0,1),
(49694,5066,6095,0,0,1,1,0),
(49695,5066,11397,1,1,1,0,0),
(49696,5066,11590,0,0,1,1,0),
(49697,5066,22220,0,0,1,1,0),
(49699,5066,22497,1,0,0,0,0),
(49701,5066,17,0,0,0,0,1),
(49710,5068,6095,0,0,2,2,0),
(49711,5068,11397,1,1,1,0,0),
(49712,5068,11590,0,0,1,1,0),
(49713,5068,22212,0,0,1,1,0),
(49715,5068,22489,1,0,0,0,0),
(49717,5068,17,0,0,0,0,1),
(49758,5074,6095,0,0,2,2,0),
(49759,5074,11397,1,1,1,0,0),
(49760,5074,11590,0,0,1,1,0),
(49761,5074,22218,0,0,1,1,0),
(49763,5074,22495,1,0,0,0,0),
(49765,5074,17,0,0,0,0,1),
(49766,5075,6095,0,0,2,2,0),
(49767,5075,11397,1,1,1,0,0),
(49768,5075,11590,0,0,1,1,0),
(49769,5075,22219,0,0,1,1,0),
(49771,5075,22496,1,0,0,0,0),
(49773,5075,17,0,0,0,0,1),
(58551,6050,6095,0,0,1,1,0),
(58552,6050,11397,1,1,1,0,0),
(58553,6050,11590,0,0,1,1,0),
(58554,6050,22208,0,0,1,1,0),
(58556,6050,22485,1,0,0,0,0),
(58558,6050,17,0,0,0,0,1),
(58567,6052,6095,0,0,2,2,0),
(58568,6052,11397,1,1,1,0,0),
(58569,6052,11590,0,0,1,1,0),
(58570,6052,22200,0,0,1,1,0),
(58572,6052,22477,1,0,0,0,0),
(58574,6052,17,0,0,0,0,1),
(58615,6058,6095,0,0,2,2,0),
(58616,6058,11397,1,1,1,0,0),
(58617,6058,11590,0,0,1,1,0),
(58618,6058,22206,0,0,1,1,0),
(58620,6058,22483,1,0,0,0,0),
(58622,6058,17,0,0,0,0,1),
(58623,6059,6095,0,0,2,2,0),
(58624,6059,11397,1,1,1,0,0),
(58625,6059,11590,0,0,1,1,0),
(58626,6059,22207,0,0,1,1,0),
(58628,6059,22484,1,0,0,0,0),
(58630,6059,17,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*)INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*)INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe r JOIN rrc152_before e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>12 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC152 missing definitions';END IF;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe_entries r JOIN rrc152_entries e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>72 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC152 missing entries';END IF;
 IF EXISTS(SELECT 1 FROM rrc152_before e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC152 definition mismatch';END IF;
 IF EXISTS(SELECT 1 FROM rrc152_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc152_before p ON p.id=r.recipe_id)<>72 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC152 preserved entry mismatch';END IF;
 UPDATE tradeskill_recipe r JOIN rrc152_after e ON r.id=e.id SET r.trivial=e.trivial;
 SET changed_rows=ROW_COUNT();
 IF changed_rows<>12 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC152 changed row mismatch';END IF;
 IF EXISTS(SELECT 1 FROM rrc152_after e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC152 definition mismatch';END IF;
 IF EXISTS(SELECT 1 FROM rrc152_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc152_before p ON p.id=r.recipe_id)<>72 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC152 preserved entry mismatch';END IF;
 IF(SELECT COUNT(*)FROM tradeskill_recipe)<>recipes_before OR(SELECT COUNT(*)FROM tradeskill_recipe_entries)<>entries_before THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC152 row count drift';END IF;
 DROP TEMPORARY TABLE rrc152_before;
 DROP TEMPORARY TABLE rrc152_after;
 DROP TEMPORARY TABLE rrc152_entries;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC152',changed_rows,recipes_before,(SELECT COUNT(*)FROM tradeskill_recipe),entries_before,(SELECT COUNT(*)FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
