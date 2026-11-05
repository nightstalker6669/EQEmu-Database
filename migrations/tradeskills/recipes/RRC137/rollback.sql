-- RRC137: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc137_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc137_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc137_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc137_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3094883,CONVERT(0x466561726c696e6b6564204368657374205365616c USING utf8mb4),57,0,463,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133372e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3094884,CONVERT(0x466561726c696e6b6564204c656767696e67205365616c USING utf8mb4),57,0,451,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133372e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3094885,CONVERT(0x466561726c696e6b656420426f6f74205365616c USING utf8mb4),57,0,450,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133372e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3094886,CONVERT(0x466561726c696e6b656420536c65657665205365616c USING utf8mb4),57,0,447,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133372e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3094887,CONVERT(0x466561726c696e6b6564205772697374205365616c USING utf8mb4),57,0,442,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133372e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3094888,CONVERT(0x466561726c696e6b656420476c6f7665205365616c USING utf8mb4),57,0,443,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133372e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3094889,CONVERT(0x466561726c696e6b65642048656c6d205365616c USING utf8mb4),57,0,446,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133372e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL);
INSERT INTO rrc137_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3094883,134543,1,0,0,0,0),
(3094883,34525,0,0,1,1,0),
(3094883,134550,0,0,1,1,0),
(3094883,63244,0,0,3,3,0),
(3094883,16503,0,0,2,2,0),
(3094883,134654,0,0,1,1,0),
(3094883,33439,0,0,1,1,0),
(3094883,10254,0,0,1,1,0),
(3094883,17877,0,0,0,0,1),
(3094884,134544,1,0,0,0,0),
(3094884,34532,0,0,1,1,0),
(3094884,134550,0,0,1,1,0),
(3094884,63244,0,0,3,3,0),
(3094884,16503,0,0,2,2,0),
(3094884,134654,0,0,1,1,0),
(3094884,33439,0,0,1,1,0),
(3094884,10254,0,0,1,1,0),
(3094884,17877,0,0,0,0,1),
(3094885,134545,1,0,0,0,0),
(3094885,34533,0,0,1,1,0),
(3094885,134550,0,0,1,1,0),
(3094885,63244,0,0,3,3,0),
(3094885,16503,0,0,2,2,0),
(3094885,134654,0,0,1,1,0),
(3094885,33439,0,0,1,1,0),
(3094885,10254,0,0,1,1,0),
(3094885,17877,0,0,0,0,1),
(3094886,134546,1,0,0,0,0),
(3094886,34529,0,0,1,1,0),
(3094886,134550,0,0,1,1,0),
(3094886,63244,0,0,3,3,0),
(3094886,16503,0,0,2,2,0),
(3094886,134654,0,0,1,1,0),
(3094886,33439,0,0,1,1,0),
(3094886,10254,0,0,1,1,0),
(3094886,17877,0,0,0,0,1),
(3094887,134547,1,0,0,0,0),
(3094887,34530,0,0,1,1,0),
(3094887,134550,0,0,1,1,0),
(3094887,63244,0,0,3,3,0),
(3094887,16503,0,0,2,2,0),
(3094887,134654,0,0,1,1,0),
(3094887,33439,0,0,1,1,0),
(3094887,10254,0,0,1,1,0),
(3094887,17877,0,0,0,0,1),
(3094888,134548,1,0,0,0,0),
(3094888,34531,0,0,1,1,0),
(3094888,134550,0,0,1,1,0),
(3094888,63244,0,0,3,3,0),
(3094888,16503,0,0,2,2,0),
(3094888,134654,0,0,1,1,0),
(3094888,33439,0,0,1,1,0),
(3094888,10254,0,0,1,1,0),
(3094888,17877,0,0,0,0,1),
(3094889,134549,1,0,0,0,0),
(3094889,34522,0,0,1,1,0),
(3094889,134550,0,0,1,1,0),
(3094889,63244,0,0,3,3,0),
(3094889,16503,0,0,2,2,0),
(3094889,134654,0,0,1,1,0),
(3094889,33439,0,0,1,1,0),
(3094889,10254,0,0,1,1,0),
(3094889,17877,0,0,0,0,1);
INSERT INTO rrc137_items (`id`,`name`) VALUES
(10254,CONVERT(0x5669616c206f66205075726966696564204d616e61 USING utf8mb4)),
(16503,CONVERT(0x506c6174696e756d20426172 USING utf8mb4)),
(17877,CONVERT(0x44656c75786520546f6f6c626f78 USING utf8mb4)),
(33439,CONVERT(0x5365616c205061747465726e USING utf8mb4)),
(34522,CONVERT(0x436861696e6d61696c20436f69662054656d706c617465205061747465726e USING utf8mb4)),
(34525,CONVERT(0x436861696e6d61696c20436865737467756172642054656d706c617465205061747465726e USING utf8mb4)),
(34529,CONVERT(0x436861696e6d61696c2041726d732054656d706c617465205061747465726e USING utf8mb4)),
(34530,CONVERT(0x436861696e6d61696c204272616365722054656d706c617465205061747465726e USING utf8mb4)),
(34531,CONVERT(0x436861696e6d61696c20476c6f7665732054656d706c617465205061747465726e USING utf8mb4)),
(34532,CONVERT(0x436861696e6d61696c204c6567706c617465732054656d706c617465205061747465726e USING utf8mb4)),
(34533,CONVERT(0x436861696e6d61696c20426f6f74732054656d706c617465205061747465726e USING utf8mb4)),
(63244,CONVERT(0x476e6f6d697368204865617420536f75726365 USING utf8mb4)),
(134543,CONVERT(0x466561726c696e6b6564204368657374205365616c USING utf8mb4)),
(134544,CONVERT(0x466561726c696e6b6564204c656767696e67205365616c USING utf8mb4)),
(134545,CONVERT(0x466561726c696e6b656420426f6f74205365616c USING utf8mb4)),
(134546,CONVERT(0x466561726c696e6b656420536c65657665205365616c USING utf8mb4)),
(134547,CONVERT(0x466561726c696e6b6564205772697374205365616c USING utf8mb4)),
(134548,CONVERT(0x466561726c696e6b656420476c6f7665205365616c USING utf8mb4)),
(134549,CONVERT(0x466561726c696e6b65642048656c6d205365616c USING utf8mb4)),
(134550,CONVERT(0x466561726c696e6b6564205761746572 USING utf8mb4)),
(134654,CONVERT(0x53636f7263686564204f7265 USING utf8mb4));
 START TRANSACTION;

 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc137_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc137_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=10254 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 24576 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16503 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17877 AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 10 AND `bagslots` <=> 10 AND `bagsize` <=> 4 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=33439 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34522 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 75 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34525 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 75 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34529 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 75 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34530 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34531 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34532 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 50 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34533 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 75 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=63244 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 25 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134543 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 95 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134544 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 95 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134545 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 95 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134546 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 95 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134547 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 95 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134548 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 95 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134549 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 95 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134550 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134654 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 native item semantics mismatch'; END IF;
 IF already_present<>7 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc137_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc137_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc137_recipes q ON q.id=r.recipe_id LEFT JOIN rrc137_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc137_recipes q ON q.id=r.recipe_id)<>63 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc137_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc137_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc137_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-7 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-63 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC137 rollback count mismatch'; END IF;
 DROP TEMPORARY TABLE rrc137_entries;
 DROP TEMPORARY TABLE rrc137_recipes;
 DROP TEMPORARY TABLE rrc137_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC137' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
