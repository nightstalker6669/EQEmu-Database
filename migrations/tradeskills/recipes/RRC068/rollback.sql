-- RRC068: four explicit alternative-container links, dedicated fresh MariaDB CLI session.
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
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC068 invalid target/transaction'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC068 strict mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC068 InnoDB foundation mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc068_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc068_old LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc068_new LIKE tradeskill_recipe_entries;
 INSERT INTO rrc068_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(302,CONVERT(0x53696d706c6520436f6e7461637420506f69736f6e USING utf8mb4),56,0,46,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(303,CONVERT(0x53696d706c6520496e6a656374656420506f69736f6e USING utf8mb4),56,0,54,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(304,CONVERT(0x53696d706c6520536f6c76656e74 USING utf8mb4),56,0,38,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(305,CONVERT(0x53696d706c6520556e6976657273616c2053757370656e73696f6e USING utf8mb4),56,0,31,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc068_old (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(2286,302,58063,0,0,1,1,0),
(2287,302,58169,0,0,1,1,0),
(2288,302,58093,1,0,0,0,0),
(2289,302,17190,0,0,0,0,1),
(2290,302,17904,0,0,0,0,1),
(2291,303,58062,0,0,1,1,0),
(2292,303,58168,0,0,1,1,0),
(2293,303,58097,1,0,0,0,0),
(2294,303,17190,0,0,0,0,1),
(2295,303,17904,0,0,0,0,1),
(2320,304,58060,0,0,1,1,0),
(2321,304,58167,0,0,1,1,0),
(2322,304,58122,1,0,0,0,0),
(2323,304,17190,0,0,0,0,1),
(2324,304,17904,0,0,0,0,1),
(2325,305,58128,0,0,1,1,0),
(2326,305,58167,0,0,1,1,0),
(2327,305,58130,1,0,0,0,0),
(2328,305,17190,0,0,0,0,1),
(2329,305,17904,0,0,0,0,1);
 INSERT INTO rrc068_new (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(302,17139,0,0,0,0,1),
(303,17139,0,0,0,0,1),
(304,17139,0,0,0,0,1),
(305,17139,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO locked_rows FROM tradeskill_recipe r JOIN rrc068_recipes e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC068 recipe missing'; END IF;
 SELECT COUNT(*) INTO locked_rows FROM tradeskill_recipe_entries r JOIN rrc068_old e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>20 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC068 old entry missing'; END IF;
 IF EXISTS(SELECT 1 FROM rrc068_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC068 recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc068_old e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc068_recipes e ON r.recipe_id=e.id)<>24 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC068 old entries mismatch'; END IF;
 IF (SELECT COUNT(*) FROM rrc068_new e JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)<>4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC068 new links mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=17139 AND BINARY Name=BINARY CONVERT(0x4d6172626c65204d6f7274617220616e6420506573746c65 USING utf8mb4) AND itemclass=1 AND bagtype=12 AND bagslots=10 AND bagsize=3)<>1 OR (SELECT COUNT(*) FROM items WHERE id=17904 AND itemclass=1 AND bagtype=12 AND bagslots=6 AND bagsize=3)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC068 native mortar capacity mismatch'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc068_new e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`;
 SET links_changed=ROW_COUNT();
 IF links_changed<>4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC068 link count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc068_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC068 recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc068_old e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc068_recipes e ON r.recipe_id=e.id)<>20 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC068 old entries mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc068_recipes e ON r.recipe_id=e.id WHERE r.item_id=17139 AND r.iscontainer=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC068 link collision'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC068 count delta mismatch'; END IF;
 DROP TEMPORARY TABLE rrc068_old;
 DROP TEMPORARY TABLE rrc068_new;
 DROP TEMPORARY TABLE rrc068_recipes;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC068',links_changed,recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe),entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
