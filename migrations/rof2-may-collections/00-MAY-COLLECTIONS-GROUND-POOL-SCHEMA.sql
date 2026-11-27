-- May RoF2 Collections. Catalog definitions only.
-- Assign pool members only after each fixed site and its set membership are verified.
CREATE TABLE `ground_spawn_collectibles` (
    `ground_spawn_id` INT UNSIGNED NOT NULL,
    `item_id` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`ground_spawn_id`, `item_id`)
) ENGINE=InnoDB;
