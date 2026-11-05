-- RRC254: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc254_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc254_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc254_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc254_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3097620,CONVERT(0x496d6275656420426c61636b656e656420506561726c2053696c7665722052696e67 USING utf8mb4),68,0,52,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204c656761637920696d62756564206a6577656c7279207265636f6e737472756374696f6e3b205252433235342e USING utf8mb4),0,0,0,1,6,-1,NULL,NULL),
(3097621,CONVERT(0x496d6275656420506c6174696e756d204469616d6f6e642052696e67 USING utf8mb4),68,0,287,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204c656761637920696d62756564206a6577656c7279207265636f6e737472756374696f6e3b205252433235342e USING utf8mb4),0,0,0,1,6,-1,NULL,NULL),
(3097622,CONVERT(0x496d6275656420426c61636b2053617070686972652053696c766572204e65636b6c616365 USING utf8mb4),68,0,68,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204c656761637920696d62756564206a6577656c7279207265636f6e737472756374696f6e3b205252433235342e USING utf8mb4),0,0,0,1,6,-1,NULL,NULL),
(3097623,CONVERT(0x496d6275656420426c61636b20536170706869726520456c65637472756d2045617272696e67 USING utf8mb4),68,0,140,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204c656761637920696d62756564206a6577656c7279207265636f6e737472756374696f6e3b205252433235342e USING utf8mb4),0,0,0,1,6,-1,NULL,NULL),
(3097624,CONVERT(0x496d6275656420476f6c6420426c61636b2053617070686972652045617272696e67 USING utf8mb4),68,0,212,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204c656761637920696d62756564206a6577656c7279207265636f6e737472756374696f6e3b205252433235342e USING utf8mb4),0,0,0,1,6,-1,NULL,NULL),
(3097625,CONVERT(0x496d6275656420426c61636b20536170706869726520506c6174696e756d204e65636b6c616365 USING utf8mb4),68,0,284,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204c656761637920696d62756564206a6577656c7279207265636f6e737472756374696f6e3b205252433235342e USING utf8mb4),0,0,0,1,6,-1,NULL,NULL),
(3097626,CONVERT(0x496d627565642053696c76657220526f73652052696e67 USING utf8mb4),68,0,34,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204c656761637920696d62756564206a6577656c7279207265636f6e737472756374696f6e3b205252433235342e USING utf8mb4),0,0,0,1,6,-1,NULL,NULL),
(3097627,CONVERT(0x496d6275656420456c65637472756d20526f736520416d756c6574 USING utf8mb4),68,0,98,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204c656761637920696d62756564206a6577656c7279207265636f6e737472756374696f6e3b205252433235342e USING utf8mb4),0,0,0,1,6,-1,NULL,NULL),
(3097628,CONVERT(0x496d6275656420476f6c64656e20526f736520416d756c6574 USING utf8mb4),68,0,170,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204c656761637920696d62756564206a6577656c7279207265636f6e737472756374696f6e3b205252433235342e USING utf8mb4),0,0,0,1,6,-1,NULL,NULL),
(3097629,CONVERT(0x496d627565642053696c76657220506c61696e732052696e67 USING utf8mb4),68,0,34,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204c656761637920696d62756564206a6577656c7279207265636f6e737472756374696f6e3b205252433235342e USING utf8mb4),0,0,0,1,6,-1,NULL,NULL),
(3097630,CONVERT(0x496d6275656420456c65637472756d20506c61696e732045617272696e67 USING utf8mb4),68,0,98,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204c656761637920696d62756564206a6577656c7279207265636f6e737472756374696f6e3b205252433235342e USING utf8mb4),0,0,0,1,6,-1,NULL,NULL),
(3097631,CONVERT(0x496d6275656420476f6c64656e20506c61696e732045617272696e67 USING utf8mb4),68,0,170,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204c656761637920696d62756564206a6577656c7279207265636f6e737472756374696f6e3b205252433235342e USING utf8mb4),0,0,0,1,6,-1,NULL,NULL),
(3097632,CONVERT(0x496d6275656420506c6174696e756d20506c61696e732052696e67 USING utf8mb4),68,0,242,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204c656761637920696d62756564206a6577656c7279207265636f6e737472756374696f6e3b205252433235342e USING utf8mb4),0,0,0,1,6,-1,NULL,NULL);
INSERT INTO rrc254_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3097620,16504,0,0,1,1,0),
(3097620,20565,1,0,0,0,0),
(3097620,22548,0,0,1,1,0),
(3097620,17187,0,0,0,0,1),
(3097621,16507,0,0,1,1,0),
(3097621,20572,1,0,0,0,0),
(3097621,22549,0,0,1,1,0),
(3097621,17187,0,0,0,0,1),
(3097622,16504,0,0,1,1,0),
(3097622,20573,1,0,0,0,0),
(3097622,22551,0,0,1,1,0),
(3097622,17187,0,0,0,0,1),
(3097623,16505,0,0,1,1,0),
(3097623,20574,1,0,0,0,0),
(3097623,22551,0,0,1,1,0),
(3097623,17187,0,0,0,0,1),
(3097624,16506,0,0,1,1,0),
(3097624,20575,1,0,0,0,0),
(3097624,22551,0,0,1,1,0),
(3097624,17187,0,0,0,0,1),
(3097625,16507,0,0,1,1,0),
(3097625,20576,1,0,0,0,0),
(3097625,22551,0,0,1,1,0),
(3097625,17187,0,0,0,0,1),
(3097626,16504,0,0,1,1,0),
(3097626,20597,1,0,0,0,0),
(3097626,22550,0,0,1,1,0),
(3097626,17187,0,0,0,0,1),
(3097627,16505,0,0,1,1,0),
(3097627,20598,1,0,0,0,0),
(3097627,22550,0,0,1,1,0),
(3097627,17187,0,0,0,0,1),
(3097628,16506,0,0,1,1,0),
(3097628,20599,1,0,0,0,0),
(3097628,22550,0,0,1,1,0),
(3097628,17187,0,0,0,0,1),
(3097629,16504,0,0,1,1,0),
(3097629,20891,1,0,0,0,0),
(3097629,22553,0,0,1,1,0),
(3097629,17187,0,0,0,0,1),
(3097630,16505,0,0,1,1,0),
(3097630,20892,1,0,0,0,0),
(3097630,22553,0,0,1,1,0),
(3097630,17187,0,0,0,0,1),
(3097631,16506,0,0,1,1,0),
(3097631,20893,1,0,0,0,0),
(3097631,22553,0,0,1,1,0),
(3097631,17187,0,0,0,0,1),
(3097632,16507,0,0,1,1,0),
(3097632,20894,1,0,0,0,0),
(3097632,22553,0,0,1,1,0),
(3097632,17187,0,0,0,0,1);
INSERT INTO rrc254_items (`id`,`name`) VALUES
(16504,CONVERT(0x456e6368616e7465642053696c76657220426172 USING utf8mb4)),
(16505,CONVERT(0x456e6368616e74656420456c65637472756d20426172 USING utf8mb4)),
(16506,CONVERT(0x456e6368616e74656420476f6c6420426172 USING utf8mb4)),
(16507,CONVERT(0x456e6368616e74656420506c6174696e756d20426172 USING utf8mb4)),
(17187,CONVERT(0x436f6c6c61707369626c65204a6577656c65722773204b6974 USING utf8mb4)),
(20565,CONVERT(0x496d6275656420426c61636b656e656420506561726c2053696c7665722052696e67 USING utf8mb4)),
(20572,CONVERT(0x496d6275656420506c6174696e756d204469616d6f6e642052696e67 USING utf8mb4)),
(20573,CONVERT(0x496d6275656420426c61636b2053617070686972652053696c766572204e65636b6c616365 USING utf8mb4)),
(20574,CONVERT(0x496d6275656420426c61636b20536170706869726520456c65637472756d2045617272696e67 USING utf8mb4)),
(20575,CONVERT(0x496d6275656420476f6c6420426c61636b2053617070686972652045617272696e67 USING utf8mb4)),
(20576,CONVERT(0x496d6275656420426c61636b20536170706869726520506c6174696e756d204e65636b6c616365 USING utf8mb4)),
(20597,CONVERT(0x496d627565642053696c76657220526f73652052696e67 USING utf8mb4)),
(20598,CONVERT(0x496d6275656420456c65637472756d20526f736520416d756c6574 USING utf8mb4)),
(20599,CONVERT(0x496d6275656420476f6c64656e20526f736520416d756c6574 USING utf8mb4)),
(20891,CONVERT(0x496d627565642053696c76657220506c61696e732052696e67 USING utf8mb4)),
(20892,CONVERT(0x496d6275656420456c65637472756d20506c61696e732045617272696e67 USING utf8mb4)),
(20893,CONVERT(0x496d6275656420476f6c64656e20506c61696e732045617272696e67 USING utf8mb4)),
(20894,CONVERT(0x496d6275656420506c6174696e756d20506c61696e732052696e67 USING utf8mb4)),
(22548,CONVERT(0x496d6275656420426c61636b20506561726c USING utf8mb4)),
(22549,CONVERT(0x496d62756564204469616d6f6e64 USING utf8mb4)),
(22550,CONVERT(0x496d6275656420526f73652051756172747a USING utf8mb4)),
(22551,CONVERT(0x496d6275656420426c61636b205361707068697265 USING utf8mb4)),
(22553,CONVERT(0x496d6275656420506c61696e7320506562626c65 USING utf8mb4));
 CREATE TEMPORARY TABLE rrc254_peer_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc254_peer_entries LIKE tradeskill_recipe_entries;
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 target database mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16504 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16505 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16506 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16507 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17187 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 20 AND `bagslots` <=> 6 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=20565 AND `itemclass` <=> 0 AND `itemtype` <=> 29 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 512 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=20572 AND `itemclass` <=> 0 AND `itemtype` <=> 29 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 256 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=20573 AND `itemclass` <=> 0 AND `itemtype` <=> 29 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 2 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=20574 AND `itemclass` <=> 0 AND `itemtype` <=> 29 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 2 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=20575 AND `itemclass` <=> 0 AND `itemtype` <=> 29 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 2 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=20576 AND `itemclass` <=> 0 AND `itemtype` <=> 29 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 2 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=20597 AND `itemclass` <=> 0 AND `itemtype` <=> 29 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 16 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=20598 AND `itemclass` <=> 0 AND `itemtype` <=> 29 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 16 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=20599 AND `itemclass` <=> 0 AND `itemtype` <=> 29 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 16 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=20891 AND `itemclass` <=> 0 AND `itemtype` <=> 29 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 128 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=20892 AND `itemclass` <=> 0 AND `itemtype` <=> 29 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 128 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=20893 AND `itemclass` <=> 0 AND `itemtype` <=> 29 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 128 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=20894 AND `itemclass` <=> 0 AND `itemtype` <=> 29 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 128 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=22548 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=22549 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=22550 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=22551 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=22553 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 native item semantics mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc254_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc254_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc254_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc254_entries e ON r.item_id=e.item_id AND e.successcount>0 AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc254_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc254_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 output producer universe changed'; END IF;

 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc254_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc254_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 item identity/dependency mismatch'; END IF;
 IF already_present<>13 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc254_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc254_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc254_recipes q ON q.id=r.recipe_id LEFT JOIN rrc254_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc254_recipes q ON q.id=r.recipe_id)<>52 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc254_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc254_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc254_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-13 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-52 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 rollback count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc254_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc254_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc254_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc254_entries e ON r.item_id=e.item_id AND e.successcount>0 AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc254_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc254_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC254 output producer universe changed'; END IF;
 DROP TEMPORARY TABLE rrc254_peer_entries;
 DROP TEMPORARY TABLE rrc254_peer_recipes;
 DROP TEMPORARY TABLE rrc254_entries;
 DROP TEMPORARY TABLE rrc254_recipes;
 DROP TEMPORARY TABLE rrc254_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC254' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
