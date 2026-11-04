-- Complete Dragonscale batch dependency: researched crystal/canvas pickup bindings.
-- Generated candidate only. Run under the whole-package transaction, stopped
-- writers and backup policy. This does not activate quests or change geometry.
SET NAMES utf8mb4;
SET SESSION check_constraint_checks=1;
DROP TEMPORARY TABLE IF EXISTS `_dragonscale_ground_expected`;
-- Copy native field types so FLOAT geometry retains its original precision.
CREATE TEMPORARY TABLE `_dragonscale_ground_expected` AS SELECT
`id`,`zoneid`,`version`,`max_x`,`max_y`,`max_z`,`min_x`,`min_y`,`heading`,`name`,`item`,`max_allowed`,`respawn_timer`, CAST(0 AS UNSIGNED) AS replacement
FROM ground_spawns WHERE 0;
INSERT INTO `_dragonscale_ground_expected` (`id`,`zoneid`,`version`,`max_x`,`max_y`,`max_z`,`min_x`,`min_y`,`heading`,`name`,`item`,`max_allowed`,`respawn_timer`,replacement) VALUES
(482,442,0,2628.99,2301.71,42.2,2628.99,2301.71,275,'IT11154_ACTORDEF',1001,1,300,36639),
(483,442,0,2533.35,2205.94,42.26,2533.35,2205.94,268,'IT11154_ACTORDEF',1001,1,300,36639),
(484,442,0,2586.05,2025.23,47.34,2586.05,2025.23,315,'IT11154_ACTORDEF',1001,1,300,36639),
(485,442,0,2512.95,2050.81,40.09,2512.95,2050.81,66,'IT11154_ACTORDEF',1001,1,300,36639),
(486,442,0,2575.62,2088.99,39.95,2575.62,2088.99,185,'IT11154_ACTORDEF',1001,1,300,36639),
(487,442,0,2752.83,2283.12,42.46,2752.83,2283.12,406,'IT11154_ACTORDEF',1001,1,300,36639),
(488,442,0,2819.79,2333.83,47.1,2819.79,2333.83,368,'IT11154_ACTORDEF',1001,1,300,36639),
(491,443,0,1712.21,881.52,16.17,1712.21,881.52,373,'IT65_ACTORDEF',1001,1,300,36638),
(492,443,0,1367.24,1023.94,15.48,1367.24,1023.94,497,'IT65_ACTORDEF',1001,1,300,36638),
(493,443,0,1509.38,880.07,25.66,1509.38,880.07,399,'IT65_ACTORDEF',1001,1,300,36638),
(494,443,0,1502.57,1211.43,19.26,1502.57,1211.43,52,'IT65_ACTORDEF',1001,1,300,36638),
(495,443,0,2055.32,985.61,14.1,2055.32,985.61,154,'IT65_ACTORDEF',1001,1,300,36638),
(496,443,0,1923.87,969.46,15.99,1923.87,969.46,377,'IT65_ACTORDEF',1001,1,300,36638),
(497,443,0,1875.52,1230.76,17.57,1875.52,1230.76,178,'IT65_ACTORDEF',1001,1,300,36638);
DROP TEMPORARY TABLE IF EXISTS `_dragonscale_ground_guard`;
CREATE TEMPORARY TABLE `_dragonscale_ground_guard` (
  ok INT NOT NULL CHECK(ok=1)
);
INSERT INTO `_dragonscale_ground_guard`
SELECT IF(COUNT(*)=14,1,0)
FROM `_dragonscale_ground_expected` e JOIN ground_spawns g ON g.id=e.id
WHERE g.`zoneid` <=> e.`zoneid` AND g.`version` <=> e.`version` AND g.`max_x` <=> e.`max_x` AND g.`max_y` <=> e.`max_y` AND g.`max_z` <=> e.`max_z` AND g.`min_x` <=> e.`min_x` AND g.`min_y` <=> e.`min_y` AND g.`heading` <=> e.`heading` AND g.`name` <=> e.`name` AND g.`max_allowed` <=> e.`max_allowed` AND g.`respawn_timer` <=> e.`respawn_timer` AND (g.item=e.item OR g.item=e.replacement);
INSERT INTO `_dragonscale_ground_guard`
SELECT IF(COUNT(*)=2,1,0) FROM items
WHERE (id=36639 AND Name='Levitation Crystal') OR (id=36638 AND Name='Piece of Canvas');
UPDATE ground_spawns g JOIN `_dragonscale_ground_expected` e ON g.id=e.id
SET g.item=e.replacement WHERE g.item=e.item;
INSERT INTO `_dragonscale_ground_guard`
SELECT IF(COUNT(*)=14,1,0)
FROM `_dragonscale_ground_expected` e JOIN ground_spawns g ON g.id=e.id
WHERE g.`zoneid` <=> e.`zoneid` AND g.`version` <=> e.`version` AND g.`max_x` <=> e.`max_x` AND g.`max_y` <=> e.`max_y` AND g.`max_z` <=> e.`max_z` AND g.`min_x` <=> e.`min_x` AND g.`min_y` <=> e.`min_y` AND g.`heading` <=> e.`heading` AND g.`name` <=> e.`name` AND g.`max_allowed` <=> e.`max_allowed` AND g.`respawn_timer` <=> e.`respawn_timer` AND g.item=e.replacement;
SET @dragonscale_ground_ok=1;
DROP TEMPORARY TABLE `_dragonscale_ground_guard`;
DROP TEMPORARY TABLE `_dragonscale_ground_expected`;
