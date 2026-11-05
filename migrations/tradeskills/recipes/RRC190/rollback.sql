-- RRC190: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc190_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc190_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc190_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc190_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3096410,CONVERT(0x556e666972656420436c6f75647920456e6572676569616e20506f69736f6e204f7262 USING utf8mb4),69,0,356,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f4420436c6f7564792f4d697374792d6f7262207265636f6e737472756374696f6e3b205252433139302e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096411,CONVERT(0x556e666972656420436c6f75647920456e6572676569616e205761746572204f7262 USING utf8mb4),69,0,356,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f4420436c6f7564792f4d697374792d6f7262207265636f6e737472756374696f6e3b205252433139302e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096412,CONVERT(0x556e666972656420436c6f75647920456e6572676569616e20536861646f77204f7262 USING utf8mb4),69,0,356,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f4420436c6f7564792f4d697374792d6f7262207265636f6e737472756374696f6e3b205252433139302e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096413,CONVERT(0x556e6669726564204d6973747920456e6572676569616e20496365204f7262 USING utf8mb4),69,0,370,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f4420436c6f7564792f4d697374792d6f7262207265636f6e737472756374696f6e3b205252433139302e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096414,CONVERT(0x556e6669726564204d6973747920456e6572676569616e2046697265204f7262 USING utf8mb4),69,0,370,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f4420436c6f7564792f4d697374792d6f7262207265636f6e737472756374696f6e3b205252433139302e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096415,CONVERT(0x556e6669726564204d6973747920456e6572676569616e204561727468204f7262 USING utf8mb4),69,0,370,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f4420436c6f7564792f4d697374792d6f7262207265636f6e737472756374696f6e3b205252433139302e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096416,CONVERT(0x556e6669726564204d6973747920456e6572676569616e20416972204f7262 USING utf8mb4),69,0,370,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f4420436c6f7564792f4d697374792d6f7262207265636f6e737472756374696f6e3b205252433139302e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096417,CONVERT(0x556e6669726564204d6973747920456e6572676569616e2047726f777468204f7262 USING utf8mb4),69,0,383,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f4420436c6f7564792f4d697374792d6f7262207265636f6e737472756374696f6e3b205252433139302e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096418,CONVERT(0x556e6669726564204d6973747920456e6572676569616e204465636179204f7262 USING utf8mb4),69,0,383,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f4420436c6f7564792f4d697374792d6f7262207265636f6e737472756374696f6e3b205252433139302e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096419,CONVERT(0x556e6669726564204d6973747920456e6572676569616e20506f69736f6e204f7262 USING utf8mb4),69,0,396,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f4420436c6f7564792f4d697374792d6f7262207265636f6e737472756374696f6e3b205252433139302e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096420,CONVERT(0x556e6669726564204d6973747920456e6572676569616e2044697365617365204f7262 USING utf8mb4),69,0,396,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f4420436c6f7564792f4d697374792d6f7262207265636f6e737472756374696f6e3b205252433139302e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096421,CONVERT(0x556e6669726564204d6973747920456e6572676569616e204c69676874204f7262 USING utf8mb4),69,0,396,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f4420436c6f7564792f4d697374792d6f7262207265636f6e737472756374696f6e3b205252433139302e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096422,CONVERT(0x5365616c656420436c6f75647920456e6572676569616e20506f69736f6e204f7262 USING utf8mb4),69,0,316,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f4420436c6f7564792f4d697374792d6f7262207265636f6e737472756374696f6e3b205252433139302e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096423,CONVERT(0x5365616c656420436c6f75647920456e6572676569616e205761746572204f7262 USING utf8mb4),69,0,316,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f4420436c6f7564792f4d697374792d6f7262207265636f6e737472756374696f6e3b205252433139302e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096424,CONVERT(0x5365616c656420436c6f75647920456e6572676569616e20536861646f77204f7262 USING utf8mb4),69,0,316,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f4420436c6f7564792f4d697374792d6f7262207265636f6e737472756374696f6e3b205252433139302e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096425,CONVERT(0x5365616c6564204d6973747920456e6572676569616e20496365204f7262 USING utf8mb4),69,0,316,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f4420436c6f7564792f4d697374792d6f7262207265636f6e737472756374696f6e3b205252433139302e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096426,CONVERT(0x5365616c6564204d6973747920456e6572676569616e2046697265204f7262 USING utf8mb4),69,0,316,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f4420436c6f7564792f4d697374792d6f7262207265636f6e737472756374696f6e3b205252433139302e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096427,CONVERT(0x5365616c6564204d6973747920456e6572676569616e204561727468204f7262 USING utf8mb4),69,0,316,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f4420436c6f7564792f4d697374792d6f7262207265636f6e737472756374696f6e3b205252433139302e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096428,CONVERT(0x5365616c6564204d6973747920456e6572676569616e20416972204f7262 USING utf8mb4),69,0,316,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f4420436c6f7564792f4d697374792d6f7262207265636f6e737472756374696f6e3b205252433139302e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096429,CONVERT(0x5365616c6564204d6973747920456e6572676569616e2047726f777468204f7262 USING utf8mb4),69,0,330,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f4420436c6f7564792f4d697374792d6f7262207265636f6e737472756374696f6e3b205252433139302e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096430,CONVERT(0x5365616c6564204d6973747920456e6572676569616e204465636179204f7262 USING utf8mb4),69,0,330,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f4420436c6f7564792f4d697374792d6f7262207265636f6e737472756374696f6e3b205252433139302e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096431,CONVERT(0x5365616c6564204d6973747920456e6572676569616e20506f69736f6e204f7262 USING utf8mb4),69,0,343,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f4420436c6f7564792f4d697374792d6f7262207265636f6e737472756374696f6e3b205252433139302e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096432,CONVERT(0x5365616c6564204d6973747920456e6572676569616e2044697365617365204f7262 USING utf8mb4),69,0,343,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f4420436c6f7564792f4d697374792d6f7262207265636f6e737472756374696f6e3b205252433139302e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL),
(3096433,CONVERT(0x5365616c6564204d6973747920456e6572676569616e204c69676874204f7262 USING utf8mb4),69,0,343,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920536f4420436c6f7564792f4d697374792d6f7262207265636f6e737472756374696f6e3b205252433139302e USING utf8mb4),0,0,0,1,15,-1,NULL,NULL);
INSERT INTO rrc190_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3096410,10252,0,0,1,1,0),
(3096410,33828,0,0,1,1,0),
(3096410,33838,0,0,1,1,0),
(3096410,41807,0,0,1,1,0),
(3096410,41820,1,0,0,0,0),
(3096410,8,0,0,0,0,1),
(3096411,10252,0,0,1,1,0),
(3096411,33828,0,0,1,1,0),
(3096411,41807,0,0,1,1,0),
(3096411,41811,0,0,1,1,0),
(3096411,41822,1,0,0,0,0),
(3096411,8,0,0,0,0,1),
(3096412,10252,0,0,1,1,0),
(3096412,33828,0,0,1,1,0),
(3096412,41807,0,0,1,1,0),
(3096412,41813,0,0,1,1,0),
(3096412,41823,1,0,0,0,0),
(3096412,8,0,0,0,0,1),
(3096413,10253,0,0,1,1,0),
(3096413,33828,0,0,1,1,0),
(3096413,33832,0,0,1,1,0),
(3096413,41808,0,0,1,1,0),
(3096413,41825,1,0,0,0,0),
(3096413,8,0,0,0,0,1),
(3096414,10253,0,0,1,1,0),
(3096414,33828,0,0,1,1,0),
(3096414,33833,0,0,1,1,0),
(3096414,41808,0,0,1,1,0),
(3096414,41826,1,0,0,0,0),
(3096414,8,0,0,0,0,1),
(3096415,10253,0,0,1,1,0),
(3096415,33828,0,0,1,1,0),
(3096415,33834,0,0,1,1,0),
(3096415,41808,0,0,1,1,0),
(3096415,41827,1,0,0,0,0),
(3096415,8,0,0,0,0,1),
(3096416,10253,0,0,1,1,0),
(3096416,33828,0,0,1,1,0),
(3096416,33835,0,0,1,1,0),
(3096416,41808,0,0,1,1,0),
(3096416,41828,1,0,0,0,0),
(3096416,8,0,0,0,0,1),
(3096417,10253,0,0,1,1,0),
(3096417,33828,0,0,1,1,0),
(3096417,33836,0,0,1,1,0),
(3096417,41808,0,0,1,1,0),
(3096417,41829,1,0,0,0,0),
(3096417,8,0,0,0,0,1),
(3096418,10253,0,0,1,1,0),
(3096418,33828,0,0,1,1,0),
(3096418,33837,0,0,1,1,0),
(3096418,41808,0,0,1,1,0),
(3096418,41830,1,0,0,0,0),
(3096418,8,0,0,0,0,1),
(3096419,10253,0,0,1,1,0),
(3096419,33828,0,0,1,1,0),
(3096419,33838,0,0,1,1,0),
(3096419,41808,0,0,1,1,0),
(3096419,41831,1,0,0,0,0),
(3096419,8,0,0,0,0,1),
(3096420,10253,0,0,1,1,0),
(3096420,33828,0,0,1,1,0),
(3096420,33839,0,0,1,1,0),
(3096420,41808,0,0,1,1,0),
(3096420,41832,1,0,0,0,0),
(3096420,8,0,0,0,0,1),
(3096421,10253,0,0,1,1,0),
(3096421,33828,0,0,1,1,0),
(3096421,41808,0,0,1,1,0),
(3096421,41812,0,0,1,1,0),
(3096421,41835,1,0,0,0,0),
(3096421,8,0,0,0,0,1),
(3096422,16908,0,0,1,1,0),
(3096422,33838,0,0,1,1,0),
(3096422,41820,0,0,1,1,0),
(3096422,41876,4,0,0,0,0),
(3096422,9,0,0,0,0,1),
(3096423,16908,0,0,1,1,0),
(3096423,41811,0,0,1,1,0),
(3096423,41822,0,0,1,1,0),
(3096423,41878,4,0,0,0,0),
(3096423,9,0,0,0,0,1),
(3096424,16908,0,0,1,1,0),
(3096424,41813,0,0,1,1,0),
(3096424,41823,0,0,1,1,0),
(3096424,41879,4,0,0,0,0),
(3096424,9,0,0,0,0,1),
(3096425,16908,0,0,1,1,0),
(3096425,33832,0,0,1,1,0),
(3096425,41825,0,0,1,1,0),
(3096425,41881,3,0,0,0,0),
(3096425,9,0,0,0,0,1),
(3096426,16908,0,0,1,1,0),
(3096426,33833,0,0,1,1,0),
(3096426,41826,0,0,1,1,0),
(3096426,41882,3,0,0,0,0),
(3096426,9,0,0,0,0,1),
(3096427,16908,0,0,1,1,0),
(3096427,33834,0,0,1,1,0),
(3096427,41827,0,0,1,1,0),
(3096427,41883,3,0,0,0,0),
(3096427,9,0,0,0,0,1),
(3096428,16908,0,0,1,1,0),
(3096428,33835,0,0,1,1,0),
(3096428,41828,0,0,1,1,0),
(3096428,41884,3,0,0,0,0),
(3096428,9,0,0,0,0,1),
(3096429,16908,0,0,1,1,0),
(3096429,33836,0,0,1,1,0),
(3096429,41829,0,0,1,1,0),
(3096429,41885,3,0,0,0,0),
(3096429,9,0,0,0,0,1),
(3096430,16908,0,0,1,1,0),
(3096430,33837,0,0,1,1,0),
(3096430,41830,0,0,1,1,0),
(3096430,41886,3,0,0,0,0),
(3096430,9,0,0,0,0,1),
(3096431,16908,0,0,1,1,0),
(3096431,33838,0,0,1,1,0),
(3096431,41831,0,0,1,1,0),
(3096431,41887,3,0,0,0,0),
(3096431,9,0,0,0,0,1),
(3096432,16908,0,0,1,1,0),
(3096432,33839,0,0,1,1,0),
(3096432,41832,0,0,1,1,0),
(3096432,41888,3,0,0,0,0),
(3096432,9,0,0,0,0,1),
(3096433,16908,0,0,1,1,0),
(3096433,41812,0,0,1,1,0),
(3096433,41835,0,0,1,1,0),
(3096433,41891,3,0,0,0,0),
(3096433,9,0,0,0,0,1);
INSERT INTO rrc190_items (`id`,`name`) VALUES
(10252,CONVERT(0x5669616c206f6620436c656172204d616e61 USING utf8mb4)),
(10253,CONVERT(0x5669616c206f662044697374696c6c6564204d616e61 USING utf8mb4)),
(16908,CONVERT(0x48696768205175616c69747920466972696e67205368656574 USING utf8mb4)),
(33828,CONVERT(0x53696c76657220496e667573656420456e6572676569616320436c6179 USING utf8mb4)),
(33832,CONVERT(0x44697374696c6c656420457373656e6365206f6620496365 USING utf8mb4)),
(33833,CONVERT(0x44697374696c6c656420457373656e6365206f662046697265 USING utf8mb4)),
(33834,CONVERT(0x44697374696c6c656420457373656e6365206f66204561727468 USING utf8mb4)),
(33835,CONVERT(0x44697374696c6c656420457373656e6365206f6620416972 USING utf8mb4)),
(33836,CONVERT(0x44697374696c6c656420457373656e6365206f662047726f777468 USING utf8mb4)),
(33837,CONVERT(0x44697374696c6c656420457373656e6365206f66204465636179 USING utf8mb4)),
(33838,CONVERT(0x44697374696c6c656420457373656e6365206f6620506f69736f6e USING utf8mb4)),
(33839,CONVERT(0x44697374696c6c656420457373656e6365206f662044697365617365 USING utf8mb4)),
(41807,CONVERT(0x436c6f75647920456e6572676569616e20536b65746368 USING utf8mb4)),
(41808,CONVERT(0x4d6973747920456e6572676569616e20536b65746368 USING utf8mb4)),
(41811,CONVERT(0x44697374696c6c656420457373656e6365206f66205761746572 USING utf8mb4)),
(41812,CONVERT(0x44697374696c6c656420457373656e6365206f66204c69676874 USING utf8mb4)),
(41813,CONVERT(0x44697374696c6c656420457373656e6365206f6620536861646f77 USING utf8mb4)),
(41820,CONVERT(0x556e666972656420436c6f75647920456e6572676569616e20506f69736f6e204f7262 USING utf8mb4)),
(41822,CONVERT(0x556e666972656420436c6f75647920456e6572676569616e205761746572204f7262 USING utf8mb4)),
(41823,CONVERT(0x556e666972656420436c6f75647920456e6572676569616e20536861646f77204f7262 USING utf8mb4)),
(41825,CONVERT(0x556e6669726564204d6973747920456e6572676569616e20496365204f7262 USING utf8mb4)),
(41826,CONVERT(0x556e6669726564204d6973747920456e6572676569616e2046697265204f7262 USING utf8mb4)),
(41827,CONVERT(0x556e6669726564204d6973747920456e6572676569616e204561727468204f7262 USING utf8mb4)),
(41828,CONVERT(0x556e6669726564204d6973747920456e6572676569616e20416972204f7262 USING utf8mb4)),
(41829,CONVERT(0x556e6669726564204d6973747920456e6572676569616e2047726f777468204f7262 USING utf8mb4)),
(41830,CONVERT(0x556e6669726564204d6973747920456e6572676569616e204465636179204f7262 USING utf8mb4)),
(41831,CONVERT(0x556e6669726564204d6973747920456e6572676569616e20506f69736f6e204f7262 USING utf8mb4)),
(41832,CONVERT(0x556e6669726564204d6973747920456e6572676569616e2044697365617365204f7262 USING utf8mb4)),
(41835,CONVERT(0x556e6669726564204d6973747920456e6572676569616e204c69676874204f7262 USING utf8mb4)),
(41876,CONVERT(0x5365616c656420436c6f75647920456e6572676569616e20506f69736f6e204f7262 USING utf8mb4)),
(41878,CONVERT(0x5365616c656420436c6f75647920456e6572676569616e205761746572204f7262 USING utf8mb4)),
(41879,CONVERT(0x5365616c656420436c6f75647920456e6572676569616e20536861646f77204f7262 USING utf8mb4)),
(41881,CONVERT(0x5365616c6564204d6973747920456e6572676569616e20496365204f7262 USING utf8mb4)),
(41882,CONVERT(0x5365616c6564204d6973747920456e6572676569616e2046697265204f7262 USING utf8mb4)),
(41883,CONVERT(0x5365616c6564204d6973747920456e6572676569616e204561727468204f7262 USING utf8mb4)),
(41884,CONVERT(0x5365616c6564204d6973747920456e6572676569616e20416972204f7262 USING utf8mb4)),
(41885,CONVERT(0x5365616c6564204d6973747920456e6572676569616e2047726f777468204f7262 USING utf8mb4)),
(41886,CONVERT(0x5365616c6564204d6973747920456e6572676569616e204465636179204f7262 USING utf8mb4)),
(41887,CONVERT(0x5365616c6564204d6973747920456e6572676569616e20506f69736f6e204f7262 USING utf8mb4)),
(41888,CONVERT(0x5365616c6564204d6973747920456e6572676569616e2044697365617365204f7262 USING utf8mb4)),
(41891,CONVERT(0x5365616c6564204d6973747920456e6572676569616e204c69676874204f7262 USING utf8mb4));
 CREATE TEMPORARY TABLE rrc190_peer_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc190_peer_entries LIKE tradeskill_recipe_entries;
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 target database mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=10252 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=10253 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=16908 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=33828 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=33832 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=33833 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=33834 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=33835 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=33836 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=33837 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=33838 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=33839 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41807 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41808 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41811 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41812 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41813 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41820 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41822 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41823 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41825 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41826 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41827 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41828 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41829 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41830 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41831 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41832 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41835 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 0 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41876 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 0 AND `deity` <=> 0 AND `reqlevel` <=> 65 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41878 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 0 AND `deity` <=> 0 AND `reqlevel` <=> 65 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41879 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 0 AND `deity` <=> 0 AND `reqlevel` <=> 65 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41881 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 0 AND `deity` <=> 0 AND `reqlevel` <=> 70 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41882 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 0 AND `deity` <=> 0 AND `reqlevel` <=> 70 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41883 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 0 AND `deity` <=> 0 AND `reqlevel` <=> 70 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41884 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 0 AND `deity` <=> 0 AND `reqlevel` <=> 70 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41885 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 0 AND `deity` <=> 0 AND `reqlevel` <=> 70 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41886 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 0 AND `deity` <=> 0 AND `reqlevel` <=> 70 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41887 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 0 AND `deity` <=> 0 AND `reqlevel` <=> 70 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41888 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 0 AND `deity` <=> 0 AND `reqlevel` <=> 70 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=41891 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `size` <=> 0 AND `maxcharges` <=> 1 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 0 AND `deity` <=> 0 AND `reqlevel` <=> 70 AND `reclevel` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 native item semantics mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc190_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc190_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc190_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc190_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc190_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc190_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 output producer universe changed'; END IF;

 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc190_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc190_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 item identity/dependency mismatch'; END IF;
 IF already_present<>24 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc190_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc190_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc190_recipes q ON q.id=r.recipe_id LEFT JOIN rrc190_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc190_recipes q ON q.id=r.recipe_id)<>132 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc190_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc190_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc190_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-24 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-132 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 rollback count mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc190_peer_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 existing output-use peer definition drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc190_peer_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc190_peer_recipes p ON p.id=r.recipe_id)<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 existing output-use peer entry drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc190_entries e ON r.item_id=e.item_id AND e.successcount>e.componentcount AND e.iscontainer=0 WHERE r.successcount>0 AND r.iscontainer=0 AND NOT EXISTS(SELECT 1 FROM rrc190_recipes n WHERE n.id=r.recipe_id) AND NOT EXISTS(SELECT 1 FROM rrc190_peer_recipes p WHERE p.id=r.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC190 output producer universe changed'; END IF;
 DROP TEMPORARY TABLE rrc190_peer_entries;
 DROP TEMPORARY TABLE rrc190_peer_recipes;
 DROP TEMPORARY TABLE rrc190_entries;
 DROP TEMPORARY TABLE rrc190_recipes;
 DROP TEMPORARY TABLE rrc190_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC190' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
