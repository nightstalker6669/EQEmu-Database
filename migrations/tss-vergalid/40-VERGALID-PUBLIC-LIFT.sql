-- The physical platform and both ropes move only when an original lever calls
-- them. They must hold their state throughout the boarding and riding window.
DELIMITER //
CREATE PROCEDURE rof2_bind_vergalid_public_lift()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
    UPDATE doors
    SET disable_timer=1
    WHERE zone='vergalid' AND version=0 AND opentype=59
      AND disable_timer=0 AND triggerdoor=0 AND triggertype=0
      AND ((id=17396 AND doorid=38 AND name='OBJ_ELEVPLAT') OR
           (id=17397 AND doorid=39 AND name='OBJ_ELEVROPE') OR
           (id=17398 AND doorid=40 AND name='OBJ_ELEVROPE'));
    IF ROW_COUNT() <> 3 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Unexpected preimages for the three public Vergalid lift leaves';
    END IF;
    COMMIT;
END//
DELIMITER ;
CALL rof2_bind_vergalid_public_lift();
DROP PROCEDURE rof2_bind_vergalid_public_lift;
