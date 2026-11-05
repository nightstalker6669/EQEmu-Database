-- RRC172: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc172_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc172_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc172_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc172_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3096128,CONVERT(0x45786f7469632053696c6b204361702054656d706c617465 USING utf8mb4),61,0,492,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792073696c6b2074656d706c617465207265636f6e737472756374696f6e3b205252433137322e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096129,CONVERT(0x45786f7469632053696c6b20526f62652054656d706c617465 USING utf8mb4),61,0,515,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792073696c6b2074656d706c617465207265636f6e737472756374696f6e3b205252433137322e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096130,CONVERT(0x45786f7469632053696c6b20536c656576652054656d706c617465 USING utf8mb4),61,0,494,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792073696c6b2074656d706c617465207265636f6e737472756374696f6e3b205252433137322e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096131,CONVERT(0x45786f7469632053696c6b20577269737462616e642054656d706c617465 USING utf8mb4),61,0,488,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792073696c6b2074656d706c617465207265636f6e737472756374696f6e3b205252433137322e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096132,CONVERT(0x45786f7469632053696c6b20476c6f76652054656d706c617465 USING utf8mb4),61,0,490,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792073696c6b2074656d706c617465207265636f6e737472756374696f6e3b205252433137322e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096133,CONVERT(0x45786f7469632053696c6b2050616e742054656d706c617465 USING utf8mb4),61,0,498,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792073696c6b2074656d706c617465207265636f6e737472756374696f6e3b205252433137322e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096134,CONVERT(0x45786f7469632053696c6b20426f6f742054656d706c617465 USING utf8mb4),61,0,496,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792073696c6b2074656d706c617465207265636f6e737472756374696f6e3b205252433137322e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096135,CONVERT(0x4265666f756c65642053696c6b204361702054656d706c617465 USING utf8mb4),61,0,492,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792073696c6b2074656d706c617465207265636f6e737472756374696f6e3b205252433137322e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3096136,CONVERT(0x4265666f756c65642053696c6b20526f62652054656d706c617465 USING utf8mb4),61,0,515,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792073696c6b2074656d706c617465207265636f6e737472756374696f6e3b205252433137322e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3096137,CONVERT(0x4265666f756c65642053696c6b20536c656576652054656d706c617465 USING utf8mb4),61,0,494,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792073696c6b2074656d706c617465207265636f6e737472756374696f6e3b205252433137322e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3096138,CONVERT(0x4265666f756c65642053696c6b20577269737462616e642054656d706c617465 USING utf8mb4),61,0,488,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792073696c6b2074656d706c617465207265636f6e737472756374696f6e3b205252433137322e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3096139,CONVERT(0x4265666f756c65642053696c6b20476c6f76652054656d706c617465 USING utf8mb4),61,0,490,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792073696c6b2074656d706c617465207265636f6e737472756374696f6e3b205252433137322e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3096140,CONVERT(0x4265666f756c65642053696c6b2050616e742054656d706c617465 USING utf8mb4),61,0,498,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792073696c6b2074656d706c617465207265636f6e737472756374696f6e3b205252433137322e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3096141,CONVERT(0x4265666f756c65642053696c6b20426f6f742054656d706c617465 USING utf8mb4),61,0,496,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792073696c6b2074656d706c617465207265636f6e737472756374696f6e3b205252433137322e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL);
INSERT INTO rrc172_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3096128,34497,0,0,1,1,0),
(3096128,34548,0,0,1,1,0),
(3096128,34914,1,1,1,0,0),
(3096128,112445,1,0,0,0,0),
(3096128,112604,0,0,4,4,0),
(3096128,113373,0,0,1,1,0),
(3096128,17966,0,0,0,0,1),
(3096129,34501,0,0,1,1,0),
(3096129,34548,0,0,1,1,0),
(3096129,34914,1,1,1,0,0),
(3096129,112449,1,0,0,0,0),
(3096129,112604,0,0,6,6,0),
(3096129,113373,0,0,1,1,0),
(3096129,17966,0,0,0,0,1),
(3096130,34505,0,0,1,1,0),
(3096130,34548,0,0,1,1,0),
(3096130,34914,1,1,1,0,0),
(3096130,112453,1,0,0,0,0),
(3096130,112604,0,0,4,4,0),
(3096130,113373,0,0,1,1,0),
(3096130,17966,0,0,0,0,1),
(3096131,34506,0,0,1,1,0),
(3096131,34548,0,0,1,1,0),
(3096131,34914,1,1,1,0,0),
(3096131,112454,1,0,0,0,0),
(3096131,112604,0,0,2,2,0),
(3096131,113373,0,0,1,1,0),
(3096131,17966,0,0,0,0,1),
(3096132,34507,0,0,1,1,0),
(3096132,34548,0,0,1,1,0),
(3096132,34914,1,1,1,0,0),
(3096132,112455,1,0,0,0,0),
(3096132,112604,0,0,2,2,0),
(3096132,113373,0,0,1,1,0),
(3096132,17966,0,0,0,0,1),
(3096133,34508,0,0,1,1,0),
(3096133,34548,0,0,1,1,0),
(3096133,34914,1,1,1,0,0),
(3096133,112456,1,0,0,0,0),
(3096133,112604,0,0,6,6,0),
(3096133,113373,0,0,1,1,0),
(3096133,17966,0,0,0,0,1),
(3096134,34509,0,0,1,1,0),
(3096134,34548,0,0,1,1,0),
(3096134,34914,1,1,1,0,0),
(3096134,112457,1,0,0,0,0),
(3096134,112604,0,0,4,4,0),
(3096134,113373,0,0,1,1,0),
(3096134,17966,0,0,0,0,1),
(3096135,34497,0,0,1,1,0),
(3096135,34548,0,0,1,1,0),
(3096135,34914,1,1,1,0,0),
(3096135,134494,1,0,0,0,0),
(3096135,134653,0,0,4,4,0),
(3096135,135310,0,0,1,1,0),
(3096135,17966,0,0,0,0,1),
(3096136,34501,0,0,1,1,0),
(3096136,34548,0,0,1,1,0),
(3096136,34914,1,1,1,0,0),
(3096136,134498,1,0,0,0,0),
(3096136,134653,0,0,6,6,0),
(3096136,135310,0,0,1,1,0),
(3096136,17966,0,0,0,0,1),
(3096137,34505,0,0,1,1,0),
(3096137,34548,0,0,1,1,0),
(3096137,34914,1,1,1,0,0),
(3096137,134502,1,0,0,0,0),
(3096137,134653,0,0,4,4,0),
(3096137,135310,0,0,1,1,0),
(3096137,17966,0,0,0,0,1),
(3096138,34506,0,0,1,1,0),
(3096138,34548,0,0,1,1,0),
(3096138,34914,1,1,1,0,0),
(3096138,134503,1,0,0,0,0),
(3096138,134653,0,0,2,2,0),
(3096138,135310,0,0,1,1,0),
(3096138,17966,0,0,0,0,1),
(3096139,34507,0,0,1,1,0),
(3096139,34548,0,0,1,1,0),
(3096139,34914,1,1,1,0,0),
(3096139,134504,1,0,0,0,0),
(3096139,134653,0,0,2,2,0),
(3096139,135310,0,0,1,1,0),
(3096139,17966,0,0,0,0,1),
(3096140,34508,0,0,1,1,0),
(3096140,34548,0,0,1,1,0),
(3096140,34914,1,1,1,0,0),
(3096140,134505,1,0,0,0,0),
(3096140,134653,0,0,6,6,0),
(3096140,135310,0,0,1,1,0),
(3096140,17966,0,0,0,0,1),
(3096141,34509,0,0,1,1,0),
(3096141,34548,0,0,1,1,0),
(3096141,34914,1,1,1,0,0),
(3096141,134506,1,0,0,0,0),
(3096141,134653,0,0,4,4,0),
(3096141,135310,0,0,1,1,0),
(3096141,17966,0,0,0,0,1);
INSERT INTO rrc172_items (`id`,`name`) VALUES
(17966,CONVERT(0x44656c75786520536577696e67204b6974 USING utf8mb4)),
(34497,CONVERT(0x53696c6b204361702054656d706c617465205061747465726e USING utf8mb4)),
(34501,CONVERT(0x53696c6b20526f62652054656d706c617465205061747465726e USING utf8mb4)),
(34505,CONVERT(0x53696c6b20536c656576652054656d706c617465205061747465726e USING utf8mb4)),
(34506,CONVERT(0x53696c6b20577269737462616e642054656d706c617465205061747465726e USING utf8mb4)),
(34507,CONVERT(0x53696c6b20476c6f76652054656d706c617465205061747465726e USING utf8mb4)),
(34508,CONVERT(0x53696c6b2050616e742054656d706c617465205061747465726e USING utf8mb4)),
(34509,CONVERT(0x53696c6b20426f6f742054656d706c617465205061747465726e USING utf8mb4)),
(34548,CONVERT(0x53696c6b20437572696e67204368656d6963616c73 USING utf8mb4)),
(34914,CONVERT(0x53696d706c6520536577696e67204e6565646c65 USING utf8mb4)),
(112445,CONVERT(0x45786f7469632053696c6b204361702054656d706c617465 USING utf8mb4)),
(112449,CONVERT(0x45786f7469632053696c6b20526f62652054656d706c617465 USING utf8mb4)),
(112453,CONVERT(0x45786f7469632053696c6b20536c656576652054656d706c617465 USING utf8mb4)),
(112454,CONVERT(0x45786f7469632053696c6b20577269737462616e642054656d706c617465 USING utf8mb4)),
(112455,CONVERT(0x45786f7469632053696c6b20476c6f76652054656d706c617465 USING utf8mb4)),
(112456,CONVERT(0x45786f7469632053696c6b2050616e742054656d706c617465 USING utf8mb4)),
(112457,CONVERT(0x45786f7469632053696c6b20426f6f742054656d706c617465 USING utf8mb4)),
(112604,CONVERT(0x45786f7469632053696c6b USING utf8mb4)),
(113373,CONVERT(0x506c617465642046696c616d656e74 USING utf8mb4)),
(134494,CONVERT(0x4265666f756c65642053696c6b204361702054656d706c617465 USING utf8mb4)),
(134498,CONVERT(0x4265666f756c65642053696c6b20526f62652054656d706c617465 USING utf8mb4)),
(134502,CONVERT(0x4265666f756c65642053696c6b20536c656576652054656d706c617465 USING utf8mb4)),
(134503,CONVERT(0x4265666f756c65642053696c6b20577269737462616e642054656d706c617465 USING utf8mb4)),
(134504,CONVERT(0x4265666f756c65642053696c6b20476c6f76652054656d706c617465 USING utf8mb4)),
(134505,CONVERT(0x4265666f756c65642053696c6b2050616e742054656d706c617465 USING utf8mb4)),
(134506,CONVERT(0x4265666f756c65642053696c6b20426f6f742054656d706c617465 USING utf8mb4)),
(134653,CONVERT(0x4265666f756c65642053696c6b USING utf8mb4)),
(135310,CONVERT(0x43616c6369666965642046696c616d656e74 USING utf8mb4));
 CREATE TEMPORARY TABLE rrc172_peer_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc172_peer_entries LIKE tradeskill_recipe_entries;
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 target database mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17966 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 16 AND `bagslots` <=> 10 AND `bagsize` <=> 4 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `size` <=> 1 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34497 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 75 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `size` <=> 1 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34501 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 75 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `size` <=> 1 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34505 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `size` <=> 1 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34506 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `size` <=> 1 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34507 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 50 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `size` <=> 1 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34508 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 75 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `size` <=> 1 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34509 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `size` <=> 1 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34548 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `size` <=> 1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34914 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `size` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112445 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 9 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `size` <=> 1 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112449 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 3 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `size` <=> 1 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112453 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 9 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `size` <=> 1 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112454 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 15 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `size` <=> 1 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112455 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 15 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `size` <=> 1 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112456 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 3 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `size` <=> 1 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112457 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 9 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `size` <=> 1 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112604 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `size` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=113373 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `size` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134494 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 9 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `size` <=> 1 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134498 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 3 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `size` <=> 1 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134502 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 9 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `size` <=> 1 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134503 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 15 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `size` <=> 1 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134504 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 15 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `size` <=> 1 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134505 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 3 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `size` <=> 1 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134506 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 9 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `size` <=> 1 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134653 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `size` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=135310 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `size` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 native item semantics mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc172_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc172_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc172_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc172_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc172_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc172_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 output producer universe changed'; END IF;

 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc172_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc172_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 item identity/dependency mismatch'; END IF;
 IF already_present<>14 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc172_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc172_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc172_recipes q ON q.id=r.recipe_id LEFT JOIN rrc172_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc172_recipes q ON q.id=r.recipe_id)<>98 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc172_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc172_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc172_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-14 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-98 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 rollback count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc172_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc172_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc172_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc172_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc172_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc172_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC172 output producer universe changed'; END IF;
 DROP TEMPORARY TABLE rrc172_peer_entries;
 DROP TEMPORARY TABLE rrc172_peer_recipes;
 DROP TEMPORARY TABLE rrc172_entries;
 DROP TEMPORARY TABLE rrc172_recipes;
 DROP TEMPORARY TABLE rrc172_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC172' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
