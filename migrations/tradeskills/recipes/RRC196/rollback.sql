-- RRC196: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc196_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc196_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc196_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc196_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3096542,CONVERT(0x426c61636b20416372796c6961205761722048616d6d6572204f726e616d656e74204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54206f726e616d656e742d6d6174657269616c207265636f6e737472756374696f6e3b205252433139362e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096543,CONVERT(0x426c61636b20416372796c6961204772656174204d616365204f726e616d656e74204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54206f726e616d656e742d6d6174657269616c207265636f6e737472756374696f6e3b205252433139362e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096544,CONVERT(0x426c61636b20416372796c696120426c616465204f726e616d656e74204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54206f726e616d656e742d6d6174657269616c207265636f6e737472756374696f6e3b205252433139362e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096545,CONVERT(0x426c61636b20416372796c69612048616c62657264204f726e616d656e74204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54206f726e616d656e742d6d6174657269616c207265636f6e737472756374696f6e3b205252433139362e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096546,CONVERT(0x426c61636b20416372796c696120446167676572204f726e616d656e74204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54206f726e616d656e742d6d6174657269616c207265636f6e737472756374696f6e3b205252433139362e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096547,CONVERT(0x426c61636b20416372796c6961205370656172204f726e616d656e74204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54206f726e616d656e742d6d6174657269616c207265636f6e737472756374696f6e3b205252433139362e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096548,CONVERT(0x556e666972656420426c61636b20416372796c6961205761722048616d6d6572204f726e616d656e74204d6f6c64 USING utf8mb4),69,0,302,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54206f726e616d656e742d6d6174657269616c207265636f6e737472756374696f6e3b205252433139362e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096549,CONVERT(0x556e666972656420426c61636b20416372796c6961204772656174204d616365204f726e616d656e74204d6f6c64 USING utf8mb4),69,0,295,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54206f726e616d656e742d6d6174657269616c207265636f6e737472756374696f6e3b205252433139362e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096550,CONVERT(0x556e666972656420426c61636b20416372796c696120426c616465204f726e616d656e74204d6f6c64 USING utf8mb4),69,0,295,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54206f726e616d656e742d6d6174657269616c207265636f6e737472756374696f6e3b205252433139362e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096551,CONVERT(0x556e666972656420426c61636b20416372796c69612048616c62657264204f726e616d656e74204d6f6c64 USING utf8mb4),69,0,295,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54206f726e616d656e742d6d6174657269616c207265636f6e737472756374696f6e3b205252433139362e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096552,CONVERT(0x556e666972656420426c61636b20416372796c696120446167676572204f726e616d656e74204d6f6c64 USING utf8mb4),69,0,288,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54206f726e616d656e742d6d6174657269616c207265636f6e737472756374696f6e3b205252433139362e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096553,CONVERT(0x556e666972656420426c61636b20416372796c6961205370656172204f726e616d656e74204d6f6c64 USING utf8mb4),69,0,288,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54206f726e616d656e742d6d6174657269616c207265636f6e737472756374696f6e3b205252433139362e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096554,CONVERT(0x556e6669726564204f6273696469616e205363616c652048616d6d6572204f726e616d656e74 USING utf8mb4),69,0,322,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54206f726e616d656e742d6d6174657269616c207265636f6e737472756374696f6e3b205252433139362e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096555,CONVERT(0x556e6669726564204f6273696469616e205363616c652047726561742048616d6d6572204f726e616d656e74 USING utf8mb4),69,0,315,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54206f726e616d656e742d6d6174657269616c207265636f6e737472756374696f6e3b205252433139362e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096556,CONVERT(0x447265616d20496e667573656420436c6179 USING utf8mb4),69,0,102,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54206f726e616d656e742d6d6174657269616c207265636f6e737472756374696f6e3b205252433139362e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL);
INSERT INTO rrc196_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3096542,16908,0,0,1,1,0),
(3096542,45875,1,0,0,0,0),
(3096542,45946,0,0,1,1,0),
(3096542,9,0,0,0,0,1),
(3096543,16908,0,0,1,1,0),
(3096543,45876,1,0,0,0,0),
(3096543,45947,0,0,1,1,0),
(3096543,9,0,0,0,0,1),
(3096544,16908,0,0,1,1,0),
(3096544,45877,1,0,0,0,0),
(3096544,45948,0,0,1,1,0),
(3096544,9,0,0,0,0,1),
(3096545,16908,0,0,1,1,0),
(3096545,45878,1,0,0,0,0),
(3096545,45949,0,0,1,1,0),
(3096545,9,0,0,0,0,1),
(3096546,16908,0,0,1,1,0),
(3096546,45879,1,0,0,0,0),
(3096546,45950,0,0,1,1,0),
(3096546,9,0,0,0,0,1),
(3096547,16908,0,0,1,1,0),
(3096547,45880,1,0,0,0,0),
(3096547,45951,0,0,1,1,0),
(3096547,9,0,0,0,0,1),
(3096548,45931,0,0,1,1,0),
(3096548,45938,0,0,2,2,0),
(3096548,45946,1,0,0,0,0),
(3096548,8,0,0,0,0,1),
(3096549,45932,0,0,1,1,0),
(3096549,45938,0,0,3,3,0),
(3096549,45947,1,0,0,0,0),
(3096549,8,0,0,0,0,1),
(3096550,45933,0,0,1,1,0),
(3096550,45938,0,0,2,2,0),
(3096550,45948,1,0,0,0,0),
(3096550,8,0,0,0,0,1),
(3096551,45934,0,0,1,1,0),
(3096551,45938,0,0,3,3,0),
(3096551,45949,1,0,0,0,0),
(3096551,8,0,0,0,0,1),
(3096552,45935,0,0,1,1,0),
(3096552,45938,0,0,1,1,0),
(3096552,45950,1,0,0,0,0),
(3096552,8,0,0,0,0,1),
(3096553,45936,0,0,1,1,0),
(3096553,45938,0,0,2,2,0),
(3096553,45951,1,0,0,0,0),
(3096553,8,0,0,0,0,1),
(3096554,10018,0,0,1,1,0),
(3096554,124294,0,0,1,1,0),
(3096554,124310,1,0,0,0,0),
(3096554,124341,0,0,2,2,0),
(3096554,8,0,0,0,0,1),
(3096555,10018,0,0,1,1,0),
(3096555,124295,0,0,1,1,0),
(3096555,124311,1,0,0,0,0),
(3096555,124341,0,0,3,3,0),
(3096555,8,0,0,0,0,1),
(3096556,13006,0,0,1,1,0),
(3096556,16896,0,0,1,1,0),
(3096556,46979,0,0,1,1,0),
(3096556,124341,1,0,0,0,0),
(3096556,8,0,0,0,0,1);
INSERT INTO rrc196_items (`id`,`name`) VALUES
(10018,CONVERT(0x48656d6174697465 USING utf8mb4)),
(13006,CONVERT(0x576174657220466c61736b USING utf8mb4)),
(16896,CONVERT(0x4c6172676520426c6f636b206f66204d6167696320436c6179 USING utf8mb4)),
(16908,CONVERT(0x48696768205175616c69747920466972696e67205368656574 USING utf8mb4)),
(45875,CONVERT(0x426c61636b20416372796c6961205761722048616d6d6572204f726e616d656e74204d6f6c64 USING utf8mb4)),
(45876,CONVERT(0x426c61636b20416372796c6961204772656174204d616365204f726e616d656e74204d6f6c64 USING utf8mb4)),
(45877,CONVERT(0x426c61636b20416372796c696120426c616465204f726e616d656e74204d6f6c64 USING utf8mb4)),
(45878,CONVERT(0x426c61636b20416372796c69612048616c62657264204f726e616d656e74204d6f6c64 USING utf8mb4)),
(45879,CONVERT(0x426c61636b20416372796c696120446167676572204f726e616d656e74204d6f6c64 USING utf8mb4)),
(45880,CONVERT(0x426c61636b20416372796c6961205370656172204f726e616d656e74204d6f6c64 USING utf8mb4)),
(45931,CONVERT(0x426c61636b20416372796c6961205761722048616d6d6572204f726e616d656e74204d6f6c6420536b65746368 USING utf8mb4)),
(45932,CONVERT(0x426c61636b20416372796c6961204772656174204d616365204f726e616d656e74204d6f6c6420536b65746368 USING utf8mb4)),
(45933,CONVERT(0x426c61636b20416372796c696120426c616465204f726e616d656e74204d6f6c6420536b65746368 USING utf8mb4)),
(45934,CONVERT(0x426c61636b20416372796c69612048616c62657264204f726e616d656e74204d6f6c6420536b65746368 USING utf8mb4)),
(45935,CONVERT(0x426c61636b20416372796c696120446167676572204f726e616d656e74204d6f6c6420536b65746368 USING utf8mb4)),
(45936,CONVERT(0x426c61636b20416372796c6961205370656172204f726e616d656e74204d6f6c6420536b65746368 USING utf8mb4)),
(45938,CONVERT(0x436f7367726f766520496e667573656420436c6179 USING utf8mb4)),
(45946,CONVERT(0x556e666972656420426c61636b20416372796c6961205761722048616d6d6572204f726e616d656e74204d6f6c64 USING utf8mb4)),
(45947,CONVERT(0x556e666972656420426c61636b20416372796c6961204772656174204d616365204f726e616d656e74204d6f6c64 USING utf8mb4)),
(45948,CONVERT(0x556e666972656420426c61636b20416372796c696120426c616465204f726e616d656e74204d6f6c64 USING utf8mb4)),
(45949,CONVERT(0x556e666972656420426c61636b20416372796c69612048616c62657264204f726e616d656e74204d6f6c64 USING utf8mb4)),
(45950,CONVERT(0x556e666972656420426c61636b20416372796c696120446167676572204f726e616d656e74204d6f6c64 USING utf8mb4)),
(45951,CONVERT(0x556e666972656420426c61636b20416372796c6961205370656172204f726e616d656e74204d6f6c64 USING utf8mb4)),
(46979,CONVERT(0x447265616d2044757374 USING utf8mb4)),
(124294,CONVERT(0x4f6273696469616e205363616c652048616d6d6572204f726e616d656e7420536b65746368 USING utf8mb4)),
(124295,CONVERT(0x4f6273696469616e205363616c652047726561742048616d6d6572204f726e616d656e7420536b65746368 USING utf8mb4)),
(124310,CONVERT(0x556e6669726564204f6273696469616e205363616c652048616d6d6572204f726e616d656e74 USING utf8mb4)),
(124311,CONVERT(0x556e6669726564204f6273696469616e205363616c652047726561742048616d6d6572204f726e616d656e74 USING utf8mb4)),
(124341,CONVERT(0x447265616d20496e667573656420436c6179 USING utf8mb4));
 CREATE TEMPORARY TABLE rrc196_peer_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc196_peer_entries LIKE tradeskill_recipe_entries;
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 target database mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=10018 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=13006 AND `itemclass` <=> 0 AND `itemtype` <=> 15 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16896 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16908 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45875 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 55 AND `bagslots` <=> 1 AND `bagsize` <=> 4 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45876 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 55 AND `bagslots` <=> 1 AND `bagsize` <=> 4 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45877 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 55 AND `bagslots` <=> 1 AND `bagsize` <=> 4 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45878 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 55 AND `bagslots` <=> 1 AND `bagsize` <=> 4 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45879 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 55 AND `bagslots` <=> 1 AND `bagsize` <=> 4 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45880 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 55 AND `bagslots` <=> 1 AND `bagsize` <=> 4 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45931 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45932 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45933 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45934 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45935 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45936 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45938 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45946 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45947 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45948 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45949 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45950 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45951 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=46979 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=124294 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=124295 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=124310 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=124311 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=124341 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 native item semantics mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc196_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc196_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc196_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc196_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc196_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc196_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 output producer universe changed'; END IF;

 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc196_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc196_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 item identity/dependency mismatch'; END IF;
 IF already_present<>15 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc196_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc196_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc196_recipes q ON q.id=r.recipe_id LEFT JOIN rrc196_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc196_recipes q ON q.id=r.recipe_id)<>63 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc196_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc196_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc196_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-15 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-63 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 rollback count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc196_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc196_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc196_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc196_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc196_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc196_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC196 output producer universe changed'; END IF;
 DROP TEMPORARY TABLE rrc196_peer_entries;
 DROP TEMPORARY TABLE rrc196_peer_recipes;
 DROP TEMPORARY TABLE rrc196_entries;
 DROP TEMPORARY TABLE rrc196_recipes;
 DROP TEMPORARY TABLE rrc196_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC196' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
