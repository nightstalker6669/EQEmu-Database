-- Activate only the complete15-quest candidate in its single transaction.
DROP TEMPORARY TABLE IF EXISTS `_dragonscale_activation_guard`;
CREATE TEMPORARY TABLE `_dragonscale_activation_guard`(ok INT NOT NULL CHECK(ok=1));
INSERT INTO `_dragonscale_activation_guard` VALUES(IF((COALESCE(@dragonscale_whole_batch_reviewed,0)=1)
 AND (COALESCE(@dragonscale_journal_ok,0)=1)
 AND (COALESCE(@dragonscale_ground_ok,0)=1)
 AND (COALESCE(@dragonscale_world_ok,0)=1)
 AND (COALESCE(@dragonscale_faction_ok,0)=1)
 AND ((SELECT COUNT(*) FROM tasks WHERE id BETWEEN 3041001 AND 3041015)=15)
 AND ((SELECT COUNT(*) FROM task_activities WHERE taskid BETWEEN 3041001 AND 3041015)=43)
 AND ((SELECT COUNT(*) FROM achievement_criteria WHERE achievement_id IN(500100200,500100300,500100400) AND component_type=1 AND component_id BETWEEN 50281 AND 50295 AND event_type=4 AND progress_mode=3 AND target_id BETWEEN 3041001 AND 3041015)=15)
 AND ((SELECT COUNT(*) FROM achievements WHERE id IN(500100200,500100300,500100400) AND enabled=1)=3)
 AND ((SELECT COUNT(*) FROM ground_spawns WHERE (id BETWEEN 482 AND 488 AND item=36639)OR(id BETWEEN 491 AND 497 AND item=36638))=14)
 AND ((SELECT COUNT(*) FROM npc_types WHERE(id=442900 AND name='a_Darkvine_guard' AND see_invis=1)OR(id=443900 AND name='#Lelluran' AND race=519 AND class=5 AND npc_spells_id=3041001))=2)
 AND ((SELECT COUNT(*) FROM spawnentry WHERE npcID=443900 AND chance=5)=23)
 AND ((SELECT COUNT(*) FROM npc_spells_entries WHERE npc_spells_id=3041001)=4),1,0));
UPDATE tasks SET enabled=1 WHERE id BETWEEN 3041001 AND 3041015;
UPDATE achievement_criteria SET enabled=1 WHERE achievement_id IN(500100200,500100300,500100400) AND component_type=1 AND component_id BETWEEN 50281 AND 50295;
SET @dragonscale_activation_ok=1;
