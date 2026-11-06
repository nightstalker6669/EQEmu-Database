-- RRC295: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc295_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc295_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc295_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc295_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3102671,CONVERT(0x46697a7a6c657370726f636b6574277320466f72636566756c204469736368617267696e6720417070617261747573 USING utf8mb4),57,0,411,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792073747269637420726563697065733b6c69746572616c20726f6c65732f657861637420736f75726365206d616b657220616e6420626f6f6b2067617465733b6c6162656c6c65642065726120666c6f6f72207265636f6e737472756374696f6e3b5252433239352e USING utf8mb4),0,0,0,1,0,-1,NULL,NULL),
(3102672,CONVERT(0x4d697261676520476f67676c6573 USING utf8mb4),57,0,295,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792073747269637420726563697065733b6c69746572616c20726f6c65732f657861637420736f75726365206d616b657220616e6420626f6f6b2067617465733b6c6162656c6c65642065726120666c6f6f72207265636f6e737472756374696f6e3b5252433239352e USING utf8mb4),0,0,0,1,0,-1,NULL,NULL),
(3102673,CONVERT(0x436c6f636b776f726b204175746f6d61746f6e USING utf8mb4),57,0,322,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792073747269637420726563697065733b6c69746572616c20726f6c65732f657861637420736f75726365206d616b657220616e6420626f6f6b2067617465733b6c6162656c6c65642065726120666c6f6f72207265636f6e737472756374696f6e3b5252433239352e USING utf8mb4),0,0,0,1,0,-1,NULL,NULL),
(3102674,CONVERT(0x526f636b657465657220426f6f7473 USING utf8mb4),57,0,308,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792073747269637420726563697065733b6c69746572616c20726f6c65732f657861637420736f75726365206d616b657220616e6420626f6f6b2067617465733b6c6162656c6c65642065726120666c6f6f72207265636f6e737472756374696f6e3b5252433239352e USING utf8mb4),0,0,0,1,0,-1,NULL,NULL);
INSERT INTO rrc295_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3102671,17434,0,0,2,2,0),
(3102671,17466,0,0,2,2,0),
(3102671,23605,0,0,2,2,0),
(3102671,32686,0,0,2,2,0),
(3102671,38996,0,0,1,1,0),
(3102671,38997,1,0,0,0,0),
(3102671,39734,0,0,1,1,0),
(3102671,17877,0,0,0,0,1),
(3102672,7483,0,0,1,1,0),
(3102672,16860,0,0,1,1,0),
(3102672,16888,0,0,1,1,0),
(3102672,81138,0,0,1,1,0),
(3102672,81160,0,0,1,1,0),
(3102672,81298,1,0,0,0,0),
(3102672,17877,0,0,0,0,1),
(3102673,9179,0,0,1,1,0),
(3102673,9181,0,0,1,1,0),
(3102673,9194,0,0,1,1,0),
(3102673,16858,0,0,1,1,0),
(3102673,16882,0,0,1,1,0),
(3102673,81138,0,0,1,1,0),
(3102673,81299,1,0,0,0,0),
(3102673,17877,0,0,0,0,1),
(3102674,13004,0,0,1,1,0),
(3102674,16858,0,0,1,1,0),
(3102674,16891,0,0,1,1,0),
(3102674,21024,0,0,1,1,0),
(3102674,63244,0,0,1,1,0),
(3102674,81138,0,0,1,1,0),
(3102674,81300,1,0,0,0,0),
(3102674,17877,0,0,0,0,1);
INSERT INTO rrc295_items (`id`,`name`) VALUES
(7483,CONVERT(0x4375726564204c65617468657220547562696e67 USING utf8mb4)),
(9179,CONVERT(0x436f696c656420537072696e67 USING utf8mb4)),
(9181,CONVERT(0x4d616e612042617474657279202d20436c61737320536978 USING utf8mb4)),
(9194,CONVERT(0x537465656c20436173696e67 USING utf8mb4)),
(13004,CONVERT(0x4c61726765204c616e7465726e USING utf8mb4)),
(16858,CONVERT(0x4765617273 USING utf8mb4)),
(16860,CONVERT(0x5265666c656374697665205368617264 USING utf8mb4)),
(16882,CONVERT(0x537461746963204f7262 USING utf8mb4)),
(16888,CONVERT(0x4d6574616c2046617374656e696e67 USING utf8mb4)),
(16891,CONVERT(0x536861726b736b696e20547562696e67 USING utf8mb4)),
(17434,CONVERT(0x496e7472696361746520546974616e69756d204765617273 USING utf8mb4)),
(17466,CONVERT(0x437574204469616d6f6e642047656172 USING utf8mb4)),
(17877,CONVERT(0x44656c75786520546f6f6c626f78 USING utf8mb4)),
(21024,CONVERT(0x536d616c6c2046696e6520506c61746520426f6f7473 USING utf8mb4)),
(23605,CONVERT(0x4d6f756e74656420426c7565204469616d6f6e64 USING utf8mb4)),
(32686,CONVERT(0x54696e7920436c6f636b776f726b205368616674 USING utf8mb4)),
(38996,CONVERT(0x46697a7a6c657370726f636b6574277320456e65726779205265706f7369746f7279 USING utf8mb4)),
(38997,CONVERT(0x46697a7a6c657370726f636b6574277320466f72636566756c204469736368617267696e6720417070617261747573 USING utf8mb4)),
(39734,CONVERT(0x54656d706f72697465205472696f2042726163656c6574 USING utf8mb4)),
(63244,CONVERT(0x476e6f6d697368204865617420536f75726365 USING utf8mb4)),
(81138,CONVERT(0x4665796d6574616c20426172 USING utf8mb4)),
(81160,CONVERT(0x4d697261676573746f6e65 USING utf8mb4)),
(81298,CONVERT(0x4d697261676520476f67676c6573 USING utf8mb4)),
(81299,CONVERT(0x436c6f636b776f726b204175746f6d61746f6e USING utf8mb4)),
(81300,CONVERT(0x526f636b657465657220426f6f7473 USING utf8mb4));
 CREATE TEMPORARY TABLE rrc295_peer_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc295_peer_entries LIKE tradeskill_recipe_entries;
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 target database mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=7483 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=9179 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 32767 AND `races` <=> 18432 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=9181 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=9194 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 32767 AND `races` <=> 18432 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=13004 AND `itemclass` <=> 0 AND `itemtype` <=> 16 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16858 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16860 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16882 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16888 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16891 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17434 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17466 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17877 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 10 AND `bagslots` <=> 10 AND `bagsize` <=> 4 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=21024 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 151 AND `races` <=> 19640 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=23605 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=32686 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38996 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38997 AND `itemclass` <=> 0 AND `itemtype` <=> 29 AND `size` <=> 0 AND `maxcharges` <=> -1 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 81 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=39734 AND `itemclass` <=> 0 AND `itemtype` <=> 29 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 80 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=63244 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 25 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81138 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81160 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81298 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> -1 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81299 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> -1 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81300 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> -1 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 native item semantics mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc295_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc295_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc295_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc295_entries e ON r.item_id=e.item_id AND e.successcount>0 AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc295_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc295_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 output producer universe changed'; END IF;

 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc295_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc295_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 item identity/dependency mismatch'; END IF;
 IF already_present<>4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc295_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc295_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc295_recipes q ON q.id=r.recipe_id LEFT JOIN rrc295_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc295_recipes q ON q.id=r.recipe_id)<>31 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc295_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc295_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc295_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-4 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-31 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 rollback count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc295_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc295_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc295_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc295_entries e ON r.item_id=e.item_id AND e.successcount>0 AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc295_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc295_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC295 output producer universe changed'; END IF;
 DROP TEMPORARY TABLE rrc295_peer_entries;
 DROP TEMPORARY TABLE rrc295_peer_recipes;
 DROP TEMPORARY TABLE rrc295_entries;
 DROP TEMPORARY TABLE rrc295_recipes;
 DROP TEMPORARY TABLE rrc295_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC295' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
