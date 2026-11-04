
ALTER TABLE `character_buffs`
	ADD COLUMN `initialduration` INT(11) SIGNED NOT NULL DEFAULT 0 AFTER `ticsremaining`,
	CHANGE COLUMN `dot_rune` `dot_rune` INT(10) UNSIGNED NOT NULL DEFAULT 0;
UPDATE `character_buffs` SET `initialduration` = `ticsremaining` WHERE TRUE;

ALTER TABLE IF EXISTS `merc_buffs`
	CHANGE COLUMN `dot_rune` `dot_rune` INT(10) UNSIGNED NOT NULL DEFAULT 0,
	ADD COLUMN `InitialDuration` INT(11) SIGNED NOT NULL DEFAULT 0 AFTER `TicsRemaining`,
	ADD COLUMN `instrument_mod` INT(10) UNSIGNED NOT NULL DEFAULT 10 AFTER `ExtraDIChance`;
IF EXISTS(
	SELECT 1 FROM `information_schema`.`TABLES` WHERE `table_schema` = DATABASE() AND `table_name` = 'merc_buffs'
) THEN UPDATE `merc_buffs` SET `InitialDuration` = `TicsRemaining` WHERE TRUE; END IF;

ALTER TABLE `character_pet_buffs`
	CHANGE COLUMN `char_id` `character_id` INT(11) UNSIGNED NOT NULL,
	CHANGE COLUMN `slot` `slot_id` TINYINT(3) UNSIGNED NOT NULL,
	CHANGE COLUMN `caster_level` `caster_level` TINYINT(3) UNSIGNED NOT NULL,
	RENAME COLUMN `castername` TO `caster_name`,
	ADD COLUMN `initialduration` INT(11) SIGNED NOT NULL DEFAULT 0 AFTER `ticsremaining`,
	CHANGE COLUMN `counters` `counters` INT(10) UNSIGNED NOT NULL DEFAULT 0,
	CHANGE COLUMN `numhits` `numhits` INT(10) UNSIGNED NOT NULL DEFAULT 0,
	CHANGE COLUMN `rune` `melee_rune` INT(10) UNSIGNED NOT NULL DEFAULT 0,
	ADD COLUMN `magic_rune` INT(10) UNSIGNED NOT NULL DEFAULT 0 AFTER `melee_rune`,
	ADD COLUMN `persistent` TINYINT(3) UNSIGNED NOT NULL DEFAULT 0 AFTER `magic_rune`,
	ADD COLUMN `dot_rune` INT(10) UNSIGNED NOT NULL DEFAULT 0 AFTER `persistent`,
	ADD COLUMN `caston_x` INT(10) NOT NULL DEFAULT 0 AFTER `dot_rune`,
	ADD COLUMN `caston_y` INT(10) NOT NULL DEFAULT 0 AFTER `caston_x`,
	ADD COLUMN `caston_z` INT(10) NOT NULL DEFAULT 0 AFTER `caston_y`,
	ADD COLUMN `ExtraDIChance` INT(10) NOT NULL DEFAULT 0 AFTER `caston_z`,
	CHANGE COLUMN `instrument_mod` `instrument_mod` INT(10) UNSIGNED NOT NULL DEFAULT 10 AFTER `ExtraDIChance`;
