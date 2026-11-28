-- May 2013 Slayer award for I'm a People Person! (11000028). Existing component progress is conserved.
DELIMITER $$
BEGIN NOT ATOMIC
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    START TRANSACTION;
    IF (SELECT COALESCE(SHA2(GROUP_CONCAT(d ORDER BY d SEPARATOR ''),256),'') FROM (SELECT SHA2(JSON_ARRAY(`id`,`name`,`description`,`icon_id`,`points`,`has_reward`,`client_flag`,`version`,`reset_on_version_change`,`enabled`),256) d FROM achievements WHERE id=11000028) exact_rows)<>'bcdda941ef14e385cc1f9a3f567be696912c77b0e2f8eb7a70f99334d2cbce52' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Ambassador exact preimage mismatch achievements'; END IF;
    IF (SELECT COALESCE(SHA2(GROUP_CONCAT(d ORDER BY d SEPARATOR ''),256),'') FROM (SELECT SHA2(JSON_ARRAY(`achievement_id`,`component_type`,`sequence`,`component_id`,`name`,`description`),256) d FROM achievement_components WHERE achievement_id=11000028) exact_rows)<>'77d38d90c924461d9e8256e67d4774819781f30fc9f1dce7d1d19d8619798ff6' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Ambassador exact preimage mismatch achievement_components'; END IF;
    IF (SELECT COALESCE(SHA2(GROUP_CONCAT(d ORDER BY d SEPARATOR ''),256),'') FROM (SELECT SHA2(JSON_ARRAY(`component_id`,`required_count`),256) d FROM achievement_associations WHERE component_id IN (300197,300198,300199,300200,300201,300202,300203,300204,300205,300206,300207,300208,300209,300210,300211,300212)) exact_rows)<>'367654c26ab149e69862d72a6c9142221ffffda5fd19cc216af1cdad3c2f78a4' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Ambassador exact preimage mismatch achievement_associations'; END IF;
    IF (SELECT COALESCE(SHA2(GROUP_CONCAT(d ORDER BY d SEPARATOR ''),256),'') FROM (SELECT SHA2(JSON_ARRAY(`id`,`achievement_id`,`component_type`,`component_sequence`,`component_id`,`event_type`,`progress_mode`,`behavior`,`target_id`,`target_id2`,`target_value`,`required_count`,`enabled`),256) d FROM achievement_criteria WHERE achievement_id=11000028) exact_rows)<>'33ead4c2dad6824a0ce90c7c6da7501b51b86922f5b544610e54de1a5ef0f2c6' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Ambassador exact preimage mismatch achievement_criteria'; END IF;
    IF EXISTS (SELECT 1 FROM titles WHERE id=304101774 OR title_set=304101774 OR prefix='Ambassador' OR suffix='the Ambassador') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Ambassador reserved scope occupied titles'; END IF;
    IF EXISTS (SELECT 1 FROM player_titlesets WHERE title_set=304101774) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Ambassador reserved scope occupied player_titlesets'; END IF;
    IF EXISTS (SELECT 1 FROM rewards WHERE reward_id=304101775 OR (reward_type=5 AND reward_data_id=304101774)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Ambassador reserved scope occupied rewards'; END IF;
    IF EXISTS (SELECT 1 FROM reward_sources WHERE source_type=1 AND source_id=11000028) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Ambassador reserved scope occupied reward_sources'; END IF;
    IF EXISTS (SELECT 1 FROM reward_source_entries WHERE (source_type=1 AND source_id=11000028) OR reward_id=304101775) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Ambassador reserved scope occupied reward_source_entries'; END IF;
    INSERT INTO titles (id,prefix,suffix,title_set) VALUES (304101774,'Ambassador','the Ambassador',304101774);
    IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Ambassador title insert count mismatch'; END IF;
    INSERT INTO rewards (reward_id,reward_type,reward_data_id,amount,description,enabled) VALUES (304101775,5,304101774,1,'Ambassador title and suffix',1);
    IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Ambassador reward insert count mismatch'; END IF;
    INSERT INTO reward_source_entries (source_type,source_id,sequence,reward_id) VALUES (1,11000028,0,304101775);
    IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Ambassador source insert count mismatch'; END IF;
    COMMIT;
END$$
DELIMITER ;
