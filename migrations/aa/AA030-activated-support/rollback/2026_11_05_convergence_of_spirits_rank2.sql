-- AA030 PROPOSAL ONLY. New AA rank only; no existing AA, spell or player writes.
-- MariaDB/InnoDB. One-use transaction; stop on any mismatch.
DELIMITER //
BEGIN NOT ATOMIC
DECLARE actual_count INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=13557 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA030 rollback rank count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 13557 AND `upper_hotkey_sid` <=> 13556 AND `lower_hotkey_sid` <=> 13556 AND `title_sid` <=> 13556 AND `desc_sid` <=> 13556 AND `cost` <=> 12 AND `level_req` <=> 92 AND `spell` <=> 30793 AND `spell_type` <=> 44 AND `recast_time` <=> 600 AND `expansion` <=> 18 AND `prev_id` <=> 13556 AND `next_id` <=> -1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA030 rollback rank mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=13557 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA030 rollback unexpected aa_rank_effects'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=13557 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA030 rollback unexpected aa_rank_prereqs'; END IF;
SELECT COUNT(*) INTO actual_count FROM `character_alternate_abilities` WHERE aa_id=13556 AND aa_value>=2 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA030 rollback refused newly reachable ownership exists'; END IF;
DELETE FROM aa_ranks WHERE id=13557;
COMMIT;
SELECT 'AA030_ROLLED_BACK_NEW_ROW_ONLY' AS result;
END//
DELIMITER ;
