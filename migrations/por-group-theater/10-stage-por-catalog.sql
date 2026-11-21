DELIMITER //
BEGIN NOT ATOMIC
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    ROLLBACK;
    RESIGNAL;
END;
START TRANSACTION;
IF (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema=DATABASE() AND engine='InnoDB' AND table_name IN
  ('tasks','task_activities','dynamic_zone_templates','zone','spawn2','spawnentry','spawngroup','doors','npc_types',
   'npc_faction','loottable','lootdrop','loottable_entries','lootdrop_entries','reward_sources','reward_sets',
   'reward_options','reward_option_entries','rewards','tradeskill_recipe','tradeskill_recipe_entries','merchantlist'))<>22 THEN
   SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='PoR catalog transaction requires the expected InnoDB tables';
END IF;
IF EXISTS (SELECT 1 FROM tasks WHERE id BETWEEN 920300 AND 920339)
   OR EXISTS (SELECT 1 FROM task_activities WHERE taskid BETWEEN 920300 AND 920339) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Reserved PoR task IDs are occupied';
END IF;
INSERT INTO tasks (id,type,title,description,duration,min_level,min_players,max_players,repeatable,dz_template_id,enabled,replay_timer_seconds) VALUES
    (920300, 1, 'Skylance: The Library', 'Find the Codex Artifice for Ao.', 21600, 70, 3, 6, 1, 920300, 0, 0),
    (920301, 1, 'Skylance: The Oubliette', 'Recover the prototype egg for Ao.', 21600, 70, 3, 6, 1, 920301, 0, 0),
    (920302, 1, 'Skylance: The Laboratory', 'Hatch the prototype egg and confront Tallongast.', 21600, 70, 3, 6, 1, 920302, 0, 2700),
    (920303, 2, 'Saga Skins', 'Collect the nine skins and bind their translations.', 0, 1, 1, 1, 0, 0, 0, 0),
    (920304, 2, 'Preparing Your New Skins', 'Bring Maelin his materials and have him fashion armor.', 0, 1, 1, 1, 0, 0, 0, 0),
    (920305, 1, 'Become the Vessel', 'Wear the Enraged Flesh armor and prove your rage in Sverag.', 21600, 1, 3, 6, 1, 0, 0, 0),
    (920306, 1, 'Samples of Corruption', 'Seal ten blood samples from Razorthorn and return them to Oathmir.', 21600, 1, 3, 6, 1, 920306, 0, 0),
    (920307, 1, 'The Key to the Past', 'Find Krylin and recover the five sandstone tablet pieces.', 21600, 70, 3, 6, 1, 920307, 0, 0),
    (920308, 1, 'The Burning Prince', 'Aid the Queen and confront Prince Tak’Salir.', 21600, 70, 3, 6, 1, 920308, 0, 0),
    (920309, 1, 'Message to the Past', 'Recover the Queen’s regalia and deliver it to her younger self.', 21600, 70, 3, 6, 1, 920309, 0, 0),
    (920310, 2, 'The Chalice of Life', 'Return the four lifestones to Lilthill’yan’s Ghost.', 0, 55, 1, 1, 1, 0, 0, 0),
    (920326, 2, 'Bring Me the Head of a Giant!', 'Support the defenders of Sverag by bringing their enemy trophies.', 0, 65, 1, 1, 1, 0, 0, 0),
    (920327, 2, 'Bring Me Their Skulls!', 'Support the defenders of Sverag by bringing their enemy trophies.', 0, 70, 1, 1, 1, 0, 0, 0),
    (920328, 2, 'Paws for Effect!', 'Support the defenders of Sverag by bringing their enemy trophies.', 0, 65, 1, 1, 1, 0, 0, 0),
    (920329, 2, 'Bring Me Their Heads!', 'Support the defenders of Sverag by bringing their enemy trophies.', 0, 65, 1, 1, 1, 0, 0, 0),
    (920330, 2, 'Eye Want Them Dead!', 'Support the defenders of Sverag by bringing their enemy trophies.', 0, 65, 1, 1, 1, 0, 0, 0),
    (920331, 2, 'Bring Me Their Paws!', 'Support the defenders of Sverag by bringing their enemy trophies.', 0, 65, 1, 1, 1, 0, 0, 0),
    (920332, 2, 'Drachnid Heads', 'Support the defenders of Sverag by bringing their enemy trophies.', 0, 65, 1, 1, 1, 0, 0, 0),
    (920333, 2, 'Take Their Tentacles!', 'Support the defenders of Sverag by bringing their enemy trophies.', 0, 65, 1, 1, 1, 0, 0, 0),
    (920334, 2, 'Axe Them No Questions!', 'Support the defenders of Sverag by bringing their enemy trophies.', 0, 65, 1, 1, 1, 0, 0, 0),
    (920335, 2, 'Saga Skin Translations', 'Deliver both translation volumes to Maelin.', 0, 1, 1, 1, 0, 0, 0, 0),
    (920336, 2, 'Ao’s Chime', 'Allow Ao to clean the Tarnished Chime.', 0, 1, 1, 1, 0, 0, 0, 0),
    (920337, 2, 'The Theater of Blood', 'Present the enchanted chime to Arch Mage Galsin.', 0, 70, 1, 1, 0, 0, 0, 0);

INSERT INTO task_activities (taskid,activityid,step,activitytype,goalmethod,goalcount,description_override,npc_match_list,item_id_list,zones,zone_version) VALUES
    (920300, 0, 0, 11, 2, 1, 'Enter Skylance Tower', '', '', '371', 10),
    (920300, 1, 1, 11, 2, 1, 'Enter the Skylance Library', '', '', '371', 10),
    (920301, 0, 0, 11, 2, 1, 'Enter Skylance Tower', '', '', '371', 11),
    (920301, 1, 1, 11, 2, 1, 'Enter the Skylance Oubliette', '', '', '371', 11),
    (920302, 0, 0, 11, 2, 1, 'Enter Skylance Tower', '', '', '371', 12),
    (920302, 1, 1, 11, 2, 1, 'Enter the Skylance Laboratory', '', '', '371', 12),
    (920300, 2, 2, 4, 2, 1, 'Speak with Student Joban', '371036', '', '371', 10),
    (920300, 3, 3, 3, 0, 1, 'Recover Gareth’s half of the token', '371049', '36141', '371', 10),
    (920300, 4, 3, 3, 0, 1, 'Recover Venorin’s half of the token', '371025', '36140', '371', 10),
    (920300, 5, 4, 1, 2, 2, 'Give both token halves to the Head Librarian', '371037', '36140|36141', '371', 10),
    (920300, 6, 5, 1, 0, 1, 'Return the Codex Artifice to Ao', '369083', '36142', '369', 0),
    (920301, 2, 2, 0, 2, 1, 'Recover the prototype egg from a pulsing eggsack', '', '', '371', 11),
    (920301, 3, 3, 1, 0, 1, 'Return the Prototype Egg to Ao', '369083', '36143', '369', 0),
    (920302, 2, 2, 0, 2, 1, 'Place the incubated egg on the laboratory table', '', '', '371', 12),
    (920302, 3, 3, 0, 2, 1, 'Complete the laboratory procedures in order', '', '', '371', 12),
    (920302, 4, 4, 2, 0, 1, 'Defeat Tallongast the Discarded', '371963', '', '371', 12),
    (920303, 0, 0, 3, 2, 1, 'Recover a distinct saga skin', '', '88069', '372|374|375', -1),
    (920303, 1, 1, 1, 2, 1, 'Have Maelin translate this skin', '202125', '88069', '202', 0),
    (920303, 2, 0, 3, 2, 1, 'Recover a distinct saga skin', '', '88070', '372|374|375', -1),
    (920303, 3, 1, 1, 2, 1, 'Have Maelin translate this skin', '202125', '88070', '202', 0),
    (920303, 4, 0, 3, 2, 1, 'Recover a distinct saga skin', '', '88071', '372|374|375', -1),
    (920303, 5, 1, 1, 2, 1, 'Have Maelin translate this skin', '202125', '88071', '202', 0),
    (920303, 6, 0, 3, 2, 1, 'Recover a distinct saga skin', '', '88072', '372|374|375', -1),
    (920303, 7, 1, 1, 2, 1, 'Have Maelin translate this skin', '202125', '88072', '202', 0),
    (920303, 8, 0, 3, 2, 1, 'Recover a distinct saga skin', '', '88073', '372|374|375', -1),
    (920303, 9, 1, 1, 2, 1, 'Have Maelin translate this skin', '202125', '88073', '202', 0),
    (920303, 10, 0, 3, 2, 1, 'Recover a distinct saga skin', '', '88074', '372|374|375', -1),
    (920303, 11, 1, 1, 2, 1, 'Have Maelin translate this skin', '202125', '88074', '202', 0),
    (920303, 12, 0, 3, 2, 1, 'Recover a distinct saga skin', '', '88075', '372|374|375', -1),
    (920303, 13, 1, 1, 2, 1, 'Have Maelin translate this skin', '202125', '88075', '202', 0),
    (920303, 14, 0, 3, 2, 1, 'Recover a distinct saga skin', '', '88076', '372|374|375', -1),
    (920303, 15, 1, 1, 2, 1, 'Have Maelin translate this skin', '202125', '88076', '202', 0),
    (920303, 16, 0, 3, 2, 1, 'Recover a distinct saga skin', '', '88077', '372|374|375', -1),
    (920303, 17, 1, 1, 2, 1, 'Have Maelin translate this skin', '202125', '88077', '202', 0),
    (920303, 18, 2, 6, 0, 1, 'Bind the nine translations into two volumes', '', '88087', '', -1),
    (920335, 0, 0, 1, 2, 1, 'Give this volume to Maelin', '202125', '88087', '202', 0),
    (920335, 1, 0, 1, 2, 1, 'Give this volume to Maelin', '202125', '88089', '202', 0),
    (920336, 0, 0, 1, 2, 1, 'Give Ao the Tarnished Chime', '369083', '36144', '369', 0),
    (920337, 0, 0, 1, 2, 1, 'Present the enchanted chime to Galsin', '369011', '84162', '369', 0),
    (920304, 0, 0, 3, 0, 1, 'Collect Maelin’s armor materials', '', '88090', '372|374|375', -1),
    (920304, 1, 1, 1, 0, 1, 'Deliver Maelin’s armor materials', '202125', '88090', '202', 0),
    (920304, 2, 0, 3, 0, 5, 'Collect Maelin’s armor materials', '', '88091', '372|374|375', -1),
    (920304, 3, 1, 1, 0, 5, 'Deliver Maelin’s armor materials', '202125', '88091', '202', 0),
    (920304, 4, 0, 3, 0, 5, 'Collect Maelin’s armor materials', '', '88092', '372|374|375', -1),
    (920304, 5, 1, 1, 0, 5, 'Deliver Maelin’s armor materials', '202125', '88092', '202', 0),
    (920304, 6, 2, 1, 2, 1, 'Have Maelin fashion a piece of Enraged Flesh armor', '202125', '88069', '202', 0),
    (920304, 7, 2, 1, 2, 1, 'Have Maelin fashion a piece of Enraged Flesh armor', '202125', '88072', '202', 0),
    (920304, 8, 2, 1, 2, 1, 'Have Maelin fashion a piece of Enraged Flesh armor', '202125', '88076', '202', 0),
    (920304, 9, 2, 1, 2, 1, 'Have Maelin fashion a piece of Enraged Flesh armor', '202125', '88077', '202', 0),
    (920304, 10, 2, 1, 2, 1, 'Have Maelin fashion a piece of Enraged Flesh armor', '202125', '88074', '202', 0),
    (920305, 0, 0, 0, 2, 1, 'Sit before the tower in Enraged Flesh armor', '', '', '374', 0),
    (920305, 1, 1, 2, 2, 60, 'Slay sixty inhabitants of Sverag', '', '', '374', 0),
    (920305, 2, 2, 0, 2, 1, 'Return to the tower and sit in the armor again', '', '', '374', 0),
    (920305, 3, 3, 1, 0, 1, 'Deliver the rage-touched armor to Maelin', '202125', '88093', '202', 0),
    (920305, 4, 3, 1, 0, 1, 'Deliver the rage-touched armor to Maelin', '202125', '88094', '202', 0),
    (920305, 5, 3, 1, 0, 1, 'Deliver the rage-touched armor to Maelin', '202125', '88095', '202', 0),
    (920305, 6, 3, 1, 0, 1, 'Deliver the rage-touched armor to Maelin', '202125', '88096', '202', 0),
    (920305, 7, 3, 1, 0, 1, 'Deliver the rage-touched armor to Maelin', '202125', '88097', '202', 0),
    (920306, 0, 0, 11, 2, 1, 'Enter the owned Razorthorn instance', '', '', '375', 10),
    (920306, 1, 1, 3, 0, 10, 'Loot ten vials of corrupted blood', '', '84156', '375', 10),
    (920306, 2, 2, 6, 0, 1, 'Seal the ten samples in the Runed Silver Box', '', '84158', '', -1),
    (920306, 3, 3, 1, 0, 1, 'Return the sealed box to Oathmir', '372000', '84158', '372', 0),
    (920307, 0, 0, 4, 2, 1, 'Speak with Krylin', '376081', '', '376', 0),
    (920307, 1, 1, 11, 2, 1, 'Enter the Root of Ro', '', '', '377', 10),
    (920307, 2, 2, 3, 0, 1, 'Recover a distinct piece of the sandstone tablet', '', '36135', '377', 10),
    (920307, 3, 2, 3, 0, 1, 'Recover a distinct piece of the sandstone tablet', '', '36136', '377', 10),
    (920307, 4, 2, 3, 0, 1, 'Recover a distinct piece of the sandstone tablet', '', '36137', '377', 10),
    (920307, 5, 2, 3, 0, 1, 'Recover a distinct piece of the sandstone tablet', '', '36138', '377', 10),
    (920307, 6, 2, 3, 0, 1, 'Recover a distinct piece of the sandstone tablet', '377960', '36139', '377', 10),
    (920307, 7, 3, 1, 0, 1, 'Return a piece of the tablet to Tak’Valnakor', '392045', '36135', '392', 0),
    (920307, 8, 3, 1, 0, 1, 'Return a piece of the tablet to Tak’Valnakor', '392045', '36136', '392', 0),
    (920307, 9, 3, 1, 0, 1, 'Return a piece of the tablet to Tak’Valnakor', '392045', '36137', '392', 0),
    (920307, 10, 3, 1, 0, 1, 'Return a piece of the tablet to Tak’Valnakor', '392045', '36138', '392', 0),
    (920307, 11, 3, 1, 0, 1, 'Return a piece of the tablet to Tak’Valnakor', '392045', '36139', '392', 0),
    (920308, 0, 0, 4, 2, 1, 'Speak with Queen Tak’Yaliz to enter', '392088', '', '392', 0),
    (920308, 1, 1, 2, 0, 5, 'Defeat the five priests of the Burning Prince', '376960', '', '376', 10),
    (920308, 2, 2, 2, 0, 1, 'Slay Prince Tak’Salir', '376961', '', '376', 10),
    (920308, 3, 3, 4, 2, 1, 'Report to Queen Tak’Yaliz', '392088', '', '392', 0),
    (920309, 0, 0, 4, 2, 1, 'Receive the Crown of Tak’Yaliz from the Queen', '392088', '', '392', 0),
    (920309, 1, 1, 11, 2, 1, 'Enter the owned Ruins of Takish-Hiz', '', '', '376', 11),
    (920309, 2, 2, 3, 0, 1, 'Recover the Queen’s proof from the ruins', '376962', '84152', '376', 11),
    (920309, 3, 2, 3, 0, 1, 'Recover the Queen’s proof from the ruins', '376963', '84153', '376', 11),
    (920309, 4, 2, 3, 0, 1, 'Recover the Queen’s proof from the ruins', '376964', '84154', '376', 11),
    (920309, 5, 3, 1, 0, 1, 'Give the proof to Maryn Tak’Yaliz', '378062', '84152', '378', 0),
    (920309, 6, 3, 1, 0, 1, 'Give the proof to Maryn Tak’Yaliz', '378062', '84153', '378', 0),
    (920309, 7, 3, 1, 0, 1, 'Give the proof to Maryn Tak’Yaliz', '378062', '84154', '378', 0),
    (920309, 8, 3, 1, 0, 1, 'Give the proof to Maryn Tak’Yaliz', '378062', '84155', '378', 0),
    (920310, 0, 0, 1, 0, 1, 'Return a Lifestone to Lilthill’yan’s Ghost', '376056', '85641', '376', 0),
    (920310, 1, 0, 1, 0, 1, 'Return a Lifestone to Lilthill’yan’s Ghost', '376056', '85642', '376', 0),
    (920310, 2, 0, 1, 0, 1, 'Return a Lifestone to Lilthill’yan’s Ghost', '376056', '85643', '376', 0),
    (920310, 3, 0, 1, 0, 1, 'Return a Lifestone to Lilthill’yan’s Ghost', '376056', '85644', '376', 0),
    (920326, 0, 0, 1, 2, 4, 'Deliver four trophies to the Sverag contact', '374001', '88060', '374', 0),
    (920327, 0, 0, 1, 2, 4, 'Deliver four trophies to the Sverag contact', '', '88061', '374', 0),
    (920328, 0, 0, 1, 2, 4, 'Deliver four trophies to the Sverag contact', '374001', '88062', '374', 0),
    (920329, 0, 0, 1, 2, 4, 'Deliver four trophies to the Sverag contact', '374001', '88063', '374', 0),
    (920330, 0, 0, 1, 2, 4, 'Deliver four trophies to the Sverag contact', '374001', '88064', '374', 0),
    (920331, 0, 0, 1, 2, 4, 'Deliver four trophies to the Sverag contact', '374001', '88065', '374', 0),
    (920332, 0, 0, 1, 2, 4, 'Deliver four trophies to the Sverag contact', '374001', '88066', '374', 0),
    (920333, 0, 0, 1, 2, 4, 'Deliver four trophies to the Sverag contact', '374001', '88067', '374', 0),
    (920334, 0, 0, 1, 2, 4, 'Deliver four trophies to the Sverag contact', '374001', '88068', '374', 0);
