CREATE TABLE IF NOT EXISTS tss_ashengate_event_credit (
    dz_uuid CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    event_id TINYINT UNSIGNED NOT NULL,
    character_id INT UNSIGNED NOT NULL,
    instance_id INT UNSIGNED NOT NULL,
    earned_at BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (dz_uuid, event_id, character_id),
    KEY character_event (character_id, event_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tss_ashengate_marks (
    character_id INT UNSIGNED NOT NULL,
    source_token CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    dz_uuid CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    instance_id INT UNSIGNED NOT NULL,
    event_id TINYINT UNSIGNED NOT NULL,
    consumed_at BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (character_id),
    UNIQUE KEY unique_source (source_token)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tss_ashengate_mark_loot (
    dz_uuid CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    event_id TINYINT UNSIGNED NOT NULL,
    source_ordinal TINYINT UNSIGNED NOT NULL,
    source_token CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    character_id INT UNSIGNED NOT NULL,
    instance_id INT UNSIGNED NOT NULL,
    item_guid BIGINT UNSIGNED NOT NULL,
    issued_at BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (dz_uuid, event_id, source_ordinal),
    UNIQUE KEY unique_source (source_token),
    KEY character_issuance (character_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tss_ashengate_public_actions (
    source_token CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    activity_id TINYINT UNSIGNED NOT NULL,
    character_id INT UNSIGNED NOT NULL,
    task_id INT UNSIGNED NOT NULL,
    accepted_time INT UNSIGNED NOT NULL,
    placement_id INT UNSIGNED NOT NULL,
    item_guid BIGINT UNSIGNED NULL,
    recorded_at BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (source_token, activity_id),
    KEY active_task (character_id, task_id, accepted_time, activity_id)
) ENGINE=InnoDB;
