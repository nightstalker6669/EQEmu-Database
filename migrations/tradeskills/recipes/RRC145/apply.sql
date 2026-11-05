-- RRC145: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
-- Source recipe facts/provenance: batch.public.json. No engine/updater/version/rule changes.
-- Anonymous compound block: no permanent helper procedure or migration table.
DELIMITER //
BEGIN NOT ATOMIC
 DECLARE own_transaction BOOLEAN DEFAULT FALSE;
 DECLARE prototype_locked BIGINT DEFAULT 0;
 DECLARE already_present INT DEFAULT 0;
 DECLARE recipes_before BIGINT DEFAULT 0;
 DECLARE entries_before BIGINT DEFAULT 0;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION
 BEGIN
  IF own_transaction THEN ROLLBACK; END IF;
  RESIGNAL;
 END;
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc145_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc145_parents LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc145_parent_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc145_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc145_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc145_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3094890,CONVERT(0x43686172676564204d61676e65746963204761756e746c657473 USING utf8mb4),63,0,268,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204f6f5720536d697468696e67207265636f6e737472756374696f6e3b205252433134352e USING utf8mb4),0,0,0,1,8,-1,NULL,NULL),
(3094891,CONVERT(0x4368617267656420576f726e204d61676e6574696320436f6c6c6172 USING utf8mb4),63,0,262,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204f6f5720536d697468696e67207265636f6e737472756374696f6e3b205252433134352e USING utf8mb4),0,0,0,1,8,-1,NULL,NULL),
(3094892,CONVERT(0x4368617267656420576f726e204d61676e65746963205061756c64726f6e73 USING utf8mb4),63,0,275,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204f6f5720536d697468696e67207265636f6e737472756374696f6e3b205252433134352e USING utf8mb4),0,0,0,1,8,-1,NULL,NULL),
(3094893,CONVERT(0x4d61676e65746963204d6574616c20427269636b USING utf8mb4),63,0,135,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204f6f5720536d697468696e67207265636f6e737472756374696f6e3b205252433134352e USING utf8mb4),0,0,0,1,8,-1,NULL,NULL),
(3094894,CONVERT(0x4d61676e65746963204d6574616c20427269636b USING utf8mb4),63,0,135,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204f6f5720536d697468696e67207265636f6e737472756374696f6e3b205252433134352e USING utf8mb4),0,0,0,1,8,-1,NULL,NULL),
(3094895,CONVERT(0x4d61676e65746963204d6574616c20427269636b USING utf8mb4),63,0,135,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204f6f5720536d697468696e67207265636f6e737472756374696f6e3b205252433134352e USING utf8mb4),0,0,0,1,8,-1,NULL,NULL),
(3094896,CONVERT(0x4d61676e65746963204d6574616c20427269636b USING utf8mb4),63,0,135,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204f6f5720536d697468696e67207265636f6e737472756374696f6e3b205252433134352e USING utf8mb4),0,0,0,1,8,-1,NULL,NULL),
(3094897,CONVERT(0x536f66742042617a7520436f6c6c6172 USING utf8mb4),63,0,262,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204f6f5720536d697468696e67207265636f6e737472756374696f6e3b205252433134352e USING utf8mb4),0,0,0,1,8,-1,NULL,NULL),
(3094898,CONVERT(0x536f66742042617a7520436f6c6c6172 USING utf8mb4),63,0,262,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204f6f5720536d697468696e67207265636f6e737472756374696f6e3b205252433134352e USING utf8mb4),0,0,0,1,8,-1,NULL,NULL),
(3094899,CONVERT(0x536f66742042617a7520436f6c6c6172206f6620466c616d6573 USING utf8mb4),63,0,262,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204f6f5720536d697468696e67207265636f6e737472756374696f6e3b205252433134352e USING utf8mb4),0,0,0,1,8,-1,NULL,NULL),
(3094900,CONVERT(0x536f66742042617a75205061756c64726f6e73 USING utf8mb4),63,0,275,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204f6f5720536d697468696e67207265636f6e737472756374696f6e3b205252433134352e USING utf8mb4),0,0,0,1,8,-1,NULL,NULL),
(3094901,CONVERT(0x536f66742042617a75205061756c64726f6e73206f6620466c616d6573 USING utf8mb4),63,0,275,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204f6f5720536d697468696e67207265636f6e737472756374696f6e3b205252433134352e USING utf8mb4),0,0,0,1,8,-1,NULL,NULL),
(3094902,CONVERT(0x536f66742042617a7520536b697274 USING utf8mb4),63,0,262,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204f6f5720536d697468696e67207265636f6e737472756374696f6e3b205252433134352e USING utf8mb4),0,0,0,1,8,-1,NULL,NULL),
(3094903,CONVERT(0x536f66742042617a7520536b697274206f6620466c616d6573 USING utf8mb4),63,0,262,0,0,CONVERT(0x4d61696e7461696e65642d7072696d617279204f6f5720536d697468696e67207265636f6e737472756374696f6e3b205252433134352e USING utf8mb4),0,0,0,1,8,-1,NULL,NULL);
INSERT INTO rrc145_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3094890,72105,1,0,0,0,0),
(3094890,72029,0,0,2,2,0),
(3094890,72104,0,0,1,1,0),
(3094890,10489,1,1,1,0,0),
(3094890,17,0,0,0,0,1),
(3094891,72103,1,0,0,0,0),
(3094891,72029,0,0,1,1,0),
(3094891,10489,1,1,1,0,0),
(3094891,72102,0,0,1,1,0),
(3094891,17,0,0,0,0,1),
(3094892,72109,1,0,0,0,0),
(3094892,72029,0,0,3,3,0),
(3094892,10489,1,1,1,0,0),
(3094892,72108,0,0,1,1,0),
(3094892,17,0,0,0,0,1),
(3094893,72159,2,0,0,0,0),
(3094893,72134,0,0,1,1,0),
(3094893,10489,1,1,1,0,0),
(3094893,17,0,0,0,0,1),
(3094894,72159,2,0,0,0,0),
(3094894,72106,0,0,1,1,0),
(3094894,10489,1,1,1,0,0),
(3094894,17,0,0,0,0,1),
(3094895,72159,3,0,0,0,0),
(3094895,72110,0,0,1,1,0),
(3094895,10489,1,1,1,0,0),
(3094895,17,0,0,0,0,1),
(3094896,72159,2,0,0,0,0),
(3094896,72104,0,0,1,1,0),
(3094896,10489,1,1,1,0,0),
(3094896,17,0,0,0,0,1),
(3094897,72118,1,0,0,0,0),
(3094897,72057,0,0,1,1,0),
(3094897,22035,0,0,1,1,0),
(3094897,10489,1,1,1,0,0),
(3094897,72192,0,0,1,1,0),
(3094897,17,0,0,0,0,1),
(3094898,72118,1,0,0,0,0),
(3094898,72057,0,0,1,1,0),
(3094898,22035,0,0,1,1,0),
(3094898,72035,0,0,1,1,0),
(3094898,10489,1,1,1,0,0),
(3094898,17,0,0,0,0,1),
(3094899,72119,1,0,0,0,0),
(3094899,72058,0,0,1,1,0),
(3094899,10489,1,1,1,0,0),
(3094899,72118,0,0,1,1,0),
(3094899,17,0,0,0,0,1),
(3094900,72124,1,0,0,0,0),
(3094900,72057,0,0,3,3,0),
(3094900,22037,0,0,1,1,0),
(3094900,10489,1,1,1,0,0),
(3094900,72194,0,0,1,1,0),
(3094900,17,0,0,0,0,1),
(3094901,72125,1,0,0,0,0),
(3094901,72058,0,0,3,3,0),
(3094901,10489,1,1,1,0,0),
(3094901,72124,0,0,1,1,0),
(3094901,17,0,0,0,0,1),
(3094902,72116,1,0,0,0,0),
(3094902,72057,0,0,1,1,0),
(3094902,22039,0,0,1,1,0),
(3094902,10489,1,1,1,0,0),
(3094902,72192,0,0,1,1,0),
(3094902,17,0,0,0,0,1),
(3094903,72117,1,0,0,0,0),
(3094903,72058,0,0,1,1,0),
(3094903,10489,1,1,1,0,0),
(3094903,72116,0,1,1,0,0),
(3094903,17,0,0,0,0,1);
INSERT INTO rrc145_items (`id`,`name`) VALUES
(10489,CONVERT(0x536d697468792048616d6d6572 USING utf8mb4)),
(22035,CONVERT(0x436861696e6d61696c204e65636b6775617264205061747465726e USING utf8mb4)),
(22037,CONVERT(0x436861696e6d61696c204d616e746c65205061747465726e USING utf8mb4)),
(22039,CONVERT(0x436861696e6d61696c20536b697274205061747465726e USING utf8mb4)),
(72029,CONVERT(0x4c696768746e696e6720436f7265 USING utf8mb4)),
(72035,CONVERT(0x5275696e65642042617a7520536b696e USING utf8mb4)),
(72057,CONVERT(0x42617a7520426c6f6f64 USING utf8mb4)),
(72058,CONVERT(0x507972696c656e20466c616d65 USING utf8mb4)),
(72102,CONVERT(0x576f726e204d61676e6574696320436f6c6c6172 USING utf8mb4)),
(72103,CONVERT(0x4368617267656420576f726e204d61676e6574696320436f6c6c6172 USING utf8mb4)),
(72104,CONVERT(0x4d61676e65746963204761756e746c657473 USING utf8mb4)),
(72105,CONVERT(0x43686172676564204d61676e65746963204761756e746c657473 USING utf8mb4)),
(72106,CONVERT(0x4d61676e6574696320426f6f7473 USING utf8mb4)),
(72108,CONVERT(0x576f726e204d61676e65746963205061756c64726f6e73 USING utf8mb4)),
(72109,CONVERT(0x4368617267656420576f726e204d61676e65746963205061756c64726f6e73 USING utf8mb4)),
(72110,CONVERT(0x4d61676e657469632048656c6d USING utf8mb4)),
(72116,CONVERT(0x536f66742042617a7520536b697274 USING utf8mb4)),
(72117,CONVERT(0x536f66742042617a7520536b697274206f6620466c616d6573 USING utf8mb4)),
(72118,CONVERT(0x536f66742042617a7520436f6c6c6172 USING utf8mb4)),
(72119,CONVERT(0x536f66742042617a7520436f6c6c6172206f6620466c616d6573 USING utf8mb4)),
(72124,CONVERT(0x536f66742042617a75205061756c64726f6e73 USING utf8mb4)),
(72125,CONVERT(0x536f66742042617a75205061756c64726f6e73206f6620466c616d6573 USING utf8mb4)),
(72134,CONVERT(0x4d61676e657469632056616d627261636573 USING utf8mb4)),
(72159,CONVERT(0x4d61676e65746963204d6574616c20427269636b USING utf8mb4)),
(72192,CONVERT(0x54616e6e6564205275696e65642042617a7520536b696e USING utf8mb4)),
(72194,CONVERT(0x54616e6e65642042617a7520536b696e USING utf8mb4));
INSERT INTO rrc145_parents (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(5434,CONVERT(0x4d61676e65746963204d6574616c20427269636b USING utf8mb4),63,0,135,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5435,CONVERT(0x4d61676e65746963204d6574616c20427269636b USING utf8mb4),63,0,135,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5436,CONVERT(0x4d61676e65746963204d6574616c20427269636b USING utf8mb4),63,0,135,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5437,CONVERT(0x4d61676e65746963204d6574616c20427269636b USING utf8mb4),63,0,135,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5438,CONVERT(0x4d61676e65746963204d6574616c20427269636b USING utf8mb4),63,0,135,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5439,CONVERT(0x4d61676e65746963204d6574616c20427269636b USING utf8mb4),63,0,135,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5440,CONVERT(0x4d61676e65746963204d6574616c20427269636b USING utf8mb4),63,0,135,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5441,CONVERT(0x4d61676e65746963204d6574616c20427269636b USING utf8mb4),63,0,135,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5442,CONVERT(0x4d61676e65746963204d6574616c20427269636b USING utf8mb4),63,0,135,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5443,CONVERT(0x4d61676e65746963204d6574616c20427269636b USING utf8mb4),63,0,135,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5444,CONVERT(0x4d61676e65746963204d6574616c20427269636b USING utf8mb4),63,0,135,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5445,CONVERT(0x4d61676e65746963204d6574616c20427269636b USING utf8mb4),63,0,135,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5446,CONVERT(0x4d61676e65746963204d6574616c20427269636b USING utf8mb4),63,0,135,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5447,CONVERT(0x4d61676e65746963204d6574616c20427269636b USING utf8mb4),63,0,135,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(5448,CONVERT(0x4d61676e65746963204d6574616c20427269636b USING utf8mb4),63,0,135,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(6386,CONVERT(0x536f66742042617a75205061756c64726f6e73 USING utf8mb4),63,0,275,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(6387,CONVERT(0x536f66742042617a7520536b697274 USING utf8mb4),63,0,262,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL);
INSERT INTO rrc145_parent_entries (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(52670,5434,10489,1,1,1,0,0),
(52671,5434,72062,0,0,1,1,0),
(52673,5434,72159,1,0,0,0,0),
(52675,5434,17,0,0,0,0,1),
(52676,5435,10489,1,1,1,0,0),
(52677,5435,72061,0,0,1,1,0),
(52679,5435,72159,1,0,0,0,0),
(52681,5435,17,0,0,0,0,1),
(52682,5436,10489,1,1,1,0,0),
(52683,5436,72063,0,0,1,1,0),
(52685,5436,72159,1,0,0,0,0),
(52687,5436,17,0,0,0,0,1),
(52688,5437,10489,1,1,1,0,0),
(52689,5437,72132,0,0,1,1,0),
(52691,5437,72159,1,0,0,0,0),
(52693,5437,17,0,0,0,0,1),
(52694,5438,10489,1,1,1,0,0),
(52695,5438,72100,0,0,1,1,0),
(52697,5438,72159,1,0,0,0,0),
(52699,5438,17,0,0,0,0,1),
(52700,5439,10489,1,1,1,0,0),
(52701,5439,72102,0,0,1,1,0),
(52703,5439,72159,1,0,0,0,0),
(52705,5439,17,0,0,0,0,1),
(52706,5440,10489,1,1,1,0,0),
(52707,5440,72010,0,0,1,1,0),
(52708,5440,72159,2,0,0,0,0),
(52711,5440,17,0,0,0,0,1),
(52712,5441,10489,1,1,1,0,0),
(52713,5441,72064,0,0,1,1,0),
(52714,5441,72159,2,0,0,0,0),
(52717,5441,17,0,0,0,0,1),
(52718,5442,10489,1,1,1,0,0),
(52719,5442,72011,0,0,1,1,0),
(52720,5442,72159,2,0,0,0,0),
(52723,5442,17,0,0,0,0,1),
(52724,5443,10489,1,1,1,0,0),
(52725,5443,72108,0,0,1,1,0),
(52726,5443,72159,3,0,0,0,0),
(52729,5443,17,0,0,0,0,1),
(52730,5444,10489,1,1,1,0,0),
(52731,5444,72009,0,0,1,1,0),
(52732,5444,72159,3,0,0,0,0),
(52735,5444,17,0,0,0,0,1),
(52736,5445,10489,1,1,1,0,0),
(52737,5445,72012,0,0,1,1,0),
(52738,5445,72159,3,0,0,0,0),
(52741,5445,17,0,0,0,0,1),
(52742,5446,10489,1,1,1,0,0),
(52743,5446,72014,0,0,1,1,0),
(52744,5446,72159,4,0,0,0,0),
(52747,5446,17,0,0,0,0,1),
(52748,5447,10489,1,1,1,0,0),
(52749,5447,72013,0,0,1,1,0),
(52750,5447,72159,4,0,0,0,0),
(52752,5447,72030,1,0,0,0,0),
(52754,5447,17,0,0,0,0,1),
(52755,5448,10489,1,1,1,0,0),
(52756,5448,72112,0,0,1,1,0),
(52757,5448,72159,4,0,0,0,0),
(52759,5448,72030,1,0,0,0,0),
(52761,5448,17,0,0,0,0,1),
(61426,6386,72057,0,0,3,3,0),
(61427,6386,10489,1,1,1,0,0),
(61428,6386,22037,0,0,1,1,0),
(61429,6386,72055,0,0,1,1,0),
(61431,6386,72124,1,0,0,0,0),
(61433,6386,17,0,0,0,0,1),
(61434,6387,10489,1,1,1,0,0),
(61435,6387,22039,0,0,1,1,0),
(61436,6387,72035,0,0,1,1,0),
(61437,6387,72057,0,0,1,1,0),
(61439,6387,72116,1,0,0,0,0),
(61441,6387,17,0,0,0,0,1);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*)INTO prototype_locked FROM tradeskill_recipe r JOIN rrc145_parents p ON p.id=r.id FOR UPDATE;
 IF prototype_locked<>17 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 prototype definitions missing'; END IF;
 SELECT COUNT(*)INTO prototype_locked FROM tradeskill_recipe_entries e JOIN rrc145_parents p ON p.id=e.recipe_id FOR UPDATE;
 IF prototype_locked<>74 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 prototype entries missing'; END IF;
 IF EXISTS(SELECT 1 FROM rrc145_parents e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 existing Smithing recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc145_parent_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc145_parents p ON p.id=r.recipe_id)<>74 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 existing Smithing entries drift'; END IF;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc145_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc145_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=10489 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=22035 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=22037 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=22039 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=72029 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=72035 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=72057 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=72058 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=72102 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 33089 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 32 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 50 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=72103 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 33089 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 32 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 55 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=72104 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 151 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 4096 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 58 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=72105 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 151 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 4096 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 62 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=72106 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 151 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 524288 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 58 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=72108 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 33089 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 64 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 58 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=72109 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 33089 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 64 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 62 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=72110 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 151 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 4 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 62 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=72116 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 16540 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 1048576 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 50 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=72117 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 16540 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 1048576 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 55 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=72118 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 16540 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 32 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 50 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=72119 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 16540 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 32 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 55 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=72124 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 16540 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 64 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 58 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=72125 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 16540 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 64 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 62 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=72134 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 151 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 128 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 58 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=72159 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=72192 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*) FROM items WHERE id=72194 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `purity` <=> 0 AND `augtype` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0 AND `filename` <=> '' AND `booktype` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 native item semantics mismatch'; END IF;
 IF already_present NOT IN (0,14) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 partial batch or ID collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe r JOIN rrc145_recipes e ON r.tradeskill=e.tradeskill AND r.name=e.name WHERE r.id<>e.id AND NOT EXISTS(SELECT 1 FROM rrc145_parents p WHERE p.id=r.id) AND NOT EXISTS(SELECT 1 FROM rrc145_recipes own WHERE own.id=r.id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 existing recipe-name collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc145_entries e ON r.item_id=e.item_id JOIN rrc145_recipes q ON e.recipe_id=q.id WHERE e.successcount>e.componentcount AND e.iscontainer=0 AND r.successcount>0 AND r.iscontainer=0 AND r.recipe_id<>e.recipe_id AND r.recipe_id NOT IN (5434,5435,5436,5437,5438,5439,5440,5441,5442,5443,5444,5445,5446,5447,5448,6386,6387) AND r.recipe_id NOT BETWEEN 3094890 AND 3094903) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 existing output recipe collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72104 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094890 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=4 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72029)=2 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72104)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72102 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094891 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=3 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72029)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72102)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72108 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094892 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=5 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72029)=3 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72108)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72134 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094893 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=2 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72134)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72106 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094894 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=2 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72106)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72110 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094895 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=2 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72110)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72104 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094896 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=2 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72104)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72192 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094897 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=4 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72057)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=22035)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72192)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72057 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094898 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=4 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72057)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=22035)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72035)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72118 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094899 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=3 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72058)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72118)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72194 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094900 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=6 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72057)=3 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=22037)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72194)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72124 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094901 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=5 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72058)=3 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72124)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72192 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094902 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=4 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72057)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=22039)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72192)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72116 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094903 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=3 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72058)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72116)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 IF already_present=0 THEN
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc145_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 new ID range already has learned references'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc145_recipes e ON r.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 orphan target entries collision'; END IF;
 INSERT INTO tradeskill_recipe (id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled) SELECT id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,must_learn,learned_by_item_id,quest,enabled,min_expansion,max_expansion,content_flags,content_flags_disabled FROM rrc145_recipes;
 INSERT INTO tradeskill_recipe_entries (recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer) SELECT recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer FROM rrc145_entries;
 END IF;
 IF EXISTS(SELECT 1 FROM rrc145_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc145_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc145_recipes q ON q.id=r.recipe_id LEFT JOIN rrc145_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc145_recipes q ON q.id=r.recipe_id)<>70 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 target entry multiplicity mismatch'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before+IF(already_present=0,14,0) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before+IF(already_present=0,70,0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 unexpected table row-count delta'; END IF;
 IF EXISTS(SELECT 1 FROM rrc145_parents e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 existing Smithing recipe drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc145_parent_entries e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc145_parents p ON p.id=r.recipe_id)<>74 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 existing Smithing entries drift'; END IF;
 DROP TEMPORARY TABLE rrc145_parents;
 DROP TEMPORARY TABLE rrc145_parent_entries;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72104 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094890 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=4 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72029)=2 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72104)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72102 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094891 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=3 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72029)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72102)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72108 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094892 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=5 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72029)=3 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72108)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72134 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094893 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=2 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72134)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72106 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094894 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=2 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72106)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72110 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094895 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=2 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72110)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72104 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094896 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=2 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72104)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72192 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094897 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=4 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72057)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=22035)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72192)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72057 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094898 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=4 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72057)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=22035)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72035)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72118 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094899 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=3 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72058)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72118)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72194 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094900 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=6 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72057)=3 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=22037)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72194)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72124 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094901 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=5 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72058)=3 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72124)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72192 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094902 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=4 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72057)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=22039)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72192)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72116 AND a.componentcount>0 AND a.iscontainer=0 AND r.id<>3094903 AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=3 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72058)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=10489)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72116)=1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC145 all-state full input collision'; END IF;
 DROP TEMPORARY TABLE rrc145_entries;
 DROP TEMPORARY TABLE rrc145_recipes;
 DROP TEMPORARY TABLE rrc145_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC145' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
