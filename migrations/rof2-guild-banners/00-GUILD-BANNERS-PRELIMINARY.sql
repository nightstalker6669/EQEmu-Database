-- Preliminary offline schema for one durable guild banner per guild.
-- Public placement initially uses instance_id 0. Runtime owns placement eligibility.
CREATE TABLE `guild_banners` (
    `guild_id` INT NOT NULL,
    `zone_id` INT UNSIGNED NOT NULL,
    `zone_version` INT NOT NULL,
    `instance_id` INT UNSIGNED NOT NULL DEFAULT 0,
    `planter_char_id` INT UNSIGNED NOT NULL,
    `banner_type` INT UNSIGNED NOT NULL,
    `x` FLOAT NOT NULL,
    `y` FLOAT NOT NULL,
    `z` FLOAT NOT NULL,
    `heading` FLOAT NOT NULL,
    `planted_at` BIGINT UNSIGNED NOT NULL,
    `upgrade_expires_at` BIGINT UNSIGNED NOT NULL,
    `base_expires_at` BIGINT UNSIGNED NOT NULL,
    `revision` BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (`guild_id`),
    KEY `guild_banners_zone_instance_idx` (`zone_id`,`zone_version`,`instance_id`),
    CONSTRAINT `guild_banners_guild_fk`
        FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB;
