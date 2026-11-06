-- AA038 PROPOSAL ONLY: finite Twinproc prefix; preserve existing eligibility and focus limits.
-- No existing AA or player writes. MariaDB/InnoDB; stop on mismatch.
DELIMITER //
BEGIN NOT ATOMIC
DECLARE actual_count INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=13414 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA038 rollback rank count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 13414 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 12416 AND `desc_sid` <=> 12416 AND `cost` <=> 18 AND `level_req` <=> 95 AND `spell` <=> -1 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 18 AND `prev_id` <=> 13413 AND `next_id` <=> -1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA038 rollback rank mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=13414 FOR UPDATE;
IF actual_count <> 9 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA038 rollback effects count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 13414 AND `slot` <=> 1 AND `effect_id` <=> 399 AND `base1` <=> 15 AND `base2` <=> 0) OR (`rank_id` <=> 13414 AND `slot` <=> 2 AND `effect_id` <=> 141 AND `base1` <=> 1 AND `base2` <=> 0) OR (`rank_id` <=> 13414 AND `slot` <=> 3 AND `effect_id` <=> 138 AND `base1` <=> 0 AND `base2` <=> 0) OR (`rank_id` <=> 13414 AND `slot` <=> 4 AND `effect_id` <=> 142 AND `base1` <=> 255 AND `base2` <=> 0) OR (`rank_id` <=> 13414 AND `slot` <=> 5 AND `effect_id` <=> 391 AND `base1` <=> 0 AND `base2` <=> 0) OR (`rank_id` <=> 13414 AND `slot` <=> 6 AND `effect_id` <=> 311 AND `base1` <=> 0 AND `base2` <=> 0) OR (`rank_id` <=> 13414 AND `slot` <=> 7 AND `effect_id` <=> 137 AND `base1` <=> -152 AND `base2` <=> 0) OR (`rank_id` <=> 13414 AND `slot` <=> 8 AND `effect_id` <=> 411 AND `base1` <=> 100350 AND `base2` <=> 0) OR (`rank_id` <=> 13414 AND `slot` <=> 9 AND `effect_id` <=> 137 AND `base1` <=> -39 AND `base2` <=> 0);
IF actual_count <> 9 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA038 rollback effects mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=13414 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA038 rollback unexpected prereqs'; END IF;
SELECT COUNT(*) INTO actual_count FROM `character_alternate_abilities` WHERE aa_id=12416 AND aa_value>=5 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA038 rollback refused newly reachable ownership exists'; END IF;
DELETE FROM aa_rank_effects WHERE rank_id=13414;
DELETE FROM aa_ranks WHERE id=13414;
COMMIT;
SELECT 'AA038_ROLLED_BACK_NEW_ROWS_ONLY' AS result;
END//
DELIMITER ;
