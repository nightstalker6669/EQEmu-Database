-- RRC173: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc173_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc173_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc173_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc173_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3096142,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f662074686520536b6570746963 USING utf8mb4),68,300,508,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792066696e69746520776561706f6e207265636f6e737472756374696f6e3b205252433137332e USING utf8mb4),1,135564,0,1,19,-1,NULL,NULL),
(3096143,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f6620496e666573746174696f6e USING utf8mb4),68,300,508,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792066696e69746520776561706f6e207265636f6e737472756374696f6e3b205252433137332e USING utf8mb4),1,135564,0,1,19,-1,NULL,NULL),
(3096144,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f662042656c6f77 USING utf8mb4),68,300,508,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792066696e69746520776561706f6e207265636f6e737472756374696f6e3b205252433137332e USING utf8mb4),1,135564,0,1,19,-1,NULL,NULL),
(3096145,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f66207468652046617263657572 USING utf8mb4),68,300,508,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792066696e69746520776561706f6e207265636f6e737472756374696f6e3b205252433137332e USING utf8mb4),1,135564,0,1,19,-1,NULL,NULL),
(3096146,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f6620546572726f72 USING utf8mb4),68,300,508,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792066696e69746520776561706f6e207265636f6e737472756374696f6e3b205252433137332e USING utf8mb4),1,135564,0,1,19,-1,NULL,NULL),
(3096147,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f6620546861756d617475726779 USING utf8mb4),68,300,508,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792066696e69746520776561706f6e207265636f6e737472756374696f6e3b205252433137332e USING utf8mb4),1,135564,0,1,19,-1,NULL,NULL),
(3096148,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f66204465766f74696f6e USING utf8mb4),68,300,508,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792066696e69746520776561706f6e207265636f6e737472756374696f6e3b205252433137332e USING utf8mb4),1,135564,0,1,19,-1,NULL,NULL),
(3096149,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f66207468652046697265204c6f7264 USING utf8mb4),68,300,508,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792066696e69746520776561706f6e207265636f6e737472756374696f6e3b205252433137332e USING utf8mb4),1,135564,0,1,19,-1,NULL,NULL),
(3096150,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f662048617465 USING utf8mb4),68,300,508,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792066696e69746520776561706f6e207265636f6e737472756374696f6e3b205252433137332e USING utf8mb4),1,135564,0,1,19,-1,NULL,NULL),
(3096151,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f662053746f726d73 USING utf8mb4),68,300,508,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792066696e69746520776561706f6e207265636f6e737472756374696f6e3b205252433137332e USING utf8mb4),1,135564,0,1,19,-1,NULL,NULL),
(3096152,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f662074686520446570746873 USING utf8mb4),68,300,508,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792066696e69746520776561706f6e207265636f6e737472756374696f6e3b205252433137332e USING utf8mb4),1,135564,0,1,19,-1,NULL,NULL),
(3096153,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f66205374696c6c6e657373 USING utf8mb4),68,300,508,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792066696e69746520776561706f6e207265636f6e737472756374696f6e3b205252433137332e USING utf8mb4),1,135564,0,1,19,-1,NULL,NULL),
(3096154,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f6620746865205761726d6f6e676572 USING utf8mb4),68,300,508,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792066696e69746520776561706f6e207265636f6e737472756374696f6e3b205252433137332e USING utf8mb4),1,135564,0,1,19,-1,NULL,NULL),
(3096155,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f662057696c6466697265 USING utf8mb4),68,300,508,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792066696e69746520776561706f6e207265636f6e737472756374696f6e3b205252433137332e USING utf8mb4),1,135564,0,1,19,-1,NULL,NULL),
(3096156,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f66204465636179 USING utf8mb4),68,300,508,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792066696e69746520776561706f6e207265636f6e737472756374696f6e3b205252433137332e USING utf8mb4),1,135564,0,1,19,-1,NULL,NULL),
(3096157,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f66204a7564676d656e74 USING utf8mb4),68,300,508,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792066696e69746520776561706f6e207265636f6e737472756374696f6e3b205252433137332e USING utf8mb4),1,135564,0,1,19,-1,NULL,NULL),
(3096158,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f662047726f777468 USING utf8mb4),68,300,508,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792066696e69746520776561706f6e207265636f6e737472756374696f6e3b205252433137332e USING utf8mb4),1,135564,0,1,19,-1,NULL,NULL),
(3096159,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f66207468652042726f6f64 USING utf8mb4),68,300,508,0,0,CONVERT(0x4d61696e7461696e65642d7072696d6172792066696e69746520776561706f6e207265636f6e737472756374696f6e3b205252433137332e USING utf8mb4),1,135564,0,1,19,-1,NULL,NULL);
INSERT INTO rrc173_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3096142,10037,0,0,1,1,0),
(3096142,10254,0,0,1,1,0),
(3096142,81837,0,0,1,1,0),
(3096142,95829,1,1,1,0,0),
(3096142,134656,0,0,1,1,0),
(3096142,135498,1,0,0,0,0),
(3096142,17187,0,0,0,0,1),
(3096142,17764,0,0,0,0,1),
(3096142,62480,0,0,0,0,1),
(3096143,10037,0,0,1,1,0),
(3096143,10254,0,0,1,1,0),
(3096143,81830,0,0,1,1,0),
(3096143,95829,1,1,1,0,0),
(3096143,134656,0,0,1,1,0),
(3096143,135501,1,0,0,0,0),
(3096143,17187,0,0,0,0,1),
(3096143,17764,0,0,0,0,1),
(3096143,62480,0,0,0,0,1),
(3096144,10037,0,0,1,1,0),
(3096144,10254,0,0,1,1,0),
(3096144,81824,0,0,1,1,0),
(3096144,95829,1,1,1,0,0),
(3096144,134656,0,0,1,1,0),
(3096144,135504,1,0,0,0,0),
(3096144,17187,0,0,0,0,1),
(3096144,17764,0,0,0,0,1),
(3096144,62480,0,0,0,0,1),
(3096145,10037,0,0,1,1,0),
(3096145,10254,0,0,1,1,0),
(3096145,81833,0,0,1,1,0),
(3096145,95829,1,1,1,0,0),
(3096145,134656,0,0,1,1,0),
(3096145,135507,1,0,0,0,0),
(3096145,17187,0,0,0,0,1),
(3096145,17764,0,0,0,0,1),
(3096145,62480,0,0,0,0,1),
(3096146,10037,0,0,1,1,0),
(3096146,10254,0,0,1,1,0),
(3096146,81823,0,0,1,1,0),
(3096146,95829,1,1,1,0,0),
(3096146,134656,0,0,1,1,0),
(3096146,135510,1,0,0,0,0),
(3096146,17187,0,0,0,0,1),
(3096146,17764,0,0,0,0,1),
(3096146,62480,0,0,0,0,1),
(3096147,10037,0,0,1,1,0),
(3096147,10254,0,0,1,1,0),
(3096147,48161,0,0,1,1,0),
(3096147,95829,1,1,1,0,0),
(3096147,134656,0,0,1,1,0),
(3096147,135513,1,0,0,0,0),
(3096147,17187,0,0,0,0,1),
(3096147,17764,0,0,0,0,1),
(3096147,62480,0,0,0,0,1),
(3096148,10037,0,0,1,1,0),
(3096148,10254,0,0,1,1,0),
(3096148,81829,0,0,1,1,0),
(3096148,95829,1,1,1,0,0),
(3096148,134656,0,0,1,1,0),
(3096148,135516,1,0,0,0,0),
(3096148,17187,0,0,0,0,1),
(3096148,17764,0,0,0,0,1),
(3096148,62480,0,0,0,0,1),
(3096149,10037,0,0,1,1,0),
(3096149,10254,0,0,1,1,0),
(3096149,48159,0,0,1,1,0),
(3096149,95829,1,1,1,0,0),
(3096149,134656,0,0,1,1,0),
(3096149,135519,1,0,0,0,0),
(3096149,17187,0,0,0,0,1),
(3096149,17764,0,0,0,0,1),
(3096149,62480,0,0,0,0,1),
(3096150,10037,0,0,1,1,0),
(3096150,10254,0,0,1,1,0),
(3096150,81826,0,0,1,1,0),
(3096150,95829,1,1,1,0,0),
(3096150,134656,0,0,1,1,0),
(3096150,135522,1,0,0,0,0),
(3096150,17187,0,0,0,0,1),
(3096150,17764,0,0,0,0,1),
(3096150,62480,0,0,0,0,1),
(3096151,10037,0,0,1,1,0),
(3096151,10254,0,0,1,1,0),
(3096151,81832,0,0,1,1,0),
(3096151,95829,1,1,1,0,0),
(3096151,134656,0,0,1,1,0),
(3096151,135525,1,0,0,0,0),
(3096151,17187,0,0,0,0,1),
(3096151,17764,0,0,0,0,1),
(3096151,62480,0,0,0,0,1),
(3096152,10037,0,0,1,1,0),
(3096152,10254,0,0,1,1,0),
(3096152,81827,0,0,1,1,0),
(3096152,95829,1,1,1,0,0),
(3096152,134656,0,0,1,1,0),
(3096152,135531,1,0,0,0,0),
(3096152,17187,0,0,0,0,1),
(3096152,17764,0,0,0,0,1),
(3096152,62480,0,0,0,0,1),
(3096153,10037,0,0,1,1,0),
(3096153,10254,0,0,1,1,0),
(3096153,81834,0,0,1,1,0),
(3096153,95829,1,1,1,0,0),
(3096153,134656,0,0,1,1,0),
(3096153,135534,1,0,0,0,0),
(3096153,17187,0,0,0,0,1),
(3096153,17764,0,0,0,0,1),
(3096153,62480,0,0,0,0,1),
(3096154,10037,0,0,1,1,0),
(3096154,10254,0,0,1,1,0),
(3096154,81821,0,0,1,1,0),
(3096154,95829,1,1,1,0,0),
(3096154,134656,0,0,1,1,0),
(3096154,135537,1,0,0,0,0),
(3096154,17187,0,0,0,0,1),
(3096154,17764,0,0,0,0,1),
(3096154,62480,0,0,0,0,1),
(3096155,10037,0,0,1,1,0),
(3096155,10254,0,0,1,1,0),
(3096155,81831,0,0,1,1,0),
(3096155,95829,1,1,1,0,0),
(3096155,134656,0,0,1,1,0),
(3096155,135546,1,0,0,0,0),
(3096155,17187,0,0,0,0,1),
(3096155,17764,0,0,0,0,1),
(3096155,62480,0,0,0,0,1),
(3096156,10037,0,0,1,1,0),
(3096156,10254,0,0,1,1,0),
(3096156,48158,0,0,1,1,0),
(3096156,95829,1,1,1,0,0),
(3096156,134656,0,0,1,1,0),
(3096156,135549,1,0,0,0,0),
(3096156,17187,0,0,0,0,1),
(3096156,17764,0,0,0,0,1),
(3096156,62480,0,0,0,0,1),
(3096157,10037,0,0,1,1,0),
(3096157,10254,0,0,1,1,0),
(3096157,81822,0,0,1,1,0),
(3096157,95829,1,1,1,0,0),
(3096157,134656,0,0,1,1,0),
(3096157,135552,1,0,0,0,0),
(3096157,17187,0,0,0,0,1),
(3096157,17764,0,0,0,0,1),
(3096157,62480,0,0,0,0,1),
(3096158,10037,0,0,1,1,0),
(3096158,10254,0,0,1,1,0),
(3096158,81825,0,0,1,1,0),
(3096158,95829,1,1,1,0,0),
(3096158,134656,0,0,1,1,0),
(3096158,135555,1,0,0,0,0),
(3096158,17187,0,0,0,0,1),
(3096158,17764,0,0,0,0,1),
(3096158,62480,0,0,0,0,1),
(3096159,10037,0,0,1,1,0),
(3096159,10254,0,0,1,1,0),
(3096159,81836,0,0,1,1,0),
(3096159,95829,1,1,1,0,0),
(3096159,134656,0,0,1,1,0),
(3096159,135558,1,0,0,0,0),
(3096159,17187,0,0,0,0,1),
(3096159,17764,0,0,0,0,1),
(3096159,62480,0,0,0,0,1);
INSERT INTO rrc173_items (`id`,`name`) VALUES
(10037,CONVERT(0x4469616d6f6e64 USING utf8mb4)),
(10254,CONVERT(0x5669616c206f66205075726966696564204d616e61 USING utf8mb4)),
(17187,CONVERT(0x436f6c6c61707369626c65204a6577656c65722773204b6974 USING utf8mb4)),
(17764,CONVERT(0x506c616e6172204a6577656c65722773204b6974 USING utf8mb4)),
(48158,CONVERT(0x426c6573736564205761746572206f66205465727269732d5468756c65 USING utf8mb4)),
(48159,CONVERT(0x426c6573736564205761746572206f662046656e6e696e20526f USING utf8mb4)),
(48161,CONVERT(0x426c6573736564205761746572206f66204472757a7a696c20526f USING utf8mb4)),
(62480,CONVERT(0x5265696e666f72636564204a6577656c65722773204b6974 USING utf8mb4)),
(81821,CONVERT(0x426c6573736564205761746572206f662052616c6c6f73205a656b USING utf8mb4)),
(81822,CONVERT(0x426c6573736564205761746572206f66205468652054726962756e616c USING utf8mb4)),
(81823,CONVERT(0x426c6573736564205761746572206f662043617a69632d5468756c65 USING utf8mb4)),
(81824,CONVERT(0x426c6573736564205761746572206f66204272656c6c20536572696c6973 USING utf8mb4)),
(81825,CONVERT(0x426c6573736564205761746572206f662054756e617265 USING utf8mb4)),
(81826,CONVERT(0x426c6573736564205761746572206f6620496e6e6f7275756b USING utf8mb4)),
(81827,CONVERT(0x426c6573736564205761746572206f6620507265787573 USING utf8mb4)),
(81829,CONVERT(0x426c6573736564205761746572206f662045726f6c6c697369204d617272 USING utf8mb4)),
(81830,CONVERT(0x426c6573736564205761746572206f6620426572746f7878756c6f7573 USING utf8mb4)),
(81831,CONVERT(0x426c6573736564205761746572206f6620536f6c7573656b20526f USING utf8mb4)),
(81832,CONVERT(0x426c6573736564205761746572206f66204b6172616e61 USING utf8mb4)),
(81833,CONVERT(0x426c6573736564205761746572206f662042726973746c6562616e65 USING utf8mb4)),
(81834,CONVERT(0x426c6573736564205761746572206f66205175656c6c696f7573 USING utf8mb4)),
(81836,CONVERT(0x426c6573736564205761746572206f66205665657368616e USING utf8mb4)),
(81837,CONVERT(0x5761746572206f662074686520536b6570746963 USING utf8mb4)),
(95829,CONVERT(0x48616c662d4d6f6f6e2043757420546f6f6c USING utf8mb4)),
(134656,CONVERT(0x4265666f756c6564205370696e6e6572657420466c756964 USING utf8mb4)),
(135498,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f662074686520536b6570746963 USING utf8mb4)),
(135501,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f6620496e666573746174696f6e USING utf8mb4)),
(135504,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f662042656c6f77 USING utf8mb4)),
(135507,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f66207468652046617263657572 USING utf8mb4)),
(135510,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f6620546572726f72 USING utf8mb4)),
(135513,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f6620546861756d617475726779 USING utf8mb4)),
(135516,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f66204465766f74696f6e USING utf8mb4)),
(135519,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f66207468652046697265204c6f7264 USING utf8mb4)),
(135522,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f662048617465 USING utf8mb4)),
(135525,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f662053746f726d73 USING utf8mb4)),
(135531,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f662074686520446570746873 USING utf8mb4)),
(135534,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f66205374696c6c6e657373 USING utf8mb4)),
(135537,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f6620746865205761726d6f6e676572 USING utf8mb4)),
(135546,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f662057696c6466697265 USING utf8mb4)),
(135549,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f66204465636179 USING utf8mb4)),
(135552,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f66204a756467656d656e74 USING utf8mb4)),
(135555,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f662047726f777468 USING utf8mb4)),
(135558,CONVERT(0x5472616e7363656e64656e7420566963696f75732053796d626f6c206f66207468652042726f6f64 USING utf8mb4)),
(135564,CONVERT(0x5472616e7363656e64656e7420576561706f6e204175676d656e74696e67 USING utf8mb4));
 CREATE TEMPORARY TABLE rrc173_peer_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc173_peer_entries LIKE tradeskill_recipe_entries;
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 target database mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=10037 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=10254 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17187 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 20 AND `bagslots` <=> 6 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17764 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 20 AND `bagslots` <=> 6 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48158 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48159 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48161 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=62480 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 20 AND `bagslots` <=> 6 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81821 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81822 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81823 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81824 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81825 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81826 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81827 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81829 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81830 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81831 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81832 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81833 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81834 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81836 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=81837 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=95829 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=134656 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=135498 AND `itemclass` <=> 0 AND `itemtype` <=> 54 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> '' AND `booktype` <=> 0 AND `aagi` <=> 23 AND `ac` <=> 53 AND `acha` <=> 23 AND `adex` <=> 23 AND `aint` <=> 23 AND `asta` <=> 23 AND `astr` <=> 23 AND `attack` <=> 22 AND `augtype` <=> 1024 AND `awis` <=> 23 AND `clairvoyance` <=> 22 AND `cr` <=> 39 AND `damage` <=> 109 AND `dr` <=> 39 AND `endur` <=> 1807 AND `fr` <=> 39 AND `healamt` <=> 14 AND `hp` <=> 1807 AND `mana` <=> 1807 AND `manaregen` <=> 0 AND `mr` <=> 39 AND `pr` <=> 39 AND `regen` <=> 0 AND `slots` <=> 8192 AND `spelldmg` <=> 14 AND `proceffect` <=> -1 AND `worneffect` <=> -1 AND `focuseffect` <=> -1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=135501 AND `itemclass` <=> 0 AND `itemtype` <=> 54 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> '' AND `booktype` <=> 0 AND `aagi` <=> 23 AND `ac` <=> 53 AND `acha` <=> 23 AND `adex` <=> 23 AND `aint` <=> 23 AND `asta` <=> 23 AND `astr` <=> 23 AND `attack` <=> 22 AND `augtype` <=> 1024 AND `awis` <=> 23 AND `clairvoyance` <=> 22 AND `cr` <=> 31 AND `damage` <=> 108 AND `dr` <=> 51 AND `endur` <=> 1807 AND `fr` <=> 31 AND `healamt` <=> 14 AND `hp` <=> 1807 AND `mana` <=> 1807 AND `manaregen` <=> 0 AND `mr` <=> 39 AND `pr` <=> 39 AND `regen` <=> 0 AND `slots` <=> 8192 AND `spelldmg` <=> 14 AND `proceffect` <=> -1 AND `worneffect` <=> -1 AND `focuseffect` <=> -1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=135504 AND `itemclass` <=> 0 AND `itemtype` <=> 54 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> '' AND `booktype` <=> 0 AND `aagi` <=> 23 AND `ac` <=> 53 AND `acha` <=> 23 AND `adex` <=> 23 AND `aint` <=> 23 AND `asta` <=> 23 AND `astr` <=> 23 AND `attack` <=> 22 AND `augtype` <=> 1024 AND `awis` <=> 23 AND `clairvoyance` <=> 22 AND `cr` <=> 35 AND `damage` <=> 108 AND `dr` <=> 39 AND `endur` <=> 1807 AND `fr` <=> 35 AND `healamt` <=> 14 AND `hp` <=> 1807 AND `mana` <=> 1807 AND `manaregen` <=> 0 AND `mr` <=> 47 AND `pr` <=> 39 AND `regen` <=> 0 AND `slots` <=> 8192 AND `spelldmg` <=> 14 AND `proceffect` <=> 20606 AND `worneffect` <=> -1 AND `focuseffect` <=> -1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=135507 AND `itemclass` <=> 0 AND `itemtype` <=> 54 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> '' AND `booktype` <=> 0 AND `aagi` <=> 23 AND `ac` <=> 53 AND `acha` <=> 23 AND `adex` <=> 23 AND `aint` <=> 23 AND `asta` <=> 23 AND `astr` <=> 23 AND `attack` <=> 22 AND `augtype` <=> 1024 AND `awis` <=> 23 AND `clairvoyance` <=> 22 AND `cr` <=> 31 AND `damage` <=> 108 AND `dr` <=> 39 AND `endur` <=> 1807 AND `fr` <=> 31 AND `healamt` <=> 14 AND `hp` <=> 1807 AND `mana` <=> 1807 AND `manaregen` <=> 0 AND `mr` <=> 39 AND `pr` <=> 51 AND `regen` <=> 0 AND `slots` <=> 8192 AND `spelldmg` <=> 14 AND `proceffect` <=> -1 AND `worneffect` <=> -1 AND `focuseffect` <=> -1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=135510 AND `itemclass` <=> 0 AND `itemtype` <=> 54 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> '' AND `booktype` <=> 0 AND `aagi` <=> 23 AND `ac` <=> 53 AND `acha` <=> 23 AND `adex` <=> 23 AND `aint` <=> 23 AND `asta` <=> 23 AND `astr` <=> 23 AND `attack` <=> 22 AND `augtype` <=> 1024 AND `awis` <=> 23 AND `clairvoyance` <=> 22 AND `cr` <=> 39 AND `damage` <=> 108 AND `dr` <=> 39 AND `endur` <=> 1807 AND `fr` <=> 39 AND `healamt` <=> 14 AND `hp` <=> 1807 AND `mana` <=> 1807 AND `manaregen` <=> 0 AND `mr` <=> 39 AND `pr` <=> 39 AND `regen` <=> 0 AND `slots` <=> 8192 AND `spelldmg` <=> 14 AND `proceffect` <=> 20683 AND `worneffect` <=> -1 AND `focuseffect` <=> -1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=135513 AND `itemclass` <=> 0 AND `itemtype` <=> 54 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> '' AND `booktype` <=> 0 AND `aagi` <=> 23 AND `ac` <=> 53 AND `acha` <=> 23 AND `adex` <=> 23 AND `aint` <=> 23 AND `asta` <=> 23 AND `astr` <=> 23 AND `attack` <=> 22 AND `augtype` <=> 1024 AND `awis` <=> 23 AND `clairvoyance` <=> 22 AND `cr` <=> 39 AND `damage` <=> 108 AND `dr` <=> 39 AND `endur` <=> 1807 AND `fr` <=> 39 AND `healamt` <=> 14 AND `hp` <=> 1807 AND `mana` <=> 1807 AND `manaregen` <=> 0 AND `mr` <=> 39 AND `pr` <=> 39 AND `regen` <=> 0 AND `slots` <=> 8192 AND `spelldmg` <=> 14 AND `proceffect` <=> 20690 AND `worneffect` <=> -1 AND `focuseffect` <=> -1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=135516 AND `itemclass` <=> 0 AND `itemtype` <=> 54 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> '' AND `booktype` <=> 0 AND `aagi` <=> 23 AND `ac` <=> 53 AND `acha` <=> 23 AND `adex` <=> 23 AND `aint` <=> 23 AND `asta` <=> 23 AND `astr` <=> 23 AND `attack` <=> 22 AND `augtype` <=> 1024 AND `awis` <=> 23 AND `clairvoyance` <=> 22 AND `cr` <=> 39 AND `damage` <=> 108 AND `dr` <=> 31 AND `endur` <=> 1807 AND `fr` <=> 39 AND `healamt` <=> 14 AND `hp` <=> 1807 AND `mana` <=> 1807 AND `manaregen` <=> 0 AND `mr` <=> 51 AND `pr` <=> 31 AND `regen` <=> 0 AND `slots` <=> 8192 AND `spelldmg` <=> 14 AND `proceffect` <=> -1 AND `worneffect` <=> -1 AND `focuseffect` <=> -1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=135519 AND `itemclass` <=> 0 AND `itemtype` <=> 54 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> '' AND `booktype` <=> 0 AND `aagi` <=> 23 AND `ac` <=> 53 AND `acha` <=> 23 AND `adex` <=> 23 AND `aint` <=> 23 AND `asta` <=> 23 AND `astr` <=> 23 AND `attack` <=> 22 AND `augtype` <=> 1024 AND `awis` <=> 23 AND `clairvoyance` <=> 22 AND `cr` <=> 27 AND `damage` <=> 108 AND `dr` <=> 39 AND `endur` <=> 1807 AND `fr` <=> 51 AND `healamt` <=> 14 AND `hp` <=> 1807 AND `mana` <=> 1807 AND `manaregen` <=> 0 AND `mr` <=> 39 AND `pr` <=> 39 AND `regen` <=> 0 AND `slots` <=> 8192 AND `spelldmg` <=> 14 AND `proceffect` <=> 20627 AND `worneffect` <=> -1 AND `focuseffect` <=> -1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=135522 AND `itemclass` <=> 0 AND `itemtype` <=> 54 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> '' AND `booktype` <=> 0 AND `aagi` <=> 23 AND `ac` <=> 53 AND `acha` <=> 23 AND `adex` <=> 23 AND `aint` <=> 23 AND `asta` <=> 23 AND `astr` <=> 23 AND `attack` <=> 22 AND `augtype` <=> 1024 AND `awis` <=> 23 AND `clairvoyance` <=> 22 AND `cr` <=> 39 AND `damage` <=> 108 AND `dr` <=> 39 AND `endur` <=> 1807 AND `fr` <=> 39 AND `healamt` <=> 14 AND `hp` <=> 1807 AND `mana` <=> 1807 AND `manaregen` <=> 0 AND `mr` <=> 39 AND `pr` <=> 39 AND `regen` <=> 0 AND `slots` <=> 8192 AND `spelldmg` <=> 14 AND `proceffect` <=> 20641 AND `worneffect` <=> -1 AND `focuseffect` <=> -1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=135525 AND `itemclass` <=> 0 AND `itemtype` <=> 54 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> '' AND `booktype` <=> 0 AND `aagi` <=> 23 AND `ac` <=> 53 AND `acha` <=> 23 AND `adex` <=> 23 AND `aint` <=> 23 AND `asta` <=> 23 AND `astr` <=> 23 AND `attack` <=> 22 AND `augtype` <=> 1024 AND `awis` <=> 23 AND `clairvoyance` <=> 22 AND `cr` <=> 51 AND `damage` <=> 108 AND `dr` <=> 39 AND `endur` <=> 1807 AND `fr` <=> 27 AND `healamt` <=> 14 AND `hp` <=> 1807 AND `mana` <=> 1807 AND `manaregen` <=> 0 AND `mr` <=> 39 AND `pr` <=> 39 AND `regen` <=> 0 AND `slots` <=> 8192 AND `spelldmg` <=> 14 AND `proceffect` <=> 20676 AND `worneffect` <=> -1 AND `focuseffect` <=> -1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=135531 AND `itemclass` <=> 0 AND `itemtype` <=> 54 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> '' AND `booktype` <=> 0 AND `aagi` <=> 23 AND `ac` <=> 53 AND `acha` <=> 23 AND `adex` <=> 23 AND `aint` <=> 23 AND `asta` <=> 23 AND `astr` <=> 23 AND `attack` <=> 22 AND `augtype` <=> 1024 AND `awis` <=> 23 AND `clairvoyance` <=> 22 AND `cr` <=> 51 AND `damage` <=> 108 AND `dr` <=> 39 AND `endur` <=> 1807 AND `fr` <=> 27 AND `healamt` <=> 14 AND `hp` <=> 1807 AND `mana` <=> 1807 AND `manaregen` <=> 0 AND `mr` <=> 39 AND `pr` <=> 39 AND `regen` <=> 0 AND `slots` <=> 8192 AND `spelldmg` <=> 14 AND `proceffect` <=> -1 AND `worneffect` <=> -1 AND `focuseffect` <=> -1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=135534 AND `itemclass` <=> 0 AND `itemtype` <=> 54 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> '' AND `booktype` <=> 0 AND `aagi` <=> 23 AND `ac` <=> 53 AND `acha` <=> 23 AND `adex` <=> 23 AND `aint` <=> 23 AND `asta` <=> 23 AND `astr` <=> 23 AND `attack` <=> 22 AND `augtype` <=> 1024 AND `awis` <=> 23 AND `clairvoyance` <=> 22 AND `cr` <=> 39 AND `damage` <=> 108 AND `dr` <=> 39 AND `endur` <=> 1807 AND `fr` <=> 39 AND `healamt` <=> 14 AND `hp` <=> 1807 AND `mana` <=> 1807 AND `manaregen` <=> 0 AND `mr` <=> 39 AND `pr` <=> 39 AND `regen` <=> 0 AND `slots` <=> 8192 AND `spelldmg` <=> 14 AND `proceffect` <=> 20669 AND `worneffect` <=> -1 AND `focuseffect` <=> -1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=135537 AND `itemclass` <=> 0 AND `itemtype` <=> 54 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> '' AND `booktype` <=> 0 AND `aagi` <=> 23 AND `ac` <=> 53 AND `acha` <=> 23 AND `adex` <=> 23 AND `aint` <=> 23 AND `asta` <=> 23 AND `astr` <=> 23 AND `attack` <=> 22 AND `augtype` <=> 1024 AND `awis` <=> 23 AND `clairvoyance` <=> 22 AND `cr` <=> 39 AND `damage` <=> 108 AND `dr` <=> 39 AND `endur` <=> 1807 AND `fr` <=> 39 AND `healamt` <=> 14 AND `hp` <=> 1807 AND `mana` <=> 1807 AND `manaregen` <=> 0 AND `mr` <=> 39 AND `pr` <=> 39 AND `regen` <=> 0 AND `slots` <=> 8192 AND `spelldmg` <=> 14 AND `proceffect` <=> 20697 AND `worneffect` <=> -1 AND `focuseffect` <=> -1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=135546 AND `itemclass` <=> 0 AND `itemtype` <=> 54 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> '' AND `booktype` <=> 0 AND `aagi` <=> 23 AND `ac` <=> 53 AND `acha` <=> 23 AND `adex` <=> 23 AND `aint` <=> 23 AND `asta` <=> 23 AND `astr` <=> 23 AND `attack` <=> 22 AND `augtype` <=> 1024 AND `awis` <=> 23 AND `clairvoyance` <=> 22 AND `cr` <=> 27 AND `damage` <=> 108 AND `dr` <=> 39 AND `endur` <=> 1807 AND `fr` <=> 51 AND `healamt` <=> 14 AND `hp` <=> 1807 AND `mana` <=> 1807 AND `manaregen` <=> 0 AND `mr` <=> 39 AND `pr` <=> 39 AND `regen` <=> 0 AND `slots` <=> 8192 AND `spelldmg` <=> 14 AND `proceffect` <=> -1 AND `worneffect` <=> -1 AND `focuseffect` <=> -1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=135549 AND `itemclass` <=> 0 AND `itemtype` <=> 54 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> '' AND `booktype` <=> 0 AND `aagi` <=> 23 AND `ac` <=> 53 AND `acha` <=> 23 AND `adex` <=> 23 AND `aint` <=> 23 AND `asta` <=> 23 AND `astr` <=> 23 AND `attack` <=> 22 AND `augtype` <=> 1024 AND `awis` <=> 23 AND `clairvoyance` <=> 22 AND `cr` <=> 31 AND `damage` <=> 108 AND `dr` <=> 51 AND `endur` <=> 1807 AND `fr` <=> 31 AND `healamt` <=> 14 AND `hp` <=> 1807 AND `mana` <=> 1807 AND `manaregen` <=> 0 AND `mr` <=> 39 AND `pr` <=> 39 AND `regen` <=> 0 AND `slots` <=> 8192 AND `spelldmg` <=> 14 AND `proceffect` <=> 20620 AND `worneffect` <=> -1 AND `focuseffect` <=> -1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=135552 AND `itemclass` <=> 0 AND `itemtype` <=> 54 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> '' AND `booktype` <=> 0 AND `aagi` <=> 23 AND `ac` <=> 53 AND `acha` <=> 23 AND `adex` <=> 23 AND `aint` <=> 23 AND `asta` <=> 23 AND `astr` <=> 23 AND `attack` <=> 22 AND `augtype` <=> 1024 AND `awis` <=> 23 AND `clairvoyance` <=> 22 AND `cr` <=> 39 AND `damage` <=> 108 AND `dr` <=> 31 AND `endur` <=> 1807 AND `fr` <=> 39 AND `healamt` <=> 14 AND `hp` <=> 1807 AND `mana` <=> 1807 AND `manaregen` <=> 0 AND `mr` <=> 51 AND `pr` <=> 31 AND `regen` <=> 0 AND `slots` <=> 8192 AND `spelldmg` <=> 14 AND `proceffect` <=> 20655 AND `worneffect` <=> -1 AND `focuseffect` <=> -1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=135555 AND `itemclass` <=> 0 AND `itemtype` <=> 54 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> '' AND `booktype` <=> 0 AND `aagi` <=> 23 AND `ac` <=> 53 AND `acha` <=> 23 AND `adex` <=> 23 AND `aint` <=> 23 AND `asta` <=> 23 AND `astr` <=> 23 AND `attack` <=> 22 AND `augtype` <=> 1024 AND `awis` <=> 23 AND `clairvoyance` <=> 22 AND `cr` <=> 35 AND `damage` <=> 108 AND `dr` <=> 43 AND `endur` <=> 1807 AND `fr` <=> 35 AND `healamt` <=> 14 AND `hp` <=> 1807 AND `mana` <=> 1807 AND `manaregen` <=> 0 AND `mr` <=> 39 AND `pr` <=> 43 AND `regen` <=> 0 AND `slots` <=> 8192 AND `spelldmg` <=> 14 AND `proceffect` <=> 20634 AND `worneffect` <=> -1 AND `focuseffect` <=> -1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=135558 AND `itemclass` <=> 0 AND `itemtype` <=> 54 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> '' AND `booktype` <=> 0 AND `aagi` <=> 23 AND `ac` <=> 53 AND `acha` <=> 23 AND `adex` <=> 23 AND `aint` <=> 23 AND `asta` <=> 23 AND `astr` <=> 23 AND `attack` <=> 22 AND `augtype` <=> 1024 AND `awis` <=> 23 AND `clairvoyance` <=> 22 AND `cr` <=> 39 AND `damage` <=> 108 AND `dr` <=> 39 AND `endur` <=> 1807 AND `fr` <=> 39 AND `healamt` <=> 14 AND `hp` <=> 1807 AND `mana` <=> 1807 AND `manaregen` <=> 0 AND `mr` <=> 39 AND `pr` <=> 39 AND `regen` <=> 0 AND `slots` <=> 8192 AND `spelldmg` <=> 14 AND `proceffect` <=> -1 AND `worneffect` <=> -1 AND `focuseffect` <=> -1)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=135564 AND `itemclass` <=> 2 AND `itemtype` <=> 60 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 0 AND `deity` <=> 0 AND `reqlevel` <=> 96 AND `reclevel` <=> 100 AND `filename` <=> CONVERT(0x5453534b553230576561706f6e4a776c313030 USING utf8mb4) AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM books WHERE name=CONVERT(0x5453534b553230576561706f6e4a776c313030 USING utf8mb4) AND SHA2(txtfile,256)=CONVERT(0x39363035373865626163313332393165363136613938393134656566323963386133336336633762613037613835386636616632336665643936396430343038 USING utf8mb4))<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 native family book context mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc173_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc173_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc173_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc173_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc173_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc173_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 output producer universe changed'; END IF;

 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc173_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc173_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 item identity/dependency mismatch'; END IF;
 IF already_present<>18 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc173_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc173_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc173_recipes q ON q.id=r.recipe_id LEFT JOIN rrc173_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc173_recipes q ON q.id=r.recipe_id)<>162 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc173_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc173_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc173_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-18 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-162 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 rollback count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc173_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc173_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc173_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc173_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc173_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc173_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC173 output producer universe changed'; END IF;
 DROP TEMPORARY TABLE rrc173_peer_entries;
 DROP TEMPORARY TABLE rrc173_peer_recipes;
 DROP TEMPORARY TABLE rrc173_entries;
 DROP TEMPORARY TABLE rrc173_recipes;
 DROP TEMPORARY TABLE rrc173_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC173' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
