-- RRC197: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc197_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc197_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc197_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc197_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3096557,CONVERT(0x476c6f72696f757320536d616c6c2048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096558,CONVERT(0x476c6f72696f75732048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096559,CONVERT(0x476c6f72696f7573204c617267652048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096560,CONVERT(0x476c6f72696f757320426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096561,CONVERT(0x476c6f72696f757320486561767920426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096562,CONVERT(0x476c6f72696f757320417865204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096563,CONVERT(0x476c6f72696f757320536d616c6c20426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096564,CONVERT(0x476c6f72696f7573205370656172204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096565,CONVERT(0x476c6f72696f7573204d616365204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096566,CONVERT(0x476c6f72696f75732048616d6d6572204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096567,CONVERT(0x476c6f72696f7573204d6574616c205772617020536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096568,CONVERT(0x476c6f72696f757320556c616b20426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096569,CONVERT(0x476c6f72696f7573204c6172676520426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096570,CONVERT(0x476c6f72696f7573204c6172676520417865204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096571,CONVERT(0x556e666972656420476c6f72696f757320536d616c6c2048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,282,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096572,CONVERT(0x556e666972656420476c6f72696f75732048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,282,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096573,CONVERT(0x556e666972656420476c6f72696f7573204c617267652048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,282,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096574,CONVERT(0x556e666972656420476c6f72696f757320426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,283,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096575,CONVERT(0x556e666972656420476c6f72696f757320486561767920426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,283,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096576,CONVERT(0x556e666972656420476c6f72696f757320417865204865616420536861706564204d6f6c64 USING utf8mb4),69,0,284,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096577,CONVERT(0x556e666972656420476c6f72696f757320536d616c6c20426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,283,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096578,CONVERT(0x556e666972656420476c6f72696f7573205370656172204865616420536861706564204d6f6c64 USING utf8mb4),69,0,282,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096579,CONVERT(0x556e666972656420476c6f72696f7573204d616365204865616420536861706564204d6f6c64 USING utf8mb4),69,0,282,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096580,CONVERT(0x556e666972656420476c6f72696f75732048616d6d6572204865616420536861706564204d6f6c64 USING utf8mb4),69,0,282,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096581,CONVERT(0x556e666972656420476c6f72696f7573204d6574616c205772617020536861706564204d6f6c64 USING utf8mb4),69,0,282,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096582,CONVERT(0x556e666972656420476c6f72696f757320556c616b20426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,283,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096583,CONVERT(0x556e666972656420476c6f72696f7573204c6172676520426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,284,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL),
(3096584,CONVERT(0x556e666972656420476c6f72696f7573204c6172676520417865204865616420536861706564204d6f6c64 USING utf8mb4),69,0,287,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f4120476c6f72696f7573206d6f6c64207265636f6e737472756374696f6e3b205252433139372e USING utf8mb4),0,0,0,1,18,-1,NULL,NULL);
INSERT INTO rrc197_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3096557,16908,0,0,1,1,0),
(3096557,129638,1,0,0,0,0),
(3096557,129761,0,0,1,1,0),
(3096557,9,0,0,0,0,1),
(3096558,16908,0,0,1,1,0),
(3096558,129639,1,0,0,0,0),
(3096558,129762,0,0,1,1,0),
(3096558,9,0,0,0,0,1),
(3096559,16908,0,0,1,1,0),
(3096559,129640,1,0,0,0,0),
(3096559,129763,0,0,1,1,0),
(3096559,9,0,0,0,0,1),
(3096560,16908,0,0,1,1,0),
(3096560,129641,1,0,0,0,0),
(3096560,129764,0,0,1,1,0),
(3096560,9,0,0,0,0,1),
(3096561,16908,0,0,1,1,0),
(3096561,129642,1,0,0,0,0),
(3096561,129765,0,0,1,1,0),
(3096561,9,0,0,0,0,1),
(3096562,16908,0,0,1,1,0),
(3096562,129643,1,0,0,0,0),
(3096562,129766,0,0,1,1,0),
(3096562,9,0,0,0,0,1),
(3096563,16908,0,0,1,1,0),
(3096563,129644,1,0,0,0,0),
(3096563,129767,0,0,1,1,0),
(3096563,9,0,0,0,0,1),
(3096564,16908,0,0,1,1,0),
(3096564,129645,1,0,0,0,0),
(3096564,129768,0,0,1,1,0),
(3096564,9,0,0,0,0,1),
(3096565,16908,0,0,1,1,0),
(3096565,129646,1,0,0,0,0),
(3096565,129769,0,0,1,1,0),
(3096565,9,0,0,0,0,1),
(3096566,16908,0,0,1,1,0),
(3096566,129647,1,0,0,0,0),
(3096566,129770,0,0,1,1,0),
(3096566,9,0,0,0,0,1),
(3096567,16908,0,0,1,1,0),
(3096567,129648,1,0,0,0,0),
(3096567,129771,0,0,1,1,0),
(3096567,9,0,0,0,0,1),
(3096568,16908,0,0,1,1,0),
(3096568,129649,1,0,0,0,0),
(3096568,129772,0,0,1,1,0),
(3096568,9,0,0,0,0,1),
(3096569,16908,0,0,1,1,0),
(3096569,129650,1,0,0,0,0),
(3096569,129773,0,0,1,1,0),
(3096569,9,0,0,0,0,1),
(3096570,16908,0,0,1,1,0),
(3096570,129651,1,0,0,0,0),
(3096570,129774,0,0,1,1,0),
(3096570,9,0,0,0,0,1),
(3096571,16901,0,0,1,1,0),
(3096571,48893,0,0,1,1,0),
(3096571,112604,0,0,1,1,0),
(3096571,129761,1,0,0,0,0),
(3096571,8,0,0,0,0,1),
(3096572,16902,0,0,1,1,0),
(3096572,48894,0,0,1,1,0),
(3096572,112604,0,0,1,1,0),
(3096572,129762,1,0,0,0,0),
(3096572,8,0,0,0,0,1),
(3096573,16901,0,0,1,1,0),
(3096573,16902,0,0,1,1,0),
(3096573,48895,0,0,1,1,0),
(3096573,112604,0,0,1,1,0),
(3096573,129763,1,0,0,0,0),
(3096573,8,0,0,0,0,1),
(3096574,16902,0,0,2,2,0),
(3096574,48896,0,0,1,1,0),
(3096574,112604,0,0,1,1,0),
(3096574,129764,1,0,0,0,0),
(3096574,8,0,0,0,0,1),
(3096575,16902,0,0,3,3,0),
(3096575,48897,0,0,1,1,0),
(3096575,112604,0,0,1,1,0),
(3096575,129765,1,0,0,0,0),
(3096575,8,0,0,0,0,1),
(3096576,16902,0,0,2,2,0),
(3096576,48898,0,0,1,1,0),
(3096576,112604,0,0,1,1,0),
(3096576,129766,1,0,0,0,0),
(3096576,8,0,0,0,0,1),
(3096577,16902,0,0,1,1,0),
(3096577,48899,0,0,1,1,0),
(3096577,112604,0,0,1,1,0),
(3096577,129767,1,0,0,0,0),
(3096577,8,0,0,0,0,1),
(3096578,16902,0,0,1,1,0),
(3096578,48900,0,0,1,1,0),
(3096578,112604,0,0,1,1,0),
(3096578,129768,1,0,0,0,0),
(3096578,8,0,0,0,0,1),
(3096579,16902,0,0,1,1,0),
(3096579,48901,0,0,1,1,0),
(3096579,112604,0,0,1,1,0),
(3096579,129769,1,0,0,0,0),
(3096579,8,0,0,0,0,1),
(3096580,16902,0,0,2,2,0),
(3096580,48902,0,0,1,1,0),
(3096580,112604,0,0,1,1,0),
(3096580,129770,1,0,0,0,0),
(3096580,8,0,0,0,0,1),
(3096581,16901,0,0,1,1,0),
(3096581,48903,0,0,1,1,0),
(3096581,112604,0,0,1,1,0),
(3096581,129771,1,0,0,0,0),
(3096581,8,0,0,0,0,1),
(3096582,16902,0,0,1,1,0),
(3096582,48904,0,0,1,1,0),
(3096582,112604,0,0,1,1,0),
(3096582,129772,1,0,0,0,0),
(3096582,8,0,0,0,0,1),
(3096583,16902,0,0,4,4,0),
(3096583,48905,0,0,1,1,0),
(3096583,112604,0,0,1,1,0),
(3096583,129773,1,0,0,0,0),
(3096583,8,0,0,0,0,1),
(3096584,16902,0,0,4,4,0),
(3096584,48906,0,0,1,1,0),
(3096584,112604,0,0,1,1,0),
(3096584,129774,1,0,0,0,0),
(3096584,8,0,0,0,0,1);
INSERT INTO rrc197_items (`id`,`name`) VALUES
(16901,CONVERT(0x426c6f636b206f6620436c6179 USING utf8mb4)),
(16902,CONVERT(0x4c6172676520426c6f636b206f6620436c6179 USING utf8mb4)),
(16908,CONVERT(0x48696768205175616c69747920466972696e67205368656574 USING utf8mb4)),
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
(48904,CONVERT(0x556c616b20426c61646520536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48905,CONVERT(0x4c6172676520426c61646520536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48906,CONVERT(0x4c6172676520417865204865616420536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(112604,CONVERT(0x45786f7469632053696c6b USING utf8mb4)),
(129638,CONVERT(0x476c6f72696f757320536d616c6c2048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(129639,CONVERT(0x476c6f72696f75732048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(129640,CONVERT(0x476c6f72696f7573204c617267652048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(129641,CONVERT(0x476c6f72696f757320426c61646520536861706564204d6f6c64 USING utf8mb4)),
(129642,CONVERT(0x476c6f72696f757320486561767920426c61646520536861706564204d6f6c64 USING utf8mb4)),
(129643,CONVERT(0x476c6f72696f757320417865204865616420536861706564204d6f6c64 USING utf8mb4)),
(129644,CONVERT(0x476c6f72696f757320536d616c6c20426c61646520536861706564204d6f6c64 USING utf8mb4)),
(129645,CONVERT(0x476c6f72696f7573205370656172204865616420536861706564204d6f6c64 USING utf8mb4)),
(129646,CONVERT(0x476c6f72696f7573204d616365204865616420536861706564204d6f6c64 USING utf8mb4)),
(129647,CONVERT(0x476c6f72696f75732048616d6d6572204865616420536861706564204d6f6c64 USING utf8mb4)),
(129648,CONVERT(0x476c6f72696f7573204d6574616c205772617020536861706564204d6f6c64 USING utf8mb4)),
(129649,CONVERT(0x476c6f72696f757320556c616b20426c61646520536861706564204d6f6c64 USING utf8mb4)),
(129650,CONVERT(0x476c6f72696f7573204c6172676520426c61646520536861706564204d6f6c64 USING utf8mb4)),
(129651,CONVERT(0x476c6f72696f7573204c6172676520417865204865616420536861706564204d6f6c64 USING utf8mb4)),
(129761,CONVERT(0x556e666972656420476c6f72696f757320536d616c6c2048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(129762,CONVERT(0x556e666972656420476c6f72696f75732048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(129763,CONVERT(0x556e666972656420476c6f72696f7573204c617267652048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(129764,CONVERT(0x556e666972656420476c6f72696f757320426c61646520536861706564204d6f6c64 USING utf8mb4)),
(129765,CONVERT(0x556e666972656420476c6f72696f757320486561767920426c61646520536861706564204d6f6c64 USING utf8mb4)),
(129766,CONVERT(0x556e666972656420476c6f72696f757320417865204865616420536861706564204d6f6c64 USING utf8mb4)),
(129767,CONVERT(0x556e666972656420476c6f72696f757320536d616c6c20426c61646520536861706564204d6f6c64 USING utf8mb4)),
(129768,CONVERT(0x556e666972656420476c6f72696f7573205370656172204865616420536861706564204d6f6c64 USING utf8mb4)),
(129769,CONVERT(0x556e666972656420476c6f72696f7573204d616365204865616420536861706564204d6f6c64 USING utf8mb4)),
(129770,CONVERT(0x556e666972656420476c6f72696f75732048616d6d6572204865616420536861706564204d6f6c64 USING utf8mb4)),
(129771,CONVERT(0x556e666972656420476c6f72696f7573204d6574616c205772617020536861706564204d6f6c64 USING utf8mb4)),
(129772,CONVERT(0x556e666972656420476c6f72696f757320556c616b20426c61646520536861706564204d6f6c64 USING utf8mb4)),
(129773,CONVERT(0x556e666972656420476c6f72696f7573204c6172676520426c61646520536861706564204d6f6c64 USING utf8mb4)),
(129774,CONVERT(0x556e666972656420476c6f72696f7573204c6172676520417865204865616420536861706564204d6f6c64 USING utf8mb4));
 CREATE TEMPORARY TABLE rrc197_peer_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc197_peer_entries LIKE tradeskill_recipe_entries;
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 target database mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16901 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16902 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16908 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48893 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48894 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48895 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48896 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48897 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48898 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48899 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48900 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48901 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48902 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48903 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48904 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48905 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48906 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112604 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129638 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129639 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 15 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129640 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129641 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129642 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129643 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129644 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129645 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 15 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129646 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129647 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129648 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129649 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129650 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 3 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 5 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129651 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 3 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 5 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129761 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129762 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129763 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129764 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129765 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129766 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129767 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129768 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129769 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129770 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129771 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129772 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129773 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 3 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=129774 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 3 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 native item semantics mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc197_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc197_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc197_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc197_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc197_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc197_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 output producer universe changed'; END IF;

 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc197_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc197_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 item identity/dependency mismatch'; END IF;
 IF already_present<>28 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc197_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc197_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc197_recipes q ON q.id=r.recipe_id LEFT JOIN rrc197_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc197_recipes q ON q.id=r.recipe_id)<>127 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc197_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc197_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc197_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-28 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-127 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 rollback count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc197_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc197_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc197_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc197_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc197_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc197_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC197 output producer universe changed'; END IF;
 DROP TEMPORARY TABLE rrc197_peer_entries;
 DROP TEMPORARY TABLE rrc197_peer_recipes;
 DROP TEMPORARY TABLE rrc197_entries;
 DROP TEMPORARY TABLE rrc197_recipes;
 DROP TEMPORARY TABLE rrc197_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC197' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
