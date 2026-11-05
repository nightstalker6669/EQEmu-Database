-- AA-019 PROPOSAL ONLY: Hastened Trueshot8 known native14263; explicit local encoding defaults.
-- No player ownership/points writes. MariaDB/InnoDB; stop on any mismatch.
DELIMITER //
BEGIN NOT ATOMIC
DECLARE actual_count INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=14263 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-019 rollback rank count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 14263 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 6355 AND `desc_sid` <=> 6355 AND `cost` <=> 12 AND `level_req` <=> 95 AND `spell` <=> -1 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 18 AND `prev_id` <=> 14101 AND `next_id` <=> -1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-019 rollback rank mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=14263 FOR UPDATE;
IF actual_count <> 7 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-019 rollback effect count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 14263 AND `slot` <=> 1 AND `effect_id` <=> 310 AND `base1` <=> 2880000 AND `base2` <=> 0) OR (`rank_id` <=> 14263 AND `slot` <=> 2 AND `effect_id` <=> 139 AND `base1` <=> 4506 AND `base2` <=> 0) OR (`rank_id` <=> 14263 AND `slot` <=> 3 AND `effect_id` <=> 310 AND `base1` <=> 2880000 AND `base2` <=> 0) OR (`rank_id` <=> 14263 AND `slot` <=> 4 AND `effect_id` <=> 385 AND `base1` <=> 11122 AND `base2` <=> 0) OR (`rank_id` <=> 14263 AND `slot` <=> 5 AND `effect_id` <=> 385 AND `base1` <=> 11222 AND `base2` <=> 0) OR (`rank_id` <=> 14263 AND `slot` <=> 6 AND `effect_id` <=> 385 AND `base1` <=> 11322 AND `base2` <=> 0) OR (`rank_id` <=> 14263 AND `slot` <=> 7 AND `effect_id` <=> 385 AND `base1` <=> 11522 AND `base2` <=> 0);
IF actual_count <> 7 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-019 rollback effects mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=14263 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-019 rollback prereqs mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `character_alternate_abilities` WHERE aa_id=6355 AND aa_value>=8 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-019 rollback refused newly reachable ownership exists'; END IF;
DELETE FROM aa_rank_effects WHERE rank_id=14263;
DELETE FROM aa_ranks WHERE id=14263;
COMMIT;
SELECT 'AA-019_ROLLED_BACK_NEW_ROWS_ONLY' AS result;
END//
DELIMITER ;
