START TRANSACTION;

INSERT INTO dynamic_zone_templates
    (id,zone_id,zone_version,name,min_players,max_players,duration_seconds,
     compass_zone_id,compass_x,compass_y,compass_z,return_zone_id,return_x,return_y,return_z,return_h,
     override_zone_in,zone_in_x,zone_in_y,zone_in_z,zone_in_h)
VALUES
    (920364,404,20,'Vergalid Mines: Into the Leviathan''s Lair',6,24,21600,403,-1498.55,1618.21,386.25,403,-1490,1610,385,0,1,14,0,3,0),
    (920365,404,21,'Vergalid Mines: Vergalid''s End',6,54,21600,403,590.418,1971.03,364.93,403,586.49,1970.38,365,0,1,14,0,3,0);

INSERT INTO tasks
    (id,type,title,description,duration,min_level,max_level,min_players,max_players,
     repeatable,dz_template_id,lock_activity_id,replay_timer_seconds,faction_reward,faction_amount,exp_reward)
VALUES
    (920360,1,'Vergalid Mines: Into the Leviathan''s Lair','Find Kellak in the flooded mines and defeat him.',21600,0,0,6,24,1,920364,-1,129600,0,0,0),
    (920361,1,'Vergalid Mines: Vergalid''s End','Defeat Nurtha and Goru, destroy the stone protectors, and slay Vergalid.',21600,0,0,6,54,1,920365,-1,0,0,0,0);

INSERT INTO shared_task_average_level_policies (task_id,minimum_average_level,enabled)
VALUES (920360,75,1), (920361,75,1);

-- Scripted activities require an actual actor or owned occurrence. Public kills
-- and the other Vergalid version cannot update any of these objectives.
INSERT INTO task_activities
    (taskid,activityid,req_activity_id,step,activitytype,goalmethod,goalcount,
     description_override,npc_match_list,zones,zone_version)
VALUES
    (920360,0,-1,0,5,2,1,'Enter the Vergalid Mines',NULL,'404',20),
    (920360,1,0,1,2,2,1,'Slay Kellak the Serpent Lord','404940','404',20),
    (920361,0,-1,0,5,2,1,'Enter the Vergalid Mines',NULL,'404',21),
    (920361,1,0,1,2,2,1,'Destroy Nurtha Frazzlesprocket','404942','404',21),
    (920361,2,1,2,2,2,1,'Banish Goru Uldrock, the Reincarnate','404950','404',21),
    (920361,3,2,3,2,2,1,'Power down the life force feeding Vergalid','404958','404',21),
    (920361,4,3,4,2,2,1,'Destroy Vergalid','404959','404',21);

COMMIT;
