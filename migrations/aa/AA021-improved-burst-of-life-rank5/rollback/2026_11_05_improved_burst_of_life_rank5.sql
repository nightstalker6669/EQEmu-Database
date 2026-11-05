-- AA-021 PROPOSAL ONLY: Improved Burst of Life5 known native7769; explicit local encoding defaults.
-- No player ownership/points writes. MariaDB/InnoDB; stop on any mismatch.
DELIMITER //
BEGIN NOT ATOMIC
DECLARE actual_count INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=7769 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-021 rollback rank count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 7769 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 7765 AND `desc_sid` <=> 7765 AND `cost` <=> 15 AND `level_req` <=> 90 AND `spell` <=> 0 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 17 AND `prev_id` <=> 7768 AND `next_id` <=> -1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-021 rollback rank mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=7769 FOR UPDATE;
IF actual_count <> 3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-021 rollback effect count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 7769 AND `slot` <=> 1 AND `effect_id` <=> 392 AND `base1` <=> 5000 AND `base2` <=> 0) OR (`rank_id` <=> 7769 AND `slot` <=> 2 AND `effect_id` <=> 139 AND `base1` <=> 21820 AND `base2` <=> 0) OR (`rank_id` <=> 7769 AND `slot` <=> 3 AND `effect_id` <=> 411 AND `base1` <=> 4 AND `base2` <=> 0);
IF actual_count <> 3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-021 rollback effects mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=7769 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-021 rollback prereqs mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `character_alternate_abilities` WHERE aa_id=7765 AND aa_value>=5 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-021 rollback refused newly reachable ownership exists'; END IF;
DELETE FROM aa_rank_effects WHERE rank_id=7769;
DELETE FROM aa_ranks WHERE id=7769;
COMMIT;
SELECT 'AA-021_ROLLED_BACK_NEW_ROWS_ONLY' AS result;
END//
DELIMITER ;
