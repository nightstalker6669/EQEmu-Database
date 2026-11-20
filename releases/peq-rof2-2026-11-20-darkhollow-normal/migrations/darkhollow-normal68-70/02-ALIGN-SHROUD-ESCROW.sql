-- Reviewed development alignment of four empty legacy shroud escrow tables.
-- Requires stopped world/zone and empty affected shroud escrow. Each ALTER commits independently.
-- No task, role choice, live character table, or session rows are written.
DELIMITER //
BEGIN NOT ATOMIC
 IF DATABASE() IS NULL OR @@in_transaction<>0 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Select target database outside a transaction';
 END IF;
 IF EXISTS (SELECT 1 FROM spirit_shroud_state WHERE template_id<>0 OR active_session_id IS NOT NULL)
  OR EXISTS (SELECT 1 FROM spirit_shroud_sessions WHERE phase='active')
  OR EXISTS (SELECT 1 FROM shroud_original_character_buffs)
  OR EXISTS (SELECT 1 FROM shroud_original_character_pet_buffs)
  OR EXISTS (SELECT 1 FROM shroud_original_character_spells)
  OR EXISTS (SELECT 1 FROM shroud_original_character_memmed_spells) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Shroud alignment requires empty affected escrow and no active shroud sessions';
 END IF;
 IF (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema=DATABASE()
  AND table_name IN ('character_buffs','character_memmed_spells','character_pet_buffs','character_spells','shroud_original_character_buffs','shroud_original_character_memmed_spells','shroud_original_character_pet_buffs','shroud_original_character_spells') AND ENGINE='InnoDB')<>8 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Shroud alignment requires eight InnoDB tables';
 END IF;
 IF (
  SELECT COUNT(*) FROM (
   SELECT table_name,COUNT(*) AS column_count,
    SHA2(GROUP_CONCAT(CONCAT_WS(':',ordinal_position,column_name,column_type,is_nullable,
      COALESCE(column_default,'<NULL>')) ORDER BY ordinal_position SEPARATOR '|'),256) AS shape
   FROM information_schema.columns WHERE table_schema=DATABASE()
    AND table_name IN ('character_buffs','character_memmed_spells','character_pet_buffs','character_spells','shroud_original_character_buffs','shroud_original_character_memmed_spells','shroud_original_character_pet_buffs','shroud_original_character_spells')
   GROUP BY table_name
  ) s WHERE (s.table_name,s.column_count,s.shape) IN (
   ('character_buffs',18,'4735c8520c32247e5116881bc6f78fcbde700591d287a8819ec78c4ce37a432c'),
   ('character_memmed_spells',3,'fb977b7596a280839ac11c96a6c4e9b0d9bed4b63e2333963151d568673ead57'),
   ('character_pet_buffs',19,'5cebded375f9ee1842bd263432aa4b768107c795bc9847b87fa245dc5f5e8626'),
   ('character_spells',3,'24d47f3d6a16b9d151cc7c4331c9b7385124df6ee101ed9ab2c85dc2c5caab7e'),
   ('shroud_original_character_buffs',17,'c3ecabe05812059742c75cf55013da49ad57c889a96d1242f4921c16d6fe4c88'),
   ('shroud_original_character_memmed_spells',3,'3d58ade2d596894866776155eb0fd2ba2fa30bfe2311591d9ea755a69a02b9cc'),
   ('shroud_original_character_pet_buffs',11,'83427ab96e21c1911e8054e53126bd844466d619a3a96faa3cf3398616c95baa'),
   ('shroud_original_character_spells',3,'904d43011b1c91c7fb597d8c63f1bab91de97d2983bb25a1c41fed6cd6ed6824')
  )
 ) <> 8 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Shroud snapshot preimage differs';
 END IF;

 ALTER TABLE shroud_original_character_buffs
  MODIFY COLUMN spell_id INT(11) NOT NULL,
  ADD COLUMN initialduration INT(11) NOT NULL DEFAULT 0 AFTER ticsremaining,
  MODIFY COLUMN dot_rune INT(10) UNSIGNED NOT NULL DEFAULT 0;

 ALTER TABLE shroud_original_character_pet_buffs
  CHANGE COLUMN char_id character_id INT(11) UNSIGNED NOT NULL,
  CHANGE COLUMN slot slot_id TINYINT(3) UNSIGNED NOT NULL,
  MODIFY COLUMN caster_level TINYINT(3) UNSIGNED NOT NULL,
  RENAME COLUMN castername TO caster_name,
  ADD COLUMN initialduration INT(11) NOT NULL DEFAULT 0 AFTER ticsremaining,
  MODIFY COLUMN counters INT(10) UNSIGNED NOT NULL DEFAULT 0,
  MODIFY COLUMN numhits INT(10) UNSIGNED NOT NULL DEFAULT 0,
  CHANGE COLUMN rune melee_rune INT(10) UNSIGNED NOT NULL DEFAULT 0,
  ADD COLUMN magic_rune INT(10) UNSIGNED NOT NULL DEFAULT 0 AFTER melee_rune,
  ADD COLUMN persistent TINYINT(3) UNSIGNED NOT NULL DEFAULT 0 AFTER magic_rune,
  ADD COLUMN dot_rune INT(10) UNSIGNED NOT NULL DEFAULT 0 AFTER persistent,
  ADD COLUMN caston_x INT(10) NOT NULL DEFAULT 0 AFTER dot_rune,
  ADD COLUMN caston_y INT(10) NOT NULL DEFAULT 0 AFTER caston_x,
  ADD COLUMN caston_z INT(10) NOT NULL DEFAULT 0 AFTER caston_y,
  ADD COLUMN ExtraDIChance INT(10) NOT NULL DEFAULT 0 AFTER caston_z,
  MODIFY COLUMN instrument_mod INT(10) UNSIGNED NOT NULL DEFAULT 10 AFTER ExtraDIChance;

 ALTER TABLE shroud_original_character_spells MODIFY COLUMN spell_id INT(11) NOT NULL DEFAULT 0;
 ALTER TABLE shroud_original_character_memmed_spells MODIFY COLUMN spell_id INT(11) NOT NULL DEFAULT 0;

 IF (
  SELECT COUNT(*) FROM (
   SELECT table_name,COUNT(*) AS column_count,
    SHA2(GROUP_CONCAT(CONCAT_WS(':',ordinal_position,column_name,column_type,is_nullable,
      COALESCE(column_default,'<NULL>')) ORDER BY ordinal_position SEPARATOR '|'),256) AS shape
   FROM information_schema.columns WHERE table_schema=DATABASE()
    AND table_name IN ('shroud_original_character_buffs','shroud_original_character_memmed_spells','shroud_original_character_pet_buffs','shroud_original_character_spells')
   GROUP BY table_name
  ) s WHERE (s.table_name,s.column_count,s.shape) IN (
   ('shroud_original_character_buffs',18,'4735c8520c32247e5116881bc6f78fcbde700591d287a8819ec78c4ce37a432c'),
   ('shroud_original_character_memmed_spells',3,'fb977b7596a280839ac11c96a6c4e9b0d9bed4b63e2333963151d568673ead57'),
   ('shroud_original_character_pet_buffs',19,'5cebded375f9ee1842bd263432aa4b768107c795bc9847b87fa245dc5f5e8626'),
   ('shroud_original_character_spells',3,'24d47f3d6a16b9d151cc7c4331c9b7385124df6ee101ed9ab2c85dc2c5caab7e')
  )
 ) <> 4 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Shroud snapshot postimage differs';
 END IF;

 IF NOT ((SELECT GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',')
     FROM information_schema.statistics WHERE table_schema=DATABASE()
      AND table_name='shroud_original_character_pet_buffs' AND index_name='PRIMARY')
      <=> 'character_id,pet,slot_id') THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Shroud pet snapshot primary key differs';
 END IF;
END//
DELIMITER ;

