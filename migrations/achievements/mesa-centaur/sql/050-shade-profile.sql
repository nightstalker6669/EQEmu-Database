-- Period-supported mechanics plus explicit server reconstructions:
-- HP22200: existing PEQ named55 baseline, original exact HP unknown.
-- min61: existing named55/Necromancer native scaling default.
-- max377: reconstruction from Oct17,2006 observed hit, not raw Live DB proof.
-- respawn2550 +/-150sec: Mar12,2013 reported40–45min interval; distribution default.
-- Visibility1: ordinary invisibility, not a claim about every enhanced invisibility tier.
SET NAMES utf8mb4;
DELIMITER //
BEGIN NOT ATOMIC
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK;RESIGNAL;END;
 START TRANSACTION;
 IF NOT EXISTS(SELECT 1 FROM npc_types WHERE id=397196 AND name='#shade_of_corruption' AND level=55 AND class=11 AND hp=3575 AND mindmg=0 AND maxdmg=4 AND see_invis=0) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Shade profile preimage conflict';
 END IF;
 IF NOT EXISTS(SELECT 1 FROM spawn2 WHERE id=112270 AND zone='mesa' AND version=0 AND spawngroupID=73872 AND respawntime=640 AND variance=0) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Shade spawn timer preimage conflict';
 END IF;
 UPDATE npc_types SET hp=22200,mindmg=61,maxdmg=377,see_invis=1 WHERE id=397196 AND hp=3575 AND mindmg=0 AND maxdmg=4 AND see_invis=0;
 IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Shade profile affected-row conflict';END IF;
 UPDATE spawn2 SET respawntime=2550,variance=300 WHERE id=112270 AND respawntime=640 AND variance=0;
 IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Shade timer affected-row conflict';END IF;
 COMMIT;
END//
DELIMITER ;
