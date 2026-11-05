-- RRC234: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc234_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc234_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc234_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc234_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3097136,CONVERT(0x5068696c746572206f66204d696e6f72205472616e736c6f636174696f6e USING utf8mb4),59,0,64,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f52204d69737420616e64205068696c74657220416c6368656d79207265636f6e737472756374696f6e3b205252433233342e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3097137,CONVERT(0x5068696c746572206f662074686520546869636b6574 USING utf8mb4),59,0,126,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f52204d69737420616e64205068696c74657220416c6368656d79207265636f6e737472756374696f6e3b205252433233342e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3097138,CONVERT(0x5068696c746572206f66207468652046726f7374706c61696e73 USING utf8mb4),59,0,126,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f52204d69737420616e64205068696c74657220416c6368656d79207265636f6e737472756374696f6e3b205252433233342e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3097139,CONVERT(0x5068696c746572206f6620746865205377616d70 USING utf8mb4),59,0,126,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f52204d69737420616e64205068696c74657220416c6368656d79207265636f6e737472756374696f6e3b205252433233342e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3097140,CONVERT(0x5068696c746572206f662074686520426f6e656669656c64 USING utf8mb4),59,0,126,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f52204d69737420616e64205068696c74657220416c6368656d79207265636f6e737472756374696f6e3b205252433233342e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3097141,CONVERT(0x5068696c746572206f6620746865205477696c69676874 USING utf8mb4),59,0,126,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f52204d69737420616e64205068696c74657220416c6368656d79207265636f6e737472756374696f6e3b205252433233342e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3097142,CONVERT(0x4d697374206f662074686520576f6c662049 USING utf8mb4),59,0,250,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f52204d69737420616e64205068696c74657220416c6368656d79207265636f6e737472756374696f6e3b205252433233342e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3097143,CONVERT(0x4d697374206f662074686520576f6c66204949 USING utf8mb4),59,0,290,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f52204d69737420616e64205068696c74657220416c6368656d79207265636f6e737472756374696f6e3b205252433233342e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3097144,CONVERT(0x5068696c746572206f662074686520416e74 USING utf8mb4),59,0,122,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f52204d69737420616e64205068696c74657220416c6368656d79207265636f6e737472756374696f6e3b205252433233342e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3097145,CONVERT(0x4d697374206f662074686520416e74 USING utf8mb4),59,0,224,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f52204d69737420616e64205068696c74657220416c6368656d79207265636f6e737472756374696f6e3b205252433233342e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3097146,CONVERT(0x5068696c746572206f66207468652053657270656e74 USING utf8mb4),59,0,45,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f52204d69737420616e64205068696c74657220416c6368656d79207265636f6e737472756374696f6e3b205252433233342e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3097147,CONVERT(0x5068696c746572206f6620436c656172205369676874 USING utf8mb4),59,0,70,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f52204d69737420616e64205068696c74657220416c6368656d79207265636f6e737472756374696f6e3b205252433233342e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3097148,CONVERT(0x5068696c746572206f6620466c656574696e67204c616e67756f72 USING utf8mb4),59,0,95,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f52204d69737420616e64205068696c74657220416c6368656d79207265636f6e737472756374696f6e3b205252433233342e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3097149,CONVERT(0x5068696c746572206f662046616572756e65 USING utf8mb4),59,0,164,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f52204d69737420616e64205068696c74657220416c6368656d79207265636f6e737472756374696f6e3b205252433233342e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3097150,CONVERT(0x5068696c746572206f66204d696e6f72204e65676174696f6e USING utf8mb4),59,0,50,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f52204d69737420616e64205068696c74657220416c6368656d79207265636f6e737472756374696f6e3b205252433233342e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3097151,CONVERT(0x5068696c746572206f66204d616a6f72204e65676174696f6e USING utf8mb4),59,0,170,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f52204d69737420616e64205068696c74657220416c6368656d79207265636f6e737472756374696f6e3b205252433233342e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3097152,CONVERT(0x5068696c746572206f6620577261636b62616e65 USING utf8mb4),59,0,260,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f52204d69737420616e64205068696c74657220416c6368656d79207265636f6e737472756374696f6e3b205252433233342e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3097153,CONVERT(0x5068696c746572206f662056616d706972696320537069726974 USING utf8mb4),59,0,260,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f52204d69737420616e64205068696c74657220416c6368656d79207265636f6e737472756374696f6e3b205252433233342e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3097154,CONVERT(0x5068696c746572206f6620746865204861776b277320457965 USING utf8mb4),59,0,330,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f52204d69737420616e64205068696c74657220416c6368656d79207265636f6e737472756374696f6e3b205252433233342e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3097155,CONVERT(0x5068696c746572206f662074686520546974616e USING utf8mb4),59,0,152,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f52204d69737420616e64205068696c74657220416c6368656d79207265636f6e737472756374696f6e3b205252433233342e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3097156,CONVERT(0x5068696c746572206f6620556e6c6966652041776172656e657373 USING utf8mb4),59,0,152,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f52204d69737420616e64205068696c74657220416c6368656d79207265636f6e737472756374696f6e3b205252433233342e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3097157,CONVERT(0x4d697374206f6620746865205765696768746c657373 USING utf8mb4),59,0,224,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f52204d69737420616e64205068696c74657220416c6368656d79207265636f6e737472756374696f6e3b205252433233342e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3097158,CONVERT(0x5068696c746572206f662047756c6f6e277320496d70756e697479 USING utf8mb4),59,0,91,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f52204d69737420616e64205068696c74657220416c6368656d79207265636f6e737472756374696f6e3b205252433233342e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3097159,CONVERT(0x5068696c746572206f662041717561746963204861756e74 USING utf8mb4),59,0,152,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920506f52204d69737420616e64205068696c74657220416c6368656d79207265636f6e737472756374696f6e3b205252433233342e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL);
INSERT INTO rrc234_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3097136,45216,0,0,1,1,0),
(3097136,51421,0,0,1,1,0),
(3097136,95841,0,0,1,1,0),
(3097136,95921,0,0,3,3,0),
(3097136,96466,1,0,0,0,0),
(3097136,17901,0,0,0,0,1),
(3097137,14242,0,0,1,1,0),
(3097137,16510,0,0,1,1,0),
(3097137,22143,0,0,1,1,0),
(3097137,95843,0,0,1,1,0),
(3097137,95875,0,0,4,4,0),
(3097137,96468,1,0,0,0,0),
(3097137,17901,0,0,0,0,1),
(3097138,14242,0,0,1,1,0),
(3097138,16510,0,0,1,1,0),
(3097138,22143,0,0,1,1,0),
(3097138,95843,0,0,1,1,0),
(3097138,95874,0,0,4,4,0),
(3097138,96469,1,0,0,0,0),
(3097138,17901,0,0,0,0,1),
(3097139,14242,0,0,1,1,0),
(3097139,16510,0,0,1,1,0),
(3097139,22143,0,0,1,1,0),
(3097139,95843,0,0,1,1,0),
(3097139,95883,0,0,4,4,0),
(3097139,96470,1,0,0,0,0),
(3097139,17901,0,0,0,0,1),
(3097140,14242,0,0,1,1,0),
(3097140,16510,0,0,1,1,0),
(3097140,22143,0,0,1,1,0),
(3097140,95843,0,0,1,1,0),
(3097140,95882,0,0,4,4,0),
(3097140,96471,1,0,0,0,0),
(3097140,17901,0,0,0,0,1),
(3097141,14242,0,0,1,1,0),
(3097141,16510,0,0,1,1,0),
(3097141,22143,0,0,1,1,0),
(3097141,95843,0,0,1,1,0),
(3097141,95881,0,0,4,4,0),
(3097141,96472,1,0,0,0,0),
(3097141,17901,0,0,0,0,1),
(3097142,14216,0,0,1,1,0),
(3097142,14217,0,0,1,1,0),
(3097142,14230,0,0,1,1,0),
(3097142,95846,0,0,1,1,0),
(3097142,95989,0,0,2,2,0),
(3097142,96478,1,0,0,0,0),
(3097142,96911,0,0,1,1,0),
(3097142,17901,0,0,0,0,1),
(3097143,14216,0,0,1,1,0),
(3097143,14217,0,0,1,1,0),
(3097143,16527,0,0,1,1,0),
(3097143,95847,0,0,1,1,0),
(3097143,95989,0,0,2,2,0),
(3097143,96479,1,0,0,0,0),
(3097143,96915,0,0,1,1,0),
(3097143,17901,0,0,0,0,1),
(3097144,22142,0,0,1,1,0),
(3097144,95843,0,0,1,1,0),
(3097144,95997,0,0,2,2,0),
(3097144,96021,0,0,2,2,0),
(3097144,96480,1,0,0,0,0),
(3097144,17901,0,0,0,0,1),
(3097145,14230,0,0,1,1,0),
(3097145,16520,0,0,2,2,0),
(3097145,16525,0,0,2,2,0),
(3097145,95846,0,0,1,1,0),
(3097145,96481,1,0,0,0,0),
(3097145,96911,0,0,1,1,0),
(3097145,17901,0,0,0,0,1),
(3097146,16515,0,0,1,1,0),
(3097146,95840,0,0,1,1,0),
(3097146,95853,0,0,2,2,0),
(3097146,95984,0,0,2,2,0),
(3097146,96482,1,0,0,0,0),
(3097146,17901,0,0,0,0,1),
(3097147,22141,0,0,1,1,0),
(3097147,95841,0,0,1,1,0),
(3097147,95853,0,0,2,2,0),
(3097147,95981,0,0,2,2,0),
(3097147,96483,1,0,0,0,0),
(3097147,17901,0,0,0,0,1),
(3097148,14229,0,0,1,1,0),
(3097148,95842,0,0,1,1,0),
(3097148,95864,0,0,2,2,0),
(3097148,95865,0,0,2,2,0),
(3097148,96484,1,0,0,0,0),
(3097148,17901,0,0,0,0,1),
(3097149,16516,0,0,2,2,0),
(3097149,16518,0,0,1,1,0),
(3097149,16524,0,0,1,1,0),
(3097149,16526,0,0,1,1,0),
(3097149,95844,0,0,1,1,0),
(3097149,96485,1,0,0,0,0),
(3097149,17901,0,0,0,0,1),
(3097150,16515,0,0,1,1,0),
(3097150,95840,0,0,1,1,0),
(3097150,95857,0,0,2,2,0),
(3097150,95990,0,0,2,2,0),
(3097150,96486,1,0,0,0,0),
(3097150,17901,0,0,0,0,1),
(3097151,14219,0,0,2,2,0),
(3097151,16524,0,0,1,1,0),
(3097151,51411,0,0,2,2,0),
(3097151,95844,0,0,1,1,0),
(3097151,96487,1,0,0,0,0),
(3097151,17901,0,0,0,0,1),
(3097152,16526,0,0,2,2,0),
(3097152,16527,0,0,1,1,0),
(3097152,51411,0,0,2,2,0),
(3097152,95847,0,0,1,1,0),
(3097152,96915,0,0,1,1,0),
(3097152,96929,1,0,0,0,0),
(3097152,17901,0,0,0,0,1),
(3097153,16525,0,0,2,2,0),
(3097153,16527,0,0,1,1,0),
(3097153,51411,0,0,2,2,0),
(3097153,95847,0,0,1,1,0),
(3097153,96915,0,0,1,1,0),
(3097153,96930,1,0,0,0,0),
(3097153,17901,0,0,0,0,1),
(3097154,22143,0,0,1,1,0),
(3097154,95848,0,0,1,1,0),
(3097154,96001,0,0,2,2,0),
(3097154,96004,0,0,2,2,0),
(3097154,96916,0,0,1,1,0),
(3097154,96931,1,0,0,0,0),
(3097154,17901,0,0,0,0,1),
(3097155,16524,0,0,1,1,0),
(3097155,22138,0,0,2,2,0),
(3097155,51404,0,0,2,2,0),
(3097155,95844,0,0,1,1,0),
(3097155,96932,1,0,0,0,0),
(3097155,17901,0,0,0,0,1),
(3097156,16518,0,0,2,2,0),
(3097156,16522,0,0,2,2,0),
(3097156,16524,0,0,1,1,0),
(3097156,95844,0,0,1,1,0),
(3097156,96934,1,0,0,0,0),
(3097156,17901,0,0,0,0,1),
(3097157,14216,0,0,2,2,0),
(3097157,14228,0,0,1,1,0),
(3097157,14230,0,0,1,1,0),
(3097157,14232,0,0,1,1,0),
(3097157,95846,0,0,1,1,0),
(3097157,96911,0,0,1,1,0),
(3097157,96935,1,0,0,0,0),
(3097157,17901,0,0,0,0,1),
(3097158,14229,0,0,1,1,0),
(3097158,95842,0,0,1,1,0),
(3097158,95863,0,0,2,2,0),
(3097158,96012,0,0,2,2,0),
(3097158,96936,1,0,0,0,0),
(3097158,17901,0,0,0,0,1),
(3097159,14215,0,0,1,1,0),
(3097159,16524,0,0,1,1,0),
(3097159,16526,0,0,3,3,0),
(3097159,95844,0,0,1,1,0),
(3097159,96938,1,0,0,0,0),
(3097159,17901,0,0,0,0,1);
INSERT INTO rrc234_items (`id`,`name`) VALUES
(14215,CONVERT(0x53616765204c656166 USING utf8mb4)),
(14216,CONVERT(0x4269727468776f7274 USING utf8mb4)),
(14217,CONVERT(0x46656e75677265656b USING utf8mb4)),
(14219,CONVERT(0x4d616e6472616b6520526f6f74 USING utf8mb4)),
(14228,CONVERT(0x436f6d66726579 USING utf8mb4)),
(14229,CONVERT(0x426c7565205665727661696e2042756c62 USING utf8mb4)),
(14230,CONVERT(0x56616c657269616e20526f6f74 USING utf8mb4)),
(14232,CONVERT(0x466967776f7274 USING utf8mb4)),
(14242,CONVERT(0x48656c696f74726f7065 USING utf8mb4)),
(16510,CONVERT(0x596562616d616e7465 USING utf8mb4)),
(16515,CONVERT(0x566f7827732044757374 USING utf8mb4)),
(16516,CONVERT(0x457965627269676874 USING utf8mb4)),
(16518,CONVERT(0x427572646f636b20526f6f74 USING utf8mb4)),
(16520,CONVERT(0x44616d69616e61 USING utf8mb4)),
(16522,CONVERT(0x486f7265686f756e64 USING utf8mb4)),
(16524,CONVERT(0x42756762616e65 USING utf8mb4)),
(16525,CONVERT(0x4665766572666577 USING utf8mb4)),
(16526,CONVERT(0x576f756e6477617274 USING utf8mb4)),
(16527,CONVERT(0x42616c6d204c6561766573 USING utf8mb4)),
(17901,CONVERT(0x4d65646963696e6520426167 USING utf8mb4)),
(22138,CONVERT(0x5472692d4665726e204c656166 USING utf8mb4)),
(22141,CONVERT(0x56696f6c6574205472692d5475626520536170 USING utf8mb4)),
(22142,CONVERT(0x42657468657269756d204261726b USING utf8mb4)),
(22143,CONVERT(0x426c616465204c656166 USING utf8mb4)),
(45216,CONVERT(0x53746f726d20436c6f7564 USING utf8mb4)),
(51404,CONVERT(0x437572756c6f7468 USING utf8mb4)),
(51411,CONVERT(0x48656d6c6f636b20506f77646572 USING utf8mb4)),
(51421,CONVERT(0x56696e756b USING utf8mb4)),
(95840,CONVERT(0x437275646520506f74696f6e205669616c USING utf8mb4)),
(95841,CONVERT(0x526f75676820506f74696f6e205669616c USING utf8mb4)),
(95842,CONVERT(0x4d616b65736869667420506f74696f6e205669616c USING utf8mb4)),
(95843,CONVERT(0x53696d706c6520506f74696f6e205669616c USING utf8mb4)),
(95844,CONVERT(0x506c61696e20506f74696f6e205669616c USING utf8mb4)),
(95846,CONVERT(0x46696e6520506f74696f6e205669616c USING utf8mb4)),
(95847,CONVERT(0x47656d6d656420506f74696f6e205669616c USING utf8mb4)),
(95848,CONVERT(0x52756e656420506f74696f6e205669616c USING utf8mb4)),
(95853,CONVERT(0x457965627269676874204c656166 USING utf8mb4)),
(95857,CONVERT(0x50696e6368206f66204d616e6472616b6520526f6f74 USING utf8mb4)),
(95863,CONVERT(0x5370726967206f66204269727468776f7274 USING utf8mb4)),
(95864,CONVERT(0x53656374696f6e206f6620427572646f636b20526f6f74 USING utf8mb4)),
(95865,CONVERT(0x5370726967206f6620457965627269676874 USING utf8mb4)),
(95874,CONVERT(0x48616e6466756c206f662042656e7a6f696e USING utf8mb4)),
(95875,CONVERT(0x42756e646c65206f66204269727468776f7274 USING utf8mb4)),
(95881,CONVERT(0x42756e646c65206f66204d616e6472616b6520526f6f7473 USING utf8mb4)),
(95882,CONVERT(0x42756e646c65206f66204d756c6c65696e USING utf8mb4)),
(95883,CONVERT(0x42756e646c65206f66204e69676874205368616465 USING utf8mb4)),
(95921,CONVERT(0x4d656173757265206f6620507269736d20477261696e73 USING utf8mb4)),
(95981,CONVERT(0x43686970206f66204b6174756b61204261726b USING utf8mb4)),
(95984,CONVERT(0x477261696e206f662043656e74656e7469616c73706f7265 USING utf8mb4)),
(95989,CONVERT(0x4d656173757265206f6620576f6c6620426c6f6f64 USING utf8mb4)),
(95990,CONVERT(0x477261696e206f662048656d6c6f636b20506f77646572 USING utf8mb4)),
(95997,CONVERT(0x5370726967206f66204665766572666577 USING utf8mb4)),
(96001,CONVERT(0x42756e646c65206f66205472692d4665726e204c6561766573 USING utf8mb4)),
(96004,CONVERT(0x42756e646c65206f66205374617220526561636820436c6f766572 USING utf8mb4)),
(96012,CONVERT(0x50696e6368206f662047726f756e6420466967776f7274 USING utf8mb4)),
(96021,CONVERT(0x5370726967206f662044616d69616e61 USING utf8mb4)),
(96466,CONVERT(0x5068696c746572206f66204d696e6f72205472616e736c6f636174696f6e USING utf8mb4)),
(96468,CONVERT(0x5068696c746572206f662074686520546869636b6574 USING utf8mb4)),
(96469,CONVERT(0x5068696c746572206f66207468652046726f7374706c61696e73 USING utf8mb4)),
(96470,CONVERT(0x5068696c746572206f6620746865205377616d70 USING utf8mb4)),
(96471,CONVERT(0x5068696c746572206f662074686520426f6e656669656c64 USING utf8mb4)),
(96472,CONVERT(0x5068696c746572206f6620746865205477696c69676874 USING utf8mb4)),
(96478,CONVERT(0x4d697374206f662074686520576f6c662049 USING utf8mb4)),
(96479,CONVERT(0x4d697374206f662074686520576f6c66204949 USING utf8mb4)),
(96480,CONVERT(0x5068696c746572206f662074686520416e74 USING utf8mb4)),
(96481,CONVERT(0x4d697374206f662074686520416e74 USING utf8mb4)),
(96482,CONVERT(0x5068696c746572206f66207468652053657270656e74 USING utf8mb4)),
(96483,CONVERT(0x5068696c746572206f6620436c656172205369676874 USING utf8mb4)),
(96484,CONVERT(0x5068696c746572206f6620466c656574696e67204c616e67756f72 USING utf8mb4)),
(96485,CONVERT(0x5068696c746572206f662046616572756e65 USING utf8mb4)),
(96486,CONVERT(0x5068696c746572206f66204d696e6f72204e65676174696f6e USING utf8mb4)),
(96487,CONVERT(0x5068696c746572206f66204d616a6f72204e65676174696f6e USING utf8mb4)),
(96911,CONVERT(0x526f6275737420536861646f7720457373656e6365 USING utf8mb4)),
(96915,CONVERT(0x457863657074696f6e616c205368697373617220426c6f6f64 USING utf8mb4)),
(96916,CONVERT(0x506f77646572206f6620526f USING utf8mb4)),
(96929,CONVERT(0x5068696c746572206f6620577261636b62616e65 USING utf8mb4)),
(96930,CONVERT(0x5068696c746572206f662056616d706972696320537069726974 USING utf8mb4)),
(96931,CONVERT(0x5068696c746572206f6620746865204861776b277320457965 USING utf8mb4)),
(96932,CONVERT(0x5068696c746572206f662074686520546974616e USING utf8mb4)),
(96934,CONVERT(0x5068696c746572206f6620556e6c6966652041776172656e657373 USING utf8mb4)),
(96935,CONVERT(0x4d697374206f6620746865205765696768746c657373 USING utf8mb4)),
(96936,CONVERT(0x5068696c746572206f662047756c6f6e277320496d70756e697479 USING utf8mb4)),
(96938,CONVERT(0x5068696c746572206f662041717561746963204861756e74 USING utf8mb4));
 CREATE TEMPORARY TABLE rrc234_peer_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc234_peer_entries LIKE tradeskill_recipe_entries;
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 target database mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=14215 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=14216 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=14217 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=14219 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=14228 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=14229 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=14230 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=14232 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=14242 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16510 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16515 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16516 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16518 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16520 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16522 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16524 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16525 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16526 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16527 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17901 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 9 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `classes` <=> 512 AND `races` <=> 131071 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=22138 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=22141 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=22142 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=22143 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45216 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=51404 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=51411 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=51421 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95840 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95841 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95842 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95843 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95844 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95846 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95847 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95848 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95853 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95857 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95863 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95864 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95865 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95874 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95875 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95881 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95882 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95883 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95921 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95981 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95984 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95989 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95990 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95997 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96001 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96004 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96012 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96021 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96466 AND `itemclass` <=> 0 AND `itemtype` <=> 21 AND `size` <=> 1 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96468 AND `itemclass` <=> 0 AND `itemtype` <=> 21 AND `size` <=> 1 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96469 AND `itemclass` <=> 0 AND `itemtype` <=> 21 AND `size` <=> 1 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96470 AND `itemclass` <=> 0 AND `itemtype` <=> 21 AND `size` <=> 1 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96471 AND `itemclass` <=> 0 AND `itemtype` <=> 21 AND `size` <=> 1 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96472 AND `itemclass` <=> 0 AND `itemtype` <=> 21 AND `size` <=> 1 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96478 AND `itemclass` <=> 0 AND `itemtype` <=> 21 AND `size` <=> 1 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96479 AND `itemclass` <=> 0 AND `itemtype` <=> 21 AND `size` <=> 1 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96480 AND `itemclass` <=> 0 AND `itemtype` <=> 21 AND `size` <=> 1 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96481 AND `itemclass` <=> 0 AND `itemtype` <=> 21 AND `size` <=> 1 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96482 AND `itemclass` <=> 0 AND `itemtype` <=> 21 AND `size` <=> 1 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96483 AND `itemclass` <=> 0 AND `itemtype` <=> 21 AND `size` <=> 1 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96484 AND `itemclass` <=> 0 AND `itemtype` <=> 21 AND `size` <=> 1 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96485 AND `itemclass` <=> 0 AND `itemtype` <=> 21 AND `size` <=> 1 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96486 AND `itemclass` <=> 0 AND `itemtype` <=> 21 AND `size` <=> 1 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96487 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96911 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96915 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96916 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96929 AND `itemclass` <=> 0 AND `itemtype` <=> 21 AND `size` <=> 1 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96930 AND `itemclass` <=> 0 AND `itemtype` <=> 21 AND `size` <=> 1 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96931 AND `itemclass` <=> 0 AND `itemtype` <=> 21 AND `size` <=> 1 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96932 AND `itemclass` <=> 0 AND `itemtype` <=> 21 AND `size` <=> 1 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96934 AND `itemclass` <=> 0 AND `itemtype` <=> 21 AND `size` <=> 1 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96935 AND `itemclass` <=> 0 AND `itemtype` <=> 21 AND `size` <=> 1 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96936 AND `itemclass` <=> 0 AND `itemtype` <=> 21 AND `size` <=> 1 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96938 AND `itemclass` <=> 0 AND `itemtype` <=> 21 AND `size` <=> 1 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 native item semantics mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc234_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc234_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc234_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc234_entries e ON r.item_id=e.item_id AND e.successcount>0 AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc234_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc234_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 output producer universe changed'; END IF;

 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc234_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc234_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 item identity/dependency mismatch'; END IF;
 IF already_present<>24 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc234_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc234_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc234_recipes q ON q.id=r.recipe_id LEFT JOIN rrc234_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc234_recipes q ON q.id=r.recipe_id)<>160 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc234_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc234_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc234_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-24 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-160 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 rollback count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc234_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc234_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc234_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc234_entries e ON r.item_id=e.item_id AND e.successcount>0 AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc234_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc234_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC234 output producer universe changed'; END IF;
 DROP TEMPORARY TABLE rrc234_peer_entries;
 DROP TEMPORARY TABLE rrc234_peer_recipes;
 DROP TEMPORARY TABLE rrc234_entries;
 DROP TEMPORARY TABLE rrc234_recipes;
 DROP TEMPORARY TABLE rrc234_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC234' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
