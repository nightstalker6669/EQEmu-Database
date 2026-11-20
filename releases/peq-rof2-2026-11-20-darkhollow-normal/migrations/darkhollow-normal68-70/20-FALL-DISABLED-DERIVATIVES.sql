-- 9346 FALL NORMAL DISABLED. Offline review input. Requires the exact reserved prior task/DZ rows.
-- Additive DDL precedes the guarded content transaction. Stop on error.
-- Offline draft. Install only through the database owner. No activation in this file.
CREATE TABLE IF NOT EXISTS fall_shroud_config (
  id TINYINT UNSIGNED PRIMARY KEY,
  enabled BOOLEAN NOT NULL DEFAULT FALSE,
  commander_type INT UNSIGNED NULL,
  respawn_x FLOAT NULL,
  respawn_y FLOAT NULL,
  respawn_z FLOAT NULL,
  respawn_heading FLOAT NULL,
  refill_percent TINYINT UNSIGNED NOT NULL DEFAULT 40,
  normal_xp_bp SMALLINT UNSIGNED NOT NULL DEFAULT 500,
  aa_xp_bp SMALLINT UNSIGNED NOT NULL DEFAULT 9000
) ENGINE=InnoDB;
INSERT INTO fall_shroud_config (id) VALUES (1)
  ON DUPLICATE KEY UPDATE id=id;

CREATE TABLE IF NOT EXISTS fall_shroud_roles (
  class_id TINYINT UNSIGNED PRIMARY KEY,
  template_id INT UNSIGNED NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS fall_shroud_skills (
  template_id INT UNSIGNED NOT NULL,
  skill_id TINYINT UNSIGNED NOT NULL,
  skill_value SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY (template_id, skill_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS fall_shroud_choices (
  run_id BIGINT UNSIGNED NOT NULL,
  character_id INT UNSIGNED NOT NULL,
  template_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (run_id, character_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS fall_shroud_runs (
  run_id BIGINT UNSIGNED PRIMARY KEY,
  instance_id INT UNSIGNED NOT NULL,
  commander_token CHAR(36) CHARACTER SET ascii NOT NULL UNIQUE,
  exit_requested_at BIGINT UNSIGNED NULL,
  succeeded_at BIGINT UNSIGNED NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS fall_shroud_members (
  run_id BIGINT UNSIGNED NOT NULL,
  character_id INT UNSIGNED NOT NULL,
  session_id BIGINT UNSIGNED NOT NULL UNIQUE,
  instance_id INT UNSIGNED NOT NULL,
  normal_xp_bp SMALLINT UNSIGNED NOT NULL,
  aa_xp_bp SMALLINT UNSIGNED NOT NULL,
  refill_percent TINYINT UNSIGNED NOT NULL,
  commander_type INT UNSIGNED NOT NULL,
  respawn_x FLOAT NOT NULL,
  respawn_y FLOAT NOT NULL,
  respawn_z FLOAT NOT NULL,
  respawn_heading FLOAT NOT NULL,
  shard_token CHAR(36) CHARACTER SET ascii NULL,
  shard_slot SMALLINT UNSIGNED NULL,
  exited_at BIGINT UNSIGNED NULL,
  exit_succeeded BOOLEAN NOT NULL DEFAULT FALSE,
  xp_settled_at BIGINT UNSIGNED NULL,
  PRIMARY KEY (run_id, character_id),
  UNIQUE KEY consumed_corpse_slot (shard_token, shard_slot),
  KEY character_mission_xp (character_id, exit_succeeded, xp_settled_at)
) ENGINE=InnoDB;

DELIMITER //
BEGIN NOT ATOMIC
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
IF (SELECT COUNT(*) FROM tasks WHERE id=920243 AND type=1 AND dz_template_id=920243 AND enabled=0)<>1 OR (SELECT COUNT(*) FROM dynamic_zone_templates WHERE id=920243 AND zone_id=348 AND zone_version=1)<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall requires exact disabled task and DZ 920243';
END IF;

IF (SELECT COUNT(*) FROM fall_shroud_config WHERE id=1 AND enabled=0 AND commander_type IS NULL AND respawn_x IS NULL AND respawn_y IS NULL AND respawn_z IS NULL AND respawn_heading IS NULL)<>1 OR EXISTS(SELECT 1 FROM fall_shroud_roles) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall provider preimage is not disabled and unbound';
END IF;

IF EXISTS(SELECT 1 FROM aa_ranks WHERE spell_type IN (1900,1901,1902,1903,1904,1905,1906,1907,1908,1909,1910,1911,1912)) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall timer groups collide';
END IF;

IF EXISTS(SELECT 1 FROM spirit_shroud_templates WHERE id IN (90500,90501,90502,90503,90504)) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall reserved spirit_shroud_templates identities collide';
END IF;

IF EXISTS(SELECT 1 FROM spirit_shroud_abilities WHERE template_id IN (90500,90501,90502,90503,90504)) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall reserved spirit_shroud_abilities identities collide';
END IF;

IF EXISTS(SELECT 1 FROM spirit_shroud_starter_equipment WHERE template_id IN (90500,90501,90502,90503,90504)) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall reserved spirit_shroud_starter_equipment identities collide';
END IF;

IF EXISTS(SELECT 1 FROM fall_shroud_skills WHERE template_id IN (90500,90501,90502,90503,90504)) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall reserved fall_shroud_skills identities collide';
END IF;

IF EXISTS(SELECT 1 FROM items WHERE id IN (900100,900101,900102,900103,900104,900105)) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall reserved items identities collide';
END IF;

IF EXISTS(SELECT 1 FROM spells_new WHERE id IN (42700,42701,42702)) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall reserved spells_new identities collide';
END IF;

IF EXISTS(SELECT 1 FROM db_str WHERE id IN (49200,49201,49202,49203)) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall reserved db_str identities collide';
END IF;

IF EXISTS(SELECT 1 FROM aa_ability WHERE id IN (49100,49105,49110,49115,49120,49125,49130,49135,49140,49145,49146,49147,49148,49149,49150,49151,49152,49153,49154,49155,49156,49157)) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall reserved aa_ability identities collide';
END IF;

IF EXISTS(SELECT 1 FROM aa_ranks WHERE id IN (49100,49101,49102,49103,49104,49105,49106,49107,49108,49109,49110,49111,49112,49113,49114,49115,49116,49117,49118,49119,49120,49121,49122,49123,49124,49125,49126,49127,49128,49129,49130,49131,49132,49133,49134,49135,49136,49137,49138,49139,49140,49141,49142,49143,49144,49145,49146,49147,49148,49149,49150,49151,49152,49153,49154,49155,49156,49157)) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall reserved aa_ranks identities collide';
END IF;

IF EXISTS(SELECT 1 FROM aa_rank_effects WHERE rank_id IN (49100,49101,49102,49103,49104,49105,49106,49107,49108,49109,49110,49111,49112,49113,49114,49115,49116,49117,49118,49119,49120,49121,49122,49123,49124,49125,49126,49127,49128,49129,49130,49131,49132,49133,49134,49135,49136,49137,49138,49139,49140,49141,49142,49143,49144,49145,49146,49147,49148,49149,49150,49151,49152,49153,49154,49155,49156,49157)) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall reserved aa_rank_effects identities collide';
END IF;

IF EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id IN (49100,49101,49102,49103,49104,49105,49106,49107,49108,49109,49110,49111,49112,49113,49114,49115,49116,49117,49118,49119,49120,49121,49122,49123,49124,49125,49126,49127,49128,49129,49130,49131,49132,49133,49134,49135,49136,49137,49138,49139,49140,49141,49142,49143,49144,49145,49146,49147,49148,49149,49150,49151,49152,49153,49154,49155,49156,49157)) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall reserved aa_rank_prereqs identities collide';
END IF;

IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('aa_ability','aa_rank_effects','aa_rank_prereqs','aa_ranks','db_str','fall_shroud_config','fall_shroud_roles','fall_shroud_skills','items','spells_new','spirit_shroud_abilities','spirit_shroud_starter_equipment','spirit_shroud_templates') AND ENGINE='InnoDB')<>13 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall content requires transactional tables';
END IF;

IF EXISTS(SELECT 1 FROM timers WHERE type IN (2900,2901,2902,2903,2904,2905,2906,2907,2908,2909,2910,2911,2912)) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall reserved persisted timer identities collide';
END IF;

IF (SELECT COUNT(*) FROM items WHERE id=85538 AND Name='Illsalin Legion Shield' AND idfile='IT10772' AND itemtype=8 AND damage=0 AND delay=0 AND slots=16384 AND ac=25 AND stacksize=1 AND nodrop=1 AND norent=1 AND clickeffect=-1 AND proceffect=-1 AND worneffect=-1 AND focuseffect=-1)<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall item base 85538 drift';
END IF;

IF (SELECT COUNT(*) FROM items WHERE id=85539 AND Name='Shiliskin Hoplite Spear' AND idfile='IT10613' AND itemtype=2 AND damage=6 AND delay=25 AND slots=24576 AND ac=0 AND stacksize=1 AND nodrop=1 AND norent=1 AND clickeffect=-1 AND proceffect=-1 AND worneffect=-1 AND focuseffect=-1)<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall item base 85539 drift';
END IF;

IF (SELECT COUNT(*) FROM items WHERE id=85540 AND Name='Shiliskin Battle Deep Blade' AND idfile='IT10840' AND itemtype=2 AND damage=5 AND delay=25 AND slots=24576 AND ac=0 AND stacksize=1 AND nodrop=1 AND norent=1 AND clickeffect=-1 AND proceffect=-1 AND worneffect=-1 AND focuseffect=-1)<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall item base 85540 drift';
END IF;

IF (SELECT COUNT(*) FROM items WHERE id=85541 AND Name='Shiliskin Infantry Blade' AND idfile='IT10017' AND itemtype=0 AND damage=5 AND delay=25 AND slots=24576 AND ac=0 AND stacksize=1 AND nodrop=1 AND norent=1 AND clickeffect=-1 AND proceffect=-1 AND worneffect=-1 AND focuseffect=-1)<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall item base 85541 drift';
END IF;

IF (SELECT COUNT(*) FROM items WHERE id=85542 AND Name='Runestaff of the Deep' AND idfile='IT10201' AND itemtype=3 AND damage=4 AND delay=25 AND slots=24576 AND ac=0 AND stacksize=1 AND nodrop=1 AND norent=1 AND clickeffect=-1 AND proceffect=-1 AND worneffect=-1 AND focuseffect=-1)<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall item base 85542 drift';
END IF;

IF (SELECT COUNT(*) FROM items WHERE id=85543 AND Name='Tome of Incantations' AND idfile='IT10646' AND itemtype=2 AND damage=5 AND delay=25 AND slots=24576 AND ac=0 AND stacksize=1 AND nodrop=1 AND norent=1 AND clickeffect=-1 AND proceffect=-1 AND worneffect=-1 AND focuseffect=-1)<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall item base 85543 drift';
END IF;

IF (SELECT COUNT(*) FROM spells_new WHERE id=19 AND name='Armor of Faith' AND cast_time=6000 AND mana=150 AND `targettype`=5 AND `effectid1`=10 AND `effectid2`=10 AND `effectid3`=10 AND `effectid4`=1 AND `max1`=0)<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall spell base 19 drift';
END IF;

IF (SELECT COUNT(*) FROM spells_new WHERE id=1712 AND name='Forlorn Deeds' AND cast_time=6000 AND mana=225 AND `targettype`=5 AND `effectid1`=10 AND `effectid2`=11 AND `effectid3`=35 AND `effectid4`=254 AND `max1`=0)<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall spell base 1712 drift';
END IF;

IF (SELECT COUNT(*) FROM spells_new WHERE id=3358 AND name='Bliss' AND cast_time=2500 AND mana=300 AND `targettype`=5 AND `effectid1`=31 AND `effectid2`=63 AND `effectid3`=254 AND `effectid4`=254 AND `max1`=68)<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall spell base 3358 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ability WHERE id=48706 AND first_rank_id=48706 AND enabled=1 AND category=3 AND name='Innate Run Speed')<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive root 48706 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48706 AND upper_hotkey_sid=3000 AND lower_hotkey_sid=3000 AND title_sid=3000 AND desc_sid=3000 AND cost=1 AND level_req=51 AND expansion=0 AND prev_id=-1 AND next_id=48707 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48706)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48706 AND ((slot=1 AND effect_id=271 AND base1=8 AND base2=0)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48706) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48706 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48707 AND upper_hotkey_sid=3000 AND lower_hotkey_sid=3000 AND title_sid=3000 AND desc_sid=3000 AND cost=2 AND level_req=55 AND expansion=0 AND prev_id=48706 AND next_id=48708 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48707)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48707 AND ((slot=1 AND effect_id=271 AND base1=14 AND base2=0)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48707) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48707 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48708 AND upper_hotkey_sid=3000 AND lower_hotkey_sid=3000 AND title_sid=3000 AND desc_sid=3000 AND cost=3 AND level_req=60 AND expansion=0 AND prev_id=48707 AND next_id=48709 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48708)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48708 AND ((slot=1 AND effect_id=271 AND base1=21 AND base2=0)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48708) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48708 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48709 AND upper_hotkey_sid=3000 AND lower_hotkey_sid=3000 AND title_sid=3000 AND desc_sid=3000 AND cost=4 AND level_req=65 AND expansion=0 AND prev_id=48708 AND next_id=48710 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48709)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48709 AND ((slot=1 AND effect_id=271 AND base1=28 AND base2=0)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48709) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48709 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48710 AND upper_hotkey_sid=3000 AND lower_hotkey_sid=3000 AND title_sid=3000 AND desc_sid=3000 AND cost=5 AND level_req=70 AND expansion=0 AND prev_id=48709 AND next_id=-1 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48710)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48710 AND ((slot=1 AND effect_id=271 AND base1=35 AND base2=0)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48710) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48710 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ability WHERE id=48415 AND first_rank_id=48415 AND enabled=1 AND category=3 AND name='Combat Stability')<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive root 48415 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48415 AND upper_hotkey_sid=3025 AND lower_hotkey_sid=3025 AND title_sid=3025 AND desc_sid=3025 AND cost=2 AND level_req=50 AND expansion=0 AND prev_id=-1 AND next_id=48416 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48415)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48415 AND ((slot=1 AND effect_id=259 AND base1=2 AND base2=0)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48415) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48415 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48416 AND upper_hotkey_sid=3025 AND lower_hotkey_sid=3025 AND title_sid=3025 AND desc_sid=3025 AND cost=3 AND level_req=55 AND expansion=0 AND prev_id=48415 AND next_id=48417 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48416)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48416 AND ((slot=1 AND effect_id=259 AND base1=4 AND base2=0)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48416) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48416 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48417 AND upper_hotkey_sid=3025 AND lower_hotkey_sid=3025 AND title_sid=3025 AND desc_sid=3025 AND cost=4 AND level_req=60 AND expansion=0 AND prev_id=48416 AND next_id=48418 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48417)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48417 AND ((slot=1 AND effect_id=259 AND base1=6 AND base2=0)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48417) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48417 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48418 AND upper_hotkey_sid=3025 AND lower_hotkey_sid=3025 AND title_sid=3025 AND desc_sid=3025 AND cost=5 AND level_req=65 AND expansion=0 AND prev_id=48417 AND next_id=48419 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48418)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48418 AND ((slot=1 AND effect_id=259 AND base1=8 AND base2=0)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48418) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48418 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48419 AND upper_hotkey_sid=3025 AND lower_hotkey_sid=3025 AND title_sid=3025 AND desc_sid=3025 AND cost=6 AND level_req=70 AND expansion=0 AND prev_id=48418 AND next_id=-1 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48419)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48419 AND ((slot=1 AND effect_id=259 AND base1=10 AND base2=0)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48419) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48419 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ability WHERE id=48420 AND first_rank_id=48420 AND enabled=1 AND category=3 AND name='Combat Agility')<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive root 48420 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48420 AND upper_hotkey_sid=3030 AND lower_hotkey_sid=3030 AND title_sid=3030 AND desc_sid=3030 AND cost=2 AND level_req=50 AND expansion=0 AND prev_id=-1 AND next_id=48421 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48420)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48420 AND ((slot=1 AND effect_id=172 AND base1=2 AND base2=0)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48420) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48420 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48421 AND upper_hotkey_sid=3030 AND lower_hotkey_sid=3030 AND title_sid=3030 AND desc_sid=3030 AND cost=3 AND level_req=55 AND expansion=0 AND prev_id=48420 AND next_id=48422 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48421)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48421 AND ((slot=1 AND effect_id=172 AND base1=4 AND base2=0)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48421) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48421 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48422 AND upper_hotkey_sid=3030 AND lower_hotkey_sid=3030 AND title_sid=3030 AND desc_sid=3030 AND cost=4 AND level_req=60 AND expansion=0 AND prev_id=48421 AND next_id=48423 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48422)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48422 AND ((slot=1 AND effect_id=172 AND base1=6 AND base2=0)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48422) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48422 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48423 AND upper_hotkey_sid=3030 AND lower_hotkey_sid=3030 AND title_sid=3030 AND desc_sid=3030 AND cost=5 AND level_req=65 AND expansion=0 AND prev_id=48422 AND next_id=48424 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48423)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48423 AND ((slot=1 AND effect_id=172 AND base1=8 AND base2=0)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48423) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48423 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48424 AND upper_hotkey_sid=3030 AND lower_hotkey_sid=3030 AND title_sid=3030 AND desc_sid=3030 AND cost=6 AND level_req=70 AND expansion=0 AND prev_id=48423 AND next_id=-1 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48424)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48424 AND ((slot=1 AND effect_id=172 AND base1=10 AND base2=0)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48424) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48424 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ability WHERE id=48425 AND first_rank_id=48425 AND enabled=1 AND category=3 AND name='Combat Fury')<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive root 48425 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48425 AND upper_hotkey_sid=3035 AND lower_hotkey_sid=3035 AND title_sid=3035 AND desc_sid=3035 AND cost=2 AND level_req=50 AND expansion=0 AND prev_id=-1 AND next_id=48426 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48425)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48425 AND ((slot=1 AND effect_id=169 AND base1=15 AND base2=-1)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48425) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48425 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48426 AND upper_hotkey_sid=3035 AND lower_hotkey_sid=3035 AND title_sid=3035 AND desc_sid=3035 AND cost=3 AND level_req=55 AND expansion=0 AND prev_id=48425 AND next_id=48427 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48426)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48426 AND ((slot=1 AND effect_id=169 AND base1=30 AND base2=-1)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48426) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48426 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48427 AND upper_hotkey_sid=3035 AND lower_hotkey_sid=3035 AND title_sid=3035 AND desc_sid=3035 AND cost=4 AND level_req=60 AND expansion=0 AND prev_id=48426 AND next_id=48428 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48427)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48427 AND ((slot=1 AND effect_id=169 AND base1=45 AND base2=-1)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48427) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48427 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48428 AND upper_hotkey_sid=3035 AND lower_hotkey_sid=3035 AND title_sid=3035 AND desc_sid=3035 AND cost=5 AND level_req=65 AND expansion=0 AND prev_id=48427 AND next_id=48429 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48428)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48428 AND ((slot=1 AND effect_id=169 AND base1=60 AND base2=-1)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48428) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48428 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48429 AND upper_hotkey_sid=3035 AND lower_hotkey_sid=3035 AND title_sid=3035 AND desc_sid=3035 AND cost=6 AND level_req=70 AND expansion=0 AND prev_id=48428 AND next_id=-1 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48429)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48429 AND ((slot=1 AND effect_id=169 AND base1=75 AND base2=-1)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48429) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48429 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ability WHERE id=48539 AND first_rank_id=48539 AND enabled=1 AND category=3 AND name='Innate Dexterity')<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive root 48539 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48539 AND upper_hotkey_sid=3171 AND lower_hotkey_sid=3171 AND title_sid=3171 AND desc_sid=3171 AND cost=1 AND level_req=25 AND expansion=0 AND prev_id=-1 AND next_id=48540 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48539)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48539 AND ((slot=1 AND effect_id=5 AND base1=2 AND base2=0)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48539) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48539 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48540 AND upper_hotkey_sid=3171 AND lower_hotkey_sid=3171 AND title_sid=3171 AND desc_sid=3171 AND cost=1 AND level_req=30 AND expansion=0 AND prev_id=48539 AND next_id=48541 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48540)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48540 AND ((slot=1 AND effect_id=5 AND base1=4 AND base2=0)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48540) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48540 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48541 AND upper_hotkey_sid=3171 AND lower_hotkey_sid=3171 AND title_sid=3171 AND desc_sid=3171 AND cost=1 AND level_req=35 AND expansion=0 AND prev_id=48540 AND next_id=48542 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48541)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48541 AND ((slot=1 AND effect_id=5 AND base1=6 AND base2=0)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48541) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48541 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48542 AND upper_hotkey_sid=3171 AND lower_hotkey_sid=3171 AND title_sid=3171 AND desc_sid=3171 AND cost=2 AND level_req=40 AND expansion=0 AND prev_id=48541 AND next_id=48543 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48542)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48542 AND ((slot=1 AND effect_id=5 AND base1=8 AND base2=0)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48542) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48542 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48543 AND upper_hotkey_sid=3171 AND lower_hotkey_sid=3171 AND title_sid=3171 AND desc_sid=3171 AND cost=2 AND level_req=45 AND expansion=0 AND prev_id=48542 AND next_id=48544 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48543)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48543 AND ((slot=1 AND effect_id=5 AND base1=10 AND base2=0)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48543) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48543 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ability WHERE id=48599 AND first_rank_id=48599 AND enabled=1 AND category=3 AND name='Mental Clarity')<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive root 48599 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48599 AND upper_hotkey_sid=3287 AND lower_hotkey_sid=3287 AND title_sid=3287 AND desc_sid=3287 AND cost=2 AND level_req=25 AND expansion=0 AND prev_id=-1 AND next_id=48600 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48599)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48599 AND ((slot=1 AND effect_id=15 AND base1=1 AND base2=0)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48599) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48599 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48600 AND upper_hotkey_sid=3287 AND lower_hotkey_sid=3287 AND title_sid=3287 AND desc_sid=3287 AND cost=2 AND level_req=30 AND expansion=0 AND prev_id=48599 AND next_id=48601 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48600)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48600 AND ((slot=1 AND effect_id=15 AND base1=2 AND base2=0)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48600) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48600 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48601 AND upper_hotkey_sid=3287 AND lower_hotkey_sid=3287 AND title_sid=3287 AND desc_sid=3287 AND cost=2 AND level_req=35 AND expansion=0 AND prev_id=48600 AND next_id=48602 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48601)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48601 AND ((slot=1 AND effect_id=15 AND base1=3 AND base2=0)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48601) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48601 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48602 AND upper_hotkey_sid=3287 AND lower_hotkey_sid=3287 AND title_sid=3287 AND desc_sid=3287 AND cost=4 AND level_req=40 AND expansion=0 AND prev_id=48601 AND next_id=48603 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48602)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48602 AND ((slot=1 AND effect_id=15 AND base1=4 AND base2=0)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48602) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48602 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48603 AND upper_hotkey_sid=3287 AND lower_hotkey_sid=3287 AND title_sid=3287 AND desc_sid=3287 AND cost=4 AND level_req=45 AND expansion=0 AND prev_id=48602 AND next_id=48604 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48603)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48603 AND ((slot=1 AND effect_id=15 AND base1=5 AND base2=0)))<>1 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48603) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48603 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ability WHERE id=48639 AND first_rank_id=48639 AND enabled=1 AND category=3 AND name='Improved Healing')<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive root 48639 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48639 AND upper_hotkey_sid=3347 AND lower_hotkey_sid=3347 AND title_sid=3347 AND desc_sid=3347 AND cost=1 AND level_req=20 AND expansion=0 AND prev_id=-1 AND next_id=48640 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48639)<>8 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48639 AND ((slot=1 AND effect_id=125 AND base1=5 AND base2=5) OR (slot=2 AND effect_id=137 AND base1=0 AND base2=0) OR (slot=3 AND effect_id=141 AND base1=1 AND base2=0) OR (slot=4 AND effect_id=138 AND base1=1 AND base2=0) OR (slot=5 AND effect_id=139 AND base1=-13 AND base2=0) OR (slot=6 AND effect_id=139 AND base1=-1292 AND base2=0) OR (slot=7 AND effect_id=137 AND base1=-147 AND base2=0) OR (slot=8 AND effect_id=311 AND base1=0 AND base2=0)))<>8 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48639) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48639 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48640 AND upper_hotkey_sid=3347 AND lower_hotkey_sid=3347 AND title_sid=3347 AND desc_sid=3347 AND cost=2 AND level_req=20 AND expansion=0 AND prev_id=48639 AND next_id=48641 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48640)<>8 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48640 AND ((slot=1 AND effect_id=125 AND base1=10 AND base2=10) OR (slot=2 AND effect_id=137 AND base1=0 AND base2=0) OR (slot=3 AND effect_id=141 AND base1=1 AND base2=0) OR (slot=4 AND effect_id=138 AND base1=1 AND base2=0) OR (slot=5 AND effect_id=139 AND base1=-13 AND base2=0) OR (slot=6 AND effect_id=139 AND base1=-1292 AND base2=0) OR (slot=7 AND effect_id=137 AND base1=-147 AND base2=0) OR (slot=8 AND effect_id=311 AND base1=0 AND base2=0)))<>8 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48640) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48640 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48641 AND upper_hotkey_sid=3347 AND lower_hotkey_sid=3347 AND title_sid=3347 AND desc_sid=3347 AND cost=3 AND level_req=20 AND expansion=0 AND prev_id=48640 AND next_id=48642 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48641)<>8 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48641 AND ((slot=1 AND effect_id=125 AND base1=15 AND base2=15) OR (slot=2 AND effect_id=137 AND base1=0 AND base2=0) OR (slot=3 AND effect_id=141 AND base1=1 AND base2=0) OR (slot=4 AND effect_id=138 AND base1=1 AND base2=0) OR (slot=5 AND effect_id=139 AND base1=-13 AND base2=0) OR (slot=6 AND effect_id=139 AND base1=-1292 AND base2=0) OR (slot=7 AND effect_id=137 AND base1=-147 AND base2=0) OR (slot=8 AND effect_id=311 AND base1=0 AND base2=0)))<>8 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48641) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48641 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48642 AND upper_hotkey_sid=3347 AND lower_hotkey_sid=3347 AND title_sid=3347 AND desc_sid=3347 AND cost=4 AND level_req=20 AND expansion=0 AND prev_id=48641 AND next_id=48643 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48642)<>8 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48642 AND ((slot=1 AND effect_id=125 AND base1=20 AND base2=20) OR (slot=2 AND effect_id=137 AND base1=0 AND base2=0) OR (slot=3 AND effect_id=141 AND base1=1 AND base2=0) OR (slot=4 AND effect_id=138 AND base1=1 AND base2=0) OR (slot=5 AND effect_id=139 AND base1=-13 AND base2=0) OR (slot=6 AND effect_id=139 AND base1=-1292 AND base2=0) OR (slot=7 AND effect_id=137 AND base1=-147 AND base2=0) OR (slot=8 AND effect_id=311 AND base1=0 AND base2=0)))<>8 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48642) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48642 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48643 AND upper_hotkey_sid=3347 AND lower_hotkey_sid=3347 AND title_sid=3347 AND desc_sid=3347 AND cost=6 AND level_req=55 AND expansion=0 AND prev_id=48642 AND next_id=48644 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48643)<>8 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48643 AND ((slot=1 AND effect_id=125 AND base1=25 AND base2=25) OR (slot=2 AND effect_id=137 AND base1=0 AND base2=0) OR (slot=3 AND effect_id=141 AND base1=1 AND base2=0) OR (slot=4 AND effect_id=138 AND base1=1 AND base2=0) OR (slot=5 AND effect_id=139 AND base1=-13 AND base2=0) OR (slot=6 AND effect_id=139 AND base1=-1292 AND base2=0) OR (slot=7 AND effect_id=137 AND base1=-147 AND base2=0) OR (slot=8 AND effect_id=311 AND base1=0 AND base2=0)))<>8 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48643) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48643 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ability WHERE id=48649 AND first_rank_id=48649 AND enabled=1 AND category=3 AND name='Spell Haste')<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive root 48649 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48649 AND upper_hotkey_sid=3357 AND lower_hotkey_sid=3357 AND title_sid=3357 AND desc_sid=3357 AND cost=2 AND level_req=20 AND expansion=0 AND prev_id=-1 AND next_id=48650 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48649)<>4 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48649 AND ((slot=1 AND effect_id=127 AND base1=5 AND base2=0) OR (slot=2 AND effect_id=139 AND base1=-13 AND base2=0) OR (slot=3 AND effect_id=143 AND base1=3000 AND base2=0) OR (slot=4 AND effect_id=311 AND base1=0 AND base2=0)))<>4 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48649) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48649 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48650 AND upper_hotkey_sid=3357 AND lower_hotkey_sid=3357 AND title_sid=3357 AND desc_sid=3357 AND cost=3 AND level_req=20 AND expansion=0 AND prev_id=48649 AND next_id=48651 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48650)<>4 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48650 AND ((slot=1 AND effect_id=127 AND base1=8 AND base2=0) OR (slot=2 AND effect_id=139 AND base1=-13 AND base2=0) OR (slot=3 AND effect_id=143 AND base1=3000 AND base2=0) OR (slot=4 AND effect_id=311 AND base1=0 AND base2=0)))<>4 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48650) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48650 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48651 AND upper_hotkey_sid=3357 AND lower_hotkey_sid=3357 AND title_sid=3357 AND desc_sid=3357 AND cost=4 AND level_req=20 AND expansion=0 AND prev_id=48650 AND next_id=48652 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48651)<>4 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48651 AND ((slot=1 AND effect_id=127 AND base1=10 AND base2=0) OR (slot=2 AND effect_id=139 AND base1=-13 AND base2=0) OR (slot=3 AND effect_id=143 AND base1=3000 AND base2=0) OR (slot=4 AND effect_id=311 AND base1=0 AND base2=0)))<>4 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48651) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48651 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48652 AND upper_hotkey_sid=3357 AND lower_hotkey_sid=3357 AND title_sid=3357 AND desc_sid=3357 AND cost=6 AND level_req=55 AND expansion=0 AND prev_id=48651 AND next_id=48653 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48652)<>4 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48652 AND ((slot=1 AND effect_id=127 AND base1=13 AND base2=0) OR (slot=2 AND effect_id=139 AND base1=-13 AND base2=0) OR (slot=3 AND effect_id=143 AND base1=3000 AND base2=0) OR (slot=4 AND effect_id=311 AND base1=0 AND base2=0)))<>4 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48652) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48652 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48653 AND upper_hotkey_sid=3357 AND lower_hotkey_sid=3357 AND title_sid=3357 AND desc_sid=3357 AND cost=8 AND level_req=55 AND expansion=0 AND prev_id=48652 AND next_id=48654 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48653)<>4 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48653 AND ((slot=1 AND effect_id=127 AND base1=15 AND base2=0) OR (slot=2 AND effect_id=139 AND base1=-13 AND base2=0) OR (slot=3 AND effect_id=143 AND base1=3000 AND base2=0) OR (slot=4 AND effect_id=311 AND base1=0 AND base2=0)))<>4 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48653) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48653 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ability WHERE id=48657 AND first_rank_id=48657 AND enabled=1 AND category=3 AND name='Mana Preservation')<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive root 48657 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48657 AND upper_hotkey_sid=3365 AND lower_hotkey_sid=3365 AND title_sid=3365 AND desc_sid=3365 AND cost=1 AND level_req=20 AND expansion=0 AND prev_id=-1 AND next_id=48658 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48657)<>3 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48657 AND ((slot=1 AND effect_id=132 AND base1=2 AND base2=2) OR (slot=2 AND effect_id=139 AND base1=-13 AND base2=0) OR (slot=3 AND effect_id=311 AND base1=0 AND base2=0)))<>3 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48657) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48657 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48658 AND upper_hotkey_sid=3365 AND lower_hotkey_sid=3365 AND title_sid=3365 AND desc_sid=3365 AND cost=2 AND level_req=20 AND expansion=0 AND prev_id=48657 AND next_id=48659 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48658)<>3 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48658 AND ((slot=1 AND effect_id=132 AND base1=4 AND base2=4) OR (slot=2 AND effect_id=139 AND base1=-13 AND base2=0) OR (slot=3 AND effect_id=311 AND base1=0 AND base2=0)))<>3 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48658) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48658 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48659 AND upper_hotkey_sid=3365 AND lower_hotkey_sid=3365 AND title_sid=3365 AND desc_sid=3365 AND cost=3 AND level_req=20 AND expansion=0 AND prev_id=48658 AND next_id=48660 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48659)<>3 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48659 AND ((slot=1 AND effect_id=132 AND base1=6 AND base2=6) OR (slot=2 AND effect_id=139 AND base1=-13 AND base2=0) OR (slot=3 AND effect_id=311 AND base1=0 AND base2=0)))<>3 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48659) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48659 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48660 AND upper_hotkey_sid=3365 AND lower_hotkey_sid=3365 AND title_sid=3365 AND desc_sid=3365 AND cost=4 AND level_req=20 AND expansion=0 AND prev_id=48659 AND next_id=48661 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48660)<>3 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48660 AND ((slot=1 AND effect_id=132 AND base1=8 AND base2=8) OR (slot=2 AND effect_id=139 AND base1=-13 AND base2=0) OR (slot=3 AND effect_id=311 AND base1=0 AND base2=0)))<>3 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48660) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48660 drift';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id=48661 AND upper_hotkey_sid=3365 AND lower_hotkey_sid=3365 AND title_sid=3365 AND desc_sid=3365 AND cost=6 AND level_req=55 AND expansion=0 AND prev_id=48660 AND next_id=48662 AND spell=-1)<>1 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48661)<>3 OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=48661 AND ((slot=1 AND effect_id=132 AND base1=10 AND base2=10) OR (slot=2 AND effect_id=139 AND base1=-13 AND base2=0) OR (slot=3 AND effect_id=311 AND base1=0 AND base2=0)))<>3 OR EXISTS(SELECT 1 FROM aa_rank_prereqs WHERE rank_id=48661) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall passive rank 48661 drift';
END IF;

