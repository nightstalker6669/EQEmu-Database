START TRANSACTION;

INSERT INTO tasks
    (id, type, title, description, min_level, max_level, min_players, max_players,
     repeatable, faction_reward, faction_amount, reward_id_list)
VALUES
    (920367, 2, 'Sabotage', 'Gather the three components and sabotage the East wing supplies.', 70, 0, 1, 1, 1, 1135, 175, ''),
    (920368, 2, 'Project Disarm', 'Deprive the Scarlet Legion of its weapons.', 75, 0, 1, 1, 1, 1135, 200, ''),
    (920369, 2, 'The Weakest Link', 'Destroy the griffon eggs and put down their wardens.', 75, 0, 1, 1, 1, 1135, 225, '53734'),
    (920370, 2, 'Children of Flame', 'Capture four young drakes from the West wing.', 75, 0, 1, 1, 1, 1134, 125, ''),
    (920371, 2, 'A Daring Rescue', 'Find Hidaga within the West wing and tell Jenray of the rescue.', 75, 0, 1, 1, 1, 1134, 175, ''),
    (920372, 2, 'Under Pressure', 'Bring Jenray a Lava Ooze Gland and a Solusek Diamond.', 75, 0, 1, 1, 1, 1134, 225, '53733'),
    (920373, 2, 'A Complex Diversion', 'Disrupt the Scarlet Legion and defeat Stitch in the East wing raid.', 75, 0, 1, 1, 0, 0, 0, ''),
    (920374, 2, 'Ghosts from the Past', 'Put Sothgar to rest in the West wing raid and return to Jenray.', 75, 0, 1, 1, 0, 0, 0, '');

INSERT INTO task_activities
    (taskid, activityid, req_activity_id, step, activitytype, goalmethod, goalcount,
     description_override, npc_match_list, item_id_list, zones, zone_version)
VALUES
    (920367, 0, -1, 0, 3, 0, 1, 'Loot Ashen Powder', NULL, '87195', '406', 0),
    (920367, 1, -1, 0, 3, 0, 1, 'Loot a Worker''s Pouch', NULL, '87196', '406', 0),
    (920367, 2, -1, 0, 3, 0, 1, 'Pick up the Magma Infused Crystal', NULL, '87197', '406', 0),
    (920367, 3, -1, 1, 6, 0, 1, 'Assemble the satchel of explosives', NULL, '87199', '406', 0),
    (920367, 4, 3, 2, 5, 2, 1, 'Sabotage the supply site', NULL, NULL, '406', 0),
    (920368, 0, -1, 0, 3, 0, 8, 'Recover Adamantium Drakkin Polearms', NULL, '87192', '406', 0),
    (920368, 1, -1, 0, 3, 0, 8, 'Recover Etched Drakkin Longswords', NULL, '87193', '406', 0),
    (920368, 2, -1, 0, 3, 0, 8, 'Recover Weighted Drakkin Whips', NULL, '87194', '406', 0),
    (920369, 0, -1, 0, 2, 0, 15, 'Slay Scarlet Legion eggtenders', '406113|406116|406118', NULL, '406', 0),
    (920369, 1, -1, 0, 2, 0, 5, 'Destroy the unhatched griffon eggs', '406117', NULL, '406', 0),
    (920369, 2, -1, 1, 4, 2, 1, 'Return to Zhubis', '405092', NULL, '405', 0),
    (920370, 0, -1, 0, 9, 2, 4, 'Hatch four drake eggs with the Ashen Incubator', '406013|406015|406034', NULL, '406', 0),
    (920370, 1, -1, 0, 9, 2, 4, 'Capture four baby drakes with the Ashen Incubator', NULL, '87187', '406', 0),
    (920370, 2, -1, 1, 1, 2, 4, 'Return the four captured drakes to Jenray', '405153', '87187', '405', 0),
    (920371, 0, -1, 0, 4, 2, 1, 'Hail the rescued Hidaga', NULL, NULL, '406', 0),
    (920371, 1, 0, 1, 4, 2, 1, 'Return to Jenray', '405153', NULL, '405', 0),
    (920372, 0, -1, 0, 13, 0, 1, 'Collect a Lava Ooze Gland', NULL, '52610', '405;406', 0),
    (920372, 1, -1, 0, 13, 0, 1, 'Collect a Solusek Diamond', NULL, '87188', '405;406', 0),
    (920372, 2, -1, 1, 1, 2, 1, 'Deliver the Lava Ooze Gland to Jenray', '405153', '52610', '405', 0),
    (920372, 3, -1, 1, 1, 2, 1, 'Deliver the Solusek Diamond to Jenray', '405153', '87188', '405', 0),
    (920373, 0, -1, 0, 5, 2, 1, 'Reach the Stone Span', NULL, NULL, '406', 20),
    (920373, 1, 0, 1, 5, 2, 1, 'Cross the pitfall ledge', NULL, NULL, '406', 20),
    (920373, 2, 1, 2, 5, 2, 1, 'Reach the Arch', NULL, NULL, '406', 20),
    (920373, 3, 2, 3, 2, 2, 10, 'Repel ten Scarlet Legion combatants', NULL, NULL, '406', 20),
    (920373, 4, 3, 4, 2, 2, 1, 'Defeat Stitch', NULL, NULL, '406', 20),
    (920374, 0, -1, 0, 2, 2, 1, 'Defeat Sothgar the Twiceborn', NULL, NULL, '406', 21),
    (920374, 1, 0, 1, 4, 2, 1, 'Return to Jenray', '405153', NULL, '405', 0);

COMMIT;
