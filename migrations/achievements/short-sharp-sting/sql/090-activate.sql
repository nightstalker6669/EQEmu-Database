-- Final activation is part of the same required transaction as every other SQL file.
-- Only the installer supplies the hash after checking the reviewed Lua settings.
SET NAMES utf8mb4;
SET SESSION check_constraint_checks=1;
START TRANSACTION;
CREATE TEMPORARY TABLE _sting_activation_guard(label VARCHAR(80)PRIMARY KEY,ok TINYINT NOT NULL,CHECK(ok=1))ENGINE=InnoDB;
INSERT INTO _sting_activation_guard VALUES('review',COALESCE(@sting_package_review_sha='29ddbde2a1d15629daf97c5110c25584f10effea7d2ae66ead74cd2e2e8524d7',0));
INSERT INTO _sting_activation_guard VALUES('quests',(SELECT COUNT(*) FROM tasks WHERE id BETWEEN 3040317 AND 3040320)=4);
INSERT INTO _sting_activation_guard VALUES('objectives',(SELECT COUNT(*) FROM task_activities WHERE taskid BETWEEN 3040317 AND 3040320)=18);
INSERT INTO _sting_activation_guard VALUES('recipe',(SELECT COUNT(*) FROM tradeskill_recipe WHERE id=3040320)=1 AND(SELECT COUNT(*) FROM tradeskill_recipe_entries WHERE recipe_id=3040320)=9);
INSERT INTO _sting_activation_guard VALUES('bindings',(SELECT COUNT(*) FROM achievement_criteria WHERE achievement_id=500030300 AND component_type=1 AND component_id BETWEEN 50091 AND 50094 AND event_type=4 AND target_id BETWEEN 3040317 AND 3040320)=4);
INSERT INTO _sting_activation_guard VALUES('reward_sets',(SELECT COUNT(*) FROM reward_sets WHERE reward_set_id IN(3040319,3050303))=2);
INSERT INTO _sting_activation_guard VALUES('reward_options',(SELECT COUNT(*) FROM reward_options WHERE reward_set_id IN(3040319,3050303))=7);
INSERT INTO _sting_activation_guard VALUES('reward_entries',(SELECT COUNT(*) FROM reward_option_entries WHERE reward_set_id IN(3040319,3050303))=7);
INSERT INTO _sting_activation_guard VALUES('rewards',(SELECT COUNT(*) FROM rewards WHERE reward_id BETWEEN 30403191 AND 30403193 OR reward_id BETWEEN 305030301 AND 305030304)=7);
UPDATE tasks SET enabled=1 WHERE id BETWEEN 3040317 AND 3040320;
UPDATE tradeskill_recipe SET enabled=1 WHERE id=3040320;
UPDATE achievement_criteria SET enabled=1 WHERE achievement_id=500030300 AND component_type=1 AND component_id BETWEEN 50091 AND 50094;
UPDATE reward_sets SET enabled=1 WHERE reward_set_id IN(3040319,3050303);
UPDATE reward_sources SET enabled=1 WHERE(source_type=2 AND source_id=3040319)OR(source_type=1 AND source_id=500030300);
UPDATE reward_options SET enabled=1 WHERE reward_set_id IN(3040319,3050303);
UPDATE rewards SET enabled=1 WHERE reward_id BETWEEN 30403191 AND 30403193 OR reward_id BETWEEN 305030301 AND 305030304;
DROP TEMPORARY TABLE _sting_activation_guard;
COMMIT;
