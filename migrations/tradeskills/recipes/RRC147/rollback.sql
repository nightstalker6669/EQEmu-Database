-- RRC147:Twelve existing trivial fields only; exact selected current preimages required.
DELIMITER //
BEGIN NOT ATOMIC
 DECLARE own_transaction BOOLEAN DEFAULT FALSE;
 DECLARE recipes_before BIGINT DEFAULT 0;
 DECLARE entries_before BIGINT DEFAULT 0;
 DECLARE locked_rows BIGINT DEFAULT 0;
 DECLARE changed_rows BIGINT DEFAULT 0;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN IF own_transaction THEN ROLLBACK;END IF;RESIGNAL;END;
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC147 target/transaction mismatch';END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC147 strict mode required';END IF;
 IF(SELECT COUNT(*)FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE()AND TABLE_NAME IN('tradeskill_recipe','tradeskill_recipe_entries')AND ENGINE='InnoDB')<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC147 InnoDB mismatch';END IF;
 CREATE TEMPORARY TABLE rrc147_before LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc147_after LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc147_entries LIKE tradeskill_recipe_entries;
 INSERT INTO rrc147_before(`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`)VALUES
(4192,CONVERT(0x456c65637472696669656420436f707065722042697473 USING utf8mb4),63,0,28,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(4195,CONVERT(0x456c65637472696669656420436f70706572205374756473 USING utf8mb4),63,0,54,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(4226,CONVERT(0x456e6368616e74656420426172204f662045276369616e20496365 USING utf8mb4),63,0,135,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(4230,CONVERT(0x456e6368616e74656420426172204f662057696e64204d6574616c USING utf8mb4),63,0,135,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(4988,CONVERT(0x496e6675736564204d656469756d205175616c69747920426f6e696e67 USING utf8mb4),63,0,62,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5265,CONVERT(0x4c61726765204d6574616c20436f6e7461696e6572 USING utf8mb4),63,0,46,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5453,CONVERT(0x4d656469756d204d6574616c20436f6e7461696e6572 USING utf8mb4),63,0,41,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5541,CONVERT(0x4e696768746d6172652049726f6e2042697473 USING utf8mb4),63,0,28,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5544,CONVERT(0x4e696768746d6172652049726f6e205374756473 USING utf8mb4),63,0,54,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5977,CONVERT(0x5368656574204f66204d6f6c74656e204f7265 USING utf8mb4),63,0,75,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(6256,CONVERT(0x536d616c6c204d6574616c20436f6e7461696e6572 USING utf8mb4),63,0,31,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(6409,CONVERT(0x537465656c2042697473 USING utf8mb4),63,0,24,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc147_after(`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`)VALUES
(4192,CONVERT(0x456c65637472696669656420436f707065722042697473 USING utf8mb4),63,0,103,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(4195,CONVERT(0x456c65637472696669656420436f70706572205374756473 USING utf8mb4),63,0,118,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(4226,CONVERT(0x456e6368616e74656420426172204f662045276369616e20496365 USING utf8mb4),63,0,165,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(4230,CONVERT(0x456e6368616e74656420426172204f662057696e64204d6574616c USING utf8mb4),63,0,128,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(4988,CONVERT(0x496e6675736564204d656469756d205175616c69747920426f6e696e67 USING utf8mb4),63,0,61,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5265,CONVERT(0x4c61726765204d6574616c20436f6e7461696e6572 USING utf8mb4),63,0,21,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5453,CONVERT(0x4d656469756d204d6574616c20436f6e7461696e6572 USING utf8mb4),63,0,21,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5541,CONVERT(0x4e696768746d6172652049726f6e2042697473 USING utf8mb4),63,0,27,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5544,CONVERT(0x4e696768746d6172652049726f6e205374756473 USING utf8mb4),63,0,108,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5977,CONVERT(0x5368656574204f66204d6f6c74656e204f7265 USING utf8mb4),63,0,95,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(6256,CONVERT(0x536d616c6c204d6574616c20436f6e7461696e6572 USING utf8mb4),63,0,21,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(6409,CONVERT(0x537465656c2042697473 USING utf8mb4),63,0,36,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc147_entries(`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`)VALUES
(41073,4192,7052,1,1,1,0,0),
(41074,4192,29539,0,0,1,1,0),
(41075,4192,29584,3,0,0,0,0),
(41078,4192,17,0,0,0,0,1),
(41104,4195,29584,0,0,3,3,0),
(41105,4195,12011,1,1,1,0,0),
(41106,4195,29533,0,0,1,1,0),
(41107,4195,29578,2,0,0,0,0),
(41110,4195,17,0,0,0,0,1),
(41390,4226,10254,0,0,1,1,0),
(41391,4226,29535,0,0,1,1,0),
(41392,4226,28183,1,0,0,0,0),
(41393,4226,17,0,0,0,0,1),
(41406,4230,10254,0,0,1,1,0),
(41407,4230,29537,0,0,1,1,0),
(41408,4230,28185,1,0,0,0,0),
(41409,4230,17,0,0,0,0,1),
(49249,4988,10467,0,0,1,1,0),
(49250,4988,10489,1,1,1,0,0),
(49251,4988,22568,0,0,1,1,0),
(49252,4988,23542,0,0,1,1,0),
(49254,4988,23679,1,0,0,0,0),
(49256,4988,17,0,0,0,0,1),
(51286,5265,12027,0,0,1,1,0),
(51287,5265,12063,0,0,1,1,0),
(51288,5265,12070,0,0,1,1,0),
(51289,5265,13006,0,0,1,1,0),
(51290,5265,16905,0,0,1,1,0),
(51291,5265,17965,1,0,0,0,0),
(51292,5265,17,0,0,0,0,1),
(52791,5453,12027,0,0,1,1,0),
(52792,5453,12062,0,0,1,1,0),
(52793,5453,12069,0,0,1,1,0),
(52794,5453,13006,0,0,1,1,0),
(52795,5453,16905,0,0,1,1,0),
(52796,5453,17964,1,0,0,0,0),
(52797,5453,17,0,0,0,0,1),
(53541,5541,7052,1,1,1,0,0),
(53542,5541,29538,0,0,1,1,0),
(53543,5541,29583,3,0,0,0,0),
(53546,5541,17,0,0,0,0,1),
(53564,5544,29583,0,0,3,3,0),
(53565,5544,12011,1,1,1,0,0),
(53566,5544,29532,0,0,1,1,0),
(53567,5544,29577,2,0,0,0,0),
(53570,5544,17,0,0,0,0,1),
(58056,5977,29528,0,0,1,1,0),
(58057,5977,29534,0,0,1,1,0),
(58058,5977,29546,1,1,1,0,0),
(58059,5977,29540,2,0,0,0,0),
(58062,5977,17,0,0,0,0,1),
(60426,6256,12027,0,0,1,1,0),
(60427,6256,12061,0,0,1,1,0),
(60428,6256,12068,0,0,1,1,0),
(60429,6256,13006,0,0,1,1,0),
(60430,6256,16905,0,0,1,1,0),
(60431,6256,17963,1,0,0,0,0),
(60432,6256,17,0,0,0,0,1),
(60433,6256,32,0,0,0,0,1),
(60434,6256,33,0,0,0,0,1),
(60435,6256,34,0,0,0,0,1),
(60436,6256,48,0,0,0,0,1),
(61546,6409,12011,1,1,1,0,0),
(61547,6409,66168,0,0,1,1,0),
(61549,6409,66173,1,0,0,0,0),
(61551,6409,17,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*)INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*)INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe r JOIN rrc147_before e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>12 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC147 missing definitions';END IF;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe_entries r JOIN rrc147_entries e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>66 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC147 missing entries';END IF;
 IF EXISTS(SELECT 1 FROM rrc147_before e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC147 definition mismatch';END IF;
 IF EXISTS(SELECT 1 FROM rrc147_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc147_before p ON p.id=r.recipe_id)<>66 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC147 preserved entry mismatch';END IF;
 UPDATE tradeskill_recipe r JOIN rrc147_after e ON r.id=e.id SET r.trivial=e.trivial;
 SET changed_rows=ROW_COUNT();
 IF changed_rows<>12 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC147 changed row mismatch';END IF;
 IF EXISTS(SELECT 1 FROM rrc147_after e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC147 definition mismatch';END IF;
 IF EXISTS(SELECT 1 FROM rrc147_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc147_before p ON p.id=r.recipe_id)<>66 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC147 preserved entry mismatch';END IF;
 IF(SELECT COUNT(*)FROM tradeskill_recipe)<>recipes_before OR(SELECT COUNT(*)FROM tradeskill_recipe_entries)<>entries_before THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC147 row count drift';END IF;
 DROP TEMPORARY TABLE rrc147_before;
 DROP TEMPORARY TABLE rrc147_after;
 DROP TEMPORARY TABLE rrc147_entries;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC147',changed_rows,recipes_before,(SELECT COUNT(*)FROM tradeskill_recipe),entries_before,(SELECT COUNT(*)FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
