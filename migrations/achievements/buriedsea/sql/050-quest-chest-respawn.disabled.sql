-- Original May22,2007 report on quest4079 specifies a six-minute respawn.
-- Only the five existing Redfeather item spawns are changed. No positions,
-- other island timers, spawn groups or shared loot tables are overwritten.
SET SESSION check_constraint_checks=1;
START TRANSACTION;
SET @tbs_chest_respawn_ok=IF(COALESCE(@buriedsea_whole_batch_reviewed,0)=1
 AND (SELECT COUNT(*) FROM spawn2 s JOIN spawnentry e ON e.spawngroupID=s.spawngroupID
  WHERE s.zone='buriedsea' AND e.npcID=423141 AND e.chance=100
   AND s.respawntime IN(640,360)
   AND ((s.id=118040 AND s.spawngroupID=79642)
    OR(s.id=118137 AND s.spawngroupID=79739)
    OR(s.id=118212 AND s.spawngroupID=79814)
    OR(s.id=118276 AND s.spawngroupID=79878)
    OR(s.id=118428 AND s.spawngroupID=80030)))=5
 AND NOT EXISTS(SELECT 1 FROM spawnentry WHERE spawngroupID IN(79642,79739,79814,79878,80030) AND npcID<>423141),1,0);
DROP TEMPORARY TABLE IF EXISTS `_tbs_chest_respawn_guard`;
CREATE TEMPORARY TABLE `_tbs_chest_respawn_guard`(ok INT NOT NULL CHECK(ok=1));
INSERT INTO `_tbs_chest_respawn_guard` VALUES(@tbs_chest_respawn_ok);
UPDATE spawn2 SET respawntime=360
 WHERE @tbs_chest_respawn_ok=1 AND zone='buriedsea'
 AND id IN(118040,118137,118212,118276,118428);
COMMIT;
