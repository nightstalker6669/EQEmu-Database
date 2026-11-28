-- Offline candidate. Preserve the two existing race alternatives and add the authentic Poison Frog model.
DELIMITER $$
BEGIN NOT ATOMIC
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    START TRANSACTION;
    IF NOT EXISTS (SELECT 1 FROM achievements WHERE id=11000084 AND BINARY name='Rrrribit!' AND enabled=0)
        OR NOT EXISTS (SELECT 1 FROM achievement_components WHERE achievement_id=11000084 AND component_type=1
                       AND component_id=300268 AND sequence=1 AND BINARY name='Frogs')
        OR NOT EXISTS (SELECT 1 FROM achievement_associations WHERE component_id=300268 AND required_count=100)
        OR (SELECT COUNT(*) FROM achievement_criteria WHERE achievement_id=11000084)<>2
        OR (SELECT COUNT(*) FROM achievement_criteria WHERE achievement_id=11000084 AND component_type=1
            AND component_sequence=1 AND component_id=300268 AND event_type=3 AND progress_mode=0 AND behavior=0
            AND target_id2=0 AND target_value=0 AND required_count=100 AND enabled=1
            AND (id,target_id) IN ((8321,343),(8322,603)))<>2
        OR EXISTS (SELECT 1 FROM achievement_criteria WHERE id=304101034)
        OR NOT EXISTS (
            SELECT 1 FROM npc_types n JOIN spawnentry e ON e.npcID=n.id
            JOIN spawn2 s ON s.spawngroupID=e.spawngroupID JOIN zone z ON z.short_name=s.zone AND z.version=0
            WHERE n.id=210047 AND n.race=316 AND e.chance>0 AND s.zone='postorms' AND s.version=0 AND z.min_status=0
        )
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Rrrribit exact frog preimage mismatch'; END IF;

    INSERT INTO achievement_criteria
        (id,achievement_id,component_type,component_sequence,component_id,event_type,progress_mode,
         behavior,target_id,target_id2,target_value,required_count,enabled)
        VALUES (304101034,11000084,1,1,300268,3,0,0,316,0,0,100,1);
    IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Rrrribit frog criterion count mismatch'; END IF;
    UPDATE achievements SET enabled=1 WHERE id=11000084 AND enabled=0;
    IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Rrrribit enable count mismatch'; END IF;
    COMMIT;
END$$
DELIMITER ;