IF (SELECT COUNT(*) FROM db_str WHERE id=4234 AND type=1 AND value='Enraged Shout')<>1 OR (SELECT COUNT(*) FROM db_str WHERE id=4234 AND type=4)<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall AA strings 4234 drift';
END IF;

IF (SELECT COUNT(*) FROM spells_new WHERE id=8255 AND name='Enraged Shout')<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall active source spell 8255 drift';
END IF;

IF (SELECT COUNT(*) FROM db_str WHERE id=13 AND type=1 AND value='Complete Heal')<>1 OR (SELECT COUNT(*) FROM db_str WHERE id=13 AND type=4)<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall AA strings 13 drift';
END IF;

IF (SELECT COUNT(*) FROM spells_new WHERE id=13 AND name='Complete Heal')<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall active source spell 13 drift';
END IF;

IF (SELECT COUNT(*) FROM spells_new WHERE id=5259 AND name='Pious Elixir')<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall active source spell 5259 drift';
END IF;

IF (SELECT COUNT(*) FROM db_str WHERE id=4228 AND type=1 AND value='Soul Reprisal')<>1 OR (SELECT COUNT(*) FROM db_str WHERE id=4228 AND type=4)<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall AA strings 4228 drift';
END IF;

IF (SELECT COUNT(*) FROM spells_new WHERE id=8249 AND name='Soul Reprisal')<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall active source spell 8249 drift';
END IF;

IF (SELECT COUNT(*) FROM db_str WHERE id=459 AND type=1 AND value='Radiant Cure')<>1 OR (SELECT COUNT(*) FROM db_str WHERE id=459 AND type=4)<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall AA strings 459 drift';
END IF;

IF (SELECT COUNT(*) FROM spells_new WHERE id=3299 AND name='Radiant Cure')<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall active source spell 3299 drift';
END IF;

