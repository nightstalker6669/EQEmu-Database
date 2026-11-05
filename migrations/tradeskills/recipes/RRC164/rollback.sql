-- RRC164: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc164_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc164_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc164_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc164_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3095805,CONVERT(0x426c6f636b206f662048696768205175616c69747920537465656c20284c6172676520427269636b7329 USING utf8mb4),63,0,31,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279206f7264696e61727920696e707574207265636f6e737472756374696f6e3b205252433136342e USING utf8mb4),0,0,0,1,10,-1,NULL,NULL),
(3095806,CONVERT(0x4c6172676520427269636b206f662048696768205175616c69747920537465656c2028426c6f636b29 USING utf8mb4),63,0,26,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279206f7264696e61727920696e707574207265636f6e737472756374696f6e3b205252433136342e USING utf8mb4),0,0,0,1,10,-1,NULL,NULL),
(3095807,CONVERT(0x4c6172676520427269636b206f662048696768205175616c69747920537465656c2028536d616c6c20427269636b29 USING utf8mb4),63,0,31,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279206f7264696e61727920696e707574207265636f6e737472756374696f6e3b205252433136342e USING utf8mb4),0,0,0,1,10,-1,NULL,NULL),
(3095808,CONVERT(0x4c6172676520427269636b206f6620526566696e65642048696768205175616c697479204f72652028426c6f636b29 USING utf8mb4),63,0,26,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279206f7264696e61727920696e707574207265636f6e737472756374696f6e3b205252433136342e USING utf8mb4),0,0,0,1,10,-1,NULL,NULL),
(3095809,CONVERT(0x4c6172676520427269636b206f6620526566696e65642048696768205175616c697479204f72652028536d616c6c20427269636b29 USING utf8mb4),63,0,26,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279206f7264696e61727920696e707574207265636f6e737472756374696f6e3b205252433136342e USING utf8mb4),0,0,0,1,10,-1,NULL,NULL),
(3095810,CONVERT(0x536d616c6c20427269636b206f662048696768205175616c69747920537465656c20284c6172676520427269636b29 USING utf8mb4),63,0,26,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279206f7264696e61727920696e707574207265636f6e737472756374696f6e3b205252433136342e USING utf8mb4),0,0,0,1,10,-1,NULL,NULL),
(3095811,CONVERT(0x536d616c6c20427269636b206f662048696768205175616c69747920537465656c2028536d616c6c20506965636529 USING utf8mb4),63,0,31,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279206f7264696e61727920696e707574207265636f6e737472756374696f6e3b205252433136342e USING utf8mb4),0,0,0,1,10,-1,NULL,NULL),
(3095812,CONVERT(0x536d616c6c205069656365206f662048696768205175616c69747920537465656c2028536d616c6c20427269636b29 USING utf8mb4),63,0,26,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279206f7264696e61727920696e707574207265636f6e737472756374696f6e3b205252433136342e USING utf8mb4),0,0,0,1,10,-1,NULL,NULL),
(3095813,CONVERT(0x4c616d696e61746f7220426c6164652028536d616c6c20427269636b206f662048696768205175616c69747920537465656c29 USING utf8mb4),63,0,102,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279206f7264696e61727920696e707574207265636f6e737472756374696f6e3b205252433136342e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3095814,CONVERT(0x4c616d696e61746f7220526f6c6c65722028536d616c6c20427269636b206f662048696768205175616c69747920537465656c29 USING utf8mb4),63,0,102,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279206f7264696e61727920696e707574207265636f6e737472756374696f6e3b205252433136342e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL);
INSERT INTO rrc164_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3095805,33435,1,0,0,0,0),
(3095805,33436,0,0,3,3,0),
(3095805,63244,0,0,3,3,0),
(3095805,17,0,0,0,0,1),
(3095806,7052,1,1,1,0,0),
(3095806,33435,0,0,1,1,0),
(3095806,33436,2,0,0,0,0),
(3095806,17,0,0,0,0,1),
(3095807,33436,1,0,0,0,0),
(3095807,33437,0,0,3,3,0),
(3095807,63244,0,0,2,2,0),
(3095807,17,0,0,0,0,1),
(3095808,7052,1,1,1,0,0),
(3095808,33260,2,0,0,0,0),
(3095808,33262,0,0,1,1,0),
(3095808,17,0,0,0,0,1),
(3095809,13006,0,0,1,1,0),
(3095809,33260,1,0,0,0,0),
(3095809,33261,0,0,3,3,0),
(3095809,17,0,0,0,0,1),
(3095810,7052,1,1,1,0,0),
(3095810,33436,0,0,1,1,0),
(3095810,33437,2,0,0,0,0),
(3095810,17,0,0,0,0,1),
(3095811,33437,1,0,0,0,0),
(3095811,33438,0,0,3,3,0),
(3095811,63244,0,0,1,1,0),
(3095811,17,0,0,0,0,1),
(3095812,7052,1,1,1,0,0),
(3095812,33437,0,0,1,1,0),
(3095812,33438,2,0,0,0,0),
(3095812,17,0,0,0,0,1),
(3095813,12011,1,1,1,0,0),
(3095813,13006,0,0,1,1,0),
(3095813,22075,0,0,1,1,0),
(3095813,33437,0,0,1,1,0),
(3095813,96488,1,0,0,0,0),
(3095813,17,0,0,0,0,1),
(3095814,10489,1,1,1,0,0),
(3095814,13006,0,0,1,1,0),
(3095814,33437,0,0,1,1,0),
(3095814,96489,1,0,0,0,0),
(3095814,17,0,0,0,0,1);
INSERT INTO rrc164_items (`id`,`name`) VALUES
(7052,CONVERT(0x536d697468696e672043686973656c USING utf8mb4)),
(10489,CONVERT(0x536d697468792048616d6d6572 USING utf8mb4)),
(12011,CONVERT(0x46696c65 USING utf8mb4)),
(13006,CONVERT(0x576174657220466c61736b USING utf8mb4)),
(22075,CONVERT(0x5468696e20426c616465204d6f6c64 USING utf8mb4)),
(33260,CONVERT(0x4c6172676520427269636b206f6620526566696e65642048696768205175616c697479204f7265 USING utf8mb4)),
(33261,CONVERT(0x536d616c6c20427269636b206f6620526566696e65642048696768205175616c697479204f7265 USING utf8mb4)),
(33262,CONVERT(0x426c6f636b206f6620526566696e65642048696768205175616c697479204f7265 USING utf8mb4)),
(33435,CONVERT(0x426c6f636b206f662048696768205175616c69747920537465656c USING utf8mb4)),
(33436,CONVERT(0x4c6172676520427269636b206f662048696768205175616c69747920537465656c USING utf8mb4)),
(33437,CONVERT(0x536d616c6c20427269636b206f662048696768205175616c69747920537465656c USING utf8mb4)),
(33438,CONVERT(0x536d616c6c205069656365206f662048696768205175616c69747920537465656c USING utf8mb4)),
(63244,CONVERT(0x476e6f6d697368204865617420536f75726365 USING utf8mb4)),
(96488,CONVERT(0x4c616d696e61746f7220426c616465 USING utf8mb4)),
(96489,CONVERT(0x4c616d696e61746f7220526f6c6c6572 USING utf8mb4));
 CREATE TEMPORARY TABLE rrc164_peer_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc164_peer_entries LIKE tradeskill_recipe_entries;
