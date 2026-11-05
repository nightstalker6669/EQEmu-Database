-- RRC195: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc195_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc195_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc195_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc195_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3096533,CONVERT(0x41646f726e65642046726961626c6520506f74696f6e205669616c USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54207669616c20616e6420737570706c656d656e74616c206d6f6c64207265636f6e737472756374696f6e3b205252433139352e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096534,CONVERT(0x41646f726e656420576f726b656420506f74696f6e205669616c USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54207669616c20616e6420737570706c656d656e74616c206d6f6c64207265636f6e737472756374696f6e3b205252433139352e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096535,CONVERT(0x41646f726e65642053686170656420506f74696f6e205669616c USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54207669616c20616e6420737570706c656d656e74616c206d6f6c64207265636f6e737472756374696f6e3b205252433139352e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096536,CONVERT(0x41646f726e656420466f726d656420506f74696f6e205669616c USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54207669616c20616e6420737570706c656d656e74616c206d6f6c64207265636f6e737472756374696f6e3b205252433139352e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096537,CONVERT(0x556e66697265642041646f726e65642046726961626c6520506f74696f6e205669616c20536574 USING utf8mb4),69,0,144,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54207669616c20616e6420737570706c656d656e74616c206d6f6c64207265636f6e737472756374696f6e3b205252433139352e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096538,CONVERT(0x556e66697265642041646f726e656420576f726b656420506f74696f6e205669616c20536574 USING utf8mb4),69,0,147,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54207669616c20616e6420737570706c656d656e74616c206d6f6c64207265636f6e737472756374696f6e3b205252433139352e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096539,CONVERT(0x556e66697265642041646f726e65642053686170656420506f74696f6e205669616c20536574 USING utf8mb4),69,0,150,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54207669616c20616e6420737570706c656d656e74616c206d6f6c64207265636f6e737472756374696f6e3b205252433139352e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096540,CONVERT(0x556e66697265642041646f726e656420466f726d656420506f74696f6e205669616c20536574 USING utf8mb4),69,0,152,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54207669616c20616e6420737570706c656d656e74616c206d6f6c64207265636f6e737472756374696f6e3b205252433139352e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096541,CONVERT(0x556e6669726564204578747261766167616e7420426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,283,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54207669616c20616e6420737570706c656d656e74616c206d6f6c64207265636f6e737472756374696f6e3b205252433139352e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL);
INSERT INTO rrc195_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3096533,16908,0,0,1,1,0),
(3096533,57117,1,0,0,0,0),
(3096533,57121,0,0,1,1,0),
(3096533,9,0,0,0,0,1),
(3096534,16908,0,0,1,1,0),
(3096534,57118,1,0,0,0,0),
(3096534,57122,0,0,1,1,0),
(3096534,9,0,0,0,0,1),
(3096535,16908,0,0,1,1,0),
(3096535,57119,1,0,0,0,0),
(3096535,57123,0,0,1,1,0),
(3096535,9,0,0,0,0,1),
(3096536,16908,0,0,1,1,0),
(3096536,57120,1,0,0,0,0),
(3096536,57124,0,0,1,1,0),
(3096536,9,0,0,0,0,1),
(3096537,16902,0,0,2,2,0),
(3096537,38340,0,0,3,3,0),
(3096537,57121,1,0,0,0,0),
(3096537,57125,0,0,1,1,0),
(3096537,96894,0,0,1,1,0),
(3096537,8,0,0,0,0,1),
(3096538,38340,0,0,3,3,0),
(3096538,57122,1,0,0,0,0),
(3096538,57125,0,0,1,1,0),
(3096538,96897,0,0,1,1,0),
(3096538,8,0,0,0,0,1),
(3096539,38340,0,0,3,3,0),
(3096539,57123,1,0,0,0,0),
(3096539,57125,0,0,1,1,0),
(3096539,96900,0,0,1,1,0),
(3096539,96904,0,0,2,2,0),
(3096539,8,0,0,0,0,1),
(3096540,16902,0,0,1,1,0),
(3096540,38340,0,0,3,3,0),
(3096540,57124,1,0,0,0,0),
(3096540,57125,0,0,1,1,0),
(3096540,96903,0,0,1,1,0),
(3096540,96904,0,0,3,3,0),
(3096540,8,0,0,0,0,1),
(3096541,16902,0,0,2,2,0),
(3096541,48896,0,0,1,1,0),
(3096541,60921,1,0,0,0,0),
(3096541,123501,0,0,1,1,0),
(3096541,8,0,0,0,0,1);
INSERT INTO rrc195_items (`id`,`name`) VALUES
(16902,CONVERT(0x4c6172676520426c6f636b206f6620436c6179 USING utf8mb4)),
(16908,CONVERT(0x48696768205175616c69747920466972696e67205368656574 USING utf8mb4)),
(38340,CONVERT(0x4875676520426c6f636b206f6620436c6179 USING utf8mb4)),
(48896,CONVERT(0x426c61646520536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(57117,CONVERT(0x41646f726e65642046726961626c6520506f74696f6e205669616c USING utf8mb4)),
(57118,CONVERT(0x41646f726e656420576f726b656420506f74696f6e205669616c USING utf8mb4)),
(57119,CONVERT(0x41646f726e65642053686170656420506f74696f6e205669616c USING utf8mb4)),
(57120,CONVERT(0x41646f726e656420466f726d656420506f74696f6e205669616c USING utf8mb4)),
(57121,CONVERT(0x556e66697265642041646f726e65642046726961626c6520506f74696f6e205669616c20536574 USING utf8mb4)),
(57122,CONVERT(0x556e66697265642041646f726e656420576f726b656420506f74696f6e205669616c20536574 USING utf8mb4)),
(57123,CONVERT(0x556e66697265642041646f726e65642053686170656420506f74696f6e205669616c20536574 USING utf8mb4)),
(57124,CONVERT(0x556e66697265642041646f726e656420466f726d656420506f74696f6e205669616c20536574 USING utf8mb4)),
(57125,CONVERT(0x41646f726e696e672047656d20506f77646572 USING utf8mb4)),
(60921,CONVERT(0x556e6669726564204578747261766167616e7420426c61646520536861706564204d6f6c64 USING utf8mb4)),
(96894,CONVERT(0x416476616e6365642046726961626c6520506f74696f6e205669616c20536b65746368 USING utf8mb4)),
(96897,CONVERT(0x416476616e63656420576f726b656420506f74696f6e205669616c20536b65746368 USING utf8mb4)),
(96900,CONVERT(0x416476616e6365642053686170656420506f74696f6e205669616c20536b65746368 USING utf8mb4)),
(96903,CONVERT(0x416476616e63656420466f726d656420506f74696f6e205669616c20536b65746368 USING utf8mb4)),
(96904,CONVERT(0x47656d20506f77646572 USING utf8mb4)),
(123501,CONVERT(0x46616e7461737469632053696c6b USING utf8mb4));
 CREATE TEMPORARY TABLE rrc195_peer_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc195_peer_entries LIKE tradeskill_recipe_entries;
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 target database mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16902 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16908 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38340 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 3 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48896 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=57117 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 90 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=57118 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 90 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=57119 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 90 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=57120 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 90 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=57121 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 90 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=57122 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 90 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=57123 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 90 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=57124 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 90 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=57125 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 90 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60921 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96894 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96897 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96900 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96903 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96904 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=123501 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 native item semantics mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc195_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc195_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc195_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc195_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc195_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc195_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 output producer universe changed'; END IF;

 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc195_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc195_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 item identity/dependency mismatch'; END IF;
 IF already_present<>9 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc195_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc195_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc195_recipes q ON q.id=r.recipe_id LEFT JOIN rrc195_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc195_recipes q ON q.id=r.recipe_id)<>45 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc195_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc195_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc195_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-9 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-45 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 rollback count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc195_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc195_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc195_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc195_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc195_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc195_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC195 output producer universe changed'; END IF;
 DROP TEMPORARY TABLE rrc195_peer_entries;
 DROP TEMPORARY TABLE rrc195_peer_recipes;
 DROP TEMPORARY TABLE rrc195_entries;
 DROP TEMPORARY TABLE rrc195_recipes;
 DROP TEMPORARY TABLE rrc195_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC195' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
