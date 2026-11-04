-- RRC062: six existing entry failure/salvage fields only. Fresh dedicated MariaDB CLI session.
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
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC062 invalid transaction/target'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC062 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC062 InnoDB foundation mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc062_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc062_before LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc062_after LIKE tradeskill_recipe_entries;
 INSERT INTO rrc062_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(1224,CONVERT(0x426c61636b2045787472616374 USING utf8mb4),59,0,36,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(1225,CONVERT(0x426c61636b2045787472616374 USING utf8mb4),59,0,36,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(1226,CONVERT(0x426c61636b2045787472616374 USING utf8mb4),59,0,36,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(1227,CONVERT(0x426c61636b2045787472616374 USING utf8mb4),59,0,36,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(1228,CONVERT(0x426c61636b2045787472616374 USING utf8mb4),59,0,36,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(1398,CONVERT(0x536172636f7363797068612045787472616374 USING utf8mb4),59,0,36,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc062_before (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(9390,1224,10062,0,1,1,0,0),
(9391,1224,13006,0,0,1,1,0),
(9392,1224,22125,0,0,1,1,0),
(9393,1224,22132,1,0,0,0,0),
(9394,1224,17770,0,0,0,0,1),
(9395,1224,17771,0,0,0,0,1),
(9396,1224,17811,0,0,0,0,1),
(9397,1224,17901,0,0,0,0,1),
(9398,1225,10062,0,1,1,0,0),
(9399,1225,13006,0,0,1,1,0),
(9400,1225,22136,0,0,1,1,0),
(9401,1225,22132,1,0,0,0,0),
(9402,1225,17770,0,0,0,0,1),
(9403,1225,17771,0,0,0,0,1),
(9404,1225,17811,0,0,0,0,1),
(9405,1225,17901,0,0,0,0,1),
(9406,1226,10062,0,1,1,0,0),
(9407,1226,13006,0,0,1,1,0),
(9408,1226,22134,0,0,1,1,0),
(9409,1226,22132,1,0,0,0,0),
(9410,1226,17770,0,0,0,0,1),
(9411,1226,17771,0,0,0,0,1),
(9412,1226,17811,0,0,0,0,1),
(9413,1226,17901,0,0,0,0,1),
(9414,1227,10062,0,1,1,0,0),
(9415,1227,13006,0,0,1,1,0),
(9416,1227,22135,0,0,1,1,0),
(9417,1227,22132,1,0,0,0,0),
(9418,1227,17770,0,0,0,0,1),
(9419,1227,17771,0,0,0,0,1),
(9420,1227,17811,0,0,0,0,1),
(9421,1227,17901,0,0,0,0,1),
(9422,1228,10062,0,1,1,0,0),
(9423,1228,13006,0,0,1,1,0),
(9424,1228,22137,0,0,1,1,0),
(9425,1228,22132,1,0,0,0,0),
(9426,1228,17770,0,0,0,0,1),
(9427,1228,17771,0,0,0,0,1),
(9428,1228,17811,0,0,0,0,1),
(9429,1228,17901,0,0,0,0,1),
(10846,1398,10062,0,1,1,0,0),
(10847,1398,13006,0,0,1,1,0),
(10848,1398,22120,0,0,1,1,0),
(10849,1398,22127,1,0,0,0,0),
(10850,1398,17770,0,0,0,0,1),
(10851,1398,17771,0,0,0,0,1),
(10852,1398,17811,0,0,0,0,1),
(10853,1398,17901,0,0,0,0,1);
 INSERT INTO rrc062_after (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(9390,1224,10062,0,0,1,1,0),
(9391,1224,13006,0,0,1,1,0),
(9392,1224,22125,0,0,1,1,0),
(9393,1224,22132,1,0,0,0,0),
(9394,1224,17770,0,0,0,0,1),
(9395,1224,17771,0,0,0,0,1),
(9396,1224,17811,0,0,0,0,1),
(9397,1224,17901,0,0,0,0,1),
(9398,1225,10062,0,0,1,1,0),
(9399,1225,13006,0,0,1,1,0),
(9400,1225,22136,0,0,1,1,0),
(9401,1225,22132,1,0,0,0,0),
(9402,1225,17770,0,0,0,0,1),
(9403,1225,17771,0,0,0,0,1),
(9404,1225,17811,0,0,0,0,1),
(9405,1225,17901,0,0,0,0,1),
(9406,1226,10062,0,0,1,1,0),
(9407,1226,13006,0,0,1,1,0),
(9408,1226,22134,0,0,1,1,0),
(9409,1226,22132,1,0,0,0,0),
(9410,1226,17770,0,0,0,0,1),
(9411,1226,17771,0,0,0,0,1),
(9412,1226,17811,0,0,0,0,1),
(9413,1226,17901,0,0,0,0,1),
(9414,1227,10062,0,0,1,1,0),
(9415,1227,13006,0,0,1,1,0),
(9416,1227,22135,0,0,1,1,0),
(9417,1227,22132,1,0,0,0,0),
(9418,1227,17770,0,0,0,0,1),
(9419,1227,17771,0,0,0,0,1),
(9420,1227,17811,0,0,0,0,1),
(9421,1227,17901,0,0,0,0,1),
(9422,1228,10062,0,0,1,1,0),
(9423,1228,13006,0,0,1,1,0),
(9424,1228,22137,0,0,1,1,0),
(9425,1228,22132,1,0,0,0,0),
(9426,1228,17770,0,0,0,0,1),
(9427,1228,17771,0,0,0,0,1),
(9428,1228,17811,0,0,0,0,1),
(9429,1228,17901,0,0,0,0,1),
(10846,1398,10062,0,0,1,1,0),
(10847,1398,13006,0,0,1,1,0),
(10848,1398,22120,0,0,1,1,0),
(10849,1398,22127,1,0,0,0,0),
(10850,1398,17770,0,0,0,0,1),
(10851,1398,17771,0,0,0,0,1),
(10852,1398,17811,0,0,0,0,1),
(10853,1398,17901,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO locked_rows FROM tradeskill_recipe r JOIN rrc062_recipes e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>6 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC062 recipe missing'; END IF;
 SELECT COUNT(*) INTO locked_rows FROM tradeskill_recipe_entries r JOIN rrc062_before e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>48 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC062 entry missing'; END IF;
 IF EXISTS(SELECT 1 FROM rrc062_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC062 recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc062_before e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc062_recipes p ON p.id=r.recipe_id)<>48 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC062 preimage mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=10062 AND BINARY Name=BINARY CONVERT(0x456d707479205669616c USING utf8mb4))<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC062 empty vial identity mismatch'; END IF;
 UPDATE tradeskill_recipe_entries r JOIN rrc062_after e ON r.id=e.id SET r.failcount=e.failcount,r.salvagecount=e.salvagecount WHERE r.id IN (9390,9398,9406,9414,9422,10846);
 SET changed_rows=ROW_COUNT();
 IF changed_rows<>6 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC062 changed-row count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc062_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC062 recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc062_after e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc062_recipes p ON p.id=r.recipe_id)<>48 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC062 postimage mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC062 table-count mismatch'; END IF;
 DROP TEMPORARY TABLE rrc062_before;
 DROP TEMPORARY TABLE rrc062_after;
 DROP TEMPORARY TABLE rrc062_recipes;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC062',changed_rows,recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe),entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
