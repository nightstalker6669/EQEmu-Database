-- RRC177: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC177 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC177 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC177 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC177 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc177_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc177_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc177_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc177_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3096185,CONVERT(0x4567672042617474657220284e657374204472616b652045676729 USING utf8mb4),60,0,28,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204e657374204472616b652045676720696e707574207265636f6e737472756374696f6e3b205252433137372e USING utf8mb4),0,0,0,1,7,-1,NULL,NULL);
INSERT INTO rrc177_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3096185,13087,0,0,1,1,0),
(3096185,45376,0,0,1,1,0),
(3096185,67741,18,0,0,0,0),
(3096185,17906,0,0,0,0,1);
INSERT INTO rrc177_items (`id`,`name`) VALUES
(13087,CONVERT(0x426f74746c65206f66204d696c6b USING utf8mb4)),
(17906,CONVERT(0x4d6978696e6720426f776c USING utf8mb4)),
(45376,CONVERT(0x4e657374204472616b6520456767 USING utf8mb4)),
(67741,CONVERT(0x45676720426174746572 USING utf8mb4));
 CREATE TEMPORARY TABLE rrc177_peer_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc177_peer_entries LIKE tradeskill_recipe_entries;
INSERT INTO rrc177_peer_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(1859,CONVERT(0x45676720426174746572 USING utf8mb4),60,0,15,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(1860,CONVERT(0x45676720426174746572 USING utf8mb4),60,0,15,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(1861,CONVERT(0x45676720426174746572 USING utf8mb4),60,0,15,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(1862,CONVERT(0x45676720426174746572 USING utf8mb4),60,0,15,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(1863,CONVERT(0x45676720426174746572 USING utf8mb4),60,0,15,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(1864,CONVERT(0x45676720426174746572 USING utf8mb4),60,0,15,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(1865,CONVERT(0x45676720426174746572 USING utf8mb4),60,0,17,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(1866,CONVERT(0x45676720426174746572 USING utf8mb4),60,0,15,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(1867,CONVERT(0x45676720426174746572 USING utf8mb4),60,0,28,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(1868,CONVERT(0x45676720426174746572 USING utf8mb4),60,0,28,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(1869,CONVERT(0x45676720426174746572 USING utf8mb4),60,0,15,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(1870,CONVERT(0x45676720426174746572 USING utf8mb4),60,0,28,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(1871,CONVERT(0x45676720426174746572 USING utf8mb4),60,0,15,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(27944,CONVERT(0x45676720426174746572 USING utf8mb4),60,0,17,0,0,CONVERT(0x447261676f6e73206f66204e6f7272617468202d2042616b696e67202865717472616465727320696d706f72742920 USING utf8mb4),0,0,0,0,9,99,'',''),
(3091909,CONVERT(0x45676720426174746572202853746f6e6520536e616b652045676729 USING utf8mb4),60,0,17,0,0,CONVERT(0x446f44483b20455154432061727469636c653334363b20646f7567682f65676720696e7075742076617269616e74733b205252433033312e USING utf8mb4),0,0,0,1,10,-1,NULL,NULL),
(3091910,CONVERT(0x45676720426174746572202853616e6420536e616b652045676729 USING utf8mb4),60,0,17,0,0,CONVERT(0x446f44483b20455154432061727469636c653334363b20646f7567682f65676720696e7075742076617269616e74733b205252433033312e USING utf8mb4),0,0,0,1,10,-1,NULL,NULL),
(3095815,CONVERT(0x456767204261747465722028477265656e20536e616b652045676729 USING utf8mb4),60,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279206f7264696e61727920696e707574207265636f6e737472756374696f6e3b205252433136352e USING utf8mb4),0,0,0,1,10,-1,NULL,NULL);
INSERT INTO rrc177_peer_entries (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(13914,1859,13087,0,0,1,1,0),
(13915,1859,13088,0,0,1,1,0),
(13916,1859,67741,1,0,0,0,0),
(13917,1859,15,0,0,0,0,1),
(13918,1859,17162,0,0,0,0,1),
(13919,1859,17906,0,0,0,0,1),
(13920,1860,3458,0,0,1,1,0),
(13921,1860,13087,0,0,1,1,0),
(13922,1860,67741,1,0,0,0,0),
(13923,1860,15,0,0,0,0,1),
(13924,1860,17162,0,0,0,0,1),
(13925,1860,17906,0,0,0,0,1),
(13926,1861,13087,0,0,1,1,0),
(13927,1861,14968,0,0,1,1,0),
(13928,1861,67741,5,0,0,0,0),
(13929,1861,15,0,0,0,0,1),
(13930,1861,17162,0,0,0,0,1),
(13931,1861,17906,0,0,0,0,1),
(13932,1862,13087,0,0,1,1,0),
(13933,1862,65489,0,0,1,1,0),
(13934,1862,67741,5,0,0,0,0),
(13935,1862,15,0,0,0,0,1),
(13936,1862,17162,0,0,0,0,1),
(13937,1862,17906,0,0,0,0,1),
(13938,1863,12787,0,0,1,1,0),
(13939,1863,13087,0,0,1,1,0),
(13940,1863,67741,5,0,0,0,0),
(13941,1863,15,0,0,0,0,1),
(13942,1863,17162,0,0,0,0,1),
(13943,1863,17906,0,0,0,0,1),
(13944,1864,13087,0,0,1,1,0),
(13945,1864,14950,0,0,1,1,0),
(13946,1864,67741,5,0,0,0,0),
(13947,1864,15,0,0,0,0,1),
(13948,1864,17162,0,0,0,0,1),
(13949,1864,17906,0,0,0,0,1),
(13950,1865,13087,0,0,1,1,0),
(13951,1865,14947,0,0,1,1,0),
(13952,1865,67741,5,0,0,0,0),
(13953,1865,15,0,0,0,0,1),
(13954,1865,17162,0,0,0,0,1),
(13955,1865,17906,0,0,0,0,1),
(13956,1866,13087,0,0,1,1,0),
(13957,1866,14922,0,0,1,1,0),
(13958,1866,67741,7,0,0,0,0),
(13959,1866,15,0,0,0,0,1),
(13960,1866,17162,0,0,0,0,1),
(13961,1866,17906,0,0,0,0,1),
(13962,1867,13087,0,0,1,1,0),
(13963,1867,19137,0,0,1,1,0),
(13964,1867,67741,12,0,0,0,0),
(13965,1867,15,0,0,0,0,1),
(13966,1867,17162,0,0,0,0,1),
(13967,1867,17906,0,0,0,0,1),
(13968,1868,13087,0,0,1,1,0),
(13969,1868,19138,0,0,1,1,0),
(13970,1868,67741,14,0,0,0,0),
(13971,1868,15,0,0,0,0,1),
(13972,1868,17162,0,0,0,0,1),
(13973,1868,17906,0,0,0,0,1),
(13974,1869,13087,0,0,1,1,0),
(13975,1869,13164,0,0,1,1,0),
(13976,1869,67741,15,0,0,0,0),
(13977,1869,15,0,0,0,0,1),
(13978,1869,17162,0,0,0,0,1),
(13979,1869,17906,0,0,0,0,1),
(13980,1870,13087,0,0,1,1,0),
(13981,1870,19139,0,0,1,1,0),
(13982,1870,67741,20,0,0,0,0),
(13983,1870,15,0,0,0,0,1),
(13984,1870,17162,0,0,0,0,1),
(13985,1870,17906,0,0,0,0,1),
(13986,1871,10160,0,0,1,1,0),
(13987,1871,13087,0,0,1,1,0),
(13988,1871,67741,10,0,0,0,0),
(13989,1871,15,0,0,0,0,1),
(13990,1871,17162,0,0,0,0,1),
(13991,1871,17906,0,0,0,0,1),
(278812,27944,13087,0,0,1,1,0),
(278813,27944,3458,0,0,1,1,0),
(278814,27944,17906,0,0,0,0,1),
(278815,27944,17162,0,0,0,0,1),
(278816,27944,54442,0,0,0,0,1),
(278817,27944,66635,0,0,0,0,1),
(278818,27944,15,0,0,0,0,1),
(278819,27944,67741,1,0,0,0,0),
(30410673,3091909,67741,1,0,0,0,0),
(30410674,3091909,13087,0,0,1,1,0),
(30410675,3091909,32643,0,0,1,1,0),
(30410676,3091909,14,0,0,0,0,1),
(30410677,3091910,67741,1,0,0,0,0),
(30410678,3091910,13087,0,0,1,1,0),
(30410679,3091910,32645,0,0,1,1,0),
(30410680,3091910,14,0,0,0,0,1),
(30450808,3095815,13087,0,0,1,1,0),
(30450809,3095815,32644,0,0,1,1,0),
(30450810,3095815,67741,1,0,0,0,0),
(30450811,3095815,17906,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC177 target database mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=13087 AND `itemclass` <=> 0 AND `itemtype` <=> 15 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC177 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17906 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 14 AND `bagslots` <=> 10 AND `bagsize` <=> 4 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC177 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45376 AND `itemclass` <=> 0 AND `itemtype` <=> 14 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC177 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=67741 AND `itemclass` <=> 0 AND `itemtype` <=> 14 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC177 native item semantics mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc177_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC177 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc177_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc177_peer_recipes p ON p.id=r.recipe_id)<>98 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC177 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc177_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc177_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc177_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC177 output producer universe changed'; END IF;

 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc177_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc177_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC177 item identity/dependency mismatch'; END IF;
 IF already_present NOT IN (0,1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC177 partial batch or ID collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r JOIN rrc177_recipes e ON r.tradeskill=e.tradeskill AND r.name=e.name WHERE r.id<>e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC177 existing recipe-name collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=45376 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3096185 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=2 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=13087)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=45376)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC177 all-state full input collision'; END IF;
 IF already_present=0 THEN
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc177_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC177 new ID range has learned references'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc177_recipes e ON r.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC177 orphan target entries collision'; END IF;
 INSERT INTO tradeskill_recipe (id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled) SELECT id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled FROM rrc177_recipes;
 INSERT INTO tradeskill_recipe_entries (recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer) SELECT recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer FROM rrc177_entries;
 END IF;
 IF EXISTS(SELECT 1 FROM rrc177_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC177 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc177_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC177 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc177_recipes q ON q.id=r.recipe_id LEFT JOIN rrc177_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC177 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc177_recipes q ON q.id=r.recipe_id)<>4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC177 target entry multiplicity mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before+IF(already_present=0,1,0) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before+IF(already_present=0,4,0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC177 unexpected table row-count delta'; END IF;
 IF EXISTS(SELECT 1 FROM rrc177_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC177 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc177_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc177_peer_recipes p ON p.id=r.recipe_id)<>98 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC177 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc177_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc177_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc177_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC177 output producer universe changed'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=45376 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3096185 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=2 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=13087)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=45376)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC177 all-state full input collision'; END IF;
 DROP TEMPORARY TABLE rrc177_peer_entries;
 DROP TEMPORARY TABLE rrc177_peer_recipes;
 DROP TEMPORARY TABLE rrc177_entries;
 DROP TEMPORARY TABLE rrc177_recipes;
 DROP TEMPORARY TABLE rrc177_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC177' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
