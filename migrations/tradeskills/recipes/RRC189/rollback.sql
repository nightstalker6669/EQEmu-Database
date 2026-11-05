-- RRC189: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc189_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc189_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc189_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc189_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3096386,CONVERT(0x4368726f6e616c20496e66757365642046726961626c6520506f74696f6e205669616c USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44207669616c2f436c6f7564792d6f7262207265636f6e737472756374696f6e3b205252433138392e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096387,CONVERT(0x4368726f6e616c20496e667573656420576f726b656420506f74696f6e205669616c USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44207669616c2f436c6f7564792d6f7262207265636f6e737472756374696f6e3b205252433138392e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096388,CONVERT(0x4368726f6e616c20496e66757365642053686170656420506f74696f6e205669616c USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44207669616c2f436c6f7564792d6f7262207265636f6e737472756374696f6e3b205252433138392e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096389,CONVERT(0x4368726f6e616c20496e667573656420466f726d656420506f74696f6e205669616c USING utf8mb4),69,0,17,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44207669616c2f436c6f7564792d6f7262207265636f6e737472756374696f6e3b205252433138392e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096390,CONVERT(0x556e6669726564204368726f6e616c20496e66757365642046726961626c6520506f74696f6e205669616c20536574 USING utf8mb4),69,0,138,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44207669616c2f436c6f7564792d6f7262207265636f6e737472756374696f6e3b205252433138392e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096391,CONVERT(0x556e6669726564204368726f6e616c20496e667573656420576f726b656420506f74696f6e205669616c20536574 USING utf8mb4),69,0,140,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44207669616c2f436c6f7564792d6f7262207265636f6e737472756374696f6e3b205252433138392e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096392,CONVERT(0x556e6669726564204368726f6e616c20496e66757365642053686170656420506f74696f6e205669616c20536574 USING utf8mb4),69,0,143,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44207669616c2f436c6f7564792d6f7262207265636f6e737472756374696f6e3b205252433138392e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096393,CONVERT(0x556e6669726564204368726f6e616c20496e667573656420466f726d656420506f74696f6e205669616c20536574 USING utf8mb4),69,0,146,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44207669616c2f436c6f7564792d6f7262207265636f6e737472756374696f6e3b205252433138392e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096394,CONVERT(0x556e666972656420436c6f75647920456e6572676569616e20496365204f7262 USING utf8mb4),69,0,330,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44207669616c2f436c6f7564792d6f7262207265636f6e737472756374696f6e3b205252433138392e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096395,CONVERT(0x556e666972656420436c6f75647920456e6572676569616e2046697265204f7262 USING utf8mb4),69,0,330,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44207669616c2f436c6f7564792d6f7262207265636f6e737472756374696f6e3b205252433138392e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096396,CONVERT(0x556e666972656420436c6f75647920456e6572676569616e204561727468204f7262 USING utf8mb4),69,0,330,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44207669616c2f436c6f7564792d6f7262207265636f6e737472756374696f6e3b205252433138392e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096397,CONVERT(0x556e666972656420436c6f75647920456e6572676569616e20416972204f7262 USING utf8mb4),69,0,330,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44207669616c2f436c6f7564792d6f7262207265636f6e737472756374696f6e3b205252433138392e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096398,CONVERT(0x556e666972656420436c6f75647920456e6572676569616e2047726f777468204f7262 USING utf8mb4),69,0,343,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44207669616c2f436c6f7564792d6f7262207265636f6e737472756374696f6e3b205252433138392e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096399,CONVERT(0x556e666972656420436c6f75647920456e6572676569616e204465636179204f7262 USING utf8mb4),69,0,343,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44207669616c2f436c6f7564792d6f7262207265636f6e737472756374696f6e3b205252433138392e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096400,CONVERT(0x556e666972656420436c6f75647920456e6572676569616e2044697365617365204f7262 USING utf8mb4),69,0,356,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44207669616c2f436c6f7564792d6f7262207265636f6e737472756374696f6e3b205252433138392e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096401,CONVERT(0x556e666972656420436c6f75647920456e6572676569616e204c69676874204f7262 USING utf8mb4),69,0,356,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44207669616c2f436c6f7564792d6f7262207265636f6e737472756374696f6e3b205252433138392e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096402,CONVERT(0x5365616c656420436c6f75647920456e6572676569616e20496365204f7262 USING utf8mb4),69,0,290,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44207669616c2f436c6f7564792d6f7262207265636f6e737472756374696f6e3b205252433138392e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096403,CONVERT(0x5365616c656420436c6f75647920456e6572676569616e2046697265204f7262 USING utf8mb4),69,0,290,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44207669616c2f436c6f7564792d6f7262207265636f6e737472756374696f6e3b205252433138392e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096404,CONVERT(0x5365616c656420436c6f75647920456e6572676569616e204561727468204f7262 USING utf8mb4),69,0,290,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44207669616c2f436c6f7564792d6f7262207265636f6e737472756374696f6e3b205252433138392e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096405,CONVERT(0x5365616c656420436c6f75647920456e6572676569616e20416972204f7262 USING utf8mb4),69,0,290,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44207669616c2f436c6f7564792d6f7262207265636f6e737472756374696f6e3b205252433138392e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096406,CONVERT(0x5365616c656420436c6f75647920456e6572676569616e2047726f777468204f7262 USING utf8mb4),69,0,303,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44207669616c2f436c6f7564792d6f7262207265636f6e737472756374696f6e3b205252433138392e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096407,CONVERT(0x5365616c656420436c6f75647920456e6572676569616e204465636179204f7262 USING utf8mb4),69,0,303,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44207669616c2f436c6f7564792d6f7262207265636f6e737472756374696f6e3b205252433138392e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096408,CONVERT(0x5365616c656420436c6f75647920456e6572676569616e2044697365617365204f7262 USING utf8mb4),69,0,316,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44207669616c2f436c6f7564792d6f7262207265636f6e737472756374696f6e3b205252433138392e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096409,CONVERT(0x5365616c656420436c6f75647920456e6572676569616e204c69676874204f7262 USING utf8mb4),69,0,316,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f44207669616c2f436c6f7564792d6f7262207265636f6e737472756374696f6e3b205252433138392e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL);
INSERT INTO rrc189_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3096386,16908,0,0,1,1,0),
(3096386,40577,3,0,0,0,0),
(3096386,40582,0,0,1,1,0),
(3096386,9,0,0,0,0,1),
(3096387,16908,0,0,1,1,0),
(3096387,40578,3,0,0,0,0),
(3096387,40583,0,0,1,1,0),
(3096387,9,0,0,0,0,1),
(3096388,16908,0,0,1,1,0),
(3096388,40579,3,0,0,0,0),
(3096388,40584,0,0,1,1,0),
(3096388,9,0,0,0,0,1),
(3096389,16908,0,0,1,1,0),
(3096389,40580,3,0,0,0,0),
(3096389,40585,0,0,1,1,0),
(3096389,9,0,0,0,0,1),
(3096390,16902,0,0,2,2,0),
(3096390,38340,0,0,3,3,0),
(3096390,40582,1,0,0,0,0),
(3096390,40586,0,0,1,1,0),
(3096390,96894,0,0,1,1,0),
(3096390,8,0,0,0,0,1),
(3096391,38340,0,0,3,3,0),
(3096391,40583,1,0,0,0,0),
(3096391,40586,0,0,1,1,0),
(3096391,96897,0,0,1,1,0),
(3096391,8,0,0,0,0,1),
(3096392,38340,0,0,3,3,0),
(3096392,40584,1,0,0,0,0),
(3096392,40586,0,0,1,1,0),
(3096392,96900,0,0,1,1,0),
(3096392,96904,0,0,2,2,0),
(3096392,8,0,0,0,0,1),
(3096393,16902,0,0,1,1,0),
(3096393,38340,0,0,3,3,0),
(3096393,40585,1,0,0,0,0),
(3096393,40586,0,0,1,1,0),
(3096393,96903,0,0,1,1,0),
(3096393,96904,0,0,3,3,0),
(3096393,8,0,0,0,0,1),
(3096394,10252,0,0,1,1,0),
(3096394,33828,0,0,1,1,0),
(3096394,33832,0,0,1,1,0),
(3096394,41807,0,0,1,1,0),
(3096394,41814,1,0,0,0,0),
(3096394,8,0,0,0,0,1),
(3096395,10252,0,0,1,1,0),
(3096395,33828,0,0,1,1,0),
(3096395,33833,0,0,1,1,0),
(3096395,41807,0,0,1,1,0),
(3096395,41815,1,0,0,0,0),
(3096395,8,0,0,0,0,1),
(3096396,10252,0,0,1,1,0),
(3096396,33828,0,0,1,1,0),
(3096396,33834,0,0,1,1,0),
(3096396,41807,0,0,1,1,0),
(3096396,41816,1,0,0,0,0),
(3096396,8,0,0,0,0,1),
(3096397,10252,0,0,1,1,0),
(3096397,33828,0,0,1,1,0),
(3096397,33835,0,0,1,1,0),
(3096397,41807,0,0,1,1,0),
(3096397,41817,1,0,0,0,0),
(3096397,8,0,0,0,0,1),
(3096398,10252,0,0,1,1,0),
(3096398,33828,0,0,1,1,0),
(3096398,33836,0,0,1,1,0),
(3096398,41807,0,0,1,1,0),
(3096398,41818,1,0,0,0,0),
(3096398,8,0,0,0,0,1),
(3096399,10252,0,0,1,1,0),
(3096399,33828,0,0,1,1,0),
(3096399,33837,0,0,1,1,0),
(3096399,41807,0,0,1,1,0),
(3096399,41819,1,0,0,0,0),
(3096399,8,0,0,0,0,1),
(3096400,10252,0,0,1,1,0),
(3096400,33828,0,0,1,1,0),
(3096400,33839,0,0,1,1,0),
(3096400,41807,0,0,1,1,0),
(3096400,41821,1,0,0,0,0),
(3096400,8,0,0,0,0,1),
(3096401,10252,0,0,1,1,0),
(3096401,33828,0,0,1,1,0),
(3096401,41807,0,0,1,1,0),
(3096401,41812,0,0,1,1,0),
(3096401,41824,1,0,0,0,0),
(3096401,8,0,0,0,0,1),
(3096402,16908,0,0,1,1,0),
(3096402,33832,0,0,1,1,0),
(3096402,41814,0,0,1,1,0),
(3096402,41870,4,0,0,0,0),
(3096402,9,0,0,0,0,1),
(3096403,16908,0,0,1,1,0),
(3096403,33833,0,0,1,1,0),
(3096403,41815,0,0,1,1,0),
(3096403,41871,4,0,0,0,0),
(3096403,9,0,0,0,0,1),
(3096404,16908,0,0,1,1,0),
(3096404,33834,0,0,1,1,0),
(3096404,41816,0,0,1,1,0),
(3096404,41872,4,0,0,0,0),
(3096404,9,0,0,0,0,1),
(3096405,16908,0,0,1,1,0),
(3096405,33835,0,0,1,1,0),
(3096405,41817,0,0,1,1,0),
(3096405,41873,4,0,0,0,0),
(3096405,9,0,0,0,0,1),
(3096406,16908,0,0,1,1,0),
(3096406,33836,0,0,1,1,0),
(3096406,41818,0,0,1,1,0),
(3096406,41874,4,0,0,0,0),
(3096406,9,0,0,0,0,1),
(3096407,16908,0,0,1,1,0),
(3096407,33837,0,0,1,1,0),
(3096407,41819,0,0,1,1,0),
(3096407,41875,4,0,0,0,0),
(3096407,9,0,0,0,0,1),
(3096408,16908,0,0,1,1,0),
(3096408,33839,0,0,1,1,0),
(3096408,41821,0,0,1,1,0),
(3096408,41877,4,0,0,0,0),
(3096408,9,0,0,0,0,1),
(3096409,16908,0,0,1,1,0),
(3096409,41812,0,0,1,1,0),
(3096409,41824,0,0,1,1,0),
(3096409,41880,4,0,0,0,0),
(3096409,9,0,0,0,0,1);
INSERT INTO rrc189_items (`id`,`name`) VALUES
(10252,CONVERT(0x5669616c206f6620436c656172204d616e61 USING utf8mb4)),
(16902,CONVERT(0x4c6172676520426c6f636b206f6620436c6179 USING utf8mb4)),
(16908,CONVERT(0x48696768205175616c69747920466972696e67205368656574 USING utf8mb4)),
(33828,CONVERT(0x53696c76657220496e667573656420456e6572676569616320436c6179 USING utf8mb4)),
(33832,CONVERT(0x44697374696c6c656420457373656e6365206f6620496365 USING utf8mb4)),
(33833,CONVERT(0x44697374696c6c656420457373656e6365206f662046697265 USING utf8mb4)),
(33834,CONVERT(0x44697374696c6c656420457373656e6365206f66204561727468 USING utf8mb4)),
(33835,CONVERT(0x44697374696c6c656420457373656e6365206f6620416972 USING utf8mb4)),
(33836,CONVERT(0x44697374696c6c656420457373656e6365206f662047726f777468 USING utf8mb4)),
(33837,CONVERT(0x44697374696c6c656420457373656e6365206f66204465636179 USING utf8mb4)),
(33839,CONVERT(0x44697374696c6c656420457373656e6365206f662044697365617365 USING utf8mb4)),
(38340,CONVERT(0x4875676520426c6f636b206f6620436c6179 USING utf8mb4)),
(40577,CONVERT(0x4368726f6e616c20496e66757365642046726961626c6520506f74696f6e205669616c USING utf8mb4)),
(40578,CONVERT(0x4368726f6e616c20496e667573656420576f726b656420506f74696f6e205669616c USING utf8mb4)),
(40579,CONVERT(0x4368726f6e616c20496e66757365642053686170656420506f74696f6e205669616c USING utf8mb4)),
(40580,CONVERT(0x4368726f6e616c20496e667573656420466f726d656420506f74696f6e205669616c USING utf8mb4)),
(40582,CONVERT(0x556e6669726564204368726f6e616c20496e66757365642046726961626c6520506f74696f6e205669616c20536574 USING utf8mb4)),
(40583,CONVERT(0x556e6669726564204368726f6e616c20496e667573656420576f726b656420506f74696f6e205669616c20536574 USING utf8mb4)),
(40584,CONVERT(0x556e6669726564204368726f6e616c20496e66757365642053686170656420506f74696f6e205669616c20536574 USING utf8mb4)),
(40585,CONVERT(0x556e6669726564204368726f6e616c20496e667573656420466f726d656420506f74696f6e205669616c20536574 USING utf8mb4)),
(40586,CONVERT(0x496e66757365642047656d2044757374 USING utf8mb4)),
(41807,CONVERT(0x436c6f75647920456e6572676569616e20536b65746368 USING utf8mb4)),
(41812,CONVERT(0x44697374696c6c656420457373656e6365206f66204c69676874 USING utf8mb4)),
(41814,CONVERT(0x556e666972656420436c6f75647920456e6572676569616e20496365204f7262 USING utf8mb4)),
(41815,CONVERT(0x556e666972656420436c6f75647920456e6572676569616e2046697265204f7262 USING utf8mb4)),
(41816,CONVERT(0x556e666972656420436c6f75647920456e6572676569616e204561727468204f7262 USING utf8mb4)),
(41817,CONVERT(0x556e666972656420436c6f75647920456e6572676569616e20416972204f7262 USING utf8mb4)),
(41818,CONVERT(0x556e666972656420436c6f75647920456e6572676569616e2047726f777468204f7262 USING utf8mb4)),
(41819,CONVERT(0x556e666972656420436c6f75647920456e6572676569616e204465636179204f7262 USING utf8mb4)),
(41821,CONVERT(0x556e666972656420436c6f75647920456e6572676569616e2044697365617365204f7262 USING utf8mb4)),
(41824,CONVERT(0x556e666972656420436c6f75647920456e6572676569616e204c69676874204f7262 USING utf8mb4)),
(41870,CONVERT(0x5365616c656420436c6f75647920456e6572676569616e20496365204f7262 USING utf8mb4)),
(41871,CONVERT(0x5365616c656420436c6f75647920456e6572676569616e2046697265204f7262 USING utf8mb4)),
(41872,CONVERT(0x5365616c656420436c6f75647920456e6572676569616e204561727468204f7262 USING utf8mb4)),
(41873,CONVERT(0x5365616c656420436c6f75647920456e6572676569616e20416972204f7262 USING utf8mb4)),
(41874,CONVERT(0x5365616c656420436c6f75647920456e6572676569616e2047726f777468204f7262 USING utf8mb4)),
(41875,CONVERT(0x5365616c656420436c6f75647920456e6572676569616e204465636179204f7262 USING utf8mb4)),
(41877,CONVERT(0x5365616c656420436c6f75647920456e6572676569616e2044697365617365204f7262 USING utf8mb4)),
(41880,CONVERT(0x5365616c656420436c6f75647920456e6572676569616e204c69676874204f7262 USING utf8mb4)),
(96894,CONVERT(0x416476616e6365642046726961626c6520506f74696f6e205669616c20536b65746368 USING utf8mb4)),
(96897,CONVERT(0x416476616e63656420576f726b656420506f74696f6e205669616c20536b65746368 USING utf8mb4)),
(96900,CONVERT(0x416476616e6365642053686170656420506f74696f6e205669616c20536b65746368 USING utf8mb4)),
(96903,CONVERT(0x416476616e63656420466f726d656420506f74696f6e205669616c20536b65746368 USING utf8mb4)),
(96904,CONVERT(0x47656d20506f77646572 USING utf8mb4));
 CREATE TEMPORARY TABLE rrc189_peer_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc189_peer_entries LIKE tradeskill_recipe_entries;
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 target database mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=10252 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16902 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16908 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=33828 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=33832 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=33833 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=33834 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=33835 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=33836 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=33837 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=33839 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=38340 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 3 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=40577 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=40578 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=40579 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=40580 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=40582 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=40583 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=40584 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=40585 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=40586 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41807 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41812 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41814 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41815 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41816 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41817 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41818 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41819 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41821 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41824 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41870 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 0 AND `deity` <=> 0 AND `reqlevel` <=> 65 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41871 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 0 AND `deity` <=> 0 AND `reqlevel` <=> 65 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41872 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 0 AND `deity` <=> 0 AND `reqlevel` <=> 65 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41873 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 0 AND `deity` <=> 0 AND `reqlevel` <=> 65 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41874 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 0 AND `deity` <=> 0 AND `reqlevel` <=> 65 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41875 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 0 AND `deity` <=> 0 AND `reqlevel` <=> 65 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41877 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 0 AND `deity` <=> 0 AND `reqlevel` <=> 65 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41880 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 0 AND `deity` <=> 0 AND `reqlevel` <=> 65 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96894 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96897 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96900 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96903 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=96904 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 1 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 native item semantics mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc189_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc189_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc189_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc189_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc189_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc189_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 output producer universe changed'; END IF;

 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc189_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc189_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 item identity/dependency mismatch'; END IF;
 IF already_present<>24 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc189_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc189_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc189_recipes q ON q.id=r.recipe_id LEFT JOIN rrc189_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc189_recipes q ON q.id=r.recipe_id)<>128 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc189_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc189_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc189_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-24 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-128 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 rollback count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc189_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc189_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc189_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc189_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc189_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc189_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC189 output producer universe changed'; END IF;
 DROP TEMPORARY TABLE rrc189_peer_entries;
 DROP TEMPORARY TABLE rrc189_peer_recipes;
 DROP TEMPORARY TABLE rrc189_entries;
 DROP TEMPORARY TABLE rrc189_recipes;
 DROP TEMPORARY TABLE rrc189_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC189' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