IF EXISTS (SELECT 1 FROM reward_sets WHERE reward_set_id BETWEEN 920300 AND 920339)
   OR EXISTS (SELECT 1 FROM reward_sources WHERE reward_set_id BETWEEN 920300 AND 920339 OR (source_type=2 AND source_id BETWEEN 920300 AND 920339))
   OR EXISTS (SELECT 1 FROM reward_options WHERE reward_set_id BETWEEN 920300 AND 920339)
   OR EXISTS (SELECT 1 FROM reward_option_entries WHERE reward_set_id BETWEEN 920300 AND 920339 OR reward_id BETWEEN 3842000000 AND 3842001279)
   OR EXISTS (SELECT 1 FROM rewards WHERE reward_id BETWEEN 3842000000 AND 3842001279)
   OR (SELECT COUNT(*) FROM items WHERE (id=39665 AND classes=49629) OR (id=39666 AND classes=15906) OR (id=77980 AND classes=1) OR (id=77981 AND classes=1) OR (id=77982 AND classes=256) OR (id=77983 AND classes=256) OR (id=77984 AND classes=64) OR (id=77985 AND classes=64) OR (id=77986 AND classes=32768) OR (id=77987 AND classes=32768) OR (id=77988 AND classes=4) OR (id=77989 AND classes=4) OR (id=77990 AND classes=16) OR (id=77991 AND classes=16) OR (id=77992 AND classes=128) OR (id=77993 AND classes=128) OR (id=77994 AND classes=8) OR (id=77995 AND classes=8) OR (id=77996 AND classes=2) OR (id=77997 AND classes=2) OR (id=77998 AND classes=2) OR (id=77999 AND classes=32) OR (id=78000 AND classes=32) OR (id=78001 AND classes=32) OR (id=78002 AND classes=512) OR (id=78003 AND classes=512) OR (id=78004 AND classes=512) OR (id=78005 AND classes=8192) OR (id=78006 AND classes=8192) OR (id=78007 AND classes=8192) OR (id=78008 AND classes=2048) OR (id=78009 AND classes=2048) OR (id=78010 AND classes=2048) OR (id=78011 AND classes=4096) OR (id=78012 AND classes=4096) OR (id=78013 AND classes=4096) OR (id=78014 AND classes=1024) OR (id=78015 AND classes=1024) OR (id=78016 AND classes=1024) OR (id=78017 AND classes=16384) OR (id=78018 AND classes=16384) OR (id=78019 AND classes=1) OR (id=78020 AND classes=256) OR (id=78021 AND classes=64) OR (id=78022 AND classes=32768) OR (id=78023 AND classes=4) OR (id=78024 AND classes=128) OR (id=78025 AND classes=2) OR (id=78026 AND classes=32) OR (id=78027 AND classes=512) OR (id=78028 AND classes=8192) OR (id=78029 AND classes=2048) OR (id=78030 AND classes=4096) OR (id=78031 AND classes=1024)) <> 54
   OR (SELECT COUNT(*) FROM items WHERE id IN (36144,84159,84163)) <> 3 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'PoR reward preimage differs';
END IF;
INSERT INTO reward_sets (reward_set_id,title,enabled) SELECT id,title,1 FROM tasks WHERE id IN (920302,920309,920310,920326,920327,920328,920329,920330,920331,920332,920333,920334,920335,920336,920337) AND enabled=0;
INSERT INTO reward_sources (source_type,source_id,reward_set_id,enabled) VALUES
    (2, 920302, 920302, 1),
    (2, 920309, 920309, 1),
    (2, 920310, 920310, 1),
    (2, 920326, 920326, 1),
    (2, 920327, 920327, 1),
    (2, 920328, 920328, 1),
    (2, 920329, 920329, 1),
    (2, 920330, 920330, 1),
    (2, 920331, 920331, 1),
    (2, 920332, 920332, 1),
    (2, 920333, 920333, 1),
    (2, 920334, 920334, 1),
    (2, 920335, 920335, 1),
    (2, 920336, 920336, 1),
    (2, 920337, 920337, 1);
