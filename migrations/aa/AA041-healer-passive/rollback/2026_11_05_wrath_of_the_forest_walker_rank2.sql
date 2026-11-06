-- AA041 PROPOSAL ONLY: qualified period-note Wrath prefix; magnitude200 is explicit reconstruction.
-- No existing AA or player writes. MariaDB/InnoDB; stop on mismatch.
DELIMITER //
BEGIN NOT ATOMIC
DECLARE actual_count INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=14245 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA041 rollback rank count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 14245 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 14244 AND `desc_sid` <=> 14244 AND `cost` <=> 11 AND `level_req` <=> 92 AND `spell` <=> -1 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 18 AND `prev_id` <=> 14244 AND `next_id` <=> -1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA041 rollback rank mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=14245 FOR UPDATE;
IF actual_count <> 5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA041 rollback effects count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 14245 AND `slot` <=> 1 AND `effect_id` <=> 286 AND `base1` <=> 200 AND `base2` <=> 0) OR (`rank_id` <=> 14245 AND `slot` <=> 2 AND `effect_id` <=> 138 AND `base1` <=> 0 AND `base2` <=> 0) OR (`rank_id` <=> 14245 AND `slot` <=> 3 AND `effect_id` <=> 143 AND `base1` <=> 1 AND `base2` <=> 0) OR (`rank_id` <=> 14245 AND `slot` <=> 4 AND `effect_id` <=> 348 AND `base1` <=> 1 AND `base2` <=> 0) OR (`rank_id` <=> 14245 AND `slot` <=> 5 AND `effect_id` <=> 411 AND `base1` <=> 64 AND `base2` <=> 0);
IF actual_count <> 5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA041 rollback effects mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=14245 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA041 rollback unexpected prereqs'; END IF;
SELECT COUNT(*) INTO actual_count FROM `character_alternate_abilities` WHERE aa_id=14244 AND aa_value>=2 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA041 rollback refused newly reachable ownership exists'; END IF;
DELETE FROM aa_rank_effects WHERE rank_id=14245;
DELETE FROM aa_ranks WHERE id=14245;
COMMIT;
SELECT 'AA041_ROLLED_BACK_NEW_ROWS_ONLY' AS result;
END//
DELIMITER ;
