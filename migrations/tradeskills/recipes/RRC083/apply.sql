-- RRC083: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC083 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC083 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC083 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC083 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc083_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc083_parents LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc083_parent_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc083_required_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc083_required_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc083_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc083_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc083_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3093668,CONVERT(0x546f6d65206f662041726d6f72206f66204465636f72756d20526b2e204949 USING utf8mb4),58,0,440,0,0,CONVERT(0x5072696d617279205072696d657220746f6d6520666f726d756c613b206578697374696e6720546f6d652042696e64696e67204b697420726f7574653b205252433038332e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093669,CONVERT(0x546f6d65206f66204a6f6c74696e6720536e61706b69636b7320526b2e204949 USING utf8mb4),58,0,436,0,0,CONVERT(0x5072696d617279205072696d657220746f6d6520666f726d756c613b206578697374696e6720546f6d652042696e64696e67204b697420726f7574653b205252433038332e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093670,CONVERT(0x546f6d65206f662041696d73686f74204469736369706c696e6520526b2e204949 USING utf8mb4),58,0,450,0,0,CONVERT(0x5072696d617279205072696d657220746f6d6520666f726d756c613b206578697374696e6720546f6d652042696e64696e67204b697420726f7574653b205252433038332e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093671,CONVERT(0x546f6d65206f66204c617374204761737020526b2e204949 USING utf8mb4),58,0,450,0,0,CONVERT(0x5072696d617279205072696d657220746f6d6520666f726d756c613b206578697374696e6720546f6d652042696e64696e67204b697420726f7574653b205252433038332e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093672,CONVERT(0x546f6d65206f6620556d6272616c20436172617061636520526b2e204949 USING utf8mb4),58,0,440,0,0,CONVERT(0x5072696d617279205072696d657220746f6d6520666f726d756c613b206578697374696e6720546f6d652042696e64696e67204b697420726f7574653b205252433038332e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL);
INSERT INTO rrc083_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3093668,115988,1,0,0,0,0),
(3093668,90314,0,0,1,1,0),
(3093668,93542,0,0,1,1,0),
(3093668,93579,0,0,1,1,0),
(3093668,93553,0,0,1,1,0),
(3093668,93524,0,0,1,1,0),
(3093668,41555,0,0,0,0,1),
(3093669,116021,1,0,0,0,0),
(3093669,93542,0,0,1,1,0),
(3093669,41544,0,0,2,2,0),
(3093669,90313,0,0,1,1,0),
(3093669,93522,0,0,1,1,0),
(3093669,41536,0,0,1,1,0),
(3093669,41555,0,0,0,0,1),
(3093670,116092,1,0,0,0,0),
(3093670,90316,0,0,1,1,0),
(3093670,93542,0,0,1,1,0),
(3093670,41539,0,0,1,1,0),
(3093670,41537,0,0,1,1,0),
(3093670,93553,0,0,1,1,0),
(3093670,93522,0,0,1,1,0),
(3093670,41555,0,0,0,0,1),
(3093671,116191,1,0,0,0,0),
(3093671,90316,0,0,1,1,0),
(3093671,93542,0,0,1,1,0),
(3093671,41541,0,0,1,1,0),
(3093671,93587,0,0,1,1,0),
(3093671,93573,0,0,1,1,0),
(3093671,93578,0,0,2,2,0),
(3093671,93553,0,0,1,1,0),
(3093671,93523,0,0,1,1,0),
(3093671,41555,0,0,0,0,1),
(3093672,116212,1,0,0,0,0),
(3093672,90314,0,0,1,1,0),
(3093672,93542,0,0,1,1,0),
(3093672,93579,0,0,1,1,0),
(3093672,93553,0,0,1,1,0),
(3093672,93523,0,0,1,1,0),
(3093672,41555,0,0,0,0,1);
INSERT INTO rrc083_items (`id`,`name`) VALUES
(41536,CONVERT(0x537472696b696e6720546869636b656e6572 USING utf8mb4)),
(41537,CONVERT(0x496e6b206f6620537472696b696e67 USING utf8mb4)),
(41539,CONVERT(0x496e6b206f6620496e666c696374696f6e USING utf8mb4)),
(41541,CONVERT(0x496e6b206f66204d796f70736973 USING utf8mb4)),
(41544,CONVERT(0x496e6b206f662046696e65737365 USING utf8mb4)),
(41555,CONVERT(0x546f6d652042696e64696e67204b6974 USING utf8mb4)),
(90313,CONVERT(0x5072696d6572 USING utf8mb4)),
(90314,CONVERT(0x46696e65205072696d6572 USING utf8mb4)),
(90316,CONVERT(0x46696e652052756e6963205072696d6572 USING utf8mb4)),
(93522,CONVERT(0x5175696c6c206f662074686520466f72657374205374616c6b6572 USING utf8mb4)),
(93523,CONVERT(0x5175696c6c206f6620746865204472656164204c6f7264 USING utf8mb4)),
(93524,CONVERT(0x5175696c6c206f6620746865204c6f72642050726f746563746f72 USING utf8mb4)),
(93542,CONVERT(0x496e6b204164646974697665206f6620746865204e616d656c657373 USING utf8mb4)),
(93553,CONVERT(0x496e7669676f726174696e6720546869636b656e6572 USING utf8mb4)),
(93573,CONVERT(0x496e6b206f662054756e617265 USING utf8mb4)),
(93578,CONVERT(0x496e6b206f66205a656b USING utf8mb4)),
(93579,CONVERT(0x496e6b206f66207468652054726962756e616c USING utf8mb4)),
(93587,CONVERT(0x496e6b206f66205061696e USING utf8mb4)),
(115988,CONVERT(0x546f6d65206f662041726d6f72206f66204465636f72756d20526b2e204949 USING utf8mb4)),
(116021,CONVERT(0x546f6d65206f66204a6f6c74696e6720536e61706b69636b7320526b2e204949 USING utf8mb4)),
(116092,CONVERT(0x546f6d65206f662041696d73686f74204469736369706c696e6520526b2e204949 USING utf8mb4)),
(116191,CONVERT(0x546f6d65206f66204c617374204761737020526b2e204949 USING utf8mb4)),
(116212,CONVERT(0x546f6d65206f6620556d6272616c20436172617061636520526b2e204949 USING utf8mb4));
INSERT INTO rrc083_parents (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(12354,CONVERT(0x546f6d65204f66204775617264204f662048756d696c697479 USING utf8mb4),58,0,298,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12356,CONVERT(0x546f6d65204f6620536f756c204775617264 USING utf8mb4),58,0,298,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12380,CONVERT(0x546f6d65204f66204775617264204f66205269676874656f75736e657373 USING utf8mb4),58,0,351,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12381,CONVERT(0x546f6d65204f6620536f756c20536869656c64 USING utf8mb4),58,0,351,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12428,CONVERT(0x546f6d65204f66204a6f6c74696e67204b69636b7320526b2e204969 USING utf8mb4),58,0,363,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12437,CONVERT(0x546f6d65204f662041726d6f72204f66205269676874656f75736e65737320526b2e204969 USING utf8mb4),58,0,366,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12439,CONVERT(0x546f6d65204f6620536f756c20436172617061636520526b2e204969 USING utf8mb4),58,0,366,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12352,CONVERT(0x546f6d65204f66204775617264204f66205069657479 USING utf8mb4),58,0,258,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12353,CONVERT(0x546f6d65204f66204963686f72204775617264 USING utf8mb4),58,0,258,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12386,CONVERT(0x536b696c6c3a205761726465722773205772617468 USING utf8mb4),58,0,352,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL),
(12388,CONVERT(0x536b696c6c3a2044616e6365204f6620412054686f7573616e6420426c61646573 USING utf8mb4),58,0,354,0,0,NULL,2,0,0,1,-1,-1,NULL,NULL);
INSERT INTO rrc083_parent_entries (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(146512,12354,93542,0,0,1,1,0),
(146513,12354,93579,0,0,1,1,0),
(146514,12354,93553,0,0,1,1,0),
(146515,12354,41616,0,0,1,1,0),
(146516,12354,93524,0,0,1,1,0),
(146518,12354,41555,0,0,0,0,1),
(146519,12354,41632,0,0,0,0,1),
(146520,12354,41633,0,0,0,0,1),
(146528,12356,93542,0,0,1,1,0),
(146529,12356,93579,0,0,1,1,0),
(146530,12356,93553,0,0,1,1,0),
(146531,12356,41616,0,0,1,1,0),
(146532,12356,93523,0,0,1,1,0),
(146534,12356,41555,0,0,0,0,1),
(146535,12356,41632,0,0,0,0,1),
(146536,12356,41633,0,0,0,0,1),
(146713,12380,93542,0,0,1,1,0),
(146714,12380,93579,0,0,1,1,0),
(146715,12380,93553,0,0,1,1,0),
(146716,12380,93524,0,0,1,1,0),
(146717,12380,41624,0,0,1,1,0),
(146718,12380,76021,1,0,0,0,0),
(146719,12380,41555,0,0,0,0,1),
(146720,12380,41632,0,0,0,0,1),
(146721,12380,41633,0,0,0,0,1),
(146722,12381,93542,0,0,1,1,0),
(146723,12381,93579,0,0,1,1,0),
(146724,12381,93553,0,0,1,1,0),
(146725,12381,93523,0,0,1,1,0),
(146726,12381,41624,0,0,1,1,0),
(146727,12381,76031,1,0,0,0,0),
(146728,12381,41555,0,0,0,0,1),
(146729,12381,41632,0,0,0,0,1),
(146730,12381,41633,0,0,0,0,1),
(147112,12428,41627,0,0,1,1,0),
(147113,12428,93542,0,0,1,1,0),
(147114,12428,41544,0,0,2,2,0),
(147115,12428,93522,0,0,1,1,0),
(147116,12428,41536,0,0,1,1,0),
(147117,12428,78424,1,0,0,0,0),
(147118,12428,41555,0,0,0,0,1),
(147187,12437,41628,0,0,1,1,0),
(147188,12437,93542,0,0,1,1,0),
(147189,12437,93579,0,0,1,1,0),
(147190,12437,93553,0,0,1,1,0),
(147191,12437,93524,0,0,1,1,0),
(147192,12437,79400,1,0,0,0,0),
(147193,12437,41555,0,0,0,0,1),
(147203,12439,41628,0,0,1,1,0),
(147204,12439,93542,0,0,1,1,0),
(147205,12439,93579,0,0,1,1,0),
(147206,12439,93553,0,0,1,1,0),
(147207,12439,93523,0,0,1,1,0),
(147208,12439,79409,1,0,0,0,0),
(147209,12439,41555,0,0,0,0,1),
(152267,12354,76037,1,0,0,0,0),
(152269,12356,76047,1,0,0,0,0),
(146494,12352,93542,0,0,1,1,0),
(146495,12352,93579,0,0,1,1,0),
(146496,12352,93553,0,0,1,1,0),
(146497,12352,93524,0,0,1,1,0),
(146498,12352,41611,0,0,1,1,0),
(146499,12352,77885,1,0,0,0,0),
(146500,12352,41555,0,0,0,0,1),
(146501,12352,41632,0,0,0,0,1),
(146502,12352,41633,0,0,0,0,1),
(146503,12353,93542,0,0,1,1,0),
(146504,12353,93579,0,0,1,1,0),
(146505,12353,93553,0,0,1,1,0),
(146506,12353,93523,0,0,1,1,0),
(146507,12353,41611,0,0,1,1,0),
(146508,12353,77886,1,0,0,0,0),
(146509,12353,41555,0,0,0,0,1),
(146510,12353,41632,0,0,0,0,1),
(146511,12353,41633,0,0,0,0,1),
(146763,12386,93542,0,0,1,1,0),
(146764,12386,41538,0,0,1,1,0),
(146765,12386,41537,0,0,1,1,0),
(146766,12386,93553,0,0,1,1,0),
(146767,12386,93522,0,0,1,1,0),
(146768,12386,41624,0,0,1,1,0),
(146769,12386,77906,1,0,0,0,0),
(146770,12386,41555,0,0,0,0,1),
(146771,12386,41632,0,0,0,0,1),
(146772,12386,41633,0,0,0,0,1),
(146780,12388,93542,0,0,1,1,0),
(146781,12388,41549,0,0,1,1,0),
(146782,12388,41538,0,0,1,1,0),
(146783,12388,41537,0,0,1,1,0),
(146784,12388,93553,0,0,1,1,0),
(146785,12388,93525,0,0,1,1,0),
(146786,12388,41624,0,0,1,1,0),
(146787,12388,77913,1,0,0,0,0),
(146788,12388,41555,0,0,0,0,1),
(146789,12388,41633,0,0,0,0,1);
INSERT INTO rrc083_required_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3093638,CONVERT(0x526f756768205072696d6572 USING utf8mb4),58,0,243,0,0,CONVERT(0x5072696d617279205072696d6572207072657061726174696f6e3b206578697374696e6720546f6d652042696e64696e67204b697420726f757465206f6e6c793b205252433037382e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093639,CONVERT(0x5072696d6572 USING utf8mb4),58,0,243,0,0,CONVERT(0x5072696d617279205072696d6572207072657061726174696f6e3b206578697374696e6720546f6d652042696e64696e67204b697420726f757465206f6e6c793b205252433037382e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093640,CONVERT(0x46696e65205072696d6572 USING utf8mb4),58,0,243,0,0,CONVERT(0x5072696d617279205072696d6572207072657061726174696f6e3b206578697374696e6720546f6d652042696e64696e67204b697420726f757465206f6e6c793b205252433037382e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093641,CONVERT(0x52756e6963205072696d6572 USING utf8mb4),58,0,243,0,0,CONVERT(0x5072696d617279205072696d6572207072657061726174696f6e3b206578697374696e6720546f6d652042696e64696e67204b697420726f757465206f6e6c793b205252433037382e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL),
(3093642,CONVERT(0x46696e652052756e6963205072696d6572 USING utf8mb4),58,0,243,0,0,CONVERT(0x5072696d617279205072696d6572207072657061726174696f6e3b206578697374696e6720546f6d652042696e64696e67204b697420726f757465206f6e6c793b205252433037382e USING utf8mb4),2,0,0,1,17,-1,NULL,NULL);
INSERT INTO rrc083_required_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
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
 IF EXISTS(SELECT 1 FROM rrc083_parents e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC083 prototype drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc083_parent_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc083_parents p ON p.id=r.recipe_id)<>95 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC083 prototype entries drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc083_required_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC083 requires exact completed RRC078'; END IF;
 IF EXISTS(SELECT 1 FROM rrc083_required_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc083_required_recipes q ON q.id=r.recipe_id)<>30 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC083 RRC078 entry postimage mismatch'; END IF;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc083_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc083_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC083 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=41555 AND itemclass=1 AND bagtype=11 AND bagslots=10 AND bagsize=3 AND classes=33089)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC083 native kit mismatch'; END IF; IF (SELECT COUNT(*) FROM items WHERE (id=115988 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=4) OR (id=90314 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=93542 AND size=0 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=93579 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=93553 AND size=0 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=93524 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=116021 AND size=1 AND stackable=0 AND maxcharges=0 AND classes=8) OR (id=41544 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=90313 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=93522 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=41536 AND size=0 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=116092 AND size=1 AND stackable=0 AND maxcharges=0 AND classes=8) OR (id=90316 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=41539 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=41537 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=116191 AND size=1 AND stackable=0 AND maxcharges=0 AND classes=16) OR (id=41541 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=33089) OR (id=93587 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=93573 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=93578 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=93523 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=15360) OR (id=116212 AND size=1 AND stackable=1 AND maxcharges=0 AND classes=16))<>22 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC083 input/output semantics mismatch'; END IF; IF (SELECT COUNT(*) FROM items WHERE (id=115988 AND itemtype=20 AND scrolleffect=14988 AND scrolllevel=0 AND reqlevel=0) OR (id=116021 AND itemtype=20 AND scrolleffect=15021 AND scrolllevel=0 AND reqlevel=0) OR (id=116092 AND itemtype=20 AND scrolleffect=15092 AND scrolllevel=0 AND reqlevel=0) OR (id=116191 AND itemtype=20 AND scrolleffect=15191 AND scrolllevel=0 AND reqlevel=0) OR (id=116212 AND itemtype=20 AND scrolleffect=15212 AND scrolllevel=0 AND reqlevel=0))<>5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC083 Tome spell binding mismatch'; END IF;
 IF already_present NOT IN (0,5) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC083 partial batch or ID collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r JOIN rrc083_recipes e ON r.tradeskill=e.tradeskill AND r.name=e.name WHERE r.id<>e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC083 existing recipe-name collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc083_entries e ON r.item_id=e.item_id JOIN rrc083_recipes q ON e.recipe_id=q.id WHERE e.successcount>e.componentcount AND e.iscontainer=0 AND r.successcount>r.componentcount AND r.iscontainer=0 AND r.recipe_id<>e.recipe_id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC083 existing output recipe collision'; END IF;
 IF already_present=0 THEN
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc083_recipes e ON r.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC083 orphan target entries collision'; END IF;
 INSERT INTO tradeskill_recipe (id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled) SELECT id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled FROM rrc083_recipes;
 INSERT INTO tradeskill_recipe_entries (recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer) SELECT recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer FROM rrc083_entries;
 END IF;
 IF EXISTS(SELECT 1 FROM rrc083_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC083 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc083_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC083 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc083_recipes q ON q.id=r.recipe_id LEFT JOIN rrc083_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC083 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc083_recipes q ON q.id=r.recipe_id)<>39 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC083 target entry multiplicity mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before+IF(already_present=0,5,0) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before+IF(already_present=0,39,0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC083 unexpected table row-count delta'; END IF;
 IF EXISTS(SELECT 1 FROM rrc083_parents e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC083 prototype drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc083_parent_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc083_parents p ON p.id=r.recipe_id)<>95 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC083 prototype entries drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc083_required_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC083 requires exact completed RRC078'; END IF;
 IF EXISTS(SELECT 1 FROM rrc083_required_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc083_required_recipes q ON q.id=r.recipe_id)<>30 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC083 RRC078 entry postimage mismatch'; END IF;
 DROP TEMPORARY TABLE rrc083_required_recipes;
 DROP TEMPORARY TABLE rrc083_required_entries;
 DROP TEMPORARY TABLE rrc083_parents;
 DROP TEMPORARY TABLE rrc083_parent_entries;
 DROP TEMPORARY TABLE rrc083_entries;
 DROP TEMPORARY TABLE rrc083_recipes;
 DROP TEMPORARY TABLE rrc083_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC083' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