INSERT INTO reward_options (reward_set_id,option_id,sequence,label,common_to_all,flags,enabled,class_mask)
SELECT 920302,1,1,name,1,0,1,65535 FROM items WHERE id=36144
UNION ALL
SELECT 920309,1,1,name,1,0,1,2 FROM items WHERE id=77998
UNION ALL
SELECT 920309,2,2,name,1,0,1,32 FROM items WHERE id=78001
UNION ALL
SELECT 920309,3,3,name,1,0,1,512 FROM items WHERE id=78004
UNION ALL
SELECT 920309,4,4,name,1,0,1,1024 FROM items WHERE id=78016
UNION ALL
SELECT 920309,5,5,name,1,0,1,2048 FROM items WHERE id=78010
UNION ALL
SELECT 920309,6,6,name,1,0,1,4096 FROM items WHERE id=78013
UNION ALL
SELECT 920309,7,7,name,1,0,1,8192 FROM items WHERE id=78007
UNION ALL
SELECT 920310,1,1,name,1,0,1,49629 FROM items WHERE id=39665
UNION ALL
SELECT 920310,2,2,name,1,0,1,15906 FROM items WHERE id=39666
UNION ALL
SELECT 920310,3,3,name,1,0,1,1 FROM items WHERE id=78019
UNION ALL
SELECT 920310,4,4,name,1,0,1,2 FROM items WHERE id=78025
UNION ALL
SELECT 920310,5,5,name,1,0,1,4 FROM items WHERE id=78023
UNION ALL
SELECT 920310,6,6,name,1,0,1,32 FROM items WHERE id=78026
UNION ALL
SELECT 920310,7,7,name,1,0,1,64 FROM items WHERE id=78021
UNION ALL
SELECT 920310,8,8,name,1,0,1,128 FROM items WHERE id=78024
UNION ALL
SELECT 920310,9,9,name,1,0,1,256 FROM items WHERE id=78020
UNION ALL
SELECT 920310,10,10,name,1,0,1,512 FROM items WHERE id=78027
UNION ALL
SELECT 920310,11,11,name,1,0,1,1024 FROM items WHERE id=78031
UNION ALL
SELECT 920310,12,12,name,1,0,1,2048 FROM items WHERE id=78029
UNION ALL
SELECT 920310,13,13,name,1,0,1,4096 FROM items WHERE id=78030
UNION ALL
SELECT 920310,14,14,name,1,0,1,8192 FROM items WHERE id=78028
UNION ALL
SELECT 920310,15,15,name,1,0,1,32768 FROM items WHERE id=78022
UNION ALL
SELECT 920326,1,1,name,1,0,1,1 FROM items WHERE id=77980
UNION ALL
SELECT 920326,2,2,name,1,0,1,2 FROM items WHERE id=77996
UNION ALL
SELECT 920326,3,3,name,1,0,1,4 FROM items WHERE id=77988
UNION ALL
SELECT 920326,4,4,name,1,0,1,8 FROM items WHERE id=77994
UNION ALL
SELECT 920326,5,5,name,1,0,1,16 FROM items WHERE id=77990
UNION ALL
SELECT 920326,6,6,name,1,0,1,32 FROM items WHERE id=77999
UNION ALL
SELECT 920326,7,7,name,1,0,1,64 FROM items WHERE id=77984
UNION ALL
SELECT 920326,8,8,name,1,0,1,128 FROM items WHERE id=77992
UNION ALL
SELECT 920326,9,9,name,1,0,1,256 FROM items WHERE id=77982
UNION ALL
SELECT 920326,10,10,name,1,0,1,512 FROM items WHERE id=78002
UNION ALL
SELECT 920326,11,11,name,1,0,1,1024 FROM items WHERE id=78014
UNION ALL
SELECT 920326,12,12,name,1,0,1,2048 FROM items WHERE id=78008
UNION ALL
SELECT 920326,13,13,name,1,0,1,4096 FROM items WHERE id=78011
UNION ALL
SELECT 920326,14,14,name,1,0,1,8192 FROM items WHERE id=78005
UNION ALL
SELECT 920326,15,15,name,1,0,1,16384 FROM items WHERE id=78017
UNION ALL
SELECT 920326,16,16,name,1,0,1,32768 FROM items WHERE id=77986
UNION ALL
SELECT 920327,1,1,name,1,0,1,1 FROM items WHERE id=77980
UNION ALL
SELECT 920327,2,2,name,1,0,1,2 FROM items WHERE id=77996
UNION ALL
SELECT 920327,3,3,name,1,0,1,4 FROM items WHERE id=77988
UNION ALL
SELECT 920327,4,4,name,1,0,1,8 FROM items WHERE id=77994
UNION ALL
SELECT 920327,5,5,name,1,0,1,16 FROM items WHERE id=77990
UNION ALL
SELECT 920327,6,6,name,1,0,1,32 FROM items WHERE id=77999
UNION ALL
SELECT 920327,7,7,name,1,0,1,64 FROM items WHERE id=77984
UNION ALL
SELECT 920327,8,8,name,1,0,1,128 FROM items WHERE id=77992
UNION ALL
SELECT 920327,9,9,name,1,0,1,256 FROM items WHERE id=77982
UNION ALL
SELECT 920327,10,10,name,1,0,1,512 FROM items WHERE id=78002
UNION ALL
SELECT 920327,11,11,name,1,0,1,1024 FROM items WHERE id=78014
UNION ALL
SELECT 920327,12,12,name,1,0,1,2048 FROM items WHERE id=78008
UNION ALL
SELECT 920327,13,13,name,1,0,1,4096 FROM items WHERE id=78011
UNION ALL
SELECT 920327,14,14,name,1,0,1,8192 FROM items WHERE id=78005
UNION ALL
SELECT 920327,15,15,name,1,0,1,16384 FROM items WHERE id=78017
UNION ALL
SELECT 920327,16,16,name,1,0,1,32768 FROM items WHERE id=77986
UNION ALL
SELECT 920328,1,1,name,1,0,1,1 FROM items WHERE id=77980
UNION ALL
SELECT 920328,2,2,name,1,0,1,2 FROM items WHERE id=77996
UNION ALL
SELECT 920328,3,3,name,1,0,1,4 FROM items WHERE id=77988
UNION ALL
SELECT 920328,4,4,name,1,0,1,8 FROM items WHERE id=77994
UNION ALL
SELECT 920328,5,5,name,1,0,1,16 FROM items WHERE id=77990
UNION ALL
SELECT 920328,6,6,name,1,0,1,32 FROM items WHERE id=77999
UNION ALL
SELECT 920328,7,7,name,1,0,1,64 FROM items WHERE id=77984
UNION ALL
SELECT 920328,8,8,name,1,0,1,128 FROM items WHERE id=77992
UNION ALL
SELECT 920328,9,9,name,1,0,1,256 FROM items WHERE id=77982
UNION ALL
SELECT 920328,10,10,name,1,0,1,512 FROM items WHERE id=78002
UNION ALL
SELECT 920328,11,11,name,1,0,1,1024 FROM items WHERE id=78014
UNION ALL
SELECT 920328,12,12,name,1,0,1,2048 FROM items WHERE id=78008
UNION ALL
SELECT 920328,13,13,name,1,0,1,4096 FROM items WHERE id=78011
UNION ALL
SELECT 920328,14,14,name,1,0,1,8192 FROM items WHERE id=78005
UNION ALL
SELECT 920328,15,15,name,1,0,1,16384 FROM items WHERE id=78017
UNION ALL
SELECT 920328,16,16,name,1,0,1,32768 FROM items WHERE id=77986
UNION ALL
SELECT 920329,1,1,name,1,0,1,1 FROM items WHERE id=77980
UNION ALL
SELECT 920329,2,2,name,1,0,1,2 FROM items WHERE id=77996
UNION ALL
SELECT 920329,3,3,name,1,0,1,4 FROM items WHERE id=77988
UNION ALL
SELECT 920329,4,4,name,1,0,1,8 FROM items WHERE id=77994
UNION ALL
SELECT 920329,5,5,name,1,0,1,16 FROM items WHERE id=77990
UNION ALL
SELECT 920329,6,6,name,1,0,1,32 FROM items WHERE id=77999
UNION ALL
SELECT 920329,7,7,name,1,0,1,64 FROM items WHERE id=77984
UNION ALL
SELECT 920329,8,8,name,1,0,1,128 FROM items WHERE id=77992
UNION ALL
SELECT 920329,9,9,name,1,0,1,256 FROM items WHERE id=77982
UNION ALL
SELECT 920329,10,10,name,1,0,1,512 FROM items WHERE id=78002
UNION ALL
SELECT 920329,11,11,name,1,0,1,1024 FROM items WHERE id=78014
UNION ALL
SELECT 920329,12,12,name,1,0,1,2048 FROM items WHERE id=78008
UNION ALL
SELECT 920329,13,13,name,1,0,1,4096 FROM items WHERE id=78011
UNION ALL
SELECT 920329,14,14,name,1,0,1,8192 FROM items WHERE id=78005
UNION ALL
SELECT 920329,15,15,name,1,0,1,16384 FROM items WHERE id=78017
UNION ALL
SELECT 920329,16,16,name,1,0,1,32768 FROM items WHERE id=77986
UNION ALL
SELECT 920330,1,1,name,1,0,1,1 FROM items WHERE id=77980
UNION ALL
SELECT 920330,2,2,name,1,0,1,2 FROM items WHERE id=77996
UNION ALL
SELECT 920330,3,3,name,1,0,1,4 FROM items WHERE id=77988
UNION ALL
SELECT 920330,4,4,name,1,0,1,8 FROM items WHERE id=77994
UNION ALL
SELECT 920330,5,5,name,1,0,1,16 FROM items WHERE id=77990
UNION ALL
SELECT 920330,6,6,name,1,0,1,32 FROM items WHERE id=77999
UNION ALL
SELECT 920330,7,7,name,1,0,1,64 FROM items WHERE id=77984
UNION ALL
SELECT 920330,8,8,name,1,0,1,128 FROM items WHERE id=77992
UNION ALL
SELECT 920330,9,9,name,1,0,1,256 FROM items WHERE id=77982
UNION ALL
SELECT 920330,10,10,name,1,0,1,512 FROM items WHERE id=78002
UNION ALL
SELECT 920330,11,11,name,1,0,1,1024 FROM items WHERE id=78014
UNION ALL
SELECT 920330,12,12,name,1,0,1,2048 FROM items WHERE id=78008
UNION ALL
SELECT 920330,13,13,name,1,0,1,4096 FROM items WHERE id=78011
UNION ALL
SELECT 920330,14,14,name,1,0,1,8192 FROM items WHERE id=78005
UNION ALL
SELECT 920330,15,15,name,1,0,1,16384 FROM items WHERE id=78017
UNION ALL
SELECT 920330,16,16,name,1,0,1,32768 FROM items WHERE id=77986
UNION ALL
SELECT 920331,1,1,name,1,0,1,1 FROM items WHERE id=77980
UNION ALL
SELECT 920331,2,2,name,1,0,1,2 FROM items WHERE id=77996
UNION ALL
SELECT 920331,3,3,name,1,0,1,4 FROM items WHERE id=77988
UNION ALL
SELECT 920331,4,4,name,1,0,1,8 FROM items WHERE id=77994
UNION ALL
SELECT 920331,5,5,name,1,0,1,16 FROM items WHERE id=77990
UNION ALL
SELECT 920331,6,6,name,1,0,1,32 FROM items WHERE id=77999
UNION ALL
SELECT 920331,7,7,name,1,0,1,64 FROM items WHERE id=77984
UNION ALL
SELECT 920331,8,8,name,1,0,1,128 FROM items WHERE id=77992
UNION ALL
SELECT 920331,9,9,name,1,0,1,256 FROM items WHERE id=77982
UNION ALL
SELECT 920331,10,10,name,1,0,1,512 FROM items WHERE id=78002
UNION ALL
SELECT 920331,11,11,name,1,0,1,1024 FROM items WHERE id=78014
UNION ALL
SELECT 920331,12,12,name,1,0,1,2048 FROM items WHERE id=78008
UNION ALL
SELECT 920331,13,13,name,1,0,1,4096 FROM items WHERE id=78011
UNION ALL
SELECT 920331,14,14,name,1,0,1,8192 FROM items WHERE id=78005
UNION ALL
SELECT 920331,15,15,name,1,0,1,16384 FROM items WHERE id=78017
UNION ALL
SELECT 920331,16,16,name,1,0,1,32768 FROM items WHERE id=77986
UNION ALL
SELECT 920332,1,1,name,1,0,1,1 FROM items WHERE id=77980
UNION ALL
SELECT 920332,2,2,name,1,0,1,2 FROM items WHERE id=77996
UNION ALL
SELECT 920332,3,3,name,1,0,1,4 FROM items WHERE id=77988
UNION ALL
SELECT 920332,4,4,name,1,0,1,8 FROM items WHERE id=77994
UNION ALL
SELECT 920332,5,5,name,1,0,1,16 FROM items WHERE id=77990
UNION ALL
SELECT 920332,6,6,name,1,0,1,32 FROM items WHERE id=77999
UNION ALL
SELECT 920332,7,7,name,1,0,1,64 FROM items WHERE id=77984
UNION ALL
SELECT 920332,8,8,name,1,0,1,128 FROM items WHERE id=77992
UNION ALL
SELECT 920332,9,9,name,1,0,1,256 FROM items WHERE id=77982
UNION ALL
SELECT 920332,10,10,name,1,0,1,512 FROM items WHERE id=78002
UNION ALL
SELECT 920332,11,11,name,1,0,1,1024 FROM items WHERE id=78014
UNION ALL
SELECT 920332,12,12,name,1,0,1,2048 FROM items WHERE id=78008
UNION ALL
SELECT 920332,13,13,name,1,0,1,4096 FROM items WHERE id=78011
UNION ALL
SELECT 920332,14,14,name,1,0,1,8192 FROM items WHERE id=78005
UNION ALL
SELECT 920332,15,15,name,1,0,1,16384 FROM items WHERE id=78017
UNION ALL
SELECT 920332,16,16,name,1,0,1,32768 FROM items WHERE id=77986
UNION ALL
SELECT 920333,1,1,name,1,0,1,1 FROM items WHERE id=77980
UNION ALL
SELECT 920333,2,2,name,1,0,1,2 FROM items WHERE id=77996
UNION ALL
SELECT 920333,3,3,name,1,0,1,4 FROM items WHERE id=77988
UNION ALL
SELECT 920333,4,4,name,1,0,1,8 FROM items WHERE id=77994
UNION ALL
SELECT 920333,5,5,name,1,0,1,16 FROM items WHERE id=77990
UNION ALL
SELECT 920333,6,6,name,1,0,1,32 FROM items WHERE id=77999
UNION ALL
SELECT 920333,7,7,name,1,0,1,64 FROM items WHERE id=77984
UNION ALL
SELECT 920333,8,8,name,1,0,1,128 FROM items WHERE id=77992
UNION ALL
SELECT 920333,9,9,name,1,0,1,256 FROM items WHERE id=77982
UNION ALL
SELECT 920333,10,10,name,1,0,1,512 FROM items WHERE id=78002
UNION ALL
SELECT 920333,11,11,name,1,0,1,1024 FROM items WHERE id=78014
UNION ALL
SELECT 920333,12,12,name,1,0,1,2048 FROM items WHERE id=78008
UNION ALL
SELECT 920333,13,13,name,1,0,1,4096 FROM items WHERE id=78011
UNION ALL
SELECT 920333,14,14,name,1,0,1,8192 FROM items WHERE id=78005
UNION ALL
SELECT 920333,15,15,name,1,0,1,16384 FROM items WHERE id=78017
UNION ALL
SELECT 920333,16,16,name,1,0,1,32768 FROM items WHERE id=77986
UNION ALL
SELECT 920334,1,1,name,1,0,1,1 FROM items WHERE id=77980
UNION ALL
SELECT 920334,2,2,name,1,0,1,2 FROM items WHERE id=77996
UNION ALL
SELECT 920334,3,3,name,1,0,1,4 FROM items WHERE id=77988
UNION ALL
SELECT 920334,4,4,name,1,0,1,8 FROM items WHERE id=77994
UNION ALL
SELECT 920334,5,5,name,1,0,1,16 FROM items WHERE id=77990
UNION ALL
SELECT 920334,6,6,name,1,0,1,32 FROM items WHERE id=77999
UNION ALL
SELECT 920334,7,7,name,1,0,1,64 FROM items WHERE id=77984
UNION ALL
SELECT 920334,8,8,name,1,0,1,128 FROM items WHERE id=77992
UNION ALL
SELECT 920334,9,9,name,1,0,1,256 FROM items WHERE id=77982
UNION ALL
SELECT 920334,10,10,name,1,0,1,512 FROM items WHERE id=78002
UNION ALL
SELECT 920334,11,11,name,1,0,1,1024 FROM items WHERE id=78014
UNION ALL
SELECT 920334,12,12,name,1,0,1,2048 FROM items WHERE id=78008
UNION ALL
SELECT 920334,13,13,name,1,0,1,4096 FROM items WHERE id=78011
UNION ALL
SELECT 920334,14,14,name,1,0,1,8192 FROM items WHERE id=78005
UNION ALL
SELECT 920334,15,15,name,1,0,1,16384 FROM items WHERE id=78017
UNION ALL
SELECT 920334,16,16,name,1,0,1,32768 FROM items WHERE id=77986
UNION ALL
SELECT 920335,1,1,name,1,0,1,1 FROM items WHERE id=77980
UNION ALL
SELECT 920335,2,2,name,1,0,1,2 FROM items WHERE id=77996
UNION ALL
SELECT 920335,3,3,name,1,0,1,4 FROM items WHERE id=77988
UNION ALL
SELECT 920335,4,4,name,1,0,1,8 FROM items WHERE id=77994
UNION ALL
SELECT 920335,5,5,name,1,0,1,16 FROM items WHERE id=77990
UNION ALL
SELECT 920335,6,6,name,1,0,1,32 FROM items WHERE id=77999
UNION ALL
SELECT 920335,7,7,name,1,0,1,64 FROM items WHERE id=77984
UNION ALL
SELECT 920335,8,8,name,1,0,1,128 FROM items WHERE id=77992
UNION ALL
SELECT 920335,9,9,name,1,0,1,256 FROM items WHERE id=77982
UNION ALL
SELECT 920335,10,10,name,1,0,1,512 FROM items WHERE id=78002
UNION ALL
SELECT 920335,11,11,name,1,0,1,1024 FROM items WHERE id=78014
UNION ALL
SELECT 920335,12,12,name,1,0,1,2048 FROM items WHERE id=78008
UNION ALL
SELECT 920335,13,13,name,1,0,1,4096 FROM items WHERE id=78011
UNION ALL
SELECT 920335,14,14,name,1,0,1,8192 FROM items WHERE id=78005
UNION ALL
SELECT 920335,15,15,name,1,0,1,16384 FROM items WHERE id=78017
UNION ALL
SELECT 920335,16,16,name,1,0,1,32768 FROM items WHERE id=77986
UNION ALL
SELECT 920336,1,1,name,1,0,1,65535 FROM items WHERE id=84159
UNION ALL
SELECT 920336,2,2,name,1,0,1,1 FROM items WHERE id=77981
UNION ALL
SELECT 920336,3,3,name,1,0,1,2 FROM items WHERE id=77997
UNION ALL
SELECT 920336,4,4,name,1,0,1,4 FROM items WHERE id=77989
UNION ALL
SELECT 920336,5,5,name,1,0,1,8 FROM items WHERE id=77995
UNION ALL
SELECT 920336,6,6,name,1,0,1,16 FROM items WHERE id=77991
UNION ALL
SELECT 920336,7,7,name,1,0,1,32 FROM items WHERE id=78000
UNION ALL
SELECT 920336,8,8,name,1,0,1,64 FROM items WHERE id=77985
UNION ALL
SELECT 920336,9,9,name,1,0,1,128 FROM items WHERE id=77993
UNION ALL
SELECT 920336,10,10,name,1,0,1,256 FROM items WHERE id=77983
UNION ALL
SELECT 920336,11,11,name,1,0,1,512 FROM items WHERE id=78003
UNION ALL
SELECT 920336,12,12,name,1,0,1,1024 FROM items WHERE id=78015
UNION ALL
SELECT 920336,13,13,name,1,0,1,2048 FROM items WHERE id=78009
UNION ALL
SELECT 920336,14,14,name,1,0,1,4096 FROM items WHERE id=78012
UNION ALL
SELECT 920336,15,15,name,1,0,1,8192 FROM items WHERE id=78006
UNION ALL
SELECT 920336,16,16,name,1,0,1,16384 FROM items WHERE id=78018
UNION ALL
SELECT 920336,17,17,name,1,0,1,32768 FROM items WHERE id=77987
UNION ALL
SELECT 920337,1,1,name,1,0,1,65535 FROM items WHERE id=84163;
INSERT INTO rewards (reward_id,reward_type,reward_data_id,amount,description,enabled)
SELECT 3842000065,0,id,1,name,1 FROM items WHERE id=36144
UNION ALL
SELECT 3842000289,0,id,1,name,1 FROM items WHERE id=77998
UNION ALL
SELECT 3842000290,0,id,1,name,1 FROM items WHERE id=78001
UNION ALL
SELECT 3842000291,0,id,1,name,1 FROM items WHERE id=78004
UNION ALL
SELECT 3842000292,0,id,1,name,1 FROM items WHERE id=78016
UNION ALL
SELECT 3842000293,0,id,1,name,1 FROM items WHERE id=78010
UNION ALL
SELECT 3842000294,0,id,1,name,1 FROM items WHERE id=78013
UNION ALL
SELECT 3842000295,0,id,1,name,1 FROM items WHERE id=78007
UNION ALL
SELECT 3842000321,0,id,1,name,1 FROM items WHERE id=39665
UNION ALL
SELECT 3842000322,0,id,1,name,1 FROM items WHERE id=39666
UNION ALL
SELECT 3842000323,0,id,1,name,1 FROM items WHERE id=78019
UNION ALL
SELECT 3842000324,0,id,1,name,1 FROM items WHERE id=78025
UNION ALL
SELECT 3842000325,0,id,1,name,1 FROM items WHERE id=78023
UNION ALL
SELECT 3842000326,0,id,1,name,1 FROM items WHERE id=78026
UNION ALL
SELECT 3842000327,0,id,1,name,1 FROM items WHERE id=78021
UNION ALL
SELECT 3842000328,0,id,1,name,1 FROM items WHERE id=78024
UNION ALL
SELECT 3842000329,0,id,1,name,1 FROM items WHERE id=78020
UNION ALL
SELECT 3842000330,0,id,1,name,1 FROM items WHERE id=78027
UNION ALL
SELECT 3842000331,0,id,1,name,1 FROM items WHERE id=78031
UNION ALL
SELECT 3842000332,0,id,1,name,1 FROM items WHERE id=78029
UNION ALL
SELECT 3842000333,0,id,1,name,1 FROM items WHERE id=78030
UNION ALL
SELECT 3842000334,0,id,1,name,1 FROM items WHERE id=78028
UNION ALL
SELECT 3842000335,0,id,1,name,1 FROM items WHERE id=78022
UNION ALL
SELECT 3842000833,0,id,1,name,1 FROM items WHERE id=77980
UNION ALL
SELECT 3842000834,0,id,1,name,1 FROM items WHERE id=77996
UNION ALL
SELECT 3842000835,0,id,1,name,1 FROM items WHERE id=77988
UNION ALL
SELECT 3842000836,0,id,1,name,1 FROM items WHERE id=77994
UNION ALL
SELECT 3842000837,0,id,1,name,1 FROM items WHERE id=77990
UNION ALL
SELECT 3842000838,0,id,1,name,1 FROM items WHERE id=77999
UNION ALL
SELECT 3842000839,0,id,1,name,1 FROM items WHERE id=77984
UNION ALL
SELECT 3842000840,0,id,1,name,1 FROM items WHERE id=77992
UNION ALL
SELECT 3842000841,0,id,1,name,1 FROM items WHERE id=77982
UNION ALL
SELECT 3842000842,0,id,1,name,1 FROM items WHERE id=78002
UNION ALL
SELECT 3842000843,0,id,1,name,1 FROM items WHERE id=78014
UNION ALL
SELECT 3842000844,0,id,1,name,1 FROM items WHERE id=78008
UNION ALL
SELECT 3842000845,0,id,1,name,1 FROM items WHERE id=78011
UNION ALL
SELECT 3842000846,0,id,1,name,1 FROM items WHERE id=78005
UNION ALL
SELECT 3842000847,0,id,1,name,1 FROM items WHERE id=78017
UNION ALL
SELECT 3842000848,0,id,1,name,1 FROM items WHERE id=77986
UNION ALL
SELECT 3842000865,0,id,1,name,1 FROM items WHERE id=77980
UNION ALL
SELECT 3842000866,0,id,1,name,1 FROM items WHERE id=77996
UNION ALL
SELECT 3842000867,0,id,1,name,1 FROM items WHERE id=77988
UNION ALL
SELECT 3842000868,0,id,1,name,1 FROM items WHERE id=77994
UNION ALL
SELECT 3842000869,0,id,1,name,1 FROM items WHERE id=77990
UNION ALL
SELECT 3842000870,0,id,1,name,1 FROM items WHERE id=77999
UNION ALL
SELECT 3842000871,0,id,1,name,1 FROM items WHERE id=77984
UNION ALL
SELECT 3842000872,0,id,1,name,1 FROM items WHERE id=77992
UNION ALL
SELECT 3842000873,0,id,1,name,1 FROM items WHERE id=77982
UNION ALL
SELECT 3842000874,0,id,1,name,1 FROM items WHERE id=78002
UNION ALL
SELECT 3842000875,0,id,1,name,1 FROM items WHERE id=78014
UNION ALL
SELECT 3842000876,0,id,1,name,1 FROM items WHERE id=78008
UNION ALL
SELECT 3842000877,0,id,1,name,1 FROM items WHERE id=78011
UNION ALL
SELECT 3842000878,0,id,1,name,1 FROM items WHERE id=78005
UNION ALL
SELECT 3842000879,0,id,1,name,1 FROM items WHERE id=78017
UNION ALL
SELECT 3842000880,0,id,1,name,1 FROM items WHERE id=77986
UNION ALL
SELECT 3842000897,0,id,1,name,1 FROM items WHERE id=77980
UNION ALL
SELECT 3842000898,0,id,1,name,1 FROM items WHERE id=77996
UNION ALL
SELECT 3842000899,0,id,1,name,1 FROM items WHERE id=77988
UNION ALL
SELECT 3842000900,0,id,1,name,1 FROM items WHERE id=77994
UNION ALL
SELECT 3842000901,0,id,1,name,1 FROM items WHERE id=77990
UNION ALL
SELECT 3842000902,0,id,1,name,1 FROM items WHERE id=77999
UNION ALL
SELECT 3842000903,0,id,1,name,1 FROM items WHERE id=77984
UNION ALL
SELECT 3842000904,0,id,1,name,1 FROM items WHERE id=77992
UNION ALL
SELECT 3842000905,0,id,1,name,1 FROM items WHERE id=77982
UNION ALL
SELECT 3842000906,0,id,1,name,1 FROM items WHERE id=78002
UNION ALL
SELECT 3842000907,0,id,1,name,1 FROM items WHERE id=78014
UNION ALL
SELECT 3842000908,0,id,1,name,1 FROM items WHERE id=78008
UNION ALL
SELECT 3842000909,0,id,1,name,1 FROM items WHERE id=78011
UNION ALL
SELECT 3842000910,0,id,1,name,1 FROM items WHERE id=78005
UNION ALL
SELECT 3842000911,0,id,1,name,1 FROM items WHERE id=78017
UNION ALL
SELECT 3842000912,0,id,1,name,1 FROM items WHERE id=77986
UNION ALL
SELECT 3842000929,0,id,1,name,1 FROM items WHERE id=77980
UNION ALL
SELECT 3842000930,0,id,1,name,1 FROM items WHERE id=77996
UNION ALL
SELECT 3842000931,0,id,1,name,1 FROM items WHERE id=77988
UNION ALL
SELECT 3842000932,0,id,1,name,1 FROM items WHERE id=77994
UNION ALL
SELECT 3842000933,0,id,1,name,1 FROM items WHERE id=77990
UNION ALL
SELECT 3842000934,0,id,1,name,1 FROM items WHERE id=77999
UNION ALL
SELECT 3842000935,0,id,1,name,1 FROM items WHERE id=77984
UNION ALL
SELECT 3842000936,0,id,1,name,1 FROM items WHERE id=77992
UNION ALL
SELECT 3842000937,0,id,1,name,1 FROM items WHERE id=77982
UNION ALL
SELECT 3842000938,0,id,1,name,1 FROM items WHERE id=78002
UNION ALL
SELECT 3842000939,0,id,1,name,1 FROM items WHERE id=78014
UNION ALL
SELECT 3842000940,0,id,1,name,1 FROM items WHERE id=78008
UNION ALL
SELECT 3842000941,0,id,1,name,1 FROM items WHERE id=78011
UNION ALL
SELECT 3842000942,0,id,1,name,1 FROM items WHERE id=78005
UNION ALL
SELECT 3842000943,0,id,1,name,1 FROM items WHERE id=78017
UNION ALL
SELECT 3842000944,0,id,1,name,1 FROM items WHERE id=77986
UNION ALL
SELECT 3842000961,0,id,1,name,1 FROM items WHERE id=77980
UNION ALL
SELECT 3842000962,0,id,1,name,1 FROM items WHERE id=77996
UNION ALL
SELECT 3842000963,0,id,1,name,1 FROM items WHERE id=77988
UNION ALL
SELECT 3842000964,0,id,1,name,1 FROM items WHERE id=77994
UNION ALL
SELECT 3842000965,0,id,1,name,1 FROM items WHERE id=77990
UNION ALL
SELECT 3842000966,0,id,1,name,1 FROM items WHERE id=77999
UNION ALL
SELECT 3842000967,0,id,1,name,1 FROM items WHERE id=77984
UNION ALL
SELECT 3842000968,0,id,1,name,1 FROM items WHERE id=77992
UNION ALL
SELECT 3842000969,0,id,1,name,1 FROM items WHERE id=77982
UNION ALL
SELECT 3842000970,0,id,1,name,1 FROM items WHERE id=78002
UNION ALL
SELECT 3842000971,0,id,1,name,1 FROM items WHERE id=78014
UNION ALL
SELECT 3842000972,0,id,1,name,1 FROM items WHERE id=78008
UNION ALL
SELECT 3842000973,0,id,1,name,1 FROM items WHERE id=78011
UNION ALL
SELECT 3842000974,0,id,1,name,1 FROM items WHERE id=78005
UNION ALL
SELECT 3842000975,0,id,1,name,1 FROM items WHERE id=78017
UNION ALL
SELECT 3842000976,0,id,1,name,1 FROM items WHERE id=77986
UNION ALL
SELECT 3842000993,0,id,1,name,1 FROM items WHERE id=77980
UNION ALL
SELECT 3842000994,0,id,1,name,1 FROM items WHERE id=77996
UNION ALL
SELECT 3842000995,0,id,1,name,1 FROM items WHERE id=77988
UNION ALL
SELECT 3842000996,0,id,1,name,1 FROM items WHERE id=77994
UNION ALL
SELECT 3842000997,0,id,1,name,1 FROM items WHERE id=77990
UNION ALL
SELECT 3842000998,0,id,1,name,1 FROM items WHERE id=77999
UNION ALL
SELECT 3842000999,0,id,1,name,1 FROM items WHERE id=77984
UNION ALL
SELECT 3842001000,0,id,1,name,1 FROM items WHERE id=77992
UNION ALL
SELECT 3842001001,0,id,1,name,1 FROM items WHERE id=77982
UNION ALL
SELECT 3842001002,0,id,1,name,1 FROM items WHERE id=78002
UNION ALL
SELECT 3842001003,0,id,1,name,1 FROM items WHERE id=78014
UNION ALL
SELECT 3842001004,0,id,1,name,1 FROM items WHERE id=78008
UNION ALL
SELECT 3842001005,0,id,1,name,1 FROM items WHERE id=78011
UNION ALL
SELECT 3842001006,0,id,1,name,1 FROM items WHERE id=78005
UNION ALL
SELECT 3842001007,0,id,1,name,1 FROM items WHERE id=78017
UNION ALL
SELECT 3842001008,0,id,1,name,1 FROM items WHERE id=77986
UNION ALL
SELECT 3842001025,0,id,1,name,1 FROM items WHERE id=77980
UNION ALL
SELECT 3842001026,0,id,1,name,1 FROM items WHERE id=77996
UNION ALL
SELECT 3842001027,0,id,1,name,1 FROM items WHERE id=77988
UNION ALL
SELECT 3842001028,0,id,1,name,1 FROM items WHERE id=77994
UNION ALL
SELECT 3842001029,0,id,1,name,1 FROM items WHERE id=77990
UNION ALL
SELECT 3842001030,0,id,1,name,1 FROM items WHERE id=77999
UNION ALL
SELECT 3842001031,0,id,1,name,1 FROM items WHERE id=77984
UNION ALL
SELECT 3842001032,0,id,1,name,1 FROM items WHERE id=77992
UNION ALL
SELECT 3842001033,0,id,1,name,1 FROM items WHERE id=77982
UNION ALL
SELECT 3842001034,0,id,1,name,1 FROM items WHERE id=78002
UNION ALL
SELECT 3842001035,0,id,1,name,1 FROM items WHERE id=78014
UNION ALL
SELECT 3842001036,0,id,1,name,1 FROM items WHERE id=78008
UNION ALL
SELECT 3842001037,0,id,1,name,1 FROM items WHERE id=78011
UNION ALL
SELECT 3842001038,0,id,1,name,1 FROM items WHERE id=78005
UNION ALL
SELECT 3842001039,0,id,1,name,1 FROM items WHERE id=78017
UNION ALL
SELECT 3842001040,0,id,1,name,1 FROM items WHERE id=77986
UNION ALL
SELECT 3842001057,0,id,1,name,1 FROM items WHERE id=77980
UNION ALL
SELECT 3842001058,0,id,1,name,1 FROM items WHERE id=77996
UNION ALL
SELECT 3842001059,0,id,1,name,1 FROM items WHERE id=77988
UNION ALL
SELECT 3842001060,0,id,1,name,1 FROM items WHERE id=77994
UNION ALL
SELECT 3842001061,0,id,1,name,1 FROM items WHERE id=77990
UNION ALL
SELECT 3842001062,0,id,1,name,1 FROM items WHERE id=77999
UNION ALL
SELECT 3842001063,0,id,1,name,1 FROM items WHERE id=77984
UNION ALL
SELECT 3842001064,0,id,1,name,1 FROM items WHERE id=77992
UNION ALL
SELECT 3842001065,0,id,1,name,1 FROM items WHERE id=77982
UNION ALL
SELECT 3842001066,0,id,1,name,1 FROM items WHERE id=78002
UNION ALL
SELECT 3842001067,0,id,1,name,1 FROM items WHERE id=78014
UNION ALL
SELECT 3842001068,0,id,1,name,1 FROM items WHERE id=78008
UNION ALL
SELECT 3842001069,0,id,1,name,1 FROM items WHERE id=78011
UNION ALL
SELECT 3842001070,0,id,1,name,1 FROM items WHERE id=78005
UNION ALL
SELECT 3842001071,0,id,1,name,1 FROM items WHERE id=78017
UNION ALL
SELECT 3842001072,0,id,1,name,1 FROM items WHERE id=77986
UNION ALL
SELECT 3842001089,0,id,1,name,1 FROM items WHERE id=77980
UNION ALL
SELECT 3842001090,0,id,1,name,1 FROM items WHERE id=77996
UNION ALL
SELECT 3842001091,0,id,1,name,1 FROM items WHERE id=77988
UNION ALL
SELECT 3842001092,0,id,1,name,1 FROM items WHERE id=77994
UNION ALL
SELECT 3842001093,0,id,1,name,1 FROM items WHERE id=77990
UNION ALL
SELECT 3842001094,0,id,1,name,1 FROM items WHERE id=77999
UNION ALL
SELECT 3842001095,0,id,1,name,1 FROM items WHERE id=77984
UNION ALL
SELECT 3842001096,0,id,1,name,1 FROM items WHERE id=77992
UNION ALL
SELECT 3842001097,0,id,1,name,1 FROM items WHERE id=77982
UNION ALL
SELECT 3842001098,0,id,1,name,1 FROM items WHERE id=78002
UNION ALL
SELECT 3842001099,0,id,1,name,1 FROM items WHERE id=78014
UNION ALL
SELECT 3842001100,0,id,1,name,1 FROM items WHERE id=78008
UNION ALL
SELECT 3842001101,0,id,1,name,1 FROM items WHERE id=78011
UNION ALL
SELECT 3842001102,0,id,1,name,1 FROM items WHERE id=78005
UNION ALL
SELECT 3842001103,0,id,1,name,1 FROM items WHERE id=78017
UNION ALL
SELECT 3842001104,0,id,1,name,1 FROM items WHERE id=77986
UNION ALL
SELECT 3842001121,0,id,1,name,1 FROM items WHERE id=77980
UNION ALL
SELECT 3842001122,0,id,1,name,1 FROM items WHERE id=77996
UNION ALL
SELECT 3842001123,0,id,1,name,1 FROM items WHERE id=77988
UNION ALL
SELECT 3842001124,0,id,1,name,1 FROM items WHERE id=77994
UNION ALL
SELECT 3842001125,0,id,1,name,1 FROM items WHERE id=77990
UNION ALL
SELECT 3842001126,0,id,1,name,1 FROM items WHERE id=77999
UNION ALL
SELECT 3842001127,0,id,1,name,1 FROM items WHERE id=77984
UNION ALL
SELECT 3842001128,0,id,1,name,1 FROM items WHERE id=77992
UNION ALL
SELECT 3842001129,0,id,1,name,1 FROM items WHERE id=77982
UNION ALL
SELECT 3842001130,0,id,1,name,1 FROM items WHERE id=78002
UNION ALL
SELECT 3842001131,0,id,1,name,1 FROM items WHERE id=78014
UNION ALL
SELECT 3842001132,0,id,1,name,1 FROM items WHERE id=78008
UNION ALL
SELECT 3842001133,0,id,1,name,1 FROM items WHERE id=78011
UNION ALL
SELECT 3842001134,0,id,1,name,1 FROM items WHERE id=78005
UNION ALL
SELECT 3842001135,0,id,1,name,1 FROM items WHERE id=78017
UNION ALL
SELECT 3842001136,0,id,1,name,1 FROM items WHERE id=77986
UNION ALL
SELECT 3842001153,0,id,1,name,1 FROM items WHERE id=84159
UNION ALL
SELECT 3842001154,0,id,1,name,1 FROM items WHERE id=77981
UNION ALL
SELECT 3842001155,0,id,1,name,1 FROM items WHERE id=77997
UNION ALL
SELECT 3842001156,0,id,1,name,1 FROM items WHERE id=77989
UNION ALL
SELECT 3842001157,0,id,1,name,1 FROM items WHERE id=77995
UNION ALL
SELECT 3842001158,0,id,1,name,1 FROM items WHERE id=77991
UNION ALL
SELECT 3842001159,0,id,1,name,1 FROM items WHERE id=78000
UNION ALL
SELECT 3842001160,0,id,1,name,1 FROM items WHERE id=77985
UNION ALL
SELECT 3842001161,0,id,1,name,1 FROM items WHERE id=77993
UNION ALL
SELECT 3842001162,0,id,1,name,1 FROM items WHERE id=77983
UNION ALL
SELECT 3842001163,0,id,1,name,1 FROM items WHERE id=78003
UNION ALL
SELECT 3842001164,0,id,1,name,1 FROM items WHERE id=78015
UNION ALL
SELECT 3842001165,0,id,1,name,1 FROM items WHERE id=78009
UNION ALL
SELECT 3842001166,0,id,1,name,1 FROM items WHERE id=78012
UNION ALL
SELECT 3842001167,0,id,1,name,1 FROM items WHERE id=78006
UNION ALL
SELECT 3842001168,0,id,1,name,1 FROM items WHERE id=78018
UNION ALL
SELECT 3842001169,0,id,1,name,1 FROM items WHERE id=77987
UNION ALL
SELECT 3842001185,0,id,1,name,1 FROM items WHERE id=84163;
INSERT INTO reward_option_entries (reward_set_id,option_id,sequence,reward_id) VALUES
    (920302, 1, 1, 3842000065),
    (920309, 1, 1, 3842000289),
    (920309, 2, 1, 3842000290),
    (920309, 3, 1, 3842000291),
    (920309, 4, 1, 3842000292),
    (920309, 5, 1, 3842000293),
    (920309, 6, 1, 3842000294),
    (920309, 7, 1, 3842000295),
    (920310, 1, 1, 3842000321),
    (920310, 2, 1, 3842000322),
    (920310, 3, 1, 3842000323),
    (920310, 4, 1, 3842000324),
    (920310, 5, 1, 3842000325),
    (920310, 6, 1, 3842000326),
    (920310, 7, 1, 3842000327),
    (920310, 8, 1, 3842000328),
    (920310, 9, 1, 3842000329),
    (920310, 10, 1, 3842000330),
    (920310, 11, 1, 3842000331),
    (920310, 12, 1, 3842000332),
    (920310, 13, 1, 3842000333),
    (920310, 14, 1, 3842000334),
    (920310, 15, 1, 3842000335),
    (920326, 1, 1, 3842000833),
    (920326, 2, 1, 3842000834),
    (920326, 3, 1, 3842000835),
    (920326, 4, 1, 3842000836),
    (920326, 5, 1, 3842000837),
    (920326, 6, 1, 3842000838),
    (920326, 7, 1, 3842000839),
    (920326, 8, 1, 3842000840),
    (920326, 9, 1, 3842000841),
    (920326, 10, 1, 3842000842),
    (920326, 11, 1, 3842000843),
    (920326, 12, 1, 3842000844),
    (920326, 13, 1, 3842000845),
    (920326, 14, 1, 3842000846),
    (920326, 15, 1, 3842000847),
    (920326, 16, 1, 3842000848),
    (920327, 1, 1, 3842000865),
    (920327, 2, 1, 3842000866),
    (920327, 3, 1, 3842000867),
    (920327, 4, 1, 3842000868),
    (920327, 5, 1, 3842000869),
    (920327, 6, 1, 3842000870),
    (920327, 7, 1, 3842000871),
    (920327, 8, 1, 3842000872),
    (920327, 9, 1, 3842000873),
    (920327, 10, 1, 3842000874),
    (920327, 11, 1, 3842000875),
    (920327, 12, 1, 3842000876),
    (920327, 13, 1, 3842000877),
    (920327, 14, 1, 3842000878),
    (920327, 15, 1, 3842000879),
    (920327, 16, 1, 3842000880),
    (920328, 1, 1, 3842000897),
    (920328, 2, 1, 3842000898),
    (920328, 3, 1, 3842000899),
    (920328, 4, 1, 3842000900),
    (920328, 5, 1, 3842000901),
    (920328, 6, 1, 3842000902),
    (920328, 7, 1, 3842000903),
    (920328, 8, 1, 3842000904),
    (920328, 9, 1, 3842000905),
    (920328, 10, 1, 3842000906),
    (920328, 11, 1, 3842000907),
    (920328, 12, 1, 3842000908),
    (920328, 13, 1, 3842000909),
    (920328, 14, 1, 3842000910),
    (920328, 15, 1, 3842000911),
    (920328, 16, 1, 3842000912),
    (920329, 1, 1, 3842000929),
    (920329, 2, 1, 3842000930),
    (920329, 3, 1, 3842000931),
    (920329, 4, 1, 3842000932),
    (920329, 5, 1, 3842000933),
    (920329, 6, 1, 3842000934),
    (920329, 7, 1, 3842000935),
    (920329, 8, 1, 3842000936),
    (920329, 9, 1, 3842000937),
    (920329, 10, 1, 3842000938),
    (920329, 11, 1, 3842000939),
    (920329, 12, 1, 3842000940),
    (920329, 13, 1, 3842000941),
    (920329, 14, 1, 3842000942),
    (920329, 15, 1, 3842000943),
    (920329, 16, 1, 3842000944),
    (920330, 1, 1, 3842000961),
    (920330, 2, 1, 3842000962),
    (920330, 3, 1, 3842000963),
    (920330, 4, 1, 3842000964),
    (920330, 5, 1, 3842000965),
    (920330, 6, 1, 3842000966),
    (920330, 7, 1, 3842000967),
    (920330, 8, 1, 3842000968),
    (920330, 9, 1, 3842000969),
    (920330, 10, 1, 3842000970),
    (920330, 11, 1, 3842000971),
    (920330, 12, 1, 3842000972),
    (920330, 13, 1, 3842000973),
    (920330, 14, 1, 3842000974),
    (920330, 15, 1, 3842000975),
    (920330, 16, 1, 3842000976),
    (920331, 1, 1, 3842000993),
    (920331, 2, 1, 3842000994),
    (920331, 3, 1, 3842000995),
    (920331, 4, 1, 3842000996),
    (920331, 5, 1, 3842000997),
    (920331, 6, 1, 3842000998),
    (920331, 7, 1, 3842000999),
    (920331, 8, 1, 3842001000),
    (920331, 9, 1, 3842001001),
    (920331, 10, 1, 3842001002),
    (920331, 11, 1, 3842001003),
    (920331, 12, 1, 3842001004),
    (920331, 13, 1, 3842001005),
    (920331, 14, 1, 3842001006),
    (920331, 15, 1, 3842001007),
    (920331, 16, 1, 3842001008),
    (920332, 1, 1, 3842001025),
    (920332, 2, 1, 3842001026),
    (920332, 3, 1, 3842001027),
    (920332, 4, 1, 3842001028),
    (920332, 5, 1, 3842001029),
    (920332, 6, 1, 3842001030),
    (920332, 7, 1, 3842001031),
    (920332, 8, 1, 3842001032),
    (920332, 9, 1, 3842001033),
    (920332, 10, 1, 3842001034),
    (920332, 11, 1, 3842001035),
    (920332, 12, 1, 3842001036),
    (920332, 13, 1, 3842001037),
    (920332, 14, 1, 3842001038),
    (920332, 15, 1, 3842001039),
    (920332, 16, 1, 3842001040),
    (920333, 1, 1, 3842001057),
    (920333, 2, 1, 3842001058),
    (920333, 3, 1, 3842001059),
    (920333, 4, 1, 3842001060),
    (920333, 5, 1, 3842001061),
    (920333, 6, 1, 3842001062),
    (920333, 7, 1, 3842001063),
    (920333, 8, 1, 3842001064),
    (920333, 9, 1, 3842001065),
    (920333, 10, 1, 3842001066),
    (920333, 11, 1, 3842001067),
    (920333, 12, 1, 3842001068),
    (920333, 13, 1, 3842001069),
    (920333, 14, 1, 3842001070),
    (920333, 15, 1, 3842001071),
    (920333, 16, 1, 3842001072),
    (920334, 1, 1, 3842001089),
    (920334, 2, 1, 3842001090),
    (920334, 3, 1, 3842001091),
    (920334, 4, 1, 3842001092),
    (920334, 5, 1, 3842001093),
    (920334, 6, 1, 3842001094),
    (920334, 7, 1, 3842001095),
    (920334, 8, 1, 3842001096),
    (920334, 9, 1, 3842001097),
    (920334, 10, 1, 3842001098),
    (920334, 11, 1, 3842001099),
    (920334, 12, 1, 3842001100),
    (920334, 13, 1, 3842001101),
    (920334, 14, 1, 3842001102),
    (920334, 15, 1, 3842001103),
    (920334, 16, 1, 3842001104),
    (920335, 1, 1, 3842001121),
    (920335, 2, 1, 3842001122),
    (920335, 3, 1, 3842001123),
    (920335, 4, 1, 3842001124),
    (920335, 5, 1, 3842001125),
    (920335, 6, 1, 3842001126),
    (920335, 7, 1, 3842001127),
    (920335, 8, 1, 3842001128),
    (920335, 9, 1, 3842001129),
    (920335, 10, 1, 3842001130),
    (920335, 11, 1, 3842001131),
    (920335, 12, 1, 3842001132),
    (920335, 13, 1, 3842001133),
    (920335, 14, 1, 3842001134),
    (920335, 15, 1, 3842001135),
    (920335, 16, 1, 3842001136),
    (920336, 1, 1, 3842001153),
    (920336, 2, 1, 3842001154),
    (920336, 3, 1, 3842001155),
    (920336, 4, 1, 3842001156),
    (920336, 5, 1, 3842001157),
    (920336, 6, 1, 3842001158),
    (920336, 7, 1, 3842001159),
    (920336, 8, 1, 3842001160),
    (920336, 9, 1, 3842001161),
    (920336, 10, 1, 3842001162),
    (920336, 11, 1, 3842001163),
    (920336, 12, 1, 3842001164),
    (920336, 13, 1, 3842001165),
    (920336, 14, 1, 3842001166),
    (920336, 15, 1, 3842001167),
    (920336, 16, 1, 3842001168),
    (920336, 17, 1, 3842001169),
    (920337, 1, 1, 3842001185);
