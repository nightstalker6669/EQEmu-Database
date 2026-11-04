-- Staged Short Sharp Sting parent items; no invented parent XP/AA/cash.
SET NAMES utf8mb4;
SET SESSION check_constraint_checks=1;
START TRANSACTION;
CREATE TEMPORARY TABLE _bixie_guard(label VARCHAR(80)PRIMARY KEY,ok TINYINT NOT NULL,CHECK(ok=1))ENGINE=InnoDB;
INSERT INTO _bixie_guard VALUES('reward_sets_identity',(NOT EXISTS(SELECT 1 FROM reward_sets WHERE (reward_set_id=3050303) AND NOT((`reward_set_id` <=> 3050303 AND `title` <=> 'Short Sharp Sting (36-45)' AND `enabled` IN(0,1))))));
INSERT INTO _bixie_guard VALUES('reward_sources_identity',(NOT EXISTS(SELECT 1 FROM reward_sources WHERE ((source_type=1 AND source_id=500030300) OR reward_set_id=3050303) AND NOT((`source_type` <=> 1 AND `source_id` <=> 500030300 AND `reward_set_id` <=> 3050303 AND `enabled` IN(0,1))))));
INSERT INTO _bixie_guard VALUES('reward_options_identity',(NOT EXISTS(SELECT 1 FROM reward_options WHERE (reward_set_id=3050303) AND NOT((`reward_set_id` <=> 3050303 AND `option_id` <=> 1 AND `sequence` <=> 1 AND `label` <=> 'Ornate Consigned Plate Gauntlets' AND `common_to_all` <=> 0 AND `flags` <=> 0 AND `enabled` IN(0,1) AND `class_mask` <=> 151) OR (`reward_set_id` <=> 3050303 AND `option_id` <=> 2 AND `sequence` <=> 2 AND `label` <=> 'Ornate Consigned Chain Gauntlets' AND `common_to_all` <=> 0 AND `flags` <=> 0 AND `enabled` IN(0,1) AND `class_mask` <=> 33544) OR (`reward_set_id` <=> 3050303 AND `option_id` <=> 3 AND `sequence` <=> 3 AND `label` <=> 'Ornate Consigned Leather Gloves' AND `common_to_all` <=> 0 AND `flags` <=> 0 AND `enabled` IN(0,1) AND `class_mask` <=> 16480) OR (`reward_set_id` <=> 3050303 AND `option_id` <=> 4 AND `sequence` <=> 4 AND `label` <=> 'Ornate Consigned Cloth Gloves' AND `common_to_all` <=> 0 AND `flags` <=> 0 AND `enabled` IN(0,1) AND `class_mask` <=> 15360)))));
INSERT INTO _bixie_guard VALUES('reward_option_entries_identity',(NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE (reward_set_id=3050303 OR reward_id BETWEEN 305030301 AND 305030304) AND NOT((`reward_set_id` <=> 3050303 AND `option_id` <=> 1 AND `sequence` <=> 0 AND `reward_id` <=> 305030301) OR (`reward_set_id` <=> 3050303 AND `option_id` <=> 2 AND `sequence` <=> 0 AND `reward_id` <=> 305030302) OR (`reward_set_id` <=> 3050303 AND `option_id` <=> 3 AND `sequence` <=> 0 AND `reward_id` <=> 305030303) OR (`reward_set_id` <=> 3050303 AND `option_id` <=> 4 AND `sequence` <=> 0 AND `reward_id` <=> 305030304)))));
INSERT INTO _bixie_guard VALUES('rewards_identity',(NOT EXISTS(SELECT 1 FROM rewards WHERE (reward_id BETWEEN 305030301 AND 305030304) AND NOT((`reward_id` <=> 305030301 AND `reward_type` <=> 0 AND `reward_data_id` <=> 108090 AND `amount` <=> 1 AND `description` <=> 'Short Sharp Sting: Ornate Consigned Plate Gauntlets' AND `enabled` IN(0,1)) OR (`reward_id` <=> 305030302 AND `reward_type` <=> 0 AND `reward_data_id` <=> 108097 AND `amount` <=> 1 AND `description` <=> 'Short Sharp Sting: Ornate Consigned Chain Gauntlets' AND `enabled` IN(0,1)) OR (`reward_id` <=> 305030303 AND `reward_type` <=> 0 AND `reward_data_id` <=> 108104 AND `amount` <=> 1 AND `description` <=> 'Short Sharp Sting: Ornate Consigned Leather Gloves' AND `enabled` IN(0,1)) OR (`reward_id` <=> 305030304 AND `reward_type` <=> 0 AND `reward_data_id` <=> 108111 AND `amount` <=> 1 AND `description` <=> 'Short Sharp Sting: Ornate Consigned Cloth Gloves' AND `enabled` IN(0,1))))));
INSERT INTO _bixie_guard VALUES('item_108090',(EXISTS(SELECT 1 FROM items WHERE id=108090 AND Name='Ornate Consigned Plate Gauntlets' AND classes=151)));
INSERT INTO _bixie_guard VALUES('item_108097',(EXISTS(SELECT 1 FROM items WHERE id=108097 AND Name='Ornate Consigned Chain Gauntlets' AND classes=33544)));
INSERT INTO _bixie_guard VALUES('item_108104',(EXISTS(SELECT 1 FROM items WHERE id=108104 AND Name='Ornate Consigned Leather Gloves' AND classes=16480)));
INSERT INTO _bixie_guard VALUES('item_108111',(EXISTS(SELECT 1 FROM items WHERE id=108111 AND Name='Ornate Consigned Cloth Gloves' AND classes=15360)));
INSERT INTO _bixie_guard VALUES('achievement',(EXISTS(SELECT 1 FROM achievements WHERE id=500030300 AND name='Short Sharp Sting (36-45)' AND enabled=1 AND has_reward=1)));
INSERT INTO reward_sets(`reward_set_id`,`title`,`enabled`)VALUES
(3050303,'Short Sharp Sting (36-45)',0)
ON DUPLICATE KEY UPDATE `title`=VALUES(`title`),`enabled`=VALUES(`enabled`);
INSERT INTO reward_sources(`source_type`,`source_id`,`reward_set_id`,`enabled`)VALUES
(1,500030300,3050303,0)
ON DUPLICATE KEY UPDATE `reward_set_id`=VALUES(`reward_set_id`),`enabled`=VALUES(`enabled`);
INSERT INTO reward_options(`reward_set_id`,`option_id`,`sequence`,`label`,`common_to_all`,`flags`,`enabled`,`class_mask`)VALUES
(3050303,1,1,'Ornate Consigned Plate Gauntlets',0,0,0,151),
(3050303,2,2,'Ornate Consigned Chain Gauntlets',0,0,0,33544),
(3050303,3,3,'Ornate Consigned Leather Gloves',0,0,0,16480),
(3050303,4,4,'Ornate Consigned Cloth Gloves',0,0,0,15360)
ON DUPLICATE KEY UPDATE `sequence`=VALUES(`sequence`),`label`=VALUES(`label`),`common_to_all`=VALUES(`common_to_all`),`flags`=VALUES(`flags`),`enabled`=VALUES(`enabled`),`class_mask`=VALUES(`class_mask`);
INSERT INTO reward_option_entries(`reward_set_id`,`option_id`,`sequence`,`reward_id`)VALUES
(3050303,1,0,305030301),
(3050303,2,0,305030302),
(3050303,3,0,305030303),
(3050303,4,0,305030304)
ON DUPLICATE KEY UPDATE `sequence`=VALUES(`sequence`);
INSERT INTO rewards(`reward_id`,`reward_type`,`reward_data_id`,`amount`,`description`,`enabled`)VALUES
(305030301,0,108090,1,'Short Sharp Sting: Ornate Consigned Plate Gauntlets',0),
(305030302,0,108097,1,'Short Sharp Sting: Ornate Consigned Chain Gauntlets',0),
(305030303,0,108104,1,'Short Sharp Sting: Ornate Consigned Leather Gloves',0),
(305030304,0,108111,1,'Short Sharp Sting: Ornate Consigned Cloth Gloves',0)
ON DUPLICATE KEY UPDATE `reward_type`=VALUES(`reward_type`),`reward_data_id`=VALUES(`reward_data_id`),`amount`=VALUES(`amount`),`description`=VALUES(`description`),`enabled`=VALUES(`enabled`);
DROP TEMPORARY TABLE _bixie_guard;
COMMIT;
