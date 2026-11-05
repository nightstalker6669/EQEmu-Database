-- RRC200: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc200_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc200_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc200_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc200_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3096597,CONVERT(0x4361736b206f6620576f726d2057696e65 USING utf8mb4),65,0,15,1,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204f6f5720576f726d2057696e65206361736b207265636f6e737472756374696f6e3b205252433230302e USING utf8mb4),0,0,0,1,8,-1,NULL,NULL);
INSERT INTO rrc200_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3096597,16580,0,0,1,1,0),
(3096597,16598,8,0,0,0,0),
(3096597,16851,8,0,0,0,0),
(3096597,75804,0,0,8,8,0),
(3096597,75810,8,0,0,0,0),
(3096597,19,0,0,0,0,1);
INSERT INTO rrc200_items (`id`,`name`) VALUES
(16580,CONVERT(0x4361736b USING utf8mb4)),
(16598,CONVERT(0x426f74746c65 USING utf8mb4)),
(16851,CONVERT(0x436f726b USING utf8mb4)),
(75804,CONVERT(0x426f74746c65206f6620576f726d2057696e65 USING utf8mb4)),
(75810,CONVERT(0x4361736b206f6620576f726d2057696e65 USING utf8mb4));
 CREATE TEMPORARY TABLE rrc200_peer_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc200_peer_entries LIKE tradeskill_recipe_entries;
