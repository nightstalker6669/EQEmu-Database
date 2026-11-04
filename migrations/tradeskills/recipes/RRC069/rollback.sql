-- RRC069: exact four-recipe/sixteen-container-link transaction. Fresh dedicated CLI session.
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
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC069 invalid target/transaction'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC069 strict mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC069 InnoDB mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc069_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc069_old LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc069_new LIKE tradeskill_recipe_entries;
 INSERT INTO rrc069_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(12745,CONVERT(0x53696d706c65205175696c6c USING utf8mb4),58,0,31,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(12746,CONVERT(0x53696d706c6520426f6f6b2042696e64696e67 USING utf8mb4),58,0,46,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(12747,CONVERT(0x53696d706c6520496e6b USING utf8mb4),58,0,38,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(12748,CONVERT(0x53696d706c6520426c616e6b20426f6f6b USING utf8mb4),58,0,54,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc069_old (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(149772,12745,98296,0,0,1,1,0),
(149773,12745,98297,1,1,1,0,0),
(149774,12745,98292,1,0,0,0,0),
(149777,12745,93492,0,0,0,0,1),
(149778,12746,98299,0,0,1,1,0),
(149779,12746,98300,0,0,1,1,0),
(149780,12746,98301,0,0,1,1,0),
(149781,12746,98294,1,0,0,0,0),
(149782,12746,93492,0,0,0,0,1),
(149783,12747,98256,0,0,1,1,0),
(149784,12747,98298,0,0,1,1,0),
(149785,12747,58145,0,0,1,1,0),
(149786,12747,98293,1,0,0,0,0),
(149787,12747,93492,0,0,0,0,1),
(149788,12748,98294,0,0,1,1,0),
(149789,12748,98302,0,0,1,1,0),
(149790,12748,98303,0,0,1,1,0),
(149791,12748,98295,1,0,0,0,0),
(149792,12748,93492,0,0,0,0,1);
 INSERT INTO rrc069_new (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(12745,41555,0,0,0,0,1),
(12745,41631,0,0,0,0,1),
(12745,41632,0,0,0,0,1),
(12745,41633,0,0,0,0,1),
(12746,41555,0,0,0,0,1),
(12746,41631,0,0,0,0,1),
(12746,41632,0,0,0,0,1),
(12746,41633,0,0,0,0,1),
(12747,41555,0,0,0,0,1),
(12747,41631,0,0,0,0,1),
(12747,41632,0,0,0,0,1),
(12747,41633,0,0,0,0,1),
(12748,41555,0,0,0,0,1),
(12748,41631,0,0,0,0,1),
(12748,41632,0,0,0,0,1),
(12748,41633,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO locked_rows FROM tradeskill_recipe r JOIN rrc069_recipes e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC069 missing recipes'; END IF;
 SELECT COUNT(*) INTO locked_rows FROM tradeskill_recipe_entries r JOIN rrc069_old e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>19 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC069 missing old entries'; END IF;
 IF EXISTS(SELECT 1 FROM rrc069_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC069 recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc069_old e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc069_recipes e ON r.recipe_id=e.id)<>35 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC069 old entries drift'; END IF;
 IF (SELECT COUNT(*) FROM rrc069_new e JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)<>16 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC069 new links mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE itemclass=1 AND bagtype=11 AND bagslots=10 AND bagsize=3 AND ((id=41555 AND BINARY Name=BINARY CONVERT(0x546f6d652042696e64696e67204b6974 USING utf8mb4) AND classes=33089) OR (id=41631 AND BINARY Name=BINARY CONVERT(0x5072617965722057726974696e67204b6974 USING utf8mb4) AND classes=16930) OR (id=41632 AND BINARY Name=BINARY CONVERT(0x487962726964205265736561726368204b6974 USING utf8mb4) AND classes=16412) OR (id=41633 AND BINARY Name=BINARY CONVERT(0x536f6e672057726974696e67204b6974 USING utf8mb4) AND classes=128) OR (id=93492 AND BINARY Name=BINARY CONVERT(0x5370656c6c205265736561726368204b6974 USING utf8mb4) AND classes=15360)))<>5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC069 native kit mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE (id=58145 AND BINARY Name=BINARY CONVERT(0x537175696420496e6b USING utf8mb4) AND size=1) OR (id=98256 AND BINARY Name=BINARY CONVERT(0x466c61736b206f66205075726966696564205761746572 USING utf8mb4) AND size=1) OR (id=98292 AND BINARY Name=BINARY CONVERT(0x53696d706c65205175696c6c USING utf8mb4) AND size=0) OR (id=98293 AND BINARY Name=BINARY CONVERT(0x53696d706c6520496e6b USING utf8mb4) AND size=0) OR (id=98294 AND BINARY Name=BINARY CONVERT(0x53696d706c6520426f6f6b2042696e64696e67 USING utf8mb4) AND size=0) OR (id=98295 AND BINARY Name=BINARY CONVERT(0x53696d706c6520426c616e6b20426f6f6b USING utf8mb4) AND size=0) OR (id=98296 AND BINARY Name=BINARY CONVERT(0x506c61696e20466c696768742046656174686572 USING utf8mb4) AND size=0) OR (id=98297 AND BINARY Name=BINARY CONVERT(0x53696d706c65205175696c6c2043757474696e6720546f6f6c USING utf8mb4) AND size=0) OR (id=98298 AND BINARY Name=BINARY CONVERT(0x53696d706c6520496e6b20426f74746c65 USING utf8mb4) AND size=0) OR (id=98299 AND BINARY Name=BINARY CONVERT(0x53696d706c6520426f6f6b2042696e64696e67204c656174686572 USING utf8mb4) AND size=0) OR (id=98300 AND BINARY Name=BINARY CONVERT(0x53696d706c6520426f6f6b2042696e64696e67204c696e696e67 USING utf8mb4) AND size=0) OR (id=98301 AND BINARY Name=BINARY CONVERT(0x53696d706c6520476c7565 USING utf8mb4) AND size=0) OR (id=98302 AND BINARY Name=BINARY CONVERT(0x53696d706c6520426f6f6b2042696e64696e6720476c7565 USING utf8mb4) AND size=0) OR (id=98303 AND BINARY Name=BINARY CONVERT(0x537461636b206f6620426c616e6b205061676573 USING utf8mb4) AND size=0))<>14 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC069 ingredient identity/size mismatch'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc069_new e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`;
 SET links_changed=ROW_COUNT();
 IF links_changed<>16 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC069 link count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc069_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC069 recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc069_old e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc069_recipes e ON r.recipe_id=e.id)<>19 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC069 old entries drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc069_new e JOIN tradeskill_recipe_entries r ON r.recipe_id=e.recipe_id AND r.item_id=e.item_id AND r.iscontainer=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC069 link collision'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-16 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC069 delta mismatch'; END IF;
 DROP TEMPORARY TABLE rrc069_old;
 DROP TEMPORARY TABLE rrc069_new;
 DROP TEMPORARY TABLE rrc069_recipes;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC069',links_changed,recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe),entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
