-- Steppes catalogue-only prerequisite, staged disabled; no task/criteria/reward/player-state writes.
-- MariaDB with enforced CHECK constraints. Stop game services/back up these four content tables before deliberate installation.
-- Review provenance first; set @steppes_catalogue_reviewed=1 in this same session to authorize this file.
-- Do not use --force. All permanent inserts also require the combined preflight result, protecting against continued execution after guard failure.
SET NAMES utf8mb4;
SET SESSION check_constraint_checks=1;
DROP TEMPORARY TABLE IF EXISTS `_stp_achievement_categories`;
CREATE TEMPORARY TABLE `_stp_achievement_categories` LIKE `achievement_categories`;
INSERT INTO `_stp_achievement_categories`(`id`,`parent_id`,`sequence`,`name`,`description`,`icon`) VALUES
(70,0,3,CONVERT(0x546865204865726f2773204a6f75726e6579 USING utf8mb4),CONVERT(0x546865204865726f2773204a6f75726e6579 USING utf8mb4),CONVERT(0x415f484a4e59 USING utf8mb4)),
(71,70,1,CONVERT(0x50726f6772657373696f6e USING utf8mb4),CONVERT(0x50726f6772657373696f6e USING utf8mb4),CONVERT(0x415f50726f6772657373696f6e537562 USING utf8mb4)),
(72,70,2,CONVERT(0x416476616e63656d656e74 USING utf8mb4),CONVERT(0x416476616e63656d656e74 USING utf8mb4),CONVERT(0x415f416476616e63656d656e74537562 USING utf8mb4));
DROP TEMPORARY TABLE IF EXISTS `_stp_achievements`;
CREATE TEMPORARY TABLE `_stp_achievements` LIKE `achievements`;
INSERT INTO `_stp_achievements`(`id`,`name`,`description`,`icon_id`,`points`,`has_reward`,`client_flag`,`version`,`reset_on_version_change`,`enabled`) VALUES
(500060200,CONVERT(0x436f6e71756572696e67205468652053746570706573202836312d373029 USING utf8mb4),CONVERT(0x41206e756d626572206f662070656f706c6520696e204372657363656e742052656163682068617665206a6f627320696e766f6c76696e672054686520537465707065732e20537065616b20776974682057617264656e204a616b61722061626f7574207265647563696e672074686520476f626c696e20616e6420476e6f6c6c207468726561742061732077656c6c2061732044616572604c6167617220616e642053656c616e612061626f757420636f6c6c656374696e6720737570706c6965733a USING utf8mb4),1169,7,1,0,0,1,0),
(500060300,CONVERT(0x5374657070652052696768742055702028537465707065732036302b29 USING utf8mb4),CONVERT(0x546f65676e6173686572207365656b7320746865207061676573206f6620616e20616e6369656e7420746f6d652c205961766961207365656b7320616e792068656c70207368652063616e206765742c20616e6420426f7264616e20746865204375727365642077616e747320746f2064697370656c2074686520637572736520686973206772656564206561726e65642068696d3a USING utf8mb4),782,3,1,0,0,1,0),
(500060400,CONVERT(0x52656275696c64696e672074686520506f7274616c2028537465707065732036302b29 USING utf8mb4),CONVERT(0x4d6f6c6472656e20746865205769736520686173206120706c616e20746f20737065616b20746f2074686520616e6369656e7420747265616e742057696c706564207468652057697468657265642e20536565207768617420796f752063616e20646f20746f2068656c703a USING utf8mb4),1072,3,1,0,0,1,0);
DROP TEMPORARY TABLE IF EXISTS `_stp_achievement_components`;
CREATE TEMPORARY TABLE `_stp_achievement_components` LIKE `achievement_components`;
INSERT INTO `_stp_achievement_components`(`achievement_id`,`component_type`,`sequence`,`component_id`,`name`,`description`) VALUES
(500060200,1,1,50190,CONVERT(0x57617264656e204a616b6172202d205377656570696e672074686520537465707065733a20476f626c696e73 USING utf8mb4),''),
(500060200,1,2,50191,CONVERT(0x57617264656e204a616b6172202d205377656570696e672074686520537465707065733a20476e6f6c6c73 USING utf8mb4),''),
(500060200,1,3,50192,CONVERT(0x57617264656e204a616b6172202d2043756c6c2074686520476f626c696e73 USING utf8mb4),''),
(500060200,1,4,50193,CONVERT(0x57617264656e204a616b6172202d2043756c6c2074686520476e6f6c6c73 USING utf8mb4),''),
(500060200,1,5,50194,CONVERT(0x57617264656e204a616b6172202d20536f77696e672044697373656e74 USING utf8mb4),''),
(500060200,1,6,50195,CONVERT(0x44616572604c61676172202d20576f6f6420666f722043617276696e67 USING utf8mb4),''),
(500060200,1,7,50196,CONVERT(0x53656c616e61202d20436c617920666f722053656c616e61 USING utf8mb4),''),
(500060200,3,0,2068,CONVERT(0x5265616368204c6576656c203630 USING utf8mb4),''),
(500060200,3,0,7011,CONVERT(0x53657270656e74 USING utf8mb4),''),
(500060300,1,1,50197,CONVERT(0x5961766961202d20576562206f6620437572696f73697479 USING utf8mb4),''),
(500060300,1,2,50198,CONVERT(0x426f7264616e2074686520437572736564202d205472656173757265206f66207468652044656164 USING utf8mb4),''),
(500060300,1,3,50199,CONVERT(0x546f65676e6173686572202d20426f6f6b20666f7220546f65676e6173686572 USING utf8mb4),''),
(500060300,3,0,2068,CONVERT(0x5265616368204c6576656c203630 USING utf8mb4),''),
(500060300,3,0,7011,CONVERT(0x53657270656e74 USING utf8mb4),''),
(500060400,1,1,50200,CONVERT(0x4d6f6c6472656e207468652057697365202d205468652054616c6b696e6720506c616e74 USING utf8mb4),''),
(500060400,1,2,50201,CONVERT(0x4d6f6c6472656e207468652057697365202d20546865204c696272617279 USING utf8mb4),''),
(500060400,1,3,50202,CONVERT(0x57696c70656420746865205769746865726564202d205468652044657374726f79656420506f7274616c USING utf8mb4),''),
(500060400,3,0,2068,CONVERT(0x5265616368204c6576656c203630 USING utf8mb4),''),
(500060400,3,0,7011,CONVERT(0x53657270656e74 USING utf8mb4),'');
DROP TEMPORARY TABLE IF EXISTS `_stp_achievement_category_associations`;
CREATE TEMPORARY TABLE `_stp_achievement_category_associations` LIKE `achievement_category_associations`;
INSERT INTO `_stp_achievement_category_associations`(`category_id`,`sequence`,`achievement_id`,`display_text`) VALUES
(71,0,500060200,''),
(72,0,500060300,''),
(72,0,500060400,'');
DROP TEMPORARY TABLE IF EXISTS `_stp_catalogue_guard`;
CREATE TEMPORARY TABLE `_stp_catalogue_guard`(ok TINYINT NOT NULL CHECK(ok=1)) ENGINE=InnoDB;
START TRANSACTION;
SET @steppes_catalogue_ok=(COALESCE(@steppes_catalogue_reviewed,0)=1)
 AND (NOT EXISTS(SELECT 1 FROM `achievement_categories` a WHERE a.id IN(70,71,72) AND NOT EXISTS(SELECT 1 FROM `_stp_achievement_categories` e WHERE a.`id`<=>e.`id` AND a.`parent_id`<=>e.`parent_id` AND a.`sequence`<=>e.`sequence` AND BINARY a.`name`<=>BINARY e.`name` AND BINARY a.`description`<=>BINARY e.`description` AND BINARY a.`icon`<=>BINARY e.`icon`)))
 AND (NOT EXISTS(SELECT 1 FROM `achievements` a WHERE a.id IN(500060200,500060300,500060400) AND NOT EXISTS(SELECT 1 FROM `_stp_achievements` e WHERE a.`id`<=>e.`id` AND BINARY a.`name`<=>BINARY e.`name` AND BINARY a.`description`<=>BINARY e.`description` AND a.`icon_id`<=>e.`icon_id` AND a.`points`<=>e.`points` AND a.`has_reward`<=>e.`has_reward` AND a.`client_flag`<=>e.`client_flag` AND a.`version`<=>e.`version` AND a.`reset_on_version_change`<=>e.`reset_on_version_change`)))
 AND (NOT EXISTS(SELECT 1 FROM `achievement_components` a WHERE a.achievement_id IN(500060200,500060300,500060400) AND NOT EXISTS(SELECT 1 FROM `_stp_achievement_components` e WHERE a.`achievement_id`<=>e.`achievement_id` AND a.`component_type`<=>e.`component_type` AND a.`sequence`<=>e.`sequence` AND a.`component_id`<=>e.`component_id` AND BINARY a.`name`<=>BINARY e.`name` AND BINARY a.`description`<=>BINARY e.`description`)))
 AND (NOT EXISTS(SELECT 1 FROM `achievement_category_associations` a WHERE a.achievement_id IN(500060200,500060300,500060400) AND NOT EXISTS(SELECT 1 FROM `_stp_achievement_category_associations` e WHERE a.`category_id`<=>e.`category_id` AND a.`sequence`<=>e.`sequence` AND a.`achievement_id`<=>e.`achievement_id` AND BINARY a.`display_text`<=>BINARY e.`display_text`)))
 AND (NOT EXISTS(SELECT 1 FROM achievement_components WHERE component_id BETWEEN 50190 AND 50202 AND achievement_id NOT IN(500060200,500060300,500060400)))
 AND (NOT EXISTS(SELECT 1 FROM achievement_associations WHERE component_id BETWEEN 50190 AND 50202 AND required_count<>1))
 AND (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN('achievement_categories','achievements','achievement_components','achievement_category_associations') AND ENGINE='InnoDB')=4;
