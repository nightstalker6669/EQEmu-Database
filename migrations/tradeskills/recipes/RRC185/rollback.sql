-- RRC185: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc185_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc185_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc185_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc185_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3096294,CONVERT(0x4f726e6174652048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138352e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096295,CONVERT(0x4f726e617465204c617267652048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138352e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096296,CONVERT(0x4f726e61746520426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138352e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096297,CONVERT(0x4f726e61746520486561767920426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138352e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096298,CONVERT(0x4f726e61746520417865204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138352e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096299,CONVERT(0x4f726e617465204d616365204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138352e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096300,CONVERT(0x4f726e6174652048616d6d6572204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138352e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096301,CONVERT(0x4f726e617465204c6172676520426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138352e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096302,CONVERT(0x4f726e617465204c6172676520417865204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138352e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096303,CONVERT(0x496e7572656420536d616c6c2048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138352e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096304,CONVERT(0x496e7572656420536d616c6c20426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138352e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096305,CONVERT(0x496e75726564205370656172204865616420536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138352e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096306,CONVERT(0x496e7572656420556c616b20426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138352e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096307,CONVERT(0x556e6669726564204f726e6174652048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,104,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138352e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096308,CONVERT(0x556e6669726564204f726e617465204c617267652048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,104,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138352e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096309,CONVERT(0x556e6669726564204f726e61746520426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,107,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138352e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096310,CONVERT(0x556e6669726564204f726e61746520486561767920426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,107,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138352e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096311,CONVERT(0x556e6669726564204f726e61746520417865204865616420536861706564204d6f6c64 USING utf8mb4),69,0,108,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138352e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096312,CONVERT(0x556e6669726564204f726e617465204d616365204865616420536861706564204d6f6c64 USING utf8mb4),69,0,104,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138352e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096313,CONVERT(0x556e6669726564204f726e6174652048616d6d6572204865616420536861706564204d6f6c64 USING utf8mb4),69,0,104,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138352e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096314,CONVERT(0x556e6669726564204f726e617465204c6172676520426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,108,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138352e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096315,CONVERT(0x556e6669726564204f726e617465204c6172676520417865204865616420536861706564204d6f6c64 USING utf8mb4),69,0,110,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138352e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096316,CONVERT(0x556e666972656420496e7572656420536d616c6c2048696c742043617374696e67204d6f6c64 USING utf8mb4),69,0,242,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138352e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096317,CONVERT(0x556e666972656420496e7572656420536d616c6c20426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,244,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138352e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096318,CONVERT(0x556e666972656420496e75726564205370656172204865616420536861706564204d6f6c64 USING utf8mb4),69,0,244,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138352e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096319,CONVERT(0x556e666972656420496e7572656420556c616b20426c61646520536861706564204d6f6c64 USING utf8mb4),69,0,244,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44206d6f6c642070616972207265636f6e737472756374696f6e3b205252433138352e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL);
INSERT INTO rrc185_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3096294,16906,0,0,1,1,0),
(3096294,48249,1,0,0,0,0),
(3096294,49077,0,0,1,1,0),
(3096294,9,0,0,0,0,1),
(3096295,16906,0,0,1,1,0),
(3096295,48250,1,0,0,0,0),
(3096295,49078,0,0,1,1,0),
(3096295,9,0,0,0,0,1),
(3096296,16906,0,0,1,1,0),
(3096296,48251,1,0,0,0,0),
(3096296,49079,0,0,1,1,0),
(3096296,9,0,0,0,0,1),
(3096297,16906,0,0,1,1,0),
(3096297,48252,1,0,0,0,0),
(3096297,49080,0,0,1,1,0),
(3096297,9,0,0,0,0,1),
(3096298,16906,0,0,1,1,0),
(3096298,48253,1,0,0,0,0),
(3096298,49081,0,0,1,1,0),
(3096298,9,0,0,0,0,1),
(3096299,16906,0,0,1,1,0),
(3096299,48256,1,0,0,0,0),
(3096299,49084,0,0,1,1,0),
(3096299,9,0,0,0,0,1),
(3096300,16906,0,0,1,1,0),
(3096300,48257,1,0,0,0,0),
(3096300,49085,0,0,1,1,0),
(3096300,9,0,0,0,0,1),
(3096301,16906,0,0,1,1,0),
(3096301,48260,1,0,0,0,0),
(3096301,49088,0,0,1,1,0),
(3096301,9,0,0,0,0,1),
(3096302,16906,0,0,1,1,0),
(3096302,48261,1,0,0,0,0),
(3096302,49089,0,0,1,1,0),
(3096302,9,0,0,0,0,1),
(3096303,16908,0,0,1,1,0),
(3096303,48290,1,0,0,0,0),
(3096303,49118,0,0,1,1,0),
(3096303,9,0,0,0,0,1),
(3096304,16908,0,0,1,1,0),
(3096304,48296,1,0,0,0,0),
(3096304,49124,0,0,1,1,0),
(3096304,9,0,0,0,0,1),
(3096305,16908,0,0,1,1,0),
(3096305,48297,1,0,0,0,0),
(3096305,49125,0,0,1,1,0),
(3096305,9,0,0,0,0,1),
(3096306,16908,0,0,1,1,0),
(3096306,48301,1,0,0,0,0),
(3096306,49129,0,0,1,1,0),
(3096306,9,0,0,0,0,1),
(3096307,16902,0,0,1,1,0),
(3096307,34216,0,0,1,1,0),
(3096307,48894,0,0,1,1,0),
(3096307,49077,1,0,0,0,0),
(3096307,8,0,0,0,0,1),
(3096308,16901,0,0,1,1,0),
(3096308,16902,0,0,1,1,0),
(3096308,34216,0,0,1,1,0),
(3096308,48895,0,0,1,1,0),
(3096308,49078,1,0,0,0,0),
(3096308,8,0,0,0,0,1),
(3096309,16902,0,0,2,2,0),
(3096309,34216,0,0,1,1,0),
(3096309,48896,0,0,1,1,0),
(3096309,49079,1,0,0,0,0),
(3096309,8,0,0,0,0,1),
(3096310,16902,0,0,3,3,0),
(3096310,34216,0,0,1,1,0),
(3096310,48897,0,0,1,1,0),
(3096310,49080,1,0,0,0,0),
(3096310,8,0,0,0,0,1),
(3096311,16902,0,0,2,2,0),
(3096311,34216,0,0,1,1,0),
(3096311,48898,0,0,1,1,0),
(3096311,49081,1,0,0,0,0),
(3096311,8,0,0,0,0,1),
(3096312,16902,0,0,1,1,0),
(3096312,34216,0,0,1,1,0),
(3096312,48901,0,0,1,1,0),
(3096312,49084,1,0,0,0,0),
(3096312,8,0,0,0,0,1),
(3096313,16902,0,0,2,2,0),
(3096313,34216,0,0,1,1,0),
(3096313,48902,0,0,1,1,0),
(3096313,49085,1,0,0,0,0),
(3096313,8,0,0,0,0,1),
(3096314,16902,0,0,4,4,0),
(3096314,34216,0,0,1,1,0),
(3096314,48905,0,0,1,1,0),
(3096314,49088,1,0,0,0,0),
(3096314,8,0,0,0,0,1),
(3096315,16902,0,0,4,4,0),
(3096315,34216,0,0,1,1,0),
(3096315,48906,0,0,1,1,0),
(3096315,49089,1,0,0,0,0),
(3096315,8,0,0,0,0,1),
(3096316,16901,0,0,1,1,0),
(3096316,34222,0,0,1,1,0),
(3096316,48893,0,0,1,1,0),
(3096316,49118,1,0,0,0,0),
(3096316,8,0,0,0,0,1),
(3096317,16902,0,0,1,1,0),
(3096317,34222,0,0,1,1,0),
(3096317,48899,0,0,1,1,0),
(3096317,49124,1,0,0,0,0),
(3096317,8,0,0,0,0,1),
(3096318,16902,0,0,1,1,0),
(3096318,34222,0,0,1,1,0),
(3096318,48900,0,0,1,1,0),
(3096318,49125,1,0,0,0,0),
(3096318,8,0,0,0,0,1),
(3096319,16902,0,0,1,1,0),
(3096319,34222,0,0,1,1,0),
(3096319,48904,0,0,1,1,0),
(3096319,49129,1,0,0,0,0),
(3096319,8,0,0,0,0,1);
INSERT INTO rrc185_items (`id`,`name`) VALUES
(16901,CONVERT(0x426c6f636b206f6620436c6179 USING utf8mb4)),
(16902,CONVERT(0x4c6172676520426c6f636b206f6620436c6179 USING utf8mb4)),
(16906,CONVERT(0x466972696e67205368656574 USING utf8mb4)),
(16908,CONVERT(0x48696768205175616c69747920466972696e67205368656574 USING utf8mb4)),
(34216,CONVERT(0x43727564652053696c6b USING utf8mb4)),
(34222,CONVERT(0x466c61776c6573732053696c6b USING utf8mb4)),
(48249,CONVERT(0x4f726e6174652048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(48250,CONVERT(0x4f726e617465204c617267652048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(48251,CONVERT(0x4f726e61746520426c61646520536861706564204d6f6c64 USING utf8mb4)),
(48252,CONVERT(0x4f726e61746520486561767920426c61646520536861706564204d6f6c64 USING utf8mb4)),
(48253,CONVERT(0x4f726e61746520417865204865616420536861706564204d6f6c64 USING utf8mb4)),
(48256,CONVERT(0x4f726e617465204d616365204865616420536861706564204d6f6c64 USING utf8mb4)),
(48257,CONVERT(0x4f726e6174652048616d6d6572204865616420536861706564204d6f6c64 USING utf8mb4)),
(48260,CONVERT(0x4f726e617465204c6172676520426c61646520536861706564204d6f6c64 USING utf8mb4)),
(48261,CONVERT(0x4f726e617465204c6172676520417865204865616420536861706564204d6f6c64 USING utf8mb4)),
(48290,CONVERT(0x496e7572656420536d616c6c2048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(48296,CONVERT(0x496e7572656420536d616c6c20426c61646520536861706564204d6f6c64 USING utf8mb4)),
(48297,CONVERT(0x496e75726564205370656172204865616420536861706564204d6f6c64 USING utf8mb4)),
(48301,CONVERT(0x496e7572656420556c616b20426c61646520536861706564204d6f6c64 USING utf8mb4)),
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
(48904,CONVERT(0x556c616b20426c61646520536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48905,CONVERT(0x4c6172676520426c61646520536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(48906,CONVERT(0x4c6172676520417865204865616420536861706564204d6f6c6420536b65746368 USING utf8mb4)),
(49077,CONVERT(0x556e6669726564204f726e6174652048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(49078,CONVERT(0x556e6669726564204f726e617465204c617267652048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(49079,CONVERT(0x556e6669726564204f726e61746520426c61646520536861706564204d6f6c64 USING utf8mb4)),
(49080,CONVERT(0x556e6669726564204f726e61746520486561767920426c61646520536861706564204d6f6c64 USING utf8mb4)),
(49081,CONVERT(0x556e6669726564204f726e61746520417865204865616420536861706564204d6f6c64 USING utf8mb4)),
(49084,CONVERT(0x556e6669726564204f726e617465204d616365204865616420536861706564204d6f6c64 USING utf8mb4)),
(49085,CONVERT(0x556e6669726564204f726e6174652048616d6d6572204865616420536861706564204d6f6c64 USING utf8mb4)),
(49088,CONVERT(0x556e6669726564204f726e617465204c6172676520426c61646520536861706564204d6f6c64 USING utf8mb4)),
(49089,CONVERT(0x556e6669726564204f726e617465204c6172676520417865204865616420536861706564204d6f6c64 USING utf8mb4)),
(49118,CONVERT(0x556e666972656420496e7572656420536d616c6c2048696c742043617374696e67204d6f6c64 USING utf8mb4)),
(49124,CONVERT(0x556e666972656420496e7572656420536d616c6c20426c61646520536861706564204d6f6c64 USING utf8mb4)),
(49125,CONVERT(0x556e666972656420496e75726564205370656172204865616420536861706564204d6f6c64 USING utf8mb4)),
(49129,CONVERT(0x556e666972656420496e7572656420556c616b20426c61646520536861706564204d6f6c64 USING utf8mb4));
 CREATE TEMPORARY TABLE rrc185_peer_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc185_peer_entries LIKE tradeskill_recipe_entries;
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 target database mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16901 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16902 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16906 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16908 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34216 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 40 AND `reclevel` <=> 49 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34222 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 75 AND `reclevel` <=> 79 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48249 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 15 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48250 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48251 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48252 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48253 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48256 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48257 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48260 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 3 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 5 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48261 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 3 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 5 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48290 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48296 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48297 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 15 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48301 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48893 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48894 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48895 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48896 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48897 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48898 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48899 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48900 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48901 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48902 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48904 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48905 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48906 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49077 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49078 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49079 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49080 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49081 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49084 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49085 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 2 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49088 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 3 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49089 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 3 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49118 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49124 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49125 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=49129 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 native item semantics mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc185_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc185_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc185_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc185_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc185_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc185_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 output producer universe changed'; END IF;

 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc185_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc185_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 item identity/dependency mismatch'; END IF;
 IF already_present<>26 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc185_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc185_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc185_recipes q ON q.id=r.recipe_id LEFT JOIN rrc185_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc185_recipes q ON q.id=r.recipe_id)<>118 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc185_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc185_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc185_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-26 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-118 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 rollback count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc185_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc185_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc185_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc185_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc185_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc185_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC185 output producer universe changed'; END IF;
 DROP TEMPORARY TABLE rrc185_peer_entries;
 DROP TEMPORARY TABLE rrc185_peer_recipes;
 DROP TEMPORARY TABLE rrc185_entries;
 DROP TEMPORARY TABLE rrc185_recipes;
 DROP TEMPORARY TABLE rrc185_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC185' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
