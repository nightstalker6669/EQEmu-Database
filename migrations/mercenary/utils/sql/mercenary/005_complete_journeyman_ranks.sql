-- Restore missing Journeyman III-V content. Character/content mercenary tables
-- must be in the currently selected database, as in the existing template loader.
-- Explicit EMULATOR TUNING, not recovered historical Live balance:
-- III/IV/V = 110/120/130 percent of the same class/clientlevel Journeyman II.
-- See common/mercenary/RANKS.md. Existing rows, contracts and prices are untouched.
-- Run with a stop-on-error client (no --force, no reconnect), during exclusive
-- content maintenance. Any error before COMMIT requires ROLLBACK/disconnect.
-- Temporary tables are connection-local; no stored routine or permanent helper.

DROP TEMPORARY TABLE IF EXISTS _merc_rank_assert;
DROP TEMPORARY TABLE IF EXISTS _merc_rank_map;
CREATE TEMPORARY TABLE _merc_rank_assert (ok TINYINT NOT NULL CHECK(ok=1));
CREATE TEMPORARY TABLE _merc_rank_map (
 source_npc_id INT UNSIGNED NOT NULL, target_npc_id INT UNSIGNED PRIMARY KEY,
 class_id INT UNSIGNED NOT NULL, tier_id TINYINT UNSIGNED NOT NULL,
 percent SMALLINT UNSIGNED NOT NULL
) ENGINE=InnoDB;
INSERT INTO _merc_rank_map
SELECT a.merc_npc_type_id,b.merc_npc_type_id,b.class_id,b.tier_id,100+10*(b.tier_id-2)
FROM merc_npc_types a JOIN merc_npc_types b ON b.class_id=a.class_id
WHERE a.proficiency_id=2 AND a.tier_id=2 AND b.proficiency_id=2
 AND b.tier_id BETWEEN 3 AND 5 AND a.class_id IN(1,2,9,12);
INSERT INTO _merc_rank_assert SELECT IF(COUNT(*)=12,1,0) FROM _merc_rank_map;
INSERT INTO _merc_rank_assert SELECT IF(COUNT(DISTINCT source_npc_id)=4,1,0) FROM _merc_rank_map;
INSERT INTO _merc_rank_assert SELECT IF(COUNT(*)=5,1,0) FROM information_schema.tables
WHERE table_schema=DATABASE() AND table_name IN('merc_stats','merc_templates','merc_merchant_template_entries','merc_armorinfo','merc_weaponinfo') AND engine='InnoDB';

START TRANSACTION;
-- A baseline must exist for each role; do not produce placeholder NPC stats.
INSERT INTO _merc_rank_assert SELECT IF(COUNT(*)=0,1,0) FROM _merc_rank_map m
WHERE NOT EXISTS(SELECT 1 FROM merc_stats s WHERE s.merc_npc_type_id=m.source_npc_id);
INSERT INTO _merc_rank_assert SELECT IF(COUNT(*)=0,1,0) FROM _merc_rank_map m
WHERE NOT EXISTS(SELECT 1 FROM merc_templates t JOIN merc_types y USING(merc_type_id)
 JOIN merc_subtypes u USING(merc_subtype_id) WHERE t.merc_npc_type_id=m.source_npc_id
 AND y.proficiency_id=2 AND u.class_id=m.class_id AND u.tier_id=2);
-- Every mapped rank must have one unambiguous client subtype.
INSERT INTO _merc_rank_assert SELECT IF(COUNT(*)=0,1,0) FROM _merc_rank_map m
WHERE (SELECT COUNT(*) FROM merc_subtypes u
 WHERE u.class_id=m.class_id AND u.tier_id=m.tier_id)<>1;
