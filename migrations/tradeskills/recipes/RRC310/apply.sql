-- RRC310: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc310_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc310_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc310_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc310_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3102883,CONVERT(0x506f74696f6e204d616b6572204b6974 USING utf8mb4),57,0,0,1,0,CONVERT(0x46696e6974652070726f70657274792d70726573657276696e67206d616e75616c2072656368617267653b204c4f43414c206b697420617661696c6162696c69747920616e642065726120666c6f6f723b205252433331302e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3102884,CONVERT(0x4368697070656420426f6e6520526f64204175676d656e746572 USING utf8mb4),57,0,15,1,0,CONVERT(0x46696e6974652070726f70657274792d70726573657276696e67206d616e75616c2072656368617267653b204c4f43414c206b697420617661696c6162696c69747920616e642065726120666c6f6f723b205252433331302e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3102885,CONVERT(0x46756c6c20436170616369747920476e6f6d6973682056616e697368696e6720446576696365 USING utf8mb4),57,0,0,1,0,CONVERT(0x46696e6974652070726f70657274792d70726573657276696e67206d616e75616c2072656368617267653b204c4f43414c206b697420617661696c6162696c69747920616e642065726120666c6f6f723b205252433331302e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3102886,CONVERT(0x46756c6c20436170616369747920476e6f6d6973682056616e697368696e6720446576696365 USING utf8mb4),57,0,0,1,0,CONVERT(0x46696e6974652070726f70657274792d70726573657276696e67206d616e75616c2072656368617267653b204c4f43414c206b697420617661696c6162696c69747920616e642065726120666c6f6f723b205252433331302e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3102887,CONVERT(0x476565726c6f6b204175746f6d617465642043616c74726f702043726561746f72 USING utf8mb4),57,0,0,1,0,CONVERT(0x46696e6974652070726f70657274792d70726573657276696e67206d616e75616c2072656368617267653b204c4f43414c206b697420617661696c6162696c69747920616e642065726120666c6f6f723b205252433331302e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3102888,CONVERT(0x476565726c6f6b20466c6f61746174696f6e205061636b USING utf8mb4),57,0,0,1,0,CONVERT(0x46696e6974652070726f70657274792d70726573657276696e67206d616e75616c2072656368617267653b204c4f43414c206b697420617661696c6162696c69747920616e642065726120666c6f6f723b205252433331302e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3102889,CONVERT(0x48616c6620436170616369747920476e6f6d6973682056616e697368696e6720446576696365 USING utf8mb4),57,0,0,1,0,CONVERT(0x46696e6974652070726f70657274792d70726573657276696e67206d616e75616c2072656368617267653b204c4f43414c206b697420617661696c6162696c69747920616e642065726120666c6f6f723b205252433331302e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL),
(3102890,CONVERT(0x506f727461626c65204272657762617272656c USING utf8mb4),57,0,0,1,0,CONVERT(0x46696e6974652070726f70657274792d70726573657276696e67206d616e75616c2072656368617267653b204c4f43414c206b697420617661696c6162696c69747920616e642065726120666c6f6f723b205252433331302e USING utf8mb4),0,0,0,1,19,-1,NULL,NULL);
INSERT INTO rrc310_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3102883,9181,0,0,1,1,0),
(3102883,64681,1,0,1,0,0),
(3102883,17902,0,0,0,0,1),
(3102884,14510,0,0,1,1,0),
(3102884,14802,0,0,1,1,0),
(3102884,97921,1,0,1,0,0),
(3102884,17902,0,0,0,0,1),
(3102885,29502,0,0,1,0,0),
(3102885,58244,0,0,2,2,0),
(3102885,75857,1,0,0,0,0),
(3102885,17902,0,0,0,0,1),
(3102886,58244,0,0,2,2,0),
(3102886,75857,1,0,1,0,0),
(3102886,17902,0,0,0,0,1),
(3102887,14802,0,0,1,1,0),
(3102887,16905,0,0,1,1,0),
(3102887,97922,1,0,1,0,0),
(3102887,17902,0,0,0,0,1),
(3102888,58244,0,0,1,1,0),
(3102888,96494,1,0,1,0,0),
(3102888,17902,0,0,0,0,1),
(3102889,14804,0,0,1,1,0),
(3102889,29502,1,0,0,0,0),
(3102889,75857,0,0,1,0,0),
(3102889,17902,0,0,0,0,1),
(3102890,34467,0,0,1,1,0),
(3102890,81303,1,0,1,0,0),
(3102890,17902,0,0,0,0,1);
INSERT INTO rrc310_items (`id`,`name`) VALUES
(9181,CONVERT(0x4d616e612042617474657279202d20436c61737320536978 USING utf8mb4)),
(14510,CONVERT(0x4368697070656420426f6e6520526f64 USING utf8mb4)),
(14802,CONVERT(0x4d616e612042617474657279202d20436c617373205468726565 USING utf8mb4)),
(14804,CONVERT(0x4d616e612042617474657279202d20436c6173732046697665 USING utf8mb4)),
(16905,CONVERT(0x4d6574616c2042697473 USING utf8mb4)),
(17902,CONVERT(0x546f6f6c626f78 USING utf8mb4)),
(29502,CONVERT(0x48616c6620436170616369747920476e6f6d6973682056616e697368696e6720446576696365 USING utf8mb4)),
(34467,CONVERT(0x437275646520436f616c USING utf8mb4)),
(58244,CONVERT(0x496e6675736564204461726b204d6174746572 USING utf8mb4)),
(64681,CONVERT(0x506f74696f6e204d616b6572204b6974 USING utf8mb4)),
(75857,CONVERT(0x46756c6c20436170616369747920476e6f6d6973682056616e697368696e6720446576696365 USING utf8mb4)),
(81303,CONVERT(0x506f727461626c65204272657762617272656c USING utf8mb4)),
(96494,CONVERT(0x476565726c6f6b20466c6f61746174696f6e205061636b USING utf8mb4)),
(97921,CONVERT(0x4368697070656420426f6e6520526f64204175676d656e746572 USING utf8mb4)),
(97922,CONVERT(0x476565726c6f6b204175746f6d617465642043616c74726f702043726561746f72 USING utf8mb4));
 CREATE TEMPORARY TABLE rrc310_peer_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc310_peer_entries LIKE tradeskill_recipe_entries;
INSERT INTO rrc310_peer_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(439,CONVERT(0x476e6f6d6973682056616e697368696e6720446576696365 USING utf8mb4),57,0,302,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(440,CONVERT(0x476e6f6d6973682056616e697368696e6720446576696365 USING utf8mb4),57,0,0,1,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(3091599,CONVERT(0x476565726c6f6b20466c6f61746174696f6e205061636b USING utf8mb4),57,0,302,0,0,CONVERT(0x446f44482f506f523b20455154432061727469636c65733335322f3337303b2054696e6b6572696e673b205252433032352e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3092616,CONVERT(0x476565726c6f6b204175746f6d617465642043616c74726f702043726561746f72 USING utf8mb4),57,0,300,0,0,CONVERT(0x5453533b20455154432061727469636c65733339342f3430303b2054696e6b6572696e672f4a6577656c63726166743b205252433034312e USING utf8mb4),0,0,0,1,12,-1,NULL,NULL),
(3094733,CONVERT(0x506f74696f6e204d616b6572204b6974 USING utf8mb4),57,0,322,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f412054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133342e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096655,CONVERT(0x46756c6c20436170616369747920476e6f6d6973682056616e697368696e6720446576696365 USING utf8mb4),57,0,302,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792056656c696f75732054696e6b6572696e67206372656174696f6e207265636f6e737472756374696f6e3b205252433230352e USING utf8mb4),0,0,0,1,2,-1,NULL,NULL),
(3102668,CONVERT(0x506f727461626c65204272657762617272656c USING utf8mb4),57,0,210,0,0,CONVERT(0x4578706c6963697420736f75726365206368617267656420706879736963616c6f7574707574313b66696e6974656372656174696f6e352f31302f3630636861726765732f6e61746976656163746f723b7061636b696e674c4f43414c4e6f536b696c6c37353b5252433239342e USING utf8mb4),0,0,0,1,0,-1,NULL,NULL),
(3102670,CONVERT(0x4368697070656420426f6e6520526f64204175676d656e746572 USING utf8mb4),57,0,120,0,0,CONVERT(0x4578706c6963697420736f75726365206368617267656420706879736963616c6f7574707574313b66696e6974656372656174696f6e352f31302f3630636861726765732f6e61746976656163746f723b7061636b696e674c4f43414c4e6f536b696c6c37353b5252433239342e USING utf8mb4),0,0,0,1,0,-1,NULL,NULL);
INSERT INTO rrc310_peer_entries (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3462,439,10037,0,0,1,1,0),
(3463,439,13003,0,0,1,1,0),
(3464,439,14804,0,0,1,1,0),
(3465,439,16860,0,0,1,1,0),
(3466,439,16861,0,0,1,1,0),
(3467,439,22535,0,0,1,1,0),
(3468,439,24862,0,0,1,1,0),
(3469,439,29502,1,0,0,0,0),
(3470,439,17276,0,0,0,0,1),
(3471,439,17877,0,0,0,0,1),
(3472,439,17902,0,0,0,0,1),
(3473,440,14804,0,0,1,1,0),
(3474,440,29502,1,0,1,1,0),
(3476,440,17276,0,0,0,0,1),
(3477,440,17877,0,0,0,0,1),
(3478,440,17902,0,0,0,0,1),
(30408023,3091599,96494,1,0,0,0,0),
(30408024,3091599,12089,0,0,1,1,0),
(30408025,3091599,63244,0,0,1,1,0),
(30408026,3091599,97071,0,0,1,1,0),
(30408027,3091599,58244,0,1,1,0,0),
(30408028,3091599,16850,0,0,2,2,0),
(30408029,3091599,16893,0,0,1,1,0),
(30408030,3091599,72048,0,0,1,1,0),
(30408031,3091599,10064,1,1,1,0,0),
(30408032,3091599,63841,0,0,1,1,0),
(30408033,3091599,10,0,0,0,0,1),
(30414690,3092616,97922,1,0,0,0,0),
(30414691,3092616,97923,0,0,1,1,0),
(30414692,3092616,10481,0,0,4,4,0),
(30414693,3092616,72016,0,0,1,1,0),
(30414694,3092616,14802,0,0,1,1,0),
(30414695,3092616,16905,0,0,1,1,0),
(30414696,3092616,72046,0,0,2,2,0),
(30414697,3092616,10,0,0,0,0,1),
(30437417,3094733,64681,1,0,0,0,0),
(30437418,3094733,64524,0,0,1,1,0),
(30437419,3094733,64522,0,0,1,1,0),
(30437420,3094733,7483,0,0,1,1,0),
(30437421,3094733,16858,0,0,1,1,0),
(30437422,3094733,63244,0,0,1,1,0),
(30437423,3094733,9181,0,0,1,1,0),
(30437424,3094733,93167,0,0,3,3,0),
(30437425,3094733,16882,0,0,1,1,0),
(30437426,3094733,17877,0,0,0,0,1),
(30459946,3096655,10037,0,0,1,1,0),
(30459947,3096655,13003,0,0,1,1,0),
(30459948,3096655,16860,0,0,1,1,0),
(30459949,3096655,16861,0,0,1,1,0),
(30459950,3096655,22535,0,0,1,1,0),
(30459951,3096655,24862,0,0,1,1,0),
(30459952,3096655,58244,0,0,2,2,0),
(30459953,3096655,75857,10,0,0,0,0),
(30459954,3096655,17902,0,0,0,0,1),
(30459955,3096655,17877,0,0,0,0,1),
(30459956,3096655,17276,0,0,0,0,1),
(30522359,3102668,9179,0,0,1,1,0),
(30522360,3102668,9194,0,0,1,1,0),
(30522361,3102668,16580,0,0,1,1,0),
(30522362,3102668,16858,0,0,1,1,0),
(30522363,3102668,16861,0,0,1,1,0),
(30522364,3102668,63244,0,0,1,1,0),
(30522365,3102668,81138,0,0,1,1,0),
(30522366,3102668,81303,1,0,0,0,0),
(30522367,3102668,17877,0,0,0,0,1),
(30522377,3102670,10062,0,0,1,1,0),
(30522378,3102670,14510,0,0,1,1,0),
(30522379,3102670,14802,0,0,1,1,0),
(30522380,3102670,16850,0,0,1,1,0),
(30522381,3102670,16858,0,0,2,2,0),
(30522382,3102670,16881,0,0,1,1,0),
(30522383,3102670,36172,0,0,1,1,0),
(30522384,3102670,97921,1,0,0,0,0),
(30522385,3102670,17877,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 target database mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=9181 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=14510 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 3 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=14802 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=14804 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16905 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 50 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17902 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 10 AND `bagslots` <=> 8 AND `bagsize` <=> 4 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=29502 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 5 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34467 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 1 AND `reclevel` <=> 4 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=58244 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=64681 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 5 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=75857 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81303 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> 5 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96494 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 20 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=97921 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 60 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=97922 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 3 AND `maxcharges` <=> 5 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 30 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 native item semantics mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc310_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 existing charged-device producer peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc310_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc310_peer_recipes p ON p.id=r.recipe_id)<>74 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 existing charged-device producer peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc310_entries e ON r.item_id=e.item_id AND e.successcount>0 AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc310_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc310_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 output producer universe changed'; END IF;

 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc310_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc310_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 item identity/dependency mismatch'; END IF;
 IF already_present NOT IN (0,8) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 partial batch or ID collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r JOIN rrc310_recipes e ON r.tradeskill=e.tradeskill AND r.name=e.name WHERE r.id<>e.id AND r.id NOT IN(3091599,3092616,3094733,3096655,3102668,3102670,3102883,3102884,3102885,3102886,3102887,3102888,3102889,3102890)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 existing recipe-name collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=64681 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3102883 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=2 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=9181)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=64681)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=97921 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3102884 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=3 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=14510)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=14802)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97921)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=58244 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3102885 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=3 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=29502)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=58244)=2) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=75857 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3102886 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=3 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=58244)=2 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=75857)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=97922 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3102887 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=3 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=14802)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=16905)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97922)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=96494 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3102888 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=2 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=58244)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=96494)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=75857 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3102889 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=2 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=14804)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=75857)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=81303 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3102890 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=2 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=34467)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=81303)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 all-state full input collision'; END IF;
 IF already_present=0 THEN
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc310_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 new ID range has learned references'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc310_recipes e ON r.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 orphan target entries collision'; END IF;
 INSERT INTO tradeskill_recipe (id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled) SELECT id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled FROM rrc310_recipes;
 INSERT INTO tradeskill_recipe_entries (recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer) SELECT recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer FROM rrc310_entries;
 END IF;
 IF EXISTS(SELECT 1 FROM rrc310_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc310_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc310_recipes q ON q.id=r.recipe_id LEFT JOIN rrc310_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc310_recipes q ON q.id=r.recipe_id)<>28 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 target entry multiplicity mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before+IF(already_present=0,8,0) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before+IF(already_present=0,28,0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 unexpected table row-count delta'; END IF;
 IF EXISTS(SELECT 1 FROM rrc310_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 existing charged-device producer peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc310_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc310_peer_recipes p ON p.id=r.recipe_id)<>74 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 existing charged-device producer peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc310_entries e ON r.item_id=e.item_id AND e.successcount>0 AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc310_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc310_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 output producer universe changed'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=64681 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3102883 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=2 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=9181)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=64681)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=97921 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3102884 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=3 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=14510)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=14802)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97921)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=58244 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3102885 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=3 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=29502)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=58244)=2) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=75857 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3102886 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=3 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=58244)=2 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=75857)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=97922 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3102887 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=3 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=14802)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=16905)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=97922)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=96494 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3102888 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=2 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=58244)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=96494)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=75857 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3102889 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=2 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=14804)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=75857)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=81303 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3102890 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=2 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=34467)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=81303)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC310 all-state full input collision'; END IF;
 DROP TEMPORARY TABLE rrc310_peer_entries;
 DROP TEMPORARY TABLE rrc310_peer_recipes;
 DROP TEMPORARY TABLE rrc310_entries;
 DROP TEMPORARY TABLE rrc310_recipes;
 DROP TEMPORARY TABLE rrc310_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC310' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