IF (SELECT COUNT(*) FROM db_str WHERE id=4232 AND type=1 AND value='Darkflame')<>1 OR (SELECT COUNT(*) FROM db_str WHERE id=4232 AND type=4)<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall AA strings 4232 drift';
END IF;

IF (SELECT COUNT(*) FROM spells_new WHERE id=8253 AND name='Darkflame')<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall active source spell 8253 drift';
END IF;

IF (SELECT COUNT(*) FROM db_str WHERE id=4229 AND type=1 AND value='Deepspite')<>1 OR (SELECT COUNT(*) FROM db_str WHERE id=4229 AND type=4)<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall AA strings 4229 drift';
END IF;

IF (SELECT COUNT(*) FROM spells_new WHERE id=8250 AND name='Deepspite')<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall active source spell 8250 drift';
END IF;

IF (SELECT COUNT(*) FROM db_str WHERE id=4233 AND type=1 AND value='Lightfade')<>1 OR (SELECT COUNT(*) FROM db_str WHERE id=4233 AND type=4)<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall AA strings 4233 drift';
END IF;

IF (SELECT COUNT(*) FROM spells_new WHERE id=8254 AND name='Lightfade')<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall active source spell 8254 drift';
END IF;

IF (SELECT COUNT(*) FROM db_str WHERE id=4231 AND type=1 AND value='Draygun''s Psyche')<>1 OR (SELECT COUNT(*) FROM db_str WHERE id=4231 AND type=4)<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall AA strings 4231 drift';
END IF;

IF (SELECT COUNT(*) FROM spells_new WHERE id=8252 AND name='Draygun''s Psyche')<>1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall active source spell 8252 drift';
END IF;

INSERT INTO `items` (`id`,`minstatus`,`Name`,`aagi`,`ac`,`accuracy`,`acha`,`adex`,`aint`,`artifactflag`,`asta`,`astr`,`attack`,`augrestrict`,`augslot1type`,`augslot1visible`,`augslot2type`,`augslot2visible`,`augslot3type`,`augslot3visible`,`augslot4type`,`augslot4visible`,`augslot5type`,`augslot5visible`,`augslot6type`,`augslot6visible`,`augtype`,`avoidance`,`awis`,`bagsize`,`bagslots`,`bagtype`,`bagwr`,`banedmgamt`,`banedmgraceamt`,`banedmgbody`,`banedmgrace`,`bardtype`,`bardvalue`,`book`,`casttime`,`casttime_`,`charmfile`,`charmfileid`,`classes`,`color`,`combateffects`,`extradmgskill`,`extradmgamt`,`price`,`cr`,`damage`,`damageshield`,`deity`,`delay`,`augdistiller`,`dotshielding`,`dr`,`clicktype`,`clicklevel2`,`elemdmgtype`,`elemdmgamt`,`endur`,`factionamt1`,`factionamt2`,`factionamt3`,`factionamt4`,`factionmod1`,`factionmod2`,`factionmod3`,`factionmod4`,`filename`,`focuseffect`,`fr`,`fvnodrop`,`haste`,`clicklevel`,`hp`,`regen`,`icon`,`idfile`,`itemclass`,`itemtype`,`ldonprice`,`ldontheme`,`ldonsold`,`light`,`lore`,`loregroup`,`magic`,`mana`,`manaregen`,`enduranceregen`,`material`,`herosforgemodel`,`maxcharges`,`mr`,`nodrop`,`norent`,`pendingloreflag`,`pr`,`procrate`,`races`,`range`,`reclevel`,`recskill`,`reqlevel`,`sellrate`,`shielding`,`size`,`skillmodtype`,`skillmodvalue`,`slots`,`clickeffect`,`spellshield`,`strikethrough`,`stunresist`,`summonedflag`,`tradeskills`,`favor`,`weight`,`UNK012`,`UNK013`,`benefitflag`,`UNK054`,`UNK059`,`booktype`,`recastdelay`,`recasttype`,`guildfavor`,`UNK123`,`UNK124`,`attuneable`,`nopet`,`updated`,`comment`,`UNK127`,`pointtype`,`potionbelt`,`potionbeltslots`,`stacksize`,`notransfer`,`stackable`,`UNK134`,`UNK137`,`proceffect`,`proctype`,`proclevel2`,`proclevel`,`UNK142`,`worneffect`,`worntype`,`wornlevel2`,`wornlevel`,`UNK147`,`focustype`,`focuslevel2`,`focuslevel`,`UNK152`,`scrolleffect`,`scrolltype`,`scrolllevel2`,`scrolllevel`,`UNK157`,`serialized`,`verified`,`serialization`,`source`,`UNK033`,`lorefile`,`UNK014`,`svcorruption`,`skillmodmax`,`UNK060`,`augslot1unk2`,`augslot2unk2`,`augslot3unk2`,`augslot4unk2`,`augslot5unk2`,`augslot6unk2`,`UNK120`,`UNK121`,`questitemflag`,`UNK132`,`clickunk5`,`clickunk6`,`clickunk7`,`procunk1`,`procunk2`,`procunk3`,`procunk4`,`procunk6`,`procunk7`,`wornunk1`,`wornunk2`,`wornunk3`,`wornunk4`,`wornunk5`,`wornunk6`,`wornunk7`,`focusunk1`,`focusunk2`,`focusunk3`,`focusunk4`,`focusunk5`,`focusunk6`,`focusunk7`,`scrollunk1`,`scrollunk2`,`scrollunk3`,`scrollunk4`,`scrollunk5`,`scrollunk6`,`scrollunk7`,`UNK193`,`purity`,`evoitem`,`evoid`,`evolvinglevel`,`evomax`,`clickname`,`procname`,`wornname`,`focusname`,`scrollname`,`dsmitigation`,`heroic_str`,`heroic_int`,`heroic_wis`,`heroic_agi`,`heroic_dex`,`heroic_sta`,`heroic_cha`,`heroic_pr`,`heroic_dr`,`heroic_fr`,`heroic_cr`,`heroic_mr`,`heroic_svcorrup`,`healamt`,`spelldmg`,`clairvoyance`,`backstabdmg`,`created`,`elitematerial`,`ldonsellbackrate`,`scriptfileid`,`expendablearrow`,`powersourcecapacity`,`bardeffect`,`bardeffecttype`,`bardlevel2`,`bardlevel`,`bardunk1`,`bardunk2`,`bardunk3`,`bardunk4`,`bardunk5`,`bardname`,`bardunk7`,`UNK214`,`subtype`,`UNK220`,`UNK221`,`heirloom`,`UNK223`,`UNK224`,`UNK225`,`UNK226`,`UNK227`,`UNK228`,`UNK229`,`UNK230`,`UNK231`,`UNK232`,`UNK233`,`UNK234`,`placeable`,`UNK236`,`UNK237`,`UNK238`,`UNK239`,`UNK240`,`UNK241`,`epicitem`,`housing_disable_rotation`,`housing_disable_free_placement`)
SELECT 900100,`minstatus`,`Name`,`aagi`,`ac`,`accuracy`,`acha`,`adex`,`aint`,`artifactflag`,`asta`,`astr`,`attack`,`augrestrict`,`augslot1type`,`augslot1visible`,`augslot2type`,`augslot2visible`,`augslot3type`,`augslot3visible`,`augslot4type`,`augslot4visible`,`augslot5type`,`augslot5visible`,`augslot6type`,`augslot6visible`,`augtype`,`avoidance`,`awis`,`bagsize`,`bagslots`,`bagtype`,`bagwr`,`banedmgamt`,`banedmgraceamt`,`banedmgbody`,`banedmgrace`,`bardtype`,`bardvalue`,`book`,`casttime`,`casttime_`,`charmfile`,`charmfileid`,1,`color`,`combateffects`,`extradmgskill`,`extradmgamt`,`price`,`cr`,`damage`,`damageshield`,`deity`,`delay`,`augdistiller`,`dotshielding`,`dr`,`clicktype`,`clicklevel2`,`elemdmgtype`,`elemdmgamt`,`endur`,`factionamt1`,`factionamt2`,`factionamt3`,`factionamt4`,`factionmod1`,`factionmod2`,`factionmod3`,`factionmod4`,`filename`,`focuseffect`,`fr`,`fvnodrop`,`haste`,`clicklevel`,`hp`,`regen`,`icon`,`idfile`,`itemclass`,`itemtype`,`ldonprice`,`ldontheme`,`ldonsold`,`light`,`lore`,`loregroup`,`magic`,`mana`,`manaregen`,`enduranceregen`,`material`,`herosforgemodel`,`maxcharges`,`mr`,`nodrop`,`norent`,`pendingloreflag`,`pr`,`procrate`,65535,`range`,`reclevel`,`recskill`,`reqlevel`,`sellrate`,`shielding`,`size`,`skillmodtype`,`skillmodvalue`,`slots`,`clickeffect`,`spellshield`,`strikethrough`,`stunresist`,`summonedflag`,`tradeskills`,`favor`,`weight`,`UNK012`,`UNK013`,`benefitflag`,`UNK054`,`UNK059`,`booktype`,`recastdelay`,`recasttype`,`guildfavor`,`UNK123`,`UNK124`,`attuneable`,`nopet`,`updated`,`comment`,`UNK127`,`pointtype`,`potionbelt`,`potionbeltslots`,`stacksize`,`notransfer`,`stackable`,`UNK134`,`UNK137`,`proceffect`,`proctype`,`proclevel2`,`proclevel`,`UNK142`,`worneffect`,`worntype`,`wornlevel2`,`wornlevel`,`UNK147`,`focustype`,`focuslevel2`,`focuslevel`,`UNK152`,`scrolleffect`,`scrolltype`,`scrolllevel2`,`scrolllevel`,`UNK157`,`serialized`,`verified`,`serialization`,`source`,`UNK033`,`lorefile`,`UNK014`,`svcorruption`,`skillmodmax`,`UNK060`,`augslot1unk2`,`augslot2unk2`,`augslot3unk2`,`augslot4unk2`,`augslot5unk2`,`augslot6unk2`,`UNK120`,`UNK121`,`questitemflag`,`UNK132`,`clickunk5`,`clickunk6`,`clickunk7`,`procunk1`,`procunk2`,`procunk3`,`procunk4`,`procunk6`,`procunk7`,`wornunk1`,`wornunk2`,`wornunk3`,`wornunk4`,`wornunk5`,`wornunk6`,`wornunk7`,`focusunk1`,`focusunk2`,`focusunk3`,`focusunk4`,`focusunk5`,`focusunk6`,`focusunk7`,`scrollunk1`,`scrollunk2`,`scrollunk3`,`scrollunk4`,`scrollunk5`,`scrollunk6`,`scrollunk7`,`UNK193`,`purity`,`evoitem`,`evoid`,`evolvinglevel`,`evomax`,`clickname`,`procname`,`wornname`,`focusname`,`scrollname`,`dsmitigation`,`heroic_str`,`heroic_int`,`heroic_wis`,`heroic_agi`,`heroic_dex`,`heroic_sta`,`heroic_cha`,`heroic_pr`,`heroic_dr`,`heroic_fr`,`heroic_cr`,`heroic_mr`,`heroic_svcorrup`,`healamt`,`spelldmg`,`clairvoyance`,`backstabdmg`,`created`,`elitematerial`,`ldonsellbackrate`,`scriptfileid`,`expendablearrow`,`powersourcecapacity`,`bardeffect`,`bardeffecttype`,`bardlevel2`,`bardlevel`,`bardunk1`,`bardunk2`,`bardunk3`,`bardunk4`,`bardunk5`,`bardname`,`bardunk7`,`UNK214`,`subtype`,`UNK220`,`UNK221`,`heirloom`,`UNK223`,`UNK224`,`UNK225`,`UNK226`,`UNK227`,`UNK228`,`UNK229`,`UNK230`,`UNK231`,`UNK232`,`UNK233`,`UNK234`,`placeable`,`UNK236`,`UNK237`,`UNK238`,`UNK239`,`UNK240`,`UNK241`,`epicitem`,`housing_disable_rotation`,`housing_disable_free_placement` FROM `items` WHERE id=85538;

INSERT INTO `items` (`id`,`minstatus`,`Name`,`aagi`,`ac`,`accuracy`,`acha`,`adex`,`aint`,`artifactflag`,`asta`,`astr`,`attack`,`augrestrict`,`augslot1type`,`augslot1visible`,`augslot2type`,`augslot2visible`,`augslot3type`,`augslot3visible`,`augslot4type`,`augslot4visible`,`augslot5type`,`augslot5visible`,`augslot6type`,`augslot6visible`,`augtype`,`avoidance`,`awis`,`bagsize`,`bagslots`,`bagtype`,`bagwr`,`banedmgamt`,`banedmgraceamt`,`banedmgbody`,`banedmgrace`,`bardtype`,`bardvalue`,`book`,`casttime`,`casttime_`,`charmfile`,`charmfileid`,`classes`,`color`,`combateffects`,`extradmgskill`,`extradmgamt`,`price`,`cr`,`damage`,`damageshield`,`deity`,`delay`,`augdistiller`,`dotshielding`,`dr`,`clicktype`,`clicklevel2`,`elemdmgtype`,`elemdmgamt`,`endur`,`factionamt1`,`factionamt2`,`factionamt3`,`factionamt4`,`factionmod1`,`factionmod2`,`factionmod3`,`factionmod4`,`filename`,`focuseffect`,`fr`,`fvnodrop`,`haste`,`clicklevel`,`hp`,`regen`,`icon`,`idfile`,`itemclass`,`itemtype`,`ldonprice`,`ldontheme`,`ldonsold`,`light`,`lore`,`loregroup`,`magic`,`mana`,`manaregen`,`enduranceregen`,`material`,`herosforgemodel`,`maxcharges`,`mr`,`nodrop`,`norent`,`pendingloreflag`,`pr`,`procrate`,`races`,`range`,`reclevel`,`recskill`,`reqlevel`,`sellrate`,`shielding`,`size`,`skillmodtype`,`skillmodvalue`,`slots`,`clickeffect`,`spellshield`,`strikethrough`,`stunresist`,`summonedflag`,`tradeskills`,`favor`,`weight`,`UNK012`,`UNK013`,`benefitflag`,`UNK054`,`UNK059`,`booktype`,`recastdelay`,`recasttype`,`guildfavor`,`UNK123`,`UNK124`,`attuneable`,`nopet`,`updated`,`comment`,`UNK127`,`pointtype`,`potionbelt`,`potionbeltslots`,`stacksize`,`notransfer`,`stackable`,`UNK134`,`UNK137`,`proceffect`,`proctype`,`proclevel2`,`proclevel`,`UNK142`,`worneffect`,`worntype`,`wornlevel2`,`wornlevel`,`UNK147`,`focustype`,`focuslevel2`,`focuslevel`,`UNK152`,`scrolleffect`,`scrolltype`,`scrolllevel2`,`scrolllevel`,`UNK157`,`serialized`,`verified`,`serialization`,`source`,`UNK033`,`lorefile`,`UNK014`,`svcorruption`,`skillmodmax`,`UNK060`,`augslot1unk2`,`augslot2unk2`,`augslot3unk2`,`augslot4unk2`,`augslot5unk2`,`augslot6unk2`,`UNK120`,`UNK121`,`questitemflag`,`UNK132`,`clickunk5`,`clickunk6`,`clickunk7`,`procunk1`,`procunk2`,`procunk3`,`procunk4`,`procunk6`,`procunk7`,`wornunk1`,`wornunk2`,`wornunk3`,`wornunk4`,`wornunk5`,`wornunk6`,`wornunk7`,`focusunk1`,`focusunk2`,`focusunk3`,`focusunk4`,`focusunk5`,`focusunk6`,`focusunk7`,`scrollunk1`,`scrollunk2`,`scrollunk3`,`scrollunk4`,`scrollunk5`,`scrollunk6`,`scrollunk7`,`UNK193`,`purity`,`evoitem`,`evoid`,`evolvinglevel`,`evomax`,`clickname`,`procname`,`wornname`,`focusname`,`scrollname`,`dsmitigation`,`heroic_str`,`heroic_int`,`heroic_wis`,`heroic_agi`,`heroic_dex`,`heroic_sta`,`heroic_cha`,`heroic_pr`,`heroic_dr`,`heroic_fr`,`heroic_cr`,`heroic_mr`,`heroic_svcorrup`,`healamt`,`spelldmg`,`clairvoyance`,`backstabdmg`,`created`,`elitematerial`,`ldonsellbackrate`,`scriptfileid`,`expendablearrow`,`powersourcecapacity`,`bardeffect`,`bardeffecttype`,`bardlevel2`,`bardlevel`,`bardunk1`,`bardunk2`,`bardunk3`,`bardunk4`,`bardunk5`,`bardname`,`bardunk7`,`UNK214`,`subtype`,`UNK220`,`UNK221`,`heirloom`,`UNK223`,`UNK224`,`UNK225`,`UNK226`,`UNK227`,`UNK228`,`UNK229`,`UNK230`,`UNK231`,`UNK232`,`UNK233`,`UNK234`,`placeable`,`UNK236`,`UNK237`,`UNK238`,`UNK239`,`UNK240`,`UNK241`,`epicitem`,`housing_disable_rotation`,`housing_disable_free_placement`)
SELECT 900101,`minstatus`,`Name`,`aagi`,`ac`,`accuracy`,`acha`,`adex`,`aint`,`artifactflag`,`asta`,`astr`,`attack`,`augrestrict`,`augslot1type`,`augslot1visible`,`augslot2type`,`augslot2visible`,`augslot3type`,`augslot3visible`,`augslot4type`,`augslot4visible`,`augslot5type`,`augslot5visible`,`augslot6type`,`augslot6visible`,`augtype`,`avoidance`,`awis`,`bagsize`,`bagslots`,`bagtype`,`bagwr`,`banedmgamt`,`banedmgraceamt`,`banedmgbody`,`banedmgrace`,`bardtype`,`bardvalue`,`book`,`casttime`,`casttime_`,`charmfile`,`charmfileid`,256,`color`,`combateffects`,`extradmgskill`,`extradmgamt`,`price`,`cr`,`damage`,`damageshield`,`deity`,`delay`,`augdistiller`,`dotshielding`,`dr`,`clicktype`,`clicklevel2`,`elemdmgtype`,`elemdmgamt`,`endur`,`factionamt1`,`factionamt2`,`factionamt3`,`factionamt4`,`factionmod1`,`factionmod2`,`factionmod3`,`factionmod4`,`filename`,`focuseffect`,`fr`,`fvnodrop`,`haste`,`clicklevel`,`hp`,`regen`,`icon`,`idfile`,`itemclass`,`itemtype`,`ldonprice`,`ldontheme`,`ldonsold`,`light`,`lore`,`loregroup`,`magic`,`mana`,`manaregen`,`enduranceregen`,`material`,`herosforgemodel`,`maxcharges`,`mr`,`nodrop`,`norent`,`pendingloreflag`,`pr`,`procrate`,65535,`range`,`reclevel`,`recskill`,`reqlevel`,`sellrate`,`shielding`,`size`,`skillmodtype`,`skillmodvalue`,`slots`,`clickeffect`,`spellshield`,`strikethrough`,`stunresist`,`summonedflag`,`tradeskills`,`favor`,`weight`,`UNK012`,`UNK013`,`benefitflag`,`UNK054`,`UNK059`,`booktype`,`recastdelay`,`recasttype`,`guildfavor`,`UNK123`,`UNK124`,`attuneable`,`nopet`,`updated`,`comment`,`UNK127`,`pointtype`,`potionbelt`,`potionbeltslots`,`stacksize`,`notransfer`,`stackable`,`UNK134`,`UNK137`,`proceffect`,`proctype`,`proclevel2`,`proclevel`,`UNK142`,`worneffect`,`worntype`,`wornlevel2`,`wornlevel`,`UNK147`,`focustype`,`focuslevel2`,`focuslevel`,`UNK152`,`scrolleffect`,`scrolltype`,`scrolllevel2`,`scrolllevel`,`UNK157`,`serialized`,`verified`,`serialization`,`source`,`UNK033`,`lorefile`,`UNK014`,`svcorruption`,`skillmodmax`,`UNK060`,`augslot1unk2`,`augslot2unk2`,`augslot3unk2`,`augslot4unk2`,`augslot5unk2`,`augslot6unk2`,`UNK120`,`UNK121`,`questitemflag`,`UNK132`,`clickunk5`,`clickunk6`,`clickunk7`,`procunk1`,`procunk2`,`procunk3`,`procunk4`,`procunk6`,`procunk7`,`wornunk1`,`wornunk2`,`wornunk3`,`wornunk4`,`wornunk5`,`wornunk6`,`wornunk7`,`focusunk1`,`focusunk2`,`focusunk3`,`focusunk4`,`focusunk5`,`focusunk6`,`focusunk7`,`scrollunk1`,`scrollunk2`,`scrollunk3`,`scrollunk4`,`scrollunk5`,`scrollunk6`,`scrollunk7`,`UNK193`,`purity`,`evoitem`,`evoid`,`evolvinglevel`,`evomax`,`clickname`,`procname`,`wornname`,`focusname`,`scrollname`,`dsmitigation`,`heroic_str`,`heroic_int`,`heroic_wis`,`heroic_agi`,`heroic_dex`,`heroic_sta`,`heroic_cha`,`heroic_pr`,`heroic_dr`,`heroic_fr`,`heroic_cr`,`heroic_mr`,`heroic_svcorrup`,`healamt`,`spelldmg`,`clairvoyance`,`backstabdmg`,`created`,`elitematerial`,`ldonsellbackrate`,`scriptfileid`,`expendablearrow`,`powersourcecapacity`,`bardeffect`,`bardeffecttype`,`bardlevel2`,`bardlevel`,`bardunk1`,`bardunk2`,`bardunk3`,`bardunk4`,`bardunk5`,`bardname`,`bardunk7`,`UNK214`,`subtype`,`UNK220`,`UNK221`,`heirloom`,`UNK223`,`UNK224`,`UNK225`,`UNK226`,`UNK227`,`UNK228`,`UNK229`,`UNK230`,`UNK231`,`UNK232`,`UNK233`,`UNK234`,`placeable`,`UNK236`,`UNK237`,`UNK238`,`UNK239`,`UNK240`,`UNK241`,`epicitem`,`housing_disable_rotation`,`housing_disable_free_placement` FROM `items` WHERE id=85539;

