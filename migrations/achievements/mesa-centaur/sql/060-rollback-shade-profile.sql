-- Exact reversal of the owned profile fields; position/group/grid and player data untouched.
SET NAMES utf8mb4;
DELIMITER //
BEGIN NOT ATOMIC
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK;RESIGNAL;END;
 START TRANSACTION;
 IF NOT EXISTS(SELECT 1 FROM npc_types WHERE id=397196 AND name='#shade_of_corruption' AND level=55 AND class=11 AND hp=22200 AND mindmg=61 AND maxdmg=377 AND see_invis=1)OR
    NOT EXISTS(SELECT 1 FROM spawn2 WHERE id=112270 AND zone='mesa' AND version=0 AND spawngroupID=73872 AND respawntime=2550 AND variance=300)THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Shade profile rollback conflict';
 END IF;
 UPDATE npc_types SET hp=3575,mindmg=0,maxdmg=4,see_invis=0 WHERE id=397196 AND hp=22200 AND mindmg=61 AND maxdmg=377 AND see_invis=1;
 IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Shade rollback affected-row conflict';END IF;
 UPDATE spawn2 SET respawntime=640,variance=0 WHERE id=112270 AND respawntime=2550 AND variance=300;
 IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Shade timer rollback affected-row conflict';END IF;
 COMMIT;
END//
DELIMITER ;
