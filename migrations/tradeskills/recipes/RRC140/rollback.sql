-- RRC140:Ten existing trivial fields only; exact selected current preimages required.
DELIMITER //
BEGIN NOT ATOMIC
 DECLARE own_transaction BOOLEAN DEFAULT FALSE;
 DECLARE recipes_before BIGINT DEFAULT 0;
 DECLARE entries_before BIGINT DEFAULT 0;
 DECLARE locked_rows BIGINT DEFAULT 0;
 DECLARE changed_rows BIGINT DEFAULT 0;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN IF own_transaction THEN ROLLBACK;END IF;RESIGNAL;END;
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC140 target/transaction mismatch';END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC140 strict mode required';END IF;
 IF(SELECT COUNT(*)FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE()AND TABLE_NAME IN('tradeskill_recipe','tradeskill_recipe_entries')AND ENGINE='InnoDB')<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC140 InnoDB mismatch';END IF;
 CREATE TEMPORARY TABLE rrc140_before LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc140_after LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc140_entries LIKE tradeskill_recipe_entries;
 INSERT INTO rrc140_before(`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`)VALUES
(357,CONVERT(0x436c6f636b776f726b204f6273657276657220427265617374706c617465 USING utf8mb4),57,0,302,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(365,CONVERT(0x436c6f636b776f726b204f627365727665722048656c6d USING utf8mb4),57,0,302,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(364,CONVERT(0x436c6f636b776f726b204f627365727665722048656c6d USING utf8mb4),57,0,302,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(370,CONVERT(0x436c6f636b776f726b20536861646f7777616c6b657220426f6f7473 USING utf8mb4),57,0,302,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(373,CONVERT(0x436c6f636b776f726b20536861646f7777616c6b65722042726163656c6574 USING utf8mb4),57,0,302,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(376,CONVERT(0x436c6f636b776f726b20536861646f7777616c6b657220436f6966 USING utf8mb4),57,0,302,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(379,CONVERT(0x436c6f636b776f726b20536861646f7777616c6b657220476c6f766573 USING utf8mb4),57,0,302,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(382,CONVERT(0x436c6f636b776f726b20536861646f7777616c6b6572204c656767696e6773 USING utf8mb4),57,0,302,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(385,CONVERT(0x436c6f636b776f726b20536861646f7777616c6b657220536c6565766573 USING utf8mb4),57,0,302,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(388,CONVERT(0x436c6f636b776f726b20536861646f7777616c6b65722054756e6963 USING utf8mb4),57,0,302,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc140_after(`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`)VALUES
(357,CONVERT(0x436c6f636b776f726b204f6273657276657220427265617374706c617465 USING utf8mb4),57,0,275,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(365,CONVERT(0x436c6f636b776f726b204f627365727665722048656c6d USING utf8mb4),57,0,275,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(364,CONVERT(0x436c6f636b776f726b204f627365727665722048656c6d USING utf8mb4),57,0,275,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(370,CONVERT(0x436c6f636b776f726b20536861646f7777616c6b657220426f6f7473 USING utf8mb4),57,0,275,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(373,CONVERT(0x436c6f636b776f726b20536861646f7777616c6b65722042726163656c6574 USING utf8mb4),57,0,275,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(376,CONVERT(0x436c6f636b776f726b20536861646f7777616c6b657220436f6966 USING utf8mb4),57,0,275,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(379,CONVERT(0x436c6f636b776f726b20536861646f7777616c6b657220476c6f766573 USING utf8mb4),57,0,275,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(382,CONVERT(0x436c6f636b776f726b20536861646f7777616c6b6572204c656767696e6773 USING utf8mb4),57,0,275,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(385,CONVERT(0x436c6f636b776f726b20536861646f7777616c6b657220536c6565766573 USING utf8mb4),57,0,275,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(388,CONVERT(0x436c6f636b776f726b20536861646f7777616c6b65722054756e6963 USING utf8mb4),57,0,275,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc140_entries(`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`)VALUES
(2760,357,65430,0,0,3,3,0),
(2761,357,22027,0,0,1,1,0),
(2762,357,22551,0,0,1,1,0),
(2763,357,29507,0,0,1,1,0),
(2764,357,65429,0,0,1,1,0),
(2765,357,65440,1,0,0,0,0),
(2766,357,17276,0,0,0,0,1),
(2767,357,17877,0,0,0,0,1),
(2768,357,17902,0,0,0,0,1),
(2832,364,65430,0,0,2,2,0),
(2833,364,22021,0,0,1,1,0),
(2834,364,22551,0,0,1,1,0),
(2835,364,29506,0,0,1,1,0),
(2836,364,65429,0,0,1,1,0),
(2837,364,65439,1,0,0,0,0),
(2838,364,17276,0,0,0,0,1),
(2839,364,17877,0,0,0,0,1),
(2840,364,17902,0,0,0,0,1),
(2841,365,65430,0,0,2,2,0),
(2842,365,22021,0,0,1,1,0),
(2843,365,22506,0,0,1,1,0),
(2844,365,29506,0,0,1,1,0),
(2845,365,65429,0,0,1,1,0),
(2846,365,65439,1,0,0,0,0),
(2847,365,17276,0,0,0,0,1),
(2848,365,17877,0,0,0,0,1),
(2849,365,17902,0,0,0,0,1),
(2880,370,22211,0,0,1,1,0),
(2881,370,22551,0,0,1,1,0),
(2882,370,29512,0,0,1,1,0),
(2883,370,65429,0,0,1,1,0),
(2884,370,65430,0,0,1,1,0),
(2885,370,65438,1,0,0,0,0),
(2886,370,17276,0,0,0,0,1),
(2887,370,17877,0,0,0,0,1),
(2888,370,17902,0,0,0,0,1),
(2904,373,22208,0,0,1,1,0),
(2905,373,22551,0,0,1,1,0),
(2906,373,29509,0,0,1,1,0),
(2907,373,65429,0,0,1,1,0),
(2908,373,65430,0,0,1,1,0),
(2909,373,65435,1,0,0,0,0),
(2910,373,17276,0,0,0,0,1),
(2911,373,17877,0,0,0,0,1),
(2912,373,17902,0,0,0,0,1),
(2928,376,65430,0,0,2,2,0),
(2929,376,22200,0,0,1,1,0),
(2930,376,22551,0,0,1,1,0),
(2931,376,29506,0,0,1,1,0),
(2932,376,65429,0,0,1,1,0),
(2933,376,65432,1,0,0,0,0),
(2934,376,17276,0,0,0,0,1),
(2935,376,17877,0,0,0,0,1),
(2936,376,17902,0,0,0,0,1),
(2952,379,65430,0,0,2,2,0),
(2953,379,22209,0,0,1,1,0),
(2954,379,22551,0,0,1,1,0),
(2955,379,29510,0,0,1,1,0),
(2956,379,65429,0,0,1,1,0),
(2957,379,65436,1,0,0,0,0),
(2958,379,17276,0,0,0,0,1),
(2959,379,17877,0,0,0,0,1),
(2960,379,17902,0,0,0,0,1),
(2976,382,65430,0,0,3,3,0),
(2977,382,22210,0,0,1,1,0),
(2978,382,22551,0,0,1,1,0),
(2979,382,29511,0,0,1,1,0),
(2980,382,65429,0,0,1,1,0),
(2981,382,65437,1,0,0,0,0),
(2982,382,17276,0,0,0,0,1),
(2983,382,17877,0,0,0,0,1),
(2984,382,17902,0,0,0,0,1),
(3000,385,65430,0,0,3,3,0),
(3001,385,22207,0,0,1,1,0),
(3002,385,22551,0,0,1,1,0),
(3003,385,29508,0,0,1,1,0),
(3004,385,65429,0,0,1,1,0),
(3005,385,65434,1,0,0,0,0),
(3006,385,17276,0,0,0,0,1),
(3007,385,17877,0,0,0,0,1),
(3008,385,17902,0,0,0,0,1),
(3024,388,65430,0,0,3,3,0),
(3025,388,22203,0,0,1,1,0),
(3026,388,22551,0,0,1,1,0),
(3027,388,29507,0,0,1,1,0),
(3028,388,65429,0,0,1,1,0),
(3029,388,65433,1,0,0,0,0),
(3030,388,17276,0,0,0,0,1),
(3031,388,17877,0,0,0,0,1),
(3032,388,17902,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*)INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*)INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe r JOIN rrc140_before e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>10 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC140 missing definitions';END IF;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe_entries r JOIN rrc140_entries e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>90 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC140 missing entries';END IF;
 IF EXISTS(SELECT 1 FROM rrc140_before e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC140 definition mismatch';END IF;
 IF EXISTS(SELECT 1 FROM rrc140_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc140_before p ON p.id=r.recipe_id)<>90 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC140 preserved entry mismatch';END IF;
 UPDATE tradeskill_recipe r JOIN rrc140_after e ON r.id=e.id SET r.trivial=e.trivial;
 SET changed_rows=ROW_COUNT();
 IF changed_rows<>10 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC140 changed row mismatch';END IF;
 IF EXISTS(SELECT 1 FROM rrc140_after e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC140 definition mismatch';END IF;
 IF EXISTS(SELECT 1 FROM rrc140_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc140_before p ON p.id=r.recipe_id)<>90 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC140 preserved entry mismatch';END IF;
 IF(SELECT COUNT(*)FROM tradeskill_recipe)<>recipes_before OR(SELECT COUNT(*)FROM tradeskill_recipe_entries)<>entries_before THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC140 row count drift';END IF;
 DROP TEMPORARY TABLE rrc140_before;
 DROP TEMPORARY TABLE rrc140_after;
 DROP TEMPORARY TABLE rrc140_entries;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC140',changed_rows,recipes_before,(SELECT COUNT(*)FROM tradeskill_recipe),entries_before,(SELECT COUNT(*)FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
