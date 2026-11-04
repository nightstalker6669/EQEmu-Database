-- AA007: source-established Drakkin race/heritage fields only.
-- Preserves existing ownership. See qualified impact and provenance notes.
DELIMITER //
BEGIN NOT ATOMIC
DECLARE actual_count INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
SELECT COUNT(*) INTO actual_count FROM aa_ability WHERE id BETWEEN 590 AND 595 FOR UPDATE;
IF actual_count <> 6 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA007 target count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM aa_ability WHERE (id=590 AND races=65535 AND drakkin_heritage=127) OR (id=591 AND races=65535 AND drakkin_heritage=127) OR (id=592 AND races=65535 AND drakkin_heritage=127) OR (id=593 AND races=65535 AND drakkin_heritage=127) OR (id=594 AND races=65535 AND drakkin_heritage=127) OR (id=595 AND races=65535 AND drakkin_heritage=127);
IF actual_count <> 6 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA007 field pre/postimage mismatch'; END IF;
UPDATE aa_ability SET races=32768,drakkin_heritage=1 WHERE id=590;
IF ROW_COUNT() <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA007 update count mismatch'; END IF;
UPDATE aa_ability SET races=32768,drakkin_heritage=2 WHERE id=591;
IF ROW_COUNT() <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA007 update count mismatch'; END IF;
UPDATE aa_ability SET races=32768,drakkin_heritage=4 WHERE id=592;
IF ROW_COUNT() <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA007 update count mismatch'; END IF;
UPDATE aa_ability SET races=32768,drakkin_heritage=8 WHERE id=593;
IF ROW_COUNT() <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA007 update count mismatch'; END IF;
UPDATE aa_ability SET races=32768,drakkin_heritage=16 WHERE id=594;
IF ROW_COUNT() <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA007 update count mismatch'; END IF;
UPDATE aa_ability SET races=32768,drakkin_heritage=32 WHERE id=595;
IF ROW_COUNT() <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA007 update count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM aa_ability WHERE id BETWEEN 590 AND 595 FOR UPDATE;
IF actual_count <> 6 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA007 target count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM aa_ability WHERE (id=590 AND races=32768 AND drakkin_heritage=1) OR (id=591 AND races=32768 AND drakkin_heritage=2) OR (id=592 AND races=32768 AND drakkin_heritage=4) OR (id=593 AND races=32768 AND drakkin_heritage=8) OR (id=594 AND races=32768 AND drakkin_heritage=16) OR (id=595 AND races=32768 AND drakkin_heritage=32);
IF actual_count <> 6 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA007 field pre/postimage mismatch'; END IF;
COMMIT;
SELECT 'AA007_COMMITTED_EXACT_POSTIMAGES' AS result;
END//
DELIMITER ;
