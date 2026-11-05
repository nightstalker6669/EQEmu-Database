-- AA-017 PROPOSAL ONLY: Twinheal5 known native13412; explicit local encoding defaults.
-- No player ownership/points writes. MariaDB/InnoDB; stop on any mismatch.
DELIMITER //
BEGIN NOT ATOMIC
DECLARE actual_count INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
SELECT COUNT(*) INTO actual_count FROM `aa_ability` WHERE id=385 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-017 ability count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ability` WHERE (`id` <=> 385 AND `name` <=> CONVERT(0x5477696e6865616c USING latin1) AND `category` <=> -1 AND `classes` <=> 16942 AND `races` <=> 65535 AND `drakkin_heritage` <=> 127 AND `deities` <=> 131071 AND `status` <=> 0 AND `type` <=> 2 AND `charges` <=> 0 AND `grant_only` <=> 0 AND `first_rank_id` <=> 12652 AND `enabled` <=> 1 AND `reset_on_death` <=> 0 AND `auto_grant_enabled` <=> 1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-017 ability preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=13411 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-017 predecessor count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 13411 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 12652 AND `desc_sid` <=> 12652 AND `cost` <=> 15 AND `level_req` <=> 92 AND `spell` <=> 0 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 18 AND `prev_id` <=> 12654 AND `next_id` <=> 13412);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-017 predecessor preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=13411 FOR UPDATE;
IF actual_count <> 8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-017 predecessor effect count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 13411 AND `slot` <=> 1 AND `effect_id` <=> 399 AND `base1` <=> 4 AND `base2` <=> 0) OR (`rank_id` <=> 13411 AND `slot` <=> 2 AND `effect_id` <=> 138 AND `base1` <=> 1 AND `base2` <=> 0) OR (`rank_id` <=> 13411 AND `slot` <=> 3 AND `effect_id` <=> 137 AND `base1` <=> 0 AND `base2` <=> 0) OR (`rank_id` <=> 13411 AND `slot` <=> 4 AND `effect_id` <=> 348 AND `base1` <=> 10 AND `base2` <=> 0) OR (`rank_id` <=> 13411 AND `slot` <=> 5 AND `effect_id` <=> 311 AND `base1` <=> 0 AND `base2` <=> 0) OR (`rank_id` <=> 13411 AND `slot` <=> 6 AND `effect_id` <=> 141 AND `base1` <=> 1 AND `base2` <=> 0) OR (`rank_id` <=> 13411 AND `slot` <=> 7 AND `effect_id` <=> 134 AND `base1` <=> 254 AND `base2` <=> 0) OR (`rank_id` <=> 13411 AND `slot` <=> 8 AND `effect_id` <=> 137 AND `base1` <=> -39 AND `base2` <=> 0);
IF actual_count <> 8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-017 predecessor effect preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=13412 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-017 new identity collision aa_ranks'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=13412 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-017 new identity collision aa_rank_effects'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=13412 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-017 new identity collision aa_rank_prereqs'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=13411 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-017 predecessor prereqs mismatch'; END IF;
INSERT INTO `aa_ranks` (`id`,`upper_hotkey_sid`,`lower_hotkey_sid`,`title_sid`,`desc_sid`,`cost`,`level_req`,`spell`,`spell_type`,`recast_time`,`expansion`,`prev_id`,`next_id`) VALUES
(13412,-1,-1,12652,12652,18,95,0,0,0,18,13411,-1);
INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(13412,1,399,5,0),
(13412,2,138,1,0),
(13412,3,137,0,0),
(13412,4,348,10,0),
(13412,5,311,0,0),
(13412,6,141,1,0),
(13412,7,134,254,0),
(13412,8,137,-39,0);
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 13412 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 12652 AND `desc_sid` <=> 12652 AND `cost` <=> 18 AND `level_req` <=> 95 AND `spell` <=> 0 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 18 AND `prev_id` <=> 13411 AND `next_id` <=> -1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-017 rank postimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=13412;
IF actual_count <> 8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-017 effect postimage count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 13412 AND `slot` <=> 1 AND `effect_id` <=> 399 AND `base1` <=> 5 AND `base2` <=> 0) OR (`rank_id` <=> 13412 AND `slot` <=> 2 AND `effect_id` <=> 138 AND `base1` <=> 1 AND `base2` <=> 0) OR (`rank_id` <=> 13412 AND `slot` <=> 3 AND `effect_id` <=> 137 AND `base1` <=> 0 AND `base2` <=> 0) OR (`rank_id` <=> 13412 AND `slot` <=> 4 AND `effect_id` <=> 348 AND `base1` <=> 10 AND `base2` <=> 0) OR (`rank_id` <=> 13412 AND `slot` <=> 5 AND `effect_id` <=> 311 AND `base1` <=> 0 AND `base2` <=> 0) OR (`rank_id` <=> 13412 AND `slot` <=> 6 AND `effect_id` <=> 141 AND `base1` <=> 1 AND `base2` <=> 0) OR (`rank_id` <=> 13412 AND `slot` <=> 7 AND `effect_id` <=> 134 AND `base1` <=> 254 AND `base2` <=> 0) OR (`rank_id` <=> 13412 AND `slot` <=> 8 AND `effect_id` <=> 137 AND `base1` <=> -39 AND `base2` <=> 0);
IF actual_count <> 8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-017 effect postimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=13412;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-017 unexpected new prereqs'; END IF;
COMMIT;
SELECT 'AA-017_COMMITTED_EXACT_POSTIMAGES' AS result;
END//
DELIMITER ;