-- The stock dbstring encodes the tier in its last digit. Custom baselines
-- using another convention must be migrated explicitly, never guessed.
INSERT INTO _merc_rank_assert SELECT IF(COUNT(*)=0,1,0)
FROM merc_templates t JOIN _merc_rank_map m ON m.source_npc_id=t.merc_npc_type_id
WHERE t.dbstring NOT REGEXP '^[0-9]+2$';
-- Preserve custom rows, but refuse an existing rank wired to a different NPC.
INSERT INTO _merc_rank_assert SELECT IF(COUNT(*)=0,1,0)
FROM merc_templates a JOIN merc_types y ON y.merc_type_id=a.merc_type_id
JOIN merc_subtypes sa ON sa.merc_subtype_id=a.merc_subtype_id
JOIN _merc_rank_map m ON m.source_npc_id=a.merc_npc_type_id
JOIN merc_subtypes sb ON sb.class_id=m.class_id AND sb.tier_id=m.tier_id
JOIN merc_templates b ON b.merc_type_id=a.merc_type_id AND b.merc_subtype_id=sb.merc_subtype_id
WHERE y.proficiency_id=2 AND sa.class_id=m.class_id AND sa.tier_id=2
 AND b.merc_npc_type_id<>m.target_npc_id;

INSERT INTO merc_stats (
 `merc_npc_type_id`, `clientlevel`, `level`, `hp`, `mana`, `AC`, `ATK`, `STR`, `STA`, `DEX`, `AGI`, `_INT`, `WIS`, `CHA`, `MR`, `CR`, `DR`, `FR`, `PR`, `Corrup`, `mindmg`, `maxdmg`, `attack_count`, `attack_speed`, `attack_delay`, `special_abilities`, `Accuracy`, `hp_regen_rate`, `mana_regen_rate`, `runspeed`, `statscale`, `spellscale`, `healscale`
)
SELECT
 m.target_npc_id,
 s.`clientlevel`,
 s.`level`,
 CASE WHEN s.`hp` > 0 THEN LEAST(2147483647, FLOOR(CAST(s.`hp` AS DECIMAL(30,6)) * m.percent / 100)) ELSE s.`hp` END,
 CASE WHEN s.`mana` > 0 THEN LEAST(2147483647, FLOOR(CAST(s.`mana` AS DECIMAL(30,6)) * m.percent / 100)) ELSE s.`mana` END,
 CASE WHEN s.`AC` > 0 THEN LEAST(32767, FLOOR(CAST(s.`AC` AS DECIMAL(30,6)) * m.percent / 100)) ELSE s.`AC` END,
 CASE WHEN s.`ATK` > 0 THEN LEAST(8388607, FLOOR(CAST(s.`ATK` AS DECIMAL(30,6)) * m.percent / 100)) ELSE s.`ATK` END,
 CASE WHEN s.`STR` > 0 THEN LEAST(16777215, FLOOR(CAST(s.`STR` AS DECIMAL(30,6)) * m.percent / 100)) ELSE s.`STR` END,
 CASE WHEN s.`STA` > 0 THEN LEAST(16777215, FLOOR(CAST(s.`STA` AS DECIMAL(30,6)) * m.percent / 100)) ELSE s.`STA` END,
 CASE WHEN s.`DEX` > 0 THEN LEAST(16777215, FLOOR(CAST(s.`DEX` AS DECIMAL(30,6)) * m.percent / 100)) ELSE s.`DEX` END,
 CASE WHEN s.`AGI` > 0 THEN LEAST(16777215, FLOOR(CAST(s.`AGI` AS DECIMAL(30,6)) * m.percent / 100)) ELSE s.`AGI` END,
 CASE WHEN s.`_INT` > 0 THEN LEAST(16777215, FLOOR(CAST(s.`_INT` AS DECIMAL(30,6)) * m.percent / 100)) ELSE s.`_INT` END,
 CASE WHEN s.`WIS` > 0 THEN LEAST(16777215, FLOOR(CAST(s.`WIS` AS DECIMAL(30,6)) * m.percent / 100)) ELSE s.`WIS` END,
 CASE WHEN s.`CHA` > 0 THEN LEAST(16777215, FLOOR(CAST(s.`CHA` AS DECIMAL(30,6)) * m.percent / 100)) ELSE s.`CHA` END,
 CASE WHEN s.`MR` > 0 THEN LEAST(32767, FLOOR(CAST(s.`MR` AS DECIMAL(30,6)) * m.percent / 100)) ELSE s.`MR` END,
 CASE WHEN s.`CR` > 0 THEN LEAST(32767, FLOOR(CAST(s.`CR` AS DECIMAL(30,6)) * m.percent / 100)) ELSE s.`CR` END,
 CASE WHEN s.`DR` > 0 THEN LEAST(32767, FLOOR(CAST(s.`DR` AS DECIMAL(30,6)) * m.percent / 100)) ELSE s.`DR` END,
 CASE WHEN s.`FR` > 0 THEN LEAST(32767, FLOOR(CAST(s.`FR` AS DECIMAL(30,6)) * m.percent / 100)) ELSE s.`FR` END,
 CASE WHEN s.`PR` > 0 THEN LEAST(32767, FLOOR(CAST(s.`PR` AS DECIMAL(30,6)) * m.percent / 100)) ELSE s.`PR` END,
 CASE WHEN s.`Corrup` > 0 THEN LEAST(32767, FLOOR(CAST(s.`Corrup` AS DECIMAL(30,6)) * m.percent / 100)) ELSE s.`Corrup` END,
 CASE WHEN s.`mindmg` > 0 THEN LEAST(4294967295, FLOOR(CAST(s.`mindmg` AS DECIMAL(30,6)) * m.percent / 100)) ELSE s.`mindmg` END,
 CASE WHEN s.`maxdmg` > 0 THEN LEAST(4294967295, FLOOR(CAST(s.`maxdmg` AS DECIMAL(30,6)) * m.percent / 100)) ELSE s.`maxdmg` END,
 s.`attack_count`,
 s.`attack_speed`,
 s.`attack_delay`,
 s.`special_abilities`,
 CASE WHEN s.`Accuracy` > 0 THEN LEAST(8388607, FLOOR(CAST(s.`Accuracy` AS DECIMAL(30,6)) * m.percent / 100)) ELSE s.`Accuracy` END,
 CASE WHEN s.`hp_regen_rate` > 0 THEN LEAST(4294967295, FLOOR(CAST(s.`hp_regen_rate` AS DECIMAL(30,6)) * m.percent / 100)) ELSE s.`hp_regen_rate` END,
 CASE WHEN s.`mana_regen_rate` > 0 THEN LEAST(4294967295, FLOOR(CAST(s.`mana_regen_rate` AS DECIMAL(30,6)) * m.percent / 100)) ELSE s.`mana_regen_rate` END,
 s.`runspeed`,
 s.`statscale`,
 CASE WHEN s.`spellscale` > 0 THEN LEAST(3.4028234e38, s.`spellscale` * m.percent / 100) ELSE s.`spellscale` END,
 CASE WHEN s.`healscale` > 0 THEN LEAST(3.4028234e38, s.`healscale` * m.percent / 100) ELSE s.`healscale` END
