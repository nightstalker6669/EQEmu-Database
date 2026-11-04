-- Stop game services before removing reaction groups used by active NPCs.
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
 IF (SELECT COUNT(*) FROM npc_faction WHERE id IN(3040461,3040462))<>2 OR
    EXISTS(SELECT 1 FROM npc_faction WHERE id IN(3040461,3040462) AND NOT(
     (id=3040461 AND name='May2013 Mesa corrupted reaction' AND primaryfaction=-10 AND ignore_primary_assist=0) OR
     (id=3040462 AND name='May2013 Mesa restored reaction' AND primaryfaction=-8 AND ignore_primary_assist=0))) OR
    EXISTS(SELECT 1 FROM npc_faction_entries WHERE npc_faction_id IN(3040461,3040462)) OR
    EXISTS(SELECT 1 FROM npc_types WHERE npc_faction_id IN(3040461,3040462)) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Mesa reaction group rollback conflict';
 END IF;
 DELETE FROM npc_faction WHERE id IN(3040461,3040462);
 COMMIT;
 DO RELEASE_LOCK('rof2.mesa.corruption.factions');
END//
DELIMITER ;
