-- Track only online, active time spent continuously in Passive stance.
-- Freeze the accumulator across zoning/logoff; it is capped at one upkeep period.
-- Apply after the standard mercenary table bootstrap. No rows are removed.
SET @mercenary_passive_column_present = (
 SELECT COUNT(*) FROM information_schema.columns
 WHERE table_schema=DATABASE() AND table_name='mercs' AND column_name='PassiveUpkeepElapsedMS'
);
SET @mercenary_passive_column_sql = IF(@mercenary_passive_column_present=0,
 'ALTER TABLE mercs ADD COLUMN PassiveUpkeepElapsedMS INT UNSIGNED NOT NULL DEFAULT 0', 'DO 0');
PREPARE mercenary_passive_column_statement FROM @mercenary_passive_column_sql;
EXECUTE mercenary_passive_column_statement;
DEALLOCATE PREPARE mercenary_passive_column_statement;
