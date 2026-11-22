START TRANSACTION;

INSERT INTO tasks (id,type,title,description,reward_text,reward_id_list,reward_method,repeatable) VALUES
(920344,0,'Entrance to Daosheen''s Chamber','Bring the three Relic dragon teeth and Porthio''s staff fragment to Apprentice Mage Sarcrynn. Then speak to Or''Sarro the Youngest.','Crystals of the Firstborn','84151',0,1),
(920345,0,'Legendary Berserker Bones','Bring Maelin the three distinct Legendary Berserker Bones while carrying your Enraged Flesh Charm.','','',0,0);

INSERT INTO task_activities (taskid,activityid,step,activitytype,goalmethod,goalcount,description_override,zones,zone_version) VALUES
(920344,0,0,0,2,1,'Give Sarcrynn Shar''Drahn''s tooth','369',0),
(920344,1,0,0,2,1,'Give Sarcrynn Tsikut''s tooth','369',0),
(920344,2,0,0,2,1,'Give Sarcrynn Ashenback''s tooth','369',0),
(920344,3,0,0,2,1,'Give Sarcrynn Porthio''s staff fragment','369',0),
(920344,4,1,0,2,1,'Hail Or''Sarro the Youngest','369',0),
(920345,0,0,0,2,1,'Give Maelin the bone from Titanothon','202',0),
(920345,1,0,0,2,1,'Give Maelin the bone from a Devastation commander','202',0),
(920345,2,0,0,2,1,'Give Maelin the bone from a Sverag boss','202',0);

COMMIT;
