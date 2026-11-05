-- RRC181: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc181_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc181_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc181_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc181_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3096190,CONVERT(0x456c61626f7261746520536d616c6c2048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138312e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096191,CONVERT(0x456c61626f726174652048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138312e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096192,CONVERT(0x456c61626f72617465204c617267652048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138312e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096193,CONVERT(0x456c61626f7261746520426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138312e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096194,CONVERT(0x456c61626f7261746520486561767920426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138312e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096195,CONVERT(0x456c61626f7261746520417865204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138312e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096196,CONVERT(0x456c61626f7261746520536d616c6c20426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138312e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096197,CONVERT(0x456c61626f72617465205370656172204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138312e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096198,CONVERT(0x456c61626f72617465204d616365204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138312e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096199,CONVERT(0x456c61626f726174652048616d6d6572204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138312e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096200,CONVERT(0x456c61626f72617465204d6574616c205772617020536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138312e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096201,CONVERT(0x456c61626f72617465204c6172676520426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138312e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096202,CONVERT(0x456c61626f72617465204c6172676520417865204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138312e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096203,CONVERT(0x556e666972656420456c61626f7261746520536d616c6c2048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,222,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138312e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096204,CONVERT(0x556e666972656420456c61626f726174652048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,222,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138312e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096205,CONVERT(0x556e666972656420456c61626f72617465204c617267652048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,222,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138312e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096206,CONVERT(0x556e666972656420456c61626f7261746520426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,223,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138312e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096207,CONVERT(0x556e666972656420456c61626f7261746520486561767920426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,223,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138312e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096208,CONVERT(0x556e666972656420456c61626f7261746520417865204865616420536861706564204d6f6c64 USING utf8mb4),69,0,224,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138312e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096209,CONVERT(0x556e666972656420456c61626f7261746520536d616c6c20426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,223,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138312e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096210,CONVERT(0x556e666972656420456c61626f72617465205370656172204865616420536861706564204d6f6c64 USING utf8mb4),69,0,223,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138312e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096211,CONVERT(0x556e666972656420456c61626f72617465204d616365204865616420536861706564204d6f6c64 USING utf8mb4),69,0,222,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138312e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096212,CONVERT(0x556e666972656420456c61626f726174652048616d6d6572204865616420536861706564204d6f6c64 USING utf8mb4),69,0,222,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138312e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096213,CONVERT(0x556e666972656420456c61626f72617465204d6574616c205772617020536861706564204d6f6c64 USING utf8mb4),69,0,222,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138312e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096214,CONVERT(0x556e666972656420456c61626f72617465204c6172676520426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,224,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138312e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096215,CONVERT(0x556e666972656420456c61626f72617465204c6172676520417865204865616420536861706564204d6f6c64 USING utf8mb4),69,0,227,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138312e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL);
INSERT INTO rrc181_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3096190,16907,0,0,1,1,0),
(3096190,48276,1,0,0,0,0),
(3096190,49104,0,0,1,1,0),
(3096190,9,0,0,0,0,1),
(3096191,16907,0,0,1,1,0),
(3096191,48277,1,0,0,0,0),
(3096191,49105,0,0,1,1,0),
(3096191,9,0,0,0,0,1),
(3096192,16907,0,0,1,1,0),
(3096192,48278,1,0,0,0,0),
(3096192,49106,0,0,1,1,0),
(3096192,9,0,0,0,0,1),
(3096193,16907,0,0,1,1,0),
(3096193,48279,1,0,0,0,0),
(3096193,49107,0,0,1,1,0),
(3096193,9,0,0,0,0,1),
(3096194,16907,0,0,1,1,0),
(3096194,48280,1,0,0,0,0),
(3096194,49108,0,0,1,1,0),
(3096194,9,0,0,0,0,1),
(3096195,16907,0,0,1,1,0),
(3096195,48281,1,0,0,0,0),
(3096195,49109,0,0,1,1,0),
(3096195,9,0,0,0,0,1),
(3096196,16907,0,0,1,1,0),
(3096196,48282,1,0,0,0,0),
(3096196,49110,0,0,1,1,0),
(3096196,9,0,0,0,0,1),
(3096197,16907,0,0,1,1,0),
(3096197,48283,1,0,0,0,0),
(3096197,49111,0,0,1,1,0),
(3096197,9,0,0,0,0,1),
(3096198,16907,0,0,1,1,0),
(3096198,48284,1,0,0,0,0),
(3096198,49112,0,0,1,1,0),
(3096198,9,0,0,0,0,1),
(3096199,16907,0,0,1,1,0),
(3096199,48285,1,0,0,0,0),
(3096199,49113,0,0,1,1,0),
(3096199,9,0,0,0,0,1),
(3096200,16907,0,0,1,1,0),
(3096200,48286,1,0,0,0,0),
(3096200,49114,0,0,1,1,0),
(3096200,9,0,0,0,0,1),
(3096201,16907,0,0,1,1,0),
(3096201,48288,1,0,0,0,0),
(3096201,49116,0,0,1,1,0),
(3096201,9,0,0,0,0,1),
(3096202,16907,0,0,1,1,0),
(3096202,48289,1,0,0,0,0),
(3096202,49117,0,0,1,1,0),
(3096202,9,0,0,0,0,1),
(3096203,16901,0,0,1,1,0),
(3096203,34221,0,0,1,1,0),
(3096203,48893,0,0,1,1,0),
(3096203,49104,1,0,0,0,0),
(3096203,8,0,0,0,0,1),
(3096204,16902,0,0,1,1,0),
(3096204,34221,0,0,1,1,0),
(3096204,48894,0,0,1,1,0),
(3096204,49105,1,0,0,0,0),
(3096204,8,0,0,0,0,1),
(3096205,16901,0,0,1,1,0),
(3096205,16902,0,0,1,1,0),
(3096205,34221,0,0,1,1,0),
(3096205,48895,0,0,1,1,0),
(3096205,49106,1,0,0,0,0),
(3096205,8,0,0,0,0,1),
(3096206,16902,0,0,2,2,0),
(3096206,34221,0,0,1,1,0),
(3096206,48896,0,0,1,1,0),
(3096206,49107,1,0,0,0,0),
(3096206,8,0,0,0,0,1),
(3096207,16902,0,0,3,3,0),
(3096207,34221,0,0,1,1,0),
(3096207,48897,0,0,1,1,0),
(3096207,49108,1,0,0,0,0),
(3096207,8,0,0,0,0,1),
(3096208,16902,0,0,2,2,0),
(3096208,34221,0,0,1,1,0),
(3096208,48898,0,0,1,1,0),
(3096208,49109,1,0,0,0,0),
(3096208,8,0,0,0,0,1),
(3096209,16902,0,0,1,1,0),
(3096209,34221,0,0,1,1,0),
(3096209,48899,0,0,1,1,0),
(3096209,49110,1,0,0,0,0),
(3096209,8,0,0,0,0,1),
(3096210,16902,0,0,1,1,0),
(3096210,34221,0,0,1,1,0),
(3096210,48900,0,0,1,1,0),
(3096210,49111,1,0,0,0,0),
(3096210,8,0,0,0,0,1),
(3096211,16902,0,0,1,1,0),
(3096211,34221,0,0,1,1,0),
(3096211,48901,0,0,1,1,0),
(3096211,49112,1,0,0,0,0),
(3096211,8,0,0,0,0,1),
(3096212,16902,0,0,2,2,0),
(3096212,34221,0,0,1,1,0),
(3096212,48902,0,0,1,1,0),
(3096212,49113,1,0,0,0,0),
(3096212,8,0,0,0,0,1),
(3096213,16901,0,0,1,1,0),
(3096213,34221,0,0,1,1,0),
(3096213,48903,0,0,1,1,0),
(3096213,49114,1,0,0,0,0),
(3096213,8,0,0,0,0,1),
(3096214,16902,0,0,4,4,0),
(3096214,34221,0,0,1,1,0),
(3096214,48905,0,0,1,1,0),
(3096214,49116,1,0,0,0,0),
(3096214,8,0,0,0,0,1),
(3096215,16902,0,0,4,4,0),
(3096215,34221,0,0,1,1,0),
(3096215,48906,0,0,1,1,0),
(3096215,49117,1,0,0,0,0),
(3096215,8,0,0,0,0,1);
INSERT INTO rrc181_items (`id`,`name`) VALUES
(16901,CONVERT(0x426c6f636b206f6620436c6179 USING utf8mb4)),
(16902,CONVERT(0x4c6172676520426c6f636b206f6620436c6179 USING utf8mb4)),
(16907,CONVERT(0x5175616c69747920466972696e67205368656574 USING utf8mb4)),
(34221,CONVERT(0x5375706572622053696c6b USING utf8mb4)),
(48276,CONVERT(0x456c61626f7261746520536d616c6c2048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(48277,CONVERT(0x456c61626f726174652048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(48278,CONVERT(0x456c61626f72617465204c617267652048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(48279,CONVERT(0x456c61626f7261746520426c61646520536861706564204d6f6c64 USING utf8mb4)),
(48280,CONVERT(0x456c61626f7261746520486561767920426c61646520536861706564204d6f6c64 USING utf8mb4)),
(48281,CONVERT(0x456c61626f7261746520417865204865616420536861706564204d6f6c64 USING utf8mb4)),
(48282,CONVERT(0x456c61626f7261746520536d616c6c20426c61646520536861706564204d6f6c64 USING utf8mb4)),
(48283,CONVERT(0x456c61626f72617465205370656172204865616420536861706564204d6f6c64 USING utf8mb4)),
(48284,CONVERT(0x456c61626f72617465204d616365204865616420536861706564204d6f6c64 USING utf8mb4)),
(48285,CONVERT(0x456c61626f726174652048616d6d6572204865616420536861706564204d6f6c64 USING utf8mb4)),
(48286,CONVERT(0x456c61626f72617465204d6574616c205772617020536861706564204d6f6c64 USING utf8mb4)),
(48288,CONVERT(0x456c61626f72617465204c6172676520426c61646520536861706564204d6f6c64 USING utf8mb4)),
(48289,CONVERT(0x456c61626f72617465204c6172676520417865204865616420536861706564204d6f6c64 USING utf8mb4)),
(48893,CONVERT(0x536d616c6c2048696c742043617374696e67204d6f6c6420536b65746368 USING utf8mb4)),
(48894,CONVERT(0x48696c742043617374696e67204d6f6c6420536b65746368 USING utf8mb4)),
(48895,CONVERT(0x4c617267652048696c742043617374696e67204d6f6c6420536b65746368 USING utf8mb4)),
(48896,CONVERT(0x426c61646520536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48897,CONVERT(0x486561767920426c61646520536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48898,CONVERT(0x417865204865616420536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48899,CONVERT(0x536d616c6c20426c61646520536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48900,CONVERT(0x5370656172204865616420536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48901,CONVERT(0x4d616365204865616420536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48902,CONVERT(0x48616d6d6572204865616420536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48903,CONVERT(0x4d6574616c205772617020536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48905,CONVERT(0x4c6172676520426c61646520536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48906,CONVERT(0x4c6172676520417865204865616420536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(49104,CONVERT(0x556e666972656420456c61626f7261746520536d616c6c2048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(49105,CONVERT(0x556e666972656420456c61626f726174652048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(49106,CONVERT(0x556e666972656420456c61626f72617465204c617267652048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(49107,CONVERT(0x556e666972656420456c61626f7261746520426c61646520536861706564204d6f6c64 USING utf8mb4)),
(49108,CONVERT(0x556e666972656420456c61626f7261746520486561767920426c61646520536861706564204d6f6c64 USING utf8mb4)),
(49109,CONVERT(0x556e666972656420456c61626f7261746520417865204865616420536861706564204d6f6c64 USING utf8mb4)),
(49110,CONVERT(0x556e666972656420456c61626f7261746520536d616c6c20426c61646520536861706564204d6f6c64 USING utf8mb4)),
(49111,CONVERT(0x556e666972656420456c61626f72617465205370656172204865616420536861706564204d6f6c64 USING utf8mb4)),
(49112,CONVERT(0x556e666972656420456c61626f72617465204d616365204865616420536861706564204d6f6c64 USING utf8mb4)),
(49113,CONVERT(0x556e666972656420456c61626f726174652048616d6d6572204865616420536861706564204d6f6c64 USING utf8mb4)),
(49114,CONVERT(0x556e666972656420456c61626f72617465204d6574616c205772617020536861706564204d6f6c64 USING utf8mb4)),
(49116,CONVERT(0x556e666972656420456c61626f72617465204c6172676520426c61646520536861706564204d6f6c64 USING utf8mb4)),
(49117,CONVERT(0x556e666972656420456c61626f72617465204c6172676520417865204865616420536861706564204d6f6c64 USING utf8mb4));
 CREATE TEMPORARY TABLE rrc181_peer_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc181_peer_entries LIKE tradeskill_recipe_entries;
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 target database mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16901 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16902 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16907 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34221 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 70 AND `reclevel` <=> 74 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48276 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48277 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 15 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48278 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48279 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48280 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48281 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48282 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48283 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 15 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48284 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48285 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48286 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48288 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 3 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 5 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48289 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 3 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 5 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48893 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48894 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48895 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48896 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48897 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48898 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48899 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48900 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48901 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48902 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48903 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48905 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48906 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49104 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49105 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49106 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49107 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49108 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49109 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49110 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49111 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49112 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49113 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49114 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49116 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 3 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49117 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 3 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 native item semantics mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc181_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc181_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc181_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc181_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc181_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc181_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 output producer universe changed'; END IF;

 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc181_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc181_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 item identity/dependency mismatch'; END IF;
 IF already_present<>26 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc181_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc181_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc181_recipes q ON q.id=r.recipe_id LEFT JOIN rrc181_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc181_recipes q ON q.id=r.recipe_id)<>118 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc181_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc181_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc181_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-26 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-118 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 rollback count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc181_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc181_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc181_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc181_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc181_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc181_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC181 output producer universe changed'; END IF;
 DROP TEMPORARY TABLE rrc181_peer_entries;
 DROP TEMPORARY TABLE rrc181_peer_recipes;
 DROP TEMPORARY TABLE rrc181_entries;
 DROP TEMPORARY TABLE rrc181_recipes;
 DROP TEMPORARY TABLE rrc181_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC181' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
