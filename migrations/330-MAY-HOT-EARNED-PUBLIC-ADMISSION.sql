-- Match project-authored HoT missions and the native persisted achievement entry checks.
-- Replace staff checks with earned admission on exactly six original public v0 rows.
DELIMITER $$
BEGIN NOT ATOMIC
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    START TRANSACTION;
    IF COALESCE((SELECT SHA2(GROUP_CONCAT(h ORDER BY id SEPARATOR ''),256) FROM (SELECT id,SHA2(JSON_ARRAY(`id`,`zoneidnumber`,`version`,`short_name`,`long_name`,`min_status`,COALESCE(`map_file_name`,''),COALESCE(`note`,''),`min_expansion`,`max_expansion`,COALESCE(`content_flags`,''),COALESCE(`content_flags_disabled`,''),`expansion`,COALESCE(`file_name`,''),`safe_x`,`safe_y`,`safe_z`,`safe_heading`,`graveyard_id`,`min_level`,`max_level`,`timezone`,`maxclients`,`ruleset`,`underworld`,`minclip`,`maxclip`,`fog_minclip`,`fog_maxclip`,`fog_blue`,`fog_red`,`fog_green`,`sky`,`ztype`,`zone_exp_multiplier`,`walkspeed`,`time_type`,`fog_red1`,`fog_green1`,`fog_blue1`,`fog_minclip1`,`fog_maxclip1`,`fog_red2`,`fog_green2`,`fog_blue2`,`fog_minclip2`,`fog_maxclip2`,`fog_red3`,`fog_green3`,`fog_blue3`,`fog_minclip3`,`fog_maxclip3`,`fog_red4`,`fog_green4`,`fog_blue4`,`fog_minclip4`,`fog_maxclip4`,`fog_density`,`flag_needed`,`canbind`,`cancombat`,`canlevitate`,`castoutdoor`,`hotzone`,`insttype`,`shutdowndelay`,`peqzone`,`bypass_expansion_check`,`suspendbuffs`,`rain_chance1`,`rain_chance2`,`rain_chance3`,`rain_chance4`,`rain_duration1`,`rain_duration2`,`rain_duration3`,`rain_duration4`,`snow_chance1`,`snow_chance2`,`snow_chance3`,`snow_chance4`,`snow_duration1`,`snow_duration2`,`snow_duration3`,`snow_duration4`,`gravity`,`type`,`skylock`,`fast_regen_hp`,`fast_regen_mana`,`fast_regen_endurance`,`npc_max_aggro_dist`,`client_update_range`,`underworld_teleport_index`,`lava_damage`,`min_lava_damage`,`idle_when_empty`,`seconds_before_idle`,`shard_at_player_count`,`allow_mercs`),256) h FROM zone WHERE id IN (5557,5558,5562,5563,5564,5566)) v),'')<>'5cc5a091ae13592ac8ba3a1e9035bf483d27de4a6d86d6da075612c46daaa42c' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='HoT earned gates exact public preimage mismatch'; END IF;
    IF (SELECT COUNT(*) FROM tasks t WHERE (t.id=920131 OR t.id BETWEEN 920400 AND 920435)
 AND t.enabled=1 AND EXISTS (SELECT 1 FROM task_activities a WHERE a.taskid=t.id))<>37 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='HoT earned gates matched prerequisites absent'; END IF;
    IF (SELECT COUNT(*) FROM achievement_criteria c
JOIN achievement_components a ON (a.achievement_id,a.component_type,a.component_id,a.sequence)=(c.achievement_id,c.component_type,c.component_id,c.component_sequence)
JOIN tasks t ON t.id=c.target_id
JOIN dynamic_zone_templates d ON d.id=t.dz_template_id
JOIN zone z ON z.zoneidnumber=d.zone_id AND z.version=d.zone_version
JOIN task_activities end_goal ON end_goal.taskid=t.id AND end_goal.activityid=t.lock_activity_id
WHERE c.id BETWEEN 304101805 AND 304101814 AND c.target_id=c.id-303181425 AND c.behavior=0 AND c.event_type=4 AND c.required_count=1 AND c.enabled=1 AND c.achievement_id=IF(t.id<=920385,1800000,1800010)
AND t.enabled=1 AND t.type=1 AND z.version=20 AND z.min_status=0 AND end_goal.step=2 AND end_goal.activitytype=11 AND end_goal.goalmethod=2)<>10 OR (SELECT COUNT(*) FROM achievements WHERE id IN (1800000,1800010) AND enabled=1)<>2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='HoT earned gates matched earned criteria absent'; END IF;
    UPDATE zone SET min_status=0,flag_needed=CASE WHEN id IN (5557,5563) THEN 'hot_group_tier4' ELSE 'hot_group_tier3' END
    WHERE id IN (5557,5558,5562,5563,5564,5566) AND version=0 AND min_status=80 AND flag_needed='';
    IF ROW_COUNT()<>6 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='HoT earned gates affected row count mismatch'; END IF;
    COMMIT;
END$$
DELIMITER ;
