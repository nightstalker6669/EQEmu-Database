
-- Explicit policies for original personal spell exchange tasks only.
CREATE TABLE IF NOT EXISTS task_spell_exchange_policies (
 task_id INT UNSIGNED NOT NULL,
 return_item_id INT UNSIGNED NOT NULL,
 language_required SMALLINT NOT NULL DEFAULT -1,
 language_skill_required TINYINT UNSIGNED NOT NULL DEFAULT 0,
 faction_id INT UNSIGNED NOT NULL DEFAULT 0,
 maximum_faction_con TINYINT UNSIGNED NOT NULL DEFAULT 0,
 hide_known_spells TINYINT UNSIGNED NOT NULL DEFAULT 0,
 PRIMARY KEY(task_id),
 CHECK(return_item_id>0),
 CHECK((language_required=-1 AND language_skill_required=0) OR (language_required BETWEEN 0 AND 27 AND language_skill_required<=100)),
 CHECK((faction_id=0 AND maximum_faction_con=0) OR (faction_id>0 AND maximum_faction_con BETWEEN 1 AND 9)),
 CHECK(hide_known_spells IN(0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
DROP TEMPORARY TABLE IF EXISTS `_spell_policy_schema_guard`;
CREATE TEMPORARY TABLE `_spell_policy_schema_guard`(ok TINYINT NOT NULL CHECK(ok=1)) ENGINE=InnoDB;
INSERT INTO `_spell_policy_schema_guard` VALUES(
 (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='task_spell_exchange_policies' AND ENGINE='InnoDB' AND TABLE_TYPE='BASE TABLE')=1
 AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='task_spell_exchange_policies')=7
 AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='task_spell_exchange_policies' AND COLUMN_NAME IN('task_id','return_item_id','faction_id') AND DATA_TYPE='int' AND LOCATE('unsigned',COLUMN_TYPE)>0 AND IS_NULLABLE='NO')=3
 AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='task_spell_exchange_policies' AND COLUMN_NAME='language_required' AND DATA_TYPE='smallint' AND LOCATE('unsigned',COLUMN_TYPE)=0 AND IS_NULLABLE='NO' AND COLUMN_DEFAULT='-1')=1
 AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='task_spell_exchange_policies' AND COLUMN_NAME IN('language_skill_required','maximum_faction_con','hide_known_spells') AND DATA_TYPE='tinyint' AND LOCATE('unsigned',COLUMN_TYPE)>0 AND IS_NULLABLE='NO' AND COLUMN_DEFAULT='0')=3
 AND (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='task_spell_exchange_policies' AND INDEX_NAME='PRIMARY')=1
 AND (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='task_spell_exchange_policies' AND INDEX_NAME='PRIMARY' AND COLUMN_NAME='task_id' AND SEQ_IN_INDEX=1)=1
);
DROP TEMPORARY TABLE `_spell_policy_schema_guard`;
