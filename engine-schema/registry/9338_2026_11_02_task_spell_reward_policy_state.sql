
-- Pin policy at occurrence creation. Legacy occurrences retain unrestricted 0.
ALTER TABLE character_task_reward_selections ADD COLUMN IF NOT EXISTS hide_known_spells TINYINT UNSIGNED NOT NULL DEFAULT 0;
DROP TEMPORARY TABLE IF EXISTS `_spell_policy_state_guard`;
CREATE TEMPORARY TABLE `_spell_policy_state_guard`(ok TINYINT NOT NULL CHECK(ok=1)) ENGINE=InnoDB;
INSERT INTO `_spell_policy_state_guard` VALUES(
 (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='character_task_reward_selections' AND COLUMN_NAME='hide_known_spells' AND DATA_TYPE='tinyint' AND LOCATE('unsigned',COLUMN_TYPE)>0 AND IS_NULLABLE='NO' AND COLUMN_DEFAULT='0')=1
 AND NOT EXISTS(SELECT 1 FROM character_task_reward_selections WHERE hide_known_spells NOT IN(0,1))
);
DROP TEMPORARY TABLE `_spell_policy_state_guard`;

-- Shared wire identity namespace. Never reset this row during content rollback.
CREATE TABLE IF NOT EXISTS reward_selection_wire_allocator (
 id TINYINT UNSIGNED NOT NULL,
 last_id BIGINT UNSIGNED NOT NULL DEFAULT 0,
 PRIMARY KEY(id),
 CHECK(id=1), CHECK(last_id<4294967295)
) ENGINE=InnoDB;
INSERT IGNORE INTO reward_selection_wire_allocator(id,last_id) VALUES(1,0);
DROP TEMPORARY TABLE IF EXISTS `_reward_wire_schema_guard`;
CREATE TEMPORARY TABLE `_reward_wire_schema_guard`(ok TINYINT NOT NULL CHECK(ok=1)) ENGINE=InnoDB;
INSERT INTO `_reward_wire_schema_guard` VALUES(
 (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='reward_selection_wire_allocator' AND ENGINE='InnoDB' AND TABLE_TYPE='BASE TABLE')=1
 AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='reward_selection_wire_allocator')=2
 AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='reward_selection_wire_allocator' AND COLUMN_NAME='id' AND DATA_TYPE='tinyint' AND LOCATE('unsigned',COLUMN_TYPE)>0 AND IS_NULLABLE='NO')=1
 AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='reward_selection_wire_allocator' AND COLUMN_NAME='last_id' AND DATA_TYPE='bigint' AND LOCATE('unsigned',COLUMN_TYPE)>0 AND IS_NULLABLE='NO' AND COLUMN_DEFAULT='0')=1
 AND (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='reward_selection_wire_allocator' AND INDEX_NAME='PRIMARY')=1
 AND (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='reward_selection_wire_allocator' AND INDEX_NAME='PRIMARY' AND COLUMN_NAME='id' AND SEQ_IN_INDEX=1)=1
 AND (SELECT COUNT(*) FROM reward_selection_wire_allocator)=1
 AND EXISTS(SELECT 1 FROM reward_selection_wire_allocator WHERE id=1 AND last_id<4294967295)
);
DROP TEMPORARY TABLE `_reward_wire_schema_guard`;
