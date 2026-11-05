-- AA-018 PROPOSAL ONLY: Hastened Weapon Shield8 known native10771; explicit local encoding defaults.
-- No player ownership/points writes. MariaDB/InnoDB; stop on any mismatch.
DELIMITER //
BEGIN NOT ATOMIC
DECLARE actual_count INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=10771 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-018 rollback rank count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 10771 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 6751 AND `desc_sid` <=> 6751 AND `cost` <=> 9 AND `level_req` <=> 90 AND `spell` <=> -1 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 17 AND `prev_id` <=> 10770 AND `next_id` <=> -1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-018 rollback rank mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=10771 FOR UPDATE;
IF actual_count <> 2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-018 rollback effect count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 10771 AND `slot` <=> 1 AND `effect_id` <=> 310 AND `base1` <=> 1920000 AND `base2` <=> 0) OR (`rank_id` <=> 10771 AND `slot` <=> 2 AND `effect_id` <=> 139 AND `base1` <=> 4519 AND `base2` <=> 0);
IF actual_count <> 2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-018 rollback effects mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=10771 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-018 rollback prereqs mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `character_alternate_abilities` WHERE aa_id=6751 AND aa_value>=8 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-018 rollback refused newly reachable ownership exists'; END IF;
DELETE FROM aa_rank_effects WHERE rank_id=10771;
DELETE FROM aa_ranks WHERE id=10771;
COMMIT;
SELECT 'AA-018_ROLLED_BACK_NEW_ROWS_ONLY' AS result;
END//
DELIMITER ;
