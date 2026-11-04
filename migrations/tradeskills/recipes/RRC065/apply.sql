-- RRC065: single explicit alternative-container link, dedicated fresh MariaDB CLI session.
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
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC065 invalid target/transaction'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC065 strict mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC065 InnoDB foundation mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc065_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc065_old LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc065_new LIKE tradeskill_recipe_entries;
 INSERT INTO rrc065_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(232,CONVERT(0x437275736865642057696e6473746f6e65 USING utf8mb4),56,0,15,1,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc065_old (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(1693,232,10223,0,0,2,2,0),
(1694,232,10227,1,0,0,0,0),
(1695,232,17139,0,0,0,0,1),
(1696,232,17190,0,0,0,0,1),
(1697,232,17904,0,0,0,0,1);
 INSERT INTO rrc065_new (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(232,17149,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO locked_rows FROM tradeskill_recipe r JOIN rrc065_recipes e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC065 recipe missing'; END IF;
 SELECT COUNT(*) INTO locked_rows FROM tradeskill_recipe_entries r JOIN rrc065_old e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC065 old entry missing'; END IF;
 IF EXISTS(SELECT 1 FROM rrc065_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC065 recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc065_old e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries WHERE recipe_id=232)<>5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC065 old entries mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries WHERE recipe_id=232 AND item_id=17149 AND iscontainer=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC065 link collision'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=17149 AND BINARY Name=BINARY CONVERT(0x436f6666696e20506f69736f6e20426f74746c65 USING utf8mb4) AND itemclass=1 AND bagtype=12 AND bagslots=10 AND bagsize=2)<>1 OR (SELECT COUNT(*) FROM items WHERE id=10223 AND BINARY Name=BINARY CONVERT(0x57696e6473746f6e65 USING utf8mb4) AND size=0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC065 native container/ingredient mismatch'; END IF;
 INSERT INTO tradeskill_recipe_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) SELECT `recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer` FROM rrc065_new;
 SET links_changed=ROW_COUNT();
 IF links_changed<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC065 link count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc065_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC065 recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc065_old e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries WHERE recipe_id=232)<>6 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC065 old entries mismatch'; END IF;
 IF (SELECT COUNT(*) FROM rrc065_new e JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC065 new link mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before+1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC065 count delta mismatch'; END IF;
 DROP TEMPORARY TABLE rrc065_old;
 DROP TEMPORARY TABLE rrc065_new;
 DROP TEMPORARY TABLE rrc065_recipes;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC065',links_changed,recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe),entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
