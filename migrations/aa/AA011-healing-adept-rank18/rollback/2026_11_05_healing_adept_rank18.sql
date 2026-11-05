-- AA-011 PROPOSAL ONLY: Healing Adept18 known native13298; explicit local encoding defaults.
-- No player ownership/points writes. MariaDB/InnoDB; stop on any mismatch.
DELIMITER //
BEGIN NOT ATOMIC
DECLARE actual_count INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=13298 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-011 rollback rank count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 13298 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 77 AND `desc_sid` <=> 77 AND `cost` <=> 12 AND `level_req` <=> 95 AND `spell` <=> -1 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 18 AND `prev_id` <=> 13297 AND `next_id` <=> -1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-011 rollback rank mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=13298 FOR UPDATE;
IF actual_count <> 8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-011 rollback effect count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 13298 AND `slot` <=> 1 AND `effect_id` <=> 125 AND `base1` <=> 55 AND `base2` <=> 55) OR (`rank_id` <=> 13298 AND `slot` <=> 2 AND `effect_id` <=> 137 AND `base1` <=> 0 AND `base2` <=> 0) OR (`rank_id` <=> 13298 AND `slot` <=> 3 AND `effect_id` <=> 141 AND `base1` <=> 1 AND `base2` <=> 0) OR (`rank_id` <=> 13298 AND `slot` <=> 4 AND `effect_id` <=> 139 AND `base1` <=> -6233 AND `base2` <=> 0) OR (`rank_id` <=> 13298 AND `slot` <=> 5 AND `effect_id` <=> 139 AND `base1` <=> -6265 AND `base2` <=> 0) OR (`rank_id` <=> 13298 AND `slot` <=> 6 AND `effect_id` <=> 125 AND `base1` <=> 55 AND `base2` <=> 55) OR (`rank_id` <=> 13298 AND `slot` <=> 7 AND `effect_id` <=> 137 AND `base1` <=> 147 AND `base2` <=> 0) OR (`rank_id` <=> 13298 AND `slot` <=> 8 AND `effect_id` <=> 141 AND `base1` <=> 1 AND `base2` <=> 0);
IF actual_count <> 8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-011 rollback effects mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=13298 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-011 rollback prereqs mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `character_alternate_abilities` WHERE aa_id=77 AND aa_value>=18 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-011 rollback refused newly reachable ownership exists'; END IF;
DELETE FROM aa_rank_effects WHERE rank_id=13298;
DELETE FROM aa_ranks WHERE id=13298;
COMMIT;
SELECT 'AA-011_ROLLED_BACK_NEW_ROWS_ONLY' AS result;
END//
DELIMITER ;
