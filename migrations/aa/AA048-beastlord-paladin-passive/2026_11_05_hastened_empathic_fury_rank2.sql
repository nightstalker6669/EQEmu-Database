-- AA048 PROPOSAL ONLY: finite reuse-time prefix; preserve both native focus blocks.
-- No existing AA or player writes. MariaDB/InnoDB; stop on mismatch.
DELIMITER //
BEGIN NOT ATOMIC
DECLARE actual_count INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
SELECT COUNT(*) INTO actual_count FROM `aa_ability` WHERE id=454 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA048 ability count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ability` WHERE (`id` <=> 454 AND `name` <=> CONVERT(0x48617374656e656420456d7061746869632046757279 USING latin1) AND `category` <=> -1 AND `classes` <=> 16384 AND `races` <=> 65535 AND `drakkin_heritage` <=> 127 AND `deities` <=> 131071 AND `status` <=> 0 AND `type` <=> 3 AND `charges` <=> 0 AND `grant_only` <=> 0 AND `first_rank_id` <=> 12822 AND `enabled` <=> 1 AND `reset_on_death` <=> 0 AND `auto_grant_enabled` <=> 1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA048 ability preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=12822 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA048 predecessor count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 12822 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 12822 AND `desc_sid` <=> 12822 AND `cost` <=> 9 AND `level_req` <=> 86 AND `spell` <=> 0 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 17 AND `prev_id` <=> -1 AND `next_id` <=> 12823);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA048 predecessor preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=12822 FOR UPDATE;
IF actual_count <> 6 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA048 predecessor effects count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 12822 AND `slot` <=> 1 AND `effect_id` <=> 310 AND `base1` <=> 153000 AND `base2` <=> 0) OR (`rank_id` <=> 12822 AND `slot` <=> 2 AND `effect_id` <=> 139 AND `base1` <=> 8233 AND `base2` <=> 0) OR (`rank_id` <=> 12822 AND `slot` <=> 3 AND `effect_id` <=> 310 AND `base1` <=> 120000 AND `base2` <=> 0) OR (`rank_id` <=> 12822 AND `slot` <=> 4 AND `effect_id` <=> 385 AND `base1` <=> 2439 AND `base2` <=> 0) OR (`rank_id` <=> 12822 AND `slot` <=> 5 AND `effect_id` <=> 385 AND `base1` <=> 2539 AND `base2` <=> 0) OR (`rank_id` <=> 12822 AND `slot` <=> 6 AND `effect_id` <=> 411 AND `base1` <=> 32768 AND `base2` <=> 0);
IF actual_count <> 6 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA048 predecessor effects mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=12822 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA048 predecessor prereqs count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=12823 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA048 target identity collision aa_ranks'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=12823 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA048 target identity collision aa_rank_effects'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=12823 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA048 target identity collision aa_rank_prereqs'; END IF;
SELECT COUNT(*) INTO actual_count FROM `spells_new` WHERE id=8233 AND recast_time=1530000 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA048 Empathic base cooldown mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `spells_new` WHERE id IN (30311,30312,30313) AND spellgroup=2439 AND recast_time=1200000 FOR UPDATE;
IF actual_count <> 3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA048 Savage Fury compatibility base cooldown mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `spells_new` WHERE id IN (36386,36387,36388) AND spellgroup=2539 AND recast_time=1200000 FOR UPDATE;
IF actual_count <> 3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA048 Savage Rage compatibility base cooldown mismatch'; END IF;
INSERT INTO `aa_ranks` (`id`,`upper_hotkey_sid`,`lower_hotkey_sid`,`title_sid`,`desc_sid`,`cost`,`level_req`,`spell`,`spell_type`,`recast_time`,`expansion`,`prev_id`,`next_id`) VALUES
(12823,-1,-1,12822,12822,12,88,0,0,0,17,12822,-1);
INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(12823,1,310,306000,0);
INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(12823,2,139,8233,0);
INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(12823,3,310,240000,0);
INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(12823,4,385,2439,0);
INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(12823,5,385,2539,0);
INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(12823,6,411,32768,0);
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 12823 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 12822 AND `desc_sid` <=> 12822 AND `cost` <=> 12 AND `level_req` <=> 88 AND `spell` <=> 0 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 17 AND `prev_id` <=> 12822 AND `next_id` <=> -1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA048 rank postimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=12823 FOR UPDATE;
IF actual_count <> 6 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA048 effect postimages count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 12823 AND `slot` <=> 1 AND `effect_id` <=> 310 AND `base1` <=> 306000 AND `base2` <=> 0) OR (`rank_id` <=> 12823 AND `slot` <=> 2 AND `effect_id` <=> 139 AND `base1` <=> 8233 AND `base2` <=> 0) OR (`rank_id` <=> 12823 AND `slot` <=> 3 AND `effect_id` <=> 310 AND `base1` <=> 240000 AND `base2` <=> 0) OR (`rank_id` <=> 12823 AND `slot` <=> 4 AND `effect_id` <=> 385 AND `base1` <=> 2439 AND `base2` <=> 0) OR (`rank_id` <=> 12823 AND `slot` <=> 5 AND `effect_id` <=> 385 AND `base1` <=> 2539 AND `base2` <=> 0) OR (`rank_id` <=> 12823 AND `slot` <=> 6 AND `effect_id` <=> 411 AND `base1` <=> 32768 AND `base2` <=> 0);
IF actual_count <> 6 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA048 effect postimages mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=12823;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA048 unexpected new prereqs'; END IF;
COMMIT;
SELECT 'AA048_COMMITTED_EXACT_POSTIMAGES' AS result;
END//
DELIMITER ;
