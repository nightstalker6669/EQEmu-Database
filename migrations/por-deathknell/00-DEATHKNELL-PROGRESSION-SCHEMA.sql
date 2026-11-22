CREATE TABLE por_deathknell_raid_credit (
    dz_uuid CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    stage VARCHAR(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    character_id INT UNSIGNED NOT NULL,
    instance_id INT UNSIGNED NOT NULL,
    input_guid BIGINT UNSIGNED NULL,
    output_guid BIGINT UNSIGNED NULL,
    PRIMARY KEY (dz_uuid, stage, character_id),
    KEY character_stage (character_id, stage)
) ENGINE=InnoDB;
