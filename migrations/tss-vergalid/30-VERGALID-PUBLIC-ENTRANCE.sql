-- Two existing public packet-1 doors, on their original geometry and version.
DELIMITER //
CREATE PROCEDURE rof2_bind_vergalid_public_doors()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    UPDATE doors
    SET dest_zone='vergalid', dest_x=14, dest_y=0, dest_z=3, dest_heading=0
    WHERE id=17358 AND zone='sunderock' AND version=0 AND doorid=1
      AND name='OBJ_DOOR_MINES' AND opentype=58 AND dest_zone='NONE'
      AND dest_instance=0 AND dest_x=0 AND dest_y=0 AND dest_z=0 AND dest_heading=0
      AND ABS(pos_x+1627.04)<0.01 AND ABS(pos_y+916.026)<0.01 AND ABS(pos_z-289.886)<0.01;
    IF ROW_COUNT() <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Unexpected preimage for Sunderock public mines door';
    END IF;

    UPDATE doors
    SET dest_zone='sunderock', dest_x=-1615, dest_y=-916, dest_z=212, dest_heading=384
    WHERE id=17361 AND zone='vergalid' AND version=0 AND doorid=1
      AND name='OBJ_VM_ENTRANCEDOOR' AND opentype=58 AND dest_zone='NONE'
      AND dest_instance=0 AND dest_x=0 AND dest_y=0 AND dest_z=0 AND dest_heading=0
      AND ABS(pos_x-40.1579)<0.01 AND ABS(pos_y-0.21)<0.01 AND ABS(pos_z-32.5116)<0.01;
    IF ROW_COUNT() <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Unexpected preimage for Vergalid public exit door';
    END IF;

    COMMIT;
END//
DELIMITER ;
CALL rof2_bind_vergalid_public_doors();
DROP PROCEDURE rof2_bind_vergalid_public_doors;