INSERT INTO rrc200_peer_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(1288,CONVERT(0x466f726d656420456e736e6172696e6720436f6e636f6374696f6e2056 USING utf8mb4),59,0,41,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7563,CONVERT(0x41204361736b204f66204167656420426c6f6f6477696e65 USING utf8mb4),65,0,255,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7564,CONVERT(0x41204361736b204f6620416c646f27732042697474657220416c65 USING utf8mb4),65,0,15,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7565,CONVERT(0x41204361736b204f6620416c646f277320446561642046726f672057696e65 USING utf8mb4),65,0,15,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7566,CONVERT(0x41204361736b204f66204265652042656572 USING utf8mb4),65,0,15,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7567,CONVERT(0x41204361736b204f66204461726b656e65642046756e6775732057696e65 USING utf8mb4),65,0,255,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7568,CONVERT(0x41204361736b204f66204465736572742044727920416c65 USING utf8mb4),65,0,255,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7569,CONVERT(0x41204361736b204f662044697374696c6c6564205377616d70726f6f7420506f6e647761746572 USING utf8mb4),65,0,255,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7570,CONVERT(0x41204361736b204f6620446f75626c6520427265776564204f72636973682053746f7574 USING utf8mb4),65,0,15,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7571,CONVERT(0x41204361736b204f66204963652042726577656420416c65 USING utf8mb4),65,0,255,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7572,CONVERT(0x41204361736b204f6620496365642057686974652057696e65 USING utf8mb4),65,0,255,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7573,CONVERT(0x41204361736b204f662053746f6e65776f6f6420416c65 USING utf8mb4),65,0,15,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7660,CONVERT(0x4661796477657220506f72746572 USING utf8mb4),65,0,68,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7663,CONVERT(0x46617964776572205368616b6572 USING utf8mb4),65,0,188,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7755,CONVERT(0x4d696e6f74617572204865726f27732042726577 USING utf8mb4),65,0,248,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7785,CONVERT(0x52656420506f72746572 USING utf8mb4),65,0,68,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7787,CONVERT(0x526f20506f72746572 USING utf8mb4),65,0,68,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(7803,CONVERT(0x536b756e6b2042726561746820416c65 USING utf8mb4),65,0,155,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7855,CONVERT(0x556e646572666f6f742042726f776e USING utf8mb4),65,0,168,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(27868,CONVERT(0x4361736b206f662045787472612044727920416c65 USING utf8mb4),65,0,15,1,0,'',0,0,0,1,-1,-1,NULL,NULL),
(3093226,CONVERT(0x4472696e6b206f662054696d656c65737320456e6572677920284669726529 USING utf8mb4),65,0,400,0,0,CONVERT(0x536f442d55462d486f542d566f413b207072696d6172792042726577696e673b205252433035342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3093227,CONVERT(0x4472696e6b206f662054696d656c65737320456e657267792028576174657229 USING utf8mb4),65,0,400,0,0,CONVERT(0x536f442d55462d486f542d566f413b207072696d6172792042726577696e673b205252433035342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3093228,CONVERT(0x4472696e6b206f662054696d656c65737320456e657267792028456172746829 USING utf8mb4),65,0,400,0,0,CONVERT(0x536f442d55462d486f542d566f413b207072696d6172792042726577696e673b205252433035342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3093229,CONVERT(0x4472696e6b206f662054696d656c65737320456e65726779202841697229 USING utf8mb4),65,0,400,0,0,CONVERT(0x536f442d55462d486f542d566f413b207072696d6172792042726577696e673b205252433035342e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL);
INSERT INTO rrc200_peer_entries (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(9988,1288,45232,0,0,1,1,0),
(9989,1288,45236,0,0,1,1,0),
(9990,1288,10062,1,0,0,0,0),
(9991,1288,16851,1,0,0,0,0),
(9992,1288,45258,1,0,0,0,0),
(9993,1288,17770,0,0,0,0,1),
(9994,1288,17771,0,0,0,0,1),
(9995,1288,17811,0,0,0,0,1),
(9996,1288,17901,0,0,0,0,1),
(71239,7563,51163,0,0,8,8,0),
(71240,7563,16580,0,0,1,1,0),
(71241,7563,16598,8,0,0,0,0),
(71242,7563,16851,8,0,0,0,0),
(71243,7563,51164,1,0,0,0,0),
(71244,7563,19,0,0,0,0,1),
(71245,7564,75805,0,0,8,8,0),
(71246,7564,16580,0,0,1,1,0),
(71247,7564,16598,8,0,0,0,0),
(71248,7564,16851,8,0,0,0,0),
(71249,7564,75811,1,0,0,0,0),
(71250,7564,19,0,0,0,0,1),
(71251,7565,75809,0,0,8,8,0),
(71252,7565,16580,0,0,1,1,0),
(71253,7565,16598,8,0,0,0,0),
(71254,7565,16851,8,0,0,0,0),
(71255,7565,75816,1,0,0,0,0),
(71256,7565,19,0,0,0,0,1),
(71257,7566,75807,0,0,8,8,0),
(71258,7566,16580,0,0,1,1,0),
(71259,7566,16598,8,0,0,0,0),
(71260,7566,16851,8,0,0,0,0),
(71261,7566,75813,1,0,0,0,0),
(71262,7566,19,0,0,0,0,1),
(71263,7567,51159,0,0,8,8,0),
(71264,7567,16580,0,0,1,1,0),
(71265,7567,16598,8,0,0,0,0),
(71266,7567,16851,8,0,0,0,0),
(71267,7567,51160,1,0,0,0,0),
(71268,7567,19,0,0,0,0,1),
(71269,7568,51155,0,0,8,8,0),
(71270,7568,16580,0,0,1,1,0),
(71271,7568,16598,8,0,0,0,0),
(71272,7568,16851,8,0,0,0,0),
(71273,7568,51156,1,0,0,0,0),
(71274,7568,19,0,0,0,0,1),
(71275,7569,51161,0,0,8,8,0),
(71276,7569,16580,0,0,1,1,0),
(71277,7569,16598,8,0,0,0,0),
(71278,7569,16851,8,0,0,0,0),
(71279,7569,51162,1,0,0,0,0),
(71280,7569,19,0,0,0,0,1),
(71281,7570,51153,0,0,8,8,0),
(71282,7570,16580,0,0,1,1,0),
(71283,7570,16598,8,0,0,0,0),
(71284,7570,16851,8,0,0,0,0),
(71285,7570,51154,1,0,0,0,0),
(71286,7570,19,0,0,0,0,1),
(71287,7571,51149,0,0,8,8,0),
(71288,7571,16580,0,0,1,1,0),
(71289,7571,16598,8,0,0,0,0),
(71290,7571,16851,8,0,0,0,0),
(71291,7571,51150,1,0,0,0,0),
(71292,7571,19,0,0,0,0,1),
(71293,7572,51147,0,0,8,8,0),
(71294,7572,16580,0,0,1,1,0),
(71295,7572,16598,8,0,0,0,0),
(71296,7572,16851,8,0,0,0,0),
(71297,7572,51148,1,0,0,0,0),
(71298,7572,19,0,0,0,0,1),
(71299,7573,75808,0,0,8,8,0),
(71300,7573,16580,0,0,1,1,0),
(71301,7573,16598,8,0,0,0,0),
(71302,7573,16851,8,0,0,0,0),
(71303,7573,75814,1,0,0,0,0),
(71304,7573,19,0,0,0,0,1),
(71799,7660,13035,0,0,2,2,0),
(71800,7660,13030,0,0,1,1,0),
(71801,7660,13031,0,0,1,1,0),
(71802,7660,16580,0,1,1,0,0),
(71803,7660,16598,4,4,0,0,0),
(71804,7660,19970,1,0,0,0,0),
(71807,7660,19,0,0,0,0,1),
(71822,7663,13008,0,0,1,1,0),
(71823,7663,13035,0,0,1,1,0),
(71824,7663,13036,0,0,1,1,0),
(71825,7663,13037,0,0,1,1,0),
(71826,7663,16580,0,1,1,0,0),
(71827,7663,16598,4,4,0,0,0),
(71828,7663,19966,1,0,0,0,0),
(71831,7663,19,0,0,0,0,1),
(72408,7755,16595,0,0,3,3,0),
(72409,7755,13006,0,0,2,2,0),
(72410,7755,13032,0,0,2,2,0),
(72411,7755,16580,0,1,1,0,0),
(72412,7755,16596,0,0,1,1,0),
(72413,7755,16598,2,0,0,0,0),
(72414,7755,19198,1,0,0,0,0),
(72416,7755,19,0,0,0,0,1),
(72610,7785,13030,0,0,4,4,0),
(72611,7785,16580,0,1,1,0,0),
(72612,7785,16598,4,0,0,0,0),
(72613,7785,19969,1,0,0,0,0),
(72615,7785,19,0,0,0,0,1),
(72624,7787,13030,0,0,2,2,0),
(72625,7787,13035,0,0,2,2,0),
(72626,7787,16580,0,1,1,0,0),
(72627,7787,16598,4,0,0,0,0),
(72628,7787,19971,1,0,0,0,0),
(72629,7787,19,0,0,0,0,1),
(72714,7803,14030,0,0,2,2,0),
(72715,7803,13032,0,0,1,1,0),
(72716,7803,13037,0,0,1,1,0),
(72717,7803,16580,0,1,1,0,0),
(72718,7803,16595,0,0,1,1,0),
(72719,7803,16596,0,0,1,1,0),
(72720,7803,16598,2,0,0,0,0),
(72721,7803,19187,1,0,0,0,0),
(72723,7803,19,0,0,0,0,1),
(73005,7855,19972,0,0,4,4,0),
(73006,7855,13006,0,0,1,1,0),
(73007,7855,13032,0,0,1,1,0),
(73008,7855,16580,0,1,1,0,0),
(73009,7855,16595,0,0,1,1,0),
(73010,7855,16598,1,1,0,0,0),
(73011,7855,19967,1,0,0,0,0),
(73014,7855,19,0,0,0,0,1),
(278221,27868,19,0,0,0,0,1),
(278222,27868,17763,0,0,0,0,1),
(278223,27868,17562,0,0,0,0,1),
(278224,27868,66626,0,0,0,0,1),
(278225,27868,54249,0,0,0,0,1),
(278226,27868,75806,0,0,8,0,0),
(278227,27868,16580,0,0,1,0,0),
(278228,27868,16851,8,0,0,0,0),
(278229,27868,16598,8,0,0,0,0),
(278230,27868,75812,1,0,0,0,0),
(30419626,3093226,37993,1,0,0,0,0),
(30419627,3093226,37978,1,1,1,0,0),
(30419628,3093226,37985,0,0,2,2,0),
(30419629,3093226,25842,0,0,1,1,0),
(30419630,3093226,97096,0,0,1,1,0),
(30419631,3093226,24084,0,0,1,1,0),
(30419632,3093226,97095,0,0,1,1,0),
(30419633,3093226,96916,0,0,1,1,0),
(30419634,3093226,97401,0,0,1,1,0),
(30419635,3093226,97400,0,0,1,1,0),
(30419636,3093226,16598,1,2,0,0,0),
(30419637,3093226,19,0,0,0,0,1),
(30419638,3093227,37993,1,0,0,0,0),
(30419639,3093227,37978,1,1,1,0,0),
(30419640,3093227,37985,0,0,2,2,0),
(30419641,3093227,25842,0,0,1,1,0),
(30419642,3093227,97096,0,0,1,1,0),
(30419643,3093227,24084,0,0,1,1,0),
(30419644,3093227,96916,0,0,1,1,0),
(30419645,3093227,97401,0,0,1,1,0),
(30419646,3093227,97400,0,0,1,1,0),
(30419647,3093227,97094,0,0,1,1,0),
(30419648,3093227,16598,1,2,0,0,0),
(30419649,3093227,19,0,0,0,0,1),
(30419650,3093228,37993,1,0,0,0,0),
(30419651,3093228,37978,1,1,1,0,0),
(30419652,3093228,37985,0,0,2,2,0),
(30419653,3093228,25842,0,0,1,1,0),
(30419654,3093228,97096,0,0,1,1,0),
(30419655,3093228,24084,0,0,1,1,0),
(30419656,3093228,97103,0,0,1,1,0),
(30419657,3093228,96916,0,0,1,1,0),
(30419658,3093228,97401,0,0,1,1,0),
(30419659,3093228,97400,0,0,1,1,0),
(30419660,3093228,16598,1,2,0,0,0),
(30419661,3093228,19,0,0,0,0,1),
(30419662,3093229,37993,1,0,0,0,0),
(30419663,3093229,37978,1,1,1,0,0),
(30419664,3093229,97102,0,0,1,1,0),
(30419665,3093229,37985,0,0,2,2,0),
(30419666,3093229,25842,0,0,1,1,0),
(30419667,3093229,97096,0,0,1,1,0),
(30419668,3093229,24084,0,0,1,1,0),
(30419669,3093229,96916,0,0,1,1,0),
(30419670,3093229,97401,0,0,1,1,0),
(30419671,3093229,97400,0,0,1,1,0),
(30419672,3093229,16598,1,2,0,0,0),
(30419673,3093229,19,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 target database mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16580 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16598 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16851 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 50 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=75804 AND `itemclass` <=> 0 AND `itemtype` <=> 21 AND `size` <=> 1 AND `maxcharges` <=> 1 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=75810 AND `itemclass` <=> 0 AND `itemtype` <=> 21 AND `size` <=> 2 AND `maxcharges` <=> 8 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 native item semantics mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc200_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc200_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc200_peer_recipes p ON p.id=r.recipe_id)<>184 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc200_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc200_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc200_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 output producer universe changed'; END IF;

 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc200_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc200_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 item identity/dependency mismatch'; END IF;
 IF already_present NOT IN (0,1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 partial batch or ID collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r JOIN rrc200_recipes e ON r.tradeskill=e.tradeskill AND r.name=e.name WHERE r.id<>e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 existing recipe-name collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=75804 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3096597 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=9 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=16580)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=75804)=8) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 all-state full input collision'; END IF;
 IF already_present=0 THEN
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc200_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 new ID range has learned references'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc200_recipes e ON r.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 orphan target entries collision'; END IF;
 INSERT INTO tradeskill_recipe (id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled) SELECT id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled FROM rrc200_recipes;
 INSERT INTO tradeskill_recipe_entries (recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer) SELECT recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer FROM rrc200_entries;
 END IF;
 IF EXISTS(SELECT 1 FROM rrc200_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc200_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc200_recipes q ON q.id=r.recipe_id LEFT JOIN rrc200_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc200_recipes q ON q.id=r.recipe_id)<>6 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 target entry multiplicity mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before+IF(already_present=0,1,0) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before+IF(already_present=0,6,0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 unexpected table row-count delta'; END IF;
 IF EXISTS(SELECT 1 FROM rrc200_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc200_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc200_peer_recipes p ON p.id=r.recipe_id)<>184 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc200_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc200_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc200_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 output producer universe changed'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=75804 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3096597 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=9 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=16580)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=75804)=8) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC200 all-state full input collision'; END IF;
 DROP TEMPORARY TABLE rrc200_peer_entries;
 DROP TEMPORARY TABLE rrc200_peer_recipes;
 DROP TEMPORARY TABLE rrc200_entries;
 DROP TEMPORARY TABLE rrc200_recipes;
 DROP TEMPORARY TABLE rrc200_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC200' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