INSERT INTO `_stp_catalogue_guard` VALUES(COALESCE(@steppes_catalogue_ok,0));
INSERT INTO `achievement_categories`(`id`,`parent_id`,`sequence`,`name`,`description`,`icon`)
SELECT e.`id`,e.`parent_id`,e.`sequence`,e.`name`,e.`description`,e.`icon` FROM `_stp_achievement_categories` e
WHERE @steppes_catalogue_ok=1 AND NOT EXISTS(SELECT 1 FROM `achievement_categories` a WHERE a.`id`=e.`id`);
INSERT INTO `achievements`(`id`,`name`,`description`,`icon_id`,`points`,`has_reward`,`client_flag`,`version`,`reset_on_version_change`,`enabled`)
SELECT e.`id`,e.`name`,e.`description`,e.`icon_id`,e.`points`,e.`has_reward`,e.`client_flag`,e.`version`,e.`reset_on_version_change`,e.`enabled` FROM `_stp_achievements` e
WHERE @steppes_catalogue_ok=1 AND NOT EXISTS(SELECT 1 FROM `achievements` a WHERE a.`id`=e.`id`);
INSERT INTO `achievement_components`(`achievement_id`,`component_type`,`sequence`,`component_id`,`name`,`description`)
SELECT e.`achievement_id`,e.`component_type`,e.`sequence`,e.`component_id`,e.`name`,e.`description` FROM `_stp_achievement_components` e
WHERE @steppes_catalogue_ok=1 AND NOT EXISTS(SELECT 1 FROM `achievement_components` a WHERE a.`achievement_id`=e.`achievement_id` AND a.`component_type`=e.`component_type` AND a.`component_id`=e.`component_id`);
INSERT INTO `achievement_category_associations`(`category_id`,`sequence`,`achievement_id`,`display_text`)
SELECT e.`category_id`,e.`sequence`,e.`achievement_id`,e.`display_text` FROM `_stp_achievement_category_associations` e
WHERE @steppes_catalogue_ok=1 AND NOT EXISTS(SELECT 1 FROM `achievement_category_associations` a WHERE a.`category_id`=e.`category_id` AND a.`achievement_id`=e.`achievement_id`);
COMMIT;
SET @steppes_catalogue_ok=NULL;
DROP TEMPORARY TABLE `_stp_achievement_categories`;
DROP TEMPORARY TABLE `_stp_achievements`;
DROP TEMPORARY TABLE `_stp_achievement_components`;
DROP TEMPORARY TABLE `_stp_achievement_category_associations`;
DROP TEMPORARY TABLE `_stp_catalogue_guard`;
