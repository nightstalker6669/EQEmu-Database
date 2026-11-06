-- AA047 PROPOSAL ONLY: finite passive prefix; preserve native encoding and inherited prerequisites.
-- No existing AA or player writes. MariaDB/InnoDB; stop on mismatch.
DELIMITER //
BEGIN NOT ATOMIC
DECLARE actual_count INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=14133 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA047 rollback rank count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 14133 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 7751 AND `desc_sid` <=> 7751 AND `cost` <=> 9 AND `level_req` <=> 93 AND `spell` <=> -1 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 18 AND `prev_id` <=> 14132 AND `next_id` <=> -1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA047 rollback rank mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=14133 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA047 rollback effects count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 14133 AND `slot` <=> 1 AND `effect_id` <=> 264 AND `base1` <=> 300 AND `base2` <=> 2234);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA047 rollback effects mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=14133 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA047 rollback unexpected prereqs'; END IF;
SELECT COUNT(*) INTO actual_count FROM `character_alternate_abilities` WHERE aa_id=7751 AND aa_value>=5 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA047 rollback refused newly reachable ownership exists'; END IF;
DELETE FROM aa_rank_effects WHERE rank_id=14133;
DELETE FROM aa_ranks WHERE id=14133;
COMMIT;
SELECT 'AA047_ROLLED_BACK_NEW_ROWS_ONLY' AS result;
END//
DELIMITER ;
