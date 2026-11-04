-- RRC098: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC098 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC098 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC098 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC098 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc098_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc098_parents LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc098_parent_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc098_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc098_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc098_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3093993,CONVERT(0x536d616c6c20426c6f6f647375636b657220547265626c6520466c79 USING utf8mb4),55,0,44,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920547265626c6520466c79207265636f6e737472756374696f6e3b205252433039382e USING utf8mb4),0,0,0,1,-1,-1,NULL,NULL),
(3093994,CONVERT(0x4a656c6c792042616e64697420547265626c6520466c79 USING utf8mb4),55,0,44,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920547265626c6520466c79207265636f6e737472756374696f6e3b205252433039382e USING utf8mb4),0,0,0,1,-1,-1,NULL,NULL);
INSERT INTO rrc098_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3093993,22714,1,0,0,0,0),
(3093993,16486,0,0,1,1,0),
(3093993,12405,0,0,1,1,0),
(3093993,22701,0,0,1,1,0),
(3093993,17048,0,0,0,0,1),
(3093993,17163,0,0,0,0,1),
(3093994,22718,1,0,0,0,0),
(3093994,13259,0,0,1,1,0),
(3093994,16486,0,0,1,1,0),
(3093994,22701,0,0,1,1,0),
(3093994,17048,0,0,0,0,1),
(3093994,17163,0,0,0,0,1);
INSERT INTO rrc098_items (`id`,`name`) VALUES
(12405,CONVERT(0x536d616c6c204d6f73717569746f2057696e67 USING utf8mb4)),
(13259,CONVERT(0x4769616e7420576173702057696e67 USING utf8mb4)),
(16486,CONVERT(0x53696c6b20546872656164 USING utf8mb4)),
(17048,CONVERT(0x5461636b6c6520426f78 USING utf8mb4)),
(17163,CONVERT(0x436f6c6c61707369626c65205461636b6c6520426f78 USING utf8mb4)),
(22701,CONVERT(0x547265626c6520486f6f6b USING utf8mb4)),
(22714,CONVERT(0x536d616c6c20426c6f6f647375636b657220547265626c6520466c79 USING utf8mb4)),
(22718,CONVERT(0x4a656c6c792042616e64697420547265626c6520466c79 USING utf8mb4));
INSERT INTO rrc098_parents (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(2,CONVERT(0x427573792042656520436972636c6520466c79 USING utf8mb4),55,0,54,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(3,CONVERT(0x42757379204265652044727920466c79 USING utf8mb4),55,0,26,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(4,CONVERT(0x427573792042656520547265626c6520466c79 USING utf8mb4),55,0,44,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5,CONVERT(0x466972652057696e6720436972636c6520466c79 USING utf8mb4),55,0,54,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(6,CONVERT(0x466972652057696e672044727920466c79 USING utf8mb4),55,0,26,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7,CONVERT(0x466972652057696e6720547265626c6520466c79 USING utf8mb4),55,0,44,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(48,CONVERT(0x4769616e7420426c6f6f647375636b657220436972636c6520466c79 USING utf8mb4),55,0,54,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(49,CONVERT(0x4769616e7420426c6f6f647375636b65722044727920466c79 USING utf8mb4),55,0,26,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(50,CONVERT(0x4769616e7420426c6f6f647375636b657220547265626c6520466c79 USING utf8mb4),55,0,44,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(70,CONVERT(0x4a656c6c792042616e64697420436972636c6520466c79 USING utf8mb4),55,0,54,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(71,CONVERT(0x4a656c6c792042616e6469742044727920466c79 USING utf8mb4),55,0,26,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(73,CONVERT(0x4e696768742053776f6f70657220436972636c6520466c79 USING utf8mb4),55,0,54,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(74,CONVERT(0x4e696768742053776f6f7065722044727920466c79 USING utf8mb4),55,0,26,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(75,CONVERT(0x4e696768742053776f6f70657220547265626c6520466c79 USING utf8mb4),55,0,44,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(133,CONVERT(0x507572706c6520547269636b7374657220436972636c6520466c79 USING utf8mb4),55,0,54,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(134,CONVERT(0x507572706c6520547269636b737465722044727920466c79 USING utf8mb4),55,0,26,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(135,CONVERT(0x507572706c6520547269636b7374657220547265626c6520466c79 USING utf8mb4),55,0,44,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(136,CONVERT(0x53637265656368696e6720436972636c6520466c79 USING utf8mb4),55,0,54,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(137,CONVERT(0x53637265656368696e672044727920466c79 USING utf8mb4),55,0,26,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(138,CONVERT(0x53637265656368696e6720547265626c6520466c79 USING utf8mb4),55,0,44,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(139,CONVERT(0x5368696d6d6572696e6720476f7373616d657220436972636c6520466c79 USING utf8mb4),55,0,54,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(140,CONVERT(0x5368696d6d6572696e6720476f7373616d65722044727920466c79 USING utf8mb4),55,0,26,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(141,CONVERT(0x5368696d6d6572696e6720476f7373616d657220547265626c6520466c79 USING utf8mb4),55,0,44,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(142,CONVERT(0x536c6f62626572696e6720486f756e6420436972636c6520466c79 USING utf8mb4),55,0,54,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(143,CONVERT(0x536c6f62626572696e6720486f756e642044727920466c79 USING utf8mb4),55,0,26,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(144,CONVERT(0x536c6f62626572696e6720486f756e6420547265626c6520466c79 USING utf8mb4),55,0,44,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(145,CONVERT(0x536d616c6c20426c6f6f647375636b657220436972636c6520466c79 USING utf8mb4),55,0,54,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(146,CONVERT(0x536d616c6c20426c6f6f647375636b65722044727920466c79 USING utf8mb4),55,0,26,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(148,CONVERT(0x53717565616b696e67204e6962626c657220436972636c6520466c79 USING utf8mb4),55,0,54,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(149,CONVERT(0x53717565616b696e67204e6962626c65722044727920466c79 USING utf8mb4),55,0,26,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(150,CONVERT(0x53717565616b696e67204e6962626c657220547265626c6520466c79 USING utf8mb4),55,0,44,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(152,CONVERT(0x59617070696e20446f67677920436972636c6520466c79 USING utf8mb4),55,0,54,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(153,CONVERT(0x59617070696e20446f6767792044727920466c79 USING utf8mb4),55,0,26,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(154,CONVERT(0x59617070696e20446f67677920547265626c6520466c79 USING utf8mb4),55,0,44,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(155,CONVERT(0x59656c6c6f776a61636b657420436972636c6520466c79 USING utf8mb4),55,0,54,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(156,CONVERT(0x59656c6c6f776a61636b65742044727920466c79 USING utf8mb4),55,0,26,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(157,CONVERT(0x59656c6c6f776a61636b657420547265626c6520466c79 USING utf8mb4),55,0,44,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
INSERT INTO rrc098_parent_entries (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(9,2,13934,0,0,1,1,0),
(10,2,16486,0,0,1,1,0),
(11,2,22702,0,0,1,1,0),
(12,2,22729,1,0,0,0,0),
(13,2,17048,0,0,0,0,1),
(14,2,17163,0,0,0,0,1),
(15,3,13934,0,0,1,1,0),
(16,3,16486,0,0,1,1,0),
(17,3,22700,0,0,1,1,0),
(18,3,22711,1,0,0,0,0),
(19,3,17048,0,0,0,0,1),
(20,3,17163,0,0,0,0,1),
(21,4,13934,0,0,1,1,0),
(22,4,16486,0,0,1,1,0),
(23,4,22701,0,0,1,1,0),
(24,4,22720,1,0,0,0,0),
(25,4,17048,0,0,0,0,1),
(26,4,17163,0,0,0,0,1),
(27,5,11933,0,0,1,1,0),
(28,5,16486,0,0,1,1,0),
(29,5,22702,0,0,1,1,0),
(30,5,22721,1,0,0,0,0),
(31,5,17048,0,0,0,0,1),
(32,5,17163,0,0,0,0,1),
(33,6,11933,0,0,1,1,0),
(34,6,16486,0,0,1,1,0),
(35,6,22700,0,0,1,1,0),
(36,6,22703,1,0,0,0,0),
(37,6,17048,0,0,0,0,1),
(38,6,17163,0,0,0,0,1),
(39,7,11933,0,0,1,1,0),
(40,7,16486,0,0,1,1,0),
(41,7,22701,0,0,1,1,0),
(42,7,22712,1,0,0,0,0),
(43,7,17048,0,0,0,0,1),
(44,7,17163,0,0,0,0,1),
(430,48,11951,0,0,1,1,0),
(431,48,16486,0,0,1,1,0),
(432,48,22702,0,0,1,1,0),
(433,48,22722,1,0,0,0,0),
(434,48,17048,0,0,0,0,1),
(435,48,17163,0,0,0,0,1),
(436,49,11951,0,0,1,1,0),
(437,49,16486,0,0,1,1,0),
(438,49,22700,0,0,1,1,0),
(439,49,22704,1,0,0,0,0),
(440,49,17048,0,0,0,0,1),
(441,49,17163,0,0,0,0,1),
(442,50,11951,0,0,1,1,0),
(443,50,16486,0,0,1,1,0),
(444,50,22701,0,0,1,1,0),
(445,50,22713,1,0,0,0,0),
(446,50,17048,0,0,0,0,1),
(447,50,17163,0,0,0,0,1),
(638,70,13259,0,0,1,1,0),
(639,70,16486,0,0,1,1,0),
(640,70,22702,0,0,1,1,0),
(641,70,22727,1,0,0,0,0),
(642,70,17048,0,0,0,0,1),
(643,70,17163,0,0,0,0,1),
(644,71,13259,0,0,1,1,0),
(645,71,16486,0,0,1,1,0),
(646,71,22700,0,0,1,1,0),
(647,71,22709,1,0,0,0,0),
(648,71,17048,0,0,0,0,1),
(649,71,17163,0,0,0,0,1),
(660,73,13069,0,0,1,1,0),
(661,73,16486,0,0,1,1,0),
(662,73,22702,0,0,1,1,0),
(663,73,22743,1,0,0,0,0),
(664,73,17048,0,0,0,0,1),
(665,73,17163,0,0,0,0,1),
(666,74,13069,0,0,1,1,0),
(667,74,16486,0,0,1,1,0),
(668,74,22700,0,0,1,1,0),
(669,74,22733,1,0,0,0,0),
(670,74,17048,0,0,0,0,1),
(671,74,17163,0,0,0,0,1),
(672,75,13069,0,0,1,1,0),
(673,75,16486,0,0,1,1,0),
(674,75,22701,0,0,1,1,0),
(675,75,22738,1,0,0,0,0),
(676,75,17048,0,0,0,0,1),
(677,75,17163,0,0,0,0,1),
(1246,133,13142,0,0,1,1,0),
(1247,133,16486,0,0,1,1,0),
(1248,133,22702,0,0,1,1,0),
(1249,133,22725,1,0,0,0,0),
(1250,133,17048,0,0,0,0,1),
(1251,133,17163,0,0,0,0,1),
(1252,134,13142,0,0,1,1,0),
(1253,134,16486,0,0,1,1,0),
(1254,134,22700,0,0,1,1,0),
(1255,134,22707,1,0,0,0,0),
(1256,134,17048,0,0,0,0,1),
(1257,134,17163,0,0,0,0,1),
(1258,135,13142,0,0,1,1,0),
(1259,135,16486,0,0,1,1,0),
(1260,135,22701,0,0,1,1,0),
(1261,135,22716,1,0,0,0,0),
(1262,135,17048,0,0,0,0,1),
(1263,135,17163,0,0,0,0,1),
(1264,136,13061,0,0,1,1,0),
(1265,136,16486,0,0,1,1,0),
(1266,136,22702,0,0,1,1,0),
(1267,136,22741,1,0,0,0,0),
(1268,136,17048,0,0,0,0,1),
(1269,136,17163,0,0,0,0,1),
(1270,137,13061,0,0,1,1,0),
(1271,137,16486,0,0,1,1,0),
(1272,137,22700,0,0,1,1,0),
(1273,137,22731,1,0,0,0,0),
(1274,137,17048,0,0,0,0,1),
(1275,137,17163,0,0,0,0,1),
(1276,138,13061,0,0,1,1,0),
(1277,138,16486,0,0,1,1,0),
(1278,138,22701,0,0,1,1,0),
(1279,138,22736,1,0,0,0,0),
(1280,138,17048,0,0,0,0,1),
(1281,138,17163,0,0,0,0,1),
(1282,139,13143,0,0,1,1,0),
(1283,139,16486,0,0,1,1,0),
(1284,139,22702,0,0,1,1,0),
(1285,139,22726,1,0,0,0,0),
(1286,139,17048,0,0,0,0,1),
(1287,139,17163,0,0,0,0,1),
(1288,140,13143,0,0,1,1,0),
(1289,140,16486,0,0,1,1,0),
(1290,140,22700,0,0,1,1,0),
(1291,140,22708,1,0,0,0,0),
(1292,140,17048,0,0,0,0,1),
(1293,140,17163,0,0,0,0,1),
(1294,141,13143,0,0,1,1,0),
(1295,141,16486,0,0,1,1,0),
(1296,141,22701,0,0,1,1,0),
(1297,141,22717,1,0,0,0,0),
(1298,141,17048,0,0,0,0,1),
(1299,141,17163,0,0,0,0,1),
(1300,142,16486,0,0,1,1,0),
(1301,142,22702,0,0,1,1,0),
(1302,142,30025,0,0,1,1,0),
(1303,142,22744,1,0,0,0,0),
(1304,142,17048,0,0,0,0,1),
(1305,142,17163,0,0,0,0,1),
(1306,143,16486,0,0,1,1,0),
(1307,143,22700,0,0,1,1,0),
(1308,143,30025,0,0,1,1,0),
(1309,143,22734,1,0,0,0,0),
(1310,143,17048,0,0,0,0,1),
(1311,143,17163,0,0,0,0,1),
(1312,144,16486,0,0,1,1,0),
(1313,144,22701,0,0,1,1,0),
(1314,144,30025,0,0,1,1,0),
(1315,144,22739,1,0,0,0,0),
(1316,144,17048,0,0,0,0,1),
(1317,144,17163,0,0,0,0,1),
(1318,145,12405,0,0,1,1,0),
(1319,145,16486,0,0,1,1,0),
(1320,145,22702,0,0,1,1,0),
(1321,145,22723,1,0,0,0,0),
(1322,145,17048,0,0,0,0,1),
(1323,145,17163,0,0,0,0,1),
(1324,146,12405,0,0,1,1,0),
(1325,146,16486,0,0,1,1,0),
(1326,146,22700,0,0,1,1,0),
(1327,146,22705,1,0,0,0,0),
(1328,146,17048,0,0,0,0,1),
(1329,146,17163,0,0,0,0,1),
(1334,148,13064,0,0,1,1,0),
(1335,148,16486,0,0,1,1,0),
(1336,148,22702,0,0,1,1,0),
(1337,148,22742,1,0,0,0,0),
(1338,148,17048,0,0,0,0,1),
(1339,148,17163,0,0,0,0,1),
(1340,149,13064,0,0,1,1,0),
(1341,149,16486,0,0,1,1,0),
(1342,149,22700,0,0,1,1,0),
(1343,149,22732,1,0,0,0,0),
(1344,149,17048,0,0,0,0,1),
(1345,149,17163,0,0,0,0,1),
(1346,150,13064,0,0,1,1,0),
(1347,150,16486,0,0,1,1,0),
(1348,150,22701,0,0,1,1,0),
(1349,150,22737,1,0,0,0,0),
(1350,150,17048,0,0,0,0,1),
(1351,150,17163,0,0,0,0,1),
(1362,152,13025,0,0,1,1,0),
(1363,152,16486,0,0,1,1,0),
(1364,152,22702,0,0,1,1,0),
(1365,152,22740,1,0,0,0,0),
(1366,152,17048,0,0,0,0,1),
(1367,152,17163,0,0,0,0,1),
(1368,153,13025,0,0,1,1,0),
(1369,153,16486,0,0,1,1,0),
(1370,153,22700,0,0,1,1,0),
(1371,153,22730,1,0,0,0,0),
(1372,153,17048,0,0,0,0,1),
(1373,153,17163,0,0,0,0,1),
(1374,154,13025,0,0,1,1,0),
(1375,154,16486,0,0,1,1,0),
(1376,154,22701,0,0,1,1,0),
(1377,154,22735,1,0,0,0,0),
(1378,154,17048,0,0,0,0,1),
(1379,154,17163,0,0,0,0,1),
(1380,155,13141,0,0,1,1,0),
(1381,155,16486,0,0,1,1,0),
(1382,155,22702,0,0,1,1,0),
(1383,155,22724,1,0,0,0,0),
(1384,155,17048,0,0,0,0,1),
(1385,155,17163,0,0,0,0,1),
(1386,156,13141,0,0,1,1,0),
(1387,156,16486,0,0,1,1,0),
(1388,156,22700,0,0,1,1,0),
(1389,156,22706,1,0,0,0,0),
(1390,156,17048,0,0,0,0,1),
(1391,156,17163,0,0,0,0,1),
(1392,157,13141,0,0,1,1,0),
(1393,157,16486,0,0,1,1,0),
(1394,157,22701,0,0,1,1,0),
(1395,157,22715,1,0,0,0,0),
(1396,157,17048,0,0,0,0,1),
(1397,157,17163,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF EXISTS(SELECT 1 FROM rrc098_parents e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC098 existing Fishing recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc098_parent_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc098_parents p ON p.id=r.recipe_id)<>222 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC098 existing Fishing entries drift'; END IF;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc098_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc098_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC098 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=12405 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC098 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=13259 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC098 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=16486 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC098 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=17048 AND `size` <=> 2 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `maxcharges` <=> 0 AND `bagtype` <=> 46 AND `bagslots` <=> 6 AND `bagsize` <=> 2 AND `classes` <=> 65535)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC098 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=17163 AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `maxcharges` <=> 0 AND `bagtype` <=> 46 AND `bagslots` <=> 6 AND `bagsize` <=> 3 AND `classes` <=> 65535)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC098 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=22701 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC098 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=22714 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 37 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC098 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=22718 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 37 AND `stackable` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC098 native item semantics mismatch'; END IF;
 IF already_present<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC098 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc098_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC098 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc098_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC098 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc098_recipes q ON q.id=r.recipe_id LEFT JOIN rrc098_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC098 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc098_recipes q ON q.id=r.recipe_id)<>12 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC098 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc098_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC098 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc098_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc098_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-2 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-12 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC098 rollback count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc098_parents e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC098 existing Fishing recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc098_parent_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc098_parents p ON p.id=r.recipe_id)<>222 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC098 existing Fishing entries drift'; END IF;
 DROP TEMPORARY TABLE rrc098_parents;
 DROP TEMPORARY TABLE rrc098_parent_entries;
 DROP TEMPORARY TABLE rrc098_entries;
 DROP TEMPORARY TABLE rrc098_recipes;
 DROP TEMPORARY TABLE rrc098_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC098' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
