-- AA045 PROPOSAL ONLY: finite passive prefix; preserve native encoding and inherited prerequisites.
-- No existing AA or player writes. MariaDB/InnoDB; stop on mismatch.
DELIMITER //
BEGIN NOT ATOMIC
DECLARE actual_count INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=10716 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA045 rollback rank count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 10716 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 10714 AND `desc_sid` <=> 10714 AND `cost` <=> 15 AND `level_req` <=> 90 AND `spell` <=> 0 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 17 AND `prev_id` <=> 10715 AND `next_id` <=> -1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA045 rollback rank mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=10716 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA045 rollback effects count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 10716 AND `slot` <=> 1 AND `effect_id` <=> 264 AND `base1` <=> 270 AND `base2` <=> 873);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA045 rollback effects mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=10716 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA045 rollback unexpected prereqs'; END IF;
SELECT COUNT(*) INTO actual_count FROM `character_alternate_abilities` WHERE aa_id=10714 AND aa_value>=3 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA045 rollback refused newly reachable ownership exists'; END IF;
DELETE FROM aa_rank_effects WHERE rank_id=10716;
DELETE FROM aa_ranks WHERE id=10716;
COMMIT;
SELECT 'AA045_ROLLED_BACK_NEW_ROWS_ONLY' AS result;
END//
DELIMITER ;
