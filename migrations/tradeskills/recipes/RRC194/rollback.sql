-- RRC194: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc194_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc194_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc194_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc194_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3096506,CONVERT(0x4578747261766167616e7420536d616c6c2048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54204578747261766167616e74206d6f6c64207265636f6e737472756374696f6e3b205252433139342e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096507,CONVERT(0x4578747261766167616e742048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54204578747261766167616e74206d6f6c64207265636f6e737472756374696f6e3b205252433139342e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096508,CONVERT(0x4578747261766167616e74204c617267652048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54204578747261766167616e74206d6f6c64207265636f6e737472756374696f6e3b205252433139342e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096509,CONVERT(0x4578747261766167616e7420426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54204578747261766167616e74206d6f6c64207265636f6e737472756374696f6e3b205252433139342e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096510,CONVERT(0x4578747261766167616e7420486561767920426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54204578747261766167616e74206d6f6c64207265636f6e737472756374696f6e3b205252433139342e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096511,CONVERT(0x4578747261766167616e7420417865204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54204578747261766167616e74206d6f6c64207265636f6e737472756374696f6e3b205252433139342e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096512,CONVERT(0x4578747261766167616e7420536d616c6c20426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54204578747261766167616e74206d6f6c64207265636f6e737472756374696f6e3b205252433139342e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096513,CONVERT(0x4578747261766167616e74205370656172204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54204578747261766167616e74206d6f6c64207265636f6e737472756374696f6e3b205252433139342e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096514,CONVERT(0x4578747261766167616e74204d616365204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54204578747261766167616e74206d6f6c64207265636f6e737472756374696f6e3b205252433139342e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096515,CONVERT(0x4578747261766167616e742048616d6d6572204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54204578747261766167616e74206d6f6c64207265636f6e737472756374696f6e3b205252433139342e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096516,CONVERT(0x4578747261766167616e74204d6574616c205772617020536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54204578747261766167616e74206d6f6c64207265636f6e737472756374696f6e3b205252433139342e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096517,CONVERT(0x4578747261766167616e7420556c616b20426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54204578747261766167616e74206d6f6c64207265636f6e737472756374696f6e3b205252433139342e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096518,CONVERT(0x4578747261766167616e74204c6172676520426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54204578747261766167616e74206d6f6c64207265636f6e737472756374696f6e3b205252433139342e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096519,CONVERT(0x4578747261766167616e74204c6172676520417865204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54204578747261766167616e74206d6f6c64207265636f6e737472756374696f6e3b205252433139342e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096520,CONVERT(0x556e6669726564204578747261766167616e7420536d616c6c2048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,282,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54204578747261766167616e74206d6f6c64207265636f6e737472756374696f6e3b205252433139342e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096521,CONVERT(0x556e6669726564204578747261766167616e742048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,282,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54204578747261766167616e74206d6f6c64207265636f6e737472756374696f6e3b205252433139342e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096522,CONVERT(0x556e6669726564204578747261766167616e74204c617267652048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,282,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54204578747261766167616e74206d6f6c64207265636f6e737472756374696f6e3b205252433139342e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096523,CONVERT(0x556e6669726564204578747261766167616e7420486561767920426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,282,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54204578747261766167616e74206d6f6c64207265636f6e737472756374696f6e3b205252433139342e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096524,CONVERT(0x556e6669726564204578747261766167616e7420417865204865616420536861706564204d6f6c64 USING utf8mb4),69,0,282,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54204578747261766167616e74206d6f6c64207265636f6e737472756374696f6e3b205252433139342e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096525,CONVERT(0x556e6669726564204578747261766167616e7420536d616c6c20426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,282,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54204578747261766167616e74206d6f6c64207265636f6e737472756374696f6e3b205252433139342e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096526,CONVERT(0x556e6669726564204578747261766167616e74205370656172204865616420536861706564204d6f6c64 USING utf8mb4),69,0,282,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54204578747261766167616e74206d6f6c64207265636f6e737472756374696f6e3b205252433139342e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096527,CONVERT(0x556e6669726564204578747261766167616e74204d616365204865616420536861706564204d6f6c64 USING utf8mb4),69,0,282,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54204578747261766167616e74206d6f6c64207265636f6e737472756374696f6e3b205252433139342e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096528,CONVERT(0x556e6669726564204578747261766167616e742048616d6d6572204865616420536861706564204d6f6c64 USING utf8mb4),69,0,282,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54204578747261766167616e74206d6f6c64207265636f6e737472756374696f6e3b205252433139342e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096529,CONVERT(0x556e6669726564204578747261766167616e74204d6574616c205772617020536861706564204d6f6c64 USING utf8mb4),69,0,282,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54204578747261766167616e74206d6f6c64207265636f6e737472756374696f6e3b205252433139342e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096530,CONVERT(0x556e6669726564204578747261766167616e7420556c616b20426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,282,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54204578747261766167616e74206d6f6c64207265636f6e737472756374696f6e3b205252433139342e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096531,CONVERT(0x556e6669726564204578747261766167616e74204c6172676520426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,284,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54204578747261766167616e74206d6f6c64207265636f6e737472756374696f6e3b205252433139342e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL),
(3096532,CONVERT(0x556e6669726564204578747261766167616e74204c6172676520417865204865616420536861706564204d6f6c64 USING utf8mb4),69,0,287,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920486f54204578747261766167616e74206d6f6c64207265636f6e737472756374696f6e3b205252433139342e USING utf8mb4),0,0,0,1,17,-1,NULL,NULL);
INSERT INTO rrc194_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3096506,16908,0,0,1,1,0),
(3096506,60795,1,0,0,0,0),
(3096506,60918,0,0,1,1,0),
(3096506,9,0,0,0,0,1),
(3096507,16908,0,0,1,1,0),
(3096507,60796,1,0,0,0,0),
(3096507,60919,0,0,1,1,0),
(3096507,9,0,0,0,0,1),
(3096508,16908,0,0,1,1,0),
(3096508,60797,1,0,0,0,0),
(3096508,60920,0,0,1,1,0),
(3096508,9,0,0,0,0,1),
(3096509,16908,0,0,1,1,0),
(3096509,60798,1,0,0,0,0),
(3096509,60921,0,0,1,1,0),
(3096509,9,0,0,0,0,1),
(3096510,16908,0,0,1,1,0),
(3096510,60799,1,0,0,0,0),
(3096510,60922,0,0,1,1,0),
(3096510,9,0,0,0,0,1),
(3096511,16908,0,0,1,1,0),
(3096511,60800,1,0,0,0,0),
(3096511,60923,0,0,1,1,0),
(3096511,9,0,0,0,0,1),
(3096512,16908,0,0,1,1,0),
(3096512,60801,1,0,0,0,0),
(3096512,60924,0,0,1,1,0),
(3096512,9,0,0,0,0,1),
(3096513,16908,0,0,1,1,0),
(3096513,60802,1,0,0,0,0),
(3096513,60925,0,0,1,1,0),
(3096513,9,0,0,0,0,1),
(3096514,16908,0,0,1,1,0),
(3096514,60803,1,0,0,0,0),
(3096514,60926,0,0,1,1,0),
(3096514,9,0,0,0,0,1),
(3096515,16908,0,0,1,1,0),
(3096515,60804,1,0,0,0,0),
(3096515,60927,0,0,1,1,0),
(3096515,9,0,0,0,0,1),
(3096516,16908,0,0,1,1,0),
(3096516,60805,1,0,0,0,0),
(3096516,60928,0,0,1,1,0),
(3096516,9,0,0,0,0,1),
(3096517,16908,0,0,1,1,0),
(3096517,60806,1,0,0,0,0),
(3096517,60929,0,0,1,1,0),
(3096517,9,0,0,0,0,1),
(3096518,16908,0,0,1,1,0),
(3096518,60807,1,0,0,0,0),
(3096518,60930,0,0,1,1,0),
(3096518,9,0,0,0,0,1),
(3096519,16908,0,0,1,1,0),
(3096519,60808,1,0,0,0,0),
(3096519,60931,0,0,1,1,0),
(3096519,9,0,0,0,0,1),
(3096520,16901,0,0,1,1,0),
(3096520,48893,0,0,1,1,0),
(3096520,60918,1,0,0,0,0),
(3096520,123501,0,0,1,1,0),
(3096520,8,0,0,0,0,1),
(3096521,16902,0,0,1,1,0),
(3096521,48894,0,0,1,1,0),
(3096521,60919,1,0,0,0,0),
(3096521,123501,0,0,1,1,0),
(3096521,8,0,0,0,0,1),
(3096522,16901,0,0,1,1,0),
(3096522,16902,0,0,1,1,0),
(3096522,48895,0,0,1,1,0),
(3096522,60920,1,0,0,0,0),
(3096522,123501,0,0,1,1,0),
(3096522,8,0,0,0,0,1),
(3096523,16902,0,0,3,3,0),
(3096523,48897,0,0,1,1,0),
(3096523,60922,1,0,0,0,0),
(3096523,123501,0,0,1,1,0),
(3096523,8,0,0,0,0,1),
(3096524,16902,0,0,2,2,0),
(3096524,48898,0,0,1,1,0),
(3096524,60923,1,0,0,0,0),
(3096524,123501,0,0,1,1,0),
(3096524,8,0,0,0,0,1),
(3096525,16902,0,0,1,1,0),
(3096525,48899,0,0,1,1,0),
(3096525,60924,1,0,0,0,0),
(3096525,123501,0,0,1,1,0),
(3096525,8,0,0,0,0,1),
(3096526,16902,0,0,1,1,0),
(3096526,48900,0,0,1,1,0),
(3096526,60925,1,0,0,0,0),
(3096526,123501,0,0,1,1,0),
(3096526,8,0,0,0,0,1),
(3096527,16902,0,0,1,1,0),
(3096527,48901,0,0,1,1,0),
(3096527,60926,1,0,0,0,0),
(3096527,123501,0,0,1,1,0),
(3096527,8,0,0,0,0,1),
(3096528,16902,0,0,2,2,0),
(3096528,48902,0,0,1,1,0),
(3096528,60927,1,0,0,0,0),
(3096528,123501,0,0,1,1,0),
(3096528,8,0,0,0,0,1),
(3096529,16901,0,0,1,1,0),
(3096529,48903,0,0,1,1,0),
(3096529,60928,1,0,0,0,0),
(3096529,123501,0,0,1,1,0),
(3096529,8,0,0,0,0,1),
(3096530,16902,0,0,1,1,0),
(3096530,48904,0,0,1,1,0),
(3096530,60929,1,0,0,0,0),
(3096530,123501,0,0,1,1,0),
(3096530,8,0,0,0,0,1),
(3096531,16902,0,0,4,4,0),
(3096531,48905,0,0,1,1,0),
(3096531,60930,1,0,0,0,0),
(3096531,123501,0,0,1,1,0),
(3096531,8,0,0,0,0,1),
(3096532,16902,0,0,4,4,0),
(3096532,48906,0,0,1,1,0),
(3096532,60931,1,0,0,0,0),
(3096532,123501,0,0,1,1,0),
(3096532,8,0,0,0,0,1);
INSERT INTO rrc194_items (`id`,`name`) VALUES
(16901,CONVERT(0x426c6f636b206f6620436c6179 USING utf8mb4)),
(16902,CONVERT(0x4c6172676520426c6f636b206f6620436c6179 USING utf8mb4)),
(16908,CONVERT(0x48696768205175616c69747920466972696e67205368656574 USING utf8mb4)),
(48893,CONVERT(0x536d616c6c2048696c742043617374696e67204d6f6c6420536b65746368 USING utf8mb4)),
(48894,CONVERT(0x48696c742043617374696e67204d6f6c6420536b65746368 USING utf8mb4)),
(48895,CONVERT(0x4c617267652048696c742043617374696e67204d6f6c6420536b65746368 USING utf8mb4)),
(48897,CONVERT(0x486561767920426c61646520536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48898,CONVERT(0x417865204865616420536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48899,CONVERT(0x536d616c6c20426c61646520536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48900,CONVERT(0x5370656172204865616420536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48901,CONVERT(0x4d616365204865616420536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48902,CONVERT(0x48616d6d6572204865616420536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48903,CONVERT(0x4d6574616c205772617020536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48904,CONVERT(0x556c616b20426c61646520536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48905,CONVERT(0x4c6172676520426c61646520536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48906,CONVERT(0x4c6172676520417865204865616420536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(60795,CONVERT(0x4578747261766167616e7420536d616c6c2048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(60796,CONVERT(0x4578747261766167616e742048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(60797,CONVERT(0x4578747261766167616e74204c617267652048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(60798,CONVERT(0x4578747261766167616e7420426c61646520536861706564204d6f6c64 USING utf8mb4)),
(60799,CONVERT(0x4578747261766167616e7420486561767920426c61646520536861706564204d6f6c64 USING utf8mb4)),
(60800,CONVERT(0x4578747261766167616e7420417865204865616420536861706564204d6f6c64 USING utf8mb4)),
(60801,CONVERT(0x4578747261766167616e7420536d616c6c20426c61646520536861706564204d6f6c64 USING utf8mb4)),
(60802,CONVERT(0x4578747261766167616e74205370656172204865616420536861706564204d6f6c64 USING utf8mb4)),
(60803,CONVERT(0x4578747261766167616e74204d616365204865616420536861706564204d6f6c64 USING utf8mb4)),
(60804,CONVERT(0x4578747261766167616e742048616d6d6572204865616420536861706564204d6f6c64 USING utf8mb4)),
(60805,CONVERT(0x4578747261766167616e74204d6574616c205772617020536861706564204d6f6c64 USING utf8mb4)),
(60806,CONVERT(0x4578747261766167616e7420556c616b20426c61646520536861706564204d6f6c64 USING utf8mb4)),
(60807,CONVERT(0x4578747261766167616e74204c6172676520426c61646520536861706564204d6f6c64 USING utf8mb4)),
(60808,CONVERT(0x4578747261766167616e74204c6172676520417865204865616420536861706564204d6f6c64 USING utf8mb4)),
(60918,CONVERT(0x556e6669726564204578747261766167616e7420536d616c6c2048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(60919,CONVERT(0x556e6669726564204578747261766167616e742048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(60920,CONVERT(0x556e6669726564204578747261766167616e74204c617267652048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(60921,CONVERT(0x556e6669726564204578747261766167616e7420426c61646520536861706564204d6f6c64 USING utf8mb4)),
(60922,CONVERT(0x556e6669726564204578747261766167616e7420486561767920426c61646520536861706564204d6f6c64 USING utf8mb4)),
(60923,CONVERT(0x556e6669726564204578747261766167616e7420417865204865616420536861706564204d6f6c64 USING utf8mb4)),
(60924,CONVERT(0x556e6669726564204578747261766167616e7420536d616c6c20426c61646520536861706564204d6f6c64 USING utf8mb4)),
(60925,CONVERT(0x556e6669726564204578747261766167616e74205370656172204865616420536861706564204d6f6c64 USING utf8mb4)),
(60926,CONVERT(0x556e6669726564204578747261766167616e74204d616365204865616420536861706564204d6f6c64 USING utf8mb4)),
(60927,CONVERT(0x556e6669726564204578747261766167616e742048616d6d6572204865616420536861706564204d6f6c64 USING utf8mb4)),
(60928,CONVERT(0x556e6669726564204578747261766167616e74204d6574616c205772617020536861706564204d6f6c64 USING utf8mb4)),
(60929,CONVERT(0x556e6669726564204578747261766167616e7420556c616b20426c61646520536861706564204d6f6c64 USING utf8mb4)),
(60930,CONVERT(0x556e6669726564204578747261766167616e74204c6172676520426c61646520536861706564204d6f6c64 USING utf8mb4)),
(60931,CONVERT(0x556e6669726564204578747261766167616e74204c6172676520417865204865616420536861706564204d6f6c64 USING utf8mb4)),
(123501,CONVERT(0x46616e7461737469632053696c6b USING utf8mb4));
 CREATE TEMPORARY TABLE rrc194_peer_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc194_peer_entries LIKE tradeskill_recipe_entries;
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 target database mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16901 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16902 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16908 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48893 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48894 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48895 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48897 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48898 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48899 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48900 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48901 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48902 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48903 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48904 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48905 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48906 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60795 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60796 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 15 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60797 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60798 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60799 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60800 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60801 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60802 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 15 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60803 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60804 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60805 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60806 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60807 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 3 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 5 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60808 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 3 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 5 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60918 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60919 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60920 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60921 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60922 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60923 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60924 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60925 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60926 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60927 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60928 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60929 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60930 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 3 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=60931 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 3 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=123501 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 86 AND `reclevel` <=> 90 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 native item semantics mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc194_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc194_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc194_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc194_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc194_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc194_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 output producer universe changed'; END IF;

 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc194_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc194_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 item identity/dependency mismatch'; END IF;
 IF already_present<>27 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc194_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc194_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc194_recipes q ON q.id=r.recipe_id LEFT JOIN rrc194_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc194_recipes q ON q.id=r.recipe_id)<>122 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc194_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc194_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc194_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-27 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-122 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 rollback count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc194_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc194_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc194_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc194_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc194_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc194_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC194 output producer universe changed'; END IF;
 DROP TEMPORARY TABLE rrc194_peer_entries;
 DROP TEMPORARY TABLE rrc194_peer_recipes;
 DROP TEMPORARY TABLE rrc194_entries;
 DROP TEMPORARY TABLE rrc194_recipes;
 DROP TEMPORARY TABLE rrc194_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC194' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
