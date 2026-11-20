-- Add only the level 68 and level 70 claim schemas. The level 69 schema and receipts remain in place.
DELIMITER $$
BEGIN NOT ATOMIC
 IF DATABASE() IS NULL OR @@in_transaction<>0 THEN
   SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Select the target database outside a transaction';
 END IF;
 IF (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema=DATABASE()
     AND table_name IN ('inventory','character_currency','housing_inventory_sessions',
         'housing_live_item_leases','dodh_level69_claims') AND table_type='BASE TABLE' AND engine='InnoDB')<>5
 OR EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema=DATABASE()
     AND table_name IN ('dodh_level68_claims','dodh_level70_claims')) THEN
   SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Darkhollow follow-up claim foundation differs';
 END IF;
 CREATE TABLE dodh_level68_claims (
  character_id INT UNSIGNED NOT NULL,
  route_id TINYINT UNSIGNED NOT NULL,
  class_id TINYINT UNSIGNED NOT NULL,
  item_id INT UNSIGNED NOT NULL,
  spell_id INT UNSIGNED NOT NULL,
  item_serial INT NOT NULL COMMENT 'Positive native ItemInstance serial persisted as inventory.guid at delivery',
  PRIMARY KEY (character_id,route_id),
  CONSTRAINT dodh_level68_claim_values CHECK
   (character_id>0 AND route_id=2 AND class_id IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)
    AND item_id>0 AND spell_id>0 AND item_serial>0)
 ) ENGINE=InnoDB DEFAULT CHARSET=ascii;
 CREATE TABLE dodh_level70_claims (
  character_id INT UNSIGNED NOT NULL,
  route_id TINYINT UNSIGNED NOT NULL,
  class_id TINYINT UNSIGNED NOT NULL,
  item_id INT UNSIGNED NOT NULL,
  spell_id INT UNSIGNED NOT NULL,
  item_serial INT NOT NULL COMMENT 'Positive native ItemInstance serial persisted as inventory.guid at delivery',
  PRIMARY KEY (character_id,route_id),
  CONSTRAINT dodh_level70_claim_values CHECK
   (character_id>0 AND route_id=3 AND class_id IN(2,6,10,11,12,13,14)
    AND item_id>0 AND spell_id>0 AND item_serial>0)
 ) ENGINE=InnoDB DEFAULT CHARSET=ascii;
END$$
DELIMITER ;