INSERT INTO `items` (`id`,`minstatus`,`Name`,`aagi`,`ac`,`accuracy`,`acha`,`adex`,`aint`,`artifactflag`,`asta`,`astr`,`attack`,`augrestrict`,`augslot1type`,`augslot1visible`,`augslot2type`,`augslot2visible`,`augslot3type`,`augslot3visible`,`augslot4type`,`augslot4visible`,`augslot5type`,`augslot5visible`,`augslot6type`,`augslot6visible`,`augtype`,`avoidance`,`awis`,`bagsize`,`bagslots`,`bagtype`,`bagwr`,`banedmgamt`,`banedmgraceamt`,`banedmgbody`,`banedmgrace`,`bardtype`,`bardvalue`,`book`,`casttime`,`casttime_`,`charmfile`,`charmfileid`,`classes`,`color`,`combateffects`,`extradmgskill`,`extradmgamt`,`price`,`cr`,`damage`,`damageshield`,`deity`,`delay`,`augdistiller`,`dotshielding`,`dr`,`clicktype`,`clicklevel2`,`elemdmgtype`,`elemdmgamt`,`endur`,`factionamt1`,`factionamt2`,`factionamt3`,`factionamt4`,`factionmod1`,`factionmod2`,`factionmod3`,`factionmod4`,`filename`,`focuseffect`,`fr`,`fvnodrop`,`haste`,`clicklevel`,`hp`,`regen`,`icon`,`idfile`,`itemclass`,`itemtype`,`ldonprice`,`ldontheme`,`ldonsold`,`light`,`lore`,`loregroup`,`magic`,`mana`,`manaregen`,`enduranceregen`,`material`,`herosforgemodel`,`maxcharges`,`mr`,`nodrop`,`norent`,`pendingloreflag`,`pr`,`procrate`,`races`,`range`,`reclevel`,`recskill`,`reqlevel`,`sellrate`,`shielding`,`size`,`skillmodtype`,`skillmodvalue`,`slots`,`clickeffect`,`spellshield`,`strikethrough`,`stunresist`,`summonedflag`,`tradeskills`,`favor`,`weight`,`UNK012`,`UNK013`,`benefitflag`,`UNK054`,`UNK059`,`booktype`,`recastdelay`,`recasttype`,`guildfavor`,`UNK123`,`UNK124`,`attuneable`,`nopet`,`updated`,`comment`,`UNK127`,`pointtype`,`potionbelt`,`potionbeltslots`,`stacksize`,`notransfer`,`stackable`,`UNK134`,`UNK137`,`proceffect`,`proctype`,`proclevel2`,`proclevel`,`UNK142`,`worneffect`,`worntype`,`wornlevel2`,`wornlevel`,`UNK147`,`focustype`,`focuslevel2`,`focuslevel`,`UNK152`,`scrolleffect`,`scrolltype`,`scrolllevel2`,`scrolllevel`,`UNK157`,`serialized`,`verified`,`serialization`,`source`,`UNK033`,`lorefile`,`UNK014`,`svcorruption`,`skillmodmax`,`UNK060`,`augslot1unk2`,`augslot2unk2`,`augslot3unk2`,`augslot4unk2`,`augslot5unk2`,`augslot6unk2`,`UNK120`,`UNK121`,`questitemflag`,`UNK132`,`clickunk5`,`clickunk6`,`clickunk7`,`procunk1`,`procunk2`,`procunk3`,`procunk4`,`procunk6`,`procunk7`,`wornunk1`,`wornunk2`,`wornunk3`,`wornunk4`,`wornunk5`,`wornunk6`,`wornunk7`,`focusunk1`,`focusunk2`,`focusunk3`,`focusunk4`,`focusunk5`,`focusunk6`,`focusunk7`,`scrollunk1`,`scrollunk2`,`scrollunk3`,`scrollunk4`,`scrollunk5`,`scrollunk6`,`scrollunk7`,`UNK193`,`purity`,`evoitem`,`evoid`,`evolvinglevel`,`evomax`,`clickname`,`procname`,`wornname`,`focusname`,`scrollname`,`dsmitigation`,`heroic_str`,`heroic_int`,`heroic_wis`,`heroic_agi`,`heroic_dex`,`heroic_sta`,`heroic_cha`,`heroic_pr`,`heroic_dr`,`heroic_fr`,`heroic_cr`,`heroic_mr`,`heroic_svcorrup`,`healamt`,`spelldmg`,`clairvoyance`,`backstabdmg`,`created`,`elitematerial`,`ldonsellbackrate`,`scriptfileid`,`expendablearrow`,`powersourcecapacity`,`bardeffect`,`bardeffecttype`,`bardlevel2`,`bardlevel`,`bardunk1`,`bardunk2`,`bardunk3`,`bardunk4`,`bardunk5`,`bardname`,`bardunk7`,`UNK214`,`subtype`,`UNK220`,`UNK221`,`heirloom`,`UNK223`,`UNK224`,`UNK225`,`UNK226`,`UNK227`,`UNK228`,`UNK229`,`UNK230`,`UNK231`,`UNK232`,`UNK233`,`UNK234`,`placeable`,`UNK236`,`UNK237`,`UNK238`,`UNK239`,`UNK240`,`UNK241`,`epicitem`,`housing_disable_rotation`,`housing_disable_free_placement`)
SELECT 900102,`minstatus`,`Name`,`aagi`,`ac`,`accuracy`,`acha`,`adex`,`aint`,`artifactflag`,`asta`,`astr`,`attack`,`augrestrict`,`augslot1type`,`augslot1visible`,`augslot2type`,`augslot2visible`,`augslot3type`,`augslot3visible`,`augslot4type`,`augslot4visible`,`augslot5type`,`augslot5visible`,`augslot6type`,`augslot6visible`,`augtype`,`avoidance`,`awis`,`bagsize`,`bagslots`,`bagtype`,`bagwr`,`banedmgamt`,`banedmgraceamt`,`banedmgbody`,`banedmgrace`,`bardtype`,`bardvalue`,`book`,`casttime`,`casttime_`,`charmfile`,`charmfileid`,256,`color`,`combateffects`,`extradmgskill`,`extradmgamt`,`price`,`cr`,`damage`,`damageshield`,`deity`,`delay`,`augdistiller`,`dotshielding`,`dr`,`clicktype`,`clicklevel2`,`elemdmgtype`,`elemdmgamt`,`endur`,`factionamt1`,`factionamt2`,`factionamt3`,`factionamt4`,`factionmod1`,`factionmod2`,`factionmod3`,`factionmod4`,`filename`,`focuseffect`,`fr`,`fvnodrop`,`haste`,`clicklevel`,`hp`,`regen`,`icon`,`idfile`,`itemclass`,`itemtype`,`ldonprice`,`ldontheme`,`ldonsold`,`light`,`lore`,`loregroup`,`magic`,`mana`,`manaregen`,`enduranceregen`,`material`,`herosforgemodel`,`maxcharges`,`mr`,`nodrop`,`norent`,`pendingloreflag`,`pr`,`procrate`,65535,`range`,`reclevel`,`recskill`,`reqlevel`,`sellrate`,`shielding`,`size`,`skillmodtype`,`skillmodvalue`,`slots`,`clickeffect`,`spellshield`,`strikethrough`,`stunresist`,`summonedflag`,`tradeskills`,`favor`,`weight`,`UNK012`,`UNK013`,`benefitflag`,`UNK054`,`UNK059`,`booktype`,`recastdelay`,`recasttype`,`guildfavor`,`UNK123`,`UNK124`,`attuneable`,`nopet`,`updated`,`comment`,`UNK127`,`pointtype`,`potionbelt`,`potionbeltslots`,`stacksize`,`notransfer`,`stackable`,`UNK134`,`UNK137`,`proceffect`,`proctype`,`proclevel2`,`proclevel`,`UNK142`,`worneffect`,`worntype`,`wornlevel2`,`wornlevel`,`UNK147`,`focustype`,`focuslevel2`,`focuslevel`,`UNK152`,`scrolleffect`,`scrolltype`,`scrolllevel2`,`scrolllevel`,`UNK157`,`serialized`,`verified`,`serialization`,`source`,`UNK033`,`lorefile`,`UNK014`,`svcorruption`,`skillmodmax`,`UNK060`,`augslot1unk2`,`augslot2unk2`,`augslot3unk2`,`augslot4unk2`,`augslot5unk2`,`augslot6unk2`,`UNK120`,`UNK121`,`questitemflag`,`UNK132`,`clickunk5`,`clickunk6`,`clickunk7`,`procunk1`,`procunk2`,`procunk3`,`procunk4`,`procunk6`,`procunk7`,`wornunk1`,`wornunk2`,`wornunk3`,`wornunk4`,`wornunk5`,`wornunk6`,`wornunk7`,`focusunk1`,`focusunk2`,`focusunk3`,`focusunk4`,`focusunk5`,`focusunk6`,`focusunk7`,`scrollunk1`,`scrollunk2`,`scrollunk3`,`scrollunk4`,`scrollunk5`,`scrollunk6`,`scrollunk7`,`UNK193`,`purity`,`evoitem`,`evoid`,`evolvinglevel`,`evomax`,`clickname`,`procname`,`wornname`,`focusname`,`scrollname`,`dsmitigation`,`heroic_str`,`heroic_int`,`heroic_wis`,`heroic_agi`,`heroic_dex`,`heroic_sta`,`heroic_cha`,`heroic_pr`,`heroic_dr`,`heroic_fr`,`heroic_cr`,`heroic_mr`,`heroic_svcorrup`,`healamt`,`spelldmg`,`clairvoyance`,`backstabdmg`,`created`,`elitematerial`,`ldonsellbackrate`,`scriptfileid`,`expendablearrow`,`powersourcecapacity`,`bardeffect`,`bardeffecttype`,`bardlevel2`,`bardlevel`,`bardunk1`,`bardunk2`,`bardunk3`,`bardunk4`,`bardunk5`,`bardname`,`bardunk7`,`UNK214`,`subtype`,`UNK220`,`UNK221`,`heirloom`,`UNK223`,`UNK224`,`UNK225`,`UNK226`,`UNK227`,`UNK228`,`UNK229`,`UNK230`,`UNK231`,`UNK232`,`UNK233`,`UNK234`,`placeable`,`UNK236`,`UNK237`,`UNK238`,`UNK239`,`UNK240`,`UNK241`,`epicitem`,`housing_disable_rotation`,`housing_disable_free_placement` FROM `items` WHERE id=85540;

