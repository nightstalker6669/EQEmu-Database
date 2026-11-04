-- RRC075: two existing ingredient IDs only; fresh dedicated MariaDB CLI session.
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
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC075 invalid transaction/target'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC075 strict mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC075 InnoDB mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc075_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc075_before LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc075_after LIKE tradeskill_recipe_entries;
 INSERT INTO rrc075_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(518,CONVERT(0x4172676c69205363726962656420537761746368 USING utf8mb4),58,0,142,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(947,CONVERT(0x566973616765205363726962656420537761746368 USING utf8mb4),58,0,142,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc075_before (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(4088,518,13051,0,0,1,1,0),
(4089,518,13063,0,0,1,1,0),
(4090,518,65411,0,0,1,1,0),
(4091,518,65137,1,0,0,0,0),
(4092,518,24,0,0,0,0,1),
(4093,518,25,0,0,0,0,1),
(4094,518,26,0,0,0,0,1),
(4095,518,27,0,0,0,0,1),
(4096,518,17500,0,0,0,0,1),
(4097,518,17501,0,0,0,0,1),
(4098,518,17502,0,0,0,0,1),
(4099,518,17652,0,0,0,0,1),
(4100,518,17653,0,0,0,0,1),
(4101,518,17654,0,0,0,0,1),
(4102,518,17655,0,0,0,0,1),
(4103,518,17903,0,0,0,0,1),
(8211,947,13051,0,0,1,1,0),
(8212,947,13063,0,0,1,1,0),
(8213,947,65413,0,0,1,1,0),
(8214,947,65159,1,0,0,0,0),
(8215,947,24,0,0,0,0,1),
(8216,947,25,0,0,0,0,1),
(8217,947,26,0,0,0,0,1),
(8218,947,27,0,0,0,0,1),
(8219,947,17500,0,0,0,0,1),
(8220,947,17501,0,0,0,0,1),
(8221,947,17502,0,0,0,0,1),
(8222,947,17652,0,0,0,0,1),
(8223,947,17653,0,0,0,0,1),
(8224,947,17654,0,0,0,0,1),
(8225,947,17655,0,0,0,0,1),
(8226,947,17903,0,0,0,0,1),
(135849,518,93492,0,0,0,0,1),
(135878,947,93492,0,0,0,0,1);
 INSERT INTO rrc075_after (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(4088,518,13051,0,0,1,1,0),
(4089,518,13063,0,0,1,1,0),
(4090,518,65410,0,0,1,1,0),
(4091,518,65137,1,0,0,0,0),
(4092,518,24,0,0,0,0,1),
(4093,518,25,0,0,0,0,1),
(4094,518,26,0,0,0,0,1),
(4095,518,27,0,0,0,0,1),
(4096,518,17500,0,0,0,0,1),
(4097,518,17501,0,0,0,0,1),
(4098,518,17502,0,0,0,0,1),
(4099,518,17652,0,0,0,0,1),
(4100,518,17653,0,0,0,0,1),
(4101,518,17654,0,0,0,0,1),
(4102,518,17655,0,0,0,0,1),
(4103,518,17903,0,0,0,0,1),
(8211,947,13051,0,0,1,1,0),
(8212,947,13063,0,0,1,1,0),
(8213,947,65412,0,0,1,1,0),
(8214,947,65159,1,0,0,0,0),
(8215,947,24,0,0,0,0,1),
(8216,947,25,0,0,0,0,1),
(8217,947,26,0,0,0,0,1),
(8218,947,27,0,0,0,0,1),
(8219,947,17500,0,0,0,0,1),
(8220,947,17501,0,0,0,0,1),
(8221,947,17502,0,0,0,0,1),
(8222,947,17652,0,0,0,0,1),
(8223,947,17653,0,0,0,0,1),
(8224,947,17654,0,0,0,0,1),
(8225,947,17655,0,0,0,0,1),
(8226,947,17903,0,0,0,0,1),
(135849,518,93492,0,0,0,0,1),
(135878,947,93492,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO locked_rows FROM tradeskill_recipe r JOIN rrc075_recipes e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC075 recipe missing'; END IF;
 SELECT COUNT(*) INTO locked_rows FROM tradeskill_recipe_entries r JOIN rrc075_before e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>34 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC075 entry missing'; END IF;
 IF EXISTS(SELECT 1 FROM rrc075_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC075 recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc075_before e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc075_recipes p ON p.id=r.recipe_id)<>34 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC075 preimage mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE (id=65410 AND BINARY Name=BINARY CONVERT(0x50617274206f66205961657468277320436f6d70656e6469756d2050672e203733 USING utf8mb4) AND size=0 AND itemclass=0 AND stackable=1 AND maxcharges=0) OR (id=65411 AND BINARY Name=BINARY CONVERT(0x50617274206f66205961657468277320436f6d70656e6469756d2050672e203733 USING utf8mb4) AND size=0 AND itemclass=0 AND stackable=1 AND maxcharges=0) OR (id=65412 AND BINARY Name=BINARY CONVERT(0x50617274206f66205961657468277320436f6d70656e6469756d2050672e203738 USING utf8mb4) AND size=0 AND itemclass=0 AND stackable=1 AND maxcharges=0) OR (id=65413 AND BINARY Name=BINARY CONVERT(0x50617274206f66205961657468277320436f6d70656e6469756d2050672e203738 USING utf8mb4) AND size=0 AND itemclass=0 AND stackable=1 AND maxcharges=0))<>4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC075 page identity/size mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries seed JOIN tradeskill_recipe r ON r.id=seed.recipe_id WHERE r.enabled=1 AND r.id<>518 AND seed.item_id=65410 AND seed.componentcount=1 AND seed.iscontainer=0 AND (SELECT SUM(e.componentcount) FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=3 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.item_id=13051 AND e.componentcount=1 AND e.iscontainer=0) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.item_id=13063 AND e.componentcount=1 AND e.iscontainer=0) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND (k.item_id=i.id OR k.item_id=i.bagtype) WHERE i.itemclass=1 AND (i.id IN (24,25,26,27,17500,17501,17502,17652,17653,17654,17655,17903,93492) OR i.bagtype IN (24,25,26,27,17500,17501,17502,17652,17653,17654,17655,17903,93492)))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC075 exact-input effective-kit collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries seed JOIN tradeskill_recipe r ON r.id=seed.recipe_id WHERE r.enabled=1 AND r.id<>947 AND seed.item_id=65412 AND seed.componentcount=1 AND seed.iscontainer=0 AND (SELECT SUM(e.componentcount) FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=3 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.item_id=13051 AND e.componentcount=1 AND e.iscontainer=0) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.item_id=13063 AND e.componentcount=1 AND e.iscontainer=0) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND (k.item_id=i.id OR k.item_id=i.bagtype) WHERE i.itemclass=1 AND (i.id IN (24,25,26,27,17500,17501,17502,17652,17653,17654,17655,17903,93492) OR i.bagtype IN (24,25,26,27,17500,17501,17502,17652,17653,17654,17655,17903,93492)))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC075 exact-input effective-kit collision'; END IF;
 UPDATE tradeskill_recipe_entries r JOIN rrc075_after e ON r.id=e.id SET r.item_id=e.item_id WHERE r.id IN (4090,8213);
 SET changed_rows=ROW_COUNT();
 IF changed_rows<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC075 changed-row mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc075_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC075 recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc075_after e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc075_recipes p ON p.id=r.recipe_id)<>34 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC075 postimage mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC075 row-count mismatch'; END IF;
 DROP TEMPORARY TABLE rrc075_before;
 DROP TEMPORARY TABLE rrc075_after;
 DROP TEMPORARY TABLE rrc075_recipes;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC075',changed_rows,recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe),entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
