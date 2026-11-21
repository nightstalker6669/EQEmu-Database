-- Optional PoR R2 addon. Apply offline with rage version 0 shut down.
-- Keep 920327 disabled until the matched source and owner catalog are installed.
DELIMITER //
BEGIN NOT ATOMIC
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        DROP TEMPORARY TABLE IF EXISTS por_sverag_mounts;
        RESIGNAL;
    END;

    START TRANSACTION;
    IF EXISTS (SELECT 1 FROM spawn_conditions WHERE zone='rage')
       OR EXISTS (SELECT 1 FROM spawn_condition_values WHERE zone='rage' AND instance_id=0)
       OR EXISTS (SELECT 1 FROM spawn_events WHERE zone='rage')
       OR NOT EXISTS (
           SELECT 1 FROM spawn2 WHERE id=105981 AND spawngroupID=67815
              AND zone='rage' AND version=0 AND x=-13 AND y=986 AND z=5.25
       )
       OR (SELECT COUNT(*) FROM npc_types WHERE race=486 AND (
           (id=372099 AND name='#Skald_Vergaldin' AND npc_faction_id=0) OR
           (id=372076 AND loottable_id=91945) OR
           (id=372085 AND loottable_id=91947) OR
           (id=372088 AND loottable_id=91946)
       ))<>4 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Unexpected Sverag spawn condition or stock actor preimage';
    END IF;

    CREATE TEMPORARY TABLE por_sverag_mounts (
        spawn_id INT UNSIGNED PRIMARY KEY,
        group_id INT NOT NULL UNIQUE,
        bolvirk_id INT NOT NULL
    );
    INSERT INTO por_sverag_mounts
    SELECT s.id, s.spawngroupID, CASE e.npcID
        WHEN 374001 THEN 372099
        WHEN 374003 THEN 372076
        WHEN 374004 THEN 372088
        WHEN 374009 THEN 372088
        ELSE 372085
    END
    FROM spawn2 s
    JOIN spawnentry e ON e.spawngroupID=s.spawngroupID
    JOIN spawngroup g ON g.id=s.spawngroupID
    WHERE s.zone='rage' AND s.version=0 AND s._condition=0 AND s.cond_value=1
      AND g.despawn=0
      AND ((s.id=105981 AND e.npcID=374001)
        OR (s.id<>105981 AND e.npcID IN (374002,374003,374004,374005,374006,374007,374009,374012)))
      AND e.condition_value_filter=1 AND e.chance=100 AND e.min_time=0 AND e.max_time=0
      AND e.min_expansion=-1 AND e.max_expansion=-1
      AND COALESCE(e.content_flags,'')='' AND COALESCE(e.content_flags_disabled,'')=''
      AND NOT EXISTS (
          SELECT 1 FROM spawn2 other WHERE other.spawngroupID=s.spawngroupID AND other.id<>s.id
      )
      AND NOT EXISTS (
          SELECT 1 FROM spawnentry other
          WHERE other.spawngroupID=e.spawngroupID AND other.npcID<>e.npcID
      );

    IF (SELECT COUNT(*) FROM por_sverag_mounts)<>159
       OR EXISTS (
           SELECT 1 FROM zone_state_spawns z JOIN por_sverag_mounts m ON m.spawn_id=z.spawn2_id
           WHERE z.zone_id=374 AND z.instance_id=0 AND z.is_corpse=0
       ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Sverag mount count differs or selected mounts have saved state';
    END IF;

    -- Native SpawnGroup selection uses the condition value as the exact entry filter.
    -- Both passes use the original spawn points; no new NPC or placement IDs.
    INSERT INTO spawn_conditions (zone,id,value,onchange,name)
    VALUES ('rage',1,2,0,'PoR Sverag control: 1 Undead, 2 Bolvirk');

    INSERT INTO spawnentry (spawngroupID,npcID,chance,condition_value_filter)
    SELECT group_id,bolvirk_id,100,2 FROM por_sverag_mounts;

    UPDATE spawn2 s JOIN por_sverag_mounts m ON m.spawn_id=s.id
    SET s._condition=1;
    IF ROW_COUNT()<>159 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Sverag stage affected unexpected placements';
    END IF;
    DROP TEMPORARY TABLE por_sverag_mounts;
    COMMIT;
END//
DELIMITER ;
