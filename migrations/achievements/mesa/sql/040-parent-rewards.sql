-- Mesa complete package dependency; import all four SQL files and scripts in order. Capture3040411 remains disabled.
SET NAMES utf8mb4;
SET SESSION check_constraint_checks=1;
DROP TEMPORARY TABLE IF EXISTS _mesa_parent_guard;
CREATE TEMPORARY TABLE _mesa_parent_guard(label VARCHAR(80)PRIMARY KEY,ok TINYINT NOT NULL,CHECK(ok=1))ENGINE=InnoDB;
INSERT INTO _mesa_parent_guard VALUES('achievement',((SELECT COUNT(*)FROM achievements WHERE id=500040300 AND name='Pranks and Research (46-50)' AND enabled=1 AND has_reward=1)=1));
INSERT INTO _mesa_parent_guard VALUES('source',(NOT EXISTS(SELECT 1 FROM reward_sources WHERE(source_type=1 AND source_id=500040300 AND reward_set_id<>3050403)OR(reward_set_id=3050403 AND NOT(source_type=1 AND source_id=500040300)))));
INSERT INTO _mesa_parent_guard VALUES('set',(NOT EXISTS(SELECT 1 FROM reward_sets WHERE reward_set_id=3050403 AND title<>'Pranks and Research (46-50)')));
INSERT INTO _mesa_parent_guard VALUES('items',((SELECT COUNT(*)FROM items WHERE (id=108583 AND Name='Flawed Consigned Scale Shield' AND classes=16861) OR (id=108584 AND Name='Flawed Consigned Carapace' AND classes=15906) OR (id=108573 AND Name='Flawed Consigned Mace' AND classes=15906) OR (id=108572 AND Name='Flawed Consigned Brawl Stick' AND classes=16861) OR (id=108576 AND Name='Flawed Consigned Glass Shard' AND classes=16793) OR (id=108582 AND Name='Flawed Consigned Longbow' AND classes=285) OR (id=108574 AND Name='Flawed Consigned Longsword' AND classes=413) OR (id=108575 AND Name='Flawed Consigned Shortsword' AND classes=413))=8));
INSERT INTO _mesa_parent_guard VALUES('reward_305040301',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=305040301 AND NOT(reward_type=0 AND reward_data_id=108583 AND amount=1 AND description='May2013 Mesa parent 500040300 item 108583'))AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=305040301 AND NOT(reward_set_id=3050403 AND option_id=1))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=305040301)));
INSERT INTO _mesa_parent_guard VALUES('reward_305040302',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=305040302 AND NOT(reward_type=0 AND reward_data_id=108584 AND amount=1 AND description='May2013 Mesa parent 500040300 item 108584'))AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=305040302 AND NOT(reward_set_id=3050403 AND option_id=2))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=305040302)));
INSERT INTO _mesa_parent_guard VALUES('reward_305040303',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=305040303 AND NOT(reward_type=0 AND reward_data_id=108573 AND amount=1 AND description='May2013 Mesa parent 500040300 item 108573'))AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=305040303 AND NOT(reward_set_id=3050403 AND option_id=2))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=305040303)));
INSERT INTO _mesa_parent_guard VALUES('reward_305040304',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=305040304 AND NOT(reward_type=0 AND reward_data_id=108572 AND amount=1 AND description='May2013 Mesa parent 500040300 item 108572'))AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=305040304 AND NOT(reward_set_id=3050403 AND option_id=3))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=305040304)));
INSERT INTO _mesa_parent_guard VALUES('reward_305040305',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=305040305 AND NOT(reward_type=0 AND reward_data_id=108576 AND amount=1 AND description='May2013 Mesa parent 500040300 item 108576'))AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=305040305 AND NOT(reward_set_id=3050403 AND option_id=4))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=305040305)));
INSERT INTO _mesa_parent_guard VALUES('reward_305040306',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=305040306 AND NOT(reward_type=0 AND reward_data_id=108582 AND amount=1 AND description='May2013 Mesa parent 500040300 item 108582'))AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=305040306 AND NOT(reward_set_id=3050403 AND option_id=5))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=305040306)));
INSERT INTO _mesa_parent_guard VALUES('reward_305040307',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=305040307 AND NOT(reward_type=0 AND reward_data_id=108574 AND amount=1 AND description='May2013 Mesa parent 500040300 item 108574'))AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=305040307 AND NOT(reward_set_id=3050403 AND option_id=6))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=305040307)));
INSERT INTO _mesa_parent_guard VALUES('reward_305040308',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=305040308 AND NOT(reward_type=0 AND reward_data_id=108575 AND amount=1 AND description='May2013 Mesa parent 500040300 item 108575'))AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=305040308 AND NOT(reward_set_id=3050403 AND option_id=7))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=305040308)));
INSERT INTO _mesa_parent_guard VALUES('options',(NOT EXISTS(SELECT 1 FROM reward_options WHERE reward_set_id=3050403 AND NOT((`reward_set_id` <=> 3050403 AND `option_id` <=> 1 AND `sequence` <=> 1 AND `label` <=> 'Flawed Consigned Scale Shield' AND `common_to_all` <=> 1 AND `flags` <=> 0 AND `enabled` <=> 1 AND `class_mask` <=> 16861) OR (`reward_set_id` <=> 3050403 AND `option_id` <=> 2 AND `sequence` <=> 2 AND `label` <=> 'Flawed Consigned caster carapace and mace' AND `common_to_all` <=> 1 AND `flags` <=> 0 AND `enabled` <=> 1 AND `class_mask` <=> 15906) OR (`reward_set_id` <=> 3050403 AND `option_id` <=> 3 AND `sequence` <=> 3 AND `label` <=> 'Flawed Consigned Brawl Stick' AND `common_to_all` <=> 0 AND `flags` <=> 0 AND `enabled` <=> 1 AND `class_mask` <=> 16861) OR (`reward_set_id` <=> 3050403 AND `option_id` <=> 4 AND `sequence` <=> 4 AND `label` <=> 'Flawed Consigned Glass Shard' AND `common_to_all` <=> 0 AND `flags` <=> 0 AND `enabled` <=> 1 AND `class_mask` <=> 16793) OR (`reward_set_id` <=> 3050403 AND `option_id` <=> 5 AND `sequence` <=> 5 AND `label` <=> 'Flawed Consigned Longbow' AND `common_to_all` <=> 0 AND `flags` <=> 0 AND `enabled` <=> 1 AND `class_mask` <=> 285) OR (`reward_set_id` <=> 3050403 AND `option_id` <=> 6 AND `sequence` <=> 6 AND `label` <=> 'Flawed Consigned Longsword' AND `common_to_all` <=> 0 AND `flags` <=> 0 AND `enabled` <=> 1 AND `class_mask` <=> 413) OR (`reward_set_id` <=> 3050403 AND `option_id` <=> 7 AND `sequence` <=> 7 AND `label` <=> 'Flawed Consigned Shortsword' AND `common_to_all` <=> 0 AND `flags` <=> 0 AND `enabled` <=> 1 AND `class_mask` <=> 413)))));
INSERT INTO _mesa_parent_guard VALUES('links',(NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_set_id=3050403 AND NOT((`reward_set_id` <=> 3050403 AND `option_id` <=> 1 AND `sequence` <=> 0 AND `reward_id` <=> 305040301) OR (`reward_set_id` <=> 3050403 AND `option_id` <=> 2 AND `sequence` <=> 0 AND `reward_id` <=> 305040302) OR (`reward_set_id` <=> 3050403 AND `option_id` <=> 2 AND `sequence` <=> 1 AND `reward_id` <=> 305040303) OR (`reward_set_id` <=> 3050403 AND `option_id` <=> 3 AND `sequence` <=> 0 AND `reward_id` <=> 305040304) OR (`reward_set_id` <=> 3050403 AND `option_id` <=> 4 AND `sequence` <=> 0 AND `reward_id` <=> 305040305) OR (`reward_set_id` <=> 3050403 AND `option_id` <=> 5 AND `sequence` <=> 0 AND `reward_id` <=> 305040306) OR (`reward_set_id` <=> 3050403 AND `option_id` <=> 6 AND `sequence` <=> 0 AND `reward_id` <=> 305040307) OR (`reward_set_id` <=> 3050403 AND `option_id` <=> 7 AND `sequence` <=> 0 AND `reward_id` <=> 305040308)))));
START TRANSACTION;
INSERT INTO reward_sets(`reward_set_id`,`title`,`enabled`)VALUES
(3050403,'Pranks and Research (46-50)',1)
ON DUPLICATE KEY UPDATE `title`=VALUES(`title`),`enabled`=VALUES(`enabled`);
INSERT INTO reward_sources(`source_type`,`source_id`,`reward_set_id`,`enabled`)VALUES
(1,500040300,3050403,1)
ON DUPLICATE KEY UPDATE `source_id`=VALUES(`source_id`),`reward_set_id`=VALUES(`reward_set_id`),`enabled`=VALUES(`enabled`);
INSERT INTO reward_options(`reward_set_id`,`option_id`,`sequence`,`label`,`common_to_all`,`flags`,`enabled`,`class_mask`)VALUES
(3050403,1,1,'Flawed Consigned Scale Shield',1,0,1,16861),
(3050403,2,2,'Flawed Consigned caster carapace and mace',1,0,1,15906),
(3050403,3,3,'Flawed Consigned Brawl Stick',0,0,1,16861),
(3050403,4,4,'Flawed Consigned Glass Shard',0,0,1,16793),
(3050403,5,5,'Flawed Consigned Longbow',0,0,1,285),
(3050403,6,6,'Flawed Consigned Longsword',0,0,1,413),
(3050403,7,7,'Flawed Consigned Shortsword',0,0,1,413)
ON DUPLICATE KEY UPDATE `option_id`=VALUES(`option_id`),`sequence`=VALUES(`sequence`),`label`=VALUES(`label`),`common_to_all`=VALUES(`common_to_all`),`flags`=VALUES(`flags`),`enabled`=VALUES(`enabled`),`class_mask`=VALUES(`class_mask`);
INSERT INTO rewards(`reward_id`,`reward_type`,`reward_data_id`,`amount`,`description`,`enabled`)VALUES
(305040301,0,108583,1,'May2013 Mesa parent 500040300 item 108583',1),
(305040302,0,108584,1,'May2013 Mesa parent 500040300 item 108584',1),
(305040303,0,108573,1,'May2013 Mesa parent 500040300 item 108573',1),
(305040304,0,108572,1,'May2013 Mesa parent 500040300 item 108572',1),
(305040305,0,108576,1,'May2013 Mesa parent 500040300 item 108576',1),
(305040306,0,108582,1,'May2013 Mesa parent 500040300 item 108582',1),
(305040307,0,108574,1,'May2013 Mesa parent 500040300 item 108574',1),
(305040308,0,108575,1,'May2013 Mesa parent 500040300 item 108575',1)
ON DUPLICATE KEY UPDATE `reward_type`=VALUES(`reward_type`),`reward_data_id`=VALUES(`reward_data_id`),`amount`=VALUES(`amount`),`description`=VALUES(`description`),`enabled`=VALUES(`enabled`);
INSERT INTO reward_option_entries(`reward_set_id`,`option_id`,`sequence`,`reward_id`)VALUES
(3050403,1,0,305040301),
(3050403,2,0,305040302),
(3050403,2,1,305040303),
(3050403,3,0,305040304),
(3050403,4,0,305040305),
(3050403,5,0,305040306),
(3050403,6,0,305040307),
(3050403,7,0,305040308)
ON DUPLICATE KEY UPDATE `option_id`=VALUES(`option_id`),`sequence`=VALUES(`sequence`),`reward_id`=VALUES(`reward_id`);
COMMIT;