UPDATE tasks SET reward_method=3 WHERE id IN (920302,920309,920310,920326,920327,920328,920329,920330,920331,920332,920333,920334,920335,920336,920337) AND enabled=0;
IF EXISTS (SELECT 1 FROM npc_faction WHERE id=369004 OR primaryfaction=1062)
   OR (SELECT COUNT(*) FROM faction_list WHERE id=1062 AND BINARY name=BINARY 'Assistants of the Scribe')<>1
   OR (SELECT COUNT(*) FROM spawn2 s JOIN spawnentry e ON e.spawngroupID=s.spawngroupID
       JOIN npc_types n ON n.id=e.npcID WHERE s.id=103451 AND s.zone='arcstone' AND s.version=0
       AND n.id=369004 AND n.merchant_id=369004 AND n.npc_faction_id=0)<>1
   OR (SELECT COUNT(*) FROM merchantlist
       WHERE merchantid=369004 AND (slot,item) IN ((5,78035),(6,78033),(7,78032),(8,78034),(9,78036))
         AND faction_required=-1100 AND min_expansion=-1 AND max_expansion=-1)<>5
   OR (SELECT COUNT(*) FROM items WHERE (id=13063 AND BINARY name=BINARY 'Piece of Parchment')
       OR (id=13051 AND BINARY name=BINARY 'Quill'))<>2 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Luritem faction or merchant preimage differs';
