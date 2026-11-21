-- Run after owner's eight alternate routes have been enabled and addon Lua installed.
DELIMITER //
BEGIN NOT ATOMIC
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
    IF (SELECT COUNT(*) FROM tasks WHERE id BETWEEN 920326 AND 920334 AND id<>920327 AND enabled=1)<>8
       OR NOT EXISTS (
           SELECT 1 FROM tasks WHERE id=920327 AND title='Bring Me Their Skulls!'
              AND enabled=0 AND min_level=70 AND reward_method=3
       )
       OR NOT EXISTS (
           SELECT 1 FROM task_activities WHERE taskid=920327 AND activityid=0 AND activitytype=1
             AND goalmethod=2 AND goalcount=4 AND item_id_list='88061' AND zones='374' AND zone_version=0
       )
       OR (SELECT COUNT(*) FROM reward_options WHERE reward_set_id=920327)<>16
       OR NOT EXISTS (
           SELECT 1 FROM spawn_conditions c
           JOIN spawn2 s ON s.zone=c.zone AND s._condition=c.id
           JOIN spawnentry e ON e.spawngroupID=s.spawngroupID
           WHERE c.zone='rage' AND c.id=1 AND c.value=2
             AND s.version=0 AND s.id=105981 AND e.npcID=372099 AND e.condition_value_filter=2
       ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Skulls QA needs PoR R2 catalog and the staged Bolvirk contact';
    END IF;
    UPDATE tasks SET enabled=1 WHERE id=920327 AND enabled=0;
    IF ROW_COUNT()<>1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Skulls QA affected unexpected tasks';
    END IF;
    COMMIT;
END//
DELIMITER ;