FROM merc_stats s JOIN _merc_rank_map m ON m.source_npc_id=s.merc_npc_type_id
WHERE NOT EXISTS(SELECT 1 FROM merc_stats d WHERE d.merc_npc_type_id=m.target_npc_id AND d.clientlevel=s.clientlevel);

-- Native appearance/weapon ranges already cover all 40 NPC type IDs. Fill only
-- genuinely absent ranges from II; retain every supplied higher-rank appearance.
INSERT INTO merc_armorinfo(merc_npc_type_id,minlevel,maxlevel,texture,helmtexture,armortint_id,armortint_red,armortint_green,armortint_blue)
SELECT m.target_npc_id,s.minlevel,s.maxlevel,s.texture,s.helmtexture,s.armortint_id,s.armortint_red,s.armortint_green,s.armortint_blue
FROM merc_armorinfo s JOIN _merc_rank_map m ON m.source_npc_id=s.merc_npc_type_id
WHERE NOT EXISTS(SELECT 1 FROM merc_armorinfo d WHERE d.merc_npc_type_id=m.target_npc_id AND d.minlevel=s.minlevel AND d.maxlevel=s.maxlevel);
INSERT INTO merc_weaponinfo(merc_npc_type_id,minlevel,maxlevel,d_melee_texture1,d_melee_texture2,prim_melee_type,sec_melee_type)
SELECT m.target_npc_id,s.minlevel,s.maxlevel,s.d_melee_texture1,s.d_melee_texture2,s.prim_melee_type,s.sec_melee_type
FROM merc_weaponinfo s JOIN _merc_rank_map m ON m.source_npc_id=s.merc_npc_type_id
WHERE NOT EXISTS(SELECT 1 FROM merc_weaponinfo d WHERE d.merc_npc_type_id=m.target_npc_id AND d.minlevel=s.minlevel AND d.maxlevel=s.maxlevel);

