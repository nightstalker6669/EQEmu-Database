-- Bind the original public click-ground actor to its existing Elddar zone point.
START TRANSACTION;
DELIMITER //
BEGIN NOT ATOMIC
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    UPDATE doors d
    JOIN zone_points p
      ON p.id=1538 AND p.zone='takishruins' AND p.version=0 AND p.number=9
     AND p.target_zone_id=378 AND p.target_instance=0
    SET d.dest_zone='elddar', d.dest_instance=0, d.dest_x=p.target_x,
        d.dest_y=p.target_y, d.dest_z=p.target_z, d.dest_heading=p.target_heading
    WHERE d.id=16846 AND d.zone='takishruins' AND d.version=0 AND d.doorid=3
      AND d.name='OBJ_STAGE_TELEPORT' AND d.opentype=57
      AND d.dest_zone='NONE' AND d.dest_instance=0
      AND d.dest_x=0 AND d.dest_y=0 AND d.dest_z=0 AND d.dest_heading=0
      AND d.keyitem=0 AND d.nokeyring=0 AND d.lockpick=0 AND d.guild=0
      AND d.triggerdoor=0 AND d.triggertype=0 AND d.door_param=-1
      AND p.target_x=-174 AND p.target_y=200 AND p.target_z=88 AND p.target_heading=22;

    IF ROW_COUNT() <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Tunare Takish ground door preimage mismatch';
    END IF;
END//
DELIMITER ;
COMMIT;
