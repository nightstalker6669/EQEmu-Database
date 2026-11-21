-- Additive schema for earned state and progression settings. DDL commits independently.
CREATE TABLE `dodh_longshadow_item_sources` (
  `item_guid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `character_id` int(10) unsigned NOT NULL,
  `shared_task_id` bigint(20) unsigned NOT NULL,
  `accepted_time` int(10) unsigned NOT NULL,
  `task_id` int(10) unsigned NOT NULL,
  `instance_id` int(10) unsigned NOT NULL,
  `item_id` int(10) unsigned NOT NULL,
  `source_kind` enum('dustspirit_note','shadowspin_corpse','poisonmaster_corpse','ryianna_orb','traitor_chest','bellfast_mines_memory','bellfast_clicktok_gem','bellfast_therimel_gem','bellfast_zlixtil_gem','bellfast_bilitan_gem','bellfast_alpha_larva_meat') NOT NULL,
  `inventory_guid` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`item_guid`),
  UNIQUE KEY `one_original_source` (`shared_task_id`,`source_kind`),
  KEY `sources_by_occurrence` (`shared_task_id`,`source_kind`),
  CONSTRAINT `longshadow_inventory_guid_valid` CHECK (`inventory_guid` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `dodh_longshadow_turnins` (
  `shared_task_id` bigint(20) unsigned NOT NULL,
  `task_id` int(10) unsigned NOT NULL,
  `activity_id` int(10) unsigned NOT NULL,
  `character_id` int(10) unsigned NOT NULL,
  `item_guid` int(10) unsigned NOT NULL,
  `request_key` char(32) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `effect_applied` tinyint(3) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`shared_task_id`,`activity_id`),
  UNIQUE KEY `one_settlement_per_item` (`item_guid`),
  UNIQUE KEY `one_settlement_per_request` (`request_key`),
  CONSTRAINT `dodh_longshadow_turnins_ibfk_1` FOREIGN KEY (`item_guid`) REFERENCES `dodh_longshadow_item_sources` (`item_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `dodh_longshadow_scene_effects` (
  `request_key` char(32) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `shared_task_id` bigint(20) unsigned NOT NULL,
  `task_id` int(10) unsigned NOT NULL,
  `activity_id` int(10) unsigned NOT NULL,
  `source_item_guid` int(10) unsigned NOT NULL,
  `character_id` int(10) unsigned NOT NULL,
  `instance_id` int(10) unsigned NOT NULL,
  `actor_type` int(10) unsigned NOT NULL,
  `materialized` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `terminal` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `prepared_item_id` int(10) unsigned DEFAULT NULL,
  `death_character_id` int(10) unsigned DEFAULT NULL,
  `death_x` float DEFAULT NULL,
  `death_y` float DEFAULT NULL,
  `death_z` float DEFAULT NULL,
  `death_heading` float DEFAULT NULL,
  `loot_item_id` int(10) unsigned DEFAULT NULL,
  `loot_character_id` int(10) unsigned DEFAULT NULL,
  `loot_item_guid` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`request_key`),
  UNIQUE KEY `one_run_effect` (`shared_task_id`,`activity_id`),
  UNIQUE KEY `dodh_scene_run_loot_guid` (`shared_task_id`,`loot_character_id`,`loot_item_guid`),
  KEY `dodh_scene_exact_source` (`source_item_guid`),
  CONSTRAINT `dodh_scene_exact_source` FOREIGN KEY (`source_item_guid`) REFERENCES `dodh_longshadow_item_sources` (`item_guid`),
  CONSTRAINT `dodh_scene_exact_turnin` FOREIGN KEY (`request_key`) REFERENCES `dodh_longshadow_turnins` (`request_key`),
  CONSTRAINT `dodh_scene_valid_state` CHECK (`materialized` in (0,1) and `terminal` in (0,1) and `terminal` <= `materialized`),
  CONSTRAINT `dodh_scene_prepared_loot` CHECK (`prepared_item_id` is null and `materialized` = 0 or `prepared_item_id` is not null and (`actor_type` = 354920 and `prepared_item_id` = 54607 or `actor_type` = 363035 and `prepared_item_id` in (86568,86569,86570,86571,86572))),
  CONSTRAINT `dodh_scene_death_shape` CHECK (`death_character_id` is null and `death_x` is null and `death_y` is null and `death_z` is null and `death_heading` is null and `loot_item_id` is null and `terminal` = 0 or `materialized` = 1 and `death_character_id` is not null and `death_character_id` > 0 and `death_x` is not null and `death_y` is not null and `death_z` is not null and `death_heading` is not null and `loot_item_id` is not null and `loot_item_id` = `prepared_item_id` and (`actor_type` = 354920 and `loot_item_id` = 54607 or `actor_type` = 363035 and `loot_item_id` in (86568,86569,86570,86571,86572))),
  CONSTRAINT `dodh_scene_loot_shape` CHECK (`terminal` = 0 and `loot_character_id` is null and `loot_item_guid` is null or `terminal` = 1 and `death_character_id` is not null and `loot_character_id` is not null and `loot_character_id` > 0 and `loot_item_guid` is not null and `loot_item_guid` between 1 and 2147483647)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `dodh_bellfast_hive_chests` (
  `shared_task_id` bigint(20) unsigned NOT NULL,
  `accepted_time` int(10) unsigned NOT NULL,
  `instance_id` int(10) unsigned NOT NULL,
  `killed_by` int(10) unsigned NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `heading` float NOT NULL,
  `opened_by` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`shared_task_id`),
  CONSTRAINT `dodh_bellfast_hive_chest_identity` CHECK (`shared_task_id` > 0 and `accepted_time` > 0 and `instance_id` > 0 and `killed_by` > 0 and (`opened_by` is null or `opened_by` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `dodh_bellfast_korlach_kills` (
  `shared_task_id` bigint(20) unsigned NOT NULL,
  `accepted_time` int(10) unsigned NOT NULL,
  `instance_id` int(10) unsigned NOT NULL,
  `spawn_id` int(10) unsigned NOT NULL,
  `npc_type_id` int(10) unsigned NOT NULL,
  `killed_by` int(10) unsigned NOT NULL,
  PRIMARY KEY (`shared_task_id`,`spawn_id`),
  CONSTRAINT `dodh_bellfast_korlach_kill_identity` CHECK (`shared_task_id` > 0 and `accepted_time` > 0 and `instance_id` > 0 and `spawn_id` > 0 and `killed_by` > 0 and `npc_type_id` between 349033 and 349043)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `dodh_bellfast_korlach_settings` (
  `task_id` int(10) unsigned NOT NULL,
  `required_kills` int(10) unsigned NOT NULL,
  PRIMARY KEY (`task_id`),
  CONSTRAINT `dodh_bellfast_korlach_settings_exact` CHECK (`task_id` = 920273 and `required_kills` between 1 and 55)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `dodh_bellfast_neran_crossings` (
  `shared_task_id` bigint(20) unsigned NOT NULL,
  `accepted_time` int(10) unsigned NOT NULL,
  `instance_id` int(10) unsigned NOT NULL,
  `character_id` int(10) unsigned NOT NULL,
  `caster_entity_id` smallint(5) unsigned NOT NULL,
  `spell_id` int(10) unsigned NOT NULL,
  `from_x` float NOT NULL,
  `from_y` float NOT NULL,
  `from_z` float NOT NULL,
  `to_x` float NOT NULL,
  `to_y` float NOT NULL,
  `to_z` float NOT NULL,
  PRIMARY KEY (`shared_task_id`,`character_id`),
  CONSTRAINT `dodh_bellfast_neran_crossing_exact` CHECK (`accepted_time` > 0 and `instance_id` > 0 and `character_id` > 0 and `caster_entity_id` > 0 and `spell_id` = 8403 and `to_y` < `from_y`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `dodh_bellfast_neran_runs` (
  `shared_task_id` bigint(20) unsigned NOT NULL,
  `accepted_time` int(10) unsigned NOT NULL,
  `instance_id` int(10) unsigned NOT NULL,
  `opened_by` int(10) unsigned NOT NULL,
  `phase` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`shared_task_id`),
  CONSTRAINT `dodh_bellfast_neran_run_exact` CHECK (`shared_task_id` > 0 and `accepted_time` > 0 and `instance_id` > 0 and `opened_by` > 0 and `phase` in (0,1,2))
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `dodh_longshadow_note_events` (
  `shared_task_id` bigint(20) unsigned NOT NULL,
  `character_id` int(10) unsigned NOT NULL,
  `accepted_time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`shared_task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `dodh_longshadow_orb_deaths` (
  `shared_task_id` bigint(20) unsigned NOT NULL,
  `actor_type` int(10) unsigned NOT NULL,
  `spawn_id` int(10) unsigned NOT NULL,
  `character_id` int(10) unsigned NOT NULL,
  `accepted_time` int(10) unsigned NOT NULL,
  `instance_id` int(10) unsigned NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `heading` float NOT NULL,
  PRIMARY KEY (`shared_task_id`),
  CONSTRAINT `dodh_orb_death_source` CHECK (`actor_type` = 354311 and `spawn_id` = 262895),
  CONSTRAINT `dodh_orb_death_scope` CHECK (`shared_task_id` > 0 and `character_id` > 0 and `accepted_time` > 0 and `instance_id` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `dodh_longshadow_scene_fixtures` (
  `actor_type` int(10) unsigned NOT NULL,
  `zone_id` smallint(5) unsigned NOT NULL,
  `zone_version` tinyint(3) unsigned NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `heading` float NOT NULL,
  `loottable_id` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`actor_type`),
  CONSTRAINT `dodh_scene_fixture_route` CHECK (`actor_type` = 354920 and `zone_id` = 354 and `zone_version` = 1 and `loottable_id` = 0 or `actor_type` = 363035 and `zone_id` = 363 and `zone_version` = 1 and `loottable_id` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `dodh_longshadow_tail_tuning` (
  `id` int(10) unsigned NOT NULL,
  `near_radius` float NOT NULL,
  `far_radius` float NOT NULL,
  `lost_seconds` int(10) unsigned NOT NULL,
  `spotted_seconds` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `CONSTRAINT_1` CHECK (`id` = 1 and `near_radius` > 0 and `far_radius` > `near_radius` and `lost_seconds` > 0 and `spotted_seconds` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `dodh_longshadow_tail_wave_types` (
  `stop` int(10) unsigned NOT NULL,
  `ordinal` int(10) unsigned NOT NULL,
  `npc_type_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`stop`,`ordinal`),
  CONSTRAINT `CONSTRAINT_1` CHECK (`stop` between 1 and 7 and `ordinal` between 1 and 4 and `npc_type_id` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `dodh_longshadow_traitor_chests` (
  `shared_task_id` bigint(20) unsigned NOT NULL,
  `accepted_time` int(10) unsigned NOT NULL,
  `instance_id` int(10) unsigned NOT NULL,
  `chamber` int(10) unsigned NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `heading` float NOT NULL,
  `opened_by` int(10) unsigned DEFAULT NULL,
  `first_boss_chamber` int(10) unsigned NOT NULL,
  PRIMARY KEY (`shared_task_id`),
  CONSTRAINT `CONSTRAINT_1` CHECK (`first_boss_chamber` between 1 and 3),
  CONSTRAINT `CONSTRAINT_2` CHECK (`shared_task_id` > 0 and `accepted_time` > 0 and `instance_id` > 0 and `chamber` between 1 and 3),
  CONSTRAINT `CONSTRAINT_3` CHECK (`opened_by` is null or `opened_by` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `dodh_longshadow_traitor_rooms` (
  `chamber` int(10) unsigned NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `heading` float NOT NULL,
  `boss_x` float NOT NULL,
  `boss_y` float NOT NULL,
  `boss_z` float NOT NULL,
  `boss_heading` float NOT NULL,
  PRIMARY KEY (`chamber`),
  CONSTRAINT `CONSTRAINT_1` CHECK (`chamber` between 1 and 3)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `dodh_longshadow_travel_events` (
  `shared_task_id` bigint(20) unsigned NOT NULL,
  `task_id` int(10) unsigned NOT NULL,
  `activity_id` int(10) unsigned NOT NULL,
  `character_id` int(10) unsigned NOT NULL,
  `accepted_time` int(10) unsigned NOT NULL,
  `instance_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`shared_task_id`,`activity_id`,`character_id`),
  CONSTRAINT `dodh_longshadow_travel_positive_scope` CHECK (`shared_task_id` > 0 and `character_id` > 0 and `accepted_time` > 0 and `instance_id` > 0),
  CONSTRAINT `dodh_longshadow_travel_exact_activity` CHECK (`task_id` in (920251,920252) and `activity_id` = 0 or `task_id` = 920253 and `activity_id` in (1,4) or `task_id` = 920254 and `activity_id` in (0,1,2) or `task_id` = 920255 and `activity_id` in (0,2,3) or `task_id` = 920270 and `activity_id` = 0 or `task_id` in (920271,920272) and `activity_id` in (0,1,2) or `task_id` = 920273 and `activity_id` in (0,1,2,3))
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `dodh_rakban_claims` (
  `character_id` int(10) unsigned NOT NULL,
  `route_id` tinyint(3) unsigned NOT NULL,
  `class_id` tinyint(3) unsigned NOT NULL,
  `item_id` int(10) unsigned NOT NULL,
  `spell_id` int(10) unsigned NOT NULL,
  `item_serial` int(11) NOT NULL,
  PRIMARY KEY (`character_id`,`route_id`),
  CONSTRAINT `dodh_rakban_claim_values` CHECK (`character_id` > 0 and `class_id` between 1 and 16 and `spell_id` = 0 and `item_serial` > 0 and (`route_id` between 1 and 5 and `item_id` = 85565 + `route_id` or `route_id` = 6 and `item_id` = 85575))
) ENGINE=InnoDB DEFAULT CHARSET=ascii COLLATE=ascii_general_ci;

CREATE TABLE `dodh_rakban_combines` (
  `character_id` int(10) unsigned NOT NULL,
  `recipe_id` int(10) unsigned NOT NULL,
  `shroud_serial` int(11) NOT NULL,
  `skull_serial` int(11) NOT NULL,
  PRIMARY KEY (`character_id`),
  CONSTRAINT `dodh_rakban_combine_values` CHECK (`character_id` > 0 and `recipe_id` > 0 and `shroud_serial` > 0 and `skull_serial` > 0 and `shroud_serial` <> `skull_serial`)
) ENGINE=InnoDB DEFAULT CHARSET=ascii COLLATE=ascii_general_ci;
