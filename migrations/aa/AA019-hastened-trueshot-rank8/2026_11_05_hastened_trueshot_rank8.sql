-- AA-019 PROPOSAL ONLY: Hastened Trueshot8 known native14263; explicit local encoding defaults.
-- No player ownership/points writes. MariaDB/InnoDB; stop on any mismatch.
DELIMITER //
BEGIN NOT ATOMIC
DECLARE actual_count INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
SELECT COUNT(*) INTO actual_count FROM `aa_ability` WHERE id=3803 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-019 ability count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ability` WHERE (`id` <=> 3803 AND `name` <=> CONVERT(0x48617374656e6564205472756573686f74 USING latin1) AND `category` <=> -1 AND `classes` <=> 8 AND `races` <=> 65535 AND `drakkin_heritage` <=> 127 AND `deities` <=> 131071 AND `status` <=> 0 AND `type` <=> 3 AND `charges` <=> 0 AND `grant_only` <=> 0 AND `first_rank_id` <=> 6355 AND `enabled` <=> 1 AND `reset_on_death` <=> 0 AND `auto_grant_enabled` <=> 1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-019 ability preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=14101 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-019 predecessor count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 14101 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 6355 AND `desc_sid` <=> 6355 AND `cost` <=> 9 AND `level_req` <=> 91 AND `spell` <=> -1 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 18 AND `prev_id` <=> 6360 AND `next_id` <=> 14263);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-019 predecessor preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=14101 FOR UPDATE;
IF actual_count <> 7 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-019 predecessor effect count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 14101 AND `slot` <=> 1 AND `effect_id` <=> 310 AND `base1` <=> 2520000 AND `base2` <=> 0) OR (`rank_id` <=> 14101 AND `slot` <=> 2 AND `effect_id` <=> 139 AND `base1` <=> 4506 AND `base2` <=> 0) OR (`rank_id` <=> 14101 AND `slot` <=> 3 AND `effect_id` <=> 310 AND `base1` <=> 2520000 AND `base2` <=> 0) OR (`rank_id` <=> 14101 AND `slot` <=> 4 AND `effect_id` <=> 385 AND `base1` <=> 11122 AND `base2` <=> 0) OR (`rank_id` <=> 14101 AND `slot` <=> 5 AND `effect_id` <=> 385 AND `base1` <=> 11222 AND `base2` <=> 0) OR (`rank_id` <=> 14101 AND `slot` <=> 6 AND `effect_id` <=> 385 AND `base1` <=> 11322 AND `base2` <=> 0) OR (`rank_id` <=> 14101 AND `slot` <=> 7 AND `effect_id` <=> 385 AND `base1` <=> 11522 AND `base2` <=> 0);
IF actual_count <> 7 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-019 predecessor effect preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=14263 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-019 new identity collision aa_ranks'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=14263 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-019 new identity collision aa_rank_effects'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=14263 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-019 new identity collision aa_rank_prereqs'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=14101 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-019 predecessor prereq count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE (`rank_id` <=> 14101 AND `aa_id` <=> 1685 AND `points` <=> 1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-019 predecessor prereq preimage mismatch'; END IF;
INSERT INTO `aa_ranks` (`id`,`upper_hotkey_sid`,`lower_hotkey_sid`,`title_sid`,`desc_sid`,`cost`,`level_req`,`spell`,`spell_type`,`recast_time`,`expansion`,`prev_id`,`next_id`) VALUES
(14263,-1,-1,6355,6355,12,95,-1,0,0,18,14101,-1);
INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(14263,1,310,2880000,0),
(14263,2,139,4506,0),
(14263,3,310,2880000,0),
(14263,4,385,11122,0),
(14263,5,385,11222,0),
(14263,6,385,11322,0),
(14263,7,385,11522,0);
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 14263 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 6355 AND `desc_sid` <=> 6355 AND `cost` <=> 12 AND `level_req` <=> 95 AND `spell` <=> -1 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 18 AND `prev_id` <=> 14101 AND `next_id` <=> -1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-019 rank postimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=14263;
IF actual_count <> 7 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-019 effect postimage count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 14263 AND `slot` <=> 1 AND `effect_id` <=> 310 AND `base1` <=> 2880000 AND `base2` <=> 0) OR (`rank_id` <=> 14263 AND `slot` <=> 2 AND `effect_id` <=> 139 AND `base1` <=> 4506 AND `base2` <=> 0) OR (`rank_id` <=> 14263 AND `slot` <=> 3 AND `effect_id` <=> 310 AND `base1` <=> 2880000 AND `base2` <=> 0) OR (`rank_id` <=> 14263 AND `slot` <=> 4 AND `effect_id` <=> 385 AND `base1` <=> 11122 AND `base2` <=> 0) OR (`rank_id` <=> 14263 AND `slot` <=> 5 AND `effect_id` <=> 385 AND `base1` <=> 11222 AND `base2` <=> 0) OR (`rank_id` <=> 14263 AND `slot` <=> 6 AND `effect_id` <=> 385 AND `base1` <=> 11322 AND `base2` <=> 0) OR (`rank_id` <=> 14263 AND `slot` <=> 7 AND `effect_id` <=> 385 AND `base1` <=> 11522 AND `base2` <=> 0);
IF actual_count <> 7 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-019 effect postimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=14263;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-019 unexpected new prereqs'; END IF;
COMMIT;
SELECT 'AA-019_COMMITTED_EXACT_POSTIMAGES' AS result;
END//
DELIMITER ;
