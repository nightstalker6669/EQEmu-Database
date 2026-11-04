-- TENTATIVE9343 source candidate, not frozen/registered/executed.
-- Four period-supported language siblings only; Master9342 is untouched.
-- All parents and new criteria remain disabled. No rewards/player rows changed.
CREATE PROCEDURE install_alaran_family_9343_candidate()
BEGIN
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
 IF (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE()
     AND TABLE_NAME='achievement_criteria' AND ENGINE='InnoDB')<>1
 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Alaran family requires transactional criteria'; END IF;
 START TRANSACTION;
 IF (SELECT COUNT(*) FROM achievements a WHERE (a.id=1900045 AND a.name=CONVERT(0x416c6172616e204c616e6775616765204177617265 USING utf8mb4) AND a.points=10 AND a.enabled=0) OR (a.id=1900046 AND a.name=CONVERT(0x416c6172616e204c616e6775616765204e6f76696365 USING utf8mb4) AND a.points=10 AND a.enabled=0) OR (a.id=1900047 AND a.name=CONVERT(0x416c6172616e204c616e677561676520466c75656e74 USING utf8mb4) AND a.points=10 AND a.enabled=0) OR (a.id=1900048 AND a.name=CONVERT(0x416c6172616e204c616e677561676520457870657274 USING utf8mb4) AND a.points=10 AND a.enabled=0))<>4
 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Alaran family parent identities mismatch'; END IF;
 IF (SELECT COUNT(*) FROM achievement_components WHERE achievement_id BETWEEN 1900045 AND 1900048 AND component_type=1)<>4
 OR (SELECT COUNT(*) FROM achievement_components WHERE (achievement_id=1900045 AND component_type=1 AND sequence=1 AND component_id=1900045 AND name=CONVERT(0x416c6172616e204c616e67756167653a203235 USING utf8mb4) AND description='') OR (achievement_id=1900046 AND component_type=1 AND sequence=1 AND component_id=1900046 AND name=CONVERT(0x416c6172616e204c616e67756167653a203530 USING utf8mb4) AND description='') OR (achievement_id=1900047 AND component_type=1 AND sequence=1 AND component_id=1900047 AND name=CONVERT(0x416c6172616e204c616e67756167653a203731 USING utf8mb4) AND description='') OR (achievement_id=1900048 AND component_type=1 AND sequence=1 AND component_id=1900048 AND name=CONVERT(0x416c6172616e204c616e67756167653a203930 USING utf8mb4) AND description=''))<>4
 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Alaran family required identities mismatch'; END IF;
 IF EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id BETWEEN 1900045 AND 1900048)
 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Alaran family criterion collision'; END IF;
 IF EXISTS(SELECT 1 FROM reward_sources WHERE source_type=1 AND source_id BETWEEN 1900045 AND 1900048)
 OR EXISTS(SELECT 1 FROM reward_source_entries WHERE source_type=1 AND source_id BETWEEN 1900045 AND 1900048)
 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Alaran family reward policy changed'; END IF;
 INSERT INTO achievement_criteria
 (achievement_id,component_type,component_sequence,component_id,event_type,progress_mode,
 behavior,target_id,target_id2,target_value,required_count,enabled) VALUES
(1900045,1,1,1900045,0,3,0,0,0,0,1,0),
(1900046,1,1,1900046,0,3,0,0,0,0,1,0),
(1900047,1,1,1900047,0,3,0,0,0,0,1,0),
(1900048,1,1,1900048,0,3,0,0,0,0,1,0);
 COMMIT;
END;
CALL install_alaran_family_9343_candidate();
DROP PROCEDURE install_alaran_family_9343_candidate;
