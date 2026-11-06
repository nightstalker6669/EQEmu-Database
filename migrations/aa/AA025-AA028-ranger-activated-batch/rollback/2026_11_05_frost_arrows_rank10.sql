-- AA-025 PROPOSAL ONLY: FrostArrows10/native13536; period binding30778.
-- No player, existing AA or spell writes. MariaDB/InnoDB; abort on mismatch.
DELIMITER //
BEGIN NOT ATOMIC
DECLARE actual_count INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=13536 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-025 rollback rank count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 13536 AND `upper_hotkey_sid` <=> 875 AND `lower_hotkey_sid` <=> 875 AND `title_sid` <=> 875 AND `desc_sid` <=> 875 AND `cost` <=> 11 AND `level_req` <=> 91 AND `spell` <=> 30778 AND `spell_type` <=> 5 AND `recast_time` <=> 180 AND `expansion` <=> 18 AND `prev_id` <=> 10777 AND `next_id` <=> -1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-025 rollback rank mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=13536 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-025 rollback unexpected effects'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=13536 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-025 rollback prereq count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE (`rank_id` <=> 13536 AND `aa_id` <=> 1685 AND `points` <=> 1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-025 rollback prereq mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `character_alternate_abilities` WHERE aa_id=875 AND aa_value>=10 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-025 rollback refused newly reachable ownership exists'; END IF;
DELETE FROM aa_rank_prereqs WHERE rank_id=13536 AND aa_id=1685 AND points=1;
DELETE FROM aa_ranks WHERE id=13536;
COMMIT;
SELECT 'AA-025_ROLLED_BACK_NEW_ROW_ONLY' AS result;
END//
DELIMITER ;
