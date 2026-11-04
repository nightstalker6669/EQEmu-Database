-- Internal NPC reaction groups only. These are not player faction reward amounts.
-- Encounter scripts remain disabled until independently reviewed activation.
SET NAMES utf8mb4;
DELIMITER //
BEGIN NOT ATOMIC
 DECLARE held INT DEFAULT 0;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION
 BEGIN
  ROLLBACK;
  IF held=1 THEN DO RELEASE_LOCK('rof2.mesa.corruption.factions');END IF;
  RESIGNAL;
 END;
 SELECT GET_LOCK('rof2.mesa.corruption.factions',0) INTO held;
 IF held<>1 OR held IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Mesa reaction groups locked';END IF;
 START TRANSACTION;
 IF EXISTS(SELECT 1 FROM npc_faction WHERE id IN(3040461,3040462)) OR
    EXISTS(SELECT 1 FROM npc_faction_entries WHERE npc_faction_id IN(3040461,3040462)) OR
    EXISTS(SELECT 1 FROM npc_types WHERE npc_faction_id IN(3040461,3040462)) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Mesa reaction group IDs already in use';
 END IF;
 INSERT INTO npc_faction(id,name,primaryfaction,ignore_primary_assist)VALUES
 (3040461,'May2013 Mesa corrupted reaction',-10,0),
 (3040462,'May2013 Mesa restored reaction',-8,0);
 COMMIT;
 DO RELEASE_LOCK('rof2.mesa.corruption.factions');
END//
DELIMITER ;