INSERT INTO `items` (`id`,`minstatus`,`Name`,`aagi`,`ac`,`accuracy`,`acha`,`adex`,`aint`,`artifactflag`,`asta`,`astr`,`attack`,`augrestrict`,`augslot1type`,`augslot1visible`,`augslot2type`,`augslot2visible`,`augslot3type`,`augslot3visible`,`augslot4type`,`augslot4visible`,`augslot5type`,`augslot5visible`,`augslot6type`,`augslot6visible`,`augtype`,`avoidance`,`awis`,`bagsize`,`bagslots`,`bagtype`,`bagwr`,`banedmgamt`,`banedmgraceamt`,`banedmgbody`,`banedmgrace`,`bardtype`,`bardvalue`,`book`,`casttime`,`casttime_`,`charmfile`,`charmfileid`,`classes`,`color`,`combateffects`,`extradmgskill`,`extradmgamt`,`price`,`cr`,`damage`,`damageshield`,`deity`,`delay`,`augdistiller`,`dotshielding`,`dr`,`clicktype`,`clicklevel2`,`elemdmgtype`,`elemdmgamt`,`endur`,`factionamt1`,`factionamt2`,`factionamt3`,`factionamt4`,`factionmod1`,`factionmod2`,`factionmod3`,`factionmod4`,`filename`,`focuseffect`,`fr`,`fvnodrop`,`haste`,`clicklevel`,`hp`,`regen`,`icon`,`idfile`,`itemclass`,`itemtype`,`ldonprice`,`ldontheme`,`ldonsold`,`light`,`lore`,`loregroup`,`magic`,`mana`,`manaregen`,`enduranceregen`,`material`,`herosforgemodel`,`maxcharges`,`mr`,`nodrop`,`norent`,`pendingloreflag`,`pr`,`procrate`,`races`,`range`,`reclevel`,`recskill`,`reqlevel`,`sellrate`,`shielding`,`size`,`skillmodtype`,`skillmodvalue`,`slots`,`clickeffect`,`spellshield`,`strikethrough`,`stunresist`,`summonedflag`,`tradeskills`,`favor`,`weight`,`UNK012`,`UNK013`,`benefitflag`,`UNK054`,`UNK059`,`booktype`,`recastdelay`,`recasttype`,`guildfavor`,`UNK123`,`UNK124`,`attuneable`,`nopet`,`updated`,`comment`,`UNK127`,`pointtype`,`potionbelt`,`potionbeltslots`,`stacksize`,`notransfer`,`stackable`,`UNK134`,`UNK137`,`proceffect`,`proctype`,`proclevel2`,`proclevel`,`UNK142`,`worneffect`,`worntype`,`wornlevel2`,`wornlevel`,`UNK147`,`focustype`,`focuslevel2`,`focuslevel`,`UNK152`,`scrolleffect`,`scrolltype`,`scrolllevel2`,`scrolllevel`,`UNK157`,`serialized`,`verified`,`serialization`,`source`,`UNK033`,`lorefile`,`UNK014`,`svcorruption`,`skillmodmax`,`UNK060`,`augslot1unk2`,`augslot2unk2`,`augslot3unk2`,`augslot4unk2`,`augslot5unk2`,`augslot6unk2`,`UNK120`,`UNK121`,`questitemflag`,`UNK132`,`clickunk5`,`clickunk6`,`clickunk7`,`procunk1`,`procunk2`,`procunk3`,`procunk4`,`procunk6`,`procunk7`,`wornunk1`,`wornunk2`,`wornunk3`,`wornunk4`,`wornunk5`,`wornunk6`,`wornunk7`,`focusunk1`,`focusunk2`,`focusunk3`,`focusunk4`,`focusunk5`,`focusunk6`,`focusunk7`,`scrollunk1`,`scrollunk2`,`scrollunk3`,`scrollunk4`,`scrollunk5`,`scrollunk6`,`scrollunk7`,`UNK193`,`purity`,`evoitem`,`evoid`,`evolvinglevel`,`evomax`,`clickname`,`procname`,`wornname`,`focusname`,`scrollname`,`dsmitigation`,`heroic_str`,`heroic_int`,`heroic_wis`,`heroic_agi`,`heroic_dex`,`heroic_sta`,`heroic_cha`,`heroic_pr`,`heroic_dr`,`heroic_fr`,`heroic_cr`,`heroic_mr`,`heroic_svcorrup`,`healamt`,`spelldmg`,`clairvoyance`,`backstabdmg`,`created`,`elitematerial`,`ldonsellbackrate`,`scriptfileid`,`expendablearrow`,`powersourcecapacity`,`bardeffect`,`bardeffecttype`,`bardlevel2`,`bardlevel`,`bardunk1`,`bardunk2`,`bardunk3`,`bardunk4`,`bardunk5`,`bardname`,`bardunk7`,`UNK214`,`subtype`,`UNK220`,`UNK221`,`heirloom`,`UNK223`,`UNK224`,`UNK225`,`UNK226`,`UNK227`,`UNK228`,`UNK229`,`UNK230`,`UNK231`,`UNK232`,`UNK233`,`UNK234`,`placeable`,`UNK236`,`UNK237`,`UNK238`,`UNK239`,`UNK240`,`UNK241`,`epicitem`,`housing_disable_rotation`,`housing_disable_free_placement`)
SELECT 900103,`minstatus`,`Name`,`aagi`,`ac`,`accuracy`,`acha`,`adex`,`aint`,`artifactflag`,`asta`,`astr`,`attack`,`augrestrict`,`augslot1type`,`augslot1visible`,`augslot2type`,`augslot2visible`,`augslot3type`,`augslot3visible`,`augslot4type`,`augslot4visible`,`augslot5type`,`augslot5visible`,`augslot6type`,`augslot6visible`,`augtype`,`avoidance`,`awis`,`bagsize`,`bagslots`,`bagtype`,`bagwr`,`banedmgamt`,`banedmgraceamt`,`banedmgbody`,`banedmgrace`,`bardtype`,`bardvalue`,`book`,`casttime`,`casttime_`,`charmfile`,`charmfileid`,1,`color`,`combateffects`,`extradmgskill`,`extradmgamt`,`price`,`cr`,`damage`,`damageshield`,`deity`,`delay`,`augdistiller`,`dotshielding`,`dr`,`clicktype`,`clicklevel2`,`elemdmgtype`,`elemdmgamt`,`endur`,`factionamt1`,`factionamt2`,`factionamt3`,`factionamt4`,`factionmod1`,`factionmod2`,`factionmod3`,`factionmod4`,`filename`,`focuseffect`,`fr`,`fvnodrop`,`haste`,`clicklevel`,`hp`,`regen`,`icon`,`idfile`,`itemclass`,`itemtype`,`ldonprice`,`ldontheme`,`ldonsold`,`light`,`lore`,`loregroup`,`magic`,`mana`,`manaregen`,`enduranceregen`,`material`,`herosforgemodel`,`maxcharges`,`mr`,`nodrop`,`norent`,`pendingloreflag`,`pr`,`procrate`,65535,`range`,`reclevel`,`recskill`,`reqlevel`,`sellrate`,`shielding`,`size`,`skillmodtype`,`skillmodvalue`,`slots`,`clickeffect`,`spellshield`,`strikethrough`,`stunresist`,`summonedflag`,`tradeskills`,`favor`,`weight`,`UNK012`,`UNK013`,`benefitflag`,`UNK054`,`UNK059`,`booktype`,`recastdelay`,`recasttype`,`guildfavor`,`UNK123`,`UNK124`,`attuneable`,`nopet`,`updated`,`comment`,`UNK127`,`pointtype`,`potionbelt`,`potionbeltslots`,`stacksize`,`notransfer`,`stackable`,`UNK134`,`UNK137`,`proceffect`,`proctype`,`proclevel2`,`proclevel`,`UNK142`,`worneffect`,`worntype`,`wornlevel2`,`wornlevel`,`UNK147`,`focustype`,`focuslevel2`,`focuslevel`,`UNK152`,`scrolleffect`,`scrolltype`,`scrolllevel2`,`scrolllevel`,`UNK157`,`serialized`,`verified`,`serialization`,`source`,`UNK033`,`lorefile`,`UNK014`,`svcorruption`,`skillmodmax`,`UNK060`,`augslot1unk2`,`augslot2unk2`,`augslot3unk2`,`augslot4unk2`,`augslot5unk2`,`augslot6unk2`,`UNK120`,`UNK121`,`questitemflag`,`UNK132`,`clickunk5`,`clickunk6`,`clickunk7`,`procunk1`,`procunk2`,`procunk3`,`procunk4`,`procunk6`,`procunk7`,`wornunk1`,`wornunk2`,`wornunk3`,`wornunk4`,`wornunk5`,`wornunk6`,`wornunk7`,`focusunk1`,`focusunk2`,`focusunk3`,`focusunk4`,`focusunk5`,`focusunk6`,`focusunk7`,`scrollunk1`,`scrollunk2`,`scrollunk3`,`scrollunk4`,`scrollunk5`,`scrollunk6`,`scrollunk7`,`UNK193`,`purity`,`evoitem`,`evoid`,`evolvinglevel`,`evomax`,`clickname`,`procname`,`wornname`,`focusname`,`scrollname`,`dsmitigation`,`heroic_str`,`heroic_int`,`heroic_wis`,`heroic_agi`,`heroic_dex`,`heroic_sta`,`heroic_cha`,`heroic_pr`,`heroic_dr`,`heroic_fr`,`heroic_cr`,`heroic_mr`,`heroic_svcorrup`,`healamt`,`spelldmg`,`clairvoyance`,`backstabdmg`,`created`,`elitematerial`,`ldonsellbackrate`,`scriptfileid`,`expendablearrow`,`powersourcecapacity`,`bardeffect`,`bardeffecttype`,`bardlevel2`,`bardlevel`,`bardunk1`,`bardunk2`,`bardunk3`,`bardunk4`,`bardunk5`,`bardname`,`bardunk7`,`UNK214`,`subtype`,`UNK220`,`UNK221`,`heirloom`,`UNK223`,`UNK224`,`UNK225`,`UNK226`,`UNK227`,`UNK228`,`UNK229`,`UNK230`,`UNK231`,`UNK232`,`UNK233`,`UNK234`,`placeable`,`UNK236`,`UNK237`,`UNK238`,`UNK239`,`UNK240`,`UNK241`,`epicitem`,`housing_disable_rotation`,`housing_disable_free_placement` FROM `items` WHERE id=85541;

INSERT INTO `items` (`id`,`minstatus`,`Name`,`aagi`,`ac`,`accuracy`,`acha`,`adex`,`aint`,`artifactflag`,`asta`,`astr`,`attack`,`augrestrict`,`augslot1type`,`augslot1visible`,`augslot2type`,`augslot2visible`,`augslot3type`,`augslot3visible`,`augslot4type`,`augslot4visible`,`augslot5type`,`augslot5visible`,`augslot6type`,`augslot6visible`,`augtype`,`avoidance`,`awis`,`bagsize`,`bagslots`,`bagtype`,`bagwr`,`banedmgamt`,`banedmgraceamt`,`banedmgbody`,`banedmgrace`,`bardtype`,`bardvalue`,`book`,`casttime`,`casttime_`,`charmfile`,`charmfileid`,`classes`,`color`,`combateffects`,`extradmgskill`,`extradmgamt`,`price`,`cr`,`damage`,`damageshield`,`deity`,`delay`,`augdistiller`,`dotshielding`,`dr`,`clicktype`,`clicklevel2`,`elemdmgtype`,`elemdmgamt`,`endur`,`factionamt1`,`factionamt2`,`factionamt3`,`factionamt4`,`factionmod1`,`factionmod2`,`factionmod3`,`factionmod4`,`filename`,`focuseffect`,`fr`,`fvnodrop`,`haste`,`clicklevel`,`hp`,`regen`,`icon`,`idfile`,`itemclass`,`itemtype`,`ldonprice`,`ldontheme`,`ldonsold`,`light`,`lore`,`loregroup`,`magic`,`mana`,`manaregen`,`enduranceregen`,`material`,`herosforgemodel`,`maxcharges`,`mr`,`nodrop`,`norent`,`pendingloreflag`,`pr`,`procrate`,`races`,`range`,`reclevel`,`recskill`,`reqlevel`,`sellrate`,`shielding`,`size`,`skillmodtype`,`skillmodvalue`,`slots`,`clickeffect`,`spellshield`,`strikethrough`,`stunresist`,`summonedflag`,`tradeskills`,`favor`,`weight`,`UNK012`,`UNK013`,`benefitflag`,`UNK054`,`UNK059`,`booktype`,`recastdelay`,`recasttype`,`guildfavor`,`UNK123`,`UNK124`,`attuneable`,`nopet`,`updated`,`comment`,`UNK127`,`pointtype`,`potionbelt`,`potionbeltslots`,`stacksize`,`notransfer`,`stackable`,`UNK134`,`UNK137`,`proceffect`,`proctype`,`proclevel2`,`proclevel`,`UNK142`,`worneffect`,`worntype`,`wornlevel2`,`wornlevel`,`UNK147`,`focustype`,`focuslevel2`,`focuslevel`,`UNK152`,`scrolleffect`,`scrolltype`,`scrolllevel2`,`scrolllevel`,`UNK157`,`serialized`,`verified`,`serialization`,`source`,`UNK033`,`lorefile`,`UNK014`,`svcorruption`,`skillmodmax`,`UNK060`,`augslot1unk2`,`augslot2unk2`,`augslot3unk2`,`augslot4unk2`,`augslot5unk2`,`augslot6unk2`,`UNK120`,`UNK121`,`questitemflag`,`UNK132`,`clickunk5`,`clickunk6`,`clickunk7`,`procunk1`,`procunk2`,`procunk3`,`procunk4`,`procunk6`,`procunk7`,`wornunk1`,`wornunk2`,`wornunk3`,`wornunk4`,`wornunk5`,`wornunk6`,`wornunk7`,`focusunk1`,`focusunk2`,`focusunk3`,`focusunk4`,`focusunk5`,`focusunk6`,`focusunk7`,`scrollunk1`,`scrollunk2`,`scrollunk3`,`scrollunk4`,`scrollunk5`,`scrollunk6`,`scrollunk7`,`UNK193`,`purity`,`evoitem`,`evoid`,`evolvinglevel`,`evomax`,`clickname`,`procname`,`wornname`,`focusname`,`scrollname`,`dsmitigation`,`heroic_str`,`heroic_int`,`heroic_wis`,`heroic_agi`,`heroic_dex`,`heroic_sta`,`heroic_cha`,`heroic_pr`,`heroic_dr`,`heroic_fr`,`heroic_cr`,`heroic_mr`,`heroic_svcorrup`,`healamt`,`spelldmg`,`clairvoyance`,`backstabdmg`,`created`,`elitematerial`,`ldonsellbackrate`,`scriptfileid`,`expendablearrow`,`powersourcecapacity`,`bardeffect`,`bardeffecttype`,`bardlevel2`,`bardlevel`,`bardunk1`,`bardunk2`,`bardunk3`,`bardunk4`,`bardunk5`,`bardname`,`bardunk7`,`UNK214`,`subtype`,`UNK220`,`UNK221`,`heirloom`,`UNK223`,`UNK224`,`UNK225`,`UNK226`,`UNK227`,`UNK228`,`UNK229`,`UNK230`,`UNK231`,`UNK232`,`UNK233`,`UNK234`,`placeable`,`UNK236`,`UNK237`,`UNK238`,`UNK239`,`UNK240`,`UNK241`,`epicitem`,`housing_disable_rotation`,`housing_disable_free_placement`)
SELECT 900104,`minstatus`,`Name`,`aagi`,`ac`,`accuracy`,`acha`,`adex`,`aint`,`artifactflag`,`asta`,`astr`,`attack`,`augrestrict`,`augslot1type`,`augslot1visible`,`augslot2type`,`augslot2visible`,`augslot3type`,`augslot3visible`,`augslot4type`,`augslot4visible`,`augslot5type`,`augslot5visible`,`augslot6type`,`augslot6visible`,`augtype`,`avoidance`,`awis`,`bagsize`,`bagslots`,`bagtype`,`bagwr`,`banedmgamt`,`banedmgraceamt`,`banedmgbody`,`banedmgrace`,`bardtype`,`bardvalue`,`book`,`casttime`,`casttime_`,`charmfile`,`charmfileid`,2050,`color`,`combateffects`,`extradmgskill`,`extradmgamt`,`price`,`cr`,`damage`,`damageshield`,`deity`,`delay`,`augdistiller`,`dotshielding`,`dr`,`clicktype`,`clicklevel2`,`elemdmgtype`,`elemdmgamt`,`endur`,`factionamt1`,`factionamt2`,`factionamt3`,`factionamt4`,`factionmod1`,`factionmod2`,`factionmod3`,`factionmod4`,`filename`,`focuseffect`,`fr`,`fvnodrop`,`haste`,`clicklevel`,`hp`,`regen`,`icon`,`idfile`,`itemclass`,`itemtype`,`ldonprice`,`ldontheme`,`ldonsold`,`light`,`lore`,`loregroup`,`magic`,`mana`,`manaregen`,`enduranceregen`,`material`,`herosforgemodel`,`maxcharges`,`mr`,`nodrop`,`norent`,`pendingloreflag`,`pr`,`procrate`,65535,`range`,`reclevel`,`recskill`,`reqlevel`,`sellrate`,`shielding`,`size`,`skillmodtype`,`skillmodvalue`,`slots`,`clickeffect`,`spellshield`,`strikethrough`,`stunresist`,`summonedflag`,`tradeskills`,`favor`,`weight`,`UNK012`,`UNK013`,`benefitflag`,`UNK054`,`UNK059`,`booktype`,`recastdelay`,`recasttype`,`guildfavor`,`UNK123`,`UNK124`,`attuneable`,`nopet`,`updated`,`comment`,`UNK127`,`pointtype`,`potionbelt`,`potionbeltslots`,`stacksize`,`notransfer`,`stackable`,`UNK134`,`UNK137`,`proceffect`,`proctype`,`proclevel2`,`proclevel`,`UNK142`,`worneffect`,`worntype`,`wornlevel2`,`wornlevel`,`UNK147`,`focustype`,`focuslevel2`,`focuslevel`,`UNK152`,`scrolleffect`,`scrolltype`,`scrolllevel2`,`scrolllevel`,`UNK157`,`serialized`,`verified`,`serialization`,`source`,`UNK033`,`lorefile`,`UNK014`,`svcorruption`,`skillmodmax`,`UNK060`,`augslot1unk2`,`augslot2unk2`,`augslot3unk2`,`augslot4unk2`,`augslot5unk2`,`augslot6unk2`,`UNK120`,`UNK121`,`questitemflag`,`UNK132`,`clickunk5`,`clickunk6`,`clickunk7`,`procunk1`,`procunk2`,`procunk3`,`procunk4`,`procunk6`,`procunk7`,`wornunk1`,`wornunk2`,`wornunk3`,`wornunk4`,`wornunk5`,`wornunk6`,`wornunk7`,`focusunk1`,`focusunk2`,`focusunk3`,`focusunk4`,`focusunk5`,`focusunk6`,`focusunk7`,`scrollunk1`,`scrollunk2`,`scrollunk3`,`scrollunk4`,`scrollunk5`,`scrollunk6`,`scrollunk7`,`UNK193`,`purity`,`evoitem`,`evoid`,`evolvinglevel`,`evomax`,`clickname`,`procname`,`wornname`,`focusname`,`scrollname`,`dsmitigation`,`heroic_str`,`heroic_int`,`heroic_wis`,`heroic_agi`,`heroic_dex`,`heroic_sta`,`heroic_cha`,`heroic_pr`,`heroic_dr`,`heroic_fr`,`heroic_cr`,`heroic_mr`,`heroic_svcorrup`,`healamt`,`spelldmg`,`clairvoyance`,`backstabdmg`,`created`,`elitematerial`,`ldonsellbackrate`,`scriptfileid`,`expendablearrow`,`powersourcecapacity`,`bardeffect`,`bardeffecttype`,`bardlevel2`,`bardlevel`,`bardunk1`,`bardunk2`,`bardunk3`,`bardunk4`,`bardunk5`,`bardname`,`bardunk7`,`UNK214`,`subtype`,`UNK220`,`UNK221`,`heirloom`,`UNK223`,`UNK224`,`UNK225`,`UNK226`,`UNK227`,`UNK228`,`UNK229`,`UNK230`,`UNK231`,`UNK232`,`UNK233`,`UNK234`,`placeable`,`UNK236`,`UNK237`,`UNK238`,`UNK239`,`UNK240`,`UNK241`,`epicitem`,`housing_disable_rotation`,`housing_disable_free_placement` FROM `items` WHERE id=85542;

