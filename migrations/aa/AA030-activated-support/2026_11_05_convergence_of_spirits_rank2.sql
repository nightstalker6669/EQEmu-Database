-- AA030 PROPOSAL ONLY. New AA rank only; no existing AA, spell or player writes.
-- MariaDB/InnoDB. One-use transaction; stop on any mismatch.
DELIMITER //
BEGIN NOT ATOMIC
DECLARE actual_count INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
SELECT COUNT(*) INTO actual_count FROM `aa_ability` WHERE id=455 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA030 ability count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ability` WHERE (`id` <=> 455 AND `name` <=> CONVERT(0x436f6e76657267656e6365206f662053706972697473 USING latin1) AND `category` <=> -1 AND `classes` <=> 8 AND `races` <=> 65535 AND `drakkin_heritage` <=> 127 AND `deities` <=> 131071 AND `status` <=> 0 AND `type` <=> 3 AND `charges` <=> 0 AND `grant_only` <=> 0 AND `first_rank_id` <=> 13556 AND `enabled` <=> 1 AND `reset_on_death` <=> 0 AND `auto_grant_enabled` <=> 1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA030 ability preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=13556 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA030 predecessor count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 13556 AND `upper_hotkey_sid` <=> 13556 AND `lower_hotkey_sid` <=> 13556 AND `title_sid` <=> 13556 AND `desc_sid` <=> 13556 AND `cost` <=> 9 AND `level_req` <=> 91 AND `spell` <=> 30792 AND `spell_type` <=> 44 AND `recast_time` <=> 600 AND `expansion` <=> 18 AND `prev_id` <=> -1 AND `next_id` <=> 13557);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA030 predecessor preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=13556 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA030 unexpected predecessor effects'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=13556 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA030 predecessor prereq count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE (`rank_id` <=> 13556 AND `aa_id` <=> 1685 AND `points` <=> 1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA030 predecessor prereq preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=13557 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA030 target identity collision aa_ranks'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=13557 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA030 target identity collision aa_rank_effects'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=13557 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA030 target identity collision aa_rank_prereqs'; END IF;
SELECT COUNT(*) INTO actual_count FROM `spells_new` WHERE id=30793 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA030 bound spell missing'; END IF;
SELECT COUNT(*) INTO actual_count FROM `spells_new` WHERE (`id` <=> 30793 AND `name` <=> CONVERT(0x436f6e76657267656e6365206f662053706972697473 USING latin1));
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA030 bound spell identity mismatch'; END IF;
INSERT INTO `aa_ranks` (`id`,`upper_hotkey_sid`,`lower_hotkey_sid`,`title_sid`,`desc_sid`,`cost`,`level_req`,`spell`,`spell_type`,`recast_time`,`expansion`,`prev_id`,`next_id`) VALUES
(13557,13556,13556,13556,13556,12,92,30793,44,600,18,13556,-1);
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 13557 AND `upper_hotkey_sid` <=> 13556 AND `lower_hotkey_sid` <=> 13556 AND `title_sid` <=> 13556 AND `desc_sid` <=> 13556 AND `cost` <=> 12 AND `level_req` <=> 92 AND `spell` <=> 30793 AND `spell_type` <=> 44 AND `recast_time` <=> 600 AND `expansion` <=> 18 AND `prev_id` <=> 13556 AND `next_id` <=> -1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA030 rank postimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=13557;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA030 unexpected postimage aa_rank_effects'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=13557;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA030 unexpected postimage aa_rank_prereqs'; END IF;
COMMIT;
SELECT 'AA030_COMMITTED_EXACT_POSTIMAGE' AS result;
END//
DELIMITER ;
