-- Enable the complete Steppes task/encounter batch after source/schema/script review.
-- Historical unknown combat/trigger/timing values use the labelled companion defaults.
-- The adjacent portal raid is not required and is not activated.
SET SESSION check_constraint_checks=1;
DROP TEMPORARY TABLE IF EXISTS _steppes_enable_guard;
CREATE TEMPORARY TABLE _steppes_enable_guard(label VARCHAR(64) PRIMARY KEY,ok TINYINT NOT NULL CHECK(ok=1)) ENGINE=InnoDB;
INSERT INTO _steppes_enable_guard VALUES
 ('review',COALESCE(@steppes_activation_reviewed,0)=1),
 ('tasks',(SELECT COUNT(*) FROM tasks WHERE id BETWEEN 3040601 AND 3040613)=13),
 ('activities',(SELECT COUNT(*) FROM task_activities WHERE taskid BETWEEN 3040601 AND 3040613)=59),
 ('criteria',(SELECT COUNT(*) FROM achievement_criteria WHERE achievement_id IN(500060200,500060300,500060400) AND target_id BETWEEN 3040601 AND 3040613 AND event_type=4 AND progress_mode=3 AND required_count=1)=13),
 ('definitions',(SELECT COUNT(*) FROM achievements WHERE id IN(500060200,500060300,500060400))=3),
 ('clones',(SELECT COUNT(*) FROM npc_types WHERE id BETWEEN 399900 AND 399910)=11),
 ('pickups',(SELECT COUNT(*) FROM ground_spawns WHERE id BETWEEN 399900 AND 399905 AND item IN(84243,88141,88142,88137,54668,54669))=6),
 ('page_distribution',(SELECT COUNT(*) FROM ground_spawns WHERE id=399903 AND item=88137 AND ROUND(min_x,2)=963.19 AND max_x=1209 AND ROUND(min_y,2)=-544.45 AND max_y=209 AND max_z=-99999 AND fix_z=1)=1),
 ('reward_sets',(SELECT COUNT(*) FROM reward_sets WHERE reward_set_id IN(3040606,3040691,3040692,3040693))=4),
 ('reward_options',(SELECT COUNT(*) FROM reward_options WHERE reward_set_id IN(3040606,3040691,3040692,3040693))=14),
 ('reward_entries',(SELECT COUNT(*) FROM reward_option_entries WHERE reward_set_id IN(3040606,3040691,3040692,3040693))=20),
 ('yavia_health',(SELECT COUNT(*) FROM npc_types WHERE id=399032 AND hp=4200)=1),
 ('shared_state_table',(SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='character_shared_task_reward_instances' AND ENGINE='InnoDB')=1);
START TRANSACTION;
UPDATE tasks SET enabled=1 WHERE id BETWEEN 3040601 AND 3040613;
UPDATE achievement_criteria SET enabled=1 WHERE achievement_id IN(500060200,500060300,500060400) AND target_id BETWEEN 3040601 AND 3040613;
UPDATE achievements SET enabled=1 WHERE id IN(500060200,500060300,500060400);
UPDATE ground_spawns SET max_allowed=1 WHERE id BETWEEN 399900 AND 399905;
UPDATE reward_sets SET enabled=1 WHERE reward_set_id IN(3040606,3040691,3040692,3040693);
UPDATE reward_sources SET enabled=1 WHERE reward_set_id IN(3040606,3040691,3040692,3040693);
UPDATE reward_options SET enabled=1 WHERE reward_set_id IN(3040606,3040691,3040692,3040693);
UPDATE rewards SET enabled=1 WHERE reward_id IN(304060610,304060620,304060630,304060640,304069110,304069111,304069120,304069121,304069130,304069131,304069140,304069141,304069150,304069151,304069160,304069161,304069210,304069220,304069310,304069320);
COMMIT;
DROP TEMPORARY TABLE _steppes_enable_guard;