INSERT INTO `items` (`id`,`minstatus`,`Name`,`aagi`,`ac`,`accuracy`,`acha`,`adex`,`aint`,`artifactflag`,`asta`,`astr`,`attack`,`augrestrict`,`augslot1type`,`augslot1visible`,`augslot2type`,`augslot2visible`,`augslot3type`,`augslot3visible`,`augslot4type`,`augslot4visible`,`augslot5type`,`augslot5visible`,`augslot6type`,`augslot6visible`,`augtype`,`avoidance`,`awis`,`bagsize`,`bagslots`,`bagtype`,`bagwr`,`banedmgamt`,`banedmgraceamt`,`banedmgbody`,`banedmgrace`,`bardtype`,`bardvalue`,`book`,`casttime`,`casttime_`,`charmfile`,`charmfileid`,`classes`,`color`,`combateffects`,`extradmgskill`,`extradmgamt`,`price`,`cr`,`damage`,`damageshield`,`deity`,`delay`,`augdistiller`,`dotshielding`,`dr`,`clicktype`,`clicklevel2`,`elemdmgtype`,`elemdmgamt`,`endur`,`factionamt1`,`factionamt2`,`factionamt3`,`factionamt4`,`factionmod1`,`factionmod2`,`factionmod3`,`factionmod4`,`filename`,`focuseffect`,`fr`,`fvnodrop`,`haste`,`clicklevel`,`hp`,`regen`,`icon`,`idfile`,`itemclass`,`itemtype`,`ldonprice`,`ldontheme`,`ldonsold`,`light`,`lore`,`loregroup`,`magic`,`mana`,`manaregen`,`enduranceregen`,`material`,`herosforgemodel`,`maxcharges`,`mr`,`nodrop`,`norent`,`pendingloreflag`,`pr`,`procrate`,`races`,`range`,`reclevel`,`recskill`,`reqlevel`,`sellrate`,`shielding`,`size`,`skillmodtype`,`skillmodvalue`,`slots`,`clickeffect`,`spellshield`,`strikethrough`,`stunresist`,`summonedflag`,`tradeskills`,`favor`,`weight`,`UNK012`,`UNK013`,`benefitflag`,`UNK054`,`UNK059`,`booktype`,`recastdelay`,`recasttype`,`guildfavor`,`UNK123`,`UNK124`,`attuneable`,`nopet`,`updated`,`comment`,`UNK127`,`pointtype`,`potionbelt`,`potionbeltslots`,`stacksize`,`notransfer`,`stackable`,`UNK134`,`UNK137`,`proceffect`,`proctype`,`proclevel2`,`proclevel`,`UNK142`,`worneffect`,`worntype`,`wornlevel2`,`wornlevel`,`UNK147`,`focustype`,`focuslevel2`,`focuslevel`,`UNK152`,`scrolleffect`,`scrolltype`,`scrolllevel2`,`scrolllevel`,`UNK157`,`serialized`,`verified`,`serialization`,`source`,`UNK033`,`lorefile`,`UNK014`,`svcorruption`,`skillmodmax`,`UNK060`,`augslot1unk2`,`augslot2unk2`,`augslot3unk2`,`augslot4unk2`,`augslot5unk2`,`augslot6unk2`,`UNK120`,`UNK121`,`questitemflag`,`UNK132`,`clickunk5`,`clickunk6`,`clickunk7`,`procunk1`,`procunk2`,`procunk3`,`procunk4`,`procunk6`,`procunk7`,`wornunk1`,`wornunk2`,`wornunk3`,`wornunk4`,`wornunk5`,`wornunk6`,`wornunk7`,`focusunk1`,`focusunk2`,`focusunk3`,`focusunk4`,`focusunk5`,`focusunk6`,`focusunk7`,`scrollunk1`,`scrollunk2`,`scrollunk3`,`scrollunk4`,`scrollunk5`,`scrollunk6`,`scrollunk7`,`UNK193`,`purity`,`evoitem`,`evoid`,`evolvinglevel`,`evomax`,`clickname`,`procname`,`wornname`,`focusname`,`scrollname`,`dsmitigation`,`heroic_str`,`heroic_int`,`heroic_wis`,`heroic_agi`,`heroic_dex`,`heroic_sta`,`heroic_cha`,`heroic_pr`,`heroic_dr`,`heroic_fr`,`heroic_cr`,`heroic_mr`,`heroic_svcorrup`,`healamt`,`spelldmg`,`clairvoyance`,`backstabdmg`,`created`,`elitematerial`,`ldonsellbackrate`,`scriptfileid`,`expendablearrow`,`powersourcecapacity`,`bardeffect`,`bardeffecttype`,`bardlevel2`,`bardlevel`,`bardunk1`,`bardunk2`,`bardunk3`,`bardunk4`,`bardunk5`,`bardname`,`bardunk7`,`UNK214`,`subtype`,`UNK220`,`UNK221`,`heirloom`,`UNK223`,`UNK224`,`UNK225`,`UNK226`,`UNK227`,`UNK228`,`UNK229`,`UNK230`,`UNK231`,`UNK232`,`UNK233`,`UNK234`,`placeable`,`UNK236`,`UNK237`,`UNK238`,`UNK239`,`UNK240`,`UNK241`,`epicitem`,`housing_disable_rotation`,`housing_disable_free_placement`)
SELECT 900105,`minstatus`,`Name`,`aagi`,`ac`,`accuracy`,`acha`,`adex`,`aint`,`artifactflag`,`asta`,`astr`,`attack`,`augrestrict`,`augslot1type`,`augslot1visible`,`augslot2type`,`augslot2visible`,`augslot3type`,`augslot3visible`,`augslot4type`,`augslot4visible`,`augslot5type`,`augslot5visible`,`augslot6type`,`augslot6visible`,`augtype`,`avoidance`,`awis`,`bagsize`,`bagslots`,`bagtype`,`bagwr`,`banedmgamt`,`banedmgraceamt`,`banedmgbody`,`banedmgrace`,`bardtype`,`bardvalue`,`book`,`casttime`,`casttime_`,`charmfile`,`charmfileid`,8192,`color`,`combateffects`,`extradmgskill`,`extradmgamt`,`price`,`cr`,`damage`,`damageshield`,`deity`,`delay`,`augdistiller`,`dotshielding`,`dr`,`clicktype`,`clicklevel2`,`elemdmgtype`,`elemdmgamt`,`endur`,`factionamt1`,`factionamt2`,`factionamt3`,`factionamt4`,`factionmod1`,`factionmod2`,`factionmod3`,`factionmod4`,`filename`,`focuseffect`,`fr`,`fvnodrop`,`haste`,`clicklevel`,`hp`,`regen`,`icon`,`idfile`,`itemclass`,`itemtype`,`ldonprice`,`ldontheme`,`ldonsold`,`light`,`lore`,`loregroup`,`magic`,`mana`,`manaregen`,`enduranceregen`,`material`,`herosforgemodel`,`maxcharges`,`mr`,`nodrop`,`norent`,`pendingloreflag`,`pr`,`procrate`,65535,`range`,`reclevel`,`recskill`,`reqlevel`,`sellrate`,`shielding`,`size`,`skillmodtype`,`skillmodvalue`,`slots`,`clickeffect`,`spellshield`,`strikethrough`,`stunresist`,`summonedflag`,`tradeskills`,`favor`,`weight`,`UNK012`,`UNK013`,`benefitflag`,`UNK054`,`UNK059`,`booktype`,`recastdelay`,`recasttype`,`guildfavor`,`UNK123`,`UNK124`,`attuneable`,`nopet`,`updated`,`comment`,`UNK127`,`pointtype`,`potionbelt`,`potionbeltslots`,`stacksize`,`notransfer`,`stackable`,`UNK134`,`UNK137`,`proceffect`,`proctype`,`proclevel2`,`proclevel`,`UNK142`,`worneffect`,`worntype`,`wornlevel2`,`wornlevel`,`UNK147`,`focustype`,`focuslevel2`,`focuslevel`,`UNK152`,`scrolleffect`,`scrolltype`,`scrolllevel2`,`scrolllevel`,`UNK157`,`serialized`,`verified`,`serialization`,`source`,`UNK033`,`lorefile`,`UNK014`,`svcorruption`,`skillmodmax`,`UNK060`,`augslot1unk2`,`augslot2unk2`,`augslot3unk2`,`augslot4unk2`,`augslot5unk2`,`augslot6unk2`,`UNK120`,`UNK121`,`questitemflag`,`UNK132`,`clickunk5`,`clickunk6`,`clickunk7`,`procunk1`,`procunk2`,`procunk3`,`procunk4`,`procunk6`,`procunk7`,`wornunk1`,`wornunk2`,`wornunk3`,`wornunk4`,`wornunk5`,`wornunk6`,`wornunk7`,`focusunk1`,`focusunk2`,`focusunk3`,`focusunk4`,`focusunk5`,`focusunk6`,`focusunk7`,`scrollunk1`,`scrollunk2`,`scrollunk3`,`scrollunk4`,`scrollunk5`,`scrollunk6`,`scrollunk7`,`UNK193`,`purity`,`evoitem`,`evoid`,`evolvinglevel`,`evomax`,`clickname`,`procname`,`wornname`,`focusname`,`scrollname`,`dsmitigation`,`heroic_str`,`heroic_int`,`heroic_wis`,`heroic_agi`,`heroic_dex`,`heroic_sta`,`heroic_cha`,`heroic_pr`,`heroic_dr`,`heroic_fr`,`heroic_cr`,`heroic_mr`,`heroic_svcorrup`,`healamt`,`spelldmg`,`clairvoyance`,`backstabdmg`,`created`,`elitematerial`,`ldonsellbackrate`,`scriptfileid`,`expendablearrow`,`powersourcecapacity`,`bardeffect`,`bardeffecttype`,`bardlevel2`,`bardlevel`,`bardunk1`,`bardunk2`,`bardunk3`,`bardunk4`,`bardunk5`,`bardname`,`bardunk7`,`UNK214`,`subtype`,`UNK220`,`UNK221`,`heirloom`,`UNK223`,`UNK224`,`UNK225`,`UNK226`,`UNK227`,`UNK228`,`UNK229`,`UNK230`,`UNK231`,`UNK232`,`UNK233`,`UNK234`,`placeable`,`UNK236`,`UNK237`,`UNK238`,`UNK239`,`UNK240`,`UNK241`,`epicitem`,`housing_disable_rotation`,`housing_disable_free_placement` FROM `items` WHERE id=85543;

INSERT INTO `spells_new` (`id`,`name`,`player_1`,`teleport_zone`,`you_cast`,`other_casts`,`cast_on_you`,`cast_on_other`,`spell_fades`,`range`,`aoerange`,`pushback`,`pushup`,`cast_time`,`recovery_time`,`recast_time`,`buffdurationformula`,`buffduration`,`AEDuration`,`mana`,`effect_base_value1`,`effect_base_value2`,`effect_base_value3`,`effect_base_value4`,`effect_base_value5`,`effect_base_value6`,`effect_base_value7`,`effect_base_value8`,`effect_base_value9`,`effect_base_value10`,`effect_base_value11`,`effect_base_value12`,`effect_limit_value1`,`effect_limit_value2`,`effect_limit_value3`,`effect_limit_value4`,`effect_limit_value5`,`effect_limit_value6`,`effect_limit_value7`,`effect_limit_value8`,`effect_limit_value9`,`effect_limit_value10`,`effect_limit_value11`,`effect_limit_value12`,`max1`,`max2`,`max3`,`max4`,`max5`,`max6`,`max7`,`max8`,`max9`,`max10`,`max11`,`max12`,`icon`,`memicon`,`components1`,`components2`,`components3`,`components4`,`component_counts1`,`component_counts2`,`component_counts3`,`component_counts4`,`NoexpendReagent1`,`NoexpendReagent2`,`NoexpendReagent3`,`NoexpendReagent4`,`formula1`,`formula2`,`formula3`,`formula4`,`formula5`,`formula6`,`formula7`,`formula8`,`formula9`,`formula10`,`formula11`,`formula12`,`LightType`,`goodEffect`,`Activated`,`resisttype`,`effectid1`,`effectid2`,`effectid3`,`effectid4`,`effectid5`,`effectid6`,`effectid7`,`effectid8`,`effectid9`,`effectid10`,`effectid11`,`effectid12`,`targettype`,`basediff`,`skill`,`zonetype`,`EnvironmentType`,`TimeOfDay`,`classes1`,`classes2`,`classes3`,`classes4`,`classes5`,`classes6`,`classes7`,`classes8`,`classes9`,`classes10`,`classes11`,`classes12`,`classes13`,`classes14`,`classes15`,`classes16`,`CastingAnim`,`TargetAnim`,`TravelType`,`SpellAffectIndex`,`disallow_sit`,`deities0`,`deities1`,`deities2`,`deities3`,`deities4`,`deities5`,`deities6`,`deities7`,`deities8`,`deities9`,`deities10`,`deities11`,`deities12`,`deities13`,`deities14`,`deities15`,`deities16`,`field142`,`field143`,`new_icon`,`spellanim`,`uninterruptable`,`ResistDiff`,`dot_stacking_exempt`,`deleteable`,`RecourseLink`,`no_partial_resist`,`field152`,`field153`,`short_buff_box`,`descnum`,`typedescnum`,`effectdescnum`,`effectdescnum2`,`npc_no_los`,`field160`,`reflectable`,`bonushate`,`field163`,`field164`,`ldon_trap`,`EndurCost`,`EndurTimerIndex`,`IsDiscipline`,`field169`,`field170`,`field171`,`field172`,`HateAdded`,`EndurUpkeep`,`numhitstype`,`numhits`,`pvpresistbase`,`pvpresistcalc`,`pvpresistcap`,`spell_category`,`pvp_duration`,`pvp_duration_cap`,`pcnpc_only_flag`,`cast_not_standing`,`can_mgb`,`nodispell`,`npc_category`,`npc_usefulness`,`MinResist`,`MaxResist`,`viral_targets`,`viral_timer`,`nimbuseffect`,`ConeStartAngle`,`ConeStopAngle`,`sneaking`,`not_extendable`,`field198`,`field199`,`suspendable`,`viral_range`,`songcap`,`field203`,`field204`,`no_block`,`field206`,`spellgroup`,`rank`,`field209`,`field210`,`CastRestriction`,`allowrest`,`InCombat`,`OutofCombat`,`field215`,`field216`,`field217`,`aemaxtargets`,`maxtargets`,`field220`,`field221`,`field222`,`field223`,`persistdeath`,`field225`,`field226`,`min_dist`,`min_dist_mod`,`max_dist`,`max_dist_mod`,`min_range`,`field232`,`field233`,`field234`,`field235`,`field236`)
SELECT 42700,'Self Protection',`player_1`,`teleport_zone`,`you_cast`,`other_casts`,`cast_on_you`,`cast_on_other`,`spell_fades`,`range`,`aoerange`,`pushback`,`pushup`,`cast_time`,`recovery_time`,`recast_time`,`buffdurationformula`,`buffduration`,`AEDuration`,`mana`,65,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,65,0,0,0,0,0,0,0,0,0,0,0,`icon`,`memicon`,`components1`,`components2`,`components3`,`components4`,`component_counts1`,`component_counts2`,`component_counts3`,`component_counts4`,`NoexpendReagent1`,`NoexpendReagent2`,`NoexpendReagent3`,`NoexpendReagent4`,100,100,100,100,100,100,100,100,100,100,100,100,`LightType`,`goodEffect`,`Activated`,`resisttype`,1,254,254,254,254,254,254,254,254,254,254,254,6,`basediff`,`skill`,`zonetype`,`EnvironmentType`,`TimeOfDay`,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,`CastingAnim`,`TargetAnim`,`TravelType`,`SpellAffectIndex`,`disallow_sit`,`deities0`,`deities1`,`deities2`,`deities3`,`deities4`,`deities5`,`deities6`,`deities7`,`deities8`,`deities9`,`deities10`,`deities11`,`deities12`,`deities13`,`deities14`,`deities15`,`deities16`,`field142`,`field143`,`new_icon`,`spellanim`,`uninterruptable`,`ResistDiff`,`dot_stacking_exempt`,`deleteable`,`RecourseLink`,`no_partial_resist`,`field152`,`field153`,`short_buff_box`,`descnum`,`typedescnum`,`effectdescnum`,`effectdescnum2`,`npc_no_los`,`field160`,`reflectable`,`bonushate`,`field163`,`field164`,`ldon_trap`,`EndurCost`,`EndurTimerIndex`,`IsDiscipline`,`field169`,`field170`,`field171`,`field172`,`HateAdded`,`EndurUpkeep`,`numhitstype`,`numhits`,`pvpresistbase`,`pvpresistcalc`,`pvpresistcap`,`spell_category`,`pvp_duration`,`pvp_duration_cap`,`pcnpc_only_flag`,`cast_not_standing`,`can_mgb`,`nodispell`,`npc_category`,`npc_usefulness`,`MinResist`,`MaxResist`,`viral_targets`,`viral_timer`,`nimbuseffect`,`ConeStartAngle`,`ConeStopAngle`,`sneaking`,`not_extendable`,`field198`,`field199`,`suspendable`,`viral_range`,`songcap`,`field203`,`field204`,`no_block`,`field206`,`spellgroup`,`rank`,`field209`,`field210`,`CastRestriction`,`allowrest`,`InCombat`,`OutofCombat`,`field215`,`field216`,`field217`,`aemaxtargets`,`maxtargets`,`field220`,`field221`,`field222`,`field223`,`persistdeath`,`field225`,`field226`,`min_dist`,`min_dist_mod`,`max_dist`,`max_dist_mod`,`min_range`,`field232`,`field233`,`field234`,`field235`,`field236` FROM `spells_new` WHERE id=19;

