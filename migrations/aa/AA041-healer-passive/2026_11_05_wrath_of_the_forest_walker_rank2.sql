-- AA041 PROPOSAL ONLY: qualified period-note Wrath prefix; magnitude200 is explicit reconstruction.
-- No existing AA or player writes. MariaDB/InnoDB; stop on mismatch.
DELIMITER //
BEGIN NOT ATOMIC
DECLARE actual_count INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
SELECT COUNT(*) INTO actual_count FROM `aa_ability` WHERE id=178 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA041 ability count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ability` WHERE (`id` <=> 178 AND `name` <=> CONVERT(0x5772617468206f662074686520466f726573742057616c6b6572 USING latin1) AND `category` <=> -1 AND `classes` <=> 32 AND `races` <=> 65535 AND `drakkin_heritage` <=> 127 AND `deities` <=> 131071 AND `status` <=> 0 AND `type` <=> 3 AND `charges` <=> 0 AND `grant_only` <=> 0 AND `first_rank_id` <=> 14244 AND `enabled` <=> 1 AND `reset_on_death` <=> 0 AND `auto_grant_enabled` <=> 1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA041 ability preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=14244 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA041 predecessor count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 14244 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 14244 AND `desc_sid` <=> 14244 AND `cost` <=> 9 AND `level_req` <=> 91 AND `spell` <=> -1 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 18 AND `prev_id` <=> -1 AND `next_id` <=> 14245);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA041 predecessor preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=14244 FOR UPDATE;
IF actual_count <> 5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA041 predecessor effects count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 14244 AND `slot` <=> 1 AND `effect_id` <=> 286 AND `base1` <=> 100 AND `base2` <=> 0) OR (`rank_id` <=> 14244 AND `slot` <=> 2 AND `effect_id` <=> 138 AND `base1` <=> 0 AND `base2` <=> 0) OR (`rank_id` <=> 14244 AND `slot` <=> 3 AND `effect_id` <=> 143 AND `base1` <=> 1 AND `base2` <=> 0) OR (`rank_id` <=> 14244 AND `slot` <=> 4 AND `effect_id` <=> 348 AND `base1` <=> 1 AND `base2` <=> 0) OR (`rank_id` <=> 14244 AND `slot` <=> 5 AND `effect_id` <=> 411 AND `base1` <=> 64 AND `base2` <=> 0);
IF actual_count <> 5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA041 predecessor effects mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=14244 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA041 predecessor prereqs count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE (`rank_id` <=> 14244 AND `aa_id` <=> 1685 AND `points` <=> 1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA041 predecessor prereqs mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=14245 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA041 target identity collision aa_ranks'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=14245 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA041 target identity collision aa_rank_effects'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=14245 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA041 target identity collision aa_rank_prereqs'; END IF;
INSERT INTO `aa_ranks` (`id`,`upper_hotkey_sid`,`lower_hotkey_sid`,`title_sid`,`desc_sid`,`cost`,`level_req`,`spell`,`spell_type`,`recast_time`,`expansion`,`prev_id`,`next_id`) VALUES
(14245,-1,-1,14244,14244,11,92,-1,0,0,18,14244,-1);
INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(14245,1,286,200,0);
INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(14245,2,138,0,0);
INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(14245,3,143,1,0);
INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(14245,4,348,1,0);
INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(14245,5,411,64,0);
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 14245 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 14244 AND `desc_sid` <=> 14244 AND `cost` <=> 11 AND `level_req` <=> 92 AND `spell` <=> -1 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 18 AND `prev_id` <=> 14244 AND `next_id` <=> -1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA041 rank postimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=14245 FOR UPDATE;
IF actual_count <> 5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA041 effect postimages count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 14245 AND `slot` <=> 1 AND `effect_id` <=> 286 AND `base1` <=> 200 AND `base2` <=> 0) OR (`rank_id` <=> 14245 AND `slot` <=> 2 AND `effect_id` <=> 138 AND `base1` <=> 0 AND `base2` <=> 0) OR (`rank_id` <=> 14245 AND `slot` <=> 3 AND `effect_id` <=> 143 AND `base1` <=> 1 AND `base2` <=> 0) OR (`rank_id` <=> 14245 AND `slot` <=> 4 AND `effect_id` <=> 348 AND `base1` <=> 1 AND `base2` <=> 0) OR (`rank_id` <=> 14245 AND `slot` <=> 5 AND `effect_id` <=> 411 AND `base1` <=> 64 AND `base2` <=> 0);
IF actual_count <> 5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA041 effect postimages mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=14245;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA041 unexpected new prereqs'; END IF;
COMMIT;
SELECT 'AA041_COMMITTED_EXACT_POSTIMAGES' AS result;
END//
DELIMITER ;
