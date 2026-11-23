-- Reserved with the Vergalid batch. No changes to the existing raid tasks.
START TRANSACTION;

INSERT INTO tasks
    (id, type, title, description, duration, min_level, max_level, min_players, max_players,
     repeatable, dz_template_id, lock_activity_id, replay_timer_seconds, faction_reward, faction_amount, exp_reward)
VALUES
    (920362, 2, 'The Pretender', 'Find Nurtha in the Vergalid raid and return to Zhubis after defeating her.',
     0, 75, 0, 1, 1, 0, 0, -1, 0, 1135, 250, 1000),
    (920363, 2, 'Severing the Strings', 'Defeat Goru, the shrine protectors, and Vergalid in the raid instance.',
     0, 75, 0, 1, 1, 0, 0, -1, 0, 1134, 250, 1000);

-- Each objective is advanced by the exact public quest giver or the exact
-- owned Vergalid's End occurrence, rather than public zone kills or skips.
INSERT INTO task_activities
    (taskid, activityid, req_activity_id, step, activitytype, goalmethod, goalcount,
     description_override, npc_match_list, zones, zone_version)
VALUES
    (920362, 0, -1, 0, 5, 2, 1, 'Enter the Vergalid Mines', NULL, '404', 21),
    (920362, 1, 0, 1, 4, 2, 1, 'Speak to Nurtha Frazzlesprocket', '404942', '404', 21),
    (920362, 2, 1, 2, 2, 2, 1, 'Defeat Nurtha Frazzlesprocket', '404942', '404', 21),
    (920362, 3, 2, 3, 4, 2, 1, 'Return to Zhubis', '405092', '405', 0),
    (920363, 0, -1, 0, 5, 2, 1, 'Enter the Vergalid Mines', NULL, '404', 21),
    (920363, 1, 0, 1, 2, 2, 1, 'Defeat Goru Uldrock, the Reincarnate', '404950', '404', 21),
    (920363, 2, 1, 2, 2, 2, 1, 'Defeat the six shrine protectors', '404958', '404', 21),
    (920363, 3, 2, 3, 2, 2, 1, 'Destroy Vergalid', '404959', '404', 21);

COMMIT;