INSERT INTO `spells_new` (`id`,`name`,`player_1`,`teleport_zone`,`you_cast`,`other_casts`,`cast_on_you`,`cast_on_other`,`spell_fades`,`range`,`aoerange`,`pushback`,`pushup`,`cast_time`,`recovery_time`,`recast_time`,`buffdurationformula`,`buffduration`,`AEDuration`,`mana`,`effect_base_value1`,`effect_base_value2`,`effect_base_value3`,`effect_base_value4`,`effect_base_value5`,`effect_base_value6`,`effect_base_value7`,`effect_base_value8`,`effect_base_value9`,`effect_base_value10`,`effect_base_value11`,`effect_base_value12`,`effect_limit_value1`,`effect_limit_value2`,`effect_limit_value3`,`effect_limit_value4`,`effect_limit_value5`,`effect_limit_value6`,`effect_limit_value7`,`effect_limit_value8`,`effect_limit_value9`,`effect_limit_value10`,`effect_limit_value11`,`effect_limit_value12`,`max1`,`max2`,`max3`,`max4`,`max5`,`max6`,`max7`,`max8`,`max9`,`max10`,`max11`,`max12`,`icon`,`memicon`,`components1`,`components2`,`components3`,`components4`,`component_counts1`,`component_counts2`,`component_counts3`,`component_counts4`,`NoexpendReagent1`,`NoexpendReagent2`,`NoexpendReagent3`,`NoexpendReagent4`,`formula1`,`formula2`,`formula3`,`formula4`,`formula5`,`formula6`,`formula7`,`formula8`,`formula9`,`formula10`,`formula11`,`formula12`,`LightType`,`goodEffect`,`Activated`,`resisttype`,`effectid1`,`effectid2`,`effectid3`,`effectid4`,`effectid5`,`effectid6`,`effectid7`,`effectid8`,`effectid9`,`effectid10`,`effectid11`,`effectid12`,`targettype`,`basediff`,`skill`,`zonetype`,`EnvironmentType`,`TimeOfDay`,`classes1`,`classes2`,`classes3`,`classes4`,`classes5`,`classes6`,`classes7`,`classes8`,`classes9`,`classes10`,`classes11`,`classes12`,`classes13`,`classes14`,`classes15`,`classes16`,`CastingAnim`,`TargetAnim`,`TravelType`,`SpellAffectIndex`,`disallow_sit`,`deities0`,`deities1`,`deities2`,`deities3`,`deities4`,`deities5`,`deities6`,`deities7`,`deities8`,`deities9`,`deities10`,`deities11`,`deities12`,`deities13`,`deities14`,`deities15`,`deities16`,`field142`,`field143`,`new_icon`,`spellanim`,`uninterruptable`,`ResistDiff`,`dot_stacking_exempt`,`deleteable`,`RecourseLink`,`no_partial_resist`,`field152`,`field153`,`short_buff_box`,`descnum`,`typedescnum`,`effectdescnum`,`effectdescnum2`,`npc_no_los`,`field160`,`reflectable`,`bonushate`,`field163`,`field164`,`ldon_trap`,`EndurCost`,`EndurTimerIndex`,`IsDiscipline`,`field169`,`field170`,`field171`,`field172`,`HateAdded`,`EndurUpkeep`,`numhitstype`,`numhits`,`pvpresistbase`,`pvpresistcalc`,`pvpresistcap`,`spell_category`,`pvp_duration`,`pvp_duration_cap`,`pcnpc_only_flag`,`cast_not_standing`,`can_mgb`,`nodispell`,`npc_category`,`npc_usefulness`,`MinResist`,`MaxResist`,`viral_targets`,`viral_timer`,`nimbuseffect`,`ConeStartAngle`,`ConeStopAngle`,`sneaking`,`not_extendable`,`field198`,`field199`,`suspendable`,`viral_range`,`songcap`,`field203`,`field204`,`no_block`,`field206`,`spellgroup`,`rank`,`field209`,`field210`,`CastRestriction`,`allowrest`,`InCombat`,`OutofCombat`,`field215`,`field216`,`field217`,`aemaxtargets`,`maxtargets`,`field220`,`field221`,`field222`,`field223`,`persistdeath`,`field225`,`field226`,`min_dist`,`min_dist_mod`,`max_dist`,`max_dist_mod`,`min_range`,`field232`,`field233`,`field234`,`field235`,`field236`)
SELECT 42701,'Local Slow',`player_1`,`teleport_zone`,`you_cast`,`other_casts`,`cast_on_you`,`cast_on_other`,`spell_fades`,`range`,`aoerange`,`pushback`,`pushup`,`cast_time`,`recovery_time`,`recast_time`,`buffdurationformula`,`buffduration`,`AEDuration`,`mana`,80,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,80,0,0,0,0,0,0,0,0,0,0,0,`icon`,`memicon`,`components1`,`components2`,`components3`,`components4`,`component_counts1`,`component_counts2`,`component_counts3`,`component_counts4`,`NoexpendReagent1`,`NoexpendReagent2`,`NoexpendReagent3`,`NoexpendReagent4`,100,100,100,100,100,100,100,100,100,100,100,100,`LightType`,`goodEffect`,`Activated`,`resisttype`,11,254,254,254,254,254,254,254,254,254,254,254,5,`basediff`,`skill`,`zonetype`,`EnvironmentType`,`TimeOfDay`,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,`CastingAnim`,`TargetAnim`,`TravelType`,`SpellAffectIndex`,`disallow_sit`,`deities0`,`deities1`,`deities2`,`deities3`,`deities4`,`deities5`,`deities6`,`deities7`,`deities8`,`deities9`,`deities10`,`deities11`,`deities12`,`deities13`,`deities14`,`deities15`,`deities16`,`field142`,`field143`,`new_icon`,`spellanim`,`uninterruptable`,`ResistDiff`,`dot_stacking_exempt`,`deleteable`,`RecourseLink`,`no_partial_resist`,`field152`,`field153`,`short_buff_box`,`descnum`,`typedescnum`,`effectdescnum`,`effectdescnum2`,`npc_no_los`,`field160`,`reflectable`,`bonushate`,`field163`,`field164`,`ldon_trap`,`EndurCost`,`EndurTimerIndex`,`IsDiscipline`,`field169`,`field170`,`field171`,`field172`,`HateAdded`,`EndurUpkeep`,`numhitstype`,`numhits`,`pvpresistbase`,`pvpresistcalc`,`pvpresistcap`,`spell_category`,`pvp_duration`,`pvp_duration_cap`,`pcnpc_only_flag`,`cast_not_standing`,`can_mgb`,`nodispell`,`npc_category`,`npc_usefulness`,`MinResist`,`MaxResist`,`viral_targets`,`viral_timer`,`nimbuseffect`,`ConeStartAngle`,`ConeStopAngle`,`sneaking`,`not_extendable`,`field198`,`field199`,`suspendable`,`viral_range`,`songcap`,`field203`,`field204`,`no_block`,`field206`,`spellgroup`,`rank`,`field209`,`field210`,`CastRestriction`,`allowrest`,`InCombat`,`OutofCombat`,`field215`,`field216`,`field217`,`aemaxtargets`,`maxtargets`,`field220`,`field221`,`field222`,`field223`,`persistdeath`,`field225`,`field226`,`min_dist`,`min_dist_mod`,`max_dist`,`max_dist_mod`,`min_range`,`field232`,`field233`,`field234`,`field235`,`field236` FROM `spells_new` WHERE id=1712;

INSERT INTO `spells_new` (`id`,`name`,`player_1`,`teleport_zone`,`you_cast`,`other_casts`,`cast_on_you`,`cast_on_other`,`spell_fades`,`range`,`aoerange`,`pushback`,`pushup`,`cast_time`,`recovery_time`,`recast_time`,`buffdurationformula`,`buffduration`,`AEDuration`,`mana`,`effect_base_value1`,`effect_base_value2`,`effect_base_value3`,`effect_base_value4`,`effect_base_value5`,`effect_base_value6`,`effect_base_value7`,`effect_base_value8`,`effect_base_value9`,`effect_base_value10`,`effect_base_value11`,`effect_base_value12`,`effect_limit_value1`,`effect_limit_value2`,`effect_limit_value3`,`effect_limit_value4`,`effect_limit_value5`,`effect_limit_value6`,`effect_limit_value7`,`effect_limit_value8`,`effect_limit_value9`,`effect_limit_value10`,`effect_limit_value11`,`effect_limit_value12`,`max1`,`max2`,`max3`,`max4`,`max5`,`max6`,`max7`,`max8`,`max9`,`max10`,`max11`,`max12`,`icon`,`memicon`,`components1`,`components2`,`components3`,`components4`,`component_counts1`,`component_counts2`,`component_counts3`,`component_counts4`,`NoexpendReagent1`,`NoexpendReagent2`,`NoexpendReagent3`,`NoexpendReagent4`,`formula1`,`formula2`,`formula3`,`formula4`,`formula5`,`formula6`,`formula7`,`formula8`,`formula9`,`formula10`,`formula11`,`formula12`,`LightType`,`goodEffect`,`Activated`,`resisttype`,`effectid1`,`effectid2`,`effectid3`,`effectid4`,`effectid5`,`effectid6`,`effectid7`,`effectid8`,`effectid9`,`effectid10`,`effectid11`,`effectid12`,`targettype`,`basediff`,`skill`,`zonetype`,`EnvironmentType`,`TimeOfDay`,`classes1`,`classes2`,`classes3`,`classes4`,`classes5`,`classes6`,`classes7`,`classes8`,`classes9`,`classes10`,`classes11`,`classes12`,`classes13`,`classes14`,`classes15`,`classes16`,`CastingAnim`,`TargetAnim`,`TravelType`,`SpellAffectIndex`,`disallow_sit`,`deities0`,`deities1`,`deities2`,`deities3`,`deities4`,`deities5`,`deities6`,`deities7`,`deities8`,`deities9`,`deities10`,`deities11`,`deities12`,`deities13`,`deities14`,`deities15`,`deities16`,`field142`,`field143`,`new_icon`,`spellanim`,`uninterruptable`,`ResistDiff`,`dot_stacking_exempt`,`deleteable`,`RecourseLink`,`no_partial_resist`,`field152`,`field153`,`short_buff_box`,`descnum`,`typedescnum`,`effectdescnum`,`effectdescnum2`,`npc_no_los`,`field160`,`reflectable`,`bonushate`,`field163`,`field164`,`ldon_trap`,`EndurCost`,`EndurTimerIndex`,`IsDiscipline`,`field169`,`field170`,`field171`,`field172`,`HateAdded`,`EndurUpkeep`,`numhitstype`,`numhits`,`pvpresistbase`,`pvpresistcalc`,`pvpresistcap`,`spell_category`,`pvp_duration`,`pvp_duration_cap`,`pcnpc_only_flag`,`cast_not_standing`,`can_mgb`,`nodispell`,`npc_category`,`npc_usefulness`,`MinResist`,`MaxResist`,`viral_targets`,`viral_timer`,`nimbuseffect`,`ConeStartAngle`,`ConeStopAngle`,`sneaking`,`not_extendable`,`field198`,`field199`,`suspendable`,`viral_range`,`songcap`,`field203`,`field204`,`no_block`,`field206`,`spellgroup`,`rank`,`field209`,`field210`,`CastRestriction`,`allowrest`,`InCombat`,`OutofCombat`,`field215`,`field216`,`field217`,`aemaxtargets`,`maxtargets`,`field220`,`field221`,`field222`,`field223`,`persistdeath`,`field225`,`field226`,`min_dist`,`min_dist_mod`,`max_dist`,`max_dist_mod`,`min_range`,`field232`,`field233`,`field234`,`field235`,`field236`)
SELECT 42702,'Bliss',`player_1`,`teleport_zone`,`you_cast`,`other_casts`,`cast_on_you`,`cast_on_other`,`spell_fades`,`range`,`aoerange`,`pushback`,`pushup`,`cast_time`,`recovery_time`,`recast_time`,`buffdurationformula`,`buffduration`,`AEDuration`,`mana`,`effect_base_value1`,`effect_base_value2`,`effect_base_value3`,`effect_base_value4`,`effect_base_value5`,`effect_base_value6`,`effect_base_value7`,`effect_base_value8`,`effect_base_value9`,`effect_base_value10`,`effect_base_value11`,`effect_base_value12`,`effect_limit_value1`,`effect_limit_value2`,`effect_limit_value3`,`effect_limit_value4`,`effect_limit_value5`,`effect_limit_value6`,`effect_limit_value7`,`effect_limit_value8`,`effect_limit_value9`,`effect_limit_value10`,`effect_limit_value11`,`effect_limit_value12`,72,`max2`,`max3`,`max4`,`max5`,`max6`,`max7`,`max8`,`max9`,`max10`,`max11`,`max12`,`icon`,`memicon`,`components1`,`components2`,`components3`,`components4`,`component_counts1`,`component_counts2`,`component_counts3`,`component_counts4`,`NoexpendReagent1`,`NoexpendReagent2`,`NoexpendReagent3`,`NoexpendReagent4`,`formula1`,`formula2`,`formula3`,`formula4`,`formula5`,`formula6`,`formula7`,`formula8`,`formula9`,`formula10`,`formula11`,`formula12`,`LightType`,`goodEffect`,`Activated`,`resisttype`,`effectid1`,`effectid2`,`effectid3`,`effectid4`,`effectid5`,`effectid6`,`effectid7`,`effectid8`,`effectid9`,`effectid10`,`effectid11`,`effectid12`,`targettype`,`basediff`,`skill`,`zonetype`,`EnvironmentType`,`TimeOfDay`,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,`CastingAnim`,`TargetAnim`,`TravelType`,`SpellAffectIndex`,`disallow_sit`,`deities0`,`deities1`,`deities2`,`deities3`,`deities4`,`deities5`,`deities6`,`deities7`,`deities8`,`deities9`,`deities10`,`deities11`,`deities12`,`deities13`,`deities14`,`deities15`,`deities16`,`field142`,`field143`,`new_icon`,`spellanim`,`uninterruptable`,`ResistDiff`,`dot_stacking_exempt`,`deleteable`,`RecourseLink`,`no_partial_resist`,`field152`,`field153`,`short_buff_box`,`descnum`,`typedescnum`,`effectdescnum`,`effectdescnum2`,`npc_no_los`,`field160`,`reflectable`,`bonushate`,`field163`,`field164`,`ldon_trap`,`EndurCost`,`EndurTimerIndex`,`IsDiscipline`,`field169`,`field170`,`field171`,`field172`,`HateAdded`,`EndurUpkeep`,`numhitstype`,`numhits`,`pvpresistbase`,`pvpresistcalc`,`pvpresistcap`,`spell_category`,`pvp_duration`,`pvp_duration_cap`,`pcnpc_only_flag`,`cast_not_standing`,`can_mgb`,`nodispell`,`npc_category`,`npc_usefulness`,`MinResist`,`MaxResist`,`viral_targets`,`viral_timer`,`nimbuseffect`,`ConeStartAngle`,`ConeStopAngle`,`sneaking`,`not_extendable`,`field198`,`field199`,`suspendable`,`viral_range`,`songcap`,`field203`,`field204`,`no_block`,`field206`,`spellgroup`,`rank`,`field209`,`field210`,`CastRestriction`,`allowrest`,`InCombat`,`OutofCombat`,`field215`,`field216`,`field217`,`aemaxtargets`,`maxtargets`,`field220`,`field221`,`field222`,`field223`,`persistdeath`,`field225`,`field226`,`min_dist`,`min_dist_mod`,`max_dist`,`max_dist_mod`,`min_range`,`field232`,`field233`,`field234`,`field235`,`field236` FROM `spells_new` WHERE id=3358;

INSERT INTO `db_str` (`id`,`type`,`value`) VALUES
(49200,1,'Pious Elixir'),
(49200,2,'Pious'),
(49200,3,'Elixir'),
(49200,4,'Restores health over time to an ally.'),
(49201,1,'Self Protection'),
(49201,2,'Self'),
(49201,3,'Guard'),
(49201,4,'Increases your armor class.'),
(49202,1,'Local Slow'),
(49202,2,'Local'),
(49202,3,'Slow'),
(49202,4,'Reduces your target''s attack rate by 20 percent.'),
(49203,1,'Bliss'),
(49203,2,'Bliss'),
(49203,4,'Entrances an eligible foe in Illsalin Marketplace.');

INSERT INTO `aa_ability` (`id`,`name`,`category`,`classes`,`grant_only`,`first_rank_id`,`enabled`,`reset_on_death`,`auto_grant_enabled`,`type`) VALUES
(49100,'Innate Run Speed',3,10499,0,49100,1,0,0,1),
(49105,'Combat Stability',3,1,0,49105,1,0,0,1),
(49110,'Combat Agility',3,1,0,49110,1,0,0,1),
(49115,'Combat Fury',3,257,0,49115,1,0,0,1),
(49120,'Innate Dexterity',3,256,0,49120,1,0,0,1),
(49125,'Mental Clarity',3,10242,0,49125,1,0,0,1),
(49130,'Improved Healing',3,2,0,49130,1,0,0,1),
(49135,'Spell Haste',3,10242,0,49135,1,0,0,1),
(49140,'Mana Preservation',3,10242,0,49140,1,0,0,1),
(49145,'Enraged Shout',4,1,1,49145,1,0,0,1),
(49146,'Complete Heal',4,2,1,49146,1,0,0,1),
(49147,'Pious Elixir',4,2,1,49147,1,0,0,1),
(49148,'Soul Reprisal',4,2,1,49148,1,0,0,1),
(49149,'Radiant Cure',4,2,1,49149,1,0,0,1),
(49150,'Self Protection',4,2,1,49150,1,0,0,1),
(49151,'Darkflame',4,2048,1,49151,1,0,0,1),
(49152,'Deepspite',4,2048,1,49152,1,0,0,1),
(49153,'Lightfade',4,2048,1,49153,1,0,0,1),
(49154,'Local Slow',4,8192,1,49154,1,0,0,1),
(49155,'Bliss',4,8192,1,49155,1,0,0,1),
(49156,'Draygun''s Psyche',4,8192,1,49156,1,0,0,1),
(49157,'Self Protection',4,8192,1,49157,1,0,0,1);