END IF;
INSERT INTO npc_faction (id,name,primaryfaction,ignore_primary_assist)
VALUES (369004,'Scribe Luritem',1062,1);
UPDATE npc_types SET npc_faction_id=369004 WHERE id=369004 AND npc_faction_id=0 AND merchant_id=369004;
IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Luritem faction link failed'; END IF;
UPDATE merchantlist SET faction_required=1100
WHERE merchantid=369004 AND (slot,item) IN ((5,78035),(6,78033),(7,78032),(8,78034),(9,78036)) AND faction_required=-1100;
IF ROW_COUNT()<>5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Luritem spell stock link failed'; END IF;
IF (SELECT COUNT(*) FROM items WHERE (id IN (88078,88079,88080,88081,88082,88083,88084,88085,88086,88087,88089,84156,84158))
    OR (id IN (45923,84157) AND itemclass=1 AND bagslots=10 AND bagtype=13))<>15
   OR EXISTS (SELECT 1 FROM tradeskill_recipe WHERE id IN (30752100,30752101))
   OR EXISTS (SELECT 1 FROM tradeskill_recipe_entries WHERE id BETWEEN 30524400 AND 30524414
      OR recipe_id IN (30752100,30752101)
      OR (item_id IN (88087,88089,84158) AND successcount>0)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='PoR recipe range or output preimage differs';
END IF;
INSERT INTO tradeskill_recipe (id,name,tradeskill,skillneeded,trivial,nofail,replace_container,enabled)
VALUES (30752100,'Saga Skin Translations',75,0,0,1,0,1),
       (30752101,'Seal the Runed Silver Box',75,0,0,1,1,1);
INSERT INTO tradeskill_recipe_entries (id,recipe_id,item_id,componentcount,successcount,iscontainer) VALUES
 (30524400,30752100,45923,0,0,1),
 (30524401,30752100,88078,1,0,0), (30524402,30752100,88079,1,0,0),
 (30524403,30752100,88080,1,0,0), (30524404,30752100,88081,1,0,0),
 (30524405,30752100,88082,1,0,0), (30524406,30752100,88083,1,0,0),
 (30524407,30752100,88084,1,0,0), (30524408,30752100,88085,1,0,0),
 (30524409,30752100,88086,1,0,0), (30524410,30752100,88087,0,1,0),
 (30524411,30752100,88089,0,1,0),
 (30524412,30752101,84157,0,0,1),
 (30524413,30752101,84156,10,0,0),
 (30524414,30752101,84158,0,1,0);
IF EXISTS (SELECT 1 FROM npc_types WHERE id IN (371960,371961,371962,371963,371964,371965,377960,376960,376961,376962,376963,376964,376965,375960)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'PoR actor IDs are occupied';
END IF;
CREATE TEMPORARY TABLE por_npc LIKE npc_types;
INSERT INTO por_npc SELECT * FROM npc_types WHERE id=371024;
IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Missing PoR actor donor 371024'; END IF;
UPDATE por_npc SET id=371960,name='an_underformed_scrykin',level=71,hp=39000,loottable_id=0,
    merchant_id=0,npc_spells_id=0,skip_global_loot=1;
INSERT INTO npc_types SELECT * FROM por_npc;
DELETE FROM por_npc;
INSERT INTO por_npc SELECT * FROM npc_types WHERE id=371018;
IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Missing PoR actor donor 371018'; END IF;
UPDATE por_npc SET id=371961,name='a_laboratory_attendant',level=71,hp=39100,loottable_id=0,
    merchant_id=0,npc_spells_id=0,skip_global_loot=1;
INSERT INTO npc_types SELECT * FROM por_npc;
DELETE FROM por_npc;
INSERT INTO por_npc SELECT * FROM npc_types WHERE id=371023;
IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Missing PoR actor donor 371023'; END IF;
UPDATE por_npc SET id=371962,name='a_failed_experiment',level=72,hp=43500,loottable_id=0,
    merchant_id=0,npc_spells_id=0,skip_global_loot=1;
INSERT INTO npc_types SELECT * FROM por_npc;
DELETE FROM por_npc;
INSERT INTO por_npc SELECT * FROM npc_types WHERE id=371049;
IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Missing PoR actor donor 371049'; END IF;
UPDATE por_npc SET id=371963,name='Tallongast_the_Discarded',level=74,hp=110000,loottable_id=0,
    merchant_id=0,npc_spells_id=0,skip_global_loot=1, maxdmg=2000;
INSERT INTO npc_types SELECT * FROM por_npc;
DELETE FROM por_npc;
INSERT INTO por_npc SELECT * FROM npc_types WHERE id=371032;
IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Missing PoR actor donor 371032'; END IF;
UPDATE por_npc SET id=371964,name='a_possessed_book',level=70,hp=12000,loottable_id=0,
    merchant_id=0,npc_spells_id=0,skip_global_loot=1;
INSERT INTO npc_types SELECT * FROM por_npc;
DELETE FROM por_npc;
INSERT INTO por_npc SELECT * FROM npc_types WHERE id=371008;
IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Missing PoR actor donor 371008'; END IF;
UPDATE por_npc SET id=371965,name='a_skylance_bookworm',level=70,hp=12000,loottable_id=0,
    merchant_id=0,npc_spells_id=0,skip_global_loot=1;
INSERT INTO npc_types SELECT * FROM por_npc;
DELETE FROM por_npc;
INSERT INTO por_npc SELECT * FROM npc_types WHERE id=377010;
IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Missing PoR actor donor 377010'; END IF;
UPDATE por_npc SET id=377960,name='BeauDril_the_Queens_Defender',level=72,hp=72000,loottable_id=304084000,
    merchant_id=0,npc_spells_id=0,skip_global_loot=1, maxdmg=1200;
INSERT INTO npc_types SELECT * FROM por_npc;
DELETE FROM por_npc;
INSERT INTO por_npc SELECT * FROM npc_types WHERE id=376105;
IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Missing PoR actor donor 376105'; END IF;
UPDATE por_npc SET id=376960,name='a_priest_of_the_Burning_Prince',level=70,hp=47000,loottable_id=0,
    merchant_id=0,npc_spells_id=0,skip_global_loot=1;
INSERT INTO npc_types SELECT * FROM por_npc;
DELETE FROM por_npc;
INSERT INTO por_npc SELECT * FROM npc_types WHERE id=376093;
IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Missing PoR actor donor 376093'; END IF;
UPDATE por_npc SET id=376961,name='Prince_TakSalir',level=73,hp=100000,loottable_id=0,
    merchant_id=0,npc_spells_id=0,skip_global_loot=1, maxdmg=1850;
INSERT INTO npc_types SELECT * FROM por_npc;
DELETE FROM por_npc;
INSERT INTO por_npc SELECT * FROM npc_types WHERE id=371013;
IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Missing PoR actor donor 371013'; END IF;
UPDATE por_npc SET id=376962,name='a_royal_chest',level=65,hp=5500,loottable_id=304084001,
    merchant_id=0,npc_spells_id=0,skip_global_loot=1, class=62, npc_faction_id=0, aggroradius=0, assistradius=0;
INSERT INTO npc_types SELECT * FROM por_npc;
DELETE FROM por_npc;
INSERT INTO por_npc SELECT * FROM npc_types WHERE id=371013;
IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Missing PoR actor donor 371013'; END IF;
UPDATE por_npc SET id=376963,name='a_royal_chest',level=65,hp=5500,loottable_id=304084002,
    merchant_id=0,npc_spells_id=0,skip_global_loot=1, class=62, npc_faction_id=0, aggroradius=0, assistradius=0;
INSERT INTO npc_types SELECT * FROM por_npc;
DELETE FROM por_npc;
INSERT INTO por_npc SELECT * FROM npc_types WHERE id=376105;
IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Missing PoR actor donor 376105'; END IF;
UPDATE por_npc SET id=376964,name='High_Priest_Kelshar',level=73,hp=85000,loottable_id=304084003,
    merchant_id=0,npc_spells_id=0,skip_global_loot=1;
INSERT INTO npc_types SELECT * FROM por_npc;
DELETE FROM por_npc;
INSERT INTO por_npc SELECT * FROM npc_types WHERE id=376035;
IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Missing PoR actor donor 376035'; END IF;
UPDATE por_npc SET id=376965,name='a_sand_elf_guard',level=71,hp=38000,loottable_id=0,
    merchant_id=0,npc_spells_id=0,skip_global_loot=1;
INSERT INTO npc_types SELECT * FROM por_npc;
DELETE FROM por_npc;
INSERT INTO por_npc SELECT * FROM npc_types WHERE id=375027;
IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Missing PoR actor donor 375027'; END IF;
UPDATE por_npc SET id=375960,name='a_shadow_of_rage',level=72,hp=50000,loottable_id=0,
    merchant_id=0,npc_spells_id=0,skip_global_loot=1;
INSERT INTO npc_types SELECT * FROM por_npc;
DELETE FROM por_npc;
DROP TEMPORARY TABLE por_npc;
IF EXISTS (SELECT 1 FROM loottable WHERE id BETWEEN 304084000 AND 304084003) OR EXISTS (SELECT 1 FROM lootdrop WHERE id BETWEEN 304084256 AND 304084259) OR (SELECT COUNT(*) FROM items WHERE id IN (36139,84152,84153,84154))<>4 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'PoR objective loot differs';
END IF;
INSERT INTO loottable (id,name) VALUES
    (304084000, 'PoR objective 36139'),
    (304084001, 'PoR objective 84152'),
    (304084002, 'PoR objective 84153'),
    (304084003, 'PoR objective 84154');
INSERT INTO lootdrop (id,name) VALUES
    (304084256, 'PoR objective 36139'),
    (304084257, 'PoR objective 84152'),
    (304084258, 'PoR objective 84153'),
    (304084259, 'PoR objective 84154');
INSERT INTO loottable_entries (loottable_id,lootdrop_id,multiplier,droplimit,mindrop,probability) VALUES
    (304084000, 304084256, 1, 0, 0, 100),
    (304084001, 304084257, 1, 0, 0, 100),
    (304084002, 304084258, 1, 0, 0, 100),
    (304084003, 304084259, 1, 0, 0, 100);
INSERT INTO lootdrop_entries (lootdrop_id,item_id,item_charges,equip_item,chance) VALUES
    (304084256, 36139, 1, 0, 100),
    (304084257, 84152, 1, 0, 100),
    (304084258, 84153, 1, 0, 100),
    (304084259, 84154, 1, 0, 100);
IF EXISTS (SELECT 1 FROM zone WHERE id BETWEEN 6300 AND 6306)
OR EXISTS (SELECT 1 FROM zone WHERE (zoneidnumber,version) IN ((371,10),(371,11),(371,12),(375,10),(377,10),(376,10),(376,11)))
OR EXISTS (SELECT 1 FROM dynamic_zone_templates WHERE id BETWEEN 920300 AND 920309)
OR EXISTS (SELECT 1 FROM spawn2 WHERE id BETWEEN 304080000 AND 304083583)
OR EXISTS (SELECT 1 FROM spawnentry WHERE spawngroupID BETWEEN 304080000 AND 304083583)
OR EXISTS (SELECT 1 FROM spawngroup WHERE id BETWEEN 304080000 AND 304083583)
OR EXISTS (SELECT 1 FROM doors WHERE id BETWEEN 304080000 AND 304083583) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'PoR owned layout IDs are occupied';
END IF;
CREATE TEMPORARY TABLE por_zone LIKE zone;
CREATE TEMPORARY TABLE por_spawn2 LIKE spawn2;
CREATE TEMPORARY TABLE por_doors LIKE doors;
CREATE TEMPORARY TABLE por_placement (old_id INT PRIMARY KEY,new_id INT UNIQUE NOT NULL,old_group INT NOT NULL) ENGINE=InnoDB;

-- skylance v10, owned template 920300
INSERT INTO por_zone SELECT * FROM zone WHERE id=346 AND zoneidnumber=371 AND short_name='skylance' AND version=0;
IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Missing retained zone 346'; END IF;
UPDATE por_zone SET id=6300, version=10, min_status=0, flag_needed='';
INSERT INTO zone SELECT * FROM por_zone;
DELETE FROM por_zone;
INSERT INTO por_placement
SELECT s.id, 304080000-1+ROW_NUMBER() OVER(ORDER BY s.id), s.spawngroupID
FROM spawn2 s
WHERE s.zone='skylance' AND s.version=0 AND EXISTS (
 SELECT 1 FROM spawnentry e JOIN npc_types n ON n.id=e.npcID
 WHERE e.spawngroupID=s.spawngroupID AND (n.id IN (371000,371001,371002,371003,371004,371005,371006,371018,371025,371028,371030,371032,371033,371036,371037,371038,371042,371048,371049,371051))
);
IF ROW_COUNT() NOT BETWEEN 1 AND 180 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Unexpected retained placement count'; END IF;
INSERT INTO spawngroup (id,name) SELECT new_id,CONCAT('por_920300_',old_id) FROM por_placement;
INSERT INTO spawnentry (spawngroupID,npcID,chance)
SELECT p.new_id,e.npcID,e.chance
FROM por_placement p JOIN spawnentry e ON e.spawngroupID=p.old_group
;

IF EXISTS (SELECT 1 FROM por_placement p LEFT JOIN spawnentry e ON e.spawngroupID=p.new_id
   GROUP BY p.new_id HAVING COALESCE(SUM(e.chance),0)<>100) THEN
 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='PoR spawn group must preserve a complete roster';
END IF;
INSERT INTO por_spawn2 SELECT s.* FROM spawn2 s JOIN por_placement p ON p.old_id=s.id;
UPDATE por_spawn2 s JOIN por_placement p ON p.old_id=s.id
SET s.id=p.new_id,s.spawngroupID=p.new_id,s.version=10,s.pathgrid=0,s._condition=0,s.cond_value=1;
INSERT INTO spawn2 SELECT * FROM por_spawn2;
DELETE FROM por_spawn2;
DELETE FROM por_placement;
INSERT INTO por_doors SELECT * FROM doors WHERE zone='skylance' AND version=0;
UPDATE por_doors SET id=304080000+255+doorid, version=10;
INSERT INTO doors SELECT * FROM por_doors;
DELETE FROM por_doors;

-- skylance v11, owned template 920301
INSERT INTO por_zone SELECT * FROM zone WHERE id=346 AND zoneidnumber=371 AND short_name='skylance' AND version=0;
IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Missing retained zone 346'; END IF;
UPDATE por_zone SET id=6301, version=11, min_status=0, flag_needed='';
INSERT INTO zone SELECT * FROM por_zone;
DELETE FROM por_zone;
INSERT INTO por_placement
SELECT s.id, 304080512-1+ROW_NUMBER() OVER(ORDER BY s.id), s.spawngroupID
FROM spawn2 s
WHERE s.zone='skylance' AND s.version=0 AND EXISTS (
 SELECT 1 FROM spawnentry e JOIN npc_types n ON n.id=e.npcID
 WHERE e.spawngroupID=s.spawngroupID AND (n.id BETWEEN 371000 AND 371006 OR n.id IN (371008,371009,371010,371011,371012,371013,371014,371015,371016,371017,371020,371021,371022,371023,371024,371029,371050))
);
IF ROW_COUNT() NOT BETWEEN 1 AND 180 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Unexpected retained placement count'; END IF;
INSERT INTO spawngroup (id,name) SELECT new_id,CONCAT('por_920301_',old_id) FROM por_placement;
INSERT INTO spawnentry (spawngroupID,npcID,chance)
SELECT p.new_id,e.npcID,e.chance
FROM por_placement p JOIN spawnentry e ON e.spawngroupID=p.old_group
;

IF EXISTS (SELECT 1 FROM por_placement p LEFT JOIN spawnentry e ON e.spawngroupID=p.new_id
   GROUP BY p.new_id HAVING COALESCE(SUM(e.chance),0)<>100) THEN
 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='PoR spawn group must preserve a complete roster';
END IF;
INSERT INTO por_spawn2 SELECT s.* FROM spawn2 s JOIN por_placement p ON p.old_id=s.id;
UPDATE por_spawn2 s JOIN por_placement p ON p.old_id=s.id
SET s.id=p.new_id,s.spawngroupID=p.new_id,s.version=11,s.pathgrid=0,s._condition=0,s.cond_value=1;
INSERT INTO spawn2 SELECT * FROM por_spawn2;
DELETE FROM por_spawn2;
DELETE FROM por_placement;
INSERT INTO por_doors SELECT * FROM doors WHERE zone='skylance' AND version=0;
UPDATE por_doors SET id=304080512+255+doorid, version=11;
INSERT INTO doors SELECT * FROM por_doors;
DELETE FROM por_doors;

-- skylance v12, owned template 920302
INSERT INTO por_zone SELECT * FROM zone WHERE id=346 AND zoneidnumber=371 AND short_name='skylance' AND version=0;
IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Missing retained zone 346'; END IF;
UPDATE por_zone SET id=6302, version=12, min_status=0, flag_needed='';
INSERT INTO zone SELECT * FROM por_zone;
DELETE FROM por_zone;
INSERT INTO por_placement
SELECT s.id, 304081024-1+ROW_NUMBER() OVER(ORDER BY s.id), s.spawngroupID
FROM spawn2 s
WHERE s.zone='skylance' AND s.version=0 AND EXISTS (
 SELECT 1 FROM spawnentry e JOIN npc_types n ON n.id=e.npcID
 WHERE e.spawngroupID=s.spawngroupID AND (n.id BETWEEN 371000 AND 371006)
);
IF ROW_COUNT() NOT BETWEEN 1 AND 180 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Unexpected retained placement count'; END IF;
INSERT INTO spawngroup (id,name) SELECT new_id,CONCAT('por_920302_',old_id) FROM por_placement;
INSERT INTO spawnentry (spawngroupID,npcID,chance)
SELECT p.new_id,e.npcID,e.chance
FROM por_placement p JOIN spawnentry e ON e.spawngroupID=p.old_group
;

IF EXISTS (SELECT 1 FROM por_placement p LEFT JOIN spawnentry e ON e.spawngroupID=p.new_id
   GROUP BY p.new_id HAVING COALESCE(SUM(e.chance),0)<>100) THEN
 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='PoR spawn group must preserve a complete roster';
END IF;
INSERT INTO por_spawn2 SELECT s.* FROM spawn2 s JOIN por_placement p ON p.old_id=s.id;
UPDATE por_spawn2 s JOIN por_placement p ON p.old_id=s.id
SET s.id=p.new_id,s.spawngroupID=p.new_id,s.version=12,s.pathgrid=0,s._condition=0,s.cond_value=1;
INSERT INTO spawn2 SELECT * FROM por_spawn2;
DELETE FROM por_spawn2;
DELETE FROM por_placement;
INSERT INTO por_doors SELECT * FROM doors WHERE zone='skylance' AND version=0;
UPDATE por_doors SET id=304081024+255+doorid, version=12;
INSERT INTO doors SELECT * FROM por_doors;
DELETE FROM por_doors;

-- ragea v10, owned template 920306
INSERT INTO por_zone SELECT * FROM zone WHERE id=310 AND zoneidnumber=375 AND short_name='ragea' AND version=0;
IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Missing retained zone 310'; END IF;
UPDATE por_zone SET id=6303, version=10, min_status=0, flag_needed='';
INSERT INTO zone SELECT * FROM por_zone;
DELETE FROM por_zone;
INSERT INTO por_placement
SELECT s.id, 304081536-1+ROW_NUMBER() OVER(ORDER BY s.id), s.spawngroupID
FROM spawn2 s
WHERE s.zone='ragea' AND s.version=0 AND EXISTS (
 SELECT 1 FROM spawnentry e JOIN npc_types n ON n.id=e.npcID
 WHERE e.spawngroupID=s.spawngroupID AND (n.id BETWEEN 375001 AND 375065)
);
IF ROW_COUNT() NOT BETWEEN 1 AND 180 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Unexpected retained placement count'; END IF;
INSERT INTO spawngroup (id,name) SELECT new_id,CONCAT('por_920306_',old_id) FROM por_placement;
INSERT INTO spawnentry (spawngroupID,npcID,chance)
SELECT p.new_id,e.npcID,e.chance
FROM por_placement p JOIN spawnentry e ON e.spawngroupID=p.old_group
;

IF EXISTS (SELECT 1 FROM por_placement p LEFT JOIN spawnentry e ON e.spawngroupID=p.new_id
   GROUP BY p.new_id HAVING COALESCE(SUM(e.chance),0)<>100) THEN
 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='PoR spawn group must preserve a complete roster';
END IF;
INSERT INTO por_spawn2 SELECT s.* FROM spawn2 s JOIN por_placement p ON p.old_id=s.id;
UPDATE por_spawn2 s JOIN por_placement p ON p.old_id=s.id
SET s.id=p.new_id,s.spawngroupID=p.new_id,s.version=10,s.pathgrid=0,s._condition=0,s.cond_value=1;
INSERT INTO spawn2 SELECT * FROM por_spawn2;
DELETE FROM por_spawn2;
DELETE FROM por_placement;
INSERT INTO por_doors SELECT * FROM doors WHERE zone='ragea' AND version=0;
UPDATE por_doors SET id=304081536+255+doorid, version=10;
INSERT INTO doors SELECT * FROM por_doors;
DELETE FROM por_doors;

-- takishruinsa v10, owned template 920307
INSERT INTO por_zone SELECT * FROM zone WHERE id=386 AND zoneidnumber=377 AND short_name='takishruinsa' AND version=0;
IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Missing retained zone 386'; END IF;
UPDATE por_zone SET id=6304, version=10, min_status=0, flag_needed='';
INSERT INTO zone SELECT * FROM por_zone;
DELETE FROM por_zone;
INSERT INTO por_placement
SELECT s.id, 304082048-1+ROW_NUMBER() OVER(ORDER BY s.id), s.spawngroupID
FROM spawn2 s
WHERE s.zone='takishruinsa' AND s.version=0 AND EXISTS (
 SELECT 1 FROM spawnentry e JOIN npc_types n ON n.id=e.npcID
 WHERE e.spawngroupID=s.spawngroupID AND (n.id BETWEEN 377000 AND 377015)
);
IF ROW_COUNT() NOT BETWEEN 1 AND 180 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Unexpected retained placement count'; END IF;
INSERT INTO spawngroup (id,name) SELECT new_id,CONCAT('por_920307_',old_id) FROM por_placement;
INSERT INTO spawnentry (spawngroupID,npcID,chance)
SELECT p.new_id,e.npcID,e.chance
FROM por_placement p JOIN spawnentry e ON e.spawngroupID=p.old_group
;

IF (SELECT COUNT(*) FROM por_placement WHERE old_id=130686)<>1 THEN
 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='PoR encounter anchor 130686 is missing'; END IF;
DELETE e FROM spawnentry e JOIN por_placement p ON p.new_id=e.spawngroupID WHERE p.old_id=130686;
INSERT INTO spawnentry (spawngroupID,npcID,chance) SELECT new_id,377960,100 FROM por_placement WHERE old_id=130686;

IF EXISTS (SELECT 1 FROM por_placement p LEFT JOIN spawnentry e ON e.spawngroupID=p.new_id
   GROUP BY p.new_id HAVING COALESCE(SUM(e.chance),0)<>100) THEN
 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='PoR spawn group must preserve a complete roster';
END IF;
INSERT INTO por_spawn2 SELECT s.* FROM spawn2 s JOIN por_placement p ON p.old_id=s.id;
UPDATE por_spawn2 s JOIN por_placement p ON p.old_id=s.id
SET s.id=p.new_id,s.spawngroupID=p.new_id,s.version=10,s.pathgrid=0,s._condition=0,s.cond_value=1;
INSERT INTO spawn2 SELECT * FROM por_spawn2;
DELETE FROM por_spawn2;
DELETE FROM por_placement;
INSERT INTO por_doors SELECT * FROM doors WHERE zone='takishruinsa' AND version=0;
UPDATE por_doors SET id=304082048+255+doorid, version=10;
INSERT INTO doors SELECT * FROM por_doors;
DELETE FROM por_doors;

-- takishruins v10, owned template 920308
INSERT INTO por_zone SELECT * FROM zone WHERE id=385 AND zoneidnumber=376 AND short_name='takishruins' AND version=0;
IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Missing retained zone 385'; END IF;
UPDATE por_zone SET id=6305, version=10, min_status=0, flag_needed='';
INSERT INTO zone SELECT * FROM por_zone;
DELETE FROM por_zone;
INSERT INTO por_placement
SELECT s.id, 304082560-1+ROW_NUMBER() OVER(ORDER BY s.id), s.spawngroupID
FROM spawn2 s
WHERE s.zone='takishruins' AND s.version=0 AND EXISTS (
 SELECT 1 FROM spawnentry e JOIN npc_types n ON n.id=e.npcID
 WHERE e.spawngroupID=s.spawngroupID AND (n.id IN (376012,376035,376051,376052,376061,376071,376075,376077,376095,376105,376107))
);
IF ROW_COUNT() NOT BETWEEN 1 AND 180 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Unexpected retained placement count'; END IF;
INSERT INTO spawngroup (id,name) SELECT new_id,CONCAT('por_920308_',old_id) FROM por_placement;
INSERT INTO spawnentry (spawngroupID,npcID,chance)
SELECT p.new_id,e.npcID,e.chance
FROM por_placement p JOIN spawnentry e ON e.spawngroupID=p.old_group
;

IF (SELECT COUNT(*) FROM por_placement WHERE old_id=106795)<>1 THEN
 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='PoR encounter anchor 106795 is missing'; END IF;
DELETE e FROM spawnentry e JOIN por_placement p ON p.new_id=e.spawngroupID WHERE p.old_id=106795;
INSERT INTO spawnentry (spawngroupID,npcID,chance) SELECT new_id,376960,100 FROM por_placement WHERE old_id=106795;

IF (SELECT COUNT(*) FROM por_placement WHERE old_id=106824)<>1 THEN
 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='PoR encounter anchor 106824 is missing'; END IF;
DELETE e FROM spawnentry e JOIN por_placement p ON p.new_id=e.spawngroupID WHERE p.old_id=106824;
INSERT INTO spawnentry (spawngroupID,npcID,chance) SELECT new_id,376960,100 FROM por_placement WHERE old_id=106824;

IF (SELECT COUNT(*) FROM por_placement WHERE old_id=106924)<>1 THEN
 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='PoR encounter anchor 106924 is missing'; END IF;
DELETE e FROM spawnentry e JOIN por_placement p ON p.new_id=e.spawngroupID WHERE p.old_id=106924;
INSERT INTO spawnentry (spawngroupID,npcID,chance) SELECT new_id,376960,100 FROM por_placement WHERE old_id=106924;

IF (SELECT COUNT(*) FROM por_placement WHERE old_id=106949)<>1 THEN
 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='PoR encounter anchor 106949 is missing'; END IF;
DELETE e FROM spawnentry e JOIN por_placement p ON p.new_id=e.spawngroupID WHERE p.old_id=106949;
INSERT INTO spawnentry (spawngroupID,npcID,chance) SELECT new_id,376960,100 FROM por_placement WHERE old_id=106949;

IF (SELECT COUNT(*) FROM por_placement WHERE old_id=106956)<>1 THEN
 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='PoR encounter anchor 106956 is missing'; END IF;
DELETE e FROM spawnentry e JOIN por_placement p ON p.new_id=e.spawngroupID WHERE p.old_id=106956;
INSERT INTO spawnentry (spawngroupID,npcID,chance) SELECT new_id,376960,100 FROM por_placement WHERE old_id=106956;

IF EXISTS (SELECT 1 FROM por_placement p LEFT JOIN spawnentry e ON e.spawngroupID=p.new_id
   GROUP BY p.new_id HAVING COALESCE(SUM(e.chance),0)<>100) THEN
 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='PoR spawn group must preserve a complete roster';
END IF;
INSERT INTO por_spawn2 SELECT s.* FROM spawn2 s JOIN por_placement p ON p.old_id=s.id;
UPDATE por_spawn2 s JOIN por_placement p ON p.old_id=s.id
SET s.id=p.new_id,s.spawngroupID=p.new_id,s.version=10,s.pathgrid=0,s._condition=0,s.cond_value=1;
INSERT INTO spawn2 SELECT * FROM por_spawn2;
DELETE FROM por_spawn2;
DELETE FROM por_placement;
INSERT INTO por_doors SELECT * FROM doors WHERE zone='takishruins' AND version=0;
UPDATE por_doors SET id=304082560+255+doorid, version=10;
INSERT INTO doors SELECT * FROM por_doors;
DELETE FROM por_doors;

-- takishruins v11, owned template 920309
INSERT INTO por_zone SELECT * FROM zone WHERE id=385 AND zoneidnumber=376 AND short_name='takishruins' AND version=0;
IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Missing retained zone 385'; END IF;
UPDATE por_zone SET id=6306, version=11, min_status=0, flag_needed='';
INSERT INTO zone SELECT * FROM por_zone;
DELETE FROM por_zone;
INSERT INTO por_placement
SELECT s.id, 304083072-1+ROW_NUMBER() OVER(ORDER BY s.id), s.spawngroupID
FROM spawn2 s
WHERE s.zone='takishruins' AND s.version=0 AND EXISTS (
 SELECT 1 FROM spawnentry e JOIN npc_types n ON n.id=e.npcID
 WHERE e.spawngroupID=s.spawngroupID AND (n.id IN (376005,376006,376009,376012,376017,376035,376052,376068,376071,376073,376095,376105,376107))
);
IF ROW_COUNT() NOT BETWEEN 1 AND 180 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Unexpected retained placement count'; END IF;
INSERT INTO spawngroup (id,name) SELECT new_id,CONCAT('por_920309_',old_id) FROM por_placement;
INSERT INTO spawnentry (spawngroupID,npcID,chance)
SELECT p.new_id,e.npcID,e.chance
FROM por_placement p JOIN spawnentry e ON e.spawngroupID=p.old_group
;

IF (SELECT COUNT(*) FROM por_placement WHERE old_id=106788)<>1 THEN
 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='PoR encounter anchor 106788 is missing'; END IF;
DELETE e FROM spawnentry e JOIN por_placement p ON p.new_id=e.spawngroupID WHERE p.old_id=106788;
INSERT INTO spawnentry (spawngroupID,npcID,chance) SELECT new_id,376962,100 FROM por_placement WHERE old_id=106788;

IF (SELECT COUNT(*) FROM por_placement WHERE old_id=106795)<>1 THEN
 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='PoR encounter anchor 106795 is missing'; END IF;
DELETE e FROM spawnentry e JOIN por_placement p ON p.new_id=e.spawngroupID WHERE p.old_id=106795;
INSERT INTO spawnentry (spawngroupID,npcID,chance) SELECT new_id,376963,100 FROM por_placement WHERE old_id=106795;

IF (SELECT COUNT(*) FROM por_placement WHERE old_id=106949)<>1 THEN
 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='PoR encounter anchor 106949 is missing'; END IF;
DELETE e FROM spawnentry e JOIN por_placement p ON p.new_id=e.spawngroupID WHERE p.old_id=106949;
INSERT INTO spawnentry (spawngroupID,npcID,chance) SELECT new_id,376964,100 FROM por_placement WHERE old_id=106949;

IF EXISTS (SELECT 1 FROM por_placement p LEFT JOIN spawnentry e ON e.spawngroupID=p.new_id
   GROUP BY p.new_id HAVING COALESCE(SUM(e.chance),0)<>100) THEN
 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='PoR spawn group must preserve a complete roster';
END IF;
INSERT INTO por_spawn2 SELECT s.* FROM spawn2 s JOIN por_placement p ON p.old_id=s.id;
UPDATE por_spawn2 s JOIN por_placement p ON p.old_id=s.id
SET s.id=p.new_id,s.spawngroupID=p.new_id,s.version=11,s.pathgrid=0,s._condition=0,s.cond_value=1;
INSERT INTO spawn2 SELECT * FROM por_spawn2;
DELETE FROM por_spawn2;
DELETE FROM por_placement;
INSERT INTO por_doors SELECT * FROM doors WHERE zone='takishruins' AND version=0;
UPDATE por_doors SET id=304083072+255+doorid, version=11;
INSERT INTO doors SELECT * FROM por_doors;
DELETE FROM por_doors;
DROP TEMPORARY TABLE por_zone,por_spawn2,por_doors,por_placement;
INSERT INTO dynamic_zone_templates
    (id,zone_id,zone_version,name,min_players,max_players,duration_seconds,return_zone_id,
     return_x,return_y,return_z,return_h,override_zone_in,zone_in_x,zone_in_y,zone_in_z,zone_in_h)
VALUES
    (920300, 371, 10, 'Skylance: The Library', 3, 6, 21600, 369, -957, 241, 409, 0, 1, 0, -95, 2, 0),
    (920301, 371, 11, 'Skylance: The Oubliette', 3, 6, 21600, 369, -957, 241, 409, 0, 1, 0, -95, 2, 0),
    (920302, 371, 12, 'Skylance: The Laboratory', 3, 6, 21600, 369, -957, 241, 409, 0, 1, 0, -95, 2, 0),
    (920306, 375, 10, 'Samples of Corruption', 3, 6, 21600, 374, 0, 87, 31.7, 0, 1, 354, 63, 3, 0),
    (920307, 377, 10, 'The Key to the Past', 3, 6, 21600, 376, -553.7, 735.3, 225.2, 0, 1, 18, -138, -29, 0),
    (920308, 376, 10, 'The Burning Prince', 3, 6, 21600, 392, -2073, 5946, 35.125, 0, 1, -983, 269, 62, 0),
    (920309, 376, 11, 'Message to the Past', 3, 6, 21600, 392, -2073, 5946, 35.125, 0, 1, -983, 269, 62, 0);
IF (SELECT COUNT(*) FROM zone WHERE version=0 AND min_status=80
    AND (id,zoneidnumber) IN ((8,369),(67,372),(105,378),(309,374),(385,376),(391,380)))<>6
   OR NOT EXISTS (SELECT 1 FROM zone WHERE id=391 AND zoneidnumber=380 AND min_level=0 AND flag_needed='')
   OR NOT EXISTS (SELECT 1 FROM doors WHERE id=16772 AND doorid=3 AND zone='freeporteast'
      AND version=0 AND name='OBJ_SULLONZEK' AND dest_zone='NONE' AND keyitem=0) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='PoR public access preimage differs';
END IF;
UPDATE zone SET min_status=0 WHERE id IN (8,67,105,309,385) AND version=0 AND min_status=80;
IF ROW_COUNT()<>5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='PoR public access row count differs'; END IF;
UPDATE zone SET min_status=0,min_level=68 WHERE id=391 AND zoneidnumber=380 AND version=0 AND min_status=80;
IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Theater admission row count differs'; END IF;
UPDATE doors SET opentype=58,dest_zone='devastation',dest_x=1390,dest_y=216,dest_z=53,dest_heading=0
WHERE id=16772 AND zone='freeporteast' AND doorid=3 AND version=0 AND dest_zone='NONE';
IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Sullon statue transport row count differs'; END IF;
IF (SELECT COUNT(*) FROM tasks WHERE id BETWEEN 920300 AND 920339 AND enabled=0)<>23
   OR (SELECT COUNT(*) FROM dynamic_zone_templates WHERE id BETWEEN 920300 AND 920309)<>7 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='PoR disabled content postimage differs';
END IF;
COMMIT;
END//
DELIMITER ;
