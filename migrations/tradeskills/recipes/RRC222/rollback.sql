-- RRC222: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc222_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc222_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc222_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc222_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3096850,CONVERT(0x466f726d65642053757370656e73696f6e206f6620536c696d652049 USING utf8mb4),59,0,38,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220466f726d656420416c6368656d792053757370656e73696f6e73207265636f6e737472756374696f6e3b205252433232322e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096851,CONVERT(0x466f726d65642053757370656e73696f6e206f6620536c696d65204949 USING utf8mb4),59,0,59,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220466f726d656420416c6368656d792053757370656e73696f6e73207265636f6e737472756374696f6e3b205252433232322e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096852,CONVERT(0x466f726d65642053757370656e73696f6e206f6620536c696d6520494949 USING utf8mb4),59,0,86,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220466f726d656420416c6368656d792053757370656e73696f6e73207265636f6e737472756374696f6e3b205252433232322e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096853,CONVERT(0x466f726d65642053757370656e73696f6e206f6620536c696d65204956 USING utf8mb4),59,0,112,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220466f726d656420416c6368656d792053757370656e73696f6e73207265636f6e737472756374696f6e3b205252433232322e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096854,CONVERT(0x466f726d65642053757370656e73696f6e206f6620536c696d652056 USING utf8mb4),59,0,151,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220466f726d656420416c6368656d792053757370656e73696f6e73207265636f6e737472756374696f6e3b205252433232322e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096855,CONVERT(0x466f726d65642053757370656e73696f6e206f6620536c696d65205649 USING utf8mb4),59,0,188,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220466f726d656420416c6368656d792053757370656e73696f6e73207265636f6e737472756374696f6e3b205252433232322e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096856,CONVERT(0x466f726d65642053757370656e73696f6e206f6620546f78696e2049 USING utf8mb4),59,0,36,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220466f726d656420416c6368656d792053757370656e73696f6e73207265636f6e737472756374696f6e3b205252433232322e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096857,CONVERT(0x466f726d65642053757370656e73696f6e206f6620546f78696e204949 USING utf8mb4),59,0,56,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220466f726d656420416c6368656d792053757370656e73696f6e73207265636f6e737472756374696f6e3b205252433232322e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096858,CONVERT(0x466f726d65642053757370656e73696f6e206f6620546f78696e20494949 USING utf8mb4),59,0,82,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220466f726d656420416c6368656d792053757370656e73696f6e73207265636f6e737472756374696f6e3b205252433232322e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096859,CONVERT(0x466f726d65642053757370656e73696f6e206f6620546f78696e204956 USING utf8mb4),59,0,108,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220466f726d656420416c6368656d792053757370656e73696f6e73207265636f6e737472756374696f6e3b205252433232322e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096860,CONVERT(0x466f726d65642053757370656e73696f6e206f6620546f78696e2056 USING utf8mb4),59,0,144,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220466f726d656420416c6368656d792053757370656e73696f6e73207265636f6e737472756374696f6e3b205252433232322e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096861,CONVERT(0x466f726d65642053757370656e73696f6e206f6620546f78696e205649 USING utf8mb4),59,0,179,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220466f726d656420416c6368656d792053757370656e73696f6e73207265636f6e737472756374696f6e3b205252433232322e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096862,CONVERT(0x466f726d65642053757370656e73696f6e206f6620546f78696e20564949 USING utf8mb4),59,0,220,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220466f726d656420416c6368656d792053757370656e73696f6e73207265636f6e737472756374696f6e3b205252433232322e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL);
INSERT INTO rrc222_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3096850,51403,0,0,1,1,0),
(3096850,95891,0,0,1,1,0),
(3096850,95899,0,0,2,2,0),
(3096850,95935,0,0,1,1,0),
(3096850,96293,1,0,0,0,0),
(3096850,96842,0,0,1,1,0),
(3096850,17901,0,0,0,0,1),
(3096851,16512,0,0,1,1,0),
(3096851,95891,0,0,1,1,0),
(3096851,95899,0,0,2,2,0),
(3096851,95935,0,0,1,1,0),
(3096851,96294,1,0,0,0,0),
(3096851,96843,0,0,1,1,0),
(3096851,17901,0,0,0,0,1),
(3096852,16515,0,0,1,1,0),
(3096852,95892,0,0,1,1,0),
(3096852,95900,0,0,2,2,0),
(3096852,95936,0,0,1,1,0),
(3096852,96295,1,0,0,0,0),
(3096852,96844,0,0,1,1,0),
(3096852,17901,0,0,0,0,1),
(3096853,51399,0,0,1,1,0),
(3096853,95892,0,0,1,1,0),
(3096853,95900,0,0,2,2,0),
(3096853,95936,0,0,1,1,0),
(3096853,96296,1,0,0,0,0),
(3096853,96845,0,0,1,1,0),
(3096853,17901,0,0,0,0,1),
(3096854,22141,0,0,1,1,0),
(3096854,95892,0,0,1,1,0),
(3096854,95900,0,0,2,2,0),
(3096854,95936,0,0,1,1,0),
(3096854,96297,1,0,0,0,0),
(3096854,96846,0,0,1,1,0),
(3096854,17901,0,0,0,0,1),
(3096855,14229,0,0,1,1,0),
(3096855,95893,0,0,1,1,0),
(3096855,95901,0,0,2,2,0),
(3096855,95937,0,0,1,1,0),
(3096855,96298,1,0,0,0,0),
(3096855,96847,0,0,1,1,0),
(3096855,17901,0,0,0,0,1),
(3096856,51403,0,0,1,1,0),
(3096856,95903,0,0,1,1,0),
(3096856,95907,0,0,1,1,0),
(3096856,95927,0,0,2,2,0),
(3096856,96333,1,0,0,0,0),
(3096856,96842,0,0,1,1,0),
(3096856,17901,0,0,0,0,1),
(3096857,16512,0,0,1,1,0),
(3096857,95903,0,0,1,1,0),
(3096857,95908,0,0,1,1,0),
(3096857,95927,0,0,2,2,0),
(3096857,96334,1,0,0,0,0),
(3096857,96843,0,0,1,1,0),
(3096857,17901,0,0,0,0,1),
(3096858,16515,0,0,1,1,0),
(3096858,95904,0,0,1,1,0),
(3096858,95908,0,0,1,1,0),
(3096858,95928,0,0,2,2,0),
(3096858,96335,1,0,0,0,0),
(3096858,96844,0,0,1,1,0),
(3096858,17901,0,0,0,0,1),
(3096859,51399,0,0,1,1,0),
(3096859,95904,0,0,1,1,0),
(3096859,95908,0,0,1,1,0),
(3096859,95929,0,0,2,2,0),
(3096859,96336,1,0,0,0,0),
(3096859,96845,0,0,1,1,0),
(3096859,17901,0,0,0,0,1),
(3096860,22141,0,0,1,1,0),
(3096860,95904,0,0,1,1,0),
(3096860,95908,0,0,1,1,0),
(3096860,95928,0,0,2,2,0),
(3096860,96337,1,0,0,0,0),
(3096860,96846,0,0,1,1,0),
(3096860,17901,0,0,0,0,1),
(3096861,14229,0,0,1,1,0),
(3096861,95905,0,0,1,1,0),
(3096861,95909,0,0,1,1,0),
(3096861,95929,0,0,2,2,0),
(3096861,96338,1,0,0,0,0),
(3096861,96847,0,0,1,1,0),
(3096861,17901,0,0,0,0,1),
(3096862,22142,0,0,1,1,0),
(3096862,95905,0,0,1,1,0),
(3096862,95909,0,0,1,1,0),
(3096862,95929,0,0,2,2,0),
(3096862,96339,1,0,0,0,0),
(3096862,96848,0,0,1,1,0),
(3096862,17901,0,0,0,0,1);
INSERT INTO rrc222_items (`id`,`name`) VALUES
(14229,CONVERT(0x426c7565205665727661696e2042756c62 USING utf8mb4)),
(16512,CONVERT(0x537469636b6c65776f7274 USING utf8mb4)),
(16515,CONVERT(0x566f7827732044757374 USING utf8mb4)),
(17901,CONVERT(0x4d65646963696e6520426167 USING utf8mb4)),
(22141,CONVERT(0x56696f6c6574205472692d5475626520536170 USING utf8mb4)),
(22142,CONVERT(0x42657468657269756d204261726b USING utf8mb4)),
(51399,CONVERT(0x42656c616e USING utf8mb4)),
(51403,CONVERT(0x436963696e6f USING utf8mb4)),
(95891,CONVERT(0x467261676d656e74206f6620416e6775727468 USING utf8mb4)),
(95892,CONVERT(0x416e6775727468204c656166 USING utf8mb4)),
(95893,CONVERT(0x5370726967206f6620416e6775727468 USING utf8mb4)),
(95899,CONVERT(0x53706c696e746572206f6620426974746572776f6f64 USING utf8mb4)),
(95900,CONVERT(0x426974746572776f6f642054776967 USING utf8mb4)),
(95901,CONVERT(0x42756e646c65206f6620426974746572776f6f64205477696773 USING utf8mb4)),
(95903,CONVERT(0x477261696e206f662042756c62204c6f74757320506f6c6c656e USING utf8mb4)),
(95904,CONVERT(0x50696e6368206f662042756c62204c6f74757320506f6c6c656e USING utf8mb4)),
(95905,CONVERT(0x42756c62204c6f74757320506574616c USING utf8mb4)),
(95907,CONVERT(0x467261676d656e74206f6620466972652053706f7265 USING utf8mb4)),
(95908,CONVERT(0x466972652053706f7265204c656166 USING utf8mb4)),
(95909,CONVERT(0x5370726967206f6620466972652053706f7265 USING utf8mb4)),
(95927,CONVERT(0x5374696e67696e67204372797374616c2044757374 USING utf8mb4)),
(95928,CONVERT(0x536c69766572206f66205374696e67696e67204372797374616c USING utf8mb4)),
(95929,CONVERT(0x5368617264206f66205374696e67696e67204372797374616c USING utf8mb4)),
(95935,CONVERT(0x467261676d656e74206f662059656c6c6f7720526865756d USING utf8mb4)),
(95936,CONVERT(0x59656c6c6f7720526865756d204c656166 USING utf8mb4)),
(95937,CONVERT(0x5370726967206f662059656c6c6f7720526865756d USING utf8mb4)),
(96293,CONVERT(0x466f726d65642053757370656e73696f6e206f6620536c696d652049 USING utf8mb4)),
(96294,CONVERT(0x466f726d65642053757370656e73696f6e206f6620536c696d65204949 USING utf8mb4)),
(96295,CONVERT(0x466f726d65642053757370656e73696f6e206f6620536c696d6520494949 USING utf8mb4)),
(96296,CONVERT(0x466f726d65642053757370656e73696f6e206f6620536c696d65204956 USING utf8mb4)),
(96297,CONVERT(0x466f726d65642053757370656e73696f6e206f6620536c696d652056 USING utf8mb4)),
(96298,CONVERT(0x466f726d65642053757370656e73696f6e206f6620536c696d65205649 USING utf8mb4)),
(96333,CONVERT(0x466f726d65642053757370656e73696f6e206f6620546f78696e2049 USING utf8mb4)),
(96334,CONVERT(0x466f726d65642053757370656e73696f6e206f6620546f78696e204949 USING utf8mb4)),
(96335,CONVERT(0x466f726d65642053757370656e73696f6e206f6620546f78696e20494949 USING utf8mb4)),
(96336,CONVERT(0x466f726d65642053757370656e73696f6e206f6620546f78696e204956 USING utf8mb4)),
(96337,CONVERT(0x466f726d65642053757370656e73696f6e206f6620546f78696e2056 USING utf8mb4)),
(96338,CONVERT(0x466f726d65642053757370656e73696f6e206f6620546f78696e205649 USING utf8mb4)),
(96339,CONVERT(0x466f726d65642053757370656e73696f6e206f6620546f78696e20564949 USING utf8mb4)),
(96842,CONVERT(0x5072696d697469766520466f726d656420506f74696f6e205669616c USING utf8mb4)),
(96843,CONVERT(0x437275646520466f726d656420506f74696f6e205669616c USING utf8mb4)),
(96844,CONVERT(0x526f75676820466f726d656420506f74696f6e205669616c USING utf8mb4)),
(96845,CONVERT(0x4d616b65736869667420466f726d656420506f74696f6e205669616c USING utf8mb4)),
(96846,CONVERT(0x53696d706c6520466f726d656420506f74696f6e205669616c USING utf8mb4)),
(96847,CONVERT(0x506c61696e20466f726d656420506f74696f6e205669616c USING utf8mb4)),
(96848,CONVERT(0x536d6f6f746820466f726d656420506f74696f6e205669616c USING utf8mb4));
 CREATE TEMPORARY TABLE rrc222_peer_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc222_peer_entries LIKE tradeskill_recipe_entries;
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 target database mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=14229 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16512 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16515 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17901 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 9 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `classes` <=> 512 AND `races` <=> 131071 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=22141 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=22142 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=51399 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=51403 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95891 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95892 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95893 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95899 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95900 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95901 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95903 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95904 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95905 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95907 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95908 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95909 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95927 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95928 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95929 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95935 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95936 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95937 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96293 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96294 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 5 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96295 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 10 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96296 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 15 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96297 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 20 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96298 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 25 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96333 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96334 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 5 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96335 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 10 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96336 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 15 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96337 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 20 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96338 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 25 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96339 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 35 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96842 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96843 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96844 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96845 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96846 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96847 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96848 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 native item semantics mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc222_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc222_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc222_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc222_entries e ON r.item_id=e.item_id AND e.successcount>0 AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc222_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc222_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 output producer universe changed'; END IF;

 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc222_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc222_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 item identity/dependency mismatch'; END IF;
 IF already_present<>13 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc222_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc222_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc222_recipes q ON q.id=r.recipe_id LEFT JOIN rrc222_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc222_recipes q ON q.id=r.recipe_id)<>91 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc222_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc222_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc222_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-13 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-91 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 rollback count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc222_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc222_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc222_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc222_entries e ON r.item_id=e.item_id AND e.successcount>0 AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc222_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc222_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC222 output producer universe changed'; END IF;
 DROP TEMPORARY TABLE rrc222_peer_entries;
 DROP TEMPORARY TABLE rrc222_peer_recipes;
 DROP TEMPORARY TABLE rrc222_entries;
 DROP TEMPORARY TABLE rrc222_recipes;
 DROP TEMPORARY TABLE rrc222_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC222' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
