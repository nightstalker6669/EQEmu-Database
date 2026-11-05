-- AA-018 PROPOSAL ONLY: Hastened Weapon Shield8 known native10771; explicit local encoding defaults.
-- No player ownership/points writes. MariaDB/InnoDB; stop on any mismatch.
DELIMITER //
BEGIN NOT ATOMIC
DECLARE actual_count INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
SELECT COUNT(*) INTO actual_count FROM `aa_ability` WHERE id=871 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-018 ability count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ability` WHERE (`id` <=> 871 AND `name` <=> CONVERT(0x48617374656e656420576561706f6e20536869656c64 USING latin1) AND `category` <=> -1 AND `classes` <=> 8 AND `races` <=> 65535 AND `drakkin_heritage` <=> 127 AND `deities` <=> 131071 AND `status` <=> 0 AND `type` <=> 3 AND `charges` <=> 0 AND `grant_only` <=> 0 AND `first_rank_id` <=> 6751 AND `enabled` <=> 1 AND `reset_on_death` <=> 0 AND `auto_grant_enabled` <=> 1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-018 ability preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=10770 FOR UPDATE;
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-018 predecessor count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 10770 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 6751 AND `desc_sid` <=> 6751 AND `cost` <=> 9 AND `level_req` <=> 88 AND `spell` <=> -1 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 17 AND `prev_id` <=> 10769 AND `next_id` <=> 10771);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-018 predecessor preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=10770 FOR UPDATE;
IF actual_count <> 2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-018 predecessor effect count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 10770 AND `slot` <=> 1 AND `effect_id` <=> 310 AND `base1` <=> 1680000 AND `base2` <=> 0) OR (`rank_id` <=> 10770 AND `slot` <=> 2 AND `effect_id` <=> 139 AND `base1` <=> 4519 AND `base2` <=> 0);
IF actual_count <> 2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-018 predecessor effect preimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE id=10771 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-018 new identity collision aa_ranks'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=10771 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-018 new identity collision aa_rank_effects'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=10771 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-018 new identity collision aa_rank_prereqs'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=10770 FOR UPDATE;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-018 predecessor prereqs mismatch'; END IF;
INSERT INTO `aa_ranks` (`id`,`upper_hotkey_sid`,`lower_hotkey_sid`,`title_sid`,`desc_sid`,`cost`,`level_req`,`spell`,`spell_type`,`recast_time`,`expansion`,`prev_id`,`next_id`) VALUES
(10771,-1,-1,6751,6751,9,90,-1,0,0,17,10770,-1);
INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(10771,1,310,1920000,0),
(10771,2,139,4519,0);
SELECT COUNT(*) INTO actual_count FROM `aa_ranks` WHERE (`id` <=> 10771 AND `upper_hotkey_sid` <=> -1 AND `lower_hotkey_sid` <=> -1 AND `title_sid` <=> 6751 AND `desc_sid` <=> 6751 AND `cost` <=> 9 AND `level_req` <=> 90 AND `spell` <=> -1 AND `spell_type` <=> 0 AND `recast_time` <=> 0 AND `expansion` <=> 17 AND `prev_id` <=> 10770 AND `next_id` <=> -1);
IF actual_count <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-018 rank postimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE rank_id=10771;
IF actual_count <> 2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-018 effect postimage count mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_effects` WHERE (`rank_id` <=> 10771 AND `slot` <=> 1 AND `effect_id` <=> 310 AND `base1` <=> 1920000 AND `base2` <=> 0) OR (`rank_id` <=> 10771 AND `slot` <=> 2 AND `effect_id` <=> 139 AND `base1` <=> 4519 AND `base2` <=> 0);
IF actual_count <> 2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-018 effect postimage mismatch'; END IF;
SELECT COUNT(*) INTO actual_count FROM `aa_rank_prereqs` WHERE rank_id=10771;
IF actual_count <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='AA-018 unexpected new prereqs'; END IF;
COMMIT;
SELECT 'AA-018_COMMITTED_EXACT_POSTIMAGES' AS result;
END//
DELIMITER ;
