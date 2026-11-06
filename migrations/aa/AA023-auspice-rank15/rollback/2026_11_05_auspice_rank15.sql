-- AA-023 PROPOSAL ONLY: Auspice15/native10742; period binding23554.
-- No player, existing AA or spell writes. MariaDB/InnoDB; abort on mismatch.
DELIMITER //
BEGIN NOT ATOMIC
DECLARE actual_count INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=10742 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-023 rollback rank count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 10742 AND `upper_hotkey_sid` <=> 1345 AND `lower_hotkey_sid` <=> 1345 AND `title_sid` <=> 1345 AND `desc_sid` <=> 1345 AND `cost` <=> 15 AND `level_req` <=> 90 AND `spell` <=> 23554 AND `spell_type` <=> 6 AND `recast_time` <=> 900 AND `expansion` <=> 17 AND `prev_id` <=> 10741 AND `next_id` <=> -1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-023 rollback rank mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=10742 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-023 rollback unexpected aa_rank_effects'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=10742 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-023 rollback unexpected aa_rank_prereqs'; END IF;
SELECT COUNT(*) INTO actual_count FROM `character_alternate_abilities` WHERE aa_id=1345 AND aa_value>=15 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-023 rollback refused newly reachable ownership exists'; END IF;
DELETE FROM aa_ranks WHERE id=10742;
COMMIT;
SELECT 'AA-023_ROLLED_BACK_NEW_ROW_ONLY' AS result;
END//
DELIMITER ;
