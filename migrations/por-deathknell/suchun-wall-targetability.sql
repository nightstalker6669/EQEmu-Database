DELIMITER //
BEGIN NOT ATOMIC
    DECLARE matches_before INT DEFAULT 0;
    DECLARE matches_after INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO matches_before FROM npc_types
    WHERE id = 377944 AND BINARY name = 'a_petrified_root_wall'
      AND BINARY lastname = 'DEST_TAK_ROOTWALL' AND class = 62
      AND race = 240 AND bodytype = 11 AND untargetable = 0 AND show_name = 0
      AND BINARY special_abilities = '21,1^24,1^25,1^34,1'
    FOR UPDATE;
    IF matches_before <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Suchun destructible wall preimage differs';
    END IF;

    UPDATE npc_types SET bodytype = 0 WHERE id = 377944;

    SELECT COUNT(*) INTO matches_after FROM npc_types
    WHERE id = 377944 AND BINARY name = 'a_petrified_root_wall'
      AND BINARY lastname = 'DEST_TAK_ROOTWALL' AND class = 62
      AND race = 240 AND bodytype = 0 AND untargetable = 0 AND show_name = 0
      AND BINARY special_abilities = '21,1^24,1^25,1^34,1';
    IF matches_after <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Suchun destructible wall postimage differs';
    END IF;

    COMMIT;
END//
DELIMITER ;
