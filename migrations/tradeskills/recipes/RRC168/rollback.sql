-- RRC168: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc168_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc168_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc168_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc168_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3095942,CONVERT(0x50616c6c616469756d20436861696e20436f69662054656d706c617465 USING utf8mb4),63,0,492,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792063756c747572616c20696e707574207265636f6e737472756374696f6e3b205252433136382e USING utf8mb4),0,113369,0,1,18,-1,NULL,NULL),
(3095943,CONVERT(0x50616c6c616469756d20436861696e20436865737467756172642054656d706c617465 USING utf8mb4),63,0,510,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792063756c747572616c20696e707574207265636f6e737472756374696f6e3b205252433136382e USING utf8mb4),0,113369,0,1,18,-1,NULL,NULL),
(3095944,CONVERT(0x50616c6c616469756d20436861696e2041726d732054656d706c617465 USING utf8mb4),63,0,494,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792063756c747572616c20696e707574207265636f6e737472756374696f6e3b205252433136382e USING utf8mb4),0,113369,0,1,18,-1,NULL,NULL),
(3095945,CONVERT(0x50616c6c616469756d20436861696e204272616365722054656d706c617465 USING utf8mb4),63,0,488,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792063756c747572616c20696e707574207265636f6e737472756374696f6e3b205252433136382e USING utf8mb4),0,113369,0,1,18,-1,NULL,NULL),
(3095946,CONVERT(0x50616c6c616469756d20436861696e204c6567706c617465732054656d706c617465 USING utf8mb4),63,0,498,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792063756c747572616c20696e707574207265636f6e737472756374696f6e3b205252433136382e USING utf8mb4),0,113369,0,1,18,-1,NULL,NULL),
(3095947,CONVERT(0x50616c6c616469756d20436861696e20426f6f74732054656d706c617465 USING utf8mb4),63,0,496,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792063756c747572616c20696e707574207265636f6e737472756374696f6e3b205252433136382e USING utf8mb4),0,113369,0,1,18,-1,NULL,NULL),
(3095948,CONVERT(0x53636f726368656420436861696e20436f69662054656d706c617465 USING utf8mb4),63,0,492,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792063756c747572616c20696e707574207265636f6e737472756374696f6e3b205252433136382e USING utf8mb4),0,135306,0,1,19,-1,NULL,NULL),
(3095949,CONVERT(0x53636f726368656420436861696e20436865737467756172642054656d706c617465 USING utf8mb4),63,0,510,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792063756c747572616c20696e707574207265636f6e737472756374696f6e3b205252433136382e USING utf8mb4),0,135306,0,1,19,-1,NULL,NULL),
(3095950,CONVERT(0x53636f726368656420436861696e204272616365722054656d706c617465 USING utf8mb4),63,0,488,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792063756c747572616c20696e707574207265636f6e737472756374696f6e3b205252433136382e USING utf8mb4),0,135306,0,1,19,-1,NULL,NULL),
(3095951,CONVERT(0x53636f726368656420436861696e204c6567706c617465732054656d706c617465 USING utf8mb4),63,0,498,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792063756c747572616c20696e707574207265636f6e737472756374696f6e3b205252433136382e USING utf8mb4),0,135306,0,1,19,-1,NULL,NULL),
(3095952,CONVERT(0x53636f726368656420436861696e20426f6f74732054656d706c617465 USING utf8mb4),63,0,496,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792063756c747572616c20696e707574207265636f6e737472756374696f6e3b205252433136382e USING utf8mb4),0,135306,0,1,19,-1,NULL,NULL);
INSERT INTO rrc168_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3095942,10489,1,1,1,0,0),
(3095942,34522,0,0,1,1,0),
(3095942,34546,0,0,1,1,0),
(3095942,112470,1,0,0,0,0),
(3095942,112605,0,0,2,2,0),
(3095942,113372,0,0,1,1,0),
(3095942,17,0,0,0,0,1),
(3095943,10489,1,1,1,0,0),
(3095943,34525,0,0,1,1,0),
(3095943,34546,0,0,1,1,0),
(3095943,112473,1,0,0,0,0),
(3095943,112605,0,0,3,3,0),
(3095943,113372,0,0,1,1,0),
(3095943,17,0,0,0,0,1),
(3095944,10489,1,1,1,0,0),
(3095944,34529,0,0,1,1,0),
(3095944,34546,0,0,1,1,0),
(3095944,112477,1,0,0,0,0),
(3095944,112605,0,0,2,2,0),
(3095944,113372,0,0,1,1,0),
(3095944,17,0,0,0,0,1),
(3095945,10489,1,1,1,0,0),
(3095945,34530,0,0,1,1,0),
(3095945,34546,0,0,1,1,0),
(3095945,112478,1,0,0,0,0),
(3095945,112605,0,0,1,1,0),
(3095945,113372,0,0,1,1,0),
(3095945,17,0,0,0,0,1),
(3095946,10489,1,1,1,0,0),
(3095946,34532,0,0,1,1,0),
(3095946,34546,0,0,1,1,0),
(3095946,112480,1,0,0,0,0),
(3095946,112605,0,0,3,3,0),
(3095946,113372,0,0,1,1,0),
(3095946,17,0,0,0,0,1),
(3095947,10489,1,1,1,0,0),
(3095947,34533,0,0,1,1,0),
(3095947,34546,0,0,1,1,0),
(3095947,112481,1,0,0,0,0),
(3095947,112605,0,0,2,2,0),
(3095947,113372,0,0,1,1,0),
(3095947,17,0,0,0,0,1),
(3095948,10489,1,1,1,0,0),
(3095948,34522,0,0,1,1,0),
(3095948,34546,0,0,1,1,0),
(3095948,134519,1,0,0,0,0),
(3095948,134654,0,0,2,2,0),
(3095948,135309,0,0,1,1,0),
(3095948,17,0,0,0,0,1),
(3095949,10489,1,1,1,0,0),
(3095949,34525,0,0,1,1,0),
(3095949,34546,0,0,1,1,0),
(3095949,134522,1,0,0,0,0),
(3095949,134654,0,0,3,3,0),
(3095949,135309,0,0,1,1,0),
(3095949,17,0,0,0,0,1),
(3095950,10489,1,1,1,0,0),
(3095950,34530,0,0,1,1,0),
(3095950,34546,0,0,1,1,0),
(3095950,134527,1,0,0,0,0),
(3095950,134654,0,0,1,1,0),
(3095950,135309,0,0,1,1,0),
(3095950,17,0,0,0,0,1),
(3095951,10489,1,1,1,0,0),
(3095951,34532,0,0,1,1,0),
(3095951,34546,0,0,1,1,0),
(3095951,134529,1,0,0,0,0),
(3095951,134654,0,0,3,3,0),
(3095951,135309,0,0,1,1,0),
(3095951,17,0,0,0,0,1),
(3095952,10489,1,1,1,0,0),
(3095952,34533,0,0,1,1,0),
(3095952,34546,0,0,1,1,0),
(3095952,134530,1,0,0,0,0),
(3095952,134654,0,0,2,2,0),
(3095952,135309,0,0,1,1,0),
(3095952,17,0,0,0,0,1);
INSERT INTO rrc168_items (`id`,`name`) VALUES
(10489,CONVERT(0x536d697468792048616d6d6572 USING utf8mb4)),
(34522,CONVERT(0x436861696e6d61696c20436f69662054656d706c617465205061747465726e USING utf8mb4)),
(34525,CONVERT(0x436861696e6d61696c20436865737467756172642054656d706c617465205061747465726e USING utf8mb4)),
(34529,CONVERT(0x436861696e6d61696c2041726d732054656d706c617465205061747465726e USING utf8mb4)),
(34530,CONVERT(0x436861696e6d61696c204272616365722054656d706c617465205061747465726e USING utf8mb4)),
(34532,CONVERT(0x436861696e6d61696c204c6567706c617465732054656d706c617465205061747465726e USING utf8mb4)),
(34533,CONVERT(0x436861696e6d61696c20426f6f74732054656d706c617465205061747465726e USING utf8mb4)),
(34546,CONVERT(0x4d6574616c2054656d706572696e67204368656d6963616c73 USING utf8mb4)),
(112470,CONVERT(0x50616c6c616469756d20436861696e20436f69662054656d706c617465 USING utf8mb4)),
(112473,CONVERT(0x50616c6c616469756d20436861696e20436865737467756172642054656d706c617465 USING utf8mb4)),
(112477,CONVERT(0x50616c6c616469756d20436861696e2041726d732054656d706c617465 USING utf8mb4)),
(112478,CONVERT(0x50616c6c616469756d20436861696e204272616365722054656d706c617465 USING utf8mb4)),
(112480,CONVERT(0x50616c6c616469756d20436861696e204c6567706c617465732054656d706c617465 USING utf8mb4)),
(112481,CONVERT(0x50616c6c616469756d20436861696e20426f6f74732054656d706c617465 USING utf8mb4)),
(112605,CONVERT(0x50616c6c616469756d204f7265 USING utf8mb4)),
(113369,CONVERT(0x536d69746865642041726d6f72205374657020585649 USING utf8mb4)),
(113372,CONVERT(0x5368696e7920436f616c USING utf8mb4)),
(134519,CONVERT(0x53636f726368656420436861696e20436f69662054656d706c617465 USING utf8mb4)),
(134522,CONVERT(0x53636f726368656420436861696e20436865737467756172642054656d706c617465 USING utf8mb4)),
(134527,CONVERT(0x53636f726368656420436861696e204272616365722054656d706c617465 USING utf8mb4)),
(134529,CONVERT(0x53636f726368656420436861696e204c6567706c617465732054656d706c617465 USING utf8mb4)),
(134530,CONVERT(0x53636f726368656420436861696e20426f6f74732054656d706c617465 USING utf8mb4)),
(134654,CONVERT(0x53636f7263686564204f7265 USING utf8mb4)),
(135306,CONVERT(0x536d69746865642041726d6f7220537465702058564949 USING utf8mb4)),
(135309,CONVERT(0x4368617267656420436f616c USING utf8mb4));
 CREATE TEMPORARY TABLE rrc168_peer_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc168_peer_entries LIKE tradeskill_recipe_entries;
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 target database mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=10489 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34522 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 75 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34525 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 75 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34529 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 75 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34530 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34532 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 50 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34533 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 75 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34546 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112470 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 6 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112473 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 2 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112477 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 6 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112478 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112480 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 2 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112481 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 6 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112605 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=113369 AND `itemclass` <=> 2 AND `itemtype` <=> 60 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> CONVERT(0x5453536d69746842617369633935 USING utf8mb4) AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=113372 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134519 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 6 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134522 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 2 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134527 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134529 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 2 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134530 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 6 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134654 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=135306 AND `itemclass` <=> 2 AND `itemtype` <=> 60 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> CONVERT(0x5453534b553230536d69746842617365313030 USING utf8mb4) AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=135309 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM books WHERE name=CONVERT(0x5453534b553230536d69746842617365313030 USING utf8mb4) AND SHA2(txtfile,256)=CONVERT(0x63393964363831626437373237303934613732666464656462646433303233343164366238336363663064346462303766343133343562623562393231643138 USING utf8mb4))<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 native family book context mismatch'; END IF;
 IF (SELECT COUNT(*)FROM books WHERE name=CONVERT(0x5453536d69746842617369633935 USING utf8mb4) AND SHA2(txtfile,256)=CONVERT(0x33633266393362343138356233613436646331316231393031376364313164633930316264336132333963336532326330373162353131366338343137643736 USING utf8mb4))<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 native family book context mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc168_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc168_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc168_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc168_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc168_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc168_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 output producer universe changed'; END IF;

 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc168_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc168_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 item identity/dependency mismatch'; END IF;
 IF already_present<>11 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc168_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc168_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc168_recipes q ON q.id=r.recipe_id LEFT JOIN rrc168_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc168_recipes q ON q.id=r.recipe_id)<>77 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc168_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc168_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc168_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-11 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-77 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 rollback count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc168_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc168_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc168_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc168_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc168_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc168_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC168 output producer universe changed'; END IF;
 DROP TEMPORARY TABLE rrc168_peer_entries;
 DROP TEMPORARY TABLE rrc168_peer_recipes;
 DROP TEMPORARY TABLE rrc168_entries;
 DROP TEMPORARY TABLE rrc168_recipes;
 DROP TEMPORARY TABLE rrc168_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC168' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
