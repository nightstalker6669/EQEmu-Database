-- RRC135: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc135_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc135_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc135_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc135_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3094744,CONVERT(0x526567616c20536572766f6c696e6b65642043756972617373 USING utf8mb4),57,300,528,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133352e USING utf8mb4),1,134633,0,1,19,-1,NULL,NULL),
(3094745,CONVERT(0x526567616c204d6574616c6f666962657220526f626573 USING utf8mb4),57,300,528,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133352e USING utf8mb4),1,134633,0,1,19,-1,NULL,NULL),
(3094746,CONVERT(0x526567616c204175746f61637475617465642043756972617373 USING utf8mb4),57,300,528,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133352e USING utf8mb4),1,134633,0,1,19,-1,NULL,NULL),
(3094747,CONVERT(0x526567616c20536572766f6c696e6b65642047726561766573 USING utf8mb4),57,300,523,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133352e USING utf8mb4),1,134633,0,1,19,-1,NULL,NULL),
(3094748,CONVERT(0x526567616c204d6574616c6f6669626572204272656563686573 USING utf8mb4),57,300,523,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133352e USING utf8mb4),1,134633,0,1,19,-1,NULL,NULL),
(3094749,CONVERT(0x526567616c204175746f61637475617465642047726561766573 USING utf8mb4),57,300,523,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133352e USING utf8mb4),1,134633,0,1,19,-1,NULL,NULL),
(3094750,CONVERT(0x526567616c20536572766f6c696e6b656420426f6f7473 USING utf8mb4),57,300,512,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133352e USING utf8mb4),1,134633,0,1,19,-1,NULL,NULL),
(3094751,CONVERT(0x526567616c204d6574616c6f666962657220426f6f7473 USING utf8mb4),57,300,512,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133352e USING utf8mb4),1,134633,0,1,19,-1,NULL,NULL),
(3094752,CONVERT(0x526567616c204175746f616374756174656420426f6f7473 USING utf8mb4),57,300,512,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133352e USING utf8mb4),1,134633,0,1,19,-1,NULL,NULL),
(3094753,CONVERT(0x526567616c20536572766f6c696e6b656420536c6565766573 USING utf8mb4),57,300,518,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133352e USING utf8mb4),1,134633,0,1,19,-1,NULL,NULL),
(3094754,CONVERT(0x526567616c204d6574616c6f666962657220536c6565766573 USING utf8mb4),57,300,518,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133352e USING utf8mb4),1,134633,0,1,19,-1,NULL,NULL),
(3094755,CONVERT(0x526567616c204175746f616374756174656420536c6565766573 USING utf8mb4),57,300,518,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133352e USING utf8mb4),1,134633,0,1,19,-1,NULL,NULL),
(3094756,CONVERT(0x526567616c20536572766f6c696e6b65642041726d62616e64 USING utf8mb4),57,300,498,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133352e USING utf8mb4),1,134633,0,1,19,-1,NULL,NULL),
(3094757,CONVERT(0x526567616c204d6574616c6f66696265722041726d62616e64 USING utf8mb4),57,300,498,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133352e USING utf8mb4),1,134633,0,1,19,-1,NULL,NULL),
(3094758,CONVERT(0x526567616c204175746f61637475617465642041726d62616e64 USING utf8mb4),57,300,498,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133352e USING utf8mb4),1,134633,0,1,19,-1,NULL,NULL),
(3094759,CONVERT(0x526567616c20536572766f6c696e6b656420476c6f766573 USING utf8mb4),57,300,503,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133352e USING utf8mb4),1,134633,0,1,19,-1,NULL,NULL),
(3094760,CONVERT(0x526567616c204d6574616c6f666962657220476c6f766573 USING utf8mb4),57,300,503,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133352e USING utf8mb4),1,134633,0,1,19,-1,NULL,NULL),
(3094761,CONVERT(0x526567616c204175746f616374756174656420476c6f766573 USING utf8mb4),57,300,503,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133352e USING utf8mb4),1,134633,0,1,19,-1,NULL,NULL),
(3094762,CONVERT(0x526567616c20536572766f6c696e6b65642048656c6d USING utf8mb4),57,300,507,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133352e USING utf8mb4),1,134633,0,1,19,-1,NULL,NULL),
(3094763,CONVERT(0x526567616c204d6574616c6f666962657220436170 USING utf8mb4),57,300,507,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133352e USING utf8mb4),1,134633,0,1,19,-1,NULL,NULL),
(3094764,CONVERT(0x526567616c204175746f61637475617465642048656c6d USING utf8mb4),57,300,507,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920526f462054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133352e USING utf8mb4),1,134633,0,1,19,-1,NULL,NULL);
INSERT INTO rrc135_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3094744,133997,1,0,0,0,0),
(3094744,135309,0,0,1,1,0),
(3094744,134657,0,0,1,1,0),
(3094744,16858,0,0,1,1,0),
(3094744,63244,0,0,1,1,0),
(3094744,133978,0,0,1,1,0),
(3094744,38905,0,0,1,1,0),
(3094744,134522,0,0,1,1,0),
(3094744,16859,0,0,1,1,0),
(3094744,13006,0,0,1,1,0),
(3094744,17877,0,0,0,0,1),
(3094745,133998,1,0,0,0,0),
(3094745,134498,0,0,1,1,0),
(3094745,134656,0,0,1,1,0),
(3094745,135310,0,0,1,1,0),
(3094745,63244,0,0,1,1,0),
(3094745,133962,0,0,1,1,0),
(3094745,16888,0,0,1,1,0),
(3094745,38800,0,0,1,1,0),
(3094745,13006,0,0,1,1,0),
(3094745,17877,0,0,0,0,1),
(3094746,133999,1,0,0,0,0),
(3094746,135309,0,0,1,1,0),
(3094746,29513,0,0,1,1,0),
(3094746,65451,0,0,2,2,0),
(3094746,134657,0,0,1,1,0),
(3094746,63244,0,0,1,1,0),
(3094746,133978,0,0,1,1,0),
(3094746,38905,0,0,1,1,0),
(3094746,134534,0,0,1,1,0),
(3094746,13006,0,0,1,1,0),
(3094746,17877,0,0,0,0,1),
(3094747,134041,1,0,0,0,0),
(3094747,135309,0,0,1,1,0),
(3094747,134657,0,0,1,1,0),
(3094747,16858,0,0,1,1,0),
(3094747,63244,0,0,1,1,0),
(3094747,133978,0,0,1,1,0),
(3094747,38906,0,0,1,1,0),
(3094747,134529,0,0,1,1,0),
(3094747,16859,0,0,1,1,0),
(3094747,13006,0,0,1,1,0),
(3094747,17877,0,0,0,0,1),
(3094748,134042,1,0,0,0,0),
(3094748,134505,0,0,1,1,0),
(3094748,134656,0,0,1,1,0),
(3094748,135310,0,0,1,1,0),
(3094748,63244,0,0,1,1,0),
(3094748,133962,0,0,1,1,0),
(3094748,16888,0,0,1,1,0),
(3094748,38801,0,0,1,1,0),
(3094748,13006,0,0,1,1,0),
(3094748,17877,0,0,0,0,1),
(3094749,134043,1,0,0,0,0),
(3094749,135309,0,0,1,1,0),
(3094749,29513,0,0,1,1,0),
(3094749,65451,0,0,2,2,0),
(3094749,134657,0,0,1,1,0),
(3094749,63244,0,0,1,1,0),
(3094749,133978,0,0,1,1,0),
(3094749,38906,0,0,1,1,0),
(3094749,134541,0,0,1,1,0),
(3094749,13006,0,0,1,1,0),
(3094749,17877,0,0,0,0,1),
(3094750,134085,1,0,0,0,0),
(3094750,135309,0,0,1,1,0),
(3094750,134657,0,0,1,1,0),
(3094750,16858,0,0,1,1,0),
(3094750,63244,0,0,1,1,0),
(3094750,133978,0,0,1,1,0),
(3094750,38903,0,0,1,1,0),
(3094750,134530,0,0,1,1,0),
(3094750,16859,0,0,1,1,0),
(3094750,13006,0,0,1,1,0),
(3094750,17877,0,0,0,0,1),
(3094751,134086,1,0,0,0,0),
(3094751,134506,0,0,1,1,0),
(3094751,134656,0,0,1,1,0),
(3094751,135310,0,0,1,1,0),
(3094751,63244,0,0,1,1,0),
(3094751,133962,0,0,1,1,0),
(3094751,16888,0,0,1,1,0),
(3094751,38798,0,0,1,1,0),
(3094751,13006,0,0,1,1,0),
(3094751,17877,0,0,0,0,1),
(3094752,134087,1,0,0,0,0),
(3094752,135309,0,0,1,1,0),
(3094752,29513,0,0,1,1,0),
(3094752,65451,0,0,2,2,0),
(3094752,134657,0,0,1,1,0),
(3094752,63244,0,0,1,1,0),
(3094752,133978,0,0,1,1,0),
(3094752,38903,0,0,1,1,0),
(3094752,134542,0,0,1,1,0),
(3094752,13006,0,0,1,1,0),
(3094752,17877,0,0,0,0,1),
(3094753,134129,1,0,0,0,0),
(3094753,135309,0,0,1,1,0),
(3094753,134657,0,0,1,1,0),
(3094753,16858,0,0,1,1,0),
(3094753,63244,0,0,1,1,0),
(3094753,133978,0,0,1,1,0),
(3094753,38904,0,0,1,1,0),
(3094753,38901,0,0,1,1,0),
(3094753,16859,0,0,1,1,0),
(3094753,13006,0,0,1,1,0),
(3094753,17877,0,0,0,0,1),
(3094754,134130,1,0,0,0,0),
(3094754,134502,0,0,1,1,0),
(3094754,134656,0,0,1,1,0),
(3094754,135310,0,0,1,1,0),
(3094754,63244,0,0,1,1,0),
(3094754,133962,0,0,1,1,0),
(3094754,16888,0,0,1,1,0),
(3094754,38796,0,0,1,1,0),
(3094754,13006,0,0,1,1,0),
(3094754,17877,0,0,0,0,1),
(3094755,134131,1,0,0,0,0),
(3094755,135309,0,0,1,1,0),
(3094755,29513,0,0,1,1,0),
(3094755,65451,0,0,2,2,0),
(3094755,134657,0,0,1,1,0),
(3094755,63244,0,0,1,1,0),
(3094755,133978,0,0,1,1,0),
(3094755,38901,0,0,1,1,0),
(3094755,134538,0,0,1,1,0),
(3094755,13006,0,0,1,1,0),
(3094755,17877,0,0,0,0,1),
(3094756,134173,1,0,0,0,0),
(3094756,135309,0,0,1,1,0),
(3094756,134657,0,0,1,1,0),
(3094756,16858,0,0,1,1,0),
(3094756,63244,0,0,1,1,0),
(3094756,133978,0,0,1,1,0),
(3094756,38900,0,0,1,1,0),
(3094756,134527,0,0,1,1,0),
(3094756,16859,0,0,1,1,0),
(3094756,13006,0,0,1,1,0),
(3094756,17877,0,0,0,0,1),
(3094757,134174,1,0,0,0,0),
(3094757,134503,0,0,1,1,0),
(3094757,134656,0,0,1,1,0),
(3094757,135310,0,0,1,1,0),
(3094757,63244,0,0,1,1,0),
(3094757,133962,0,0,1,1,0),
(3094757,16888,0,0,1,1,0),
(3094757,38795,0,0,1,1,0),
(3094757,13006,0,0,1,1,0),
(3094757,17877,0,0,0,0,1),
(3094758,134175,1,0,0,0,0),
(3094758,135309,0,0,1,1,0),
(3094758,29513,0,0,1,1,0),
(3094758,65451,0,0,2,2,0),
(3094758,134657,0,0,1,1,0),
(3094758,63244,0,0,1,1,0),
(3094758,133978,0,0,1,1,0),
(3094758,38900,0,0,1,1,0),
(3094758,134539,0,0,1,1,0),
(3094758,13006,0,0,1,1,0),
(3094758,17877,0,0,0,0,1),
(3094759,134217,1,0,0,0,0),
(3094759,135309,0,0,1,1,0),
(3094759,134657,0,0,1,1,0),
(3094759,16858,0,0,1,1,0),
(3094759,63244,0,0,1,1,0),
(3094759,133978,0,0,1,1,0),
(3094759,38902,0,0,1,1,0),
(3094759,134528,0,0,1,1,0),
(3094759,16859,0,0,1,1,0),
(3094759,13006,0,0,1,1,0),
(3094759,17877,0,0,0,0,1),
(3094760,134218,1,0,0,0,0),
(3094760,134504,0,0,1,1,0),
(3094760,134656,0,0,1,1,0),
(3094760,135310,0,0,1,1,0),
(3094760,63244,0,0,1,1,0),
(3094760,133962,0,0,1,1,0),
(3094760,16888,0,0,1,1,0),
(3094760,38797,0,0,1,1,0),
(3094760,13006,0,0,1,1,0),
(3094760,17877,0,0,0,0,1),
(3094761,134219,1,0,0,0,0),
(3094761,135309,0,0,1,1,0),
(3094761,29513,0,0,1,1,0),
(3094761,65451,0,0,2,2,0),
(3094761,134657,0,0,1,1,0),
(3094761,63244,0,0,1,1,0),
(3094761,133978,0,0,1,1,0),
(3094761,38902,0,0,1,1,0),
(3094761,134540,0,0,1,1,0),
(3094761,13006,0,0,1,1,0),
(3094761,17877,0,0,0,0,1),
(3094762,134261,1,0,0,0,0),
(3094762,135309,0,0,1,1,0),
(3094762,134657,0,0,1,1,0),
(3094762,16858,0,0,1,1,0),
(3094762,63244,0,0,1,1,0),
(3094762,133978,0,0,1,1,0),
(3094762,38904,0,0,1,1,0),
(3094762,134519,0,0,1,1,0),
(3094762,16859,0,0,1,1,0),
(3094762,13006,0,0,1,1,0),
(3094762,17877,0,0,0,0,1),
(3094763,134262,1,0,0,0,0),
(3094763,134494,0,0,1,1,0),
(3094763,134656,0,0,1,1,0),
(3094763,135310,0,0,1,1,0),
(3094763,63244,0,0,1,1,0),
(3094763,133962,0,0,1,1,0),
(3094763,16888,0,0,1,1,0),
(3094763,38799,0,0,1,1,0),
(3094763,13006,0,0,1,1,0),
(3094763,17877,0,0,0,0,1),
(3094764,134263,1,0,0,0,0),
(3094764,135309,0,0,1,1,0),
(3094764,29513,0,0,1,1,0),
(3094764,65451,0,0,2,2,0),
(3094764,134657,0,0,1,1,0),
(3094764,63244,0,0,1,1,0),
(3094764,133978,0,0,1,1,0),
(3094764,38904,0,0,1,1,0),
(3094764,134531,0,0,1,1,0),
(3094764,13006,0,0,1,1,0),
(3094764,17877,0,0,0,0,1);
INSERT INTO rrc135_items (`id`,`name`) VALUES
(13006,CONVERT(0x576174657220466c61736b USING utf8mb4)),
(16858,CONVERT(0x4765617273 USING utf8mb4)),
(16859,CONVERT(0x5370726f636b657473 USING utf8mb4)),
(16888,CONVERT(0x4d6574616c2046617374656e696e67 USING utf8mb4)),
(17877,CONVERT(0x44656c75786520546f6f6c626f78 USING utf8mb4)),
(29513,CONVERT(0x436f6773 USING utf8mb4)),
(38795,CONVERT(0x5061747465726e20666f7220476e6f6d697368205772697374677561726473 USING utf8mb4)),
(38796,CONVERT(0x5061747465726e20666f7220476e6f6d69736820536c6565766573 USING utf8mb4)),
(38797,CONVERT(0x5061747465726e20666f7220476e6f6d69736820476c6f766573 USING utf8mb4)),
(38798,CONVERT(0x5061747465726e20666f7220476e6f6d69736820426f6f7473 USING utf8mb4)),
(38799,CONVERT(0x5061747465726e20666f7220476e6f6d6973682048656c6d73 USING utf8mb4)),
(38800,CONVERT(0x5061747465726e20666f7220476e6f6d6973682054756e696373 USING utf8mb4)),
(38801,CONVERT(0x5061747465726e20666f7220476e6f6d697368204c656767696e6773 USING utf8mb4)),
(38900,CONVERT(0x4d6f6c6420666f7220476e6f6d697368205772697374677561726473 USING utf8mb4)),
(38901,CONVERT(0x4d6f6c6420666f7220476e6f6d69736820536c6565766573 USING utf8mb4)),
(38902,CONVERT(0x4d6f6c6420666f7220476e6f6d69736820476c6f766573 USING utf8mb4)),
(38903,CONVERT(0x4d6f6c6420666f7220476e6f6d69736820426f6f7473 USING utf8mb4)),
(38904,CONVERT(0x4d6f6c6420666f7220476e6f6d6973682048656c6d73 USING utf8mb4)),
(38905,CONVERT(0x4d6f6c6420666f7220476e6f6d697368204368657374706c61746573 USING utf8mb4)),
(38906,CONVERT(0x4d6f6c6420666f7220476e6f6d697368204c656767696e6773 USING utf8mb4)),
(63244,CONVERT(0x476e6f6d697368204865617420536f75726365 USING utf8mb4)),
(65451,CONVERT(0x436f6e7472617074696f6e205061727473 USING utf8mb4)),
(133962,CONVERT(0x4c756d696e657363656e7420466f727469666965642042726f6e7a6520546872656164 USING utf8mb4)),
(133978,CONVERT(0x4c756d696e657363656e7420466f727469666965642042726f6e7a65 USING utf8mb4)),
(133997,CONVERT(0x526567616c20536572766f6c696e6b65642043756972617373 USING utf8mb4)),
(133998,CONVERT(0x526567616c204d6574616c6f666962657220526f626573 USING utf8mb4)),
(133999,CONVERT(0x526567616c204175746f61637475617465642043756972617373 USING utf8mb4)),
(134041,CONVERT(0x526567616c20536572766f6c696e6b65642047726561766573 USING utf8mb4)),
(134042,CONVERT(0x526567616c204d6574616c6f6669626572204272656563686573 USING utf8mb4)),
(134043,CONVERT(0x526567616c204175746f61637475617465642047726561766573 USING utf8mb4)),
(134085,CONVERT(0x526567616c20536572766f6c696e6b656420426f6f7473 USING utf8mb4)),
(134086,CONVERT(0x526567616c204d6574616c6f666962657220426f6f7473 USING utf8mb4)),
(134087,CONVERT(0x526567616c204175746f616374756174656420426f6f7473 USING utf8mb4)),
(134129,CONVERT(0x526567616c20536572766f6c696e6b656420536c6565766573 USING utf8mb4)),
(134130,CONVERT(0x526567616c204d6574616c6f666962657220536c6565766573 USING utf8mb4)),
(134131,CONVERT(0x526567616c204175746f616374756174656420536c6565766573 USING utf8mb4)),
(134173,CONVERT(0x526567616c20536572766f6c696e6b65642041726d62616e64 USING utf8mb4)),
(134174,CONVERT(0x526567616c204d6574616c6f66696265722041726d62616e64 USING utf8mb4)),
(134175,CONVERT(0x526567616c204175746f61637475617465642041726d62616e64 USING utf8mb4)),
(134217,CONVERT(0x526567616c20536572766f6c696e6b656420476c6f766573 USING utf8mb4)),
(134218,CONVERT(0x526567616c204d6574616c6f666962657220476c6f766573 USING utf8mb4)),
(134219,CONVERT(0x526567616c204175746f616374756174656420476c6f766573 USING utf8mb4)),
(134261,CONVERT(0x526567616c20536572766f6c696e6b65642048656c6d USING utf8mb4)),
(134262,CONVERT(0x526567616c204d6574616c6f666962657220436170 USING utf8mb4)),
(134263,CONVERT(0x526567616c204175746f61637475617465642048656c6d USING utf8mb4)),
(134494,CONVERT(0x4265666f756c65642053696c6b204361702054656d706c617465 USING utf8mb4)),
(134498,CONVERT(0x4265666f756c65642053696c6b20526f62652054656d706c617465 USING utf8mb4)),
(134502,CONVERT(0x4265666f756c65642053696c6b20536c656576652054656d706c617465 USING utf8mb4)),
(134503,CONVERT(0x4265666f756c65642053696c6b20577269737462616e642054656d706c617465 USING utf8mb4)),
(134504,CONVERT(0x4265666f756c65642053696c6b20476c6f76652054656d706c617465 USING utf8mb4)),
(134505,CONVERT(0x4265666f756c65642053696c6b2050616e742054656d706c617465 USING utf8mb4)),
(134506,CONVERT(0x4265666f756c65642053696c6b20426f6f742054656d706c617465 USING utf8mb4)),
(134519,CONVERT(0x53636f726368656420436861696e20436f69662054656d706c617465 USING utf8mb4)),
(134522,CONVERT(0x53636f726368656420436861696e20436865737467756172642054656d706c617465 USING utf8mb4)),
(134527,CONVERT(0x53636f726368656420436861696e204272616365722054656d706c617465 USING utf8mb4)),
(134528,CONVERT(0x53636f726368656420436861696e20476c6f7665732054656d706c617465 USING utf8mb4)),
(134529,CONVERT(0x53636f726368656420436861696e204c6567706c617465732054656d706c617465 USING utf8mb4)),
(134530,CONVERT(0x53636f726368656420436861696e20426f6f74732054656d706c617465 USING utf8mb4)),
(134531,CONVERT(0x53636f726368656420506c6174652048656c6d2054656d706c617465 USING utf8mb4)),
(134534,CONVERT(0x53636f726368656420427265617374706c6174652054656d706c617465 USING utf8mb4)),
(134538,CONVERT(0x53636f726368656420506c6174652056616d62726163652054656d706c617465 USING utf8mb4)),
(134539,CONVERT(0x53636f726368656420506c617465204272616365722054656d706c617465 USING utf8mb4)),
(134540,CONVERT(0x53636f726368656420506c617465204761756e746c65742054656d706c617465 USING utf8mb4)),
(134541,CONVERT(0x53636f726368656420506c61746520477265617665732054656d706c617465 USING utf8mb4)),
(134542,CONVERT(0x53636f726368656420506c61746520426f6f742054656d706c617465 USING utf8mb4)),
(134633,CONVERT(0x526567616c20476e6f6d6973682043756c747572616c2054696e6b6572696e67 USING utf8mb4)),
(134656,CONVERT(0x4265666f756c6564205370696e6e6572657420466c756964 USING utf8mb4)),
(134657,CONVERT(0x436f72727570746564204c6f616d USING utf8mb4)),
(135309,CONVERT(0x4368617267656420436f616c USING utf8mb4)),
(135310,CONVERT(0x43616c6369666965642046696c616d656e74 USING utf8mb4));
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF (SELECT COUNT(*)FROM books WHERE name=CONVERT(0x5453534b55323043546e6b474e4d313030 USING utf8mb4) AND SHA2(txtfile,256)=CONVERT(0x65663135343565396435636565383261633463363539313664353931383561303962316534386332393639366333636137623132333633383163653039306461 USING utf8mb4))<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native book context mismatch'; END IF;

 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc135_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc135_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=13006 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 15 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16858 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16859 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16888 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17877 AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 10 AND `bagslots` <=> 10 AND `bagsize` <=> 4 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=29513 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38795 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 400 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38796 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38797 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38798 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38799 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38800 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38801 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38900 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 400 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38901 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38902 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38903 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38904 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38905 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38906 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=63244 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 25 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=65451 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=133962 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=133978 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=133997 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 256 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 131072 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=133998 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 15360 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 131072 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=133999 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 23 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 131072 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134041 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 256 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 262144 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134042 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 15360 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 262144 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134043 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 23 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 262144 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134085 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 256 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 524288 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134086 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 15360 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 524288 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134087 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 23 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 524288 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134129 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 256 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 128 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134130 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 15360 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 128 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134131 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 23 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 128 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134173 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 256 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 1536 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134174 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 15360 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 1536 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134175 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 23 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 1536 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134217 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 256 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 4096 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134218 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 15360 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 4096 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134219 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 23 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 4096 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134261 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 256 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 4 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134262 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 15360 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 4 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134263 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 23 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 4 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134494 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 9 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134498 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 3 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134502 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 9 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134503 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 15 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134504 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 15 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134505 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 3 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134506 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 9 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134519 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 6 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134522 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 2 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134527 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134528 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134529 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 2 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134530 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 6 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134531 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 3 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134534 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134538 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 3 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134539 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 5 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134540 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 5 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134541 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134542 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 3 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134633 AND `size` <=> 0 AND `itemclass` <=> 2 AND `itemtype` <=> 60 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 0 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> CONVERT(0x5453534b55323043546e6b474e4d313030 USING utf8mb4) AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134656 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134657 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=135309 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=135310 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 native item semantics mismatch'; END IF;
 IF already_present<>21 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc135_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc135_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc135_recipes q ON q.id=r.recipe_id LEFT JOIN rrc135_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc135_recipes q ON q.id=r.recipe_id)<>224 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc135_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc135_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc135_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-21 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-224 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC135 rollback count mismatch'; END IF;
 DROP TEMPORARY TABLE rrc135_entries;
 DROP TEMPORARY TABLE rrc135_recipes;
 DROP TEMPORARY TABLE rrc135_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC135' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
