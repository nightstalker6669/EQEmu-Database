-- AA-024 PROPOSAL ONLY: Guardian19/native10761; period binding23641.
-- No player, existing AA or spell writes. MariaDB/InnoDB; abort on mismatch.
DELIMITER //
BEGIN NOT ATOMIC
DECLARE actual_count INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=10761 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-024 rollback rank count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 10761 AND `upper_hotkey_sid` <=> 545 AND `lower_hotkey_sid` <=> 545 AND `title_sid` <=> 545 AND `desc_sid` <=> 545 AND `cost` <=> 12 AND `level_req` <=> 89 AND `spell` <=> 23641 AND `spell_type` <=> 3 AND `recast_time` <=> 900 AND `expansion` <=> 17 AND `prev_id` <=> 10760 AND `next_id` <=> -1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-024 rollback rank mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=10761 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-024 rollback unexpected aa_rank_effects'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=10761 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-024 rollback unexpected aa_rank_prereqs'; END IF;
SELECT COUNT(*) INTO actual_count FROM `character_alternate_abilities` WHERE aa_id=545 AND aa_value>=19 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-024 rollback refused newly reachable ownership exists'; END IF;
DELETE FROM aa_ranks WHERE id=10761;
COMMIT;
SELECT 'AA-024_ROLLED_BACK_NEW_ROW_ONLY' AS result;
END//
DELIMITER ;
