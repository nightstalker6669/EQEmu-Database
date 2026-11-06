-- AA038 PROPOSAL ONLY: finite Twinproc prefix; preserve existing eligibility and focus limits.
-- No existing AA or player writes. MariaDB/InnoDB; stop on mismatch.
DELIMITER //
BEGIN NOT ATOMIC
DECLARE actual_count INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
SELECT COUNT(*) INTO actual_count FROM `aa_ability` WHERE id=1664 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA038 ability count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ability` WHERE (`id` <=> 1664 AND `name` <=> CONVERT(0x5477696e70726f63 USING latin1) AND `category` <=> -1 AND `classes` <=> 50175 AND `races` <=> 65535 AND `drakkin_heritage` <=> 127 AND `deities` <=> 131071 AND `status` <=> 0 AND `type` <=> 3 AND `charges` <=> 0 AND `grant_only` <=> 0 AND `first_rank_id` <=> 12416 AND `enabled` <=> 1 AND `reset_on_death` <=> 0 AND `auto_grant_enabled` <=> 1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA038 ability preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=13413 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA038 predecessor count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 13413 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 12416 AND `desc_sid` <=> 12416 AND `cost` <=> 15 AND `level_req` <=> 91 AND `spell` <=> -1 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 18 AND `prev_id` <=> 12418 AND `next_id` <=> 13414);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA038 predecessor preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=13413 FOR UPDATE;
IF actual_count <> 9 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA038 predecessor effects count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 13413 AND `slot` <=> 1 AND `effect_id` <=> 399 AND `base1` <=> 12 AND `base2` <=> 0) OR (`rank_id` <=> 13413 AND `slot` <=> 2 AND `effect_id` <=> 141 AND `base1` <=> 1 AND `base2` <=> 0) OR (`rank_id` <=> 13413 AND `slot` <=> 3 AND `effect_id` <=> 138 AND `base1` <=> 0 AND `base2` <=> 0) OR (`rank_id` <=> 13413 AND `slot` <=> 4 AND `effect_id` <=> 142 AND `base1` <=> 255 AND `base2` <=> 0) OR (`rank_id` <=> 13413 AND `slot` <=> 5 AND `effect_id` <=> 391 AND `base1` <=> 0 AND `base2` <=> 0) OR (`rank_id` <=> 13413 AND `slot` <=> 6 AND `effect_id` <=> 311 AND `base1` <=> 0 AND `base2` <=> 0) OR (`rank_id` <=> 13413 AND `slot` <=> 7 AND `effect_id` <=> 137 AND `base1` <=> -152 AND `base2` <=> 0) OR (`rank_id` <=> 13413 AND `slot` <=> 8 AND `effect_id` <=> 411 AND `base1` <=> 100350 AND `base2` <=> 0) OR (`rank_id` <=> 13413 AND `slot` <=> 9 AND `effect_id` <=> 137 AND `base1` <=> -39 AND `base2` <=> 0);
IF actual_count <> 9 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA038 predecessor effects mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=13413 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA038 predecessor prereqs count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE (`rank_id` <=> 13413 AND `aa_id` <=> 1685 AND `points` <=> 1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA038 predecessor prereqs mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=13414 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA038 target identity collision aa_ranks'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=13414 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA038 target identity collision aa_rank_effects'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=13414 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA038 target identity collision aa_rank_prereqs'; END IF;
INSERT INTO `aa_ranks` (`id`,`upper_hotkey_sid`,`lower_hotkey_sid`,`title_sid`,`desc_sid`,`cost`,`level_req`,`spell`,`spell_type`,`recast_time`,`expansion`,`prev_id`,`next_id`) VALUES
(13414,-1,-1,12416,12416,18,95,-1,0,0,18,13413,-1);
INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(13414,1,399,15,0);
INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(13414,2,141,1,0);
INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(13414,3,138,0,0);
INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(13414,4,142,255,0);
INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(13414,5,391,0,0);
INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(13414,6,311,0,0);
INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(13414,7,137,-152,0);
INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(13414,8,411,100350,0);
INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(13414,9,137,-39,0);
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 13414 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 12416 AND `desc_sid` <=> 12416 AND `cost` <=> 18 AND `level_req` <=> 95 AND `spell` <=> -1 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 18 AND `prev_id` <=> 13413 AND `next_id` <=> -1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA038 rank postimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=13414 FOR UPDATE;
IF actual_count <> 9 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA038 effect postimages count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 13414 AND `slot` <=> 1 AND `effect_id` <=> 399 AND `base1` <=> 15 AND `base2` <=> 0) OR (`rank_id` <=> 13414 AND `slot` <=> 2 AND `effect_id` <=> 141 AND `base1` <=> 1 AND `base2` <=> 0) OR (`rank_id` <=> 13414 AND `slot` <=> 3 AND `effect_id` <=> 138 AND `base1` <=> 0 AND `base2` <=> 0) OR (`rank_id` <=> 13414 AND `slot` <=> 4 AND `effect_id` <=> 142 AND `base1` <=> 255 AND `base2` <=> 0) OR (`rank_id` <=> 13414 AND `slot` <=> 5 AND `effect_id` <=> 391 AND `base1` <=> 0 AND `base2` <=> 0) OR (`rank_id` <=> 13414 AND `slot` <=> 6 AND `effect_id` <=> 311 AND `base1` <=> 0 AND `base2` <=> 0) OR (`rank_id` <=> 13414 AND `slot` <=> 7 AND `effect_id` <=> 137 AND `base1` <=> -152 AND `base2` <=> 0) OR (`rank_id` <=> 13414 AND `slot` <=> 8 AND `effect_id` <=> 411 AND `base1` <=> 100350 AND `base2` <=> 0) OR (`rank_id` <=> 13414 AND `slot` <=> 9 AND `effect_id` <=> 137 AND `base1` <=> -39 AND `base2` <=> 0);
IF actual_count <> 9 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA038 effect postimages mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=13414;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA038 unexpected new prereqs'; END IF;
COMMIT;
SELECT 'AA038_COMMITTED_EXACT_POSTIMAGES' AS result;
END//
DELIMITER ;