INSERT INTO merc_templates(merc_type_id,merc_subtype_id,merc_npc_type_id,dbstring,name_type_id,clientversion)
SELECT DISTINCT a.merc_type_id,b.merc_subtype_id,m.target_npc_id,
 CONCAT(LEFT(a.dbstring,LENGTH(a.dbstring)-1),m.tier_id),a.name_type_id,a.clientversion
FROM merc_templates a JOIN merc_types y ON y.merc_type_id=a.merc_type_id
JOIN merc_subtypes sa ON sa.merc_subtype_id=a.merc_subtype_id
JOIN _merc_rank_map m ON m.source_npc_id=a.merc_npc_type_id
JOIN merc_subtypes b ON b.class_id=m.class_id AND b.tier_id=m.tier_id
WHERE y.proficiency_id=2 AND sa.class_id=m.class_id AND sa.tier_id=2
 AND NOT EXISTS(SELECT 1 FROM merc_templates d WHERE d.merc_type_id=a.merc_type_id AND d.merc_subtype_id=b.merc_subtype_id);

-- Only extend a catalogue which already sells II of the same race and role.
-- Specialist/event/claim liaisons and their original availability are preserved.
INSERT INTO merc_merchant_template_entries(merc_merchant_template_id,merc_template_id)
SELECT DISTINCT e.merc_merchant_template_id,b.merc_template_id
FROM merc_merchant_template_entries e JOIN merc_templates a ON a.merc_template_id=e.merc_template_id
JOIN merc_types y ON y.merc_type_id=a.merc_type_id
JOIN merc_subtypes sa ON sa.merc_subtype_id=a.merc_subtype_id
JOIN _merc_rank_map m ON m.source_npc_id=a.merc_npc_type_id
JOIN merc_subtypes sb ON sb.class_id=m.class_id AND sb.tier_id=m.tier_id
JOIN merc_templates b ON b.merc_type_id=a.merc_type_id AND b.merc_subtype_id=sb.merc_subtype_id AND b.merc_npc_type_id=m.target_npc_id
WHERE y.proficiency_id=2 AND sa.class_id=m.class_id AND sa.tier_id=2
 AND NOT EXISTS(SELECT 1 FROM merc_merchant_template_entries d WHERE d.merc_merchant_template_id=e.merc_merchant_template_id AND d.merc_template_id=b.merc_template_id);

-- A generated row must be loadable through the real armor/weapon joins.
INSERT INTO _merc_rank_assert SELECT IF(COUNT(*)=0,1,0)
FROM _merc_rank_map m JOIN merc_stats s ON s.merc_npc_type_id=m.source_npc_id
WHERE NOT EXISTS(SELECT 1 FROM merc_stats d
 JOIN merc_armorinfo a ON a.merc_npc_type_id=d.merc_npc_type_id AND a.minlevel<=d.level AND a.maxlevel>=d.level
 JOIN merc_weaponinfo w ON w.merc_npc_type_id=d.merc_npc_type_id AND w.minlevel<=d.level AND w.maxlevel>=d.level
 WHERE d.merc_npc_type_id=m.target_npc_id AND d.clientlevel=s.clientlevel);
COMMIT;
DROP TEMPORARY TABLE _merc_rank_map;
DROP TEMPORARY TABLE _merc_rank_assert;
