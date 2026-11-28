-- Offline candidate. Two exact May-era Slayer titles, each with a prefix and suffix.
DELIMITER $$
BEGIN NOT ATOMIC
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    START TRANSACTION;
    IF NOT EXISTS (SELECT 1 FROM achievements WHERE id=11000031 AND BINARY name='Short People' AND has_reward=1 AND version=0)
        OR NOT EXISTS (SELECT 1 FROM achievements WHERE id=11000046 AND BINARY name='Gnolling is Half the Battle' AND has_reward=1 AND version=0)
        OR (SELECT COUNT(*) FROM achievement_criteria WHERE achievement_id=11000031)<>8
        OR (SELECT COUNT(*) FROM achievement_criteria WHERE achievement_id=11000046)<>3
        OR (SELECT COUNT(DISTINCT target_id) FROM achievement_criteria WHERE achievement_id=11000031 AND component_id=300215
            AND component_type=1 AND component_sequence=1 AND event_type=3 AND required_count=1000 AND enabled=1
            AND progress_mode=0 AND behavior=0 AND target_id2=0 AND target_value=0 AND target_id IN (8,11,12,81,94,183,645,646))<>8
        OR (SELECT COUNT(DISTINCT target_id) FROM achievement_criteria WHERE achievement_id=11000046 AND component_id=300230
            AND component_type=1 AND component_sequence=1 AND event_type=3 AND required_count=1000 AND enabled=1
            AND progress_mode=0 AND behavior=0 AND target_id2=0 AND target_value=0 AND target_id IN (39,524,617))<>3
        OR EXISTS (SELECT 1 FROM titles WHERE id IN (304101030,304101031) OR title_set IN (304101030,304101031)
            OR prefix IN ('Gnome Slayer','Gnoll Slayer') OR suffix IN ('the Gnome Slayer','the Gnoll Slayer'))
        OR EXISTS (SELECT 1 FROM player_titlesets WHERE title_set IN (304101030,304101031))
        OR EXISTS (SELECT 1 FROM rewards WHERE reward_id IN (304101032,304101033)
            OR (reward_type=5 AND reward_data_id IN (304101030,304101031)))
        OR EXISTS (SELECT 1 FROM reward_sources WHERE source_type=1 AND source_id IN (11000031,11000046))
        OR EXISTS (SELECT 1 FROM reward_source_entries WHERE (source_type=1 AND source_id IN (11000031,11000046))
            OR reward_id IN (304101032,304101033))
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Slayer title exact preimage mismatch'; END IF;

    INSERT INTO titles (id,prefix,suffix,title_set)
        VALUES (304101030,'Gnome Slayer','the Gnome Slayer',304101030),
               (304101031,'Gnoll Slayer','the Gnoll Slayer',304101031);
    IF ROW_COUNT() <> 2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Slayer title insert count mismatch'; END IF;

    INSERT INTO rewards (reward_id,reward_type,reward_data_id,amount,description,enabled)
        VALUES (304101032,5,304101030,1,'Gnome Slayer title and suffix',1),
               (304101033,5,304101031,1,'Gnoll Slayer title and suffix',1);
    IF ROW_COUNT() <> 2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Slayer title reward insert count mismatch'; END IF;

    INSERT INTO reward_source_entries (source_type,source_id,sequence,reward_id)
        VALUES (1,11000031,0,304101032),(1,11000046,0,304101033);
    IF ROW_COUNT() <> 2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Slayer title source insert count mismatch'; END IF;
    COMMIT;
END$$
DELIMITER ;
