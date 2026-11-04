-- RRC081: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc081_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc081_parents LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc081_parent_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc081_required_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc081_required_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc081_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc081_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc081_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3093644,CONVERT(0x546f6d65206f66204563686f206f6620446563657074696f6e20526b2e204949 USING utf8mb4),58,0,440,0,0,CONVERT(0x5072696d617279204d6f6e6b205072696d657220746f6d6520666f726d756c613b206578697374696e6720546f6d652042696e64696e67204b697420726f7574653b205252433038312e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093645,CONVERT(0x546f6d65206f6620576865656c206f6620466973747320526b2e204949 USING utf8mb4),58,0,444,0,0,CONVERT(0x5072696d617279204d6f6e6b205072696d657220746f6d6520666f726d756c613b206578697374696e6720546f6d652042696e64696e67204b697420726f7574653b205252433038312e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093646,CONVERT(0x546f6d65206f66205368696d6d6572696e672053696c686f756574746520526b2e204949 USING utf8mb4),58,0,432,0,0,CONVERT(0x5072696d617279204d6f6e6b205072696d657220746f6d6520666f726d756c613b206578697374696e6720546f6d652042696e64696e67204b697420726f7574653b205252433038312e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093647,CONVERT(0x546f6d65206f66204d6f6d656e74206f66205472616e7175696c69747920526b2e204949 USING utf8mb4),58,0,450,0,0,CONVERT(0x5072696d617279204d6f6e6b205072696d657220746f6d6520666f726d756c613b206578697374696e6720546f6d652042696e64696e67204b697420726f7574653b205252433038312e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093648,CONVERT(0x546f6d65206f662041737472616c2050726f6a656374696f6e20526b2e204949 USING utf8mb4),58,0,436,0,0,CONVERT(0x5072696d617279204d6f6e6b205072696d657220746f6d6520666f726d756c613b206578697374696e6720546f6d652042696e64696e67204b697420726f7574653b205252433038312e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093649,CONVERT(0x546f6d65206f662044656c617920446561746820526b2e204949 USING utf8mb4),58,0,450,0,0,CONVERT(0x5072696d617279204d6f6e6b205072696d657220746f6d6520666f726d756c613b206578697374696e6720546f6d652042696e64696e67204b697420726f7574653b205252433038312e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093650,CONVERT(0x546f6d65206f66204372797374616c70616c6d204469736369706c696e6520526b2e204949 USING utf8mb4),58,0,444,0,0,CONVERT(0x5072696d617279204d6f6e6b205072696d657220746f6d6520666f726d756c613b206578697374696e6720546f6d652042696e64696e67204b697420726f7574653b205252433038312e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL);
INSERT INTO rrc081_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3093644,115785,1,0,0,0,0),
(3093644,93555,0,0,1,1,0),
(3093644,90314,0,0,1,1,0),
(3093644,93589,0,0,1,1,0),
(3093644,93590,0,0,1,1,0),
(3093644,41526,0,0,1,1,0),
(3093644,41534,0,0,1,1,0),
(3093644,41555,0,0,0,0,1),
(3093645,115797,1,0,0,0,0),
(3093645,93542,0,0,1,1,0),
(3093645,41544,0,0,3,3,0),
(3093645,41526,0,0,1,1,0),
(3093645,90315,0,0,1,1,0),
(3093645,41536,0,0,1,1,0),
(3093645,41555,0,0,0,0,1),
(3093646,115800,1,0,0,0,0),
(3093646,93555,0,0,1,1,0),
(3093646,93542,0,0,1,1,0),
(3093646,93590,0,0,1,1,0),
(3093646,41526,0,0,1,1,0),
(3093646,90312,0,0,1,1,0),
(3093646,41555,0,0,0,0,1),
(3093647,115803,1,0,0,0,0),
(3093647,90316,0,0,1,1,0),
(3093647,93542,0,0,1,1,0),
(3093647,93575,0,0,1,1,0),
(3093647,93578,0,0,1,1,0),
(3093647,93553,0,0,1,1,0),
(3093647,41526,0,0,1,1,0),
(3093647,41555,0,0,0,0,1),
(3093648,115812,1,0,0,0,0),
(3093648,93557,0,0,1,1,0),
(3093648,93542,0,0,1,1,0),
(3093648,93576,0,0,1,1,0),
(3093648,90313,0,0,1,1,0),
(3093648,41526,0,0,1,1,0),
(3093648,41555,0,0,0,0,1),
(3093649,115815,1,0,0,0,0),
(3093649,90316,0,0,1,1,0),
(3093649,93542,0,0,1,1,0),
(3093649,93573,0,0,1,1,0),
(3093649,93553,0,0,1,1,0),
(3093649,41526,0,0,1,1,0),
(3093649,41555,0,0,0,0,1),
(3093650,115821,1,0,0,0,0),
(3093650,93542,0,0,1,1,0),
(3093650,93578,0,0,2,2,0),
(3093650,93553,0,0,1,1,0),
(3093650,41526,0,0,1,1,0),
(3093650,90315,0,0,1,1,0),
(3093650,41555,0,0,0,0,1);
INSERT INTO rrc081_items (`id`,`name`) VALUES
(41526,CONVERT(0x5175696c6c206f6620746865205472616e7363656e64656e74 USING utf8mb4)),
(41534,CONVERT(0x52616c6c6f732720496e6b204164646974697665 USING utf8mb4)),
(41536,CONVERT(0x537472696b696e6720546869636b656e6572 USING utf8mb4)),
(41544,CONVERT(0x496e6b206f662046696e65737365 USING utf8mb4)),
(41555,CONVERT(0x546f6d652042696e64696e67204b6974 USING utf8mb4)),
(90312,CONVERT(0x526f756768205072696d6572 USING utf8mb4)),
(90313,CONVERT(0x5072696d6572 USING utf8mb4)),
(90314,CONVERT(0x46696e65205072696d6572 USING utf8mb4)),
(90315,CONVERT(0x52756e6963205072696d6572 USING utf8mb4)),
(90316,CONVERT(0x46696e652052756e6963205072696d6572 USING utf8mb4)),
(93542,CONVERT(0x496e6b204164646974697665206f6620746865204e616d656c657373 USING utf8mb4)),
(93553,CONVERT(0x496e7669676f726174696e6720546869636b656e6572 USING utf8mb4)),
(93555,CONVERT(0x446562696c69746174696e6720546869636b656e6572 USING utf8mb4)),
(93557,CONVERT(0x436f6e6a7572696e6720546869636b656e6572 USING utf8mb4)),
(93573,CONVERT(0x496e6b206f662054756e617265 USING utf8mb4)),
(93575,CONVERT(0x496e6b206f662074686520426f6172 USING utf8mb4)),
(93576,CONVERT(0x496e6b206f6620746865204561676c65 USING utf8mb4)),
(93578,CONVERT(0x496e6b206f66205a656b USING utf8mb4)),
(93589,CONVERT(0x496e6b206f6620466f7267657466756c6e657373 USING utf8mb4)),
(93590,CONVERT(0x496e6b206f66205472616e7175696c697479 USING utf8mb4)),
(115785,CONVERT(0x546f6d65206f66204563686f206f6620446563657074696f6e20526b2e204949 USING utf8mb4)),
(115797,CONVERT(0x546f6d65206f6620576865656c206f6620466973747320526b2e204949 USING utf8mb4)),
(115800,CONVERT(0x546f6d65206f66205368696d6d6572696e672053696c686f756574746520526b2e204949 USING utf8mb4)),
(115803,CONVERT(0x546f6d65206f66204d6f6d656e74206f66205472616e7175696c69747920526b2e204949 USING utf8mb4)),
(115812,CONVERT(0x546f6d65206f662041737472616c2050726f6a656374696f6e20526b2e204949 USING utf8mb4)),
(115815,CONVERT(0x546f6d65206f662044656c617920446561746820526b2e204949 USING utf8mb4)),
(115821,CONVERT(0x546f6d65206f66204372797374616c70616c6d204469736369706c696e6520526b2e204949 USING utf8mb4));
INSERT INTO rrc081_parents (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(12347,CONVERT(0x546f6d65204f66204469736369706c65732041757261 USING utf8mb4),58,0,172,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12358,CONVERT(0x546f6d65204f66204c656f7061726420436c6177 USING utf8mb4),58,0,299,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12364,CONVERT(0x546f6d65204f66205068616e746f6d20536861646f77 USING utf8mb4),58,0,332,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12368,CONVERT(0x546f6d65204f6620447265616d77616c6b204469736369706c696e65 USING utf8mb4),58,0,339,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12378,CONVERT(0x546f6d65204f6620447261676f6e2046616e67 USING utf8mb4),58,0,350,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12390,CONVERT(0x536b696c6c3a204d617374657227732041757261 USING utf8mb4),58,0,354,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12393,CONVERT(0x536b696c6c3a204865656c204f66204b616e6a69 USING utf8mb4),58,0,355,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12400,CONVERT(0x546f6d65204f6620436f756e746572666f726365204469736369706c696e65 USING utf8mb4),58,0,355,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12401,CONVERT(0x546f6d65204f66205068616e746f6d2053696c686f756574746520526b2e204969 USING utf8mb4),58,0,355,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12423,CONVERT(0x546f6d65204f66205068616e746f6d20437279 USING utf8mb4),58,0,362,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12434,CONVERT(0x546f6d65204f66204563686f204f66204d6973646972656374696f6e20526b2e204969 USING utf8mb4),58,0,364,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12438,CONVERT(0x546f6d65204f6620496d70656e65747261626c65204469736369706c696e6520526b2e204969 USING utf8mb4),58,0,366,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12452,CONVERT(0x546f6d65204f6620436c6177737472696b6572277320466c7572727920526b2e204969 USING utf8mb4),58,0,370,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12454,CONVERT(0x546f6d65204f66205261706964204b69636b204469736369706c696e65 USING utf8mb4),58,0,370,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12480,CONVERT(0x546f6d65204f66204d6f6d656e74204f662043616c6d20526b2e204969 USING utf8mb4),58,0,374,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12481,CONVERT(0x546f6d65204f66205363616c656466697374204469736369706c696e6520526b2e204969 USING utf8mb4),58,0,374,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12373,CONVERT(0x536b696c6c3a204669737473204f66205775 USING utf8mb4),58,0,343,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL);
INSERT INTO rrc081_parent_entries (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(146447,12347,41610,0,0,1,1,0),
(146448,12347,93542,0,0,1,1,0),
(146449,12347,38507,0,0,1,1,0),
(146450,12347,38506,0,0,1,1,0),
(146451,12347,38508,0,0,1,1,0),
(146452,12347,41526,0,0,1,1,0),
(146453,12347,93554,0,0,1,1,0),
(146454,12347,78021,1,0,0,0,0),
(146455,12347,41555,0,0,0,0,1),
(146544,12358,93542,0,0,1,1,0),
(146545,12358,41544,0,0,1,1,0),
(146546,12358,93587,0,0,1,1,0),
(146547,12358,41616,0,0,1,1,0),
(146548,12358,41526,0,0,1,1,0),
(146549,12358,41536,0,0,1,1,0),
(146551,12358,41555,0,0,0,0,1),
(146592,12364,93555,0,0,1,1,0),
(146593,12364,93542,0,0,1,1,0),
(146594,12364,93588,0,0,1,1,0),
(146595,12364,41541,0,0,1,1,0),
(146596,12364,41542,0,0,1,1,0),
(146597,12364,41526,0,0,1,1,0),
(146598,12364,41620,0,0,1,1,0),
(146599,12364,59912,1,0,0,0,0),
(146600,12364,41555,0,0,0,0,1),
(146624,12368,41621,0,0,1,1,0),
(146625,12368,93542,0,0,1,1,0),
(146626,12368,93577,0,0,1,1,0),
(146627,12368,93564,0,0,1,1,0),
(146628,12368,93553,0,0,1,1,0),
(146629,12368,41526,0,0,1,1,0),
(146630,12368,77289,1,0,0,0,0),
(146631,12368,41555,0,0,0,0,1),
(146698,12378,93542,0,0,1,1,0),
(146699,12378,41544,0,0,1,1,0),
(146700,12378,93587,0,0,1,1,0),
(146701,12378,41526,0,0,1,1,0),
(146702,12378,41624,0,0,1,1,0),
(146703,12378,41536,0,0,1,1,0),
(146704,12378,76034,1,0,0,0,0),
(146705,12378,41555,0,0,0,0,1),
(146801,12390,41625,0,0,1,1,0),
(146802,12390,93542,0,0,1,1,0),
(146803,12390,38507,0,0,1,1,0),
(146804,12390,38506,0,0,1,1,0),
(146805,12390,38508,0,0,1,1,0),
(146806,12390,41526,0,0,1,1,0),
(146807,12390,93554,0,0,1,1,0),
(146808,12390,77985,1,0,0,0,0),
(146809,12390,41555,0,0,0,0,1),
(146824,12393,41625,0,0,1,1,0),
(146825,12393,93542,0,0,1,1,0),
(146826,12393,41539,0,0,1,1,0),
(146827,12393,41550,0,0,1,1,0),
(146828,12393,41537,0,0,1,1,0),
(146829,12393,93553,0,0,1,1,0),
(146830,12393,41526,0,0,1,1,0),
(146831,12393,77984,1,0,0,0,0),
(146832,12393,41555,0,0,0,0,1),
(146881,12400,41623,0,0,1,1,0),
(146882,12400,93542,0,0,1,1,0),
(146883,12400,93580,0,0,1,1,0),
(146884,12400,41545,0,0,1,1,0),
(146885,12400,93553,0,0,1,1,0),
(146886,12400,41526,0,0,1,1,0),
(146887,12400,77291,1,0,0,0,0),
(146888,12400,41555,0,0,0,0,1),
(146889,12401,93555,0,0,1,1,0),
(146890,12401,93542,0,0,1,1,0),
(146891,12401,93590,0,0,1,1,0),
(146892,12401,41526,0,0,1,1,0),
(146893,12401,41626,0,0,1,1,0),
(146894,12401,79285,1,0,0,0,0),
(146895,12401,41555,0,0,0,0,1),
(147072,12423,93555,0,0,1,1,0),
(147073,12423,93542,0,0,1,1,0),
(147074,12423,41542,0,0,1,1,0),
(147075,12423,41526,0,0,1,1,0),
(147076,12423,41624,0,0,1,1,0),
(147077,12423,77285,1,0,0,0,0),
(147078,12423,41555,0,0,0,0,1),
(147161,12434,93555,0,0,1,1,0),
(147162,12434,41628,0,0,1,1,0),
(147163,12434,93589,0,0,1,1,0),
(147164,12434,93590,0,0,1,1,0),
(147165,12434,41526,0,0,1,1,0),
(147166,12434,41534,0,0,1,1,0),
(147167,12434,79270,1,0,0,0,0),
(147168,12434,41555,0,0,0,0,1),
(147194,12438,41627,0,0,1,1,0),
(147195,12438,93542,0,0,1,1,0),
(147196,12438,93561,0,0,1,1,0),
(147197,12438,93579,0,0,2,2,0),
(147198,12438,93578,0,0,3,3,0),
(147199,12438,93553,0,0,1,1,0),
(147200,12438,41526,0,0,1,1,0),
(147201,12438,79276,1,0,0,0,0),
(147202,12438,41555,0,0,0,0,1),
(147306,12452,93542,0,0,1,1,0),
(147307,12452,41544,0,0,3,3,0),
(147308,12452,41526,0,0,1,1,0),
(147309,12452,41629,0,0,1,1,0),
(147310,12452,41536,0,0,1,1,0),
(147311,12452,79282,1,0,0,0,0),
(147312,12452,41555,0,0,0,0,1),
(147320,12454,41625,0,0,1,1,0),
(147321,12454,93542,0,0,1,1,0),
(147322,12454,41550,0,0,1,1,0),
(147323,12454,93553,0,0,1,1,0),
(147324,12454,41526,0,0,1,1,0),
(147325,12454,77290,1,0,0,0,0),
(147326,12454,41555,0,0,0,0,1),
(147537,12480,41630,0,0,1,1,0),
(147538,12480,93542,0,0,1,1,0),
(147539,12480,93575,0,0,1,1,0),
(147540,12480,93578,0,0,1,1,0),
(147541,12480,93553,0,0,1,1,0),
(147542,12480,41526,0,0,1,1,0),
(147543,12480,79288,1,0,0,0,0),
(147544,12480,41555,0,0,0,0,1),
(147545,12481,93542,0,0,1,1,0),
(147546,12481,41539,0,0,6,6,0),
(147547,12481,93553,0,0,1,1,0),
(147548,12481,41526,0,0,1,1,0),
(147549,12481,41629,0,0,1,1,0),
(147550,12481,79445,1,0,0,0,0),
(147551,12481,41555,0,0,0,0,1),
(152271,12358,76051,1,0,0,0,0),
(146662,12373,41623,0,0,1,1,0),
(146663,12373,93542,0,0,1,1,0),
(146664,12373,41553,0,0,1,1,0),
(146665,12373,41526,0,0,1,1,0),
(146666,12373,93554,0,0,1,1,0),
(146667,12373,77895,1,0,0,0,0),
(146668,12373,41555,0,0,0,0,1);
INSERT INTO rrc081_required_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3093638,CONVERT(0x526f756768205072696d6572 USING utf8mb4),58,0,243,0,0,CONVERT(0x5072696d617279205072696d6572207072657061726174696f6e3b206578697374696e6720546f6d652042696e64696e67204b697420726f757465206f6e6c793b205252433037382e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093639,CONVERT(0x5072696d6572 USING utf8mb4),58,0,243,0,0,CONVERT(0x5072696d617279205072696d6572207072657061726174696f6e3b206578697374696e6720546f6d652042696e64696e67204b697420726f757465206f6e6c793b205252433037382e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093640,CONVERT(0x46696e65205072696d6572 USING utf8mb4),58,0,243,0,0,CONVERT(0x5072696d617279205072696d6572207072657061726174696f6e3b206578697374696e6720546f6d652042696e64696e67204b697420726f757465206f6e6c793b205252433037382e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093641,CONVERT(0x52756e6963205072696d6572 USING utf8mb4),58,0,243,0,0,CONVERT(0x5072696d617279205072696d6572207072657061726174696f6e3b206578697374696e6720546f6d652042696e64696e67204b697420726f757465206f6e6c793b205252433037382e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093642,CONVERT(0x46696e652052756e6963205072696d6572 USING utf8mb4),58,0,243,0,0,CONVERT(0x5072696d617279205072696d6572207072657061726174696f6e3b206578697374696e6720546f6d652042696e64696e67204b697420726f757465206f6e6c793b205252433037382e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL);
INSERT INTO rrc081_required_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3093638,90312,1,0,0,0,0),
(3093638,93617,0,0,1,1,0),
(3093638,90317,0,0,1,1,0),
(3093638,90322,0,0,1,1,0),
(3093638,41554,0,0,1,1,0),
(3093638,41555,0,0,0,0,1),
(3093639,90313,1,0,0,0,0),
(3093639,93617,0,0,1,1,0),
(3093639,90318,0,0,1,1,0),
(3093639,90323,0,0,1,1,0),
(3093639,41554,0,0,1,1,0),
(3093639,41555,0,0,0,0,1),
(3093640,90314,1,0,0,0,0),
(3093640,93617,0,0,1,1,0),
(3093640,90319,0,0,1,1,0),
(3093640,90324,0,0,1,1,0),
(3093640,41554,0,0,1,1,0),
(3093640,41555,0,0,0,0,1),
(3093641,90315,1,0,0,0,0),
(3093641,93617,0,0,1,1,0),
(3093641,90320,0,0,1,1,0),
(3093641,90325,0,0,1,1,0),
(3093641,41554,0,0,1,1,0),
(3093641,41555,0,0,0,0,1),
(3093642,90316,1,0,0,0,0),
(3093642,93617,0,0,1,1,0),
(3093642,90321,0,0,1,1,0),
(3093642,90326,0,0,1,1,0),
(3093642,41554,0,0,1,1,0),
(3093642,41555,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 IF EXISTS(SELECT 1 FROM rrc081_parents e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 prototype drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc081_parent_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc081_parents p ON p.id=r.recipe_id)<>135 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 prototype entries drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc081_required_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 requires exact completed RRC078'; END IF;
 IF EXISTS(SELECT 1 FROM rrc081_required_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc081_required_recipes q ON q.id=r.recipe_id)<>30 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 RRC078 entry postimage mismatch'; END IF;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc081_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc081_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=41555 AND itemclass=1 AND bagtype=11 AND bagslots=10 AND bagsize=3 AND classes=33089)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 native kit mismatch'; END IF; IF (SELECT COUNT(*) FROM items WHERE (id=115785 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=64) OR (id=93555 AND size=0 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=90314 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=93589 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=93590 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=41526 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=41534 AND size=0 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=115797 AND size=1 AND stackable=0 AND maxcharges=0 AND classes=64) OR (id=93542 AND size=0 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=41544 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=90315 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=41536 AND size=0 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=115800 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=64) OR (id=90312 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=115803 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=64) OR (id=90316 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=93575 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=93578 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=93553 AND size=0 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=115812 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=64) OR (id=93557 AND size=0 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=93576 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=90313 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=115815 AND size=1 AND stackable=0 AND maxcharges=0 AND classes=64) OR (id=93573 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=115821 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=64))<>26 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 input/output semantics mismatch'; END IF; IF (SELECT COUNT(*) FROM items WHERE (id=115785 AND itemtype=20 AND scrolleffect=14785 AND scrolllevel=0 AND reqlevel=0) OR (id=115797 AND itemtype=20 AND scrolleffect=14797 AND scrolllevel=0 AND reqlevel=0) OR (id=115800 AND itemtype=20 AND scrolleffect=14800 AND scrolllevel=0 AND reqlevel=0) OR (id=115803 AND itemtype=20 AND scrolleffect=14803 AND scrolllevel=0 AND reqlevel=0) OR (id=115812 AND itemtype=20 AND scrolleffect=14812 AND scrolllevel=0 AND reqlevel=0) OR (id=115815 AND itemtype=20 AND scrolleffect=14815 AND scrolllevel=0 AND reqlevel=0) OR (id=115821 AND itemtype=20 AND scrolleffect=14821 AND scrolllevel=0 AND reqlevel=0))<>7 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 Tome spell binding mismatch'; END IF;
 IF already_present NOT IN (0,7) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 partial batch or ID collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r JOIN rrc081_recipes e ON r.tradeskill=e.tradeskill AND r.name=e.name WHERE r.id<>e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 existing recipe-name collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc081_entries e ON r.item_id=e.item_id JOIN rrc081_recipes q ON e.recipe_id=q.id WHERE e.successcount>e.componentcount AND e.iscontainer=0 AND r.successcount>r.componentcount AND r.iscontainer=0 AND r.recipe_id<>e.recipe_id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 existing output recipe collision'; END IF;
 IF already_present=0 THEN
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc081_recipes e ON r.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 orphan target entries collision'; END IF;
 INSERT INTO tradeskill_recipe (id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled) SELECT id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled FROM rrc081_recipes;
 INSERT INTO tradeskill_recipe_entries (recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer) SELECT recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer FROM rrc081_entries;
 END IF;
 IF EXISTS(SELECT 1 FROM rrc081_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc081_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc081_recipes q ON q.id=r.recipe_id LEFT JOIN rrc081_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc081_recipes q ON q.id=r.recipe_id)<>51 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 target entry multiplicity mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before+IF(already_present=0,7,0) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before+IF(already_present=0,51,0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 unexpected table row-count delta'; END IF;
 IF EXISTS(SELECT 1 FROM rrc081_parents e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 prototype drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc081_parent_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc081_parents p ON p.id=r.recipe_id)<>135 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 prototype entries drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc081_required_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 requires exact completed RRC078'; END IF;
 IF EXISTS(SELECT 1 FROM rrc081_required_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc081_required_recipes q ON q.id=r.recipe_id)<>30 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC081 RRC078 entry postimage mismatch'; END IF;
 DROP TEMPORARY TABLE rrc081_required_recipes;
 DROP TEMPORARY TABLE rrc081_required_entries;
 DROP TEMPORARY TABLE rrc081_parents;
 DROP TEMPORARY TABLE rrc081_parent_entries;
 DROP TEMPORARY TABLE rrc081_entries;
 DROP TEMPORARY TABLE rrc081_recipes;
 DROP TEMPORARY TABLE rrc081_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC081' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
