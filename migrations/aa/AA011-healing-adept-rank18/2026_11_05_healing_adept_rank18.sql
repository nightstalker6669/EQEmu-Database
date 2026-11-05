-- AA-011 PROPOSAL ONLY: Healing Adept18 known native13298; explicit local encoding defaults.
-- No player ownership/points writes. MariaDB/InnoDB; stop on any mismatch.
DELIMITER //
BEGIN NOT ATOMIC
DECLARE actual_count INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
SELECT COUNT(*) INTO actual_count FROM `aa_ability` WHERE id=18 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-011 ability count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ability` WHERE (`id` <=> 18 AND `name` <=> CONVERT(0x4865616c696e67204164657074 USING latin1) AND `category` <=> -1 AND `classes` <=> 16942 AND `races` <=> 65535 AND `drakkin_heritage` <=> 127 AND `deities` <=> 131071 AND `status` <=> 0 AND `type` <=> 2 AND `charges` <=> 0 AND `grant_only` <=> 0 AND `first_rank_id` <=> 77 AND `enabled` <=> 1 AND `reset_on_death` <=> 0 AND `auto_grant_enabled` <=> 1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-011 ability preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=13297 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-011 predecessor count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 13297 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 77 AND `desc_sid` <=> 77 AND `cost` <=> 12 AND `level_req` <=> 93 AND `spell` <=> -1 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 18 AND `prev_id` <=> 13296 AND `next_id` <=> 13298);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-011 predecessor preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=13297 FOR UPDATE;
IF actual_count <> 8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-011 predecessor effect count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 13297 AND `slot` <=> 1 AND `effect_id` <=> 125 AND `base1` <=> 52 AND `base2` <=> 52) OR (`rank_id` <=> 13297 AND `slot` <=> 2 AND `effect_id` <=> 137 AND `base1` <=> 0 AND `base2` <=> 0) OR (`rank_id` <=> 13297 AND `slot` <=> 3 AND `effect_id` <=> 141 AND `base1` <=> 1 AND `base2` <=> 0) OR (`rank_id` <=> 13297 AND `slot` <=> 4 AND `effect_id` <=> 139 AND `base1` <=> -6233 AND `base2` <=> 0) OR (`rank_id` <=> 13297 AND `slot` <=> 5 AND `effect_id` <=> 139 AND `base1` <=> -6265 AND `base2` <=> 0) OR (`rank_id` <=> 13297 AND `slot` <=> 6 AND `effect_id` <=> 125 AND `base1` <=> 52 AND `base2` <=> 52) OR (`rank_id` <=> 13297 AND `slot` <=> 7 AND `effect_id` <=> 137 AND `base1` <=> 147 AND `base2` <=> 0) OR (`rank_id` <=> 13297 AND `slot` <=> 8 AND `effect_id` <=> 141 AND `base1` <=> 1 AND `base2` <=> 0);
IF actual_count <> 8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-011 predecessor effect preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=13298 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-011 new identity collision aa_ranks'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=13298 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-011 new identity collision aa_rank_effects'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=13298 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-011 new identity collision aa_rank_prereqs'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=13297 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-011 predecessor prereqs mismatch'; END IF;
INSERT INTO `aa_ranks` (`id`,`upper_hotkey_sid`,`lower_hotkey_sid`,`title_sid`,`desc_sid`,`cost`,`level_req`,`spell`,`spell_type`,`recast_time`,`expansion`,`prev_id`,`next_id`) VALUES
(13298,-1,-1,77,77,12,95,-1,0,0,18,13297,-1);
INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(13298,1,125,55,55),
(13298,2,137,0,0),
(13298,3,141,1,0),
(13298,4,139,-6233,0),
(13298,5,139,-6265,0),
(13298,6,125,55,55),
(13298,7,137,147,0),
(13298,8,141,1,0);
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 13298 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 77 AND `desc_sid` <=> 77 AND `cost` <=> 12 AND `level_req` <=> 95 AND `spell` <=> -1 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 18 AND `prev_id` <=> 13297 AND `next_id` <=> -1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-011 rank postimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=13298;
IF actual_count <> 8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-011 effect postimage count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 13298 AND `slot` <=> 1 AND `effect_id` <=> 125 AND `base1` <=> 55 AND `base2` <=> 55) OR (`rank_id` <=> 13298 AND `slot` <=> 2 AND `effect_id` <=> 137 AND `base1` <=> 0 AND `base2` <=> 0) OR (`rank_id` <=> 13298 AND `slot` <=> 3 AND `effect_id` <=> 141 AND `base1` <=> 1 AND `base2` <=> 0) OR (`rank_id` <=> 13298 AND `slot` <=> 4 AND `effect_id` <=> 139 AND `base1` <=> -6233 AND `base2` <=> 0) OR (`rank_id` <=> 13298 AND `slot` <=> 5 AND `effect_id` <=> 139 AND `base1` <=> -6265 AND `base2` <=> 0) OR (`rank_id` <=> 13298 AND `slot` <=> 6 AND `effect_id` <=> 125 AND `base1` <=> 55 AND `base2` <=> 55) OR (`rank_id` <=> 13298 AND `slot` <=> 7 AND `effect_id` <=> 137 AND `base1` <=> 147 AND `base2` <=> 0) OR (`rank_id` <=> 13298 AND `slot` <=> 8 AND `effect_id` <=> 141 AND `base1` <=> 1 AND `base2` <=> 0);
IF actual_count <> 8 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-011 effect postimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=13298;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-011 unexpected new prereqs'; END IF;
COMMIT;
SELECT 'AA-011_COMMITTED_EXACT_POSTIMAGES' AS result;
END//
DELIMITER ;
