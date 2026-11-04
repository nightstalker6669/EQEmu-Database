-- Explicit per-zone/version mercenary policy. The resolved zone row, including
-- version fallback, controls admission. Default1 preserves existing zone content.
-- No inferred raid classification or blanket content changes are applied.
SET @mercenary_zone_column_present = (
 SELECT COUNT(*) FROM information_schema.columns
 WHERE table_schema=DATABASE() AND table_name='zone' AND column_name='allow_mercs'
);
SET @mercenary_zone_column_sql = IF(@mercenary_zone_column_present=0,
 'ALTER TABLE zone ADD COLUMN allow_mercs TINYINT UNSIGNED NOT NULL DEFAULT 1', 'DO 0');
PREPARE mercenary_zone_column_statement FROM @mercenary_zone_column_sql;
EXECUTE mercenary_zone_column_statement;
DEALLOCATE PREPARE mercenary_zone_column_statement;
-- Operators may explicitly set allow_mercs=0 for selected zone/version rows.
-- Reload static zone data or restart zones after changing this policy.
