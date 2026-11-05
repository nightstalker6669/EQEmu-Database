-- AA-021 PROPOSAL ONLY: Improved Burst of Life5 known native7769; explicit local encoding defaults.
-- No player ownership/points writes. MariaDB/InnoDB; stop on any mismatch.
DELIMITER //
BEGIN NOT ATOMIC
DECLARE actual_count INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
SELECT COUNT(*) INTO actual_count FROM `aa_ability` WHERE id=999 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-021 ability count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ability` WHERE (`id` <=> 999 AND `name` <=> CONVERT(0x496d70726f766564204275727374206f66204c696665 USING latin1) AND `category` <=> -1 AND `classes` <=> 2 AND `races` <=> 65535 AND `drakkin_heritage` <=> 127 AND `deities` <=> 131071 AND `status` <=> 0 AND `type` <=> 3 AND `charges` <=> 0 AND `grant_only` <=> 0 AND `first_rank_id` <=> 7765 AND `enabled` <=> 1 AND `reset_on_death` <=> 0 AND `auto_grant_enabled` <=> 1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-021 ability preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=7768 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-021 predecessor count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 7768 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 7765 AND `desc_sid` <=> 7765 AND `cost` <=> 12 AND `level_req` <=> 89 AND `spell` <=> 0 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 17 AND `prev_id` <=> 7767 AND `next_id` <=> 7769);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-021 predecessor preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=7768 FOR UPDATE;
IF actual_count <> 3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-021 predecessor effect count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 7768 AND `slot` <=> 1 AND `effect_id` <=> 392 AND `base1` <=> 4000 AND `base2` <=> 0) OR (`rank_id` <=> 7768 AND `slot` <=> 2 AND `effect_id` <=> 139 AND `base1` <=> 21820 AND `base2` <=> 0) OR (`rank_id` <=> 7768 AND `slot` <=> 3 AND `effect_id` <=> 411 AND `base1` <=> 4 AND `base2` <=> 0);
IF actual_count <> 3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-021 predecessor effect preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=7769 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-021 new identity collision aa_ranks'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=7769 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-021 new identity collision aa_rank_effects'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=7769 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-021 new identity collision aa_rank_prereqs'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=7768 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-021 predecessor prereq count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE (`rank_id` <=> 7768 AND `aa_id` <=> 7689 AND `points` <=> 1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-021 predecessor prereq preimage mismatch'; END IF;
INSERT INTO `aa_ranks` (`id`,`upper_hotkey_sid`,`lower_hotkey_sid`,`title_sid`,`desc_sid`,`cost`,`level_req`,`spell`,`spell_type`,`recast_time`,`expansion`,`prev_id`,`next_id`) VALUES
(7769,-1,-1,7765,7765,15,90,0,0,0,17,7768,-1);
INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(7769,1,392,5000,0),
(7769,2,139,21820,0),
(7769,3,411,4,0);
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 7769 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 7765 AND `desc_sid` <=> 7765 AND `cost` <=> 15 AND `level_req` <=> 90 AND `spell` <=> 0 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 17 AND `prev_id` <=> 7768 AND `next_id` <=> -1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-021 rank postimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=7769;
IF actual_count <> 3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-021 effect postimage count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 7769 AND `slot` <=> 1 AND `effect_id` <=> 392 AND `base1` <=> 5000 AND `base2` <=> 0) OR (`rank_id` <=> 7769 AND `slot` <=> 2 AND `effect_id` <=> 139 AND `base1` <=> 21820 AND `base2` <=> 0) OR (`rank_id` <=> 7769 AND `slot` <=> 3 AND `effect_id` <=> 411 AND `base1` <=> 4 AND `base2` <=> 0);
IF actual_count <> 3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-021 effect postimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=7769;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-021 unexpected new prereqs'; END IF;
COMMIT;
SELECT 'AA-021_COMMITTED_EXACT_POSTIMAGES' AS result;
END//
DELIMITER ;
