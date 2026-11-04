-- RRC064: existing MakePoison dye data only, dedicated fresh MariaDB CLI session.
DELIMITER //
BEGIN NOT ATOMIC
 DECLARE own_transaction BOOLEAN DEFAULT FALSE;
 DECLARE recipes_before BIGINT DEFAULT 0;
 DECLARE entries_before BIGINT DEFAULT 0;
 DECLARE locked_rows BIGINT DEFAULT 0;
 DECLARE changed_rows BIGINT DEFAULT 0;
 DECLARE links_changed BIGINT DEFAULT 0;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
  IF own_transaction THEN ROLLBACK; END IF;
  RESIGNAL;
 END;
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC064 invalid target/transaction'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC064 strict mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC064 InnoDB foundation mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc064_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc064_before LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc064_after LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc064_new LIKE tradeskill_recipe_entries;
 INSERT INTO rrc064_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(214,CONVERT(0x426c61636b2045787472616374 USING utf8mb4),56,0,36,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(215,CONVERT(0x426c61636b2045787472616374 USING utf8mb4),56,0,36,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(216,CONVERT(0x426c61636b2045787472616374 USING utf8mb4),56,0,36,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(217,CONVERT(0x426c61636b2045787472616374 USING utf8mb4),56,0,36,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(218,CONVERT(0x426c61636b2045787472616374 USING utf8mb4),56,0,36,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(243,CONVERT(0x45766572677265656e2045787472616374 USING utf8mb4),56,0,36,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(255,CONVERT(0x4a61636b2d6f2d6c616e7465726e2045787472616374 USING utf8mb4),56,0,36,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(282,CONVERT(0x5065726d6166726f73742045787472616374 USING utf8mb4),56,0,36,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(290,CONVERT(0x52656420527573742045787472616374 USING utf8mb4),56,0,36,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(295,CONVERT(0x5275737365742045787472616374 USING utf8mb4),56,0,36,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(296,CONVERT(0x536172636f7363797068612045787472616374 USING utf8mb4),56,0,36,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
 INSERT INTO rrc064_before (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(1542,214,10062,0,1,1,0,0),
(1543,214,13006,0,0,1,1,0),
(1544,214,22136,0,0,1,1,0),
(1545,214,22132,1,0,0,0,0),
(1547,214,17190,0,0,0,0,1),
(1548,214,17904,0,0,0,0,1),
(1549,215,10062,0,1,1,0,0),
(1550,215,13006,0,0,1,1,0),
(1551,215,22134,0,0,1,1,0),
(1552,215,22132,1,0,0,0,0),
(1554,215,17190,0,0,0,0,1),
(1555,215,17904,0,0,0,0,1),
(1556,216,10062,0,1,1,0,0),
(1557,216,13006,0,0,1,1,0),
(1558,216,22135,0,0,1,1,0),
(1559,216,22132,1,0,0,0,0),
(1561,216,17190,0,0,0,0,1),
(1562,216,17904,0,0,0,0,1),
(1563,217,10062,0,1,1,0,0),
(1564,217,13006,0,0,1,1,0),
(1565,217,22125,0,0,1,1,0),
(1566,217,22132,1,0,0,0,0),
(1567,217,17190,0,0,0,0,1),
(1568,217,17904,0,0,0,0,1),
(1569,218,10062,0,1,1,0,0),
(1570,218,13006,0,0,1,1,0),
(1571,218,22137,0,0,1,1,0),
(1572,218,22132,1,0,0,0,0),
(1573,218,17190,0,0,0,0,1),
(1574,218,17904,0,0,0,0,1),
(1792,243,10062,0,1,1,0,0),
(1793,243,13006,0,0,1,1,0),
(1794,243,22119,0,0,1,1,0),
(1795,243,22126,1,0,0,0,0),
(1797,243,17190,0,0,0,0,1),
(1798,243,17904,0,0,0,0,1),
(1883,255,10062,0,1,1,0,0),
(1884,255,13006,0,0,1,1,0),
(1885,255,22122,0,0,1,1,0),
(1886,255,22129,1,0,0,0,0),
(1888,255,17190,0,0,0,0,1),
(1889,255,17904,0,0,0,0,1),
(2110,282,10062,0,1,1,0,0),
(2111,282,13006,0,0,1,1,0),
(2112,282,22121,0,0,1,1,0),
(2113,282,22128,1,0,0,0,0),
(2115,282,17190,0,0,0,0,1),
(2116,282,17904,0,0,0,0,1),
(2179,290,10062,0,1,1,0,0),
(2180,290,13006,0,0,1,1,0),
(2181,290,22124,0,0,1,1,0),
(2182,290,22131,1,0,0,0,0),
(2184,290,17190,0,0,0,0,1),
(2185,290,17904,0,0,0,0,1),
(2219,295,10062,0,1,1,0,0),
(2220,295,13006,0,0,1,1,0),
(2221,295,22123,0,0,1,1,0),
(2222,295,22130,1,0,0,0,0),
(2224,295,17190,0,0,0,0,1),
(2225,295,17904,0,0,0,0,1),
(2226,296,10062,0,1,1,0,0),
(2227,296,13006,0,0,1,1,0),
(2228,296,22120,0,0,1,1,0),
(2229,296,22127,1,0,0,0,0),
(2231,296,17190,0,0,0,0,1),
(2232,296,17904,0,0,0,0,1);
 INSERT INTO rrc064_after (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(1542,214,10062,0,1,1,0,0),
(1543,214,13006,0,0,1,1,0),
(1544,214,22136,0,0,1,1,0),
(1545,214,22132,1,0,0,0,0),
(1547,214,17190,0,0,0,0,1),
(1548,214,17904,0,0,0,0,1),
(1549,215,10062,0,1,1,0,0),
(1550,215,13006,0,0,1,1,0),
(1551,215,22134,0,0,1,1,0),
(1552,215,22132,1,0,0,0,0),
(1554,215,17190,0,0,0,0,1),
(1555,215,17904,0,0,0,0,1),
(1556,216,10062,0,1,1,0,0),
(1557,216,13006,0,0,1,1,0),
(1558,216,22135,0,0,1,1,0),
(1559,216,22132,1,0,0,0,0),
(1561,216,17190,0,0,0,0,1),
(1562,216,17904,0,0,0,0,1),
(1563,217,10062,0,0,1,1,0),
(1564,217,13006,0,0,1,1,0),
(1565,217,22125,0,0,1,1,0),
(1566,217,22132,1,0,0,0,0),
(1567,217,17190,0,0,0,0,1),
(1568,217,17904,0,0,0,0,1),
(1569,218,10062,0,0,1,1,0),
(1570,218,13006,0,0,1,1,0),
(1571,218,22137,0,0,1,1,0),
(1572,218,22132,1,0,0,0,0),
(1573,218,17190,0,0,0,0,1),
(1574,218,17904,0,0,0,0,1),
(1792,243,10062,0,1,1,0,0),
(1793,243,13006,0,0,1,1,0),
(1794,243,22119,0,0,1,1,0),
(1795,243,22126,1,0,0,0,0),
(1797,243,17190,0,0,0,0,1),
(1798,243,17904,0,0,0,0,1),
(1883,255,10062,0,1,1,0,0),
(1884,255,13006,0,0,1,1,0),
(1885,255,22122,0,0,1,1,0),
(1886,255,22129,1,0,0,0,0),
(1888,255,17190,0,0,0,0,1),
(1889,255,17904,0,0,0,0,1),
(2110,282,10062,0,1,1,0,0),
(2111,282,13006,0,0,1,1,0),
(2112,282,22121,0,0,1,1,0),
(2113,282,22128,1,0,0,0,0),
(2115,282,17190,0,0,0,0,1),
(2116,282,17904,0,0,0,0,1),
(2179,290,10062,0,1,1,0,0),
(2180,290,13006,0,0,1,1,0),
(2181,290,22124,0,0,1,1,0),
(2182,290,22131,1,0,0,0,0),
(2184,290,17190,0,0,0,0,1),
(2185,290,17904,0,0,0,0,1),
(2219,295,10062,0,1,1,0,0),
(2220,295,13006,0,0,1,1,0),
(2221,295,22123,0,0,1,1,0),
(2222,295,22130,1,0,0,0,0),
(2224,295,17190,0,0,0,0,1),
(2225,295,17904,0,0,0,0,1),
(2226,296,10062,0,1,1,0,0),
(2227,296,13006,0,0,1,1,0),
(2228,296,22120,0,0,1,1,0),
(2229,296,22127,1,0,0,0,0),
(2231,296,17190,0,0,0,0,1),
(2232,296,17904,0,0,0,0,1);
 INSERT INTO rrc064_new (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(214,17139,0,0,0,0,1),
(216,17139,0,0,0,0,1),
(218,17139,0,0,0,0,1),
(215,17139,0,0,0,0,1),
(217,17139,0,0,0,0,1),
(243,17139,0,0,0,0,1),
(255,17139,0,0,0,0,1),
(282,17139,0,0,0,0,1),
(290,17139,0,0,0,0,1),
(296,17139,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO locked_rows FROM tradeskill_recipe r JOIN rrc064_recipes e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>11 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC064 recipe missing'; END IF;
 SELECT COUNT(*) INTO locked_rows FROM tradeskill_recipe_entries r JOIN rrc064_before e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>66 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC064 entry missing'; END IF;
 IF EXISTS(SELECT 1 FROM rrc064_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC064 recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc064_before e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc064_recipes p ON p.id=r.recipe_id)<>76 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC064 full entries mismatch'; END IF;
 IF (SELECT COUNT(*) FROM rrc064_new e JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)<>10 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC064 added links mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=10062 AND BINARY Name=BINARY CONVERT(0x456d707479205669616c USING utf8mb4))<>1 OR (SELECT COUNT(*) FROM items WHERE id=17139 AND BINARY Name=BINARY CONVERT(0x4d6172626c65204d6f7274617220616e6420506573746c65 USING utf8mb4) AND itemclass=1 AND bagtype=12 AND bagslots=10)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC064 native vial/container mismatch'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc064_new e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`;
 SET links_changed=ROW_COUNT();
 IF links_changed<>10 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC064 link count mismatch'; END IF;
 UPDATE tradeskill_recipe_entries r JOIN rrc064_after e ON r.id=e.id SET r.failcount=e.failcount,r.salvagecount=e.salvagecount WHERE r.id IN (1569,1563);
 SET changed_rows=ROW_COUNT();
 IF changed_rows<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC064 changed-row count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc064_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC064 recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc064_after e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc064_recipes p ON p.id=r.recipe_id)<>66 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC064 full entries mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc064_new e JOIN tradeskill_recipe_entries r ON r.recipe_id=e.recipe_id AND r.item_id=e.item_id AND r.iscontainer=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC064 link collision'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-10 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC064 count delta mismatch'; END IF;
 DROP TEMPORARY TABLE rrc064_before;
 DROP TEMPORARY TABLE rrc064_after;
 DROP TEMPORARY TABLE rrc064_new;
 DROP TEMPORARY TABLE rrc064_recipes;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC064',changed_rows,links_changed,recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe),entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
