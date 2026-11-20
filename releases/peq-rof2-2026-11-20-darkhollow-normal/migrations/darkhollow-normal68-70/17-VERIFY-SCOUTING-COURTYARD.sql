DELIMITER $$
BEGIN NOT ATOMIC
 DECLARE started BOOLEAN DEFAULT FALSE;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION
 BEGIN
  IF started THEN ROLLBACK; END IF;
  RESIGNAL;
 END;
IF DATABASE() IS NULL OR @@in_transaction<>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Scouting development target or transaction differs'; END IF;
 SET TRANSACTION READ ONLY;
 START TRANSACTION;
 SET started=TRUE;
IF (SELECT COUNT(*) FROM task_activities WHERE `taskid` <=> 920237 AND `activityid` <=> 1 AND `req_activity_id` <=> -1 AND `step` <=> 1 AND `activitytype` <=> 5 AND BINARY `target_name` <=> BINARY '' AND `goalmethod` <=> 0 AND `goalcount` <=> 1 AND BINARY `description_override` <=> BINARY CONVERT(X'4578706c6f7265207468652043697479206f662058696c6c20636f75727479617264' USING utf8mb4) AND BINARY `npc_match_list` <=> BINARY '' AND BINARY `item_id_list` <=> BINARY '' AND BINARY `item_list` <=> BINARY '' AND `dz_switch_id` <=> 0 AND `min_x` <=> -442.0 AND `min_y` <=> -1106.0 AND `min_z` <=> 32 AND `max_x` <=> -394.0 AND `max_y` <=> -1058.0 AND `max_z` <=> 46 AND BINARY `skill_list` <=> BINARY CONVERT(X'2d31' USING utf8mb4) AND BINARY `spell_list` <=> BINARY CONVERT(X'30' USING utf8mb4) AND BINARY `zones` <=> BINARY CONVERT(X'333538' USING utf8mb4) AND `zone_version` <=> 3 AND `optional` <=> 0 AND `list_group` <=> 0)<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Scouting full activity row differs'; END IF;
 COMMIT;
 SET started=FALSE;
 SELECT 'SCOUTING_COURTYARD_EXACT_READBACK' AS receipt;
END$$
DELIMITER ;
