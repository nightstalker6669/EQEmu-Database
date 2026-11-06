-- AA034 PROPOSAL ONLY. New AA rank only; no existing AA, spell or player writes.
-- MariaDB/InnoDB. One-use transaction; stop on any mismatch.
DELIMITER //
BEGIN NOT ATOMIC
DECLARE actual_count INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
SELECT COUNT(*) INTO actual_count FROM `aa_ability` WHERE id=452 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA034 ability count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ability` WHERE (`id` <=> 452 AND `name` <=> CONVERT(0x50726f6c6f6e676564204465737472756374696f6e USING latin1) AND `category` <=> -1 AND `classes` <=> 2048 AND `races` <=> 65535 AND `drakkin_heritage` <=> 127 AND `deities` <=> 131071 AND `status` <=> 0 AND `type` <=> 3 AND `charges` <=> 0 AND `grant_only` <=> 0 AND `first_rank_id` <=> 1337 AND `enabled` <=> 1 AND `reset_on_death` <=> 0 AND `auto_grant_enabled` <=> 1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA034 ability preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=14338 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA034 predecessor count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 14338 AND `upper_hotkey_sid` <=> 1337 AND `lower_hotkey_sid` <=> 1337 AND `title_sid` <=> 1337 AND `desc_sid` <=> 1337 AND `cost` <=> 12 AND `level_req` <=> 91 AND `spell` <=> 32382 AND `spell_type` <=> 13 AND `recast_time` <=> 4320 AND `expansion` <=> 18 AND `prev_id` <=> 6160 AND `next_id` <=> 14339);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA034 predecessor preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=14338 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA034 unexpected predecessor effects'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=14338 FOR UPDATE;
IF actual_count <> 2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA034 predecessor prereq count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE (`rank_id` <=> 14338 AND `aa_id` <=> 308 AND `points` <=> 3) OR (`rank_id` <=> 14338 AND `aa_id` <=> 1685 AND `points` <=> 1);
IF actual_count <> 2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA034 predecessor prereq preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=14339 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA034 target identity collision aa_ranks'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=14339 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA034 target identity collision aa_rank_effects'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=14339 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA034 target identity collision aa_rank_prereqs'; END IF;
SELECT COUNT(*) INTO actual_count FROM `spells_new` WHERE id=32383 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA034 bound spell missing'; END IF;
SELECT COUNT(*) INTO actual_count FROM `spells_new` WHERE (`id` <=> 32383 AND `name` <=> CONVERT(0x50726f6c6f6e676564204465737472756374696f6e USING latin1));
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA034 bound spell identity mismatch'; END IF;
INSERT INTO `aa_ranks` (`id`,`upper_hotkey_sid`,`lower_hotkey_sid`,`title_sid`,`desc_sid`,`cost`,`level_req`,`spell`,`spell_type`,`recast_time`,`expansion`,`prev_id`,`next_id`) VALUES
(14339,1337,1337,1337,1337,15,93,32383,13,4320,18,14338,-1);
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 14339 AND `upper_hotkey_sid` <=> 1337 AND `lower_hotkey_sid` <=> 1337 AND `title_sid` <=> 1337 AND `desc_sid` <=> 1337 AND `cost` <=> 15 AND `level_req` <=> 93 AND `spell` <=> 32383 AND `spell_type` <=> 13 AND `recast_time` <=> 4320 AND `expansion` <=> 18 AND `prev_id` <=> 14338 AND `next_id` <=> -1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA034 rank postimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=14339;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA034 unexpected postimage aa_rank_effects'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=14339;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA034 unexpected postimage aa_rank_prereqs'; END IF;
COMMIT;
SELECT 'AA034_COMMITTED_EXACT_POSTIMAGE' AS result;
END//
DELIMITER ;
