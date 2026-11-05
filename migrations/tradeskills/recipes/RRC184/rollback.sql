-- RRC184: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc184_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc184_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc184_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc184_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3096268,CONVERT(0x496e7472696361746520536d616c6c2048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096269,CONVERT(0x496e74726963617465205370656172204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096270,CONVERT(0x496e7472696361746520556c616b20426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096271,CONVERT(0x496e757265642048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096272,CONVERT(0x496e75726564204c617267652048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096273,CONVERT(0x496e7572656420426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096274,CONVERT(0x496e7572656420486561767920426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096275,CONVERT(0x496e7572656420417865204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096276,CONVERT(0x496e75726564204d616365204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096277,CONVERT(0x496e757265642048616d6d6572204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096278,CONVERT(0x496e75726564204d6574616c205772617020536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096279,CONVERT(0x496e75726564204c6172676520426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096280,CONVERT(0x496e75726564204c6172676520417865204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096281,CONVERT(0x556e666972656420496e7472696361746520536d616c6c2048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,172,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096282,CONVERT(0x556e666972656420496e74726963617465205370656172204865616420536861706564204d6f6c64 USING utf8mb4),69,0,174,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096283,CONVERT(0x556e666972656420496e7472696361746520556c616b20426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,174,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096284,CONVERT(0x556e666972656420496e757265642048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,242,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096285,CONVERT(0x556e666972656420496e75726564204c617267652048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,242,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096286,CONVERT(0x556e666972656420496e7572656420426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,244,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096287,CONVERT(0x556e666972656420496e7572656420486561767920426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,244,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096288,CONVERT(0x556e666972656420496e7572656420417865204865616420536861706564204d6f6c64 USING utf8mb4),69,0,246,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096289,CONVERT(0x556e666972656420496e75726564204d616365204865616420536861706564204d6f6c64 USING utf8mb4),69,0,242,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096290,CONVERT(0x556e666972656420496e757265642048616d6d6572204865616420536861706564204d6f6c64 USING utf8mb4),69,0,242,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096291,CONVERT(0x556e666972656420496e75726564204d6574616c205772617020536861706564204d6f6c64 USING utf8mb4),69,0,242,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096292,CONVERT(0x556e666972656420496e75726564204c6172676520426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,246,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096293,CONVERT(0x556e666972656420496e75726564204c6172676520417865204865616420536861706564204d6f6c64 USING utf8mb4),69,0,247,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL);
INSERT INTO rrc184_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3096268,16907,0,0,1,1,0),
(3096268,48262,1,0,0,0,0),
(3096268,49090,0,0,1,1,0),
(3096268,9,0,0,0,0,1),
(3096269,16907,0,0,1,1,0),
(3096269,48269,1,0,0,0,0),
(3096269,49097,0,0,1,1,0),
(3096269,9,0,0,0,0,1),
(3096270,16907,0,0,1,1,0),
(3096270,48273,1,0,0,0,0),
(3096270,49101,0,0,1,1,0),
(3096270,9,0,0,0,0,1),
(3096271,16908,0,0,1,1,0),
(3096271,48291,1,0,0,0,0),
(3096271,49119,0,0,1,1,0),
(3096271,9,0,0,0,0,1),
(3096272,16908,0,0,1,1,0),
(3096272,48292,1,0,0,0,0),
(3096272,49120,0,0,1,1,0),
(3096272,9,0,0,0,0,1),
(3096273,16908,0,0,1,1,0),
(3096273,48293,1,0,0,0,0),
(3096273,49121,0,0,1,1,0),
(3096273,9,0,0,0,0,1),
(3096274,16908,0,0,1,1,0),
(3096274,48294,1,0,0,0,0),
(3096274,49122,0,0,1,1,0),
(3096274,9,0,0,0,0,1),
(3096275,16908,0,0,1,1,0),
(3096275,48295,1,0,0,0,0),
(3096275,49123,0,0,1,1,0),
(3096275,9,0,0,0,0,1),
(3096276,16908,0,0,1,1,0),
(3096276,48298,1,0,0,0,0),
(3096276,49126,0,0,1,1,0),
(3096276,9,0,0,0,0,1),
(3096277,16908,0,0,1,1,0),
(3096277,48299,1,0,0,0,0),
(3096277,49127,0,0,1,1,0),
(3096277,9,0,0,0,0,1),
(3096278,16908,0,0,1,1,0),
(3096278,48300,1,0,0,0,0),
(3096278,49128,0,0,1,1,0),
(3096278,9,0,0,0,0,1),
(3096279,16908,0,0,1,1,0),
(3096279,48302,1,0,0,0,0),
(3096279,49130,0,0,1,1,0),
(3096279,9,0,0,0,0,1),
(3096280,16908,0,0,1,1,0),
(3096280,48303,1,0,0,0,0),
(3096280,49131,0,0,1,1,0),
(3096280,9,0,0,0,0,1),
(3096281,16901,0,0,1,1,0),
(3096281,34219,0,0,1,1,0),
(3096281,48893,0,0,1,1,0),
(3096281,49090,1,0,0,0,0),
(3096281,8,0,0,0,0,1),
(3096282,16902,0,0,1,1,0),
(3096282,34219,0,0,1,1,0),
(3096282,48900,0,0,1,1,0),
(3096282,49097,1,0,0,0,0),
(3096282,8,0,0,0,0,1),
(3096283,16902,0,0,1,1,0),
(3096283,34219,0,0,1,1,0),
(3096283,48904,0,0,1,1,0),
(3096283,49101,1,0,0,0,0),
(3096283,8,0,0,0,0,1),
(3096284,16902,0,0,1,1,0),
(3096284,34222,0,0,1,1,0),
(3096284,48894,0,0,1,1,0),
(3096284,49119,1,0,0,0,0),
(3096284,8,0,0,0,0,1),
(3096285,16901,0,0,1,1,0),
(3096285,16902,0,0,1,1,0),
(3096285,34222,0,0,1,1,0),
(3096285,48895,0,0,1,1,0),
(3096285,49120,1,0,0,0,0),
(3096285,8,0,0,0,0,1),
(3096286,16902,0,0,2,2,0),
(3096286,34222,0,0,1,1,0),
(3096286,48896,0,0,1,1,0),
(3096286,49121,1,0,0,0,0),
(3096286,8,0,0,0,0,1),
(3096287,16902,0,0,3,3,0),
(3096287,34222,0,0,1,1,0),
(3096287,48897,0,0,1,1,0),
(3096287,49122,1,0,0,0,0),
(3096287,8,0,0,0,0,1),
(3096288,16902,0,0,2,2,0),
(3096288,34222,0,0,1,1,0),
(3096288,48898,0,0,1,1,0),
(3096288,49123,1,0,0,0,0),
(3096288,8,0,0,0,0,1),
(3096289,16902,0,0,1,1,0),
(3096289,34222,0,0,1,1,0),
(3096289,48901,0,0,1,1,0),
(3096289,49126,1,0,0,0,0),
(3096289,8,0,0,0,0,1),
(3096290,16902,0,0,2,2,0),
(3096290,34222,0,0,1,1,0),
(3096290,48902,0,0,1,1,0),
(3096290,49127,1,0,0,0,0),
(3096290,8,0,0,0,0,1),
(3096291,16901,0,0,1,1,0),
(3096291,34222,0,0,1,1,0),
(3096291,48903,0,0,1,1,0),
(3096291,49128,1,0,0,0,0),
(3096291,8,0,0,0,0,1),
(3096292,16902,0,0,4,4,0),
(3096292,34222,0,0,1,1,0),
(3096292,48905,0,0,1,1,0),
(3096292,49130,1,0,0,0,0),
(3096292,8,0,0,0,0,1),
(3096293,16902,0,0,4,4,0),
(3096293,34222,0,0,1,1,0),
(3096293,48906,0,0,1,1,0),
(3096293,49131,1,0,0,0,0),
(3096293,8,0,0,0,0,1);
INSERT INTO rrc184_items (`id`,`name`) VALUES
(16901,CONVERT(0x426c6f636b206f6620436c6179 USING utf8mb4)),
(16902,CONVERT(0x4c6172676520426c6f636b206f6620436c6179 USING utf8mb4)),
(16907,CONVERT(0x5175616c69747920466972696e67205368656574 USING utf8mb4)),
(16908,CONVERT(0x48696768205175616c69747920466972696e67205368656574 USING utf8mb4)),
(34219,CONVERT(0x46696e652053696c6b USING utf8mb4)),
(34222,CONVERT(0x466c61776c6573732053696c6b USING utf8mb4)),
(48262,CONVERT(0x496e7472696361746520536d616c6c2048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(48269,CONVERT(0x496e74726963617465205370656172204865616420536861706564204d6f6c64 USING utf8mb4)),
(48273,CONVERT(0x496e7472696361746520556c616b20426c61646520536861706564204d6f6c64 USING utf8mb4)),
(48291,CONVERT(0x496e757265642048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(48292,CONVERT(0x496e75726564204c617267652048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(48293,CONVERT(0x496e7572656420426c61646520536861706564204d6f6c64 USING utf8mb4)),
(48294,CONVERT(0x496e7572656420486561767920426c61646520536861706564204d6f6c64 USING utf8mb4)),
(48295,CONVERT(0x496e7572656420417865204865616420536861706564204d6f6c64 USING utf8mb4)),
(48298,CONVERT(0x496e75726564204d616365204865616420536861706564204d6f6c64 USING utf8mb4)),
(48299,CONVERT(0x496e757265642048616d6d6572204865616420536861706564204d6f6c64 USING utf8mb4)),
(48300,CONVERT(0x496e75726564204d6574616c205772617020536861706564204d6f6c64 USING utf8mb4)),
(48302,CONVERT(0x496e75726564204c6172676520426c61646520536861706564204d6f6c64 USING utf8mb4)),
(48303,CONVERT(0x496e75726564204c6172676520417865204865616420536861706564204d6f6c64 USING utf8mb4)),
(48893,CONVERT(0x536d616c6c2048696c742043617374696e67204d6f6c6420536b65746368 USING utf8mb4)),
(48894,CONVERT(0x48696c742043617374696e67204d6f6c6420536b65746368 USING utf8mb4)),
(48895,CONVERT(0x4c617267652048696c742043617374696e67204d6f6c6420536b65746368 USING utf8mb4)),
(48896,CONVERT(0x426c61646520536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48897,CONVERT(0x486561767920426c61646520536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48898,CONVERT(0x417865204865616420536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48900,CONVERT(0x5370656172204865616420536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48901,CONVERT(0x4d616365204865616420536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48902,CONVERT(0x48616d6d6572204865616420536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48903,CONVERT(0x4d6574616c205772617020536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48904,CONVERT(0x556c616b20426c61646520536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48905,CONVERT(0x4c6172676520426c61646520536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48906,CONVERT(0x4c6172676520417865204865616420536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(49090,CONVERT(0x556e666972656420496e7472696361746520536d616c6c2048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(49097,CONVERT(0x556e666972656420496e74726963617465205370656172204865616420536861706564204d6f6c64 USING utf8mb4)),
(49101,CONVERT(0x556e666972656420496e7472696361746520556c616b20426c61646520536861706564204d6f6c64 USING utf8mb4)),
(49119,CONVERT(0x556e666972656420496e757265642048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(49120,CONVERT(0x556e666972656420496e75726564204c617267652048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(49121,CONVERT(0x556e666972656420496e7572656420426c61646520536861706564204d6f6c64 USING utf8mb4)),
(49122,CONVERT(0x556e666972656420496e7572656420486561767920426c61646520536861706564204d6f6c64 USING utf8mb4)),
(49123,CONVERT(0x556e666972656420496e7572656420417865204865616420536861706564204d6f6c64 USING utf8mb4)),
(49126,CONVERT(0x556e666972656420496e75726564204d616365204865616420536861706564204d6f6c64 USING utf8mb4)),
(49127,CONVERT(0x556e666972656420496e757265642048616d6d6572204865616420536861706564204d6f6c64 USING utf8mb4)),
(49128,CONVERT(0x556e666972656420496e75726564204d6574616c205772617020536861706564204d6f6c64 USING utf8mb4)),
(49130,CONVERT(0x556e666972656420496e75726564204c6172676520426c61646520536861706564204d6f6c64 USING utf8mb4)),
(49131,CONVERT(0x556e666972656420496e75726564204c6172676520417865204865616420536861706564204d6f6c64 USING utf8mb4));
 CREATE TEMPORARY TABLE rrc184_peer_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc184_peer_entries LIKE tradeskill_recipe_entries;
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 target database mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16901 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16902 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16907 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16908 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34219 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 60 AND `reclevel` <=> 64 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34222 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 75 AND `reclevel` <=> 79 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48262 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48269 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 15 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48273 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48291 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 15 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48292 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48293 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48294 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48295 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48298 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48299 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48300 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48302 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 3 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 5 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48303 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 3 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 5 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48893 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48894 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48895 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48896 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48897 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48898 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48900 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48901 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48902 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48903 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48904 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48905 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48906 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49090 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49097 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49101 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49119 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49120 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49121 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49122 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49123 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49126 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49127 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49128 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49130 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 3 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49131 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 3 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 native item semantics mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc184_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc184_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc184_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc184_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc184_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc184_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 output producer universe changed'; END IF;

 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc184_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc184_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 item identity/dependency mismatch'; END IF;
 IF already_present<>26 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc184_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc184_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc184_recipes q ON q.id=r.recipe_id LEFT JOIN rrc184_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc184_recipes q ON q.id=r.recipe_id)<>118 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc184_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc184_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc184_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-26 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-118 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 rollback count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc184_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc184_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc184_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc184_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc184_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc184_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC184 output producer universe changed'; END IF;
 DROP TEMPORARY TABLE rrc184_peer_entries;
 DROP TEMPORARY TABLE rrc184_peer_recipes;
 DROP TEMPORARY TABLE rrc184_entries;
 DROP TEMPORARY TABLE rrc184_recipes;
 DROP TEMPORARY TABLE rrc184_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC184' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
