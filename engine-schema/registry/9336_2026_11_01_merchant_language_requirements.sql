
-- Content schema 9336. Requires the matching merchant-language binary.
-- Additive defaults preserve unrestricted existing merchant catalogues.
ALTER TABLE merchantlist
 ADD COLUMN IF NOT EXISTS language_required SMALLINT NOT NULL DEFAULT -1,
 ADD COLUMN IF NOT EXISTS language_skill_required TINYINT UNSIGNED NOT NULL DEFAULT 0;
-- Refuse incompatible pre-existing columns instead of silently adopting them.
DROP TEMPORARY TABLE IF EXISTS `_merchant_language_schema_guard`;
CREATE TEMPORARY TABLE `_merchant_language_schema_guard`(ok TINYINT NOT NULL CHECK(ok=1)) ENGINE=InnoDB;
INSERT INTO `_merchant_language_schema_guard` VALUES (
 (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='merchantlist' AND COLUMN_NAME='language_required' AND DATA_TYPE='smallint' AND LOCATE('unsigned',COLUMN_TYPE)=0 AND IS_NULLABLE='NO' AND COLUMN_DEFAULT='-1')=1
 AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='merchantlist' AND COLUMN_NAME='language_skill_required' AND DATA_TYPE='tinyint' AND LOCATE('unsigned',COLUMN_TYPE)>0 AND IS_NULLABLE='NO' AND COLUMN_DEFAULT='0')=1
);
DROP TEMPORARY TABLE `_merchant_language_schema_guard`;
