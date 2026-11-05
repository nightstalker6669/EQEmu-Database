-- RRC174: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
-- Source recipe facts/provenance: batch.public.json. No engine/updater/version/rule changes.
-- Anonymous compound block: no permanent helper procedure or migration table.
DELIMITER //
BEGIN NOT ATOMIC
 DECLARE own_transaction BOOLEAN DEFAULT FALSE;
 DECLARE already_present INT DEFAULT 0;
 DECLARE recipes_before BIGINT DEFAULT 0;
 DECLARE entries_before BIGINT DEFAULT 0;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION
 BEGIN
  IF own_transaction THEN ROLLBACK; END IF;
  RESIGNAL;
 END;
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc174_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc174_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc174_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc174_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3096160,CONVERT(0x526570656174696e672043726f7373626f7720426f6c7473202854696e6b6572696e6729 USING utf8mb4),57,0,335,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792066696e69746520776561706f6e207265636f6e737472756374696f6e3b205252433137342e USING utf8mb4),1,81108,0,1,19,-1,NULL,NULL),
(3096161,CONVERT(0x526570656174696e672043726f7373626f7720426f6c74732028466c65746368696e6729 USING utf8mb4),64,300,335,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792066696e69746520776561706f6e207265636f6e737472756374696f6e3b205252433137342e USING utf8mb4),1,81108,0,1,19,-1,NULL,NULL);
INSERT INTO rrc174_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3096160,8057,0,0,1,1,0),
(3096160,8063,0,0,1,1,0),
(3096160,81120,10,0,0,0,0),
(3096160,81131,0,0,1,1,0),
(3096160,17276,0,0,0,0,1),
(3096160,17877,0,0,0,0,1),
(3096161,8057,0,0,1,1,0),
(3096161,8063,0,0,1,1,0),
(3096161,81120,10,0,0,0,0),
(3096161,81131,0,0,1,1,0),
(3096161,17189,0,0,0,0,1),
(3096161,17762,0,0,0,0,1),
(3096161,17910,0,0,0,0,1);
INSERT INTO rrc174_items (`id`,`name`) VALUES
(8057,CONVERT(0x53696c76657220546970706564204172726f776865616473 USING utf8mb4)),
(8063,CONVERT(0x42756e646c656420537465656c204172726f7720536861667473 USING utf8mb4)),
(17189,CONVERT(0x436f6c6c61707369626c6520466c65746368696e67204b6974 USING utf8mb4)),
(17276,CONVERT(0x436f6c6c61707369626c6520546f6f6c626f78 USING utf8mb4)),
(17762,CONVERT(0x506c616e617220466c65746368696e67204b6974 USING utf8mb4)),
(17877,CONVERT(0x44656c75786520546f6f6c626f78 USING utf8mb4)),
(17910,CONVERT(0x466c65746368696e67204b6974 USING utf8mb4)),
(81108,CONVERT(0x4d65726368616e7420416c6c69616e6365205472616465626f6f6b USING utf8mb4)),
(81120,CONVERT(0x526570656174696e672043726f7373626f7720426f6c7473 USING utf8mb4)),
(81131,CONVERT(0x46696e65204665617468657273 USING utf8mb4));
 CREATE TEMPORARY TABLE rrc174_peer_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc174_peer_entries LIKE tradeskill_recipe_entries;
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 target database mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=8057 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=8063 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17189 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17276 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 10 AND `bagslots` <=> 8 AND `bagsize` <=> 4 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17762 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17877 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 10 AND `bagslots` <=> 10 AND `bagsize` <=> 4 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17910 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81108 AND `itemclass` <=> 2 AND `itemtype` <=> 60 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> CONVERT(0x5453514d415472616465626f6f6b USING utf8mb4) AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81120 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81131 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM books WHERE name=CONVERT(0x5453514d415472616465626f6f6b USING utf8mb4) AND SHA2(txtfile,256)=CONVERT(0x65666464316563363662383833643131333361656331633235626532343262303764386236663130373363393666353135303939383530373462393836613165 USING utf8mb4))<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 native family book context mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc174_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc174_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc174_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc174_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc174_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc174_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 output producer universe changed'; END IF;

 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc174_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc174_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 item identity/dependency mismatch'; END IF;
 IF already_present<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc174_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc174_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc174_recipes q ON q.id=r.recipe_id LEFT JOIN rrc174_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc174_recipes q ON q.id=r.recipe_id)<>13 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc174_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc174_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc174_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-2 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-13 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 rollback count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc174_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc174_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc174_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc174_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc174_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc174_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC174 output producer universe changed'; END IF;
 DROP TEMPORARY TABLE rrc174_peer_entries;
 DROP TEMPORARY TABLE rrc174_peer_recipes;
 DROP TEMPORARY TABLE rrc174_entries;
 DROP TEMPORARY TABLE rrc174_recipes;
 DROP TEMPORARY TABLE rrc174_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC174' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
