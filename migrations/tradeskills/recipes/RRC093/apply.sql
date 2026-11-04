-- RRC093: exact one-recipe/one-missing-ingredient transaction. Fresh dedicated CLI session.
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
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC093 invalid target/transaction'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC093 strict mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC093 InnoDB mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc093_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc093_old LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc093_new LIKE tradeskill_recipe_entries;
 INSERT INTO rrc093_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(12743,CONVERT(0x5370656c6c3a204261726b20417420546865204d6f6f6e20526b2e204969 USING utf8mb4),58,0,418,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc093_old (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(149754,12743,93557,0,0,1,1,0),
(149755,12743,97824,0,0,1,1,0),
(149756,12743,93587,0,0,1,1,0),
(149757,12743,93583,0,0,2,2,0),
(149758,12743,93578,0,0,2,2,0),
(149759,12743,93521,0,0,1,1,0),
(149760,12743,79412,1,0,0,0,0),
(149761,12743,93492,0,0,0,0,1);
 INSERT INTO rrc093_new (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(12743,93542,0,0,1,1,0);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO locked_rows FROM tradeskill_recipe r JOIN rrc093_recipes e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC093 missing recipes'; END IF;
 SELECT COUNT(*) INTO locked_rows FROM tradeskill_recipe_entries r JOIN rrc093_old e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC093 missing old entries'; END IF;
 IF EXISTS(SELECT 1 FROM rrc093_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC093 recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc093_old e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc093_recipes e ON r.recipe_id=e.id)<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC093 old entries drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc093_new e JOIN tradeskill_recipe_entries r ON r.recipe_id=e.recipe_id AND r.item_id=e.item_id AND r.iscontainer=e.iscontainer) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC093 link collision'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE itemclass=1 AND bagtype=11 AND bagslots=10 AND bagsize=3 AND ((id=93492 AND BINARY Name=BINARY CONVERT(0x5370656c6c205265736561726368204b6974 USING utf8mb4) AND classes=15360)))<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC093 native kit mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE (id=79412 AND BINARY Name=BINARY CONVERT(0x5370656c6c3a204261726b20617420746865204d6f6f6e20526b2e204949 USING utf8mb4) AND size=1) OR (id=93521 AND BINARY Name=BINARY CONVERT(0x5175696c6c206f662074686520466572616c204c6f7264 USING utf8mb4) AND size=1) OR (id=93542 AND BINARY Name=BINARY CONVERT(0x496e6b204164646974697665206f6620746865204e616d656c657373 USING utf8mb4) AND size=0) OR (id=93557 AND BINARY Name=BINARY CONVERT(0x436f6e6a7572696e6720546869636b656e6572 USING utf8mb4) AND size=0) OR (id=93578 AND BINARY Name=BINARY CONVERT(0x496e6b206f66205a656b USING utf8mb4) AND size=1) OR (id=93583 AND BINARY Name=BINARY CONVERT(0x496e6b206f662074686520436f6d70616e696f6e USING utf8mb4) AND size=1) OR (id=93587 AND BINARY Name=BINARY CONVERT(0x496e6b206f66205061696e USING utf8mb4) AND size=1) OR (id=97824 AND BINARY Name=BINARY CONVERT(0x46696e652052756e6963205061706572 USING utf8mb4) AND size=1))<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC093 ingredient identity/size mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE itemclass=0 AND stackable=1 AND maxcharges=0 AND ((id=93542 AND BINARY Name=BINARY CONVERT(0x496e6b204164646974697665206f6620746865204e616d656c657373 USING utf8mb4))))<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC093 additive identity/quantity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>12743 AND (SELECT SUM(e.componentcount) FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=9 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93557 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97824 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93587 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93583 AND e.componentcount=2) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93578 AND e.componentcount=2) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93521 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93542 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND (k.item_id=i.id OR k.item_id=i.bagtype) WHERE i.itemclass=1 AND (i.id=93492 OR i.bagtype=11))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC093 complete input effective-kit collision'; END IF;
 INSERT INTO tradeskill_recipe_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) SELECT `recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer` FROM rrc093_new;
 SET links_changed=ROW_COUNT();
 IF links_changed<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC093 link count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc093_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC093 recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc093_old e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc093_recipes e ON r.recipe_id=e.id)<>9 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC093 old entries drift'; END IF;
 IF (SELECT COUNT(*) FROM rrc093_new e JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC093 new links mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before+1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC093 delta mismatch'; END IF;
 DROP TEMPORARY TABLE rrc093_old;
 DROP TEMPORARY TABLE rrc093_new;
 DROP TEMPORARY TABLE rrc093_recipes;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC093',links_changed,recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe),entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
