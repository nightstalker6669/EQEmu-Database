-- RRC225: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc225_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc225_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc225_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc225_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3096901,CONVERT(0x42617369632053757370656e73696f6e206f6620536c696d652056494949 USING utf8mb4),59,0,271,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220426173696320616e6420466f726d656420416c6368656d792053757370656e73696f6e7320564949492d4958207265636f6e737472756374696f6e3b205252433232352e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096902,CONVERT(0x42617369632053757370656e73696f6e206f6620536c696d65204958 USING utf8mb4),59,0,314,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220426173696320616e6420466f726d656420416c6368656d792053757370656e73696f6e7320564949492d4958207265636f6e737472756374696f6e3b205252433232352e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096903,CONVERT(0x42617369632053757370656e73696f6e206f662050657374696c656e63652056494949 USING utf8mb4),59,0,264,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220426173696320616e6420466f726d656420416c6368656d792053757370656e73696f6e7320564949492d4958207265636f6e737472756374696f6e3b205252433232352e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096904,CONVERT(0x42617369632053757370656e73696f6e206f662050657374696c656e6365204958 USING utf8mb4),59,0,307,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220426173696320616e6420466f726d656420416c6368656d792053757370656e73696f6e7320564949492d4958207265636f6e737472756374696f6e3b205252433232352e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096905,CONVERT(0x42617369632053757370656e73696f6e206f6620466c616d652056494949 USING utf8mb4),59,0,252,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220426173696320616e6420466f726d656420416c6368656d792053757370656e73696f6e7320564949492d4958207265636f6e737472756374696f6e3b205252433232352e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096906,CONVERT(0x42617369632053757370656e73696f6e206f6620466c616d65204958 USING utf8mb4),59,0,292,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220426173696320616e6420466f726d656420416c6368656d792053757370656e73696f6e7320564949492d4958207265636f6e737472756374696f6e3b205252433232352e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096907,CONVERT(0x42617369632053757370656e73696f6e206f662046726f73742056494949 USING utf8mb4),59,0,252,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220426173696320616e6420466f726d656420416c6368656d792053757370656e73696f6e7320564949492d4958207265636f6e737472756374696f6e3b205252433232352e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096908,CONVERT(0x42617369632053757370656e73696f6e206f662046726f7374204958 USING utf8mb4),59,0,292,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220426173696320616e6420466f726d656420416c6368656d792053757370656e73696f6e7320564949492d4958207265636f6e737472756374696f6e3b205252433232352e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096909,CONVERT(0x42617369632053757370656e73696f6e206f6620546f78696e2056494949 USING utf8mb4),59,0,258,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220426173696320616e6420466f726d656420416c6368656d792053757370656e73696f6e7320564949492d4958207265636f6e737472756374696f6e3b205252433232352e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096910,CONVERT(0x42617369632053757370656e73696f6e206f6620546f78696e204958 USING utf8mb4),59,0,299,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220426173696320616e6420466f726d656420416c6368656d792053757370656e73696f6e7320564949492d4958207265636f6e737472756374696f6e3b205252433232352e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096911,CONVERT(0x466f726d65642053757370656e73696f6e206f6620536c696d652056494949 USING utf8mb4),59,0,274,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220426173696320616e6420466f726d656420416c6368656d792053757370656e73696f6e7320564949492d4958207265636f6e737472756374696f6e3b205252433232352e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096912,CONVERT(0x466f726d65642053757370656e73696f6e206f6620536c696d65204958 USING utf8mb4),59,0,316,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220426173696320616e6420466f726d656420416c6368656d792053757370656e73696f6e7320564949492d4958207265636f6e737472756374696f6e3b205252433232352e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096913,CONVERT(0x466f726d65642053757370656e73696f6e206f662050657374696c656e63652056494949 USING utf8mb4),59,0,268,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220426173696320616e6420466f726d656420416c6368656d792053757370656e73696f6e7320564949492d4958207265636f6e737472756374696f6e3b205252433232352e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096914,CONVERT(0x466f726d65642053757370656e73696f6e206f662050657374696c656e6365204958 USING utf8mb4),59,0,310,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220426173696320616e6420466f726d656420416c6368656d792053757370656e73696f6e7320564949492d4958207265636f6e737472756374696f6e3b205252433232352e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096915,CONVERT(0x466f726d65642053757370656e73696f6e206f6620466c616d652056494949 USING utf8mb4),59,0,255,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220426173696320616e6420466f726d656420416c6368656d792053757370656e73696f6e7320564949492d4958207265636f6e737472756374696f6e3b205252433232352e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096916,CONVERT(0x466f726d65642053757370656e73696f6e206f6620466c616d65204958 USING utf8mb4),59,0,295,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220426173696320616e6420466f726d656420416c6368656d792053757370656e73696f6e7320564949492d4958207265636f6e737472756374696f6e3b205252433232352e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096917,CONVERT(0x466f726d65642053757370656e73696f6e206f662046726f73742056494949 USING utf8mb4),59,0,255,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220426173696320616e6420466f726d656420416c6368656d792053757370656e73696f6e7320564949492d4958207265636f6e737472756374696f6e3b205252433232352e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096918,CONVERT(0x466f726d65642053757370656e73696f6e206f6620546f78696e2056494949 USING utf8mb4),59,0,260,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220426173696320616e6420466f726d656420416c6368656d792053757370656e73696f6e7320564949492d4958207265636f6e737472756374696f6e3b205252433232352e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3096919,CONVERT(0x466f726d65642053757370656e73696f6e206f6620546f78696e204958 USING utf8mb4),59,0,302,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f5220426173696320616e6420466f726d656420416c6368656d792053757370656e73696f6e7320564949492d4958207265636f6e737472756374696f6e3b205252433232352e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL);
INSERT INTO rrc225_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3096901,16524,0,0,1,1,0),
(3096901,58074,0,0,1,1,0),
(3096901,95893,0,0,1,1,0),
(3096901,95901,0,0,2,2,0),
(3096901,95937,0,0,1,1,0),
(3096901,96150,1,0,0,0,0),
(3096901,96819,0,0,1,1,0),
(3096901,17901,0,0,0,0,1),
(3096902,16530,0,0,1,1,0),
(3096902,58073,0,0,1,1,0),
(3096902,95893,0,0,1,1,0),
(3096902,95901,0,0,2,2,0),
(3096902,95937,0,0,1,1,0),
(3096902,96151,1,0,0,0,0),
(3096902,96820,0,0,1,1,0),
(3096902,17901,0,0,0,0,1),
(3096903,16524,0,0,1,1,0),
(3096903,58074,0,0,1,1,0),
(3096903,95893,0,0,1,1,0),
(3096903,95897,0,0,2,2,0),
(3096903,95937,0,0,1,1,0),
(3096903,96160,1,0,0,0,0),
(3096903,96819,0,0,1,1,0),
(3096903,17901,0,0,0,0,1),
(3096904,16530,0,0,1,1,0),
(3096904,58073,0,0,1,1,0),
(3096904,95893,0,0,1,1,0),
(3096904,95897,0,0,2,2,0),
(3096904,95937,0,0,1,1,0),
(3096904,96161,1,0,0,0,0),
(3096904,96820,0,0,1,1,0),
(3096904,17901,0,0,0,0,1),
(3096905,16524,0,0,1,1,0),
(3096905,58074,0,0,1,1,0),
(3096905,95889,0,0,1,1,0),
(3096905,95913,0,0,2,2,0),
(3096905,95937,0,0,1,1,0),
(3096905,96170,1,0,0,0,0),
(3096905,96819,0,0,1,1,0),
(3096905,17901,0,0,0,0,1),
(3096906,16530,0,0,1,1,0),
(3096906,58073,0,0,1,1,0),
(3096906,95889,0,0,1,1,0),
(3096906,95913,0,0,2,2,0),
(3096906,95937,0,0,1,1,0),
(3096906,96171,1,0,0,0,0),
(3096906,96820,0,0,1,1,0),
(3096906,17901,0,0,0,0,1),
(3096907,16524,0,0,1,1,0),
(3096907,58074,0,0,1,1,0),
(3096907,95925,0,0,1,1,0),
(3096907,95933,0,0,2,2,0),
(3096907,95937,0,0,1,1,0),
(3096907,96180,1,0,0,0,0),
(3096907,96819,0,0,1,1,0),
(3096907,17901,0,0,0,0,1),
(3096908,16530,0,0,1,1,0),
(3096908,58073,0,0,1,1,0),
(3096908,95925,0,0,1,1,0),
(3096908,95933,0,0,2,2,0),
(3096908,95937,0,0,1,1,0),
(3096908,96181,1,0,0,0,0),
(3096908,96820,0,0,1,1,0),
(3096908,17901,0,0,0,0,1),
(3096909,16524,0,0,1,1,0),
(3096909,58074,0,0,1,1,0),
(3096909,95905,0,0,1,1,0),
(3096909,95909,0,0,1,1,0),
(3096909,95929,0,0,2,2,0),
(3096909,96190,1,0,0,0,0),
(3096909,96819,0,0,1,1,0),
(3096909,17901,0,0,0,0,1),
(3096910,16530,0,0,1,1,0),
(3096910,58073,0,0,1,1,0),
(3096910,95905,0,0,1,1,0),
(3096910,95909,0,0,1,1,0),
(3096910,95929,0,0,2,2,0),
(3096910,96191,1,0,0,0,0),
(3096910,96820,0,0,1,1,0),
(3096910,17901,0,0,0,0,1),
(3096911,16524,0,0,1,1,0),
(3096911,58074,0,0,1,1,0),
(3096911,95893,0,0,1,1,0),
(3096911,95901,0,0,2,2,0),
(3096911,95937,0,0,1,1,0),
(3096911,96300,1,0,0,0,0),
(3096911,96849,0,0,1,1,0),
(3096911,17901,0,0,0,0,1),
(3096912,16530,0,0,1,1,0),
(3096912,58073,0,0,1,1,0),
(3096912,95893,0,0,1,1,0),
(3096912,95901,0,0,2,2,0),
(3096912,95937,0,0,1,1,0),
(3096912,96301,1,0,0,0,0),
(3096912,96850,0,0,1,1,0),
(3096912,17901,0,0,0,0,1),
(3096913,16524,0,0,1,1,0),
(3096913,58074,0,0,1,1,0),
(3096913,95893,0,0,1,1,0),
(3096913,95897,0,0,2,2,0),
(3096913,95937,0,0,1,1,0),
(3096913,96310,1,0,0,0,0),
(3096913,96849,0,0,1,1,0),
(3096913,17901,0,0,0,0,1),
(3096914,16530,0,0,1,1,0),
(3096914,58073,0,0,1,1,0),
(3096914,95893,0,0,1,1,0),
(3096914,95897,0,0,2,2,0),
(3096914,95937,0,0,1,1,0),
(3096914,96311,1,0,0,0,0),
(3096914,96850,0,0,1,1,0),
(3096914,17901,0,0,0,0,1),
(3096915,16524,0,0,1,1,0),
(3096915,58074,0,0,1,1,0),
(3096915,95889,0,0,1,1,0),
(3096915,95913,0,0,2,2,0),
(3096915,95937,0,0,1,1,0),
(3096915,96320,1,0,0,0,0),
(3096915,96849,0,0,1,1,0),
(3096915,17901,0,0,0,0,1),
(3096916,16530,0,0,1,1,0),
(3096916,58073,0,0,1,1,0),
(3096916,95889,0,0,1,1,0),
(3096916,95913,0,0,2,2,0),
(3096916,95937,0,0,1,1,0),
(3096916,96321,1,0,0,0,0),
(3096916,96850,0,0,1,1,0),
(3096916,17901,0,0,0,0,1),
(3096917,16524,0,0,1,1,0),
(3096917,58074,0,0,1,1,0),
(3096917,95925,0,0,1,1,0),
(3096917,95933,0,0,2,2,0),
(3096917,95937,0,0,1,1,0),
(3096917,96330,1,0,0,0,0),
(3096917,96849,0,0,1,1,0),
(3096917,17901,0,0,0,0,1),
(3096918,16524,0,0,1,1,0),
(3096918,58074,0,0,1,1,0),
(3096918,95905,0,0,1,1,0),
(3096918,95909,0,0,1,1,0),
(3096918,95929,0,0,2,2,0),
(3096918,96340,1,0,0,0,0),
(3096918,96849,0,0,1,1,0),
(3096918,17901,0,0,0,0,1),
(3096919,16530,0,0,1,1,0),
(3096919,58073,0,0,1,1,0),
(3096919,95905,0,0,1,1,0),
(3096919,95909,0,0,1,1,0),
(3096919,95929,0,0,2,2,0),
(3096919,96341,1,0,0,0,0),
(3096919,96850,0,0,1,1,0),
(3096919,17901,0,0,0,0,1);
INSERT INTO rrc225_items (`id`,`name`) VALUES
(16524,CONVERT(0x42756762616e65 USING utf8mb4)),
(16530,CONVERT(0x447261676f6e77617274 USING utf8mb4)),
(17901,CONVERT(0x4d65646963696e6520426167 USING utf8mb4)),
(58073,CONVERT(0x53616d706c65206f662046696c746572656420486967686c616e6420536c75646765 USING utf8mb4)),
(58074,CONVERT(0x53616d706c65206f662046696c7465726564205461656c6f7369616e20536c75646765 USING utf8mb4)),
(95889,CONVERT(0x5370726967206f6620416361616e61 USING utf8mb4)),
(95893,CONVERT(0x5370726967206f6620416e6775727468 USING utf8mb4)),
(95897,CONVERT(0x5370726967206f66204172726f77656564 USING utf8mb4)),
(95901,CONVERT(0x42756e646c65206f6620426974746572776f6f64205477696773 USING utf8mb4)),
(95905,CONVERT(0x42756c62204c6f74757320506574616c USING utf8mb4)),
(95909,CONVERT(0x5370726967206f6620466972652053706f7265 USING utf8mb4)),
(95913,CONVERT(0x5370726967206f6620466c616d65776f7274 USING utf8mb4)),
(95925,CONVERT(0x5370726967206f662053656174686f726e USING utf8mb4)),
(95929,CONVERT(0x5368617264206f66205374696e67696e67204372797374616c USING utf8mb4)),
(95933,CONVERT(0x5370726967206f6620537572616e6965 USING utf8mb4)),
(95937,CONVERT(0x5370726967206f662059656c6c6f7720526865756d USING utf8mb4)),
(96150,CONVERT(0x42617369632053757370656e73696f6e206f6620536c696d652056494949 USING utf8mb4)),
(96151,CONVERT(0x42617369632053757370656e73696f6e206f6620536c696d65204958 USING utf8mb4)),
(96160,CONVERT(0x42617369632053757370656e73696f6e206f662050657374696c656e63652056494949 USING utf8mb4)),
(96161,CONVERT(0x42617369632053757370656e73696f6e206f662050657374696c656e6365204958 USING utf8mb4)),
(96170,CONVERT(0x42617369632053757370656e73696f6e206f6620466c616d652056494949 USING utf8mb4)),
(96171,CONVERT(0x42617369632053757370656e73696f6e206f6620466c616d65204958 USING utf8mb4)),
(96180,CONVERT(0x42617369632053757370656e73696f6e206f662046726f73742056494949 USING utf8mb4)),
(96181,CONVERT(0x42617369632053757370656e73696f6e206f662046726f7374204958 USING utf8mb4)),
(96190,CONVERT(0x42617369632053757370656e73696f6e206f6620546f78696e2056494949 USING utf8mb4)),
(96191,CONVERT(0x42617369632053757370656e73696f6e206f6620546f78696e204958 USING utf8mb4)),
(96300,CONVERT(0x466f726d65642053757370656e73696f6e206f6620536c696d652056494949 USING utf8mb4)),
(96301,CONVERT(0x466f726d65642053757370656e73696f6e206f6620536c696d65204958 USING utf8mb4)),
(96310,CONVERT(0x466f726d65642053757370656e73696f6e206f662050657374696c656e63652056494949 USING utf8mb4)),
(96311,CONVERT(0x466f726d65642053757370656e73696f6e206f662050657374696c656e6365204958 USING utf8mb4)),
(96320,CONVERT(0x466f726d65642053757370656e73696f6e206f6620466c616d652056494949 USING utf8mb4)),
(96321,CONVERT(0x466f726d65642053757370656e73696f6e206f6620466c616d65204958 USING utf8mb4)),
(96330,CONVERT(0x466f726d65642053757370656e73696f6e206f662046726f73742056494949 USING utf8mb4)),
(96340,CONVERT(0x466f726d65642053757370656e73696f6e206f6620546f78696e2056494949 USING utf8mb4)),
(96341,CONVERT(0x466f726d65642053757370656e73696f6e206f6620546f78696e204958 USING utf8mb4)),
(96819,CONVERT(0x46696e652046726961626c6520506f74696f6e205669616c USING utf8mb4)),
(96820,CONVERT(0x47656d6d65642046726961626c6520506f74696f6e205669616c USING utf8mb4)),
(96849,CONVERT(0x46696e6520466f726d656420506f74696f6e205669616c USING utf8mb4)),
(96850,CONVERT(0x47656d6d656420466f726d656420506f74696f6e205669616c USING utf8mb4));
 CREATE TEMPORARY TABLE rrc225_peer_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc225_peer_entries LIKE tradeskill_recipe_entries;
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 target database mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16524 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16530 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17901 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 9 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `classes` <=> 512 AND `races` <=> 131071 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=58073 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=58074 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95889 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95893 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95897 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95901 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95905 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95909 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95913 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95925 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95929 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95933 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95937 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96150 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 45 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96151 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 55 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96160 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 45 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96161 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 55 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96170 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 45 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96171 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 55 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96180 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 45 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96181 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 55 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96190 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 45 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96191 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 55 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96300 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 45 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96301 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 55 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96310 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 45 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96311 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 55 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96320 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 45 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96321 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 55 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96330 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 45 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96340 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 45 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96341 AND `itemclass` <=> 0 AND `itemtype` <=> 19 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 55 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96819 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96820 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96849 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96850 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 native item semantics mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc225_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc225_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc225_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc225_entries e ON r.item_id=e.item_id AND e.successcount>0 AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc225_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc225_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 output producer universe changed'; END IF;

 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc225_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc225_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 item identity/dependency mismatch'; END IF;
 IF already_present<>19 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc225_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc225_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc225_recipes q ON q.id=r.recipe_id LEFT JOIN rrc225_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc225_recipes q ON q.id=r.recipe_id)<>152 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc225_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc225_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc225_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-19 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-152 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 rollback count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc225_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc225_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc225_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc225_entries e ON r.item_id=e.item_id AND e.successcount>0 AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc225_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc225_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC225 output producer universe changed'; END IF;
 DROP TEMPORARY TABLE rrc225_peer_entries;
 DROP TEMPORARY TABLE rrc225_peer_recipes;
 DROP TEMPORARY TABLE rrc225_entries;
 DROP TEMPORARY TABLE rrc225_recipes;
 DROP TEMPORARY TABLE rrc225_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC225' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
