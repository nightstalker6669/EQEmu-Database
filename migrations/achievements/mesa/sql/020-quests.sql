-- Mesa complete package dependency; import all four SQL files and scripts in order. Capture3040411 remains disabled.
SET NAMES utf8mb4;
SET SESSION check_constraint_checks=1;
DROP TEMPORARY TABLE IF EXISTS _mesa_guard;
CREATE TEMPORARY TABLE _mesa_guard(label VARCHAR(80)PRIMARY KEY,ok TINYINT NOT NULL,CHECK(ok=1))ENGINE=InnoDB;
INSERT INTO _mesa_guard VALUES('tasks',(NOT EXISTS(SELECT 1 FROM tasks WHERE id IN(3040401,3040402,3040403,3040404,3040405,3040406,3040407,3040408,3040409,3040410,3040411,3040412,3040413,3040414,3040415,3040416,3040417,3040418,3040419,3040420)AND NOT((id=3040401 AND type=2 AND title='Minohten Mushrooms') OR (id=3040402 AND type=2 AND title='No Place Like Home') OR (id=3040403 AND type=2 AND title='Reduce the Scouts') OR (id=3040404 AND type=2 AND title='Tuffein Mushrooms') OR (id=3040405 AND type=2 AND title='To Dull the Edge') OR (id=3040406 AND type=2 AND title='These Biscuits are Awfully Hard') OR (id=3040407 AND type=2 AND title='We Need Supplies') OR (id=3040408 AND type=2 AND title='Protect the Tuffein') OR (id=3040409 AND type=2 AND title='More Supplies for Devan') OR (id=3040410 AND type=2 AND title='Nymphs are a menace!') OR (id=3040411 AND type=2 AND title='Minohten are a menace!') OR (id=3040412 AND type=2 AND title='Smoke Them Out') OR (id=3040413 AND type=2 AND title='Pluck Their Wings') OR (id=3040414 AND type=2 AND title='Make Gravel') OR (id=3040415 AND type=2 AND title='Pull Their Hair') OR (id=3040416 AND type=2 AND title='Research the Dromrek') OR (id=3040417 AND type=2 AND title='Parlay with the Dromrek') OR (id=3040418 AND type=2 AND title='Soothe the Savage Beast?') OR (id=3040419 AND type=2 AND title='Parlay with the Dromrek, Again') OR (id=3040420 AND type=2 AND title='Reduce the Dromrek Threat')))));
INSERT INTO _mesa_guard VALUES('components',((SELECT COUNT(*)FROM achievement_components WHERE component_type=1 AND((achievement_id=500040200 AND component_id=50106 AND sequence=1 AND name='Costica - Minohten Mushrooms') OR (achievement_id=500040200 AND component_id=50107 AND sequence=2 AND name='Costica - No Place Like Home') OR (achievement_id=500040200 AND component_id=50108 AND sequence=3 AND name='Costica - Reduce the Scouts') OR (achievement_id=500040200 AND component_id=50109 AND sequence=4 AND name='Sorin - Tuffein Mushrooms') OR (achievement_id=500040200 AND component_id=50110 AND sequence=5 AND name='Sorin - To Dull the Edge') OR (achievement_id=500040200 AND component_id=50111 AND sequence=6 AND name='Sorin - These Biscuits are Awfully Hard') OR (achievement_id=500040200 AND component_id=50112 AND sequence=7 AND name='Devan - We Need Supplies') OR (achievement_id=500040200 AND component_id=50113 AND sequence=8 AND name='Devan - Protect the Tuffein') OR (achievement_id=500040200 AND component_id=50114 AND sequence=9 AND name='Devan - More Supplies for Devan') OR (achievement_id=500040200 AND component_id=50115 AND sequence=10 AND name='Devan - Nymphs are a menace!') OR (achievement_id=500040200 AND component_id=50116 AND sequence=11 AND name='Devan - Minohten are a menace!') OR (achievement_id=500040300 AND component_id=50117 AND sequence=1 AND name='Iulia - Smoke Them Out') OR (achievement_id=500040300 AND component_id=50118 AND sequence=2 AND name='Iulia - Pluck Their Wings') OR (achievement_id=500040300 AND component_id=50119 AND sequence=3 AND name='Nedelcu - Make Gravel') OR (achievement_id=500040300 AND component_id=50120 AND sequence=4 AND name='Nedelcu - Pull Their Hair') OR (achievement_id=500040300 AND component_id=50121 AND sequence=5 AND name='Scout Madu - Research the Dromrek') OR (achievement_id=500040300 AND component_id=50122 AND sequence=6 AND name='Scout Madu - Parlay with the Dromrek') OR (achievement_id=500040300 AND component_id=50123 AND sequence=7 AND name='Scout Madu - Soothe the Savage Beast?') OR (achievement_id=500040300 AND component_id=50124 AND sequence=8 AND name='Scout Madu - Parlay with the Dromrek, Again') OR (achievement_id=500040300 AND component_id=50125 AND sequence=9 AND name='Scout Madu - Reduce the Dromrek Threat')))=20));
INSERT INTO _mesa_guard VALUES('items',((SELECT COUNT(*)FROM items WHERE (id=13041 AND Name='Spider Silk' AND classes=65535) OR (id=13751 AND Name='Medium Quality Bear Skin' AND classes=65535) OR (id=13754 AND Name='Medium Quality Wolf Skin' AND classes=65535) OR (id=21790 AND Name='Minohten Fruit' AND classes=65535) OR (id=21791 AND Name='Minohten Vegetables' AND classes=65535) OR (id=21792 AND Name='Minohten Short Beer' AND classes=65535) OR (id=53554 AND Name='Crystalwing Plate Vambraces' AND classes=151) OR (id=53555 AND Name='Crystalwing Chain Bracelet' AND classes=33544) OR (id=53556 AND Name='Crystalwing Leather Vambraces' AND classes=16480) OR (id=53557 AND Name='Crystalwing Silk Bracelet' AND classes=15360) OR (id=53568 AND Name='Crystalwing Goru`kar Scout Health Stone' AND classes=65535) OR (id=53569 AND Name='Crystalwing Goru`kar Scout Power Stone' AND classes=65535) OR (id=53570 AND Name='Crystalwing Goru`kar Scout Shielding Stone' AND classes=65535) OR (id=53571 AND Name='Crystalwing Goru`kar Scout Striker Stone' AND classes=65535) OR (id=87210 AND Name='Crate of Tuffein Fruit' AND classes=65535) OR (id=87211 AND Name='Barrel of Tuffein Oats' AND classes=65535) OR (id=87212 AND Name='Pile of Rocks' AND classes=65535) OR (id=88121 AND Name='Snake Skin' AND classes=65535) OR (id=88130 AND Name='Bixie Dust Wand' AND classes=65535) OR (id=88131 AND Name='Refined Jumjum Pollen' AND classes=65535) OR (id=88132 AND Name='Burning Stick' AND classes=65535) OR (id=88133 AND Name='Napaea Wing' AND classes=65535) OR (id=88134 AND Name='Oread Hair' AND classes=65535) OR (id=88135 AND Name='Polished Lake Stone' AND classes=65535))=24));
INSERT INTO _mesa_guard VALUES('npcs',((SELECT COUNT(*)FROM npc_types WHERE (id=394164 AND name='Master_Vanguard_Regan') OR (id=394227 AND name='#Librarian_Hemfar') OR (id=394228 AND name='Alchemist_Naeema') OR (id=395210 AND name='Scout_Ethaniel') OR (id=397003 AND name='a_mesa_snake') OR (id=397007 AND name='Scout_Madu') OR (id=397008 AND name='a_mesa_snake') OR (id=397010 AND name='a_mesa_snake') OR (id=397013 AND name='Devan') OR (id=397014 AND name='Costica') OR (id=397019 AND name='a_protector_of_the_windwillow') OR (id=397021 AND name='a_Minohten_scout') OR (id=397024 AND name='a_Minohten_scout') OR (id=397028 AND name='a_rack_of_weapons') OR (id=397032 AND name='a_protector_of_the_windwillow') OR (id=397033 AND name='a_Minohten_scout') OR (id=397038 AND name='a_Minohten_scout') OR (id=397046 AND name='a_potameid_matron') OR (id=397050 AND name='a_Minohten_scout') OR (id=397054 AND name='a_napaea_striker') OR (id=397055 AND name='a_napaea_windstriker') OR (id=397057 AND name='a_napaea_striker') OR (id=397062 AND name='a_protector_of_the_windwillow') OR (id=397068 AND name='a_napaea_protector') OR (id=397077 AND name='a_napaea_striker') OR (id=397079 AND name='a_napaea_windstriker') OR (id=397080 AND name='a_protector_of_the_windwillow') OR (id=397082 AND name='a_napaea_maiden') OR (id=397083 AND name='Nedelcu') OR (id=397085 AND name='a_napaea_maiden') OR (id=397087 AND name='a_Minohten_tent') OR (id=397088 AND name='a_napaea_striker') OR (id=397089 AND name='a_mesa_recluse') OR (id=397094 AND name='a_napaea_maiden') OR (id=397095 AND name='Sorin') OR (id=397104 AND name='a_napaea_protector') OR (id=397107 AND name='a_potameid_maiden') OR (id=397113 AND name='a_potameid_maiden') OR (id=397114 AND name='a_potameid_maiden') OR (id=397115 AND name='a_protector_of_the_windwillow') OR (id=397116 AND name='an_oread_stonemistress') OR (id=397117 AND name='an_oread_maiden') OR (id=397119 AND name='Iulia') OR (id=397121 AND name='an_oread_stonehide') OR (id=397122 AND name='an_oread_protector') OR (id=397124 AND name='an_oread_protector') OR (id=397126 AND name='an_oread_stonehide') OR (id=397128 AND name='an_oread_stonemistress') OR (id=397129 AND name='a_potameid_matron') OR (id=397130 AND name='an_oread_stonehide') OR (id=397132 AND name='an_oread_maiden') OR (id=397133 AND name='a_large_mesa_recluse') OR (id=397134 AND name='an_oread_protector') OR (id=397135 AND name='a_mesa_recluse') OR (id=397137 AND name='an_oread_stonehide') OR (id=397141 AND name='a_mesa_recluse') OR (id=397142 AND name='a_potameid_maiden') OR (id=397143 AND name='a_potameid_matron') OR (id=397231 AND name='Bigone') OR (id=397233 AND name='a_potameid_noble') OR (id=397236 AND name='a_potameid_protector') OR (id=397237 AND name='a_potameid_noble') OR (id=397238 AND name='a_potameid_protector') OR (id=397240 AND name='a_potameid_retainer') OR (id=397242 AND name='a_potameid_retainer') OR (id=397243 AND name='Dromrek_Provisioner') OR (id=397244 AND name='a_potameid_retainer') OR (id=397251 AND name='Dromrek_Cook') OR (id=397255 AND name='Bashermaker') OR (id=397258 AND name='a_potameid_retainer') OR (id=397259 AND name='Foodpicker') OR (id=397262 AND name='a_potameid_protector'))=72));
INSERT INTO _mesa_guard VALUES('criterion_50106',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500040200 AND component_type=1 AND component_id=50106 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040401 AND target_id2=0 AND target_value=0 AND component_sequence=1 AND required_count=1 AND enabled=1))));
INSERT INTO _mesa_guard VALUES('criterion_50107',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500040200 AND component_type=1 AND component_id=50107 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040402 AND target_id2=0 AND target_value=0 AND component_sequence=2 AND required_count=1 AND enabled=1))));
INSERT INTO _mesa_guard VALUES('criterion_50108',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500040200 AND component_type=1 AND component_id=50108 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040403 AND target_id2=0 AND target_value=0 AND component_sequence=3 AND required_count=1 AND enabled=1))));
INSERT INTO _mesa_guard VALUES('criterion_50109',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500040200 AND component_type=1 AND component_id=50109 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040404 AND target_id2=0 AND target_value=0 AND component_sequence=4 AND required_count=1 AND enabled=1))));
INSERT INTO _mesa_guard VALUES('criterion_50110',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500040200 AND component_type=1 AND component_id=50110 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040405 AND target_id2=0 AND target_value=0 AND component_sequence=5 AND required_count=1 AND enabled=1))));
INSERT INTO _mesa_guard VALUES('criterion_50111',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500040200 AND component_type=1 AND component_id=50111 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040406 AND target_id2=0 AND target_value=0 AND component_sequence=6 AND required_count=1 AND enabled=1))));
INSERT INTO _mesa_guard VALUES('criterion_50112',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500040200 AND component_type=1 AND component_id=50112 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040407 AND target_id2=0 AND target_value=0 AND component_sequence=7 AND required_count=1 AND enabled=1))));
INSERT INTO _mesa_guard VALUES('criterion_50113',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500040200 AND component_type=1 AND component_id=50113 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040408 AND target_id2=0 AND target_value=0 AND component_sequence=8 AND required_count=1 AND enabled=1))));
INSERT INTO _mesa_guard VALUES('criterion_50114',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500040200 AND component_type=1 AND component_id=50114 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040409 AND target_id2=0 AND target_value=0 AND component_sequence=9 AND required_count=1 AND enabled=1))));
INSERT INTO _mesa_guard VALUES('criterion_50115',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500040200 AND component_type=1 AND component_id=50115 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040410 AND target_id2=0 AND target_value=0 AND component_sequence=10 AND required_count=1 AND enabled=1))));
INSERT INTO _mesa_guard VALUES('criterion_50116',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500040200 AND component_type=1 AND component_id=50116 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040411 AND target_id2=0 AND target_value=0 AND component_sequence=11 AND required_count=1 AND enabled=0))));
INSERT INTO _mesa_guard VALUES('reward_set_3040411',(NOT EXISTS(SELECT 1 FROM reward_sets WHERE reward_set_id=3040411 AND title<>'Minohten are a menace!')AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE reward_set_id=3040411 AND NOT(source_type=2 AND source_id=3040411))AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE source_type=2 AND source_id=3040411 AND reward_set_id<>3040411)));
INSERT INTO _mesa_guard VALUES('reward_30404111',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=30404111 AND description<>'May2013 Mesa option 30404111')AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=30404111 AND NOT(reward_set_id=3040411 AND option_id=1))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=30404111)));
INSERT INTO _mesa_guard VALUES('reward_30404112',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=30404112 AND description<>'May2013 Mesa option 30404112')AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=30404112 AND NOT(reward_set_id=3040411 AND option_id=2))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=30404112)));
INSERT INTO _mesa_guard VALUES('reward_30404113',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=30404113 AND description<>'May2013 Mesa option 30404113')AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=30404113 AND NOT(reward_set_id=3040411 AND option_id=3))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=30404113)));
INSERT INTO _mesa_guard VALUES('reward_30404114',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=30404114 AND description<>'May2013 Mesa option 30404114')AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=30404114 AND NOT(reward_set_id=3040411 AND option_id=4))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=30404114)));
INSERT INTO _mesa_guard VALUES('reward_30404115',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=30404115 AND description<>'May2013 Mesa option 30404115')AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=30404115 AND NOT(reward_set_id=3040411 AND option_id=5))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=30404115)));
INSERT INTO _mesa_guard VALUES('criterion_50117',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500040300 AND component_type=1 AND component_id=50117 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040412 AND target_id2=0 AND target_value=0 AND component_sequence=1 AND required_count=1 AND enabled=1))));
INSERT INTO _mesa_guard VALUES('criterion_50118',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500040300 AND component_type=1 AND component_id=50118 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040413 AND target_id2=0 AND target_value=0 AND component_sequence=2 AND required_count=1 AND enabled=1))));
INSERT INTO _mesa_guard VALUES('criterion_50119',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500040300 AND component_type=1 AND component_id=50119 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040414 AND target_id2=0 AND target_value=0 AND component_sequence=3 AND required_count=1 AND enabled=1))));
INSERT INTO _mesa_guard VALUES('criterion_50120',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500040300 AND component_type=1 AND component_id=50120 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040415 AND target_id2=0 AND target_value=0 AND component_sequence=4 AND required_count=1 AND enabled=1))));
INSERT INTO _mesa_guard VALUES('criterion_50121',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500040300 AND component_type=1 AND component_id=50121 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040416 AND target_id2=0 AND target_value=0 AND component_sequence=5 AND required_count=1 AND enabled=1))));
INSERT INTO _mesa_guard VALUES('criterion_50122',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500040300 AND component_type=1 AND component_id=50122 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040417 AND target_id2=0 AND target_value=0 AND component_sequence=6 AND required_count=1 AND enabled=1))));
INSERT INTO _mesa_guard VALUES('criterion_50123',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500040300 AND component_type=1 AND component_id=50123 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040418 AND target_id2=0 AND target_value=0 AND component_sequence=7 AND required_count=1 AND enabled=1))));
INSERT INTO _mesa_guard VALUES('criterion_50124',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500040300 AND component_type=1 AND component_id=50124 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040419 AND target_id2=0 AND target_value=0 AND component_sequence=8 AND required_count=1 AND enabled=1))));
INSERT INTO _mesa_guard VALUES('criterion_50125',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500040300 AND component_type=1 AND component_id=50125 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040420 AND target_id2=0 AND target_value=0 AND component_sequence=9 AND required_count=1 AND enabled=1))));
INSERT INTO _mesa_guard VALUES('reward_set_3040420',(NOT EXISTS(SELECT 1 FROM reward_sets WHERE reward_set_id=3040420 AND title<>'Reduce the Dromrek Threat')AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE reward_set_id=3040420 AND NOT(source_type=2 AND source_id=3040420))AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE source_type=2 AND source_id=3040420 AND reward_set_id<>3040420)));
INSERT INTO _mesa_guard VALUES('reward_30404201',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=30404201 AND description<>'May2013 Mesa option 30404201')AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=30404201 AND NOT(reward_set_id=3040420 AND option_id=1))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=30404201)));
INSERT INTO _mesa_guard VALUES('reward_30404202',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=30404202 AND description<>'May2013 Mesa option 30404202')AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=30404202 AND NOT(reward_set_id=3040420 AND option_id=2))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=30404202)));
INSERT INTO _mesa_guard VALUES('reward_30404203',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=30404203 AND description<>'May2013 Mesa option 30404203')AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=30404203 AND NOT(reward_set_id=3040420 AND option_id=3))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=30404203)));
INSERT INTO _mesa_guard VALUES('reward_30404204',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=30404204 AND description<>'May2013 Mesa option 30404204')AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=30404204 AND NOT(reward_set_id=3040420 AND option_id=4))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=30404204)));
INSERT INTO _mesa_guard VALUES('reward_30404205',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=30404205 AND description<>'May2013 Mesa option 30404205')AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=30404205 AND NOT(reward_set_id=3040420 AND option_id=5))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=30404205)));
INSERT INTO _mesa_guard VALUES('costica_faction_list',(NOT EXISTS(SELECT 1 FROM npc_faction WHERE id=397940 AND (name<>'May2013 Costica task rewards' OR primaryfaction<>0 OR ignore_primary_assist<>0))));
INSERT INTO _mesa_guard VALUES('costica_faction_entries',(NOT EXISTS(SELECT 1 FROM npc_faction_entries WHERE npc_faction_id=397940 AND NOT((faction_id=1107 AND value=5 AND npc_value=0 AND temp=0) OR (faction_id=1108 AND value=5 AND npc_value=0 AND temp=0) OR (faction_id=1109 AND value=-5 AND npc_value=0 AND temp=0) OR (faction_id=1110 AND value=-5 AND npc_value=0 AND temp=0)))));
INSERT INTO _mesa_guard VALUES('native_faction_names',((SELECT COUNT(*)FROM faction_list WHERE (id=1107 AND name='Tuffein')OR(id=1108 AND name='Tuffein Leadership')OR(id=1109 AND name='Minohten')OR(id=1110 AND name='Nymphs of the Windwillow'))=4));
START TRANSACTION;
INSERT INTO npc_faction(`id`,`name`,`primaryfaction`,`ignore_primary_assist`)VALUES
(397940,'May2013 Costica task rewards',0,0)
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`),`primaryfaction`=VALUES(`primaryfaction`),`ignore_primary_assist`=VALUES(`ignore_primary_assist`);
INSERT INTO npc_faction_entries(`npc_faction_id`,`faction_id`,`value`,`npc_value`,`temp`)VALUES
(397940,1107,5,0,0),
(397940,1108,5,0,0),
(397940,1109,-5,0,0),
(397940,1110,-5,0,0)
ON DUPLICATE KEY UPDATE `faction_id`=VALUES(`faction_id`),`value`=VALUES(`value`),`npc_value`=VALUES(`npc_value`),`temp`=VALUES(`temp`);
INSERT INTO tasks(`id`,`type`,`title`,`description`,`reward_text`,`reward_id_list`,`cash_reward`,`exp_reward`,`reward_method`,`min_level`,`repeatable`,`faction_reward`,`faction_amount`,`enabled`,`duration`)VALUES
(3040401,2,'Minohten Mushrooms','Find the Minohten camp; Steal mushrooms from the Minohten food sacks; Speak with Costica.','','',0,1000,0,40,1,397940,0,1,0),
(3040402,2,'No Place Like Home','Find the Minohten camp; Destroy the Minohten tents; Speak with Costica.','','',0,1000,0,40,1,397940,0,1,0),
(3040403,2,'Reduce the Scouts','Kill Minohten scouts; Speak with Costica.','','',0,1000,0,40,1,397940,0,1,0),
(3040404,2,'Tuffein Mushrooms','Explore the Tuffein camp; Steal food from the Tuffein camp; Return the stolen goods to Sorin.','','',0,1000,0,40,0,0,0,1,0),
(3040405,2,'To Dull the Edge','Make your way to the Tuffein camp; Destroy Tuffein weapons; Speak with Sorin.','','',0,1000,0,40,1,0,0,1,0),
(3040406,2,'These Biscuits are Awfully Hard','Explore the gnoll mining camp in the Moors; Collect piles of rocks; Sneak into the Tuffein camp; Replace food stores with rocks from the Gnoll camp; Speak with Sorin.','','',0,1000,0,40,1,0,0,1,0),
(3040407,2,'We Need Supplies','Steal fruit from the Minohten camp; Steal vegetables from the Minohten camp; Steal beer from the Minohten camp; Deliver Minohten Fruit to Devan; Deliver Minohten Vegetables to Devan; Deliver Minohten Short Beer to Devan; Speak with Devan.','','',0,1000,0,35,1,0,0,1,0),
(3040408,2,'Protect the Tuffein','Kill mesa snakes; Kill protectors of the windwillow; Kill mesa recluse spiders; Speak with Devan.','','',0,1000,0,40,1,0,0,1,0),
(3040409,2,'More Supplies for Devan','Loot Snake Skin in Goru`kar Mesa; Loot Spider Silk in Goru`kar Mesa; Loot Medium Quality Wolf Skin in Goru`kar Mesa; Loot Medium Quality Bear Skin in Goru`kar Mesa; Deliver Snake Skin to Devan; Deliver Spider Silk to Devan; Deliver Medium Quality Wolf Skin to Devan; Deliver Medium Quality Bear Skin to Devan; Speak with Devan.','','',0,1000,0,40,1,0,0,1,0),
(3040410,2,'Nymphs are a menace!','Kill napaea; Kill potameid; Kill oread; Speak with Devan.','','',0,1000,0,40,1,0,0,1,0),
(3040411,2,'Minohten are a menace!','Kill Minohten scouts; Speak with Devan; Find a way to free yourself from the cage; Flee west from the Tuffein camp; Flee to Scout Madu to be certain you have escaped; Speak with Scout Madu.','','',0,0,3,40,1,0,0,0,0),
(3040412,2,'Smoke Them Out','Get a burning stick from the centaur campfire; Burn the bushes that the Napaea hold precious; Speak with Iulia.','','',0,1000,0,45,0,0,0,1,0),
(3040413,2,'Pluck Their Wings','Loot Napaea Wings from Napaea; Deliver Napaea Wings to Iulia.','','',0,1000,0,45,1,0,0,1,0),
(3040414,2,'Make Gravel','Break the stones that the Oread hold precious; Speak with Nedelcu.','','',0,1000,0,45,1,0,0,1,0),
(3040415,2,'Pull Their Hair','Loot Oread Hair from Oread; Deliver Oread Hair to Nedelcu.','','',0,1000,0,45,1,0,0,1,0),
(3040416,2,'Research the Dromrek','Find the fork near the Dromrek area; Look at the cave entrance to the west; Explore further into the cave; Discover the northern extent of Dromrek territory; Speak with Scout Madu.','','',0,1000,0,45,1,0,0,1,0),
(3040417,2,'Parlay with the Dromrek','Try speaking with Dromrek Cook; Try speaking with Dromrek Provisioner; Try speaking with Foodpicker; Try speaking with Bashermaker; Speak with Scout Madu.','','',0,1000,0,45,1,0,0,1,0),
(3040418,2,'Soothe the Savage Beast?','Speak with Master Vanguard Regan; Speak with Librarian Hemfar; Speak with Alchemist Naeema; Speak with Scout Ethaniel; Loot Refined Jumjum Pollen from bixies; Deliver Refined Jumjum Pollen to Naeema; Speak with Scout Madu.','','',0,1000,0,45,1,0,0,1,0),
(3040419,2,'Parlay with the Dromrek, Again','Speak with Dromrek Cook; Speak with Dromrek Provisioner; Speak with Foodpicker; Speak with Bashermaker; Speak with Bigone; Speak with Scout Madu.','','',0,1000,0,45,1,0,0,1,0),
(3040420,2,'Reduce the Dromrek Threat','Kill Bigone; Speak with Scout Madu.','','',0,0,3,45,1,0,0,1,0)
ON DUPLICATE KEY UPDATE `type`=VALUES(`type`),`title`=VALUES(`title`),`description`=VALUES(`description`),`reward_text`=VALUES(`reward_text`),`reward_id_list`=VALUES(`reward_id_list`),`cash_reward`=VALUES(`cash_reward`),`exp_reward`=VALUES(`exp_reward`),`reward_method`=VALUES(`reward_method`),`min_level`=VALUES(`min_level`),`repeatable`=VALUES(`repeatable`),`faction_reward`=VALUES(`faction_reward`),`faction_amount`=VALUES(`faction_amount`),`enabled`=VALUES(`enabled`),`duration`=VALUES(`duration`);
DELETE FROM task_activities WHERE taskid IN(3040401,3040402,3040403,3040404,3040405,3040406,3040407,3040408,3040409,3040410,3040411,3040412,3040413,3040414,3040415,3040416,3040417,3040418,3040419,3040420);
INSERT INTO task_activities(`taskid`,`activityid`,`req_activity_id`,`step`,`activitytype`,`target_name`,`goalmethod`,`goalcount`,`description_override`,`npc_match_list`,`item_id_list`,`zones`,`spell_list`,`min_x`,`max_x`,`min_y`,`max_y`,`min_z`,`max_z`)VALUES
(3040401,0,-1,1,5,'',0,1,'Find the Minohten camp','','','397','',1121.54,1191.54,-1062.9,-992.9000000000001,16.299999999999997,166.3),
(3040401,1,-1,2,255,'',0,4,'Steal mushrooms from the Minohten food sacks','','','397','',0,0,0,0,0,0),
(3040401,2,-1,3,4,'',0,1,'Speak with Costica','397014','','397','',0,0,0,0,0,0),
(3040402,0,-1,1,5,'',0,1,'Find the Minohten camp','','','397','',1121.54,1191.54,-1062.9,-992.9000000000001,16.299999999999997,166.3),
(3040402,1,-1,2,2,'',0,2,'Destroy the Minohten tents','397087','','397','',0,0,0,0,0,0),
(3040402,2,-1,3,4,'',0,1,'Speak with Costica','397014','','397','',0,0,0,0,0,0),
(3040403,0,-1,1,2,'',0,4,'Kill Minohten scouts','397021|397024|397033|397038|397050','','397','',0,0,0,0,0,0),
(3040403,1,-1,2,4,'',0,1,'Speak with Costica','397014','','397','',0,0,0,0,0,0),
(3040404,0,-1,1,5,'',0,1,'Explore the Tuffein camp','','','397','',-901,-831,-1626,-1556,-52,98),
(3040404,1,-1,2,255,'',0,3,'Steal food from the Tuffein camp','','','397','',0,0,0,0,0,0),
(3040404,2,-1,3,1,'',0,3,'Return the stolen goods to Sorin','397095','87210|87211','397','',0,0,0,0,0,0),
(3040405,0,-1,1,5,'',0,1,'Make your way to the Tuffein camp','','','397','',-901,-831,-1626,-1556,-52,98),
(3040405,1,-1,2,255,'',0,5,'Destroy Tuffein weapons','397028','','397','',0,0,0,0,0,0),
(3040405,2,-1,3,4,'',0,1,'Speak with Sorin','397095','','397','',0,0,0,0,0,0),
(3040406,0,-1,1,5,'',0,1,'Explore the gnoll mining camp in the Moors','','','395','',3161.625,3421.625,-2162.375,-1902.375,-98.875,101.125),
(3040406,1,-1,2,255,'',0,3,'Collect piles of rocks','','87212','395','',0,0,0,0,0,0),
(3040406,2,-1,3,5,'',0,1,'Sneak into the Tuffein camp','','','397','',-901,-831,-1626,-1556,-52,98),
(3040406,3,-1,4,255,'',0,3,'Replace food stores with rocks from the Gnoll camp','','87212','397','',0,0,0,0,0,0),
(3040406,4,-1,5,4,'',0,1,'Speak with Sorin','397095','','397','',0,0,0,0,0,0),
(3040407,0,-1,1,255,'',0,1,'Steal fruit from the Minohten camp','','21790','397','',0,0,0,0,0,0),
(3040407,1,-1,2,255,'',0,1,'Steal vegetables from the Minohten camp','','21791','397','',0,0,0,0,0,0),
(3040407,2,-1,3,255,'',0,1,'Steal beer from the Minohten camp','','21792','397','',0,0,0,0,0,0),
(3040407,3,-1,4,1,'',0,1,'Deliver Minohten Fruit to Devan','397013','21790','397','',0,0,0,0,0,0),
(3040407,4,-1,4,1,'',0,1,'Deliver Minohten Vegetables to Devan','397013','21791','397','',0,0,0,0,0,0),
(3040407,5,-1,4,1,'',0,1,'Deliver Minohten Short Beer to Devan','397013','21792','397','',0,0,0,0,0,0),
(3040407,6,-1,5,4,'',0,1,'Speak with Devan','397013','','397','',0,0,0,0,0,0),
(3040408,0,-1,1,2,'',0,4,'Kill mesa snakes','397003|397008|397010','','397','',0,0,0,0,0,0),
(3040408,1,-1,1,2,'',0,2,'Kill protectors of the windwillow','397019|397032|397062|397080|397115','','397','',0,0,0,0,0,0),
(3040408,2,-1,1,2,'',0,4,'Kill mesa recluse spiders','397089|397133|397135|397141','','397','',0,0,0,0,0,0),
(3040408,3,-1,2,4,'',0,1,'Speak with Devan','397013','','397','',0,0,0,0,0,0),
(3040409,0,-1,1,3,'',0,4,'Loot Snake Skin in Goru`kar Mesa','','88121','397','',0,0,0,0,0,0),
(3040409,1,-1,1,3,'',0,4,'Loot Spider Silk in Goru`kar Mesa','','13041','397','',0,0,0,0,0,0),
(3040409,2,-1,1,3,'',0,2,'Loot Medium Quality Wolf Skin in Goru`kar Mesa','','13754','397','',0,0,0,0,0,0),
(3040409,3,-1,1,3,'',0,2,'Loot Medium Quality Bear Skin in Goru`kar Mesa','','13751','397','',0,0,0,0,0,0),
(3040409,4,-1,2,1,'',0,4,'Deliver Snake Skin to Devan','397013','88121','397','',0,0,0,0,0,0),
(3040409,5,-1,2,1,'',0,4,'Deliver Spider Silk to Devan','397013','13041','397','',0,0,0,0,0,0),
(3040409,6,-1,2,1,'',0,2,'Deliver Medium Quality Wolf Skin to Devan','397013','13754','397','',0,0,0,0,0,0),
(3040409,7,-1,2,1,'',0,2,'Deliver Medium Quality Bear Skin to Devan','397013','13751','397','',0,0,0,0,0,0),
(3040409,8,-1,3,4,'',0,1,'Speak with Devan','397013','','397','',0,0,0,0,0,0),
(3040410,0,-1,1,2,'',0,3,'Kill napaea','397054|397055|397057|397068|397077|397079|397082|397085|397088|397094|397104','','397','',0,0,0,0,0,0),
(3040410,1,-1,1,2,'',0,4,'Kill potameid','397046|397107|397113|397114|397129|397142|397143|397233|397236|397237|397238|397240|397242|397244|397258|397262','','397','',0,0,0,0,0,0),
(3040410,2,-1,1,2,'',0,3,'Kill oread','397116|397117|397121|397122|397124|397126|397128|397130|397132|397134|397137','','397','',0,0,0,0,0,0),
(3040410,3,-1,2,4,'',0,1,'Speak with Devan','397013','','397','',0,0,0,0,0,0),
(3040411,0,-1,1,2,'',0,4,'Kill Minohten scouts','397021|397024|397033|397038|397050','','397','',0,0,0,0,0,0),
(3040411,1,-1,2,4,'',0,1,'Speak with Devan','397013','','397','',0,0,0,0,0,0),
(3040411,2,-1,3,255,'',0,1,'Find a way to free yourself from the cage','','','397','',0,0,0,0,0,0),
(3040411,3,-1,4,5,'',0,1,'Flee west from the Tuffein camp','','','397','',-610,-470,-1420,-1280,-50,100),
(3040411,4,-1,5,5,'',0,1,'Flee to Scout Madu to be certain you have escaped','','','397','',492,582,-1995,-1905,-45,105),
(3040411,5,-1,6,4,'',0,1,'Speak with Scout Madu','397007','','397','',0,0,0,0,0,0),
(3040412,0,-1,1,255,'',0,1,'Get a burning stick from the centaur campfire','','88132','397','',0,0,0,0,0,0),
(3040412,1,-1,2,255,'',0,4,'Burn the bushes that the Napaea hold precious','','','397','',0,0,0,0,0,0),
(3040412,2,-1,3,4,'',0,1,'Speak with Iulia','397119','','397','',0,0,0,0,0,0),
(3040413,0,-1,1,3,'',0,4,'Loot Napaea Wings from Napaea','','88133','397','',0,0,0,0,0,0),
(3040413,1,-1,2,1,'',0,4,'Deliver Napaea Wings to Iulia','397119','88133','397','',0,0,0,0,0,0),
(3040414,0,-1,1,255,'',0,4,'Break the stones that the Oread hold precious','','','397','',0,0,0,0,0,0),
(3040414,1,-1,2,4,'',0,1,'Speak with Nedelcu','397083','','397','',0,0,0,0,0,0),
(3040415,0,-1,1,3,'',0,4,'Loot Oread Hair from Oread','','88134','397','',0,0,0,0,0,0),
(3040415,1,-1,2,1,'',0,4,'Deliver Oread Hair to Nedelcu','397083','88134','397','',0,0,0,0,0,0),
(3040416,0,-1,1,5,'',0,1,'Find the fork near the Dromrek area','','','397','',690,830,220,360,-42,108),
(3040416,1,-1,2,5,'',0,1,'Look at the cave entrance to the west','','','397','',1308,1488,-96,84,-30,120),
(3040416,2,-1,3,5,'',0,1,'Explore further into the cave','','','397','',1601,1731,57,187,-57,93),
(3040416,3,-1,4,5,'',0,1,'Discover the northern extent of Dromrek territory','','','397','',1081,1211,1201,1331,72,222),
(3040416,4,-1,5,4,'',0,1,'Speak with Scout Madu','397007','','397','',0,0,0,0,0,0),
(3040417,0,-1,1,2,'',0,1,'Try speaking with Dromrek Cook','397251','','397','',0,0,0,0,0,0),
(3040417,1,-1,2,2,'',0,1,'Try speaking with Dromrek Provisioner','397243','','397','',0,0,0,0,0,0),
(3040417,2,-1,3,2,'',0,1,'Try speaking with Foodpicker','397259','','397','',0,0,0,0,0,0),
(3040417,3,-1,4,2,'',0,1,'Try speaking with Bashermaker','397255','','397','',0,0,0,0,0,0),
(3040417,4,-1,5,4,'',0,1,'Speak with Scout Madu','397007','','397','',0,0,0,0,0,0),
(3040418,0,-1,1,4,'',0,1,'Speak with Master Vanguard Regan','394164','','394','',0,0,0,0,0,0),
(3040418,1,-1,2,4,'',0,1,'Speak with Librarian Hemfar','394227','','394','',0,0,0,0,0,0),
(3040418,2,-1,3,4,'',0,1,'Speak with Alchemist Naeema','394228','','394','',0,0,0,0,0,0),
(3040418,3,-1,4,4,'',0,1,'Speak with Scout Ethaniel','395210','','395','',0,0,0,0,0,0),
(3040418,4,-1,5,3,'',0,1,'Loot Refined Jumjum Pollen from bixies','','88131','396','',0,0,0,0,0,0),
(3040418,5,-1,6,1,'',0,1,'Deliver Refined Jumjum Pollen to Naeema','394228','88131','394','',0,0,0,0,0,0),
(3040418,6,-1,7,4,'',0,1,'Speak with Scout Madu','397007','','397','',0,0,0,0,0,0),
(3040419,0,-1,1,4,'',0,1,'Speak with Dromrek Cook','397251','','397','',0,0,0,0,0,0),
(3040419,1,-1,1,4,'',0,1,'Speak with Dromrek Provisioner','397243','','397','',0,0,0,0,0,0),
(3040419,2,-1,1,4,'',0,1,'Speak with Foodpicker','397259','','397','',0,0,0,0,0,0),
(3040419,3,-1,1,4,'',0,1,'Speak with Bashermaker','397255','','397','',0,0,0,0,0,0),
(3040419,4,-1,1,4,'',0,1,'Speak with Bigone','397231','','397','',0,0,0,0,0,0),
(3040419,5,-1,2,4,'',0,1,'Speak with Scout Madu','397007','','397','',0,0,0,0,0,0),
(3040420,0,-1,1,2,'',0,1,'Kill Bigone','397231','','397','',0,0,0,0,0,0),
(3040420,1,-1,2,4,'',0,1,'Speak with Scout Madu','397007','','397','',0,0,0,0,0,0)
ON DUPLICATE KEY UPDATE `activityid`=VALUES(`activityid`),`req_activity_id`=VALUES(`req_activity_id`),`step`=VALUES(`step`),`activitytype`=VALUES(`activitytype`),`target_name`=VALUES(`target_name`),`goalmethod`=VALUES(`goalmethod`),`goalcount`=VALUES(`goalcount`),`description_override`=VALUES(`description_override`),`npc_match_list`=VALUES(`npc_match_list`),`item_id_list`=VALUES(`item_id_list`),`zones`=VALUES(`zones`),`spell_list`=VALUES(`spell_list`),`min_x`=VALUES(`min_x`),`max_x`=VALUES(`max_x`),`min_y`=VALUES(`min_y`),`max_y`=VALUES(`max_y`),`min_z`=VALUES(`min_z`),`max_z`=VALUES(`max_z`);
DELETE FROM achievement_criteria WHERE achievement_id=500040200 AND component_type=1 AND component_id=50106;
DELETE FROM achievement_criteria WHERE achievement_id=500040200 AND component_type=1 AND component_id=50107;
DELETE FROM achievement_criteria WHERE achievement_id=500040200 AND component_type=1 AND component_id=50108;
DELETE FROM achievement_criteria WHERE achievement_id=500040200 AND component_type=1 AND component_id=50109;
DELETE FROM achievement_criteria WHERE achievement_id=500040200 AND component_type=1 AND component_id=50110;
DELETE FROM achievement_criteria WHERE achievement_id=500040200 AND component_type=1 AND component_id=50111;
DELETE FROM achievement_criteria WHERE achievement_id=500040200 AND component_type=1 AND component_id=50112;
DELETE FROM achievement_criteria WHERE achievement_id=500040200 AND component_type=1 AND component_id=50113;
DELETE FROM achievement_criteria WHERE achievement_id=500040200 AND component_type=1 AND component_id=50114;
DELETE FROM achievement_criteria WHERE achievement_id=500040200 AND component_type=1 AND component_id=50115;
DELETE FROM achievement_criteria WHERE achievement_id=500040200 AND component_type=1 AND component_id=50116;
DELETE FROM achievement_criteria WHERE achievement_id=500040300 AND component_type=1 AND component_id=50117;
DELETE FROM achievement_criteria WHERE achievement_id=500040300 AND component_type=1 AND component_id=50118;
DELETE FROM achievement_criteria WHERE achievement_id=500040300 AND component_type=1 AND component_id=50119;
DELETE FROM achievement_criteria WHERE achievement_id=500040300 AND component_type=1 AND component_id=50120;
DELETE FROM achievement_criteria WHERE achievement_id=500040300 AND component_type=1 AND component_id=50121;
DELETE FROM achievement_criteria WHERE achievement_id=500040300 AND component_type=1 AND component_id=50122;
DELETE FROM achievement_criteria WHERE achievement_id=500040300 AND component_type=1 AND component_id=50123;
DELETE FROM achievement_criteria WHERE achievement_id=500040300 AND component_type=1 AND component_id=50124;
DELETE FROM achievement_criteria WHERE achievement_id=500040300 AND component_type=1 AND component_id=50125;
INSERT INTO achievement_criteria(`achievement_id`,`component_type`,`component_sequence`,`component_id`,`event_type`,`progress_mode`,`behavior`,`target_id`,`target_id2`,`target_value`,`required_count`,`enabled`)VALUES
(500040200,1,1,50106,4,3,0,3040401,0,0,1,1),
(500040200,1,2,50107,4,3,0,3040402,0,0,1,1),
(500040200,1,3,50108,4,3,0,3040403,0,0,1,1),
(500040200,1,4,50109,4,3,0,3040404,0,0,1,1),
(500040200,1,5,50110,4,3,0,3040405,0,0,1,1),
(500040200,1,6,50111,4,3,0,3040406,0,0,1,1),
(500040200,1,7,50112,4,3,0,3040407,0,0,1,1),
(500040200,1,8,50113,4,3,0,3040408,0,0,1,1),
(500040200,1,9,50114,4,3,0,3040409,0,0,1,1),
(500040200,1,10,50115,4,3,0,3040410,0,0,1,1),
(500040200,1,11,50116,4,3,0,3040411,0,0,1,0),
(500040300,1,1,50117,4,3,0,3040412,0,0,1,1),
(500040300,1,2,50118,4,3,0,3040413,0,0,1,1),
(500040300,1,3,50119,4,3,0,3040414,0,0,1,1),
(500040300,1,4,50120,4,3,0,3040415,0,0,1,1),
(500040300,1,5,50121,4,3,0,3040416,0,0,1,1),
(500040300,1,6,50122,4,3,0,3040417,0,0,1,1),
(500040300,1,7,50123,4,3,0,3040418,0,0,1,1),
(500040300,1,8,50124,4,3,0,3040419,0,0,1,1),
(500040300,1,9,50125,4,3,0,3040420,0,0,1,1)
ON DUPLICATE KEY UPDATE `component_type`=VALUES(`component_type`),`component_sequence`=VALUES(`component_sequence`),`component_id`=VALUES(`component_id`),`event_type`=VALUES(`event_type`),`progress_mode`=VALUES(`progress_mode`),`behavior`=VALUES(`behavior`),`target_id`=VALUES(`target_id`),`target_id2`=VALUES(`target_id2`),`target_value`=VALUES(`target_value`),`required_count`=VALUES(`required_count`),`enabled`=VALUES(`enabled`);
INSERT INTO reward_sets(`reward_set_id`,`title`,`enabled`)VALUES
(3040411,'Minohten are a menace!',0)
ON DUPLICATE KEY UPDATE `title`=VALUES(`title`),`enabled`=VALUES(`enabled`);
INSERT INTO reward_sources(`source_type`,`source_id`,`reward_set_id`,`enabled`)VALUES
(2,3040411,3040411,0)
ON DUPLICATE KEY UPDATE `source_id`=VALUES(`source_id`),`reward_set_id`=VALUES(`reward_set_id`),`enabled`=VALUES(`enabled`);
INSERT INTO reward_options(`reward_set_id`,`option_id`,`sequence`,`label`,`common_to_all`,`flags`,`enabled`,`class_mask`)VALUES
(3040411,1,0,'Experience',1,0,1,65535),
(3040411,2,2,'Crystalwing Plate Vambraces',0,0,1,151),
(3040411,3,3,'Crystalwing Chain Bracelet',0,0,1,33544),
(3040411,4,4,'Crystalwing Leather Vambraces',0,0,1,16480),
(3040411,5,5,'Crystalwing Silk Bracelet',0,0,1,15360)
ON DUPLICATE KEY UPDATE `option_id`=VALUES(`option_id`),`sequence`=VALUES(`sequence`),`label`=VALUES(`label`),`common_to_all`=VALUES(`common_to_all`),`flags`=VALUES(`flags`),`enabled`=VALUES(`enabled`),`class_mask`=VALUES(`class_mask`);
INSERT INTO rewards(`reward_id`,`reward_type`,`reward_data_id`,`amount`,`description`,`enabled`)VALUES
(30404111,1,1,1000,'May2013 Mesa option 30404111',1),
(30404112,0,53554,1,'May2013 Mesa option 30404112',1),
(30404113,0,53555,1,'May2013 Mesa option 30404113',1),
(30404114,0,53556,1,'May2013 Mesa option 30404114',1),
(30404115,0,53557,1,'May2013 Mesa option 30404115',1)
ON DUPLICATE KEY UPDATE `reward_type`=VALUES(`reward_type`),`reward_data_id`=VALUES(`reward_data_id`),`amount`=VALUES(`amount`),`description`=VALUES(`description`),`enabled`=VALUES(`enabled`);
INSERT INTO reward_option_entries(`reward_set_id`,`option_id`,`sequence`,`reward_id`)VALUES
(3040411,1,0,30404111),
(3040411,2,0,30404112),
(3040411,3,0,30404113),
(3040411,4,0,30404114),
(3040411,5,0,30404115)
ON DUPLICATE KEY UPDATE `option_id`=VALUES(`option_id`),`sequence`=VALUES(`sequence`),`reward_id`=VALUES(`reward_id`);
INSERT INTO reward_sets(`reward_set_id`,`title`,`enabled`)VALUES
(3040420,'Reduce the Dromrek Threat',1)
ON DUPLICATE KEY UPDATE `title`=VALUES(`title`),`enabled`=VALUES(`enabled`);
INSERT INTO reward_sources(`source_type`,`source_id`,`reward_set_id`,`enabled`)VALUES
(2,3040420,3040420,1)
ON DUPLICATE KEY UPDATE `source_id`=VALUES(`source_id`),`reward_set_id`=VALUES(`reward_set_id`),`enabled`=VALUES(`enabled`);
INSERT INTO reward_options(`reward_set_id`,`option_id`,`sequence`,`label`,`common_to_all`,`flags`,`enabled`,`class_mask`)VALUES
(3040420,1,0,'Experience',1,0,1,65535),
(3040420,2,2,'Crystalwing Goru`kar Scout Health Stone',0,0,1,65535),
(3040420,3,3,'Crystalwing Goru`kar Scout Power Stone',0,0,1,65535),
(3040420,4,4,'Crystalwing Goru`kar Scout Shielding Stone',0,0,1,65535),
(3040420,5,5,'Crystalwing Goru`kar Scout Striker Stone',0,0,1,65535)
ON DUPLICATE KEY UPDATE `option_id`=VALUES(`option_id`),`sequence`=VALUES(`sequence`),`label`=VALUES(`label`),`common_to_all`=VALUES(`common_to_all`),`flags`=VALUES(`flags`),`enabled`=VALUES(`enabled`),`class_mask`=VALUES(`class_mask`);
INSERT INTO rewards(`reward_id`,`reward_type`,`reward_data_id`,`amount`,`description`,`enabled`)VALUES
(30404201,1,1,1000,'May2013 Mesa option 30404201',1),
(30404202,0,53568,1,'May2013 Mesa option 30404202',1),
(30404203,0,53569,1,'May2013 Mesa option 30404203',1),
(30404204,0,53570,1,'May2013 Mesa option 30404204',1),
(30404205,0,53571,1,'May2013 Mesa option 30404205',1)
ON DUPLICATE KEY UPDATE `reward_type`=VALUES(`reward_type`),`reward_data_id`=VALUES(`reward_data_id`),`amount`=VALUES(`amount`),`description`=VALUES(`description`),`enabled`=VALUES(`enabled`);
INSERT INTO reward_option_entries(`reward_set_id`,`option_id`,`sequence`,`reward_id`)VALUES
(3040420,1,0,30404201),
(3040420,2,0,30404202),
(3040420,3,0,30404203),
(3040420,4,0,30404204),
(3040420,5,0,30404205)
ON DUPLICATE KEY UPDATE `option_id`=VALUES(`option_id`),`sequence`=VALUES(`sequence`),`reward_id`=VALUES(`reward_id`);
COMMIT;
