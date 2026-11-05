-- RRC132: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc132_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc132_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc132_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc132_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3094593,CONVERT(0x476c6f72696f757320536572766f6c696e6b65642043756972617373 USING utf8mb4),57,0,528,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f412054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133322e USING utf8mb4),1,112584,0,1,18,-1,NULL,NULL),
(3094594,CONVERT(0x476c6f72696f7573204d6574616c6f666962657220526f626573 USING utf8mb4),57,0,528,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f412054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133322e USING utf8mb4),1,112584,0,1,18,-1,NULL,NULL),
(3094595,CONVERT(0x476c6f72696f7573204175746f61637475617465642043756972617373 USING utf8mb4),57,300,528,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f412054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133322e USING utf8mb4),1,112584,0,1,18,-1,NULL,NULL),
(3094596,CONVERT(0x476c6f72696f757320536572766f6c696e6b65642047726561766573 USING utf8mb4),57,0,523,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f412054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133322e USING utf8mb4),1,112584,0,1,18,-1,NULL,NULL),
(3094597,CONVERT(0x476c6f72696f7573204d6574616c6f6669626572204272656563686573 USING utf8mb4),57,0,523,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f412054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133322e USING utf8mb4),1,112584,0,1,18,-1,NULL,NULL),
(3094598,CONVERT(0x476c6f72696f7573204175746f61637475617465642047726561766573 USING utf8mb4),57,300,523,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f412054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133322e USING utf8mb4),1,112584,0,1,18,-1,NULL,NULL),
(3094599,CONVERT(0x476c6f72696f757320536572766f6c696e6b656420426f6f7473 USING utf8mb4),57,0,512,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f412054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133322e USING utf8mb4),1,112584,0,1,18,-1,NULL,NULL),
(3094600,CONVERT(0x476c6f72696f7573204d6574616c6f666962657220426f6f7473 USING utf8mb4),57,0,512,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f412054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133322e USING utf8mb4),1,112584,0,1,18,-1,NULL,NULL),
(3094601,CONVERT(0x476c6f72696f7573204175746f616374756174656420426f6f7473 USING utf8mb4),57,300,512,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f412054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133322e USING utf8mb4),1,112584,0,1,18,-1,NULL,NULL),
(3094602,CONVERT(0x476c6f72696f757320536572766f6c696e6b656420536c6565766573 USING utf8mb4),57,0,518,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f412054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133322e USING utf8mb4),1,112584,0,1,18,-1,NULL,NULL),
(3094603,CONVERT(0x476c6f72696f7573204d6574616c6f666962657220536c6565766573 USING utf8mb4),57,0,518,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f412054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133322e USING utf8mb4),1,112584,0,1,18,-1,NULL,NULL),
(3094604,CONVERT(0x476c6f72696f7573204175746f616374756174656420536c6565766573 USING utf8mb4),57,300,518,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f412054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133322e USING utf8mb4),1,112584,0,1,18,-1,NULL,NULL),
(3094605,CONVERT(0x476c6f72696f757320536572766f6c696e6b65642041726d62616e64 USING utf8mb4),57,0,498,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f412054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133322e USING utf8mb4),1,112584,0,1,18,-1,NULL,NULL),
(3094606,CONVERT(0x476c6f72696f7573204d6574616c6f66696265722041726d62616e64 USING utf8mb4),57,0,498,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f412054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133322e USING utf8mb4),1,112584,0,1,18,-1,NULL,NULL),
(3094607,CONVERT(0x476c6f72696f7573204175746f61637475617465642041726d62616e64 USING utf8mb4),57,300,498,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f412054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133322e USING utf8mb4),1,112584,0,1,18,-1,NULL,NULL),
(3094608,CONVERT(0x476c6f72696f757320536572766f6c696e6b656420476c6f766573 USING utf8mb4),57,0,503,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f412054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133322e USING utf8mb4),1,112584,0,1,18,-1,NULL,NULL),
(3094609,CONVERT(0x476c6f72696f7573204d6574616c6f666962657220476c6f766573 USING utf8mb4),57,0,503,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f412054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133322e USING utf8mb4),1,112584,0,1,18,-1,NULL,NULL),
(3094610,CONVERT(0x476c6f72696f7573204175746f616374756174656420476c6f766573 USING utf8mb4),57,300,503,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f412054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133322e USING utf8mb4),1,112584,0,1,18,-1,NULL,NULL),
(3094611,CONVERT(0x476c6f72696f757320536572766f6c696e6b65642048656c6d USING utf8mb4),57,0,507,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f412054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133322e USING utf8mb4),1,112584,0,1,18,-1,NULL,NULL),
(3094612,CONVERT(0x476c6f72696f7573204d6574616c6f666962657220436170 USING utf8mb4),57,0,507,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f412054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133322e USING utf8mb4),1,112584,0,1,18,-1,NULL,NULL),
(3094613,CONVERT(0x476c6f72696f7573204175746f61637475617465642048656c6d USING utf8mb4),57,300,507,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920566f412054696e6b6572696e67207265636f6e737472756374696f6e3b205252433133322e USING utf8mb4),1,112584,0,1,18,-1,NULL,NULL);
INSERT INTO rrc132_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3094593,111948,1,0,0,0,0),
(3094593,16858,0,0,1,1,0),
(3094593,111929,0,0,1,1,0),
(3094593,63244,0,0,1,1,0),
(3094593,38905,0,0,1,1,0),
(3094593,112608,0,0,1,1,0),
(3094593,112473,0,0,1,1,0),
(3094593,113372,0,0,1,1,0),
(3094593,16859,0,0,1,1,0),
(3094593,13006,0,0,1,1,0),
(3094593,17877,0,0,0,0,1),
(3094594,111949,1,0,0,0,0),
(3094594,112449,0,0,1,1,0),
(3094594,112607,0,0,1,1,0),
(3094594,111913,0,0,1,1,0),
(3094594,63244,0,0,1,1,0),
(3094594,16888,0,0,1,1,0),
(3094594,38800,0,0,1,1,0),
(3094594,113373,0,0,1,1,0),
(3094594,13006,0,0,1,1,0),
(3094594,17877,0,0,0,0,1),
(3094595,111950,1,0,0,0,0),
(3094595,29513,0,0,1,1,0),
(3094595,65451,0,0,2,2,0),
(3094595,111929,0,0,1,1,0),
(3094595,63244,0,0,1,1,0),
(3094595,38905,0,0,1,1,0),
(3094595,112608,0,0,1,1,0),
(3094595,112485,0,0,1,1,0),
(3094595,113372,0,0,1,1,0),
(3094595,13006,0,0,1,1,0),
(3094595,17877,0,0,0,0,1),
(3094596,111992,1,0,0,0,0),
(3094596,16858,0,0,1,1,0),
(3094596,111929,0,0,1,1,0),
(3094596,63244,0,0,1,1,0),
(3094596,38906,0,0,1,1,0),
(3094596,112608,0,0,1,1,0),
(3094596,112480,0,0,1,1,0),
(3094596,113372,0,0,1,1,0),
(3094596,16859,0,0,1,1,0),
(3094596,13006,0,0,1,1,0),
(3094596,17877,0,0,0,0,1),
(3094597,111993,1,0,0,0,0),
(3094597,112456,0,0,1,1,0),
(3094597,112607,0,0,1,1,0),
(3094597,111913,0,0,1,1,0),
(3094597,63244,0,0,1,1,0),
(3094597,16888,0,0,1,1,0),
(3094597,38801,0,0,1,1,0),
(3094597,113373,0,0,1,1,0),
(3094597,13006,0,0,1,1,0),
(3094597,17877,0,0,0,0,1),
(3094598,111994,1,0,0,0,0),
(3094598,29513,0,0,1,1,0),
(3094598,65451,0,0,2,2,0),
(3094598,111929,0,0,1,1,0),
(3094598,63244,0,0,1,1,0),
(3094598,38906,0,0,1,1,0),
(3094598,112608,0,0,1,1,0),
(3094598,112492,0,0,1,1,0),
(3094598,113372,0,0,1,1,0),
(3094598,13006,0,0,1,1,0),
(3094598,17877,0,0,0,0,1),
(3094599,112036,1,0,0,0,0),
(3094599,16858,0,0,1,1,0),
(3094599,111929,0,0,1,1,0),
(3094599,63244,0,0,1,1,0),
(3094599,38903,0,0,1,1,0),
(3094599,112608,0,0,1,1,0),
(3094599,112481,0,0,1,1,0),
(3094599,113372,0,0,1,1,0),
(3094599,16859,0,0,1,1,0),
(3094599,13006,0,0,1,1,0),
(3094599,17877,0,0,0,0,1),
(3094600,112037,1,0,0,0,0),
(3094600,112457,0,0,1,1,0),
(3094600,112607,0,0,1,1,0),
(3094600,111913,0,0,1,1,0),
(3094600,63244,0,0,1,1,0),
(3094600,16888,0,0,1,1,0),
(3094600,38798,0,0,1,1,0),
(3094600,113373,0,0,1,1,0),
(3094600,13006,0,0,1,1,0),
(3094600,17877,0,0,0,0,1),
(3094601,112038,1,0,0,0,0),
(3094601,29513,0,0,1,1,0),
(3094601,65451,0,0,2,2,0),
(3094601,111929,0,0,1,1,0),
(3094601,63244,0,0,1,1,0),
(3094601,38903,0,0,1,1,0),
(3094601,112608,0,0,1,1,0),
(3094601,112493,0,0,1,1,0),
(3094601,113372,0,0,1,1,0),
(3094601,13006,0,0,1,1,0),
(3094601,17877,0,0,0,0,1),
(3094602,112080,1,0,0,0,0),
(3094602,16858,0,0,1,1,0),
(3094602,111929,0,0,1,1,0),
(3094602,63244,0,0,1,1,0),
(3094602,38901,0,0,1,1,0),
(3094602,112608,0,0,1,1,0),
(3094602,112477,0,0,1,1,0),
(3094602,113372,0,0,1,1,0),
(3094602,16859,0,0,1,1,0),
(3094602,13006,0,0,1,1,0),
(3094602,17877,0,0,0,0,1),
(3094603,112081,1,0,0,0,0),
(3094603,112453,0,0,1,1,0),
(3094603,112607,0,0,1,1,0),
(3094603,111913,0,0,1,1,0),
(3094603,63244,0,0,1,1,0),
(3094603,16888,0,0,1,1,0),
(3094603,38796,0,0,1,1,0),
(3094603,113373,0,0,1,1,0),
(3094603,13006,0,0,1,1,0),
(3094603,17877,0,0,0,0,1),
(3094604,112082,1,0,0,0,0),
(3094604,29513,0,0,1,1,0),
(3094604,65451,0,0,2,2,0),
(3094604,111929,0,0,1,1,0),
(3094604,63244,0,0,1,1,0),
(3094604,38901,0,0,1,1,0),
(3094604,112608,0,0,1,1,0),
(3094604,112489,0,0,1,1,0),
(3094604,113372,0,0,1,1,0),
(3094604,13006,0,0,1,1,0),
(3094604,17877,0,0,0,0,1),
(3094605,112124,1,0,0,0,0),
(3094605,16858,0,0,1,1,0),
(3094605,111929,0,0,1,1,0),
(3094605,63244,0,0,1,1,0),
(3094605,38900,0,0,1,1,0),
(3094605,112608,0,0,1,1,0),
(3094605,112478,0,0,1,1,0),
(3094605,113372,0,0,1,1,0),
(3094605,16859,0,0,1,1,0),
(3094605,13006,0,0,1,1,0),
(3094605,17877,0,0,0,0,1),
(3094606,112125,1,0,0,0,0),
(3094606,112454,0,0,1,1,0),
(3094606,112607,0,0,1,1,0),
(3094606,111913,0,0,1,1,0),
(3094606,63244,0,0,1,1,0),
(3094606,16888,0,0,1,1,0),
(3094606,38795,0,0,1,1,0),
(3094606,113373,0,0,1,1,0),
(3094606,13006,0,0,1,1,0),
(3094606,17877,0,0,0,0,1),
(3094607,112126,1,0,0,0,0),
(3094607,29513,0,0,1,1,0),
(3094607,65451,0,0,2,2,0),
(3094607,111929,0,0,1,1,0),
(3094607,63244,0,0,1,1,0),
(3094607,38900,0,0,1,1,0),
(3094607,112608,0,0,1,1,0),
(3094607,112490,0,0,1,1,0),
(3094607,113372,0,0,1,1,0),
(3094607,13006,0,0,1,1,0),
(3094607,17877,0,0,0,0,1),
(3094608,112168,1,0,0,0,0),
(3094608,16858,0,0,1,1,0),
(3094608,111929,0,0,1,1,0),
(3094608,63244,0,0,1,1,0),
(3094608,38902,0,0,1,1,0),
(3094608,112608,0,0,1,1,0),
(3094608,112479,0,0,1,1,0),
(3094608,113372,0,0,1,1,0),
(3094608,16859,0,0,1,1,0),
(3094608,13006,0,0,1,1,0),
(3094608,17877,0,0,0,0,1),
(3094609,112169,1,0,0,0,0),
(3094609,112455,0,0,1,1,0),
(3094609,112607,0,0,1,1,0),
(3094609,111913,0,0,1,1,0),
(3094609,63244,0,0,1,1,0),
(3094609,16888,0,0,1,1,0),
(3094609,38797,0,0,1,1,0),
(3094609,113373,0,0,1,1,0),
(3094609,13006,0,0,1,1,0),
(3094609,17877,0,0,0,0,1),
(3094610,112170,1,0,0,0,0),
(3094610,29513,0,0,1,1,0),
(3094610,65451,0,0,2,2,0),
(3094610,111929,0,0,1,1,0),
(3094610,63244,0,0,1,1,0),
(3094610,38902,0,0,1,1,0),
(3094610,112608,0,0,1,1,0),
(3094610,112491,0,0,1,1,0),
(3094610,113372,0,0,1,1,0),
(3094610,13006,0,0,1,1,0),
(3094610,17877,0,0,0,0,1),
(3094611,112212,1,0,0,0,0),
(3094611,16858,0,0,1,1,0),
(3094611,111929,0,0,1,1,0),
(3094611,63244,0,0,1,1,0),
(3094611,38904,0,0,1,1,0),
(3094611,112608,0,0,1,1,0),
(3094611,112470,0,0,1,1,0),
(3094611,113372,0,0,1,1,0),
(3094611,16859,0,0,1,1,0),
(3094611,13006,0,0,1,1,0),
(3094611,17877,0,0,0,0,1),
(3094612,112213,1,0,0,0,0),
(3094612,112445,0,0,1,1,0),
(3094612,112607,0,0,1,1,0),
(3094612,111913,0,0,1,1,0),
(3094612,63244,0,0,1,1,0),
(3094612,16888,0,0,1,1,0),
(3094612,38799,0,0,1,1,0),
(3094612,113373,0,0,1,1,0),
(3094612,13006,0,0,1,1,0),
(3094612,17877,0,0,0,0,1),
(3094613,112214,1,0,0,0,0),
(3094613,29513,0,0,1,1,0),
(3094613,65451,0,0,2,2,0),
(3094613,111929,0,0,1,1,0),
(3094613,63244,0,0,1,1,0),
(3094613,38904,0,0,1,1,0),
(3094613,112608,0,0,1,1,0),
(3094613,112482,0,0,1,1,0),
(3094613,113372,0,0,1,1,0),
(3094613,13006,0,0,1,1,0),
(3094613,17877,0,0,0,0,1);
INSERT INTO rrc132_items (`id`,`name`) VALUES
(13006,CONVERT(0x576174657220466c61736b USING utf8mb4)),
(16858,CONVERT(0x4765617273 USING utf8mb4)),
(16859,CONVERT(0x5370726f636b657473 USING utf8mb4)),
(16888,CONVERT(0x4d6574616c2046617374656e696e67 USING utf8mb4)),
(17877,CONVERT(0x44656c75786520546f6f6c626f78 USING utf8mb4)),
(29513,CONVERT(0x436f6773 USING utf8mb4)),
(38795,CONVERT(0x5061747465726e20666f7220476e6f6d697368205772697374677561726473 USING utf8mb4)),
(38796,CONVERT(0x5061747465726e20666f7220476e6f6d69736820536c6565766573 USING utf8mb4)),
(38797,CONVERT(0x5061747465726e20666f7220476e6f6d69736820476c6f766573 USING utf8mb4)),
(38798,CONVERT(0x5061747465726e20666f7220476e6f6d69736820426f6f7473 USING utf8mb4)),
(38799,CONVERT(0x5061747465726e20666f7220476e6f6d6973682048656c6d73 USING utf8mb4)),
(38800,CONVERT(0x5061747465726e20666f7220476e6f6d6973682054756e696373 USING utf8mb4)),
(38801,CONVERT(0x5061747465726e20666f7220476e6f6d697368204c656767696e6773 USING utf8mb4)),
(38900,CONVERT(0x4d6f6c6420666f7220476e6f6d697368205772697374677561726473 USING utf8mb4)),
(38901,CONVERT(0x4d6f6c6420666f7220476e6f6d69736820536c6565766573 USING utf8mb4)),
(38902,CONVERT(0x4d6f6c6420666f7220476e6f6d69736820476c6f766573 USING utf8mb4)),
(38903,CONVERT(0x4d6f6c6420666f7220476e6f6d69736820426f6f7473 USING utf8mb4)),
(38904,CONVERT(0x4d6f6c6420666f7220476e6f6d6973682048656c6d73 USING utf8mb4)),
(38905,CONVERT(0x4d6f6c6420666f7220476e6f6d697368204368657374706c61746573 USING utf8mb4)),
(38906,CONVERT(0x4d6f6c6420666f7220476e6f6d697368204c656767696e6773 USING utf8mb4)),
(63244,CONVERT(0x476e6f6d697368204865617420536f75726365 USING utf8mb4)),
(65451,CONVERT(0x436f6e7472617074696f6e205061727473 USING utf8mb4)),
(111913,CONVERT(0x476c6f73737920466f727469666965642042726f6e7a6520546872656164 USING utf8mb4)),
(111929,CONVERT(0x476c6f73737920466f727469666965642042726f6e7a65 USING utf8mb4)),
(111948,CONVERT(0x476c6f72696f757320536572766f6c696e6b65642043756972617373 USING utf8mb4)),
(111949,CONVERT(0x476c6f72696f7573204d6574616c6f666962657220526f626573 USING utf8mb4)),
(111950,CONVERT(0x476c6f72696f7573204175746f61637475617465642043756972617373 USING utf8mb4)),
(111992,CONVERT(0x476c6f72696f757320536572766f6c696e6b65642047726561766573 USING utf8mb4)),
(111993,CONVERT(0x476c6f72696f7573204d6574616c6f6669626572204272656563686573 USING utf8mb4)),
(111994,CONVERT(0x476c6f72696f7573204175746f61637475617465642047726561766573 USING utf8mb4)),
(112036,CONVERT(0x476c6f72696f757320536572766f6c696e6b656420426f6f7473 USING utf8mb4)),
(112037,CONVERT(0x476c6f72696f7573204d6574616c6f666962657220426f6f7473 USING utf8mb4)),
(112038,CONVERT(0x476c6f72696f7573204175746f616374756174656420426f6f7473 USING utf8mb4)),
(112080,CONVERT(0x476c6f72696f757320536572766f6c696e6b656420536c6565766573 USING utf8mb4)),
(112081,CONVERT(0x476c6f72696f7573204d6574616c6f666962657220536c6565766573 USING utf8mb4)),
(112082,CONVERT(0x476c6f72696f7573204175746f616374756174656420536c6565766573 USING utf8mb4)),
(112124,CONVERT(0x476c6f72696f757320536572766f6c696e6b65642041726d62616e64 USING utf8mb4)),
(112125,CONVERT(0x476c6f72696f7573204d6574616c6f66696265722041726d62616e64 USING utf8mb4)),
(112126,CONVERT(0x476c6f72696f7573204175746f61637475617465642041726d62616e64 USING utf8mb4)),
(112168,CONVERT(0x476c6f72696f757320536572766f6c696e6b656420476c6f766573 USING utf8mb4)),
(112169,CONVERT(0x476c6f72696f7573204d6574616c6f666962657220476c6f766573 USING utf8mb4)),
(112170,CONVERT(0x476c6f72696f7573204175746f616374756174656420476c6f766573 USING utf8mb4)),
(112212,CONVERT(0x476c6f72696f757320536572766f6c696e6b65642048656c6d USING utf8mb4)),
(112213,CONVERT(0x476c6f72696f7573204d6574616c6f666962657220436170 USING utf8mb4)),
(112214,CONVERT(0x476c6f72696f7573204175746f61637475617465642048656c6d USING utf8mb4)),
(112445,CONVERT(0x45786f7469632053696c6b204361702054656d706c617465 USING utf8mb4)),
(112449,CONVERT(0x45786f7469632053696c6b20526f62652054656d706c617465 USING utf8mb4)),
(112453,CONVERT(0x45786f7469632053696c6b20536c656576652054656d706c617465 USING utf8mb4)),
(112454,CONVERT(0x45786f7469632053696c6b20577269737462616e642054656d706c617465 USING utf8mb4)),
(112455,CONVERT(0x45786f7469632053696c6b20476c6f76652054656d706c617465 USING utf8mb4)),
(112456,CONVERT(0x45786f7469632053696c6b2050616e742054656d706c617465 USING utf8mb4)),
(112457,CONVERT(0x45786f7469632053696c6b20426f6f742054656d706c617465 USING utf8mb4)),
(112470,CONVERT(0x50616c6c616469756d20436861696e20436f69662054656d706c617465 USING utf8mb4)),
(112473,CONVERT(0x50616c6c616469756d20436861696e20436865737467756172642054656d706c617465 USING utf8mb4)),
(112477,CONVERT(0x50616c6c616469756d20436861696e2041726d732054656d706c617465 USING utf8mb4)),
(112478,CONVERT(0x50616c6c616469756d20436861696e204272616365722054656d706c617465 USING utf8mb4)),
(112479,CONVERT(0x50616c6c616469756d20436861696e20476c6f7665732054656d706c617465 USING utf8mb4)),
(112480,CONVERT(0x50616c6c616469756d20436861696e204c6567706c617465732054656d706c617465 USING utf8mb4)),
(112481,CONVERT(0x50616c6c616469756d20436861696e20426f6f74732054656d706c617465 USING utf8mb4)),
(112482,CONVERT(0x50616c6c616469756d20506c6174652048656c6d2054656d706c617465 USING utf8mb4)),
(112485,CONVERT(0x50616c6c616469756d20427265617374706c6174652054656d706c617465 USING utf8mb4)),
(112489,CONVERT(0x50616c6c616469756d20506c6174652056616d62726163652054656d706c617465 USING utf8mb4)),
(112490,CONVERT(0x50616c6c616469756d20506c617465204272616365722054656d706c617465 USING utf8mb4)),
(112491,CONVERT(0x50616c6c616469756d20506c617465204761756e746c65742054656d706c617465 USING utf8mb4)),
(112492,CONVERT(0x50616c6c616469756d20506c61746520477265617665732054656d706c617465 USING utf8mb4)),
(112493,CONVERT(0x50616c6c616469756d20506c61746520426f6f742054656d706c617465 USING utf8mb4)),
(112584,CONVERT(0x476c6f72696f757320476e6f6d6973682043756c747572616c2054696e6b6572696e67 USING utf8mb4)),
(112607,CONVERT(0x45786f746963205370696e6e6572657420466c756964 USING utf8mb4)),
(112608,CONVERT(0x4d7973746572696f7573204c6f616d USING utf8mb4)),
(113372,CONVERT(0x5368696e7920436f616c USING utf8mb4)),
(113373,CONVERT(0x506c617465642046696c616d656e74 USING utf8mb4));
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF (SELECT COUNT(*)FROM books WHERE name=CONVERT(0x545343756c7454696e6b6572696e67474e4d3935 USING utf8mb4) AND SHA2(txtfile,256)=CONVERT(0x32623431316265383737363136356539393265356664333232386433663237623539363336663635663962376531663238343465383835643064353161613435 USING utf8mb4))<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native book context mismatch'; END IF;

 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc132_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc132_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=13006 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 15 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16858 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16859 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16888 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17877 AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 10 AND `bagslots` <=> 10 AND `bagsize` <=> 4 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=29513 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38795 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 400 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38796 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38797 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38798 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38799 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38800 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38801 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38900 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 400 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38901 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38902 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38903 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38904 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38905 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38906 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=63244 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 25 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=65451 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=111913 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=111929 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=111948 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 256 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 131072 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=111949 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 15360 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 131072 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=111950 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 23 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 131072 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=111992 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 256 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 262144 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=111993 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 15360 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 262144 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=111994 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 23 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 262144 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112036 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 256 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 524288 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112037 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 15360 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 524288 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112038 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 23 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 524288 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112080 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 256 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 128 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112081 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 15360 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 128 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112082 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 23 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 128 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112124 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 256 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 1536 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112125 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 15360 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 1536 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112126 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 23 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 1536 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112168 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 256 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 4096 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112169 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 15360 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 4096 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112170 AND `size` <=> 2 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 23 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 4096 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112212 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 256 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 4 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112213 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 15360 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 4 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112214 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 23 AND `races` <=> 2048 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 4 AND `purity` <=> 25 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112445 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 9 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112449 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 3 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112453 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 9 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112454 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 15 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112455 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 15 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112456 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 3 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112457 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 9 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112470 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 6 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112473 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 2 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112477 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 6 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112478 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112479 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112480 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 2 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112481 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 6 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112482 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 3 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112485 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112489 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 3 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112490 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 5 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112491 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 5 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112492 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112493 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 3 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112584 AND `size` <=> 0 AND `itemclass` <=> 2 AND `itemtype` <=> 60 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 0 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> CONVERT(0x545343756c7454696e6b6572696e67474e4d3935 USING utf8mb4) AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112607 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=112608 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=113372 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=113373 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 91 AND `reclevel` <=> 95 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 native item semantics mismatch'; END IF;
 IF already_present<>21 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc132_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc132_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc132_recipes q ON q.id=r.recipe_id LEFT JOIN rrc132_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc132_recipes q ON q.id=r.recipe_id)<>224 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc132_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc132_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc132_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-21 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-224 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC132 rollback count mismatch'; END IF;
 DROP TEMPORARY TABLE rrc132_entries;
 DROP TEMPORARY TABLE rrc132_recipes;
 DROP TEMPORARY TABLE rrc132_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC132' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
