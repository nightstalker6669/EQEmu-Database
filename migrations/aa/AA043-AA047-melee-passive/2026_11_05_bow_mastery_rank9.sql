-- AA044 PROPOSAL ONLY: finite passive prefix; preserve native encoding and inherited prerequisites.
-- No existing AA or player writes. MariaDB/InnoDB; stop on mismatch.
DELIMITER //
BEGIN NOT ATOMIC
DECLARE actual_count INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
SELECT COUNT(*) INTO actual_count FROM `aa_ability` WHERE id=878 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA044 ability count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ability` WHERE (`id` <=> 878 AND `name` <=> CONVERT(0x426f77204d617374657279 USING latin1) AND `category` <=> -1 AND `classes` <=> 8 AND `races` <=> 65535 AND `drakkin_heritage` <=> 127 AND `deities` <=> 131071 AND `status` <=> 0 AND `type` <=> 3 AND `charges` <=> 0 AND `grant_only` <=> 0 AND `first_rank_id` <=> 1196 AND `enabled` <=> 1 AND `reset_on_death` <=> 0 AND `auto_grant_enabled` <=> 1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA044 ability preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=10745 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA044 predecessor count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 10745 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 1196 AND `desc_sid` <=> 1196 AND `cost` <=> 5 AND `level_req` <=> 88 AND `spell` <=> -1 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 17 AND `prev_id` <=> 10744 AND `next_id` <=> 10746);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA044 predecessor preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=10745 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA044 predecessor effects count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 10745 AND `slot` <=> 1 AND `effect_id` <=> 220 AND `base1` <=> 205 AND `base2` <=> 7);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA044 predecessor effects mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=10745 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA044 predecessor prereqs count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=10746 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA044 target identity collision aa_ranks'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=10746 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA044 target identity collision aa_rank_effects'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=10746 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA044 target identity collision aa_rank_prereqs'; END IF;
INSERT INTO `aa_ranks` (`id`,`upper_hotkey_sid`,`lower_hotkey_sid`,`title_sid`,`desc_sid`,`cost`,`level_req`,`spell`,`spell_type`,`recast_time`,`expansion`,`prev_id`,`next_id`) VALUES
(10746,-1,-1,1196,1196,6,89,-1,0,0,17,10745,-1);
INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(10746,1,220,240,7);
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 10746 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 1196 AND `desc_sid` <=> 1196 AND `cost` <=> 6 AND `level_req` <=> 89 AND `spell` <=> -1 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 17 AND `prev_id` <=> 10745 AND `next_id` <=> -1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA044 rank postimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=10746 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA044 effect postimages count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 10746 AND `slot` <=> 1 AND `effect_id` <=> 220 AND `base1` <=> 240 AND `base2` <=> 7);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA044 effect postimages mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=10746;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA044 unexpected new prereqs'; END IF;
COMMIT;
SELECT 'AA044_COMMITTED_EXACT_POSTIMAGES' AS result;
END//
DELIMITER ;
