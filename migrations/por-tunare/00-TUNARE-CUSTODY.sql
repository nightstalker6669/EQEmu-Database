CREATE TABLE por_tunare_chalice_sources (
    source_key CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    shared_task_id BIGINT NOT NULL,
    dynamic_zone_id INT UNSIGNED NOT NULL,
    dz_uuid CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    instance_id INT UNSIGNED NOT NULL,
    character_id INT UNSIGNED NOT NULL,
    npc_type_id INT UNSIGNED NOT NULL,
    corpse_loot_slot INT UNSIGNED NOT NULL,
    item_guid BIGINT UNSIGNED NOT NULL,
    created_at BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (source_key),
    UNIQUE KEY guardian_run (shared_task_id)
) ENGINE=InnoDB;

CREATE TABLE por_tunare_exchange_receipts (
    character_id INT UNSIGNED NOT NULL,
    source_key CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    request_key CHAR(32) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    output_guid BIGINT UNSIGNED NOT NULL,
    created_at BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (character_id),
    UNIQUE KEY source_receipt (source_key),
    UNIQUE KEY give_receipt (request_key)
) ENGINE=InnoDB;

CREATE TABLE por_tunare_orgaf (
    spawn_id INT UNSIGNED NOT NULL,
    shared_task_id BIGINT UNSIGNED NOT NULL,
    character_id INT UNSIGNED NOT NULL,
    fight_at BIGINT UNSIGNED NOT NULL,
    state TINYINT UNSIGNED NOT NULL DEFAULT 0,
    dead_at BIGINT UNSIGNED DEFAULT NULL,
    PRIMARY KEY (spawn_id),
    UNIQUE KEY key_task_run (shared_task_id)
) ENGINE=InnoDB;

CREATE TABLE por_tunare_reward_chests (
    shared_task_id BIGINT NOT NULL,
    character_id INT UNSIGNED NOT NULL,
    task_id INT UNSIGNED NOT NULL,
    created_at BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (shared_task_id)
) ENGINE=InnoDB;
