-- RRC186: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc186_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc186_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc186_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc186_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3096320,CONVERT(0x53696d706c652048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138362e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096321,CONVERT(0x53696d706c65204c617267652048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138362e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096322,CONVERT(0x53696d706c6520426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138362e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096323,CONVERT(0x53696d706c6520486561767920426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138362e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096324,CONVERT(0x53696d706c6520417865204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138362e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096325,CONVERT(0x53696d706c652048616d6d6572204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138362e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096326,CONVERT(0x53696d706c65204c6172676520426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138362e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096327,CONVERT(0x53696d706c65204c6172676520417865204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138362e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096328,CONVERT(0x4f726e61746520536d616c6c2048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138362e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096329,CONVERT(0x4f726e61746520536d616c6c20426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138362e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096330,CONVERT(0x4f726e617465205370656172204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138362e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096331,CONVERT(0x4f726e617465204d6574616c205772617020536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138362e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096332,CONVERT(0x4f726e61746520556c616b20426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138362e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096333,CONVERT(0x556e66697265642053696d706c652048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,62,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138362e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096334,CONVERT(0x556e66697265642053696d706c65204c617267652048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,62,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138362e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096335,CONVERT(0x556e66697265642053696d706c6520426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,63,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138362e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096336,CONVERT(0x556e66697265642053696d706c6520486561767920426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,63,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138362e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096337,CONVERT(0x556e66697265642053696d706c6520417865204865616420536861706564204d6f6c64 USING utf8mb4),69,0,66,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138362e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096338,CONVERT(0x556e66697265642053696d706c652048616d6d6572204865616420536861706564204d6f6c64 USING utf8mb4),69,0,62,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138362e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096339,CONVERT(0x556e66697265642053696d706c65204c6172676520426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,66,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138362e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096340,CONVERT(0x556e66697265642053696d706c65204c6172676520417865204865616420536861706564204d6f6c64 USING utf8mb4),69,0,67,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138362e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096341,CONVERT(0x556e6669726564204f726e61746520536d616c6c2048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,104,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138362e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096342,CONVERT(0x556e6669726564204f726e61746520536d616c6c20426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,107,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138362e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096343,CONVERT(0x556e6669726564204f726e617465205370656172204865616420536861706564204d6f6c64 USING utf8mb4),69,0,107,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138362e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096344,CONVERT(0x556e6669726564204f726e617465204d6574616c205772617020536861706564204d6f6c64 USING utf8mb4),69,0,104,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138362e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096345,CONVERT(0x556e6669726564204f726e61746520556c616b20426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,107,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138362e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL);
INSERT INTO rrc186_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3096320,16906,0,0,1,1,0),
(3096320,48235,1,0,0,0,0),
(3096320,49063,0,0,1,1,0),
(3096320,9,0,0,0,0,1),
(3096321,16906,0,0,1,1,0),
(3096321,48236,1,0,0,0,0),
(3096321,49064,0,0,1,1,0),
(3096321,9,0,0,0,0,1),
(3096322,16906,0,0,1,1,0),
(3096322,48237,1,0,0,0,0),
(3096322,49065,0,0,1,1,0),
(3096322,9,0,0,0,0,1),
(3096323,16906,0,0,1,1,0),
(3096323,48238,1,0,0,0,0),
(3096323,49066,0,0,1,1,0),
(3096323,9,0,0,0,0,1),
(3096324,16906,0,0,1,1,0),
(3096324,48239,1,0,0,0,0),
(3096324,49067,0,0,1,1,0),
(3096324,9,0,0,0,0,1),
(3096325,16906,0,0,1,1,0),
(3096325,48243,1,0,0,0,0),
(3096325,49071,0,0,1,1,0),
(3096325,9,0,0,0,0,1),
(3096326,16906,0,0,1,1,0),
(3096326,48246,1,0,0,0,0),
(3096326,49074,0,0,1,1,0),
(3096326,9,0,0,0,0,1),
(3096327,16906,0,0,1,1,0),
(3096327,48247,1,0,0,0,0),
(3096327,49075,0,0,1,1,0),
(3096327,9,0,0,0,0,1),
(3096328,16906,0,0,1,1,0),
(3096328,48248,1,0,0,0,0),
(3096328,49076,0,0,1,1,0),
(3096328,9,0,0,0,0,1),
(3096329,16906,0,0,1,1,0),
(3096329,48254,1,0,0,0,0),
(3096329,49082,0,0,1,1,0),
(3096329,9,0,0,0,0,1),
(3096330,16906,0,0,1,1,0),
(3096330,48255,1,0,0,0,0),
(3096330,49083,0,0,1,1,0),
(3096330,9,0,0,0,0,1),
(3096331,16906,0,0,1,1,0),
(3096331,48258,1,0,0,0,0),
(3096331,49086,0,0,1,1,0),
(3096331,9,0,0,0,0,1),
(3096332,16906,0,0,1,1,0),
(3096332,48259,1,0,0,0,0),
(3096332,49087,0,0,1,1,0),
(3096332,9,0,0,0,0,1),
(3096333,16902,0,0,1,1,0),
(3096333,34214,0,0,1,1,0),
(3096333,48894,0,0,1,1,0),
(3096333,49063,1,0,0,0,0),
(3096333,8,0,0,0,0,1),
(3096334,16901,0,0,1,1,0),
(3096334,16902,0,0,1,1,0),
(3096334,34214,0,0,1,1,0),
(3096334,48895,0,0,1,1,0),
(3096334,49064,1,0,0,0,0),
(3096334,8,0,0,0,0,1),
(3096335,16902,0,0,2,2,0),
(3096335,34214,0,0,1,1,0),
(3096335,48896,0,0,1,1,0),
(3096335,49065,1,0,0,0,0),
(3096335,8,0,0,0,0,1),
(3096336,16902,0,0,3,3,0),
(3096336,34214,0,0,1,1,0),
(3096336,48897,0,0,1,1,0),
(3096336,49066,1,0,0,0,0),
(3096336,8,0,0,0,0,1),
(3096337,16902,0,0,2,2,0),
(3096337,34214,0,0,1,1,0),
(3096337,48898,0,0,1,1,0),
(3096337,49067,1,0,0,0,0),
(3096337,8,0,0,0,0,1),
(3096338,16902,0,0,2,2,0),
(3096338,34214,0,0,1,1,0),
(3096338,48902,0,0,1,1,0),
(3096338,49071,1,0,0,0,0),
(3096338,8,0,0,0,0,1),
(3096339,16902,0,0,4,4,0),
(3096339,34214,0,0,1,1,0),
(3096339,48905,0,0,1,1,0),
(3096339,49074,1,0,0,0,0),
(3096339,8,0,0,0,0,1),
(3096340,16902,0,0,4,4,0),
(3096340,34214,0,0,1,1,0),
(3096340,48906,0,0,1,1,0),
(3096340,49075,1,0,0,0,0),
(3096340,8,0,0,0,0,1),
(3096341,16901,0,0,1,1,0),
(3096341,34216,0,0,1,1,0),
(3096341,48893,0,0,1,1,0),
(3096341,49076,1,0,0,0,0),
(3096341,8,0,0,0,0,1),
(3096342,16902,0,0,1,1,0),
(3096342,34216,0,0,1,1,0),
(3096342,48899,0,0,1,1,0),
(3096342,49082,1,0,0,0,0),
(3096342,8,0,0,0,0,1),
(3096343,16902,0,0,1,1,0),
(3096343,34216,0,0,1,1,0),
(3096343,48900,0,0,1,1,0),
(3096343,49083,1,0,0,0,0),
(3096343,8,0,0,0,0,1),
(3096344,16901,0,0,1,1,0),
(3096344,34216,0,0,1,1,0),
(3096344,48903,0,0,1,1,0),
(3096344,49086,1,0,0,0,0),
(3096344,8,0,0,0,0,1),
(3096345,16902,0,0,1,1,0),
(3096345,34216,0,0,1,1,0),
(3096345,48904,0,0,1,1,0),
(3096345,49087,1,0,0,0,0),
(3096345,8,0,0,0,0,1);
INSERT INTO rrc186_items (`id`,`name`) VALUES
(16901,CONVERT(0x426c6f636b206f6620436c6179 USING utf8mb4)),
(16902,CONVERT(0x4c6172676520426c6f636b206f6620436c6179 USING utf8mb4)),
(16906,CONVERT(0x466972696e67205368656574 USING utf8mb4)),
(34214,CONVERT(0x53756c6c6965642053696c6b USING utf8mb4)),
(34216,CONVERT(0x43727564652053696c6b USING utf8mb4)),
(48235,CONVERT(0x53696d706c652048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(48236,CONVERT(0x53696d706c65204c617267652048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(48237,CONVERT(0x53696d706c6520426c61646520536861706564204d6f6c64 USING utf8mb4)),
(48238,CONVERT(0x53696d706c6520486561767920426c61646520536861706564204d6f6c64 USING utf8mb4)),
(48239,CONVERT(0x53696d706c6520417865204865616420536861706564204d6f6c64 USING utf8mb4)),
(48243,CONVERT(0x53696d706c652048616d6d6572204865616420536861706564204d6f6c64 USING utf8mb4)),
(48246,CONVERT(0x53696d706c65204c6172676520426c61646520536861706564204d6f6c64 USING utf8mb4)),
(48247,CONVERT(0x53696d706c65204c6172676520417865204865616420536861706564204d6f6c64 USING utf8mb4)),
(48248,CONVERT(0x4f726e61746520536d616c6c2048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(48254,CONVERT(0x4f726e61746520536d616c6c20426c61646520536861706564204d6f6c64 USING utf8mb4)),
(48255,CONVERT(0x4f726e617465205370656172204865616420536861706564204d6f6c64 USING utf8mb4)),
(48258,CONVERT(0x4f726e617465204d6574616c205772617020536861706564204d6f6c64 USING utf8mb4)),
(48259,CONVERT(0x4f726e61746520556c616b20426c61646520536861706564204d6f6c64 USING utf8mb4)),
(48893,CONVERT(0x536d616c6c2048696c742043617374696e67204d6f6c6420536b65746368 USING utf8mb4)),
(48894,CONVERT(0x48696c742043617374696e67204d6f6c6420536b65746368 USING utf8mb4)),
(48895,CONVERT(0x4c617267652048696c742043617374696e67204d6f6c6420536b65746368 USING utf8mb4)),
(48896,CONVERT(0x426c61646520536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48897,CONVERT(0x486561767920426c61646520536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48898,CONVERT(0x417865204865616420536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48899,CONVERT(0x536d616c6c20426c61646520536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48900,CONVERT(0x5370656172204865616420536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48902,CONVERT(0x48616d6d6572204865616420536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48903,CONVERT(0x4d6574616c205772617020536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48904,CONVERT(0x556c616b20426c61646520536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48905,CONVERT(0x4c6172676520426c61646520536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48906,CONVERT(0x4c6172676520417865204865616420536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(49063,CONVERT(0x556e66697265642053696d706c652048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(49064,CONVERT(0x556e66697265642053696d706c65204c617267652048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(49065,CONVERT(0x556e66697265642053696d706c6520426c61646520536861706564204d6f6c64 USING utf8mb4)),
(49066,CONVERT(0x556e66697265642053696d706c6520486561767920426c61646520536861706564204d6f6c64 USING utf8mb4)),
(49067,CONVERT(0x556e66697265642053696d706c6520417865204865616420536861706564204d6f6c64 USING utf8mb4)),
(49071,CONVERT(0x556e66697265642053696d706c652048616d6d6572204865616420536861706564204d6f6c64 USING utf8mb4)),
(49074,CONVERT(0x556e66697265642053696d706c65204c6172676520426c61646520536861706564204d6f6c64 USING utf8mb4)),
(49075,CONVERT(0x556e66697265642053696d706c65204c6172676520417865204865616420536861706564204d6f6c64 USING utf8mb4)),
(49076,CONVERT(0x556e6669726564204f726e61746520536d616c6c2048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(49082,CONVERT(0x556e6669726564204f726e61746520536d616c6c20426c61646520536861706564204d6f6c64 USING utf8mb4)),
(49083,CONVERT(0x556e6669726564204f726e617465205370656172204865616420536861706564204d6f6c64 USING utf8mb4)),
(49086,CONVERT(0x556e6669726564204f726e617465204d6574616c205772617020536861706564204d6f6c64 USING utf8mb4)),
(49087,CONVERT(0x556e6669726564204f726e61746520556c616b20426c61646520536861706564204d6f6c64 USING utf8mb4));
 CREATE TEMPORARY TABLE rrc186_peer_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc186_peer_entries LIKE tradeskill_recipe_entries;
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 target database mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16901 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16902 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16906 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34214 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 20 AND `reclevel` <=> 29 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34216 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 40 AND `reclevel` <=> 49 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48235 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 15 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48236 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48237 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48238 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48239 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48243 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48246 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 3 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 5 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48247 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 3 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 5 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48248 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48254 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48255 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 15 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48258 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48259 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48893 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48894 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48895 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48896 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48897 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48898 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48899 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48900 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48902 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48903 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48904 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48905 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48906 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49063 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49064 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49065 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49066 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49067 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49071 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49074 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 3 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49075 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 3 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49076 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49082 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49083 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49086 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49087 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 native item semantics mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc186_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc186_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc186_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc186_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc186_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc186_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 output producer universe changed'; END IF;

 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc186_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc186_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 item identity/dependency mismatch'; END IF;
 IF already_present<>26 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc186_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc186_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc186_recipes q ON q.id=r.recipe_id LEFT JOIN rrc186_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc186_recipes q ON q.id=r.recipe_id)<>118 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc186_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc186_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc186_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-26 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-118 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 rollback count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc186_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc186_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc186_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc186_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc186_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc186_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC186 output producer universe changed'; END IF;
 DROP TEMPORARY TABLE rrc186_peer_entries;
 DROP TEMPORARY TABLE rrc186_peer_recipes;
 DROP TEMPORARY TABLE rrc186_entries;
 DROP TEMPORARY TABLE rrc186_recipes;
 DROP TEMPORARY TABLE rrc186_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC186' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
