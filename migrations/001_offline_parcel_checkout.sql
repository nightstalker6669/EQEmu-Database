ALTER TABLE `trader` ADD COLUMN `offline_parcel_generation` BINARY(16) DEFAULT NULL;

CREATE TABLE `bazaar_offline_parcel_quotes` (
  `token` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `listing_id` BIGINT UNSIGNED NOT NULL,
  `generation` BINARY(16) NOT NULL,
  `seller_id` INT UNSIGNED NOT NULL,
  `serial` INT UNSIGNED NOT NULL,
  `instance_id` INT UNSIGNED NOT NULL,
  `item_id` INT UNSIGNED NOT NULL,
  `unit_price` INT UNSIGNED NOT NULL,
  `stock` INT NOT NULL,
  `buyer_id` INT UNSIGNED NOT NULL DEFAULT 0,
  `requested_quantity` INT UNSIGNED NOT NULL DEFAULT 0,
  `sold_quantity` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  `parcel_id` INT UNSIGNED NOT NULL DEFAULT 0,
  `fee` BIGINT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`token`),
  UNIQUE KEY `listing_revision` (`generation`, `stock`)
) ENGINE=InnoDB AUTO_INCREMENT=2147483648;
