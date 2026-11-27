-- Restore ordinary access to the five public Rain of Fear Collections zones.
-- Preserve all level, expansion, quest and other zone policies.
DELIMITER $$
BEGIN NOT ATOMIC
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    UPDATE zone
    SET min_status=0
    WHERE version=0 AND expansion=19 AND min_status=80
      AND (id,zoneidnumber,BINARY short_name) IN (
          (5886,757,'breedinggrounds'),
          (5887,760,'chapterhouse'),
          (5890,758,'eviltree'),
          (5891,759,'grelleth'),
          (5894,753,'xorbb')
      );

    IF ROW_COUNT() <> 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Collections public access: exact five zone preimages required';
    END IF;

    COMMIT;
END$$
DELIMITER ;
