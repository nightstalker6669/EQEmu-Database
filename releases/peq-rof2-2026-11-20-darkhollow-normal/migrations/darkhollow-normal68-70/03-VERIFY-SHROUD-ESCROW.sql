DELIMITER //
BEGIN NOT ATOMIC
IF DATABASE() IS NULL OR @@in_transaction<>0 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Snapshot alignment requires the exact dev database outside a transaction';
 END IF;
 SET TRANSACTION READ ONLY;
 START TRANSACTION;

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
 COMMIT;
 SELECT 'SHROUD_SNAPSHOT_ALIGNMENT_TYPED_POSTIMAGES_PASS' AS receipt;
END//
DELIMITER ;
