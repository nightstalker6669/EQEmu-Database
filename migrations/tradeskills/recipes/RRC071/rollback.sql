-- RRC071: exact two-recipe/eight-container-link transaction. Fresh dedicated CLI session.
DELIMITER //
BEGIN NOT ATOMIC
 DECLARE own_transaction BOOLEAN DEFAULT FALSE;
 DECLARE recipes_before BIGINT DEFAULT 0;
 DECLARE entries_before BIGINT DEFAULT 0;
 DECLARE locked_rows BIGINT DEFAULT 0;
 DECLARE links_changed BIGINT DEFAULT 0;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
  IF own_transaction THEN ROLLBACK; END IF;
  RESIGNAL;
 END;
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC071 invalid target/transaction'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC071 strict mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC071 InnoDB mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc071_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc071_old LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc071_new LIKE tradeskill_recipe_entries;
 INSERT INTO rrc071_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(12240,CONVERT(0x496e6b204f66204465636179 USING utf8mb4),58,0,35,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12244,CONVERT(0x496e6b204f66205472616e73666f726d6174696f6e USING utf8mb4),58,0,35,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc071_old (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(145640,12240,93609,0,0,1,1,0),
(145641,12240,93605,0,0,1,1,0),
(145642,12240,93510,0,0,1,0,0),
(145643,12240,38509,1,0,0,0,0),
(145644,12240,93492,0,0,0,0,1),
(145672,12244,93604,0,0,1,1,0),
(145673,12244,93609,0,0,1,1,0),
(145674,12244,93510,0,0,1,0,0),
(145675,12244,38510,1,0,0,0,0),
(145676,12244,93492,0,0,0,0,1);
 INSERT INTO rrc071_new (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(12240,41555,0,0,0,0,1),
(12240,41631,0,0,0,0,1),
(12240,41632,0,0,0,0,1),
(12240,41633,0,0,0,0,1),
(12244,41555,0,0,0,0,1),
(12244,41631,0,0,0,0,1),
(12244,41632,0,0,0,0,1),
(12244,41633,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO locked_rows FROM tradeskill_recipe r JOIN rrc071_recipes e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC071 missing recipes'; END IF;
 SELECT COUNT(*) INTO locked_rows FROM tradeskill_recipe_entries r JOIN rrc071_old e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>10 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC071 missing old entries'; END IF;
 IF EXISTS(SELECT 1 FROM rrc071_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC071 recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc071_old e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc071_recipes e ON r.recipe_id=e.id)<>18 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC071 old entries drift'; END IF;
 IF (SELECT COUNT(*) FROM rrc071_new e JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC071 new links mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE itemclass=1 AND bagtype=11 AND bagslots=10 AND bagsize=3 AND ((id=41555 AND BINARY Name=BINARY CONVERT(0x546f6d652042696e64696e67204b6974 USING utf8mb4) AND classes=33089) OR (id=41631 AND BINARY Name=BINARY CONVERT(0x5072617965722057726974696e67204b6974 USING utf8mb4) AND classes=16930) OR (id=41632 AND BINARY Name=BINARY CONVERT(0x487962726964205265736561726368204b6974 USING utf8mb4) AND classes=16412) OR (id=41633 AND BINARY Name=BINARY CONVERT(0x536f6e672057726974696e67204b6974 USING utf8mb4) AND classes=128) OR (id=93492 AND BINARY Name=BINARY CONVERT(0x5370656c6c205265736561726368204b6974 USING utf8mb4) AND classes=15360)))<>5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC071 native kit mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE (id=38509 AND BINARY Name=BINARY CONVERT(0x496e6b206f66204465636179 USING utf8mb4) AND size=1) OR (id=38510 AND BINARY Name=BINARY CONVERT(0x496e6b206f66205472616e73666f726d6174696f6e USING utf8mb4) AND size=1) OR (id=93510 AND BINARY Name=BINARY CONVERT(0x5669616c206f662050757265205761746572 USING utf8mb4) AND size=1) OR (id=93604 AND BINARY Name=BINARY CONVERT(0x417a757269746520506f77646572 USING utf8mb4) AND size=0) OR (id=93605 AND BINARY Name=BINARY CONVERT(0x4d65726375727920506f77646572 USING utf8mb4) AND size=0) OR (id=93609 AND BINARY Name=BINARY CONVERT(0x436f616c20506f77646572 USING utf8mb4) AND size=0))<>6 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC071 ingredient identity/size mismatch'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc071_new e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`;
 SET links_changed=ROW_COUNT();
 IF links_changed<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC071 link count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc071_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC071 recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc071_old e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc071_recipes e ON r.recipe_id=e.id)<>10 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC071 old entries drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc071_new e JOIN tradeskill_recipe_entries r ON r.recipe_id=e.recipe_id AND r.item_id=e.item_id AND r.iscontainer=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC071 link collision'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC071 delta mismatch'; END IF;
 DROP TEMPORARY TABLE rrc071_old;
 DROP TEMPORARY TABLE rrc071_new;
 DROP TEMPORARY TABLE rrc071_recipes;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC071',links_changed,recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe),entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
