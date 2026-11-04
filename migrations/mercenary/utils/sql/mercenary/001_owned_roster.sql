-- Native RoF2 owned-roster invariant: at most one contract per owner slot.
-- No character data is removed or rewritten. Existing duplicate slots cause
-- ALTER to fail; review/migrate those contracts rather than discarding them.
-- Apply after the standard mercenary tables bootstrap, using InnoDB tables.
SET @mercenary_roster_index_present = (
 SELECT COUNT(*) FROM (
  SELECT index_name FROM information_schema.statistics
  WHERE table_schema=DATABASE() AND table_name='mercs' AND index_name='merc_owner_slot'
  GROUP BY index_name
  HAVING MIN(non_unique)=0 AND COUNT(*)=2
   AND GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',')='OwnerCharacterID,Slot'
 ) AS valid_roster_indexes
);
SET @mercenary_roster_index_sql = IF(@mercenary_roster_index_present=0,
 'ALTER TABLE mercs ADD UNIQUE KEY merc_owner_slot (OwnerCharacterID,Slot)', 'DO 0');
PREPARE mercenary_roster_index_statement FROM @mercenary_roster_index_sql;
EXECUTE mercenary_roster_index_statement;
DEALLOCATE PREPARE mercenary_roster_index_statement;
