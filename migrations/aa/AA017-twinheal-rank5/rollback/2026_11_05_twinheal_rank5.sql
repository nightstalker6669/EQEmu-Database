-- AA-017 PROPOSAL ONLY: Twinheal5 known native13412; explicit local encoding defaults.
-- No player ownership/points writes. MariaDB/InnoDB; stop on any mismatch.
DELIMITER //
BEGIN NOT ATOMIC
DECLARE actual_count INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=13412 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-017 rollback rank count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 13412 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 12652 AND `desc_sid` <=> 12652 AND `cost` <=> 18 AND `level_req` <=> 95 AND `spell` <=> 0 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 18 AND `prev_id` <=> 13411 AND `next_id` <=> -1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-017 rollback rank mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=13412 FOR UPDATE;
IF actual_count <> 8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-017 rollback effect count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 13412 AND `slot` <=> 1 AND `effect_id` <=> 399 AND `base1` <=> 5 AND `base2` <=> 0) OR (`rank_id` <=> 13412 AND `slot` <=> 2 AND `effect_id` <=> 138 AND `base1` <=> 1 AND `base2` <=> 0) OR (`rank_id` <=> 13412 AND `slot` <=> 3 AND `effect_id` <=> 137 AND `base1` <=> 0 AND `base2` <=> 0) OR (`rank_id` <=> 13412 AND `slot` <=> 4 AND `effect_id` <=> 348 AND `base1` <=> 10 AND `base2` <=> 0) OR (`rank_id` <=> 13412 AND `slot` <=> 5 AND `effect_id` <=> 311 AND `base1` <=> 0 AND `base2` <=> 0) OR (`rank_id` <=> 13412 AND `slot` <=> 6 AND `effect_id` <=> 141 AND `base1` <=> 1 AND `base2` <=> 0) OR (`rank_id` <=> 13412 AND `slot` <=> 7 AND `effect_id` <=> 134 AND `base1` <=> 254 AND `base2` <=> 0) OR (`rank_id` <=> 13412 AND `slot` <=> 8 AND `effect_id` <=> 137 AND `base1` <=> -39 AND `base2` <=> 0);
IF actual_count <> 8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-017 rollback effects mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=13412 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-017 rollback prereqs mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `character_alternate_abilities` WHERE aa_id=12652 AND aa_value>=5 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-017 rollback refused newly reachable ownership exists'; END IF;
DELETE FROM aa_rank_effects WHERE rank_id=13412;
DELETE FROM aa_ranks WHERE id=13412;
COMMIT;
SELECT 'AA-017_ROLLED_BACK_NEW_ROWS_ONLY' AS result;
END//
DELIMITER ;