INSERT INTO rrc164_peer_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3091641,CONVERT(0x436f6d706f7369746520547265616e74204c616d696e61746520426f777374617665 USING utf8mb4),64,0,355,0,0,CONVERT(0x446f44482f506f523b20455154432061727469636c65733334382f3337313b20466c65746368696e673b205252433032362e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3091642,CONVERT(0x436f6d706f7369746520547265616e74204c616d696e617465205265637572766520426f777374617665 USING utf8mb4),64,0,408,0,0,CONVERT(0x446f44482f506f523b20455154432061727469636c65733334382f3337313b20466c65746368696e673b205252433032362e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3091645,CONVERT(0x4465736963636174656420547265616e74204c616d696e617465 USING utf8mb4),64,0,140,0,0,CONVERT(0x446f44482f506f523b20455154432061727469636c65733334382f3337313b20466c65746368696e673b205252433032362e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3091646,CONVERT(0x4465736963636174656420547265616e74204c616d696e617465 USING utf8mb4),64,0,140,0,0,CONVERT(0x446f44482f506f523b20455154432061727469636c65733334382f3337313b20466c65746368696e673b205252433032362e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3091647,CONVERT(0x4465736963636174656420547265616e74204c616d696e61746520426f777374617665 USING utf8mb4),64,0,328,0,0,CONVERT(0x446f44482f506f523b20455154432061727469636c65733334382f3337313b20466c65746368696e673b205252433032362e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3091648,CONVERT(0x4465736963636174656420547265616e74204c616d696e617465205265637572766520426f777374617665 USING utf8mb4),64,0,348,0,0,CONVERT(0x446f44482f506f523b20455154432061727469636c65733334382f3337313b20466c65746368696e673b205252433032362e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3091652,CONVERT(0x4f616b20547265616e74204c616d696e617465 USING utf8mb4),64,0,127,0,0,CONVERT(0x446f44482f506f523b20455154432061727469636c65733334382f3337313b20466c65746368696e673b205252433032362e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3091653,CONVERT(0x4f616b20547265616e74204c616d696e617465 USING utf8mb4),64,0,127,0,0,CONVERT(0x446f44482f506f523b20455154432061727469636c65733334382f3337313b20466c65746368696e673b205252433032362e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3091654,CONVERT(0x4f616b20547265616e74204c616d696e61746520426f777374617665 USING utf8mb4),64,0,302,0,0,CONVERT(0x446f44482f506f523b20455154432061727469636c65733334382f3337313b20466c65746368696e673b205252433032362e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3091655,CONVERT(0x4f616b20547265616e74204c616d696e617465205265637572766520426f777374617665 USING utf8mb4),64,0,322,0,0,CONVERT(0x446f44482f506f523b20455154432061727469636c65733334382f3337313b20466c65746368696e673b205252433032362e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3091659,CONVERT(0x537570706c6520547265616e74204c616d696e617465 USING utf8mb4),64,0,100,0,0,CONVERT(0x446f44482f506f523b20455154432061727469636c65733334382f3337313b20466c65746368696e673b205252433032362e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3091660,CONVERT(0x537570706c6520547265616e74204c616d696e617465 USING utf8mb4),64,0,100,0,0,CONVERT(0x446f44482f506f523b20455154432061727469636c65733334382f3337313b20466c65746368696e673b205252433032362e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3091661,CONVERT(0x537570706c6520547265616e74204c616d696e61746520426f777374617665 USING utf8mb4),64,0,282,0,0,CONVERT(0x446f44482f506f523b20455154432061727469636c65733334382f3337313b20466c65746368696e673b205252433032362e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3091662,CONVERT(0x537570706c6520547265616e74204c616d696e617465205265637572766520426f777374617665 USING utf8mb4),64,0,302,0,0,CONVERT(0x446f44482f506f523b20455154432061727469636c65733334382f3337313b20466c65746368696e673b205252433032362e USING utf8mb4),0,0,0,1,11,-1,NULL,NULL),
(3091675,CONVERT(0x4c6172676520427269636b206f662048696768205175616c69747920537465656c USING utf8mb4),63,0,42,0,0,CONVERT(0x446f44483b20455154432061727469636c65733335302f3335313b20536d697468696e672f5461696c6f72696e673b205252433032372e USING utf8mb4),0,0,0,1,10,-1,NULL,NULL),
(3091695,CONVERT(0x536d616c6c20427269636b206f662048696768205175616c69747920537465656c2028536d616c6c20427269636b29 USING utf8mb4),63,0,41,0,0,CONVERT(0x446f44483b20455154432061727469636c65733335302f3335313b20536d697468696e672f5461696c6f72696e673b205252433032372e USING utf8mb4),0,0,0,1,10,-1,NULL,NULL);
INSERT INTO rrc164_peer_entries (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(30408262,3091641,96504,1,0,0,0,0),
(30408263,3091641,96536,0,0,1,1,0),
(30408264,3091641,96499,0,0,1,1,0),
(30408265,3091641,96492,1,1,1,0,0),
(30408266,3091641,96489,1,1,1,0,0),
(30408267,3091641,96498,0,0,1,1,0),
(30408268,3091641,96500,0,0,2,2,0),
(30408269,3091641,18,0,0,0,0,1),
(30408270,3091642,96508,1,0,0,0,0),
(30408271,3091642,96536,0,0,1,1,0),
(30408272,3091642,96499,0,0,1,1,0),
(30408273,3091642,96492,1,1,1,0,0),
(30408274,3091642,96489,2,2,2,0,0),
(30408275,3091642,96498,0,0,1,1,0),
(30408276,3091642,96500,0,0,2,2,0),
(30408277,3091642,18,0,0,0,0,1),
(30408286,3091645,96499,2,0,0,0,0),
(30408287,3091645,97226,0,0,1,1,0),
(30408288,3091645,96492,1,1,1,0,0),
(30408289,3091645,96488,1,1,1,0,0),
(30408290,3091645,18,0,0,0,0,1),
(30408291,3091646,96499,2,0,0,0,0),
(30408292,3091646,97057,0,0,1,1,0),
(30408293,3091646,96492,1,1,1,0,0),
(30408294,3091646,96488,1,1,1,0,0),
(30408295,3091646,18,0,0,0,0,1),
(30408296,3091647,96502,1,0,0,0,0),
(30408297,3091647,96499,0,0,3,3,0),
(30408298,3091647,96492,1,1,1,0,0),
(30408299,3091647,96489,1,1,1,0,0),
(30408300,3091647,96535,0,0,1,1,0),
(30408301,3091647,18,0,0,0,0,1),
(30408302,3091648,96506,1,0,0,0,0),
(30408303,3091648,96499,0,0,3,3,0),
(30408304,3091648,96492,1,1,1,0,0),
(30408305,3091648,96489,2,2,2,0,0),
(30408306,3091648,96535,0,0,1,1,0),
(30408307,3091648,18,0,0,0,0,1),
(30408322,3091652,96498,2,0,0,0,0),
(30408323,3091652,96492,1,1,1,0,0),
(30408324,3091652,96488,1,1,1,0,0),
(30408325,3091652,97053,0,0,1,1,0),
(30408326,3091652,18,0,0,0,0,1),
(30408327,3091653,96498,2,0,0,0,0),
(30408328,3091653,97225,0,0,1,1,0),
(30408329,3091653,96492,1,1,1,0,0),
(30408330,3091653,96488,1,1,1,0,0),
(30408331,3091653,18,0,0,0,0,1),
(30408332,3091654,96501,1,0,0,0,0),
(30408333,3091654,96492,1,1,1,0,0),
(30408334,3091654,96489,1,1,1,0,0),
(30408335,3091654,96498,0,0,3,3,0),
(30408336,3091654,96535,0,0,1,1,0),
(30408337,3091654,18,0,0,0,0,1),
(30408338,3091654,17768,0,0,0,0,1),
(30408339,3091655,96505,1,0,0,0,0),
(30408340,3091655,96492,1,1,1,0,0),
(30408341,3091655,96489,2,2,2,0,0),
(30408342,3091655,96498,0,0,3,3,0),
(30408343,3091655,96535,0,0,1,1,0),
(30408344,3091655,18,0,0,0,0,1),
(30408357,3091659,96500,2,0,0,0,0),
(30408358,3091659,96492,1,1,1,0,0),
(30408359,3091659,96488,1,1,1,0,0),
(30408360,3091659,97060,0,0,1,1,0),
(30408361,3091659,18,0,0,0,0,1),
(30408362,3091660,96500,2,0,0,0,0),
(30408363,3091660,97227,0,0,1,1,0),
(30408364,3091660,96492,1,1,1,0,0),
(30408365,3091660,96488,1,1,1,0,0),
(30408366,3091660,18,0,0,0,0,1),
(30408367,3091661,96503,1,0,0,0,0),
(30408368,3091661,96492,1,1,1,0,0),
(30408369,3091661,96489,1,1,1,0,0),
(30408370,3091661,96500,0,0,3,3,0),
(30408371,3091661,96535,0,0,1,1,0),
(30408372,3091661,18,0,0,0,0,1),
(30408373,3091662,96507,1,0,0,0,0),
(30408374,3091662,96492,1,1,1,0,0),
(30408375,3091662,96489,2,2,2,0,0),
(30408376,3091662,96500,0,0,3,3,0),
(30408377,3091662,96535,0,0,1,1,0),
(30408378,3091662,18,0,0,0,0,1),
(30408664,3091675,33436,1,0,0,0,0),
(30408665,3091675,63244,0,0,6,6,0),
(30408666,3091675,93664,0,0,3,3,0),
(30408667,3091675,33260,0,0,1,1,0),
(30408668,3091675,17,0,0,0,0,1),
(30408769,3091695,33437,1,0,0,0,0),
(30408770,3091695,63244,0,0,3,3,0),
(30408771,3091695,93664,0,0,1,1,0),
(30408772,3091695,33261,0,0,1,1,0),
(30408773,3091695,17,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 target database mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=7052 AND `itemclass` <=> 0 AND `itemtype` <=> 2 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 15773 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=10489 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=12011 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=13006 AND `itemclass` <=> 0 AND `itemtype` <=> 15 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=22075 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=33260 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=33261 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=33262 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 5 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=33435 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=33436 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=33437 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=33438 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=63244 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 25 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96488 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96489 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 native item semantics mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc164_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc164_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc164_peer_recipes p ON p.id=r.recipe_id)<>93 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc164_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc164_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc164_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 output producer universe changed'; END IF;

 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc164_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc164_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 item identity/dependency mismatch'; END IF;
 IF already_present<>10 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc164_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc164_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc164_recipes q ON q.id=r.recipe_id LEFT JOIN rrc164_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc164_recipes q ON q.id=r.recipe_id)<>43 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc164_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc164_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc164_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-10 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-43 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 rollback count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc164_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc164_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc164_peer_recipes p ON p.id=r.recipe_id)<>93 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc164_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc164_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc164_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC164 output producer universe changed'; END IF;
 DROP TEMPORARY TABLE rrc164_peer_entries;
 DROP TEMPORARY TABLE rrc164_peer_recipes;
 DROP TEMPORARY TABLE rrc164_entries;
 DROP TEMPORARY TABLE rrc164_recipes;
 DROP TEMPORARY TABLE rrc164_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC164' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
