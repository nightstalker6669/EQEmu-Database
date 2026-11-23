-- One table invocation per corpse: one guaranteed rune and one optional roll.
DELIMITER //
CREATE PROCEDURE rof2_bound_vergalid_rune_drops()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
    UPDATE loottable_entries
    SET multiplier=1
    WHERE loottable_id IN (304092051, 304092053) AND lootdrop_id=304092062
      AND multiplier=2 AND droplimit=2 AND mindrop=1 AND probability=100;
    IF ROW_COUNT() <> 2 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Unexpected Nurtha and Vergalid rune pool preimages';
    END IF;
    COMMIT;
END//
DELIMITER ;
CALL rof2_bound_vergalid_rune_drops();
DROP PROCEDURE rof2_bound_vergalid_rune_drops;
