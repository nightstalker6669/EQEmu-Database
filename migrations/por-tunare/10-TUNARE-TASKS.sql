START TRANSACTION;

INSERT INTO dynamic_zone_templates
    (id,zone_id,zone_version,name,min_players,max_players,duration_seconds,
     compass_zone_id,compass_x,compass_y,compass_z,return_zone_id,return_x,return_y,return_z,return_h,
     override_zone_in,zone_in_x,zone_in_y,zone_in_z,zone_in_h)
VALUES
    (920350,379,20,'Investigating the Elddar',3,6,21600,378,-297.642,-1462.02,-84.0911,378,-298.01,-1475.55,-96,256,1,0,0,-6,0),
    (920351,379,21,'Questioning the Priest',3,6,21480,378,-297.642,-1462.02,-84.0911,378,-298.01,-1475.55,-96,256,1,0,0,-6,0),
    (920352,379,22,'The Corruption of Ro',6,36,21600,378,-297.642,-1462.02,-84.0911,378,-298.01,-1475.55,-96,256,1,0,0,-6,0);

INSERT INTO tasks
    (id,type,title,description,duration,min_level,max_level,min_players,max_players,
     repeatable,dz_template_id,lock_activity_id,replay_timer_seconds)
VALUES
    (920346,1,'Investigating the Elddar','Shalowen the Pure asks you to observe the priests who withdrew into Tunare''s Shrine.',21600,65,0,3,6,1,920350,-1,0),
    (920347,1,'Questioning the Priest','Seek Elder Priest Nalderin in Tunare''s Shrine and ask who made the Figurine of Ro.',21480,70,0,3,6,1,920351,-1,0),
    (920348,1,'The Key to Corruption','Find the four pieces of scorned wood in Elddar Forest and ask Orgaf to craft a key.',21600,70,0,3,6,1,0,-1,0),
    (920349,1,'The Corruption of Ro','Gather a raid force, find Brazlin in Tunare''s Shrine, and stop the corruption.',21600,70,0,6,36,1,920352,0,331200);

-- Same-step kill and loot objectives can both advance as each priest falls.
INSERT INTO task_activities
    (taskid,activityid,req_activity_id,step,activitytype,goalmethod,goalcount,
     description_override,npc_match_list,item_id_list,zones,zone_version)
VALUES
    (920346,0,-1,1,5,2,1,'Investigate the upper levels of the tree',NULL,NULL,'379',20),
    (920346,1,0,2,3,0,1,'Search the chest for information about the corrupted elves',NULL,'85076','379',20),
    (920346,2,1,3,2,0,5,'Seek out the corrupted priests for answers','379951',NULL,'379',20),
    (920346,3,1,3,3,0,5,'Recover the missing pieces from the figurine',NULL,'85077','379',20),
    (920346,4,-1,4,6,0,1,'Place stones inside of the figurine',NULL,'85078','379',20),
    (920346,5,4,5,1,2,1,'Return the figurine to Shalowen the Pure','378059','85078','378',0),
    (920347,0,-1,1,5,2,1,'Search for Elder Priest Nalderin',NULL,NULL,'379',21),
    (920347,1,0,2,4,2,1,'Confront the elder priest for answers about the corrupted elves','379940',NULL,'379',21),
    (920347,2,1,3,3,0,1,'Recover the sealed scroll from Nalderin',NULL,'85080','379',21),
    (920347,3,2,4,1,2,1,'Return the sealed scroll to Shalowen','378059','85080','378',0),
    (920348,0,-1,1,5,2,1,'Search for Agrel the Scorned',NULL,NULL,'378',0),
    (920348,1,0,1,3,0,1,'Recover a magical piece of wood from Agrel',NULL,'85081','378',0),
    (920348,2,-1,1,5,2,1,'Search for Drekin the Scorned',NULL,NULL,'378',0),
    (920348,3,2,1,3,0,1,'Recover a magical piece of wood from Drekin',NULL,'85082','378',0),
    (920348,4,-1,1,5,2,1,'Search for Remlin the Scorned',NULL,NULL,'378',0),
    (920348,5,4,1,3,0,1,'Recover a magical piece of wood from Remlin',NULL,'85083','378',0),
    (920348,6,-1,1,5,2,1,'Search for Zorbig the Scorned',NULL,NULL,'378',0),
    (920348,7,6,1,3,0,1,'Recover a magical piece of wood from Zorbig',NULL,'85084','378',0),
    (920348,8,-1,2,5,2,1,'Find Orgaf the great orc crafter',NULL,NULL,'378',0),
    (920348,9,8,3,1,2,1,'Get Orgaf to craft the wooden key to unlock the shrine door','378168',NULL,'378',0),
    (920348,10,9,4,3,0,1,'Recover the shrine door key',NULL,'85079','378',0),
    (920349,0,-1,1,5,2,1,'Search for Brazlin in the shrine room',NULL,NULL,'379',22),
    (920349,1,0,2,4,2,1,'Confront the high priest for answers about the corrupted elves','379941',NULL,'379',22),
    (920349,2,1,3,2,2,1,'Slay the high priest to stop the corruption','379942',NULL,'379',22);

INSERT INTO tradeskill_recipe
    (id,name,tradeskill,skillneeded,trivial,nofail,replace_container,notes,quest,enabled)
VALUES
    (304090000,'Restore the Figurine of Ro',75,0,0,1,1,'Combine five Stones of Corruption in the Figurine of Ro.',0,1);

INSERT INTO tradeskill_recipe_entries
    (id,recipe_id,item_id,successcount,failcount,componentcount,salvagecount,iscontainer)
VALUES
    (304090001,304090000,85076,0,0,0,0,1),
    (304090002,304090000,85077,0,0,5,0,0),
    (304090003,304090000,85078,1,0,0,0,0);

INSERT INTO achievement_criteria
    (achievement_id,component_type,component_sequence,component_id,event_type,
     progress_mode,behavior,target_id,target_id2,target_value,required_count,enabled)
VALUES
    (500990210,1,1,59902100,0,3,0,0,0,1,1,1),
    (500990210,2,2,59902101,4,3,1,920346,0,1,1,1),
    (500990210,2,3,59902102,4,3,1,920347,0,1,1,1),
    (500990210,2,4,59902103,4,3,1,920348,0,1,1,1),
    (500990210,2,5,59902104,4,3,1,920349,0,1,1,1);

COMMIT;
