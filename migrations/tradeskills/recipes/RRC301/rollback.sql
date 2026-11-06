-- RRC301: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc301_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc301_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc301_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc301_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3102767,CONVERT(0x456c6567616e742053746f6e6520436172766564205461626c65 USING utf8mb4),68,0,202,0,0,CONVERT(0x46696e69746531332061757468656e74696320706c61636564204a6577656c72795461626c6535343235302079617264207265636970652d6c69737420726f757465733b5252433330312e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3102768,CONVERT(0x4c617267652053746f6e652043617276656420436f756e746572 USING utf8mb4),68,0,202,0,0,CONVERT(0x46696e69746531332061757468656e74696320706c61636564204a6577656c72795461626c6535343235302079617264207265636970652d6c69737420726f757465733b5252433330312e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3102769,CONVERT(0x536d616c6c2053746f6e65204361727665642044726573736572 USING utf8mb4),68,0,202,0,0,CONVERT(0x46696e69746531332061757468656e74696320706c61636564204a6577656c72795461626c6535343235302079617264207265636970652d6c69737420726f757465733b5252433330312e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3102770,CONVERT(0x53696d706c652053746f6e652043617276656420507562205461626c65 USING utf8mb4),68,0,202,0,0,CONVERT(0x46696e69746531332061757468656e74696320706c61636564204a6577656c72795461626c6535343235302079617264207265636970652d6c69737420726f757465733b5252433330312e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3102771,CONVERT(0x4c6f6674792053746f6e6520436172766564204368616972 USING utf8mb4),68,0,175,0,0,CONVERT(0x46696e69746531332061757468656e74696320706c61636564204a6577656c72795461626c6535343235302079617264207265636970652d6c69737420726f757465733b5252433330312e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3102772,CONVERT(0x436f6d666f727461626c652053746f6e652043617276656420436f74 USING utf8mb4),68,0,188,0,0,CONVERT(0x46696e69746531332061757468656e74696320706c61636564204a6577656c72795461626c6535343235302079617264207265636970652d6c69737420726f757465733b5252433330312e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3102773,CONVERT(0x536d616c6c2053746f6e652043617276656420426564 USING utf8mb4),68,0,202,0,0,CONVERT(0x46696e69746531332061757468656e74696320706c61636564204a6577656c72795461626c6535343235302079617264207265636970652d6c69737420726f757465733b5252433330312e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3102774,CONVERT(0x4772616e64696f73652053746f6e652043686973656c6564205461626c65 USING utf8mb4),68,0,202,0,0,CONVERT(0x46696e69746531332061757468656e74696320706c61636564204a6577656c72795461626c6535343235302079617264207265636970652d6c69737420726f757465733b5252433330312e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3102775,CONVERT(0x4d6964646c652053697a65642053746f6e652043686973656c656420436f756e746572 USING utf8mb4),68,0,202,0,0,CONVERT(0x46696e69746531332061757468656e74696320706c61636564204a6577656c72795461626c6535343235302079617264207265636970652d6c69737420726f757465733b5252433330312e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3102776,CONVERT(0x5374757264792053746f6e652043686973656c656420476174686572696e67205461626c65 USING utf8mb4),68,0,188,0,0,CONVERT(0x46696e69746531332061757468656e74696320706c61636564204a6577656c72795461626c6535343235302079617264207265636970652d6c69737420726f757465733b5252433330312e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3102777,CONVERT(0x46696e652053746f6e652043686973656c656420506577 USING utf8mb4),68,0,188,0,0,CONVERT(0x46696e69746531332061757468656e74696320706c61636564204a6577656c72795461626c6535343235302079617264207265636970652d6c69737420726f757465733b5252433330312e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3102778,CONVERT(0x537461747565737175652053746f6e652043686973656c6564204368616972 USING utf8mb4),68,0,175,0,0,CONVERT(0x46696e69746531332061757468656e74696320706c61636564204a6577656c72795461626c6535343235302079617264207265636970652d6c69737420726f757465733b5252433330312e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3102779,CONVERT(0x5377616e6b2053746f6e652043686973656c656420426564 USING utf8mb4),68,0,202,0,0,CONVERT(0x46696e69746531332061757468656e74696320706c61636564204a6577656c72795461626c6535343235302079617264207265636970652d6c69737420726f757465733b5252433330312e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL);
INSERT INTO rrc301_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3102767,61642,1,0,0,0,0),
(3102767,81309,0,0,2,2,0),
(3102767,81310,0,0,4,4,0),
(3102767,81312,0,0,1,1,0),
(3102767,81315,0,0,1,1,0),
(3102767,81320,0,0,1,1,0),
(3102767,81321,0,0,1,1,0),
(3102767,20,0,0,0,0,1),
(3102768,61659,1,0,0,0,0),
(3102768,81309,0,0,2,2,0),
(3102768,81311,0,0,2,2,0),
(3102768,81312,0,0,1,1,0),
(3102768,81315,0,0,1,1,0),
(3102768,81320,0,0,1,1,0),
(3102768,81323,0,0,1,1,0),
(3102768,20,0,0,0,0,1),
(3102769,61669,1,0,0,0,0),
(3102769,81309,0,0,2,2,0),
(3102769,81311,0,0,1,1,0),
(3102769,81312,0,0,1,1,0),
(3102769,81316,0,0,1,1,0),
(3102769,81319,0,0,1,1,0),
(3102769,81320,0,0,1,1,0),
(3102769,81321,0,0,1,1,0),
(3102769,20,0,0,0,0,1),
(3102770,61674,1,0,0,0,0),
(3102770,81309,0,0,1,1,0),
(3102770,81310,0,0,4,4,0),
(3102770,81312,0,0,1,1,0),
(3102770,81315,0,0,1,1,0),
(3102770,81320,0,0,1,1,0),
(3102770,81321,0,0,1,1,0),
(3102770,20,0,0,0,0,1),
(3102771,61703,1,0,0,0,0),
(3102771,81309,0,0,1,1,0),
(3102771,81310,0,0,4,4,0),
(3102771,81312,0,0,1,1,0),
(3102771,81318,0,0,1,1,0),
(3102771,20,0,0,0,0,1),
(3102772,61713,1,0,0,0,0),
(3102772,81309,0,0,2,2,0),
(3102772,81311,0,0,1,1,0),
(3102772,81312,0,0,1,1,0),
(3102772,81315,0,0,1,1,0),
(3102772,81320,0,0,1,1,0),
(3102772,81322,0,0,1,1,0),
(3102772,20,0,0,0,0,1),
(3102773,61724,1,0,0,0,0),
(3102773,81310,0,0,4,4,0),
(3102773,81311,0,0,1,1,0),
(3102773,81315,0,0,1,1,0),
(3102773,81317,0,0,1,1,0),
(3102773,81322,0,0,1,1,0),
(3102773,20,0,0,0,0,1),
(3102774,61738,1,0,0,0,0),
(3102774,81309,0,0,2,2,0),
(3102774,81310,0,0,4,4,0),
(3102774,81312,0,0,1,1,0),
(3102774,81315,0,0,1,1,0),
(3102774,81320,0,0,1,1,0),
(3102774,81324,0,0,1,1,0),
(3102774,20,0,0,0,0,1),
(3102775,61757,1,0,0,0,0),
(3102775,81309,0,0,2,2,0),
(3102775,81311,0,0,2,2,0),
(3102775,81312,0,0,1,1,0),
(3102775,81319,0,0,1,1,0),
(3102775,81320,0,0,1,1,0),
(3102775,81323,0,0,1,1,0),
(3102775,20,0,0,0,0,1),
(3102776,61765,1,0,0,0,0),
(3102776,81309,0,0,1,1,0),
(3102776,81310,0,0,4,4,0),
(3102776,81312,0,0,1,1,0),
(3102776,81315,0,0,1,1,0),
(3102776,81318,0,0,1,1,0),
(3102776,81320,0,0,1,1,0),
(3102776,20,0,0,0,0,1),
(3102777,61769,1,0,0,0,0),
(3102777,81309,0,0,2,2,0),
(3102777,81310,0,0,2,2,0),
(3102777,81312,0,0,1,1,0),
(3102777,81318,0,0,1,1,0),
(3102777,81319,0,0,1,1,0),
(3102777,20,0,0,0,0,1),
(3102778,61792,1,0,0,0,0),
(3102778,81309,0,0,1,1,0),
(3102778,81310,0,0,4,4,0),
(3102778,81312,0,0,1,1,0),
(3102778,81319,0,0,1,1,0),
(3102778,20,0,0,0,0,1),
(3102779,61809,1,0,0,0,0),
(3102779,81310,0,0,4,4,0),
(3102779,81311,0,0,1,1,0),
(3102779,81317,0,0,1,1,0),
(3102779,81322,0,0,1,1,0),
(3102779,81324,0,0,1,1,0),
(3102779,20,0,0,0,0,1);
INSERT INTO rrc301_items (`id`,`name`) VALUES
(54250,CONVERT(0x4a6577656c7279204d616b696e67205461626c65 USING utf8mb4)),
(61642,CONVERT(0x456c6567616e742053746f6e6520436172766564205461626c65 USING utf8mb4)),
(61659,CONVERT(0x4c617267652053746f6e652043617276656420436f756e746572 USING utf8mb4)),
(61669,CONVERT(0x536d616c6c2053746f6e65204361727665642044726573736572 USING utf8mb4)),
(61674,CONVERT(0x53696d706c652053746f6e652043617276656420507562205461626c65 USING utf8mb4)),
(61703,CONVERT(0x4c6f6674792053746f6e6520436172766564204368616972 USING utf8mb4)),
(61713,CONVERT(0x436f6d666f727461626c652053746f6e652043617276656420436f74 USING utf8mb4)),
(61724,CONVERT(0x536d616c6c2053746f6e652043617276656420426564 USING utf8mb4)),
(61738,CONVERT(0x4772616e64696f73652053746f6e652043686973656c6564205461626c65 USING utf8mb4)),
(61757,CONVERT(0x4d6964646c652053697a65642053746f6e652043686973656c656420436f756e746572 USING utf8mb4)),
(61765,CONVERT(0x5374757264792053746f6e652043686973656c656420476174686572696e67205461626c65 USING utf8mb4)),
(61769,CONVERT(0x46696e652053746f6e652043686973656c656420506577 USING utf8mb4)),
(61792,CONVERT(0x537461747565737175652053746f6e652043686973656c6564204368616972 USING utf8mb4)),
(61809,CONVERT(0x5377616e6b2053746f6e652043686973656c656420426564 USING utf8mb4)),
(81309,CONVERT(0x53746f6e65204675726e69747572652042617365 USING utf8mb4)),
(81310,CONVERT(0x53746f6e65204675726e6974757265204c6567 USING utf8mb4)),
(81311,CONVERT(0x53746f6e65204675726e6974757265204672616d65 USING utf8mb4)),
(81312,CONVERT(0x426f6e64696e67204167656e74 USING utf8mb4)),
(81315,CONVERT(0x4e61696c73 USING utf8mb4)),
(81316,CONVERT(0x4d6574616c204b6e6f6273 USING utf8mb4)),
(81317,CONVERT(0x43757368696f6e73 USING utf8mb4)),
(81318,CONVERT(0x4465636f726174696f6e73 USING utf8mb4)),
(81319,CONVERT(0x506f6c697368 USING utf8mb4)),
(81320,CONVERT(0x4d6574616c2042616e64696e67 USING utf8mb4)),
(81321,CONVERT(0x4d6574616c2048696e676573 USING utf8mb4)),
(81322,CONVERT(0x4c696e656e73 USING utf8mb4)),
(81323,CONVERT(0x53616e647061706572 USING utf8mb4)),
(81324,CONVERT(0x4d6574616c20526f6473 USING utf8mb4));
 CREATE TEMPORARY TABLE rrc301_peer_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc301_peer_entries LIKE tradeskill_recipe_entries;
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF (SELECT COUNT(*)FROM items WHERE `id` <=> 54250 AND `Name` <=> CONVERT(0x4a6577656c7279204d616b696e67205461626c65 USING utf8mb4) AND `idfile` <=> CONVERT(0x49543131353433 USING utf8mb4) AND `itemclass` <=> 1 AND `bagslots` <=> 10 AND `bagtype` <=> 20 AND `bagsize` <=> 4 AND `placeable` <=> 1 AND `UNK224` <=> 14 AND `UNK225` <=> 0 AND `UNK226` <=> 0 AND `UNK227` <=> 0 AND `UNK228` <=> 1036831949 AND `UNK229` <=> 1075838976 AND `UNK230` <=> 6 AND `UNK231` <=> 1 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `loregroup` <=> 0 AND `nodrop` <=> 1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 exact native placed54250 metadata changed'; END IF;

 IF DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 target database mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=54250 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `size` <=> 4 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 20 AND `bagslots` <=> 10 AND `bagsize` <=> 4 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=61642 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 4 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=61659 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 4 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=61669 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 4 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=61674 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 4 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=61703 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 4 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=61713 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 4 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=61724 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 4 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=61738 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 4 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=61757 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 4 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=61765 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 4 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=61769 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 4 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=61792 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 4 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=61809 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 4 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81309 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81310 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81311 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81312 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81315 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81316 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81317 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81318 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81319 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81320 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81321 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81322 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81323 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81324 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 native item semantics mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc301_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc301_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc301_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc301_entries e ON r.item_id=e.item_id AND e.successcount>0 AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc301_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc301_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 output producer universe changed'; END IF;

 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc301_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc301_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 item identity/dependency mismatch'; END IF;
 IF already_present<>13 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc301_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc301_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc301_recipes q ON q.id=r.recipe_id LEFT JOIN rrc301_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc301_recipes q ON q.id=r.recipe_id)<>98 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc301_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc301_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc301_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-13 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-98 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 rollback count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc301_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc301_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc301_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc301_entries e ON r.item_id=e.item_id AND e.successcount>0 AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc301_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc301_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC301 output producer universe changed'; END IF;
 DROP TEMPORARY TABLE rrc301_peer_entries;
 DROP TEMPORARY TABLE rrc301_peer_recipes;
 DROP TEMPORARY TABLE rrc301_entries;
 DROP TEMPORARY TABLE rrc301_recipes;
 DROP TEMPORARY TABLE rrc301_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC301' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
