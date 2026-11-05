-- RRC106: MariaDB10.11, dedicated fresh admin session; manual coordinated application only.
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
 IF @@in_transaction <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 requires fresh transaction-free session'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 strict SQL mode required'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('tradeskill_recipe','tradeskill_recipe_entries','items') AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 InnoDB foundation mismatch'; END IF;
 IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe')<>16 OR (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tradeskill_recipe_entries')<>8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 recipe schema column-count mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc106_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc106_entries LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc106_items(id INT PRIMARY KEY,name VARCHAR(64) NOT NULL) ENGINE=InnoDB;
INSERT INTO rrc106_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(3094055,CONVERT(0x53696d706c65205265637572766520426f77737472696e67 USING utf8mb4),64,0,51,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920556e646572666f6f7420636174616c6f67756520466c65746368696e67207265636f6e737472756374696f6e3b205252433130362e USING utf8mb4),0,0,0,1,16,-1,NULL,NULL),
(3094056,CONVERT(0x4f726e617465205265637572766520426f77737472696e67 USING utf8mb4),64,0,84,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920556e646572666f6f7420636174616c6f67756520466c65746368696e67207265636f6e737472756374696f6e3b205252433130362e USING utf8mb4),0,0,0,1,16,-1,NULL,NULL),
(3094057,CONVERT(0x496e74726963617465205265637572766520426f77737472696e67 USING utf8mb4),64,0,144,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920556e646572666f6f7420636174616c6f67756520466c65746368696e67207265636f6e737472756374696f6e3b205252433130362e USING utf8mb4),0,0,0,1,16,-1,NULL,NULL),
(3094058,CONVERT(0x456c61626f72617465205265637572766520426f77737472696e67 USING utf8mb4),64,0,184,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920556e646572666f6f7420636174616c6f67756520466c65746368696e67207265636f6e737472756374696f6e3b205252433130362e USING utf8mb4),0,0,0,1,16,-1,NULL,NULL),
(3094059,CONVERT(0x496e75726564205265637572766520426f77737472696e67 USING utf8mb4),64,0,204,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920556e646572666f6f7420636174616c6f67756520466c65746368696e67207265636f6e737472756374696f6e3b205252433130362e USING utf8mb4),0,0,0,1,16,-1,NULL,NULL),
(3094060,CONVERT(0x456c6567616e74205265637572766520426f77737472696e67 USING utf8mb4),64,0,224,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920556e646572666f6f7420636174616c6f67756520466c65746368696e67207265636f6e737472756374696f6e3b205252433130362e USING utf8mb4),0,0,0,1,16,-1,NULL,NULL),
(3094061,CONVERT(0x5374616c77617274205265637572766520426f77737472696e67 USING utf8mb4),64,0,244,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920556e646572666f6f7420636174616c6f67756520466c65746368696e67207265636f6e737472756374696f6e3b205252433130362e USING utf8mb4),0,0,0,1,16,-1,NULL,NULL),
(3094062,CONVERT(0x53696d706c65205265637572766520426f77 USING utf8mb4),64,0,106,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920556e646572666f6f7420636174616c6f67756520466c65746368696e67207265636f6e737472756374696f6e3b205252433130362e USING utf8mb4),1,45867,0,1,16,-1,NULL,NULL),
(3094063,CONVERT(0x4f726e617465205265637572766520426f77 USING utf8mb4),64,0,175,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920556e646572666f6f7420636174616c6f67756520466c65746368696e67207265636f6e737472756374696f6e3b205252433130362e USING utf8mb4),1,45867,0,1,16,-1,NULL,NULL),
(3094064,CONVERT(0x496e74726963617465205265637572766520426f77 USING utf8mb4),64,0,295,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920556e646572666f6f7420636174616c6f67756520466c65746368696e67207265636f6e737472756374696f6e3b205252433130362e USING utf8mb4),1,45867,0,1,16,-1,NULL,NULL),
(3094065,CONVERT(0x456c61626f72617465205265637572766520426f77 USING utf8mb4),64,0,375,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920556e646572666f6f7420636174616c6f67756520466c65746368696e67207265636f6e737472756374696f6e3b205252433130362e USING utf8mb4),1,45867,0,1,16,-1,NULL,NULL),
(3094066,CONVERT(0x496e75726564205265637572766520426f77 USING utf8mb4),64,0,415,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920556e646572666f6f7420636174616c6f67756520466c65746368696e67207265636f6e737472756374696f6e3b205252433130362e USING utf8mb4),1,45867,0,1,16,-1,NULL,NULL),
(3094067,CONVERT(0x456c6567616e74205265637572766520426f77 USING utf8mb4),64,0,468,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920556e646572666f6f7420636174616c6f67756520466c65746368696e67207265636f6e737472756374696f6e3b205252433130362e USING utf8mb4),1,45867,0,1,16,-1,NULL,NULL),
(3094068,CONVERT(0x5374616c77617274205265637572766520426f77 USING utf8mb4),64,0,495,0,0,CONVERT(0x4d61696e7461696e65642d7072696d61727920556e646572666f6f7420636174616c6f67756520466c65746368696e67207265636f6e737472756374696f6e3b205252433130362e USING utf8mb4),1,45867,0,1,16,-1,NULL,NULL);
INSERT INTO rrc106_entries (`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(3094055,45176,1,0,0,0,0),
(3094055,29992,0,0,1,1,0),
(3094055,34214,0,0,2,2,0),
(3094055,17189,0,0,0,0,1),
(3094055,17762,0,0,0,0,1),
(3094055,17910,0,0,0,0,1),
(3094056,45177,1,0,0,0,0),
(3094056,29992,0,0,1,1,0),
(3094056,34216,0,0,2,2,0),
(3094056,17189,0,0,0,0,1),
(3094056,17762,0,0,0,0,1),
(3094056,17910,0,0,0,0,1),
(3094057,45178,1,0,0,0,0),
(3094057,29992,0,0,1,1,0),
(3094057,34219,0,0,2,2,0),
(3094057,17189,0,0,0,0,1),
(3094057,17762,0,0,0,0,1),
(3094057,17910,0,0,0,0,1),
(3094058,45179,1,0,0,0,0),
(3094058,29992,0,0,1,1,0),
(3094058,34221,0,0,2,2,0),
(3094058,17189,0,0,0,0,1),
(3094058,17762,0,0,0,0,1),
(3094058,17910,0,0,0,0,1),
(3094059,45180,1,0,0,0,0),
(3094059,29992,0,0,1,1,0),
(3094059,34222,0,0,2,2,0),
(3094059,17189,0,0,0,0,1),
(3094059,17762,0,0,0,0,1),
(3094059,17910,0,0,0,0,1),
(3094060,45181,1,0,0,0,0),
(3094060,29992,0,0,1,1,0),
(3094060,34223,0,0,2,2,0),
(3094060,17189,0,0,0,0,1),
(3094060,17762,0,0,0,0,1),
(3094060,17910,0,0,0,0,1),
(3094061,45182,1,0,0,0,0),
(3094061,29992,0,0,1,1,0),
(3094061,48892,0,0,2,2,0),
(3094061,17189,0,0,0,0,1),
(3094061,17762,0,0,0,0,1),
(3094061,17910,0,0,0,0,1),
(3094062,47353,1,0,0,0,0),
(3094062,8086,1,1,1,0,0),
(3094062,45175,0,0,1,1,0),
(3094062,45168,0,0,1,1,0),
(3094062,45176,0,0,1,1,0),
(3094062,48196,0,0,1,1,0),
(3094062,34904,0,0,1,1,0),
(3094062,17910,0,0,0,0,1),
(3094063,47354,1,0,0,0,0),
(3094063,45169,0,0,1,1,0),
(3094063,34906,0,0,1,1,0),
(3094063,45177,0,0,1,1,0),
(3094063,48202,0,0,1,1,0),
(3094063,8086,1,1,1,0,0),
(3094063,45175,0,0,1,1,0),
(3094063,17189,0,0,0,0,1),
(3094063,17762,0,0,0,0,1),
(3094063,17910,0,0,0,0,1),
(3094064,47355,1,0,0,0,0),
(3094064,34909,0,0,1,1,0),
(3094064,45178,0,0,1,1,0),
(3094064,48208,0,0,1,1,0),
(3094064,8086,1,1,1,0,0),
(3094064,45175,0,0,1,1,0),
(3094064,45170,0,0,1,1,0),
(3094064,17189,0,0,0,0,1),
(3094064,17762,0,0,0,0,1),
(3094064,17910,0,0,0,0,1),
(3094065,47356,1,0,0,0,0),
(3094065,45179,0,0,1,1,0),
(3094065,48214,0,0,1,1,0),
(3094065,45171,0,0,1,1,0),
(3094065,8086,1,1,1,0,0),
(3094065,45175,0,0,1,1,0),
(3094065,34911,0,0,1,1,0),
(3094065,17189,0,0,0,0,1),
(3094065,17762,0,0,0,0,1),
(3094065,17910,0,0,0,0,1),
(3094066,47357,1,0,0,0,0),
(3094066,34912,0,0,1,1,0),
(3094066,45180,0,0,1,1,0),
(3094066,48220,0,0,1,1,0),
(3094066,8086,1,1,1,0,0),
(3094066,45175,0,0,1,1,0),
(3094066,45172,0,0,1,1,0),
(3094066,17189,0,0,0,0,1),
(3094066,17762,0,0,0,0,1),
(3094066,17910,0,0,0,0,1),
(3094067,47358,1,0,0,0,0),
(3094067,45181,0,0,1,1,0),
(3094067,48226,0,0,1,1,0),
(3094067,45173,0,0,1,1,0),
(3094067,34913,0,0,1,1,0),
(3094067,8086,1,1,1,0,0),
(3094067,45175,0,0,1,1,0),
(3094067,17189,0,0,0,0,1),
(3094067,17762,0,0,0,0,1),
(3094067,17910,0,0,0,0,1),
(3094068,47359,1,0,0,0,0),
(3094068,45174,0,0,1,1,0),
(3094068,48908,0,0,1,1,0),
(3094068,8086,1,1,1,0,0),
(3094068,45175,0,0,1,1,0),
(3094068,45182,0,0,1,1,0),
(3094068,48232,0,0,1,1,0),
(3094068,17189,0,0,0,0,1),
(3094068,17762,0,0,0,0,1),
(3094068,17910,0,0,0,0,1);
INSERT INTO rrc106_items (`id`,`name`) VALUES
(8086,CONVERT(0x506c616e696e6720546f6f6c USING utf8mb4)),
(17189,CONVERT(0x436f6c6c61707369626c6520466c65746368696e67204b6974 USING utf8mb4)),
(17762,CONVERT(0x506c616e617220466c65746368696e67204b6974 USING utf8mb4)),
(17910,CONVERT(0x466c65746368696e67204b6974 USING utf8mb4)),
(29992,CONVERT(0x436c756d70206f6620576178 USING utf8mb4)),
(34214,CONVERT(0x53756c6c6965642053696c6b USING utf8mb4)),
(34216,CONVERT(0x43727564652053696c6b USING utf8mb4)),
(34219,CONVERT(0x46696e652053696c6b USING utf8mb4)),
(34221,CONVERT(0x5375706572622053696c6b USING utf8mb4)),
(34222,CONVERT(0x466c61776c6573732053696c6b USING utf8mb4)),
(34223,CONVERT(0x4578717569736974652053696c6b USING utf8mb4)),
(34904,CONVERT(0x53756c6c696564205370696e6e6572657420466c756964 USING utf8mb4)),
(34906,CONVERT(0x4372756465205370696e6e6572657420466c756964 USING utf8mb4)),
(34909,CONVERT(0x46696e65205370696e6e6572657420466c756964 USING utf8mb4)),
(34911,CONVERT(0x537570657262205370696e6e6572657420466c756964 USING utf8mb4)),
(34912,CONVERT(0x466c61776c657373205370696e6e6572657420466c756964 USING utf8mb4)),
(34913,CONVERT(0x457871756973697465205370696e6e6572657420466c756964 USING utf8mb4)),
(45168,CONVERT(0x526f7567682053616e647061706572 USING utf8mb4)),
(45169,CONVERT(0x436f617273652053616e647061706572 USING utf8mb4)),
(45170,CONVERT(0x53696d706c652053616e647061706572 USING utf8mb4)),
(45171,CONVERT(0x46696e652053616e647061706572 USING utf8mb4)),
(45172,CONVERT(0x5375706572696f722053616e647061706572 USING utf8mb4)),
(45173,CONVERT(0x457863657074696f6e616c2053616e647061706572 USING utf8mb4)),
(45174,CONVERT(0x4578717569736974652053616e647061706572 USING utf8mb4)),
(45175,CONVERT(0x5265637572766520426f77204469616772616d USING utf8mb4)),
(45176,CONVERT(0x53696d706c65205265637572766520426f7720537472696e67 USING utf8mb4)),
(45177,CONVERT(0x4f726e617465205265637572766520426f7720537472696e67 USING utf8mb4)),
(45178,CONVERT(0x496e74726963617465205265637572766520426f7720537472696e67 USING utf8mb4)),
(45179,CONVERT(0x456c61626f72617465205265637572766520426f7720537472696e67 USING utf8mb4)),
(45180,CONVERT(0x496e75726564205265637572766520426f7720537472696e67 USING utf8mb4)),
(45181,CONVERT(0x456c6567616e74205265637572766520426f7720537472696e67 USING utf8mb4)),
(45182,CONVERT(0x5374616c77617274205265637572766520426f7720537472696e67 USING utf8mb4)),
(45867,CONVERT(0x5265637572766520426f77204469616772616d73 USING utf8mb4)),
(47353,CONVERT(0x53696d706c65205265637572766520426f77 USING utf8mb4)),
(47354,CONVERT(0x4f726e617465205265637572766520426f77 USING utf8mb4)),
(47355,CONVERT(0x496e74726963617465205265637572766520426f77 USING utf8mb4)),
(47356,CONVERT(0x456c61626f72617465205265637572766520426f77 USING utf8mb4)),
(47357,CONVERT(0x496e75726564205265637572766520426f77 USING utf8mb4)),
(47358,CONVERT(0x456c6567616e74205265637572766520426f77 USING utf8mb4)),
(47359,CONVERT(0x5374616c77617274205265637572766520426f77 USING utf8mb4)),
(48196,CONVERT(0x53696d706c65205374616666 USING utf8mb4)),
(48202,CONVERT(0x4f726e617465205374616666 USING utf8mb4)),
(48208,CONVERT(0x496e74726963617465205374616666 USING utf8mb4)),
(48214,CONVERT(0x456c61626f72617465205374616666 USING utf8mb4)),
(48220,CONVERT(0x496e75726564205374616666 USING utf8mb4)),
(48226,CONVERT(0x456c6567616e74205374616666 USING utf8mb4)),
(48232,CONVERT(0x5374616c77617274205374616666 USING utf8mb4)),
(48892,CONVERT(0x496d6d6163756c6174652053696c6b USING utf8mb4)),
(48908,CONVERT(0x496d6d6163756c617465205370696e6e6572657420466c756964 USING utf8mb4));
 START TRANSACTION;
 IF (SELECT COUNT(*) FROM books WHERE name=CONVERT(0x5453534b553137576561706f6e426f77 USING utf8mb4) AND SHA2(txtfile,256)=CONVERT(0x39616362383764646165633633373664396465393934323038323036366265313438393766363635366230383737336666363137316665333238616461363535 USING utf8mb4))<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native book context mismatch'; END IF;

 SET own_transaction=TRUE;
 SELECT COUNT(*) INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*) INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*) INTO already_present FROM tradeskill_recipe r JOIN rrc106_recipes e ON r.id=e.id FOR UPDATE;
 IF EXISTS(SELECT 1 FROM rrc106_items e LEFT JOIN items i ON i.id=e.id WHERE i.id IS NULL OR BINARY i.Name<>BINARY e.name) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 item identity/dependency mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=8086 AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 10 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17189 AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17762 AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=17910 AND `size` <=> 1 AND `itemclass` <=> 1 AND `itemtype` <=> 11 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 18 AND `bagslots` <=> 8 AND `bagsize` <=> 3 AND `classes` <=> 65535 AND `races` <=> 131071 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=29992 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34214 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34216 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34219 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34221 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34222 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34223 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34904 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34906 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34909 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34911 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34912 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=34913 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45168 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45169 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45170 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45171 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45172 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45173 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45174 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45175 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45176 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45177 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45178 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45179 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45180 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45181 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45182 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=45867 AND `size` <=> 0 AND `itemclass` <=> 2 AND `itemtype` <=> 60 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 0 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> CONVERT(0x5453534b553137576561706f6e426f77 USING utf8mb4))<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=47353 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=47354 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=47355 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=47356 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=47357 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=47358 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=47359 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 5 AND `stackable` <=> 0 AND `stacksize` <=> 1 AND `maxcharges` <=> -1 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48196 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48202 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48208 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48214 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48220 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48226 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48232 AND `size` <=> 3 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 10 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48892 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 200 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 0 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF (SELECT COUNT(*)FROM items WHERE id=48908 AND `size` <=> 0 AND `itemclass` <=> 0 AND `itemtype` <=> 11 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `booktype` <=> 0 AND `filename` <=> '')<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 native item semantics mismatch'; END IF;
 IF already_present<>14 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 rollback requires exact whole installed batch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc106_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`name` <=> e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND r.`notes` <=> e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND r.`content_flags` <=> e.`content_flags` AND r.`content_flags_disabled` <=> e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 recipe postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc106_entries e LEFT JOIN tradeskill_recipe_entries r ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE r.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 expected entry absent'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries r JOIN rrc106_recipes q ON q.id=r.recipe_id LEFT JOIN rrc106_entries e ON r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer` WHERE e.id IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 foreign/different target entries'; END IF;
 IF (SELECT COUNT(*) FROM tradeskill_recipe_entries r JOIN rrc106_recipes q ON q.id=r.recipe_id)<>110 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 target entry multiplicity mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM char_recipe_list c JOIN rrc106_recipes e ON c.recipe_id=e.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 rollback refused: learned recipe references exist'; END IF;
 DELETE r FROM tradeskill_recipe_entries r JOIN rrc106_recipes e ON r.recipe_id=e.id;
 DELETE r FROM tradeskill_recipe r JOIN rrc106_recipes e ON r.id=e.id;
 IF (SELECT COUNT(*) FROM tradeskill_recipe)<>recipes_before-14 OR (SELECT COUNT(*) FROM tradeskill_recipe_entries)<>entries_before-110 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC106 rollback count mismatch'; END IF;
 DROP TEMPORARY TABLE rrc106_entries;
 DROP TEMPORARY TABLE rrc106_recipes;
 DROP TEMPORARY TABLE rrc106_items;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC106' AS batch,already_present AS previous_recipe_count,recipes_before AS recipes_before,(SELECT COUNT(*) FROM tradeskill_recipe) AS recipes_after,entries_before AS entries_before,(SELECT COUNT(*) FROM tradeskill_recipe_entries) AS entries_after,@@in_transaction AS in_transaction;
END//
DELIMITER ;
