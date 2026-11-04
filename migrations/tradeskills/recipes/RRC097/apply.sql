-- RRC097: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc097_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc097_parents LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc097_parent_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc097_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc097_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc097_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3093970,CONVERT(0x5370656c6c3a2043616e63656c204d61676963 USING utf8mb4),58,0,34,0,0,CONVERT(0x5072696d6172792048696465207370656c6c20666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f7574653b205252433039372e USING utf8mb4),2,0,0,1,-1,-1,NULL,NULL),
(3093971,CONVERT(0x5370656c6c3a204669726573746f726d USING utf8mb4),58,0,44,0,0,CONVERT(0x5072696d6172792048696465207370656c6c20666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f7574653b205252433039372e USING utf8mb4),2,0,0,1,-1,-1,NULL,NULL),
(3093972,CONVERT(0x5370656c6c3a20536861646f772053746570 USING utf8mb4),58,0,30,0,0,CONVERT(0x5072696d6172792048696465207370656c6c20666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f7574653b205252433039372e USING utf8mb4),2,0,0,1,-1,-1,NULL,NULL),
(3093973,CONVERT(0x5370656c6c3a2053756d6d6f6e696e673a204561727468 USING utf8mb4),58,0,71,0,0,CONVERT(0x5072696d6172792048696465207370656c6c20666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f7574653b205252433039372e USING utf8mb4),2,0,0,1,-1,-1,NULL,NULL),
(3093974,CONVERT(0x5370656c6c3a20436f6e6a75726174696f6e3a2046697265 USING utf8mb4),58,0,106,0,0,CONVERT(0x5072696d6172792048696465207370656c6c20666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f7574653b205252433039372e USING utf8mb4),2,0,0,1,-1,-1,NULL,NULL),
(3093975,CONVERT(0x5370656c6c3a2053756d6d6f6e20466f6f64 USING utf8mb4),58,0,23,0,0,CONVERT(0x5072696d6172792048696465207370656c6c20666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f7574653b205252433039372e USING utf8mb4),2,0,0,1,-1,-1,NULL,NULL),
(3093976,CONVERT(0x5370656c6c3a2054727565204e6f727468 USING utf8mb4),58,0,22,0,0,CONVERT(0x5072696d6172792048696465207370656c6c20666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f7574653b205252433039372e USING utf8mb4),2,0,0,1,-1,-1,NULL,NULL),
(3093977,CONVERT(0x5370656c6c3a2053756d6d6f6e204472696e6b USING utf8mb4),58,0,23,0,0,CONVERT(0x5072696d6172792048696465207370656c6c20666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f7574653b205252433039372e USING utf8mb4),2,0,0,1,-1,-1,NULL,NULL),
(3093978,CONVERT(0x5370656c6c3a2053656e73652053756d6d6f6e6564 USING utf8mb4),58,0,26,0,0,CONVERT(0x5072696d6172792048696465207370656c6c20666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f7574653b205252433039372e USING utf8mb4),2,0,0,1,-1,-1,NULL,NULL),
(3093979,CONVERT(0x5370656c6c3a20456c656d656e74616c6b696e3a205761746572 USING utf8mb4),58,0,25,0,0,CONVERT(0x5072696d6172792048696465207370656c6c20666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f7574653b205252433039372e USING utf8mb4),2,0,0,1,-1,-1,NULL,NULL),
(3093980,CONVERT(0x5370656c6c3a2044696d656e73696f6e616c20506f636b6574 USING utf8mb4),58,0,32,0,0,CONVERT(0x5072696d6172792048696465207370656c6c20666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f7574653b205252433039372e USING utf8mb4),2,0,0,1,-1,-1,NULL,NULL),
(3093981,CONVERT(0x5370656c6c3a20456c656d656e74616c696e673a204561727468 USING utf8mb4),58,0,39,0,0,CONVERT(0x5072696d6172792048696465207370656c6c20666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f7574653b205252433039372e USING utf8mb4),2,0,0,1,-1,-1,NULL,NULL),
(3093982,CONVERT(0x5370656c6c3a20456c656d656e74616c696e673a205761746572 USING utf8mb4),58,0,33,0,0,CONVERT(0x5072696d6172792048696465207370656c6c20666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f7574653b205252433039372e USING utf8mb4),2,0,0,1,-1,-1,NULL,NULL),
(3093983,CONVERT(0x5370656c6c3a20456c656d656e74616c3a204561727468 USING utf8mb4),58,0,47,0,0,CONVERT(0x5072696d6172792048696465207370656c6c20666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f7574653b205252433039372e USING utf8mb4),2,0,0,1,-1,-1,NULL,NULL),
(3093984,CONVERT(0x5370656c6c3a20456c656d656e74616c3a205761746572 USING utf8mb4),58,0,41,0,0,CONVERT(0x5072696d6172792048696465207370656c6c20666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f7574653b205252433039372e USING utf8mb4),2,0,0,1,-1,-1,NULL,NULL),
(3093985,CONVERT(0x5370656c6c3a20537068657265206f66204c69676874 USING utf8mb4),58,0,22,0,0,CONVERT(0x5072696d6172792048696465207370656c6c20666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f7574653b205252433039372e USING utf8mb4),2,0,0,1,-1,-1,NULL,NULL),
(3093986,CONVERT(0x5370656c6c3a2047617465 USING utf8mb4),58,0,28,0,0,CONVERT(0x5072696d6172792048696465207370656c6c20666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f7574653b205252433039372e USING utf8mb4),2,0,0,1,-1,-1,NULL,NULL),
(3093987,CONVERT(0x5370656c6c3a20526f6f74 USING utf8mb4),58,0,26,0,0,CONVERT(0x5072696d6172792048696465207370656c6c20666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f7574653b205252433039372e USING utf8mb4),2,0,0,1,-1,-1,NULL,NULL),
(3093988,CONVERT(0x5370656c6c3a20496365737472696b65 USING utf8mb4),58,0,32,0,0,CONVERT(0x5072696d6172792048696465207370656c6c20666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f7574653b205252433039372e USING utf8mb4),2,0,0,1,-1,-1,NULL,NULL),
(3093989,CONVERT(0x5370656c6c3a2048616c6f206f66204c69676874 USING utf8mb4),58,0,38,0,0,CONVERT(0x5072696d6172792048696465207370656c6c20666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f7574653b205252433039372e USING utf8mb4),2,0,0,1,-1,-1,NULL,NULL),
(3093990,CONVERT(0x5370656c6c3a204361766f7274696e6720426f6e6573 USING utf8mb4),58,0,23,0,0,CONVERT(0x5072696d6172792048696465207370656c6c20666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f7574653b205252433039372e USING utf8mb4),2,0,0,1,-1,-1,NULL,NULL),
(3093991,CONVERT(0x5370656c6c3a204c656572696e6720436f72707365 USING utf8mb4),58,0,29,0,0,CONVERT(0x5072696d6172792048696465207370656c6c20666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f7574653b205252433039372e USING utf8mb4),2,0,0,1,-1,-1,NULL,NULL),
(3093992,CONVERT(0x5370656c6c3a2047617468657220536861646f7773 USING utf8mb4),58,0,34,0,0,CONVERT(0x5072696d6172792048696465207370656c6c20666f726d756c613b206578697374696e67205370656c6c205265736561726368204b697420726f7574653b205252433039372e USING utf8mb4),2,0,0,1,-1,-1,NULL,NULL);
INSERT INTO rrc097_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3093970,15048,1,0,0,0,0),
(3093970,93555,0,0,1,1,0),
(3093970,93542,0,0,1,1,0),
(3093970,93560,0,0,1,1,0),
(3093970,97761,0,0,1,1,0),
(3093970,93514,0,0,1,1,0),
(3093970,93492,0,0,0,0,1),
(3093971,15085,1,0,0,0,0),
(3093971,93548,0,0,1,1,0),
(3093971,93587,0,0,1,1,0),
(3093971,97766,0,0,1,1,0),
(3093971,93517,0,0,1,1,0),
(3093971,93537,0,0,1,1,0),
(3093971,93492,0,0,0,0,1),
(3093972,15354,1,0,0,0,0),
(3093972,97759,0,0,1,1,0),
(3093972,93542,0,0,1,1,0),
(3093972,93577,0,0,1,1,0),
(3093972,93553,0,0,1,1,0),
(3093972,93516,0,0,1,1,0),
(3093972,93492,0,0,0,0,1),
(3093973,15569,1,0,0,0,0),
(3093973,93557,0,0,1,1,0),
(3093973,93542,0,0,1,1,0),
(3093973,93583,0,0,1,1,0),
(3093973,93585,0,0,1,1,0),
(3093973,93515,0,0,1,1,0),
(3093973,97779,0,0,1,1,0),
(3093973,93492,0,0,0,0,1),
(3093974,15630,1,0,0,0,0),
(3093974,93557,0,0,1,1,0),
(3093974,93542,0,0,1,1,0),
(3093974,93558,0,0,1,1,0),
(3093974,93583,0,0,1,1,0),
(3093974,97796,0,0,1,1,0),
(3093974,93515,0,0,1,1,0),
(3093974,93492,0,0,0,0,1),
(3093975,16100,1,0,0,0,0),
(3093975,93557,0,0,1,1,0),
(3093975,93542,0,0,1,1,0),
(3093975,93573,0,0,1,1,0),
(3093975,93515,0,0,1,1,0),
(3093975,97755,0,0,1,1,0),
(3093975,93492,0,0,0,0,1),
(3093976,16101,1,0,0,0,0),
(3093976,93542,0,0,1,1,0),
(3093976,93576,0,0,1,1,0),
(3093976,93553,0,0,1,1,0),
(3093976,93526,0,0,1,1,0),
(3093976,97755,0,0,1,1,0),
(3093976,93492,0,0,0,0,1),
(3093977,16102,1,0,0,0,0),
(3093977,93557,0,0,1,1,0),
(3093977,93542,0,0,1,1,0),
(3093977,93574,0,0,1,1,0),
(3093977,93515,0,0,1,1,0),
(3093977,97755,0,0,1,1,0),
(3093977,93492,0,0,0,0,1),
(3093978,16104,1,0,0,0,0),
(3093978,93542,0,0,1,1,0),
(3093978,93576,0,0,1,1,0),
(3093978,93553,0,0,1,1,0),
(3093978,97757,0,0,1,1,0),
(3093978,93515,0,0,1,1,0),
(3093978,93492,0,0,0,0,1),
(3093979,16108,1,0,0,0,0),
(3093979,97756,0,0,1,1,0),
(3093979,93557,0,0,1,1,0),
(3093979,93542,0,0,1,1,0),
(3093979,93559,0,0,1,1,0),
(3093979,93583,0,0,1,1,0),
(3093979,93515,0,0,1,1,0),
(3093979,93492,0,0,0,0,1),
(3093980,16112,1,0,0,0,0),
(3093980,97760,0,0,1,1,0),
(3093980,93557,0,0,1,1,0),
(3093980,93542,0,0,1,1,0),
(3093980,93572,0,0,1,1,0),
(3093980,93515,0,0,1,1,0),
(3093980,93492,0,0,0,0,1),
(3093981,16113,1,0,0,0,0),
(3093981,93557,0,0,1,1,0),
(3093981,93542,0,0,1,1,0),
(3093981,93583,0,0,1,1,0),
(3093981,93585,0,0,1,1,0),
(3093981,97763,0,0,1,1,0),
(3093981,93515,0,0,1,1,0),
(3093981,93492,0,0,0,0,1),
(3093982,16114,1,0,0,0,0),
(3093982,97760,0,0,1,1,0),
(3093982,93557,0,0,1,1,0),
(3093982,93542,0,0,1,1,0),
(3093982,93559,0,0,1,1,0),
(3093982,93583,0,0,1,1,0),
(3093982,93515,0,0,1,1,0),
(3093982,93492,0,0,0,0,1),
(3093983,16119,1,0,0,0,0),
(3093983,93557,0,0,1,1,0),
(3093983,93542,0,0,1,1,0),
(3093983,93583,0,0,1,1,0),
(3093983,93585,0,0,1,1,0),
(3093983,93515,0,0,1,1,0),
(3093983,97767,0,0,1,1,0),
(3093983,93492,0,0,0,0,1),
(3093984,16120,1,0,0,0,0),
(3093984,93557,0,0,1,1,0),
(3093984,93542,0,0,1,1,0),
(3093984,93559,0,0,1,1,0),
(3093984,93583,0,0,1,1,0),
(3093984,93515,0,0,1,1,0),
(3093984,97764,0,0,1,1,0),
(3093984,93492,0,0,0,0,1),
(3093985,16301,1,0,0,0,0),
(3093985,93557,0,0,1,1,0),
(3093985,93542,0,0,1,1,0),
(3093985,93576,0,0,1,1,0),
(3093985,93517,0,0,1,1,0),
(3093985,97755,0,0,1,1,0),
(3093985,93492,0,0,0,0,1),
(3093986,16303,1,0,0,0,0),
(3093986,93542,0,0,1,1,0),
(3093986,93577,0,0,1,1,0),
(3093986,93553,0,0,1,1,0),
(3093986,93526,0,0,1,1,0),
(3093986,97758,0,0,1,1,0),
(3093986,93492,0,0,0,0,1),
(3093987,16304,1,0,0,0,0),
(3093987,93555,0,0,1,1,0),
(3093987,93580,0,0,1,1,0),
(3093987,93539,0,0,1,1,0),
(3093987,97757,0,0,1,1,0),
(3093987,93517,0,0,1,1,0),
(3093987,93492,0,0,0,0,1),
(3093988,16306,1,0,0,0,0),
(3093988,93546,0,0,1,1,0),
(3093988,97760,0,0,1,1,0),
(3093988,93538,0,0,1,1,0),
(3093988,93587,0,0,1,1,0),
(3093988,93517,0,0,1,1,0),
(3093988,93492,0,0,0,0,1),
(3093989,16315,1,0,0,0,0),
(3093989,93557,0,0,1,1,0),
(3093989,93542,0,0,1,1,0),
(3093989,93576,0,0,1,1,0),
(3093989,97763,0,0,1,1,0),
(3093989,93517,0,0,1,1,0),
(3093989,93492,0,0,0,0,1),
(3093990,16400,1,0,0,0,0),
(3093990,13073,0,0,1,1,0),
(3093990,93557,0,0,1,1,0),
(3093990,93542,0,0,1,1,0),
(3093990,93583,0,0,1,1,0),
(3093990,93516,0,0,1,1,0),
(3093990,97755,0,0,1,1,0),
(3093990,93492,0,0,0,0,1),
(3093991,16406,1,0,0,0,0),
(3093991,13073,0,0,1,1,0),
(3093991,93557,0,0,1,1,0),
(3093991,93542,0,0,1,1,0),
(3093991,93583,0,0,1,1,0),
(3093991,93516,0,0,1,1,0),
(3093991,97758,0,0,1,1,0),
(3093991,93492,0,0,0,0,1),
(3093992,16410,1,0,0,0,0),
(3093992,93542,0,0,1,1,0),
(3093992,93576,0,0,1,1,0),
(3093992,93553,0,0,1,1,0),
(3093992,97761,0,0,1,1,0),
(3093992,93516,0,0,1,1,0),
(3093992,93492,0,0,0,0,1);
INSERT INTO rrc097_items (`id`,`name`) VALUES
(13073,CONVERT(0x426f6e65204368697073 USING utf8mb4)),
(15048,CONVERT(0x5370656c6c3a2043616e63656c204d61676963 USING utf8mb4)),
(15085,CONVERT(0x5370656c6c3a204669726573746f726d USING utf8mb4)),
(15354,CONVERT(0x5370656c6c3a20536861646f772053746570 USING utf8mb4)),
(15569,CONVERT(0x5370656c6c3a2053756d6d6f6e696e673a204561727468 USING utf8mb4)),
(15630,CONVERT(0x5370656c6c3a20436f6e6a75726174696f6e3a2046697265 USING utf8mb4)),
(16100,CONVERT(0x5370656c6c3a2053756d6d6f6e20466f6f64 USING utf8mb4)),
(16101,CONVERT(0x5370656c6c3a2054727565204e6f727468 USING utf8mb4)),
(16102,CONVERT(0x5370656c6c3a2053756d6d6f6e204472696e6b USING utf8mb4)),
(16104,CONVERT(0x5370656c6c3a2053656e73652053756d6d6f6e6564 USING utf8mb4)),
(16108,CONVERT(0x5370656c6c3a20456c656d656e74616c6b696e3a205761746572 USING utf8mb4)),
(16112,CONVERT(0x5370656c6c3a2044696d656e73696f6e616c20506f636b6574 USING utf8mb4)),
(16113,CONVERT(0x5370656c6c3a20456c656d656e74616c696e673a204561727468 USING utf8mb4)),
(16114,CONVERT(0x5370656c6c3a20456c656d656e74616c696e673a205761746572 USING utf8mb4)),
(16119,CONVERT(0x5370656c6c3a20456c656d656e74616c3a204561727468 USING utf8mb4)),
(16120,CONVERT(0x5370656c6c3a20456c656d656e74616c3a205761746572 USING utf8mb4)),
(16301,CONVERT(0x5370656c6c3a20537068657265206f66204c69676874 USING utf8mb4)),
(16303,CONVERT(0x5370656c6c3a2047617465 USING utf8mb4)),
(16304,CONVERT(0x5370656c6c3a20526f6f74 USING utf8mb4)),
(16306,CONVERT(0x5370656c6c3a20496365737472696b65 USING utf8mb4)),
(16315,CONVERT(0x5370656c6c3a2048616c6f206f66204c69676874 USING utf8mb4)),
(16400,CONVERT(0x5370656c6c3a204361766f7274696e6720426f6e6573 USING utf8mb4)),
(16406,CONVERT(0x5370656c6c3a204c656572696e6720436f72707365 USING utf8mb4)),
(16410,CONVERT(0x5370656c6c3a2047617468657220536861646f7773 USING utf8mb4)),
(93492,CONVERT(0x5370656c6c205265736561726368204b6974 USING utf8mb4)),
(93514,CONVERT(0x5175696c6c206f662074686520436f6572636572 USING utf8mb4)),
(93515,CONVERT(0x5175696c6c206f6620746865204172636820436f6e766f6b6572 USING utf8mb4)),
(93516,CONVERT(0x5175696c6c206f66207468652041726368204c696368 USING utf8mb4)),
(93517,CONVERT(0x5175696c6c206f662074686520417263616e697374 USING utf8mb4)),
(93526,CONVERT(0x5175696c6c206f662074686520417263616e65 USING utf8mb4)),
(93537,CONVERT(0x526f277320496e6b204164646974697665 USING utf8mb4)),
(93538,CONVERT(0x45276369277320496e6b204164646974697665 USING utf8mb4)),
(93539,CONVERT(0x4c75636c696e277320496e6b204164646974697665 USING utf8mb4)),
(93542,CONVERT(0x496e6b204164646974697665206f6620746865204e616d656c657373 USING utf8mb4)),
(93546,CONVERT(0x416c274b61626f7220546869636b656e6572 USING utf8mb4)),
(93548,CONVERT(0x4578706174696174696e6720546869636b656e6572 USING utf8mb4)),
(93553,CONVERT(0x496e7669676f726174696e6720546869636b656e6572 USING utf8mb4)),
(93555,CONVERT(0x446562696c69746174696e6720546869636b656e6572 USING utf8mb4)),
(93557,CONVERT(0x436f6e6a7572696e6720546869636b656e6572 USING utf8mb4)),
(93558,CONVERT(0x496e6b206f6620526f USING utf8mb4)),
(93559,CONVERT(0x496e6b206f662045276369 USING utf8mb4)),
(93560,CONVERT(0x496e6b206f66204472757a7a696c20526f USING utf8mb4)),
(93572,CONVERT(0x496e6b206f6620746865204e616d656c657373 USING utf8mb4)),
(93573,CONVERT(0x496e6b206f662054756e617265 USING utf8mb4)),
(93574,CONVERT(0x496e6b206f6620507265787573 USING utf8mb4)),
(93576,CONVERT(0x496e6b206f6620746865204561676c65 USING utf8mb4)),
(93577,CONVERT(0x496e6b206f6620416c616372697479 USING utf8mb4)),
(93580,CONVERT(0x496e6b206f6620746865204c6973746c657373 USING utf8mb4)),
(93583,CONVERT(0x496e6b206f662074686520436f6d70616e696f6e USING utf8mb4)),
(93585,CONVERT(0x496e6b206f6620746865205261746865 USING utf8mb4)),
(93587,CONVERT(0x496e6b206f66205061696e USING utf8mb4)),
(97755,CONVERT(0x53746966662048696465 USING utf8mb4)),
(97756,CONVERT(0x436c65616e65642053746966662048696465 USING utf8mb4)),
(97757,CONVERT(0x50726570617265642053746966662048696465 USING utf8mb4)),
(97758,CONVERT(0x536d6f6f74682053746966662048696465 USING utf8mb4)),
(97759,CONVERT(0x43727564652048696465 USING utf8mb4)),
(97760,CONVERT(0x436c65616e65642043727564652048696465 USING utf8mb4)),
(97761,CONVERT(0x50726570617265642043727564652048696465 USING utf8mb4)),
(97763,CONVERT(0x5072697374696e652043727564652048696465 USING utf8mb4)),
(97764,CONVERT(0x526f7567682048696465 USING utf8mb4)),
(97766,CONVERT(0x507265706172656420526f7567682048696465 USING utf8mb4)),
(97767,CONVERT(0x536d6f6f746820526f7567682048696465 USING utf8mb4)),
(97779,CONVERT(0x537570706c652048696465 USING utf8mb4)),
(97796,CONVERT(0x507265706172656420537570706c652052756e69632048696465 USING utf8mb4));
INSERT INTO rrc097_parents (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(650,CONVERT(0x5370656c6c3a20436f6e6a75726174696f6e3a2046697265 USING utf8mb4),58,0,162,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(857,CONVERT(0x5370656c6c3a2053756d6d6f6e696e673a204561727468 USING utf8mb4),58,0,57,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
INSERT INTO rrc097_parent_entries (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(5644,650,11804,0,0,1,1,0),
(5645,650,11808,0,0,1,1,0),
(5646,650,15626,0,0,1,1,0),
(5647,650,15630,1,0,0,0,0),
(5648,650,25,0,0,0,0,1),
(5649,650,17502,0,0,0,0,1),
(5650,650,17653,0,0,0,0,1),
(7421,857,11796,0,0,1,1,0),
(7422,857,11871,0,0,1,1,0),
(7423,857,15496,0,0,1,1,0),
(7424,857,15569,1,0,0,0,0),
(7425,857,25,0,0,0,0,1),
(7426,857,17502,0,0,0,0,1),
(7427,857,17653,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF EXISTS(SELECT 1 FROM rrc097_parents e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 legacy recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc097_parent_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc097_parents p ON p.id=r.recipe_id)<>14 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 legacy entries drift'; END IF;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc097_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc097_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93492 AND itemclass=1 AND bagtype=11 AND bagslots=10 AND bagsize=3 AND classes=15360)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native kit mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=13073 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 65535 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 13073 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=15048 AND `itemclass` <=> 0 AND `itemtype` <=> 20 AND `classes` <=> 32318 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `scrolleffect` <=> 48 AND `scrolllevel` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `size` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 15048 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=15085 AND `itemclass` <=> 0 AND `itemtype` <=> 20 AND `classes` <=> 2048 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `scrolleffect` <=> 85 AND `scrolllevel` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `size` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 15085 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=15354 AND `itemclass` <=> 0 AND `itemtype` <=> 20 AND `classes` <=> 3088 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `scrolleffect` <=> 354 AND `scrolllevel` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `size` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 15354 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=15569 AND `itemtype` <=> 20 AND `classes` <=> 4096 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `scrolleffect` <=> 569 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `size` <=> 1 AND `itemclass` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 15569 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=15630 AND `itemtype` <=> 20 AND `classes` <=> 4096 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `scrolleffect` <=> 630 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `size` <=> 1 AND `itemclass` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 15630 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=16100 AND `itemclass` <=> 0 AND `itemtype` <=> 20 AND `classes` <=> 4096 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `scrolleffect` <=> 50 AND `scrolllevel` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `size` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 16100 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=16101 AND `itemclass` <=> 0 AND `itemtype` <=> 20 AND `classes` <=> 4096 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `scrolleffect` <=> 205 AND `scrolllevel` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `size` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 16101 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=16102 AND `itemclass` <=> 0 AND `itemtype` <=> 20 AND `classes` <=> 4096 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `scrolleffect` <=> 211 AND `scrolllevel` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `size` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 16102 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=16104 AND `itemclass` <=> 0 AND `itemtype` <=> 20 AND `classes` <=> 4096 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `scrolleffect` <=> 232 AND `scrolllevel` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `size` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 16104 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=16108 AND `itemclass` <=> 0 AND `itemtype` <=> 20 AND `classes` <=> 4096 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `scrolleffect` <=> 315 AND `scrolllevel` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `size` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 16108 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=16112 AND `itemclass` <=> 0 AND `itemtype` <=> 20 AND `classes` <=> 4096 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `scrolleffect` <=> 325 AND `scrolllevel` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `size` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 16112 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=16113 AND `itemclass` <=> 0 AND `itemtype` <=> 20 AND `classes` <=> 4096 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `scrolleffect` <=> 397 AND `scrolllevel` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `size` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 16113 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=16114 AND `itemclass` <=> 0 AND `itemtype` <=> 20 AND `classes` <=> 4096 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `scrolleffect` <=> 398 AND `scrolllevel` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `size` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 16114 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=16119 AND `itemclass` <=> 0 AND `itemtype` <=> 20 AND `classes` <=> 4096 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `scrolleffect` <=> 401 AND `scrolllevel` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `size` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 16119 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=16120 AND `itemclass` <=> 0 AND `itemtype` <=> 20 AND `classes` <=> 4096 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `scrolleffect` <=> 402 AND `scrolllevel` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `size` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 16120 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=16301 AND `itemclass` <=> 0 AND `itemtype` <=> 20 AND `classes` <=> 2048 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `scrolleffect` <=> 373 AND `scrolllevel` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `size` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 16301 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=16303 AND `itemclass` <=> 0 AND `itemtype` <=> 20 AND `classes` <=> 15906 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `scrolleffect` <=> 36 AND `scrolllevel` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `size` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 16303 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=16304 AND `itemclass` <=> 0 AND `itemtype` <=> 20 AND `classes` <=> 11782 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `scrolleffect` <=> 230 AND `scrolllevel` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `size` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 16304 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=16306 AND `itemclass` <=> 0 AND `itemtype` <=> 20 AND `classes` <=> 2048 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `scrolleffect` <=> 377 AND `scrolllevel` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `size` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 16306 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=16315 AND `itemclass` <=> 0 AND `itemtype` <=> 20 AND `classes` <=> 2086 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `scrolleffect` <=> 234 AND `scrolllevel` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `size` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 16315 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=16400 AND `itemclass` <=> 0 AND `itemtype` <=> 20 AND `classes` <=> 1024 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `scrolleffect` <=> 338 AND `scrolllevel` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `size` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 16400 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=16406 AND `itemclass` <=> 0 AND `itemtype` <=> 20 AND `classes` <=> 1040 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `scrolleffect` <=> 491 AND `scrolllevel` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `size` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 16406 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=16410 AND `itemclass` <=> 0 AND `itemtype` <=> 20 AND `classes` <=> 1024 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `scrolleffect` <=> 522 AND `scrolllevel` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `nodrop` <=> 1 AND `norent` <=> 1 AND `size` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 16410 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93492 AND `size` <=> 3 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `classes` <=> 15360 AND `bagtype` <=> 11 AND `bagslots` <=> 10 AND `bagsize` <=> 3 AND `stackable` <=> 0 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 93492 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93514 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 93514 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93515 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 93515 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93516 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 93516 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93517 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 93517 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93526 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 93526 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93537 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 93537 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93538 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 93538 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93539 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 93539 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93542 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 93542 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93546 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 93546 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93548 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 93548 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93553 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 93553 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93555 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 93555 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93557 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 93557 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93558 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 93558 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93559 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 93559 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93560 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 93560 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93572 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 93572 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93573 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 93573 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93574 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 93574 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93576 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 93576 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93577 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 93577 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93580 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 93580 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93583 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 93583 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93585 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 93585 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=93587 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 93587 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=97755 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 97755 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=97756 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 97756 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=97757 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 97757 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=97758 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 97758 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=97759 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 97759 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=97760 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 97760 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=97761 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 97761 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=97763 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 97763 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=97764 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 97764 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=97766 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 97766 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=97767 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 97767 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=97779 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 97779 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=97796 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `classes` <=> 15360 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `stackable` <=> 1 AND `maxcharges` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 native semantics 97796 mismatch'; END IF;
 IF (SELECT COUNT(*) FROM spells_new WHERE id=48 AND classes14=7)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 spell class binding mismatch'; END IF;
 IF (SELECT COUNT(*) FROM spells_new WHERE id=85 AND classes12=12)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 spell class binding mismatch'; END IF;
 IF (SELECT COUNT(*) FROM spells_new WHERE id=354 AND classes11=5)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 spell class binding mismatch'; END IF;
 IF (SELECT COUNT(*) FROM spells_new WHERE id=569 AND classes13=25)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 spell class binding mismatch'; END IF;
 IF (SELECT COUNT(*) FROM spells_new WHERE id=630 AND classes13=42)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 spell class binding mismatch'; END IF;
 IF (SELECT COUNT(*) FROM spells_new WHERE id=50 AND classes13=1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 spell class binding mismatch'; END IF;
 IF (SELECT COUNT(*) FROM spells_new WHERE id=205 AND classes13=1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 spell class binding mismatch'; END IF;
 IF (SELECT COUNT(*) FROM spells_new WHERE id=211 AND classes13=1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 spell class binding mismatch'; END IF;
 IF (SELECT COUNT(*) FROM spells_new WHERE id=232 AND classes13=3)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 spell class binding mismatch'; END IF;
 IF (SELECT COUNT(*) FROM spells_new WHERE id=315 AND classes13=2)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 spell class binding mismatch'; END IF;
 IF (SELECT COUNT(*) FROM spells_new WHERE id=325 AND classes13=6)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 spell class binding mismatch'; END IF;
 IF (SELECT COUNT(*) FROM spells_new WHERE id=397 AND classes13=9)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 spell class binding mismatch'; END IF;
 IF (SELECT COUNT(*) FROM spells_new WHERE id=398 AND classes13=6)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 spell class binding mismatch'; END IF;
 IF (SELECT COUNT(*) FROM spells_new WHERE id=401 AND classes13=13)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 spell class binding mismatch'; END IF;
 IF (SELECT COUNT(*) FROM spells_new WHERE id=402 AND classes13=10)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 spell class binding mismatch'; END IF;
 IF (SELECT COUNT(*) FROM spells_new WHERE id=373 AND classes12=1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 spell class binding mismatch'; END IF;
 IF (SELECT COUNT(*) FROM spells_new WHERE id=36 AND classes12=4)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 spell class binding mismatch'; END IF;
 IF (SELECT COUNT(*) FROM spells_new WHERE id=230 AND classes12=3)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 spell class binding mismatch'; END IF;
 IF (SELECT COUNT(*) FROM spells_new WHERE id=377 AND classes12=6)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 spell class binding mismatch'; END IF;
 IF (SELECT COUNT(*) FROM spells_new WHERE id=234 AND classes12=9)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 spell class binding mismatch'; END IF;
 IF (SELECT COUNT(*) FROM spells_new WHERE id=338 AND classes11=1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 spell class binding mismatch'; END IF;
 IF (SELECT COUNT(*) FROM spells_new WHERE id=491 AND classes11=4)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 spell class binding mismatch'; END IF;
 IF (SELECT COUNT(*) FROM spells_new WHERE id=522 AND classes11=7)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 spell class binding mismatch'; END IF;
 IF already_present NOT IN (0,23) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 partial batch or ID collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r JOIN rrc097_recipes e ON r.tradeskill=e.tradeskill AND r.name=e.name WHERE r.id<>e.id AND r.id NOT IN (650,857)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 existing recipe-name collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc097_entries e ON r.item_id=e.item_id JOIN rrc097_recipes q ON e.recipe_id=q.id WHERE e.successcount>e.componentcount AND e.iscontainer=0 AND r.successcount>r.componentcount AND r.iscontainer=0 AND r.recipe_id<>e.recipe_id AND r.recipe_id NOT IN (650,857)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 existing output recipe collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>3093970 AND (SELECT SUM(e.componentcount) FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=5 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93555 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93542 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93560 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97761 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93514 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND (k.item_id=i.id OR k.item_id=i.bagtype) WHERE i.itemclass=1 AND (i.id=93492 OR i.bagtype=11))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 complete input/effective kit collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>3093971 AND (SELECT SUM(e.componentcount) FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=5 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93548 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93587 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97766 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93517 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93537 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND (k.item_id=i.id OR k.item_id=i.bagtype) WHERE i.itemclass=1 AND (i.id=93492 OR i.bagtype=11))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 complete input/effective kit collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>3093972 AND (SELECT SUM(e.componentcount) FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=5 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97759 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93542 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93577 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93553 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93516 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND (k.item_id=i.id OR k.item_id=i.bagtype) WHERE i.itemclass=1 AND (i.id=93492 OR i.bagtype=11))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 complete input/effective kit collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>3093973 AND (SELECT SUM(e.componentcount) FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=6 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93557 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93542 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93583 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93585 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93515 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97779 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND (k.item_id=i.id OR k.item_id=i.bagtype) WHERE i.itemclass=1 AND (i.id=93492 OR i.bagtype=11))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 complete input/effective kit collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>3093974 AND (SELECT SUM(e.componentcount) FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=6 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93557 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93542 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93558 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93583 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97796 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93515 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND (k.item_id=i.id OR k.item_id=i.bagtype) WHERE i.itemclass=1 AND (i.id=93492 OR i.bagtype=11))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 complete input/effective kit collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>3093975 AND (SELECT SUM(e.componentcount) FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=5 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93557 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93542 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93573 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93515 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97755 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND (k.item_id=i.id OR k.item_id=i.bagtype) WHERE i.itemclass=1 AND (i.id=93492 OR i.bagtype=11))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 complete input/effective kit collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>3093976 AND (SELECT SUM(e.componentcount) FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=5 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93542 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93576 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93553 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93526 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97755 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND (k.item_id=i.id OR k.item_id=i.bagtype) WHERE i.itemclass=1 AND (i.id=93492 OR i.bagtype=11))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 complete input/effective kit collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>3093977 AND (SELECT SUM(e.componentcount) FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=5 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93557 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93542 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93574 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93515 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97755 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND (k.item_id=i.id OR k.item_id=i.bagtype) WHERE i.itemclass=1 AND (i.id=93492 OR i.bagtype=11))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 complete input/effective kit collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>3093978 AND (SELECT SUM(e.componentcount) FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=5 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93542 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93576 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93553 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97757 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93515 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND (k.item_id=i.id OR k.item_id=i.bagtype) WHERE i.itemclass=1 AND (i.id=93492 OR i.bagtype=11))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 complete input/effective kit collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>3093979 AND (SELECT SUM(e.componentcount) FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=6 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97756 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93557 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93542 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93559 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93583 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93515 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND (k.item_id=i.id OR k.item_id=i.bagtype) WHERE i.itemclass=1 AND (i.id=93492 OR i.bagtype=11))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 complete input/effective kit collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>3093980 AND (SELECT SUM(e.componentcount) FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=5 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97760 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93557 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93542 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93572 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93515 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND (k.item_id=i.id OR k.item_id=i.bagtype) WHERE i.itemclass=1 AND (i.id=93492 OR i.bagtype=11))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 complete input/effective kit collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>3093981 AND (SELECT SUM(e.componentcount) FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=6 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93557 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93542 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93583 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93585 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97763 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93515 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND (k.item_id=i.id OR k.item_id=i.bagtype) WHERE i.itemclass=1 AND (i.id=93492 OR i.bagtype=11))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 complete input/effective kit collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>3093982 AND (SELECT SUM(e.componentcount) FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=6 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97760 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93557 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93542 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93559 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93583 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93515 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND (k.item_id=i.id OR k.item_id=i.bagtype) WHERE i.itemclass=1 AND (i.id=93492 OR i.bagtype=11))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 complete input/effective kit collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>3093983 AND (SELECT SUM(e.componentcount) FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=6 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93557 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93542 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93583 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93585 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93515 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97767 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND (k.item_id=i.id OR k.item_id=i.bagtype) WHERE i.itemclass=1 AND (i.id=93492 OR i.bagtype=11))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 complete input/effective kit collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>3093984 AND (SELECT SUM(e.componentcount) FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=6 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93557 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93542 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93559 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93583 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93515 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97764 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND (k.item_id=i.id OR k.item_id=i.bagtype) WHERE i.itemclass=1 AND (i.id=93492 OR i.bagtype=11))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 complete input/effective kit collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>3093985 AND (SELECT SUM(e.componentcount) FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=5 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93557 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93542 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93576 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93517 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97755 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND (k.item_id=i.id OR k.item_id=i.bagtype) WHERE i.itemclass=1 AND (i.id=93492 OR i.bagtype=11))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 complete input/effective kit collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>3093986 AND (SELECT SUM(e.componentcount) FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=5 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93542 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93577 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93553 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93526 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97758 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND (k.item_id=i.id OR k.item_id=i.bagtype) WHERE i.itemclass=1 AND (i.id=93492 OR i.bagtype=11))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 complete input/effective kit collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>3093987 AND (SELECT SUM(e.componentcount) FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=5 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93555 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93580 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93539 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97757 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93517 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND (k.item_id=i.id OR k.item_id=i.bagtype) WHERE i.itemclass=1 AND (i.id=93492 OR i.bagtype=11))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 complete input/effective kit collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>3093988 AND (SELECT SUM(e.componentcount) FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=5 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93546 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97760 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93538 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93587 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93517 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND (k.item_id=i.id OR k.item_id=i.bagtype) WHERE i.itemclass=1 AND (i.id=93492 OR i.bagtype=11))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 complete input/effective kit collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>3093989 AND (SELECT SUM(e.componentcount) FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=5 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93557 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93542 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93576 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97763 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93517 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND (k.item_id=i.id OR k.item_id=i.bagtype) WHERE i.itemclass=1 AND (i.id=93492 OR i.bagtype=11))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 complete input/effective kit collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>3093990 AND (SELECT SUM(e.componentcount) FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=6 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=13073 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93557 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93542 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93583 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93516 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97755 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND (k.item_id=i.id OR k.item_id=i.bagtype) WHERE i.itemclass=1 AND (i.id=93492 OR i.bagtype=11))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 complete input/effective kit collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>3093991 AND (SELECT SUM(e.componentcount) FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=6 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=13073 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93557 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93542 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93583 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93516 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97758 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND (k.item_id=i.id OR k.item_id=i.bagtype) WHERE i.itemclass=1 AND (i.id=93492 OR i.bagtype=11))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 complete input/effective kit collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r WHERE r.enabled=1 AND r.id<>3093992 AND (SELECT SUM(e.componentcount) FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=5 AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93542 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93576 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93553 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97761 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=93516 AND e.componentcount=1) AND EXISTS(SELECT 1 FROM items i JOIN tradeskill_recipe_entries k ON k.recipe_id=r.id AND k.iscontainer=1 AND (k.item_id=i.id OR k.item_id=i.bagtype) WHERE i.itemclass=1 AND (i.id=93492 OR i.bagtype=11))) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 complete input/effective kit collision'; END IF;
 IF already_present=0 THEN
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc097_recipes e ON r.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 orphan target entries collision'; END IF;
 INSERT INTO tradeskill_recipe (id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled) SELECT id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled FROM rrc097_recipes;
 INSERT INTO tradeskill_recipe_entries (recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer) SELECT recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer FROM rrc097_entries;
 END IF;
 IF EXISTS(SELECT 1 FROM rrc097_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc097_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc097_recipes q ON q.id=r.recipe_id LEFT JOIN rrc097_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc097_recipes q ON q.id=r.recipe_id)<>170 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 target entry multiplicity mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before+IF(already_present=0,23,0) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before+IF(already_present=0,170,0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 unexpected table row-count delta'; END IF;
 IF EXISTS(SELECT 1 FROM rrc097_parents e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 legacy recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc097_parent_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc097_parents p ON p.id=r.recipe_id)<>14 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC097 legacy entries drift'; END IF;
 DROP TEMPORARY TABLE rrc097_parents;
 DROP TEMPORARY TABLE rrc097_parent_entries;
 DROP TEMPORARY TABLE rrc097_entries;
 DROP TEMPORARY TABLE rrc097_recipes;
 DROP TEMPORARY TABLE rrc097_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC097' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
