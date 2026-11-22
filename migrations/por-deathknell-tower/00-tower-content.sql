-- Deathknell four-event catalog. Apply only to the pinned r32 schema and data.
-- The ordered gear rolls are native. The earned event script adds one Harp to
-- each chest while binding the corresponding expedition loot lockout.
DELIMITER //
BEGIN NOT ATOMIC
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    START TRANSACTION;

    IF (SELECT COUNT(*) FROM zone WHERE id=6310 AND zoneidnumber=381 AND version=20 AND short_name='theatera') <> 1 OR (SELECT COUNT(*) FROM dynamic_zone_templates WHERE id=920343 AND zone_id=381 AND zone_version=20 AND name='Deathknell') <> 1 OR (SELECT COUNT(*) FROM doors WHERE zone='theatera' AND version=20 AND id BETWEEN 304086537 AND 304086541) <> 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Deathknell r32 instance preimage mismatch';
    END IF;

    IF EXISTS(SELECT 1 FROM npc_types WHERE id BETWEEN 381946 AND 381981) OR EXISTS(SELECT 1 FROM spawn2 WHERE id BETWEEN 304088000 AND 304088031 OR (zone='theatera' AND version=20)) OR EXISTS(SELECT 1 FROM spawngroup WHERE id BETWEEN 304088032 AND 304088063) OR EXISTS(SELECT 1 FROM spawnentry WHERE spawngroupID BETWEEN 304088032 AND 304088063) OR EXISTS(SELECT 1 FROM loottable WHERE id BETWEEN 304088064 AND 304088067) OR EXISTS(SELECT 1 FROM loottable_entries WHERE loottable_id BETWEEN 304088064 AND 304088067 OR lootdrop_id BETWEEN 304088068 AND 304088071) OR EXISTS(SELECT 1 FROM lootdrop WHERE id BETWEEN 304088068 AND 304088071) OR EXISTS(SELECT 1 FROM lootdrop_entries WHERE lootdrop_id BETWEEN 304088068 AND 304088071) OR EXISTS(SELECT 1 FROM traps WHERE id BETWEEN 304088072 AND 304088095 OR (zone='theatera' AND version=20)) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Deathknell reserved content collision';
    END IF;

    IF (SELECT COUNT(*) FROM items WHERE id BETWEEN 39335 AND 39376) <> 42 OR (SELECT COUNT(*) FROM items WHERE id=52601 AND clickeffect=8577) <> 1 OR (SELECT COUNT(*) FROM items WHERE id=52602) <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Deathknell item preimage mismatch';
    END IF;

    INSERT INTO loottable (id, name) VALUES
    (304088064, 'Deathknell event 1 rewards'),
    (304088065, 'Deathknell event 2 rewards'),
    (304088066, 'Deathknell event 3 rewards'),
    (304088067, 'Deathknell event 4 rewards');

    INSERT INTO lootdrop (id, name) VALUES
    (304088068, 'Deathknell event 1 gear'),
    (304088069, 'Deathknell event 2 gear'),
    (304088070, 'Deathknell event 3 gear'),
    (304088071, 'Deathknell event 4 gear');

    INSERT INTO loottable_entries (loottable_id, lootdrop_id, multiplier, droplimit, mindrop, probability) VALUES
    (304088064, 304088068, 1, 3, 3, 100),
    (304088065, 304088069, 1, 3, 3, 100),
    (304088066, 304088070, 1, 3, 3, 100),
    (304088067, 304088071, 1, 3, 3, 100);

    INSERT INTO lootdrop_entries (lootdrop_id, item_id, item_charges, equip_item, chance, multiplier) VALUES
    (304088068, 39335, 1, 0, 100, 1),
    (304088068, 39336, 1, 0, 100, 1),
    (304088068, 39337, 1, 0, 100, 1),
    (304088068, 39338, 1, 0, 100, 1),
    (304088068, 39339, 1, 0, 100, 1),
    (304088068, 39340, 1, 0, 100, 1),
    (304088068, 39341, 1, 0, 100, 1),
    (304088068, 39342, 1, 0, 100, 1),
    (304088068, 39343, 1, 0, 100, 1),
    (304088068, 39344, 1, 0, 100, 1),
    (304088069, 39345, 1, 0, 100, 1),
    (304088069, 39346, 1, 0, 100, 1),
    (304088069, 39347, 1, 0, 100, 1),
    (304088069, 39348, 1, 0, 100, 1),
    (304088069, 39349, 1, 0, 100, 1),
    (304088069, 39350, 1, 0, 100, 1),
    (304088069, 39351, 1, 0, 100, 1),
    (304088069, 39352, 1, 0, 100, 1),
    (304088069, 39353, 1, 0, 100, 1),
    (304088069, 39354, 1, 0, 100, 1),
    (304088070, 39355, 1, 0, 100, 1),
    (304088070, 39356, 1, 0, 100, 1),
    (304088070, 39357, 1, 0, 100, 1),
    (304088070, 39358, 1, 0, 100, 1),
    (304088070, 39359, 1, 0, 100, 1),
    (304088070, 39360, 1, 0, 100, 1),
    (304088070, 39361, 1, 0, 100, 1),
    (304088070, 39362, 1, 0, 100, 1),
    (304088070, 39363, 1, 0, 100, 1),
    (304088070, 39364, 1, 0, 100, 1),
    (304088071, 39365, 1, 0, 100, 1),
    (304088071, 39366, 1, 0, 100, 1),
    (304088071, 39367, 1, 0, 100, 1),
    (304088071, 39368, 1, 0, 100, 1),
    (304088071, 39369, 1, 0, 100, 1),
    (304088071, 39370, 1, 0, 100, 1),
    (304088071, 39371, 1, 0, 100, 1),
    (304088071, 39372, 1, 0, 100, 1),
    (304088071, 39373, 1, 0, 100, 1),
    (304088071, 39374, 1, 0, 100, 1),
    (304088071, 39375, 1, 0, 100, 1),
    (304088071, 39376, 1, 0, 100, 1);

    INSERT INTO npc_types
        (id,name,level,race,class,bodytype,hp,gender,texture,helmtexture,size,loottable_id,
         mindmg,maxdmg,special_abilities,aggroradius,assistradius,runspeed,AC,MR,CR,DR,FR,PR,
         version,attack_delay,raid_target,skip_global_loot,flymode)
    SELECT p.id,p.name,p.level,n.race,n.class,n.bodytype,p.hp,n.gender,n.texture,n.helmtexture,n.size,p.loot,
        p.mindmg,p.maxdmg,p.abilities,0,0,p.speed,GREATEST(n.AC,325),35,35,35,35,35,
        20,30,p.maxdmg>=3500,1,0
    FROM (

        SELECT 381946 AS id, 381010 AS donor, 'South_Deathknell_Watcher' AS name, 80 AS level, 550000 AS hp, 950 AS mindmg, 3900 AS maxdmg, 0 AS speed, '3,1^17,1^21,1' AS abilities, 0 AS loot

        UNION ALL SELECT 381947, 381012, 'West_Deathknell_Watcher', 80, 550000, 950, 3900, 0, '3,1^17,1^21,1', 0

        UNION ALL SELECT 381948, 381013, 'North_Deathknell_Watcher', 80, 550000, 950, 3900, 0, '3,1^17,1^21,1', 0

        UNION ALL SELECT 381949, 381014, 'East_Deathknell_Watcher', 80, 550000, 950, 3900, 0, '3,1^17,1^21,1', 0

        UNION ALL SELECT 381950, 381011, 'Deathknell_Enforcer', 80, 1400000, 1100, 4500, 1.25, '2,1^17,1^21,1', 0

        UNION ALL SELECT 381951, 380014, 'a_Truefaith_zealot', 73, 80000, 275, 1450, 1.25, '17,1', 0

        UNION ALL SELECT 381952, 380016, 'a_Truefaith_follower', 69, 68000, 200, 1200, 1.25, '', 0

        UNION ALL SELECT 381953, 380014, 'a_Truefaith_bat_keeper', 74, 100000, 0, 0, 0, '24,1^25,1^35,1', 0

        UNION ALL SELECT 381954, 351923, 'a_blooddrinker', 74, 45000, 220, 1200, 1.25, '', 0

        UNION ALL SELECT 381955, 380016, 'a_Truefaith_sneak', 74, 100000, 0, 0, 0, '24,1^25,1^35,1', 0

        UNION ALL SELECT 381956, 365036, 'a_focus_of_the_Collective', 75, 95000, 300, 1600, 1.25, '21,1', 0

        UNION ALL SELECT 381957, 361005, 'a_deep_orc_servant', 75, 120000, 370, 1950, 1.18, '16,1^17,1^21,1', 0

        UNION ALL SELECT 381958, 380014, 'Melkis', 80, 1700000, 850, 3500, 0.9, '2,1^14,1^17,1^21,1', 0

        UNION ALL SELECT 381959, 380016, 'Ashtar', 80, 1700000, 850, 3500, 0.9, '2,1^14,1^17,1^21,1', 0

        UNION ALL SELECT 381960, 380013, 'T`Pall', 80, 1700000, 850, 3500, 0.9, '2,1^14,1^17,1^21,1', 0

        UNION ALL SELECT 381961, 380014, 'a_Truefaith_minion', 74, 100000, 275, 1600, 1.25, '', 0

        UNION ALL SELECT 381962, 380016, 'a_Truefaith_soldier', 74, 100000, 275, 1600, 1.25, '', 0

        UNION ALL SELECT 381963, 380013, 'a_Truefaith_follower', 74, 100000, 275, 1600, 1.25, '', 0

        UNION ALL SELECT 381964, 380041, 'a_hallway_banshee', 75, 100000, 0, 0, 1.5, '24,1^25,1^35,1', 0

        UNION ALL SELECT 381965, 381015, 'Ayonae_Ro', 80, 4200000, 850, 3600, 0, '2,1^14,1^17,1^21,1', 0

        UNION ALL SELECT 381966, 380041, 'an_alto', 75, 112000, 350, 1750, 1.25, '21,1', 0

        UNION ALL SELECT 381967, 380042, 'a_bass', 75, 112000, 350, 1750, 1.25, '21,1', 0

        UNION ALL SELECT 381968, 380041, 'a_soprano', 75, 112000, 350, 1750, 1.25, '21,1', 0

        UNION ALL SELECT 381969, 380042, 'a_tenor', 75, 112000, 350, 1750, 1.25, '21,1', 0

        UNION ALL SELECT 381970, 381015, 'Ayonae_Ro', 80, 7200, 0, 0, 0, '24,1^25,1^35,1', 0

        UNION ALL SELECT 381971, 14017, 'a_member_of_the_Collective', 75, 95000, 300, 1600, 1.25, '21,1', 0

        UNION ALL SELECT 381972, 381016, 'a_dissonant_bell', 25, 875, 0, 0, 0, '24,1^25,1^35,1', 0

        UNION ALL SELECT 381978, 379014, 'a_mystical_chest', 70, 1, 0, 0, 0, '21,1^24,1^25,1', 304088064

        UNION ALL SELECT 381979, 379014, 'a_mystical_chest', 70, 1, 0, 0, 0, '21,1^24,1^25,1', 304088065

        UNION ALL SELECT 381980, 379014, 'a_mystical_chest', 70, 1, 0, 0, 0, '21,1^24,1^25,1', 304088066

        UNION ALL SELECT 381981, 379014, 'a_mystical_chest', 70, 1, 0, 0, 0, '21,1^24,1^25,1', 304088067

    ) p JOIN npc_types n ON n.id=p.donor;

    IF ROW_COUNT() <> 31 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Deathknell NPC donors incomplete';
    END IF;

    INSERT INTO spawngroup (id,name) VALUES
    (304088032, 'theatera_20_deathknell_304088000'),
    (304088033, 'theatera_20_deathknell_304088001'),
    (304088034, 'theatera_20_deathknell_304088002'),
    (304088035, 'theatera_20_humming_01'),
    (304088036, 'theatera_20_humming_02'),
    (304088037, 'theatera_20_humming_03'),
    (304088038, 'theatera_20_humming_04'),
    (304088039, 'theatera_20_humming_05'),
    (304088040, 'theatera_20_humming_06'),
    (304088041, 'theatera_20_humming_07'),
    (304088042, 'theatera_20_humming_08'),
    (304088043, 'theatera_20_humming_09'),
    (304088044, 'theatera_20_humming_10');

    INSERT INTO spawnentry (spawngroupID,npcID,chance) VALUES
    (304088032, 381970, 100),
    (304088033, 381970, 100),
    (304088034, 381972, 100),
    (304088035, 381000, 100),
    (304088036, 381001, 100),
    (304088037, 381002, 100),
    (304088038, 381003, 100),
    (304088039, 381004, 100),
    (304088040, 381005, 100),
    (304088041, 381006, 100),
    (304088042, 381007, 100),
    (304088043, 381008, 100),
    (304088044, 381009, 100);

    INSERT INTO spawn2 (id,spawngroupID,zone,version,x,y,z,heading,respawntime,pathgrid) VALUES
    (304088000, 304088032, 'theatera', 20, 31, 31, 4.125, 322, 300, 0),
    (304088001, 304088033, 'theatera', 20, -1.85, 138.93, -627, 0, 300, 0),
    (304088002, 304088034, 'theatera', 20, 0, 0, 43, 0, 300, 0);

    INSERT INTO spawn2 (id,spawngroupID,zone,version,x,y,z,heading,respawntime,variance,pathgrid,path_when_zone_idle,animation)
    SELECT 304088003+(id-135971), 304088035+(id-135971), zone, 20, x,y,z,heading,respawntime,variance,pathgrid,path_when_zone_idle,animation
    FROM spawn2 WHERE zone='theatera' AND version=0 AND id BETWEEN 135971 AND 135980;

    IF ROW_COUNT() <> 10 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Deathknell lower route donors incomplete';
    END IF;

    INSERT INTO traps (id,zone,version,x,y,z,chance,maxzdiff,radius,effect,effectvalue,
             message,skill,level,respawn_time,respawn_var,triggered_number,`group`,despawn_when_triggered)
    VALUES

    (304088072, 'theatera', 20, -137, -16, -250, 100, 12, 3.5, 0, 8579, 'A hidden floor spike lashes out.', 140, 75, 45, 8, 1, 0, 1),
    (304088073, 'theatera', 20, -137, -6, -250, 100, 12, 3.5, 0, 8579, 'A hidden floor spike lashes out.', 140, 75, 45, 8, 1, 0, 1),
    (304088074, 'theatera', 20, -137, 6, -250, 100, 12, 3.5, 0, 8579, 'A hidden floor spike lashes out.', 140, 75, 45, 8, 1, 0, 1),
    (304088075, 'theatera', 20, -137, 16, -250, 100, 12, 3.5, 0, 8579, 'A hidden floor spike lashes out.', 140, 75, 45, 8, 1, 0, 1),
    (304088076, 'theatera', 20, -127, -16, -250, 100, 12, 3.5, 0, 8579, 'A hidden floor spike lashes out.', 140, 75, 45, 8, 1, 0, 1),
    (304088077, 'theatera', 20, -127, -6, -250, 100, 12, 3.5, 0, 8579, 'A hidden floor spike lashes out.', 140, 75, 45, 8, 1, 0, 1),
    (304088078, 'theatera', 20, -127, 6, -250, 100, 12, 3.5, 0, 8579, 'A hidden floor spike lashes out.', 140, 75, 45, 8, 1, 0, 1),
    (304088079, 'theatera', 20, -127, 16, -250, 100, 12, 3.5, 0, 8579, 'A hidden floor spike lashes out.', 140, 75, 45, 8, 1, 0, 1),
    (304088080, 'theatera', 20, -117, -16, -250, 100, 12, 3.5, 0, 8579, 'A hidden floor spike lashes out.', 140, 75, 45, 8, 1, 0, 1),
    (304088081, 'theatera', 20, -117, -6, -250, 100, 12, 3.5, 0, 8579, 'A hidden floor spike lashes out.', 140, 75, 45, 8, 1, 0, 1),
    (304088082, 'theatera', 20, -117, 6, -250, 100, 12, 3.5, 0, 8579, 'A hidden floor spike lashes out.', 140, 75, 45, 8, 1, 0, 1),
    (304088083, 'theatera', 20, -117, 16, -250, 100, 12, 3.5, 0, 8579, 'A hidden floor spike lashes out.', 140, 75, 45, 8, 1, 0, 1),
    (304088084, 'theatera', 20, -107, -16, -250, 100, 12, 3.5, 0, 8579, 'A hidden floor spike lashes out.', 140, 75, 45, 8, 1, 0, 1),
    (304088085, 'theatera', 20, -107, -6, -250, 100, 12, 3.5, 0, 8579, 'A hidden floor spike lashes out.', 140, 75, 45, 8, 1, 0, 1),
    (304088086, 'theatera', 20, -107, 6, -250, 100, 12, 3.5, 0, 8579, 'A hidden floor spike lashes out.', 140, 75, 45, 8, 1, 0, 1),
    (304088087, 'theatera', 20, -107, 16, -250, 100, 12, 3.5, 0, 8579, 'A hidden floor spike lashes out.', 140, 75, 45, 8, 1, 0, 1),
    (304088088, 'theatera', 20, -97, -16, -250, 100, 12, 3.5, 0, 8579, 'A hidden floor spike lashes out.', 140, 75, 45, 8, 1, 0, 1),
    (304088089, 'theatera', 20, -97, -6, -250, 100, 12, 3.5, 0, 8579, 'A hidden floor spike lashes out.', 140, 75, 45, 8, 1, 0, 1),
    (304088090, 'theatera', 20, -97, 6, -250, 100, 12, 3.5, 0, 8579, 'A hidden floor spike lashes out.', 140, 75, 45, 8, 1, 0, 1),
    (304088091, 'theatera', 20, -97, 16, -250, 100, 12, 3.5, 0, 8579, 'A hidden floor spike lashes out.', 140, 75, 45, 8, 1, 0, 1),
    (304088092, 'theatera', 20, -87, -16, -250, 100, 12, 3.5, 0, 8579, 'A hidden floor spike lashes out.', 140, 75, 45, 8, 1, 0, 1),
    (304088093, 'theatera', 20, -87, -6, -250, 100, 12, 3.5, 0, 8579, 'A hidden floor spike lashes out.', 140, 75, 45, 8, 1, 0, 1),
    (304088094, 'theatera', 20, -87, 6, -250, 100, 12, 3.5, 0, 8579, 'A hidden floor spike lashes out.', 140, 75, 45, 8, 1, 0, 1),
    (304088095, 'theatera', 20, -87, 16, -250, 100, 12, 3.5, 0, 8579, 'A hidden floor spike lashes out.', 140, 75, 45, 8, 1, 0, 1);

    IF ROW_COUNT() <> 24 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Deathknell trap placement mismatch';
    END IF;

    COMMIT;
END//
DELIMITER ;
