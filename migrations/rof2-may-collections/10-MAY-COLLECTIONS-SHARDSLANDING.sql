-- Internal Shard's Landing member of the single May Collections batch.
-- Apply after the separately staged ground-pool schema, only with matched source.
-- Existing r39 Fear in Pieces and Alaran in Chains rows stay unchanged.
-- Fixed site membership, 300-second cadence and two level-95 XP amounts are reconstructions.
DELIMITER $$
BEGIN NOT ATOMIC
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    START TRANSACTION;
    IF (SELECT COUNT(*) FROM zone WHERE id=5893 AND zoneidnumber=752 AND version=0
        AND BINARY short_name='shardslanding' AND expansion=19) <> 1
       OR (SELECT COUNT(*) FROM ground_spawns WHERE zoneid=752 AND version IN(-1,0)) <> 45
       OR EXISTS (SELECT 1 FROM ground_spawns WHERE id BETWEEN 304098600 AND 304098623
                   OR item BETWEEN 77376 AND 77388 OR item BETWEEN 77415 AND 77423)
       OR EXISTS (SELECT 1 FROM object WHERE itemid BETWEEN 77376 AND 77388 OR itemid BETWEEN 77415 AND 77423)
       OR EXISTS (SELECT 1 FROM lootdrop_entries WHERE item_id BETWEEN 77376 AND 77388 OR item_id BETWEEN 77415 AND 77423)
       OR EXISTS (SELECT 1 FROM ground_spawn_collectibles
                  WHERE ground_spawn_id BETWEEN 304098600 AND 304098623
                     OR item_id BETWEEN 77376 AND 77388 OR item_id BETWEEN 77415 AND 77423) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Shard Collections zone or ground preimage mismatch';
    END IF;
    IF (SELECT COUNT(*) FROM achievements WHERE id IN(2000752,2020752,2080752)
        AND enabled=0 AND has_reward=1 AND points=10) <> 3
       OR (SELECT COUNT(*) FROM achievement_category_associations
           WHERE category_id=2009 AND achievement_id IN(2000752,2020752,2080752)) <> 3
       OR (SELECT COUNT(*) FROM achievements WHERE id IN(2040752,2060752) AND enabled=1) <> 2
       OR (SELECT COUNT(*) FROM achievement_components WHERE achievement_id IN(2000752,2020752,2080752)) <> 26
       OR (SELECT COUNT(*) FROM achievement_components c JOIN achievement_associations a ON a.component_id=c.component_id
           JOIN items i ON i.id=CASE c.achievement_id WHEN 2000752 THEN 77375+c.sequence
               WHEN 2020752 THEN 77414+c.sequence END
           WHERE c.achievement_id IN(2000752,2020752) AND c.component_type=1
             AND c.component_id=c.achievement_id+1000*(c.sequence-1) AND a.required_count=1
             AND ((c.achievement_id=2000752 AND c.sequence BETWEEN 1 AND 13)
               OR (c.achievement_id=2020752 AND c.sequence BETWEEN 1 AND 9))
             AND BINARY i.Name=BINARY c.name AND i.itemtype=11 AND i.itemclass=0
             AND i.stackable=1 AND i.stacksize=100 AND i.clickeffect=-1) <> 22
       OR (SELECT COUNT(*) FROM achievement_components WHERE achievement_id=2080752
           AND component_type=1 AND component_id=2080752+1000*(sequence-1)
           AND ((sequence=1 AND BINARY name='Tracker''s Guide to Shard''s Landing')
             OR (sequence=2 AND BINARY name='Signs of Madness')
             OR (sequence=3 AND BINARY name='Fear in Pieces')
             OR (sequence=4 AND BINARY name='Alaran in Chains'))) <> 4
       OR EXISTS (SELECT 1 FROM achievement_criteria
           WHERE id BETWEEN 304098500 AND 304098525 OR achievement_id IN(2000752,2020752,2080752)) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Shard Collections component preimage mismatch';
    END IF;
    IF (SELECT COUNT(*) FROM items WHERE id=133841 AND BINARY Name='Fragmented Crystal'
         AND itemclass=0 AND itemtype=10 AND slots=2048) <> 1
       OR EXISTS (SELECT 1 FROM rewards WHERE reward_id BETWEEN 304098550 AND 304098552)
       OR EXISTS (SELECT 1 FROM reward_sources WHERE source_type=1 AND source_id IN(2000752,2020752,2080752))
       OR EXISTS (SELECT 1 FROM reward_source_entries WHERE reward_id BETWEEN 304098550 AND 304098552
          OR (source_type=1 AND source_id IN(2000752,2020752,2080752)))
       OR EXISTS (SELECT 1 FROM reward_option_entries WHERE reward_id BETWEEN 304098550 AND 304098552) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Shard Collections reward preimage mismatch';
    END IF;

    UPDATE items SET itemtype=66 WHERE itemtype=11 AND (id BETWEEN 77376 AND 77388 OR id BETWEEN 77415 AND 77423);
    IF ROW_COUNT() <> 22 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Shard Collections item update mismatch';
    END IF;
    INSERT INTO achievement_criteria
        (id,achievement_id,component_type,component_sequence,component_id,event_type,progress_mode,
         behavior,target_id,target_id2,target_value,required_count,enabled)
    VALUES
        (304098500,2000752,1,1,2000752,14,2,0,77376,0,1,1,1),
        (304098501,2000752,1,2,2001752,14,2,0,77377,0,1,1,1),
        (304098502,2000752,1,3,2002752,14,2,0,77378,0,1,1,1),
        (304098503,2000752,1,4,2003752,14,2,0,77379,0,1,1,1),
        (304098504,2000752,1,5,2004752,14,2,0,77380,0,1,1,1),
        (304098505,2000752,1,6,2005752,14,2,0,77381,0,1,1,1),
        (304098506,2000752,1,7,2006752,14,2,0,77382,0,1,1,1),
        (304098507,2000752,1,8,2007752,14,2,0,77383,0,1,1,1),
        (304098508,2000752,1,9,2008752,14,2,0,77384,0,1,1,1),
        (304098509,2000752,1,10,2009752,14,2,0,77385,0,1,1,1),
        (304098510,2000752,1,11,2010752,14,2,0,77386,0,1,1,1),
        (304098511,2000752,1,12,2011752,14,2,0,77387,0,1,1,1),
        (304098512,2000752,1,13,2012752,14,2,0,77388,0,1,1,1),
        (304098513,2020752,1,1,2020752,14,2,0,77415,0,1,1,1),
        (304098514,2020752,1,2,2021752,14,2,0,77416,0,1,1,1),
        (304098515,2020752,1,3,2022752,14,2,0,77417,0,1,1,1),
        (304098516,2020752,1,4,2023752,14,2,0,77418,0,1,1,1),
        (304098517,2020752,1,5,2024752,14,2,0,77419,0,1,1,1),
        (304098518,2020752,1,6,2025752,14,2,0,77420,0,1,1,1),
        (304098519,2020752,1,7,2026752,14,2,0,77421,0,1,1,1),
        (304098520,2020752,1,8,2027752,14,2,0,77422,0,1,1,1),
        (304098521,2020752,1,9,2028752,14,2,0,77423,0,1,1,1),
        (304098522,2080752,1,1,2080752,11,3,0,2000752,0,0,1,1),
        (304098523,2080752,1,2,2081752,11,3,0,2020752,0,0,1,1),
        (304098524,2080752,1,3,2082752,11,3,0,2040752,0,0,1,1),
        (304098525,2080752,1,4,2083752,11,3,0,2060752,0,0,1,1);

    INSERT INTO rewards (reward_id,reward_type,reward_data_id,amount,description,enabled) VALUES
       (304098550,1,1,16610406,'Tracker''s Guide to Shard''s Landing experience',1),
       (304098551,1,1,16610406,'Signs of Madness experience',1),
       (304098552,0,133841,1,'At the Source reward',1);
    INSERT INTO reward_source_entries (source_type,source_id,sequence,reward_id) VALUES
       (1,2000752,0,304098550),(1,2020752,0,304098551),(1,2080752,0,304098552);

    INSERT INTO ground_spawns
        (id,zoneid,version,max_x,max_y,max_z,min_x,min_y,heading,name,item,max_allowed,comment,respawn_timer,fix_z)
    VALUES
        (304098600,752,0,1762.1902,1384.7378,28.299,1762.1902,1384.7378,0,'IT11503_ACTORDEF',77376,1,'May Collections set 2000752 marker 1',300,1),
        (304098601,752,0,1174.7299,281.9900,10.289,1174.7299,281.9900,0,'IT11503_ACTORDEF',77377,1,'May Collections set 2000752 marker 2',300,1),
        (304098602,752,0,931.5942,-283.1270,195.912,931.5942,-283.1270,0,'IT11503_ACTORDEF',77378,1,'May Collections set 2000752 marker 3',300,1),
        (304098603,752,0,794.5901,-1278.4928,9.551,794.5901,-1278.4928,0,'IT11503_ACTORDEF',77379,1,'May Collections set 2000752 marker 5',300,1),
        (304098604,752,0,824.6530,-1691.5850,4.796,824.6530,-1691.5850,0,'IT11503_ACTORDEF',77380,1,'May Collections set 2000752 marker 6',300,1),
        (304098605,752,0,786.4008,-1758.1198,0.100,786.4008,-1758.1198,0,'IT11503_ACTORDEF',77381,1,'May Collections set 2000752 marker 7',300,1),
        (304098606,752,0,593.4198,-1521.8346,-3.478,593.4198,-1521.8346,0,'IT11503_ACTORDEF',77382,1,'May Collections set 2000752 marker 8',300,1),
        (304098607,752,0,452.8722,-1831.1592,65.756,452.8722,-1831.1592,0,'IT11503_ACTORDEF',77383,1,'May Collections set 2000752 marker 9',300,1),
        (304098608,752,0,-327.1700,-565.4701,6.729,-327.1700,-565.4701,0,'IT11503_ACTORDEF',77384,1,'May Collections set 2000752 marker 10',300,1),
        (304098609,752,0,-473.2137,-582.4098,20.764,-473.2137,-582.4098,0,'IT11503_ACTORDEF',77385,1,'May Collections set 2000752 marker 11',300,1),
        (304098610,752,0,-673.0011,1268.4679,7.955,-673.0011,1268.4679,0,'IT11503_ACTORDEF',77386,1,'May Collections set 2000752 marker 24',300,1),
        (304098611,752,0,111.2716,-554.2321,17.026,111.2716,-554.2321,0,'IT11503_ACTORDEF',77387,1,'May Collections set 2000752 marker 34',300,1),
        (304098612,752,0,-97.0128,-571.8738,0.101,-97.0128,-571.8738,0,'IT11503_ACTORDEF',77388,1,'May Collections set 2000752 marker 35',300,1),
        (304098613,752,0,951.1818,574.1696,11.129,951.1818,574.1696,0,'IT11503_ACTORDEF',77376,1,'May Collections set 2000752 marker 36',300,1),
        (304098614,752,0,1187.4590,878.4018,55.003,1187.4590,878.4018,0,'IT11503_ACTORDEF',77377,1,'May Collections set 2000752 marker 37',300,1),
        (304098615,752,0,-2028.0182,365.6846,2.657,-2028.0182,365.6846,0,'IT11503_ACTORDEF',77415,1,'May Collections set 2020752 marker 12',300,1),
        (304098616,752,0,-1962.9489,56.7698,6.472,-1962.9489,56.7698,0,'IT11503_ACTORDEF',77416,1,'May Collections set 2020752 marker 14',300,1),
        (304098617,752,0,-1998.4009,84.6944,6.472,-1998.4009,84.6944,0,'IT11503_ACTORDEF',77417,1,'May Collections set 2020752 marker 15',300,1),
        (304098618,752,0,-1713.4369,-271.2090,16.848,-1713.4369,-271.2090,0,'IT11503_ACTORDEF',77418,1,'May Collections set 2020752 marker 16',300,1),
        (304098619,752,0,-1727.1149,-80.8855,5.878,-1727.1149,-80.8855,0,'IT11503_ACTORDEF',77419,1,'May Collections set 2020752 marker 17',300,1),
        (304098620,752,0,-1702.3650,190.3890,6.486,-1702.3650,190.3890,0,'IT11503_ACTORDEF',77420,1,'May Collections set 2020752 marker 18',300,1),
        (304098621,752,0,-1613.0315,-183.7503,11.619,-1613.0315,-183.7503,0,'IT11503_ACTORDEF',77421,1,'May Collections set 2020752 marker 21',300,1),
        (304098622,752,0,-1630.9915,131.9964,13.138,-1630.9915,131.9964,0,'IT11503_ACTORDEF',77422,1,'May Collections set 2020752 marker 23',300,1),
        (304098623,752,0,-1789.6227,614.6334,0.100,-1789.6227,614.6334,0,'IT11503_ACTORDEF',77423,1,'May Collections set 2020752 marker 41',300,1);

    INSERT INTO ground_spawn_collectibles (ground_spawn_id,item_id)
    SELECT g.id,c.target_id FROM ground_spawns g JOIN achievement_criteria c
      ON (g.id BETWEEN 304098600 AND 304098614 AND c.achievement_id=2000752)
      OR (g.id BETWEEN 304098615 AND 304098623 AND c.achievement_id=2020752)
    JOIN items i ON i.id=c.target_id AND i.itemtype=66
    WHERE c.event_type=14 AND c.enabled=1
      AND g.zoneid=752 AND g.version=0 AND g.max_allowed=1 AND g.min_x=g.max_x AND g.min_y=g.max_y
      AND EXISTS (SELECT 1 FROM achievement_criteria base
          WHERE base.achievement_id=c.achievement_id AND base.event_type=14 AND base.target_id=g.item);
    IF ROW_COUNT() <> 276 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Shard Collections per-site pool insertion mismatch';
    END IF;

    UPDATE achievements SET enabled=1 WHERE id IN(2000752,2020752,2080752) AND enabled=0;
    IF ROW_COUNT() <> 3 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Shard Collections activation mismatch';
    END IF;
    COMMIT;
END$$
DELIMITER ;
