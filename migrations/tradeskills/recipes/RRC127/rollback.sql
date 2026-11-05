-- RRC127: three existing enabled output IDs only. Fresh dedicated strict MariaDB session.
DELIMITER //
BEGIN NOT ATOMIC
 DECLARE own_transaction BOOLEAN DEFAULT FALSE;
 DECLARE recipes_before BIGINT DEFAULT 0;
 DECLARE entries_before BIGINT DEFAULT 0;
 DECLARE locked_rows BIGINT DEFAULT 0;
 DECLARE changed_rows BIGINT DEFAULT 0;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
  IF own_transaction THEN ROLLBACK; END IF;
  RESIGNAL;
 END;
 IF @@in_transaction<>0 OR DATABASE()<>'peq_housing_test' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC127 target/transaction mismatch'; END IF;
 IF FIND_IN_SET('STRICT_ALL_TABLES',@@SESSION.sql_mode)=0 AND FIND_IN_SET('STRICT_TRANS_TABLES',@@SESSION.sql_mode)=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC127 strict mode required'; END IF;
 IF(SELECT COUNT(*)FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE()AND TABLE_NAME IN('tradeskill_recipe','tradeskill_recipe_entries','items')AND ENGINE='InnoDB')<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC127 InnoDB mismatch'; END IF;
 CREATE TEMPORARY TABLE rrc127_recipes LIKE tradeskill_recipe;
 CREATE TEMPORARY TABLE rrc127_before LIKE tradeskill_recipe_entries;
 CREATE TEMPORARY TABLE rrc127_after LIKE tradeskill_recipe_entries;
 INSERT INTO rrc127_recipes (`id`,`name`,`tradeskill`,`skillneeded`,`trivial`,`nofail`,`replace_container`,`notes`,`must_learn`,`learned_by_item_id`,`quest`,`enabled`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(7296,CONVERT(0x436c617373203720447261676f726e204472616b657370696b65204172726f7720286c617267652047726f6f766529 USING utf8mb4),64,0,255,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7298,CONVERT(0x436c6173732037204472616b65626f6e6520446973636f726420546970204172726f7720286c617267652047726f6f766529 USING utf8mb4),64,0,255,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(7299,CONVERT(0x436c6173732037204472616b65626f6e65204472616b657370696b65204172726f7720286c617267652047726f6f766529 USING utf8mb4),64,0,255,0,0,NULL,0,0,0,1,-1,-1,NULL,NULL),
(28298,CONVERT(0x434c415353203720447261676f726e204472616b657370696b65204172726f772028536d616c6c2047726f6f766529 USING utf8mb4),64,0,295,0,0,CONVERT(0x447261676f6e73206f66204e6f7272617468202d20466c65746368696e67202865717472616465727320696d706f72742920 USING utf8mb4),0,0,0,1,9,99,'',''),
(28300,CONVERT(0x434c4153532037204472616b65626f6e6520446973636f726420546970204172726f772028536d616c6c2047726f6f766529 USING utf8mb4),64,0,282,0,0,CONVERT(0x447261676f6e73206f66204e6f7272617468202d20466c65746368696e67202865717472616465727320696d706f72742920 USING utf8mb4),0,0,0,1,9,99,'',''),
(28301,CONVERT(0x434c415353203720447261676f726e204472616b657370696b65204172726f7720284c617267652047726f6f766529 USING utf8mb4),64,0,295,0,0,CONVERT(0x447261676f6e73206f66204e6f7272617468202d20466c65746368696e67202865717472616465727320696d706f72742920 USING utf8mb4),0,0,0,0,9,99,'',''),
(28302,CONVERT(0x434c4153532037204472616b65626f6e65204472616b657370696b65204172726f772028536d616c6c2047726f6f766529 USING utf8mb4),64,0,308,0,0,CONVERT(0x447261676f6e73206f66204e6f7272617468202d20466c65746368696e67202865717472616465727320696d706f72742920 USING utf8mb4),0,0,0,1,9,99,'',''),
(28305,CONVERT(0x434c4153532037204472616b65626f6e65204472616b657370696b65204172726f7720284c617267652047726f6f766529 USING utf8mb4),64,0,308,0,0,CONVERT(0x447261676f6e73206f66204e6f7272617468202d20466c65746368696e67202865717472616465727320696d706f72742920 USING utf8mb4),0,0,0,0,9,99,'',''),
(28324,CONVERT(0x434c4153532037204472616b65626f6e6520446973636f726420546970204172726f7720284c617267652047726f6f766529 USING utf8mb4),64,0,282,0,0,CONVERT(0x447261676f6e73206f66204e6f7272617468202d20466c65746368696e67202865717472616465727320696d706f72742920 USING utf8mb4),0,0,0,0,9,99,'','');
 INSERT INTO rrc127_before (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(68984,7296,8050,0,0,1,1,0),
(68985,7296,45617,0,0,1,1,0),
(68986,7296,72092,0,0,1,1,0),
(68987,7296,72093,0,0,1,1,0),
(68988,7296,45832,10,0,0,0,0),
(68989,7296,17128,0,0,0,0,1),
(68990,7296,17189,0,0,0,0,1),
(68991,7296,17762,0,0,0,0,1),
(68992,7296,17910,0,0,0,0,1),
(68993,7296,66163,0,0,0,0,1),
(69004,7298,8050,0,0,1,1,0),
(69005,7298,45619,0,0,1,1,0),
(69006,7298,63862,0,0,1,1,0),
(69007,7298,72093,0,0,1,1,0),
(69008,7298,45847,10,0,0,0,0),
(69009,7298,17128,0,0,0,0,1),
(69010,7298,17189,0,0,0,0,1),
(69011,7298,17762,0,0,0,0,1),
(69012,7298,17910,0,0,0,0,1),
(69013,7298,66163,0,0,0,0,1),
(69014,7299,8050,0,0,1,1,0),
(69015,7299,45617,0,0,1,1,0),
(69016,7299,45619,0,0,1,1,0),
(69017,7299,72093,0,0,1,1,0),
(69018,7299,45850,10,0,0,0,0),
(69019,7299,17128,0,0,0,0,1),
(69020,7299,17189,0,0,0,0,1),
(69021,7299,17762,0,0,0,0,1),
(69022,7299,17910,0,0,0,0,1),
(69023,7299,66163,0,0,0,0,1),
(281659,28298,72092,0,0,1,1,0),
(281660,28298,45617,0,0,1,1,0),
(281661,28298,72093,0,0,1,1,0),
(281662,28298,8052,0,0,1,1,0),
(281663,28298,17910,0,0,0,0,1),
(281664,28298,17189,0,0,0,0,1),
(281665,28298,45834,10,0,0,0,0),
(281673,28300,63862,0,0,1,1,0),
(281674,28300,45619,0,0,1,1,0),
(281675,28300,72093,0,0,1,1,0),
(281676,28300,8052,0,0,1,1,0),
(281677,28300,17910,0,0,0,0,1),
(281678,28300,17189,0,0,0,0,1),
(281679,28300,45849,10,0,0,0,0),
(281680,28301,72092,0,0,1,1,0),
(281681,28301,45617,0,0,1,1,0),
(281682,28301,72093,0,0,1,1,0),
(281683,28301,8050,0,0,1,1,0),
(281684,28301,17910,0,0,0,0,1),
(281685,28301,17189,0,0,0,0,1),
(281686,28301,45832,10,0,0,0,0),
(281687,28302,45619,0,0,1,1,0),
(281688,28302,45617,0,0,1,1,0),
(281689,28302,72093,0,0,1,1,0),
(281690,28302,8052,0,0,1,1,0),
(281691,28302,17910,0,0,0,0,1),
(281692,28302,17189,0,0,0,0,1),
(281693,28302,45852,10,0,0,0,0),
(281711,28305,45619,0,0,1,1,0),
(281712,28305,45617,0,0,1,1,0),
(281713,28305,72093,0,0,1,1,0),
(281714,28305,8050,0,0,1,1,0),
(281715,28305,17910,0,0,0,0,1),
(281716,28305,17189,0,0,0,0,1),
(281717,28305,45850,10,0,0,0,0),
(281847,28324,63862,0,0,1,1,0),
(281848,28324,45619,0,0,1,1,0),
(281849,28324,72093,0,0,1,1,0),
(281850,28324,8050,0,0,1,1,0),
(281851,28324,17910,0,0,0,0,1),
(281852,28324,17762,0,0,0,0,1),
(281853,28324,54251,0,0,0,0,1),
(281854,28324,18,0,0,0,0,1),
(281855,28324,66630,0,0,0,0,1),
(281856,28324,45847,10,0,0,0,0);
 INSERT INTO rrc127_after (`id`,`recipe_id`,`item_id`,`successcount`,`failcount`,`componentcount`,`salvagecount`,`iscontainer`) VALUES
(68984,7296,8050,0,0,1,1,0),
(68985,7296,45617,0,0,1,1,0),
(68986,7296,72092,0,0,1,1,0),
(68987,7296,72093,0,0,1,1,0),
(68988,7296,45834,10,0,0,0,0),
(68989,7296,17128,0,0,0,0,1),
(68990,7296,17189,0,0,0,0,1),
(68991,7296,17762,0,0,0,0,1),
(68992,7296,17910,0,0,0,0,1),
(68993,7296,66163,0,0,0,0,1),
(69004,7298,8050,0,0,1,1,0),
(69005,7298,45619,0,0,1,1,0),
(69006,7298,63862,0,0,1,1,0),
(69007,7298,72093,0,0,1,1,0),
(69008,7298,45849,10,0,0,0,0),
(69009,7298,17128,0,0,0,0,1),
(69010,7298,17189,0,0,0,0,1),
(69011,7298,17762,0,0,0,0,1),
(69012,7298,17910,0,0,0,0,1),
(69013,7298,66163,0,0,0,0,1),
(69014,7299,8050,0,0,1,1,0),
(69015,7299,45617,0,0,1,1,0),
(69016,7299,45619,0,0,1,1,0),
(69017,7299,72093,0,0,1,1,0),
(69018,7299,45852,10,0,0,0,0),
(69019,7299,17128,0,0,0,0,1),
(69020,7299,17189,0,0,0,0,1),
(69021,7299,17762,0,0,0,0,1),
(69022,7299,17910,0,0,0,0,1),
(69023,7299,66163,0,0,0,0,1),
(281659,28298,72092,0,0,1,1,0),
(281660,28298,45617,0,0,1,1,0),
(281661,28298,72093,0,0,1,1,0),
(281662,28298,8052,0,0,1,1,0),
(281663,28298,17910,0,0,0,0,1),
(281664,28298,17189,0,0,0,0,1),
(281665,28298,45834,10,0,0,0,0),
(281673,28300,63862,0,0,1,1,0),
(281674,28300,45619,0,0,1,1,0),
(281675,28300,72093,0,0,1,1,0),
(281676,28300,8052,0,0,1,1,0),
(281677,28300,17910,0,0,0,0,1),
(281678,28300,17189,0,0,0,0,1),
(281679,28300,45849,10,0,0,0,0),
(281680,28301,72092,0,0,1,1,0),
(281681,28301,45617,0,0,1,1,0),
(281682,28301,72093,0,0,1,1,0),
(281683,28301,8050,0,0,1,1,0),
(281684,28301,17910,0,0,0,0,1),
(281685,28301,17189,0,0,0,0,1),
(281686,28301,45832,10,0,0,0,0),
(281687,28302,45619,0,0,1,1,0),
(281688,28302,45617,0,0,1,1,0),
(281689,28302,72093,0,0,1,1,0),
(281690,28302,8052,0,0,1,1,0),
(281691,28302,17910,0,0,0,0,1),
(281692,28302,17189,0,0,0,0,1),
(281693,28302,45852,10,0,0,0,0),
(281711,28305,45619,0,0,1,1,0),
(281712,28305,45617,0,0,1,1,0),
(281713,28305,72093,0,0,1,1,0),
(281714,28305,8050,0,0,1,1,0),
(281715,28305,17910,0,0,0,0,1),
(281716,28305,17189,0,0,0,0,1),
(281717,28305,45850,10,0,0,0,0),
(281847,28324,63862,0,0,1,1,0),
(281848,28324,45619,0,0,1,1,0),
(281849,28324,72093,0,0,1,1,0),
(281850,28324,8050,0,0,1,1,0),
(281851,28324,17910,0,0,0,0,1),
(281852,28324,17762,0,0,0,0,1),
(281853,28324,54251,0,0,0,0,1),
(281854,28324,18,0,0,0,0,1),
(281855,28324,66630,0,0,0,0,1),
(281856,28324,45847,10,0,0,0,0);
 START TRANSACTION;
 SET own_transaction=TRUE;
 SELECT COUNT(*)INTO recipes_before FROM tradeskill_recipe;
 SELECT COUNT(*)INTO entries_before FROM tradeskill_recipe_entries;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe r JOIN rrc127_recipes e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>9 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC127 definition/peer missing'; END IF;
 SELECT COUNT(*)INTO locked_rows FROM tradeskill_recipe_entries r JOIN rrc127_before e ON r.id=e.id FOR UPDATE;
 IF locked_rows<>75 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC127 target/peer entries missing'; END IF;
 IF EXISTS(SELECT 1 FROM rrc127_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC127 definition/peer drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc127_before e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc127_recipes p ON p.id=r.recipe_id)<>75 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC127 preimage mismatch'; END IF;
 IF(SELECT COUNT(*)FROM items WHERE (`id` <=> 8050 AND BINARY Name=BINARY CONVERT(0x4c617267652047726f6f7665204e6f636b73 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0) OR (`id` <=> 45617 AND BINARY Name=BINARY CONVERT(0x4472616b652d5370696b6573 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0) OR (`id` <=> 45619 AND BINARY Name=BINARY CONVERT(0x4472616b652057696e6720426f6e6573 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 65535 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0) OR (`id` <=> 45832 AND BINARY Name=BINARY CONVERT(0x434c415353203720447261676f726e204472616b657370696b65204172726f77 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 27 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 12 AND `delay` <=> 0 AND `range` <=> 75 AND `slots` <=> 4194304 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0) OR (`id` <=> 45834 AND BINARY Name=BINARY CONVERT(0x434c415353203720447261676f726e204472616b657370696b65204172726f77 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 27 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 12 AND `delay` <=> 0 AND `range` <=> 125 AND `slots` <=> 4194304 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0) OR (`id` <=> 45847 AND BINARY Name=BINARY CONVERT(0x434c4153532037204472616b65626f6e6520446973636f726420546970204172726f77 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 27 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 12 AND `delay` <=> 0 AND `range` <=> 75 AND `slots` <=> 4194304 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0) OR (`id` <=> 45849 AND BINARY Name=BINARY CONVERT(0x434c4153532037204472616b65626f6e6520446973636f726420546970204172726f77 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 27 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 12 AND `delay` <=> 0 AND `range` <=> 125 AND `slots` <=> 4194304 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0) OR (`id` <=> 45850 AND BINARY Name=BINARY CONVERT(0x434c4153532037204472616b65626f6e65204472616b657370696b65204172726f77 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 27 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 13 AND `delay` <=> 0 AND `range` <=> 75 AND `slots` <=> 4194304 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0) OR (`id` <=> 45852 AND BINARY Name=BINARY CONVERT(0x434c4153532037204472616b65626f6e65204472616b657370696b65204172726f77 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 27 AND `stackable` <=> 1 AND `stacksize` <=> 100 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 285 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 13 AND `delay` <=> 0 AND `range` <=> 125 AND `slots` <=> 4194304 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0) OR (`id` <=> 63862 AND BINARY Name=BINARY CONVERT(0x446973636f7264204172726f7768656164 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 269 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0) OR (`id` <=> 72092 AND BINARY Name=BINARY CONVERT(0x447261676f726e2057696e6720426f6e6573 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0) OR (`id` <=> 72093 AND BINARY Name=BINARY CONVERT(0x476972706c616e204665617468657273 USING utf8mb4) AND `size` <=> 1 AND `itemclass` <=> 0 AND `itemtype` <=> 17 AND `stackable` <=> 1 AND `stacksize` <=> 20 AND `maxcharges` <=> 0 AND `bagtype` <=> 0 AND `bagslots` <=> 0 AND `bagsize` <=> 0 AND `classes` <=> 0 AND `races` <=> 65535 AND `deity` <=> 0 AND `damage` <=> 0 AND `delay` <=> 0 AND `range` <=> 0 AND `slots` <=> 0 AND `reqlevel` <=> 0 AND `reclevel` <=> 0 AND `loregroup` <=> 0))<>12 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC127 native item identity/range drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.iscontainer=0 AND e.successcount>e.componentcount AND e.item_id IN(45832,45834,45847,45849,45850,45852)AND NOT EXISTS(SELECT 1 FROM rrc127_recipes p WHERE p.id=e.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC127 output-producer universe drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72093 AND a.componentcount>0 AND a.iscontainer=0 AND r.id NOT IN(7296,28301) AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=4 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72092)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=45617)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72093)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=8050)=1)THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC127 selected fullinput universe drift';END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72093 AND a.componentcount>0 AND a.iscontainer=0 AND r.id NOT IN(7298,28324) AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=4 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=63862)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=45619)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72093)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=8050)=1)THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC127 selected fullinput universe drift';END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72093 AND a.componentcount>0 AND a.iscontainer=0 AND r.id NOT IN(7299,28305) AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=4 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=45619)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=45617)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72093)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=8050)=1)THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC127 selected fullinput universe drift';END IF;
 UPDATE tradeskill_recipe_entries r JOIN rrc127_after e ON r.id=e.id SET r.item_id=e.item_id WHERE r.id IN(68988,69008,69018);
 SET changed_rows=ROW_COUNT();
 IF changed_rows<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC127 changed-row mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM rrc127_recipes e LEFT JOIN tradeskill_recipe r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND BINARY r.`name` <=> BINARY e.`name` AND r.`tradeskill` <=> e.`tradeskill` AND r.`skillneeded` <=> e.`skillneeded` AND r.`trivial` <=> e.`trivial` AND r.`nofail` <=> e.`nofail` AND r.`replace_container` <=> e.`replace_container` AND BINARY r.`notes` <=> BINARY e.`notes` AND r.`must_learn` <=> e.`must_learn` AND r.`learned_by_item_id` <=> e.`learned_by_item_id` AND r.`quest` <=> e.`quest` AND r.`enabled` <=> e.`enabled` AND r.`min_expansion` <=> e.`min_expansion` AND r.`max_expansion` <=> e.`max_expansion` AND BINARY r.`content_flags` <=> BINARY e.`content_flags` AND BINARY r.`content_flags_disabled` <=> BINARY e.`content_flags_disabled`)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC127 definition/peer drift'; END IF;
 IF EXISTS(SELECT 1 FROM rrc127_after e LEFT JOIN tradeskill_recipe_entries r ON r.id=e.id WHERE r.id IS NULL OR NOT(r.`id` <=> e.`id` AND r.`recipe_id` <=> e.`recipe_id` AND r.`item_id` <=> e.`item_id` AND r.`successcount` <=> e.`successcount` AND r.`failcount` <=> e.`failcount` AND r.`componentcount` <=> e.`componentcount` AND r.`salvagecount` <=> e.`salvagecount` AND r.`iscontainer` <=> e.`iscontainer`)) OR(SELECT COUNT(*)FROM tradeskill_recipe_entries r JOIN rrc127_recipes p ON p.id=r.recipe_id)<>75 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC127 postimage mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries e WHERE e.iscontainer=0 AND e.successcount>e.componentcount AND e.item_id IN(45832,45834,45847,45849,45850,45852)AND NOT EXISTS(SELECT 1 FROM rrc127_recipes p WHERE p.id=e.recipe_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC127 output-producer universe drift'; END IF;
 IF(SELECT COUNT(*)FROM tradeskill_recipe)<>recipes_before OR(SELECT COUNT(*)FROM tradeskill_recipe_entries)<>entries_before THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC127 global row-count drift'; END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72093 AND a.componentcount>0 AND a.iscontainer=0 AND r.id NOT IN(7296,28301) AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=4 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72092)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=45617)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72093)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=8050)=1)THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC127 selected fullinput universe drift';END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72093 AND a.componentcount>0 AND a.iscontainer=0 AND r.id NOT IN(7298,28324) AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=4 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=63862)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=45619)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72093)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=8050)=1)THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC127 selected fullinput universe drift';END IF;
 IF EXISTS(SELECT 1 FROM tradeskill_recipe_entries a JOIN tradeskill_recipe r ON r.id=a.recipe_id WHERE a.item_id=72093 AND a.componentcount>0 AND a.iscontainer=0 AND r.id NOT IN(7299,28305) AND(SELECT SUM(e.componentcount)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0)=4 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=45619)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=45617)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=72093)=1 AND(SELECT COALESCE(SUM(e.componentcount),0)FROM tradeskill_recipe_entries e WHERE e.recipe_id=r.id AND e.iscontainer=0 AND e.item_id=8050)=1)THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RRC127 selected fullinput universe drift';END IF;
 DROP TEMPORARY TABLE rrc127_before;
 DROP TEMPORARY TABLE rrc127_after;
 DROP TEMPORARY TABLE rrc127_recipes;
 COMMIT;
 SET own_transaction=FALSE;
 SELECT 'RRC127',changed_rows,recipes_before,(SELECT COUNT(*)FROM tradeskill_recipe),entries_before,(SELECT COUNT(*)FROM tradeskill_recipe_entries),@@in_transaction;
END//
DELIMITER ;