INSERT INTO `aa_ranks` (`id`,`upper_hotkey_sid`,`lower_hotkey_sid`,`title_sid`,`desc_sid`,`cost`,`level_req`,`spell`,`spell_type`,`recast_time`,`expansion`,`prev_id`,`next_id`) VALUES
(49100,3000,3000,3000,3000,1,51,-1,0,0,0,-1,49101),
(49101,3000,3000,3000,3000,2,55,-1,0,0,0,49100,49102),
(49102,3000,3000,3000,3000,3,60,-1,0,0,0,49101,49103),
(49103,3000,3000,3000,3000,4,65,-1,0,0,0,49102,49104),
(49104,3000,3000,3000,3000,5,70,-1,0,0,0,49103,-1),
(49105,3025,3025,3025,3025,2,50,-1,0,0,0,-1,49106),
(49106,3025,3025,3025,3025,3,55,-1,0,0,0,49105,49107),
(49107,3025,3025,3025,3025,4,60,-1,0,0,0,49106,49108),
(49108,3025,3025,3025,3025,5,65,-1,0,0,0,49107,49109),
(49109,3025,3025,3025,3025,6,70,-1,0,0,0,49108,-1),
(49110,3030,3030,3030,3030,2,50,-1,0,0,0,-1,49111),
(49111,3030,3030,3030,3030,3,55,-1,0,0,0,49110,49112),
(49112,3030,3030,3030,3030,4,60,-1,0,0,0,49111,49113),
(49113,3030,3030,3030,3030,5,65,-1,0,0,0,49112,49114),
(49114,3030,3030,3030,3030,6,70,-1,0,0,0,49113,-1),
(49115,3035,3035,3035,3035,2,50,-1,0,0,0,-1,49116),
(49116,3035,3035,3035,3035,3,55,-1,0,0,0,49115,49117),
(49117,3035,3035,3035,3035,4,60,-1,0,0,0,49116,49118),
(49118,3035,3035,3035,3035,5,65,-1,0,0,0,49117,49119),
(49119,3035,3035,3035,3035,6,70,-1,0,0,0,49118,-1),
(49120,3171,3171,3171,3171,1,25,-1,0,0,0,-1,49121),
(49121,3171,3171,3171,3171,1,30,-1,0,0,0,49120,49122),
(49122,3171,3171,3171,3171,1,35,-1,0,0,0,49121,49123),
(49123,3171,3171,3171,3171,2,40,-1,0,0,0,49122,49124),
(49124,3171,3171,3171,3171,2,45,-1,0,0,0,49123,-1),
(49125,3287,3287,3287,3287,2,25,-1,0,0,0,-1,49126),
(49126,3287,3287,3287,3287,2,30,-1,0,0,0,49125,49127),
(49127,3287,3287,3287,3287,2,35,-1,0,0,0,49126,49128),
(49128,3287,3287,3287,3287,4,40,-1,0,0,0,49127,49129),
(49129,3287,3287,3287,3287,4,45,-1,0,0,0,49128,-1),
(49130,3347,3347,3347,3347,1,20,-1,0,0,0,-1,49131),
(49131,3347,3347,3347,3347,2,20,-1,0,0,0,49130,49132),
(49132,3347,3347,3347,3347,3,20,-1,0,0,0,49131,49133),
(49133,3347,3347,3347,3347,4,20,-1,0,0,0,49132,49134),
(49134,3347,3347,3347,3347,6,55,-1,0,0,0,49133,-1),
(49135,3357,3357,3357,3357,2,20,-1,0,0,0,-1,49136),
(49136,3357,3357,3357,3357,3,20,-1,0,0,0,49135,49137),
(49137,3357,3357,3357,3357,4,20,-1,0,0,0,49136,49138),
(49138,3357,3357,3357,3357,6,55,-1,0,0,0,49137,49139),
(49139,3357,3357,3357,3357,8,55,-1,0,0,0,49138,-1),
(49140,3365,3365,3365,3365,1,20,-1,0,0,0,-1,49141),
(49141,3365,3365,3365,3365,2,20,-1,0,0,0,49140,49142),
(49142,3365,3365,3365,3365,3,20,-1,0,0,0,49141,49143),
(49143,3365,3365,3365,3365,4,20,-1,0,0,0,49142,49144),
(49144,3365,3365,3365,3365,6,55,-1,0,0,0,49143,-1),
(49145,4234,4234,4234,4234,0,70,8255,1900,30,0,-1,-1),
(49146,13,13,13,13,0,70,13,1901,12,0,-1,-1),
(49147,49200,49200,49200,49200,0,70,5259,1902,6,0,-1,-1),
(49148,4228,4228,4228,4228,0,70,8249,1903,4,0,-1,-1),
(49149,459,459,459,459,0,70,3299,1904,60,0,-1,-1),
(49150,49201,49201,49201,49201,0,70,42700,1905,60,0,-1,-1),
(49151,4232,4232,4232,4232,0,70,8253,1906,8,0,-1,-1),
(49152,4229,-1,4229,4229,0,70,8250,1907,8,0,-1,-1),
(49153,4233,-1,4233,4233,0,70,8254,1908,12,0,-1,-1),
(49154,49202,49202,49202,49202,0,70,42701,1909,8,0,-1,-1),
(49155,49203,-1,49203,49203,0,70,42702,1910,8,0,-1,-1),
(49156,4231,4231,4231,4231,0,70,8252,1911,60,0,-1,-1),
(49157,49201,49201,49201,49201,0,70,42700,1912,60,0,-1,-1);

INSERT INTO `aa_rank_effects` (`rank_id`,`slot`,`effect_id`,`base1`,`base2`) VALUES
(49100,1,271,8,0),
(49101,1,271,14,0),
(49102,1,271,21,0),
(49103,1,271,28,0),
(49104,1,271,35,0),
(49105,1,259,2,0),
(49106,1,259,4,0),
(49107,1,259,6,0),
(49108,1,259,8,0),
(49109,1,259,10,0),
(49110,1,172,2,0),
(49111,1,172,4,0),
(49112,1,172,6,0),
(49113,1,172,8,0),
(49114,1,172,10,0),
(49115,1,169,15,-1),
(49116,1,169,30,-1),
(49117,1,169,45,-1),
(49118,1,169,60,-1),
(49119,1,169,75,-1),
(49120,1,5,2,0),
(49121,1,5,4,0),
(49122,1,5,6,0),
(49123,1,5,8,0),
(49124,1,5,10,0),
(49125,1,15,1,0),
(49126,1,15,2,0),
(49127,1,15,3,0),
(49128,1,15,4,0),
(49129,1,15,5,0),
(49130,1,125,5,5),
(49130,2,137,0,0),
(49130,3,141,1,0),
(49130,4,138,1,0),
(49130,5,139,-13,0),
(49130,6,139,-1292,0),
(49130,7,137,-147,0),
(49130,8,311,0,0),
(49131,1,125,10,10),
(49131,2,137,0,0),
(49131,3,141,1,0),
(49131,4,138,1,0),
(49131,5,139,-13,0),
(49131,6,139,-1292,0),
(49131,7,137,-147,0),
(49131,8,311,0,0),
(49132,1,125,15,15),
(49132,2,137,0,0),
(49132,3,141,1,0),
(49132,4,138,1,0),
(49132,5,139,-13,0),
(49132,6,139,-1292,0),
(49132,7,137,-147,0),
(49132,8,311,0,0),
(49133,1,125,20,20),
(49133,2,137,0,0),
(49133,3,141,1,0),
(49133,4,138,1,0),
(49133,5,139,-13,0),
(49133,6,139,-1292,0),
(49133,7,137,-147,0),
(49133,8,311,0,0),
(49134,1,125,25,25),
(49134,2,137,0,0),
(49134,3,141,1,0),
(49134,4,138,1,0),
(49134,5,139,-13,0),
(49134,6,139,-1292,0),
(49134,7,137,-147,0),
(49134,8,311,0,0),
(49135,1,127,5,0),
(49135,2,139,-13,0),
(49135,3,143,3000,0),
(49135,4,311,0,0),
(49136,1,127,8,0),
(49136,2,139,-13,0),
(49136,3,143,3000,0),
(49136,4,311,0,0),
(49137,1,127,10,0),
(49137,2,139,-13,0),
(49137,3,143,3000,0),
(49137,4,311,0,0),
(49138,1,127,13,0),
(49138,2,139,-13,0),
(49138,3,143,3000,0),
(49138,4,311,0,0),
(49139,1,127,15,0),
(49139,2,139,-13,0),
(49139,3,143,3000,0),
(49139,4,311,0,0),
(49140,1,132,2,2),
(49140,2,139,-13,0),
(49140,3,311,0,0),
(49141,1,132,4,4),
(49141,2,139,-13,0),
(49141,3,311,0,0),
(49142,1,132,6,6),
(49142,2,139,-13,0),
(49142,3,311,0,0),
(49143,1,132,8,8),
(49143,2,139,-13,0),
(49143,3,311,0,0),
(49144,1,132,10,10),
(49144,2,139,-13,0),
(49144,3,311,0,0);

INSERT INTO spirit_shroud_templates (`id`,`progression_id`,`branch_id`,`level`,`race`,`class_id`,`gender`,`hp`,`mana`,`endurance`,`base_stat`,`unlock_xp`,`name`,`description`,`progression_name`,`branch_name`,`enabled`,`content_version`,`verified`,`test_only`,`evidence_ref`,`monster_points`,`stat_str`,`stat_sta`,`stat_cha`,`stat_dex`,`stat_int`,`stat_agi`,`stat_wis`,`native_hp`,`native_mana`,`native_endurance`,`native_hp_regen`,`native_mana_regen_sitting`,`native_mana_regen_standing`,`native_endurance_regen`,`native_cold`,`native_fire`,`native_magic`,`native_disease`,`native_poison`,`native_additional_resist`,`native_corruption`,`native_ac`,`native_attack`,`native_unarmed_damage`,`native_unarmed_delay`,`resource_maxima`,`model_size`) VALUES
(90500,920243,1,70,467,1,0,12500,0,7000,100,0,'Shiliskin Warrior','Disabled reconstructed Fall form','Fall of Illsalin Normal','Warrior',0,1,0,1,'fall-normal-reconstructed-20261120',104,250,250,90,215,85,200,95,12500,0,7000,20,0,0,25,100,100,100,100,100,0,0,200,135,4,30,1,6.0),
(90501,920243,2,70,467,2,0,9500,14000,5200,100,0,'Shiliskin Cleric','Disabled reconstructed Fall form','Fall of Illsalin Normal','Cleric',0,1,0,1,'fall-normal-reconstructed-20261120',104,145,190,145,125,135,135,250,9500,14000,5200,20,30,12,25,100,100,100,100,100,0,0,135,45,4,30,1,6.0),
(90502,920243,9,70,467,9,0,10500,0,6800,100,0,'Shiliskin Rogue','Disabled reconstructed Fall form','Fall of Illsalin Normal','Rogue',0,1,0,1,'fall-normal-reconstructed-20261120',104,220,205,100,250,105,250,100,10500,0,6800,20,0,0,25,100,100,100,100,100,0,0,145,160,4,30,1,6.0),
(90503,920243,12,70,467,12,0,8000,14000,4800,100,0,'Shiliskin Wizard','Disabled reconstructed Fall form','Fall of Illsalin Normal','Wizard',0,1,0,1,'fall-normal-reconstructed-20261120',104,90,160,105,130,250,140,140,8000,14000,4800,20,30,12,25,100,100,100,100,100,0,0,95,25,4,30,1,6.0),
(90504,920243,14,70,467,14,0,8500,14000,5000,100,0,'Shiliskin Enchanter','Disabled reconstructed Fall form','Fall of Illsalin Normal','Enchanter',0,1,0,1,'fall-normal-reconstructed-20261120',104,95,170,235,140,250,145,140,8500,14000,5000,20,30,12,25,100,100,100,100,100,0,0,105,30,4,30,1,6.0);
INSERT INTO fall_shroud_roles (`class_id`,`template_id`) VALUES
(1,90500),
(2,90501),
(9,90502),
(12,90503),
(14,90504);
INSERT INTO fall_shroud_skills (`template_id`,`skill_id`,`skill_value`) VALUES
(90500,1,310),
(90500,10,350),
(90500,15,300),
(90500,19,330),
(90500,20,260),
(90500,28,255),
(90500,30,325),
(90500,33,270),
(90500,34,330),
(90500,37,280),
(90500,73,230),
(90501,0,280),
(90501,4,310),
(90501,5,310),
(90501,10,275),
(90501,13,220),
(90501,14,310),
(90501,15,270),
(90501,19,280),
(90501,24,310),
(90501,28,210),
(90501,31,375),
(90501,33,215),
(90502,8,240),
(90502,15,290),
(90502,19,330),
(90502,20,260),
(90502,22,260),
(90502,28,255),
(90502,29,200),
(90502,33,270),
(90502,34,305),
(90502,36,310),
(90502,37,230),
(90502,42,200),
(90503,0,255),
(90503,4,310),
(90503,5,310),
(90503,13,220),
(90503,14,310),
(90503,15,260),
(90503,19,255),
(90503,24,310),
(90503,28,210),
(90503,31,375),
(90503,33,150),
(90504,4,310),
(90504,5,310),
(90504,13,220),
(90504,14,310),
(90504,15,260),
(90504,19,255),
(90504,24,310),
(90504,28,210),
(90504,31,375),
(90504,33,150),
(90504,36,255);
INSERT INTO spirit_shroud_starter_equipment (`template_id`,`slot_id`,`item_id`) VALUES
(90500,13,900103),
(90500,14,900100),
(90501,13,900104),
(90502,13,900102),
(90502,14,900101),
(90503,13,900104),
(90504,13,900105);
INSERT INTO spirit_shroud_abilities (`template_id`,`rank_id`,`free_grant`) VALUES
(90500,49145,1),
(90500,49100,0),
(90500,49101,0),
(90500,49102,0),
(90500,49103,0),
(90500,49104,0),
(90500,49105,0),
(90500,49106,0),
(90500,49107,0),
(90500,49108,0),
(90500,49109,0),
(90500,49110,0),
(90500,49111,0),
(90500,49112,0),
(90500,49113,0),
(90500,49114,0),
(90500,49115,0),
(90500,49116,0),
(90500,49117,0),
(90500,49118,0),
(90500,49119,0),
(90501,49146,1),
(90501,49147,1),
(90501,49148,1),
(90501,49149,1),
(90501,49150,1),
(90501,49100,0),
(90501,49101,0),
(90501,49102,0),
(90501,49103,0),
(90501,49104,0),
(90501,49125,0),
(90501,49126,0),
(90501,49127,0),
(90501,49128,0),
(90501,49129,0),
(90501,49130,0),
(90501,49131,0),
(90501,49132,0),
(90501,49133,0),
(90501,49134,0),
(90501,49135,0),
(90501,49136,0),
(90501,49137,0),
(90501,49138,0),
(90501,49139,0),
(90501,49140,0),
(90501,49141,0),
(90501,49142,0),
(90501,49143,0),
(90501,49144,0),
(90502,49100,0),
(90502,49101,0),
(90502,49102,0),
(90502,49103,0),
(90502,49104,0),
(90502,49115,0),
(90502,49116,0),
(90502,49117,0),
(90502,49118,0),
(90502,49119,0),
(90502,49120,0),
(90502,49121,0),
(90502,49122,0),
(90502,49123,0),
(90502,49124,0),
(90503,49151,1),
(90503,49152,1),
(90503,49153,1),
(90503,49100,0),
(90503,49101,0),
(90503,49102,0),
(90503,49103,0),
(90503,49104,0),
(90503,49125,0),
(90503,49126,0),
(90503,49127,0),
(90503,49128,0),
(90503,49129,0),
(90503,49135,0),
(90503,49136,0),
(90503,49137,0),
(90503,49138,0),
(90503,49139,0),
(90503,49140,0),
(90503,49141,0),
(90503,49142,0),
(90503,49143,0),
(90503,49144,0),
(90504,49154,1),
(90504,49155,1),
(90504,49156,1),
(90504,49157,1),
(90504,49100,0),
(90504,49101,0),
(90504,49102,0),
(90504,49103,0),
(90504,49104,0),
(90504,49125,0),
(90504,49126,0),
(90504,49127,0),
(90504,49128,0),
(90504,49129,0),
(90504,49135,0),
(90504,49136,0),
(90504,49137,0),
(90504,49138,0),
(90504,49139,0),
(90504,49140,0),
(90504,49141,0),
(90504,49142,0),
(90504,49143,0),
(90504,49144,0);

IF (SELECT COUNT(*) FROM items WHERE id IN (900100,900101,900102,900103,900104,900105))<>6 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall items disabled postimage incomplete';
END IF;

IF (SELECT COUNT(*) FROM spells_new WHERE id IN (42700,42701,42702))<>3 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall spells_new disabled postimage incomplete';
END IF;

IF (SELECT COUNT(*) FROM db_str WHERE id IN (49200,49201,49202,49203))<>15 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall db_str disabled postimage incomplete';
END IF;

IF (SELECT COUNT(*) FROM aa_ability WHERE id IN (49100,49105,49110,49115,49120,49125,49130,49135,49140,49145,49146,49147,49148,49149,49150,49151,49152,49153,49154,49155,49156,49157))<>22 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall aa_ability disabled postimage incomplete';
END IF;

IF (SELECT COUNT(*) FROM aa_ranks WHERE id IN (49100,49101,49102,49103,49104,49105,49106,49107,49108,49109,49110,49111,49112,49113,49114,49115,49116,49117,49118,49119,49120,49121,49122,49123,49124,49125,49126,49127,49128,49129,49130,49131,49132,49133,49134,49135,49136,49137,49138,49139,49140,49141,49142,49143,49144,49145,49146,49147,49148,49149,49150,49151,49152,49153,49154,49155,49156,49157))<>58 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall aa_ranks disabled postimage incomplete';
END IF;

IF (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id IN (49100,49101,49102,49103,49104,49105,49106,49107,49108,49109,49110,49111,49112,49113,49114,49115,49116,49117,49118,49119,49120,49121,49122,49123,49124,49125,49126,49127,49128,49129,49130,49131,49132,49133,49134,49135,49136,49137,49138,49139,49140,49141,49142,49143,49144,49145,49146,49147,49148,49149,49150,49151,49152,49153,49154,49155,49156,49157))<>105 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall aa_rank_effects disabled postimage incomplete';
END IF;

IF (SELECT COUNT(*) FROM spirit_shroud_templates WHERE id IN (90500,90501,90502,90503,90504))<>5 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall spirit_shroud_templates disabled postimage incomplete';
END IF;

IF (SELECT COUNT(*) FROM spirit_shroud_templates WHERE id BETWEEN 90500 AND 90504 AND enabled=0 AND verified=0 AND test_only=1 AND race=467 AND level=70)<>5 OR (SELECT COUNT(*) FROM fall_shroud_roles WHERE template_id BETWEEN 90500 AND 90504)<>5 OR (SELECT COUNT(*) FROM spirit_shroud_abilities WHERE template_id BETWEEN 90500 AND 90504)<>113 OR (SELECT COUNT(*) FROM spirit_shroud_starter_equipment WHERE template_id BETWEEN 90500 AND 90504)<>7 OR (SELECT COUNT(*) FROM fall_shroud_skills WHERE template_id BETWEEN 90500 AND 90504)<>57 OR EXISTS(SELECT 1 FROM fall_shroud_config WHERE enabled<>0) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fall inactive bindings or count differs';
END IF;
COMMIT;
END//
DELIMITER ;
