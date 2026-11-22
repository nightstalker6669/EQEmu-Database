DELIMITER //
BEGIN NOT ATOMIC
    DECLARE matched_before INT DEFAULT 0;
    DECLARE matched_after INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO matched_before
    FROM npc_types
    WHERE id = 371940 AND BINARY name = 'a_crystal_spirit'
      AND race = 240 AND bodytype = 11 AND level = 73 AND texture = 0
      AND class = 1 AND gender = 2 AND untargetable = 0 AND show_name = 1
      AND BINARY special_abilities = '' AND loottable_id = 0
    FOR UPDATE;

    IF matched_before <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Daosheen crystal spirit preimage differs';
    END IF;

    UPDATE npc_types
    SET race = 431, bodytype = 5, level = 70, texture = 1
    WHERE id = 371940;

    SELECT COUNT(*) INTO matched_after
    FROM npc_types
    WHERE id = 371940 AND BINARY name = 'a_crystal_spirit'
      AND race = 431 AND bodytype = 5 AND level = 70 AND texture = 1
      AND class = 1 AND gender = 2 AND untargetable = 0 AND show_name = 1
      AND BINARY special_abilities = '' AND loottable_id = 0;
    IF matched_after <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Daosheen crystal spirit postimage differs';
    END IF;

    COMMIT;
END//
DELIMITER ;
