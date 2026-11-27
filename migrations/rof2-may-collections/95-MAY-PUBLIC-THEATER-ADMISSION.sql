-- Restore the already accepted public Theater admission row to the fresh seed.
-- This member is release-only. The existing dev postimage is a verified no-op.
DELIMITER $$
BEGIN NOT ATOMIC
    DECLARE current_status INT DEFAULT NULL;
    DECLARE current_level INT DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    START TRANSACTION;

    SELECT min_status,min_level INTO current_status,current_level
    FROM zone
    WHERE id=391 AND zoneidnumber=380 AND version=0 AND expansion=11
      AND BINARY short_name='theater' AND BINARY flag_needed=''
    FOR UPDATE;

    IF current_status=80 AND current_level=0 THEN
        UPDATE zone SET min_status=0,min_level=68
        WHERE id=391 AND min_status=80 AND min_level=0;
        IF ROW_COUNT() <> 1 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Theater admission row count mismatch';
        END IF;
    ELSEIF NOT (current_status<=>0 AND current_level<=>68) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Theater admission preimage mismatch';
    END IF;

    COMMIT;
END$$
DELIMITER ;
