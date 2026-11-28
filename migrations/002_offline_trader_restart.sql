CREATE TABLE `bazaar_offline_stalls` (
  `character_id` INT UNSIGNED NOT NULL,
  `account_id` INT UNSIGNED NOT NULL,
  `instance_id` INT UNSIGNED NOT NULL,
  `instance_version` TINYINT UNSIGNED NOT NULL,
  `instance_epoch` BINARY(16) DEFAULT NULL,
  `owner` BINARY(16) NOT NULL,
  `phase` TINYINT UNSIGNED NOT NULL,
  `x` FLOAT NOT NULL,
  `y` FLOAT NOT NULL,
  `z` FLOAT NOT NULL,
  `heading` FLOAT NOT NULL,
  PRIMARY KEY (`character_id`),
  UNIQUE KEY `one_stall_per_account` (`account_id`),
  KEY `instance_phase` (`instance_id`, `phase`)
) ENGINE=InnoDB;

ALTER TABLE `trader`
  ADD COLUMN `offline_inventory_slot` INT UNSIGNED DEFAULT NULL,
  ADD COLUMN `offline_satchel_slot` INT UNSIGNED DEFAULT NULL,
  ADD COLUMN `offline_satchel_guid` INT UNSIGNED DEFAULT NULL;

ALTER TABLE `bazaar_offline_parcel_quotes`
  ADD COLUMN `delivery_slot` INT UNSIGNED DEFAULT NULL,
  ADD COLUMN `delivery_serial` INT UNSIGNED NOT NULL DEFAULT 0;

ALTER TABLE `instance_list`
  ADD COLUMN `offline_bazaar_epoch` BINARY(16) DEFAULT NULL;
