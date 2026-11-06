-- AA032 PROPOSAL ONLY. New AA rank only; no existing AA, spell or player writes.
-- MariaDB/InnoDB. One-use transaction; stop on any mismatch.
DELIMITER //
BEGIN NOT ATOMIC
DECLARE actual_count INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=13491 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA032 rollback rank count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 13491 AND `upper_hotkey_sid` <=> 5020 AND `lower_hotkey_sid` <=> 5020 AND `title_sid` <=> 5020 AND `desc_sid` <=> 5020 AND `cost` <=> 12 AND `level_req` <=> 95 AND `spell` <=> 30743 AND `spell_type` <=> 9 AND `recast_time` <=> 300 AND `expansion` <=> 18 AND `prev_id` <=> 13490 AND `next_id` <=> -1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA032 rollback rank mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=13491 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA032 rollback unexpected aa_rank_effects'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=13491 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA032 rollback unexpected aa_rank_prereqs'; END IF;
SELECT COUNT(*) INTO actual_count FROM `character_alternate_abilities` WHERE aa_id=5020 AND aa_value>=6 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA032 rollback refused newly reachable ownership exists'; END IF;
DELETE FROM aa_ranks WHERE id=13491;
COMMIT;
SELECT 'AA032_ROLLED_BACK_NEW_ROW_ONLY' AS result;
END//
DELIMITER ;
