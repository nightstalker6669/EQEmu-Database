-- AA047 PROPOSAL ONLY: finite passive prefix; preserve native encoding and inherited prerequisites.
-- No existing AA or player writes. MariaDB/InnoDB; stop on mismatch.
DELIMITER //
BEGIN NOT ATOMIC
DECLARE actual_count INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
SELECT COUNT(*) INTO actual_count FROM `aa_ability` WHERE id=7751 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA047 ability count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ability` WHERE (`id` <=> 7751 AND `name` <=> CONVERT(0x48617374656e656420436f76657220547261636b73 USING latin1) AND `category` <=> -1 AND `classes` <=> 8 AND `races` <=> 65535 AND `drakkin_heritage` <=> 127 AND `deities` <=> 131071 AND `status` <=> 0 AND `type` <=> 3 AND `charges` <=> 0 AND `grant_only` <=> 0 AND `first_rank_id` <=> 7751 AND `enabled` <=> 1 AND `reset_on_death` <=> 0 AND `auto_grant_enabled` <=> 1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA047 ability preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=14132 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA047 predecessor count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 14132 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 7751 AND `desc_sid` <=> 7751 AND `cost` <=> 7 AND `level_req` <=> 91 AND `spell` <=> -1 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 18 AND `prev_id` <=> 7753 AND `next_id` <=> 14133);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA047 predecessor preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=14132 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA047 predecessor effects count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 14132 AND `slot` <=> 1 AND `effect_id` <=> 264 AND `base1` <=> 240 AND `base2` <=> 2234);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA047 predecessor effects mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=14132 FOR UPDATE;
IF actual_count <> 2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA047 predecessor prereqs count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE (`rank_id` <=> 14132 AND `aa_id` <=> 1685 AND `points` <=> 1) OR (`rank_id` <=> 14132 AND `aa_id` <=> 2234 AND `points` <=> 1);
IF actual_count <> 2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA047 predecessor prereqs mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=14133 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA047 target identity collision aa_ranks'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=14133 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA047 target identity collision aa_rank_effects'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=14133 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA047 target identity collision aa_rank_prereqs'; END IF;
INSERT INTO `aa_ranks` (`id`,`upper_hotkey_sid`,`lower_hotkey_sid`,`title_sid`,`desc_sid`,`cost`,`level_req`,`spell`,`spell_type`,`recast_time`,`expansion`,`prev_id`,`next_id`) VALUES
(14133,-1,-1,7751,7751,9,93,-1,0,0,18,14132,-1);
INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(14133,1,264,300,2234);
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 14133 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 7751 AND `desc_sid` <=> 7751 AND `cost` <=> 9 AND `level_req` <=> 93 AND `spell` <=> -1 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 18 AND `prev_id` <=> 14132 AND `next_id` <=> -1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA047 rank postimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=14133 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA047 effect postimages count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 14133 AND `slot` <=> 1 AND `effect_id` <=> 264 AND `base1` <=> 300 AND `base2` <=> 2234);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA047 effect postimages mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=14133;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA047 unexpected new prereqs'; END IF;
COMMIT;
SELECT 'AA047_COMMITTED_EXACT_POSTIMAGES' AS result;
END//
DELIMITER ;
