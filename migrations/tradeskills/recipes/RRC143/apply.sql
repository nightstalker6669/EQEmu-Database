-- RRC143: one existing output yield field only. Fresh dedicated strict MariaDB session.
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
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC143 target/transaction mismatch'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC143 strict mode required'; END IF;
 IF(SELECT COUNT(*)FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE()AND TABLE_NAME IN('tradeskill_recipe','tradeskill_recipe_entries','items')AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC143 InnoDB mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc143_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc143_before LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc143_after LIKE tradeskill_recipe_entries;
 INSERT INTO rrc143_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(488,CONVERT(0x506f7274696f6e204f6620496e6675736564204461726b204d6174746572 USING utf8mb4),57,0,16,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(489,CONVERT(0x506f7274696f6e204f6620496e6675736564204461726b204d6174746572 USING utf8mb4),57,0,16,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(490,CONVERT(0x506f7274696f6e204f6620496e6675736564204461726b204d6174746572 USING utf8mb4),57,0,16,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc143_before (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3802,488,62492,0,0,5,5,0),
(3803,488,62500,5,0,0,0,0),
(3804,488,17276,0,0,0,0,1),
(3805,488,17877,0,0,0,0,1),
(3806,488,17902,0,0,0,0,1),
(3807,489,58244,0,0,1,1,0),
(3808,489,62500,2,0,0,0,0),
(3809,489,17276,0,0,0,0,1),
(3810,489,17877,0,0,0,0,1),
(3811,489,17902,0,0,0,0,1),
(3812,490,58244,0,0,1,1,0),
(3813,490,62500,2,0,0,0,0),
(3814,490,17276,0,0,0,0,1),
(3815,490,17877,0,0,0,0,1),
(3816,490,17902,0,0,0,0,1);
 INSERT INTO rrc143_after (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3802,488,62492,0,0,5,5,0),
(3803,488,62500,1,0,0,0,0),
(3804,488,17276,0,0,0,0,1),
(3805,488,17877,0,0,0,0,1),
(3806,488,17902,0,0,0,0,1),
(3807,489,58244,0,0,1,1,0),
(3808,489,62500,2,0,0,0,0),
(3809,489,17276,0,0,0,0,1),
(3810,489,17877,0,0,0,0,1),
(3811,489,17902,0,0,0,0,1),
(3812,490,58244,0,0,1,1,0),
(3813,490,62500,2,0,0,0,0),
(3814,490,17276,0,0,0,0,1),
(3815,490,17877,0,0,0,0,1),
(3816,490,17902,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*)INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*)INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe r JOIN rrc143_recipes e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC143 definition/peer missing'; END IF;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe_entries r JOIN rrc143_before e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>15 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC143 target/peer entries missing'; END IF;
 IF EXISTS(SELECT 1 FROM rrc143_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC143 definition/peer drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc143_before e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc143_recipes p ON p.id=r.recipe_id)<>15 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC143 preimage mismatch'; END IF;
 IF(SELECT COUNT(*)FROM items WHERE (`id` <=> 17276 AND BINARY Name=BINARY CONVERT(0x436f6c6c61707369626c6520546f6f6c626f78 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 10 AND `bagslots` <=> 8 AND `bagsize` <=> 4 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> -1 AND `filename` <=> '' AND `booktype` <=> 0) OR (`id` <=> 17877 AND BINARY Name=BINARY CONVERT(0x44656c75786520546f6f6c626f78 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 10 AND `bagslots` <=> 10 AND `bagsize` <=> 4 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0) OR (`id` <=> 17902 AND BINARY Name=BINARY CONVERT(0x546f6f6c626f78 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 10 AND `bagslots` <=> 8 AND `bagsize` <=> 4 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0) OR (`id` <=> 58244 AND BINARY Name=BINARY CONVERT(0x496e6675736564204461726b204d6174746572 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0) OR (`id` <=> 62492 AND BINARY Name=BINARY CONVERT(0x477261696e206f6620496e6675736564204461726b204d6174746572 USING utf8mb4) AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0) OR (`id` <=> 62500 AND BINARY Name=BINARY CONVERT(0x506f7274696f6e206f6620496e6675736564204461726b204d6174746572 USING utf8mb4) AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0))<>6 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC143 native item identity/range drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.item_id=62500 AND e.successcount>0 AND e.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc143_recipes r WHERE r.id=e.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC143 producer universe drift';END IF;
 UPDATE tradeskill_recipe_entries r JOIN rrc143_after e ON r.id=e.id SET r.successcount=e.successcount WHERE r.id IN(3803);
 SET changed_rows=ROW_COUNT();
 IF changed_rows<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC143 changed-row mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc143_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC143 definition/peer drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc143_after e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc143_recipes p ON p.id=r.recipe_id)<>15 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC143 postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.item_id=62500 AND e.successcount>0 AND e.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc143_recipes r WHERE r.id=e.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC143 producer universe drift';END IF;
 IF(SELECT COUNT(*)FROM tradeskill_recipe)<>recipes_before OR(SELECT COUNT(*)FROM tradeskill_recipe_entries)<>entries_before THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC143 global row-count drift'; END IF;
 DROP TEMPORARY TABLE rrc143_before;
 DROP TEMPORARY TABLE rrc143_after;
 DROP TEMPORARY TABLE rrc143_recipes;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC143',changed_rows,recipes_before,(SELECT COUNT(*)FROM tradeskill_recipe),entries_before,(SELECT COUNT(*)FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
