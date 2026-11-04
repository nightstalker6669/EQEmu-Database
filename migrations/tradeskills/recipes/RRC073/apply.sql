-- RRC073: exact two-recipe/four-vial-return-link transaction. Fresh dedicated CLI session.
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
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC073 invalid target/transaction'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC073 strict mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC073 InnoDB mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc073_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc073_old LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc073_new LIKE tradeskill_recipe_entries;
 INSERT INTO rrc073_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(12233,CONVERT(0x52756e69632056656c6c756d20536f6c7574696f6e USING utf8mb4),58,0,243,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12239,CONVERT(0x46696e652052756e696320506170657220536f6c7574696f6e USING utf8mb4),58,0,243,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc073_old (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(145510,12233,93508,0,0,1,0,0),
(145511,12233,10030,0,0,2,2,0),
(145512,12233,10024,0,0,1,1,0),
(145513,12233,16503,0,0,1,1,0),
(145514,12233,10035,0,0,1,1,0),
(145515,12233,10025,0,0,1,1,0),
(145516,12233,93509,0,0,1,0,0),
(145517,12233,93510,0,0,1,0,0),
(145518,12233,97850,1,0,0,0,0),
(145519,12233,93492,0,0,0,0,1),
(145520,12233,41555,0,0,0,0,1),
(145521,12233,41631,0,0,0,0,1),
(145522,12233,41632,0,0,0,0,1),
(145523,12233,41633,0,0,0,0,1),
(145624,12239,10022,0,0,1,1,0),
(145625,12239,93508,0,0,1,0,0),
(145626,12239,10029,0,0,1,1,0),
(145627,12239,10033,0,0,1,1,0),
(145628,12239,10030,0,0,1,1,0),
(145629,12239,16503,0,0,1,1,0),
(145630,12239,10035,0,0,1,1,0),
(145631,12239,10032,0,0,1,1,0),
(145632,12239,93509,0,0,1,0,0),
(145633,12239,93510,0,0,1,0,0),
(145634,12239,97856,1,0,0,0,0),
(145635,12239,93492,0,0,0,0,1),
(145636,12239,41555,0,0,0,0,1),
(145637,12239,41631,0,0,0,0,1),
(145638,12239,41632,0,0,0,0,1),
(145639,12239,41633,0,0,0,0,1);
 INSERT INTO rrc073_new (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(12239,10062,1,1,0,0,0),
(12239,93618,2,2,0,0,0),
(12233,10062,1,1,0,0,0),
(12233,93618,2,2,0,0,0);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO locked_rows FROM tradeskill_recipe r JOIN rrc073_recipes e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC073 missing recipes'; END IF;
 SELECT COUNT(*) INTO locked_rows FROM tradeskill_recipe_entries r JOIN rrc073_old e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>30 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC073 missing old entries'; END IF;
 IF EXISTS(SELECT 1 FROM rrc073_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC073 recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc073_old e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc073_recipes e ON r.recipe_id=e.id)<>30 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC073 old entries drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc073_new e JOIN tradeskill_recipe_entries r ON r.recipe_id=e.recipe_id AND r.item_id=e.item_id AND r.iscontainer=e.iscontainer) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC073 link collision'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE itemclass=1 AND bagtype=11 AND bagslots=10 AND bagsize=3 AND ((id=41555 AND BINARY Name=BINARY CONVERT(0x546f6d652042696e64696e67204b6974 USING utf8mb4) AND classes=33089) OR (id=41631 AND BINARY Name=BINARY CONVERT(0x5072617965722057726974696e67204b6974 USING utf8mb4) AND classes=16930) OR (id=41632 AND BINARY Name=BINARY CONVERT(0x487962726964205265736561726368204b6974 USING utf8mb4) AND classes=16412) OR (id=41633 AND BINARY Name=BINARY CONVERT(0x536f6e672057726974696e67204b6974 USING utf8mb4) AND classes=128) OR (id=93492 AND BINARY Name=BINARY CONVERT(0x5370656c6c205265736561726368204b6974 USING utf8mb4) AND classes=15360)))<>5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC073 native kit mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE (id=10022 AND BINARY Name=BINARY CONVERT(0x416d626572 USING utf8mb4) AND size=0) OR (id=10024 AND BINARY Name=BINARY CONVERT(0x506561726c USING utf8mb4) AND size=0) OR (id=10025 AND BINARY Name=BINARY CONVERT(0x546f70617a USING utf8mb4) AND size=0) OR (id=10029 AND BINARY Name=BINARY CONVERT(0x456d6572616c64 USING utf8mb4) AND size=0) OR (id=10030 AND BINARY Name=BINARY CONVERT(0x4f70616c USING utf8mb4) AND size=0) OR (id=10032 AND BINARY Name=BINARY CONVERT(0x537461722052756279 USING utf8mb4) AND size=0) OR (id=10033 AND BINARY Name=BINARY CONVERT(0x4669726520456d6572616c64 USING utf8mb4) AND size=0) OR (id=10035 AND BINARY Name=BINARY CONVERT(0x52756279 USING utf8mb4) AND size=0) OR (id=16503 AND BINARY Name=BINARY CONVERT(0x506c6174696e756d20426172 USING utf8mb4) AND size=1) OR (id=93508 AND BINARY Name=BINARY CONVERT(0x41717561205265676961 USING utf8mb4) AND size=1) OR (id=93509 AND BINARY Name=BINARY CONVERT(0x5669616c206f66204d757269617469632041636964 USING utf8mb4) AND size=1) OR (id=93510 AND BINARY Name=BINARY CONVERT(0x5669616c206f662050757265205761746572 USING utf8mb4) AND size=1) OR (id=97850 AND BINARY Name=BINARY CONVERT(0x52756e69632056656c6c756d20536f6c7574696f6e USING utf8mb4) AND size=1) OR (id=97856 AND BINARY Name=BINARY CONVERT(0x46696e652052756e696320506170657220536f6c7574696f6e USING utf8mb4) AND size=1))<>14 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC073 ingredient identity/size mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE itemclass=0 AND stackable=1 AND maxcharges=0 AND ((id=10062 AND BINARY Name=BINARY CONVERT(0x456d707479205669616c USING utf8mb4)) OR (id=93618 AND BINARY Name=BINARY CONVERT(0x446972747920456d707479205669616c USING utf8mb4))))<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC073 vial identity/quantity mismatch'; END IF;
 INSERT INTO tradeskill_recipe_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) SELECT `recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer` FROM rrc073_new;
 SET links_changed=ROW_COUNT();
 IF links_changed<>4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC073 link count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc073_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC073 recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc073_old e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc073_recipes e ON r.recipe_id=e.id)<>34 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC073 old entries drift'; END IF;
 IF (SELECT COUNT(*) FROM rrc073_new e JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)<>4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC073 new links mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before+4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC073 delta mismatch'; END IF;
 DROP TEMPORARY TABLE rrc073_old;
 DROP TEMPORARY TABLE rrc073_new;
 DROP TEMPORARY TABLE rrc073_recipes;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC073',links_changed,recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe),entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
