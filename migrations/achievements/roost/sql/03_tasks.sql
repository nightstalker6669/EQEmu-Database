-- Roost production content; guarded disabled base import.
SET NAMES utf8mb4;
SET SESSION check_constraint_checks=1;
DROP TEMPORARY TABLE IF EXISTS _roost_tasks_guard;
CREATE TEMPORARY TABLE _roost_tasks_guard(label VARCHAR(100)PRIMARY KEY,ok TINYINT NOT NULL,CHECK(ok=1))ENGINE=InnoDB;
INSERT INTO _roost_tasks_guard VALUES('review',(COALESCE(@roost_tasks_reviewed,0)=1));
INSERT INTO _roost_tasks_guard VALUES('task_identity',(NOT EXISTS(SELECT 1 FROM tasks WHERE id IN(3040501,3040502,3040503,3040504,3040505,3040506,3040507,3040508,3040509,3040510,3040511,3040512,3040513,3040514,3040515) AND NOT((id=3040501 AND type=2 AND title='Blackfeather Roost, The Ledge') OR (id=3040502 AND type=2 AND title='Blackfeather Roost, The Grove') OR (id=3040503 AND type=2 AND title='Blackfeather Roost, The Cliffs') OR (id=3040504 AND type=2 AND title='Blackfeather Roost, The Mesa') OR (id=3040505 AND type=2 AND title='Reach the Royal Throne') OR (id=3040506 AND type=2 AND title='Kill the Queen of the Harpies!') OR (id=3040507 AND type=2 AND title='Strike a Blow - Kill Harpies and Griffons!') OR (id=3040508 AND type=2 AND title='Destroy! Knock the nests down!') OR (id=3040509 AND type=2 AND title='Cause some mayhem - Kill Gayatri!') OR (id=3040510 AND type=2 AND title='Find My Son') OR (id=3040511 AND type=2 AND title='Explore the Roost!') OR (id=3040512 AND type=2 AND title='Harass the Harpies!') OR (id=3040513 AND type=2 AND title='Griffon Feathers') OR (id=3040514 AND type=2 AND title='Help poor Fenith!') OR (id=3040515 AND type=2 AND title='A Small Wager')))));
INSERT INTO _roost_tasks_guard VALUES('item_identity',((SELECT COUNT(*)FROM items WHERE (id=13617 AND Name='Gayatri''s Heart') OR (id=28672 AND Name='Royal Crest') OR (id=28673 AND Name='Royal Emblem') OR (id=28674 AND Name='Griffon Treat') OR (id=28675 AND Name='Griffon Treat') OR (id=28676 AND Name='Griffon Treat') OR (id=28677 AND Name='Griffon Treat') OR (id=28678 AND Name='Royal Trinket') OR (id=53597 AND Name='Blackfeather Healthstone') OR (id=53598 AND Name='Blackfeather Powerstone') OR (id=53599 AND Name='Blackfeather Shockstone') OR (id=53600 AND Name='Blackfeather Focus Stone') OR (id=53601 AND Name='Blackfeather Ablestone') OR (id=53606 AND Name='Griffon Feather Cap') OR (id=53607 AND Name='Satyr Hunter''s Draught') OR (id=53608 AND Name='Satyr Draught of Insight') OR (id=53609 AND Name='Gayatri''s Shawl') OR (id=53610 AND Name='Griffonbane Hammer') OR (id=53611 AND Name='Fenith''s Lunchbox') OR (id=53612 AND Name='Dorinda''s Golden Mask') OR (id=54655 AND Name='Red Griffon Feather') OR (id=54663 AND Name='Brown Griffon Feather') OR (id=54664 AND Name='Golden Griffon Feather') OR (id=54665 AND Name='Black Griffon Feather') OR (id=54666 AND Name='White Griffon Feather'))=25));
INSERT INTO _roost_tasks_guard VALUES('npc_identity',((SELECT COUNT(*)FROM npc_types WHERE (id=394097 AND name='Jenn_Stalbath') OR (id=397102 AND name='Elder_Vasile') OR (id=398000 AND name='a_mountain_puma') OR (id=398002 AND name='a_mountain_puma') OR (id=398003 AND name='a_cunning_mountain_puma') OR (id=398010 AND name='a_mountain_puma') OR (id=398018 AND name='Fenith') OR (id=398019 AND name='a_healthy_mountain_puma') OR (id=398020 AND name='a_tame_Griffon') OR (id=398022 AND name='Adrian') OR (id=398023 AND name='Lucian') OR (id=398025 AND name='a_small_plain_harpy_nest') OR (id=398026 AND name='a_restless_harpy') OR (id=398027 AND name='a_large_normal_harpy_nest') OR (id=398028 AND name='a_restless_harpy') OR (id=398029 AND name='Coryn') OR (id=398030 AND name='a_restless_harpy') OR (id=398031 AND name='a_restless_harpy') OR (id=398032 AND name='a_small_normal_harpy_nest') OR (id=398033 AND name='a_large_plain_harpy_nest') OR (id=398035 AND name='a_harpy') OR (id=398036 AND name='a_harpy_patroller') OR (id=398037 AND name='a_blackfeather_griffon') OR (id=398038 AND name='a_restless_harpy') OR (id=398039 AND name='Dorinda') OR (id=398040 AND name='a_harpy_noble') OR (id=398041 AND name='a_harpy_patroller') OR (id=398042 AND name='a_large_sturdy_harpy_nest') OR (id=398043 AND name='a_wandering_harpy') OR (id=398044 AND name='a_restless_harpy') OR (id=398045 AND name='a_tame_Griffon') OR (id=398046 AND name='a_harpy_patroller') OR (id=398047 AND name='Mestle') OR (id=398048 AND name='a_harpy_noble') OR (id=398049 AND name='a_small_sturdy_harpy_nest') OR (id=398051 AND name='a_harpy_patroller') OR (id=398052 AND name='a_harpy_explorer') OR (id=398053 AND name='a_harpy_patroller') OR (id=398055 AND name='a_harpy_noble') OR (id=398056 AND name='a_harpy_patroller') OR (id=398057 AND name='a_wandering_harpy') OR (id=398058 AND name='a_blackfeather_griffon') OR (id=398059 AND name='a_wandering_harpy') OR (id=398060 AND name='a_wandering_harpy') OR (id=398061 AND name='a_wandering_harpy') OR (id=398062 AND name='a_wandering_harpy') OR (id=398063 AND name='a_blackfeather_griffon') OR (id=398064 AND name='a_harpy_youth') OR (id=398065 AND name='#Gayatri') OR (id=398066 AND name='a_blackfeather_griffon') OR (id=398067 AND name='an_ornate_harpy_nest') OR (id=398068 AND name='Lady_Inthra') OR (id=398069 AND name='a_highborn_harpy') OR (id=398070 AND name='Ashrana') OR (id=398071 AND name='a_blackfeather_griffon') OR (id=398072 AND name='a_blackfeather_griffon') OR (id=398073 AND name='a_highborn_harpy') OR (id=398074 AND name='a_harpy_explorer') OR (id=398075 AND name='a_highborn_harpy') OR (id=398077 AND name='Royal_Guard') OR (id=398078 AND name='a_highborn_harpy') OR (id=398079 AND name='a_harpy_explorer') OR (id=398080 AND name='Royal_Guard') OR (id=398081 AND name='Captain_Slarus') OR (id=398082 AND name='Royal_Guard') OR (id=398083 AND name='a_Queen`s_guard') OR (id=398084 AND name='a_harpy_explorer') OR (id=398085 AND name='a_Queen`s_guard') OR (id=398086 AND name='a_Queen`s_guard') OR (id=398087 AND name='#Queen_Eletyl') OR (id=398088 AND name='a_Queen`s_guard') OR (id=398092 AND name='a_mountain_puma') OR (id=398094 AND name='a_mountain_puma'))=73));
INSERT INTO _roost_tasks_guard VALUES('component_identity',((SELECT COUNT(*)FROM achievement_components WHERE (achievement_id=500050200 AND component_type=1 AND component_id=50175 AND sequence=1 AND name='Fenith - The Ledge') OR (achievement_id=500050200 AND component_type=1 AND component_id=50176 AND sequence=2 AND name='Fenith - The Grove') OR (achievement_id=500050200 AND component_type=1 AND component_id=50177 AND sequence=3 AND name='Coryn - The Cliffs') OR (achievement_id=500050200 AND component_type=1 AND component_id=50178 AND sequence=4 AND name='Mestle - The Mesa') OR (achievement_id=500050200 AND component_type=1 AND component_id=50179 AND sequence=5 AND name='Ashrana - Reach the Royal Throne') OR (achievement_id=500050200 AND component_type=1 AND component_id=50180 AND sequence=6 AND name='Ashrana - Kill the Queen of the Harpies!') OR (achievement_id=500050300 AND component_type=1 AND component_id=50181 AND sequence=1 AND name='Lucian - Strike a Blow - Kill Harpies and Griffons!') OR (achievement_id=500050300 AND component_type=1 AND component_id=50182 AND sequence=2 AND name='Lucian - Destroy! Knock the Nests Down!') OR (achievement_id=500050300 AND component_type=1 AND component_id=50183 AND sequence=3 AND name='Lucian - Cause Some Mayhem - Kill Gayatri!') OR (achievement_id=500050400 AND component_type=1 AND component_id=50184 AND sequence=1 AND name='Elder Vasile - Find My Son') OR (achievement_id=500050400 AND component_type=1 AND component_id=50185 AND sequence=2 AND name='Adrian - Explore the Roost!') OR (achievement_id=500050400 AND component_type=1 AND component_id=50186 AND sequence=3 AND name='Adrian - Harass the Harpies!') OR (achievement_id=500050500 AND component_type=1 AND component_id=50187 AND sequence=1 AND name='Jenn Stalbath - Griffon Feathers') OR (achievement_id=500050500 AND component_type=1 AND component_id=50188 AND sequence=2 AND name='Fenith - Help poor Fenith!') OR (achievement_id=500050500 AND component_type=1 AND component_id=50189 AND sequence=3 AND name='Dorinda - A Small Wager'))=15));
INSERT INTO _roost_tasks_guard VALUES('criteria_3040501',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500050200 AND component_type=1 AND component_id=50175 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040501 AND target_id2=0 AND target_value=0 AND component_sequence=1 AND required_count=1))));
INSERT INTO _roost_tasks_guard VALUES('criteria_3040502',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500050200 AND component_type=1 AND component_id=50176 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040502 AND target_id2=0 AND target_value=0 AND component_sequence=2 AND required_count=1))));
INSERT INTO _roost_tasks_guard VALUES('criteria_3040503',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500050200 AND component_type=1 AND component_id=50177 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040503 AND target_id2=0 AND target_value=0 AND component_sequence=3 AND required_count=1))));
INSERT INTO _roost_tasks_guard VALUES('criteria_3040504',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500050200 AND component_type=1 AND component_id=50178 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040504 AND target_id2=0 AND target_value=0 AND component_sequence=4 AND required_count=1))));
INSERT INTO _roost_tasks_guard VALUES('criteria_3040505',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500050200 AND component_type=1 AND component_id=50179 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040505 AND target_id2=0 AND target_value=0 AND component_sequence=5 AND required_count=1))));
INSERT INTO _roost_tasks_guard VALUES('criteria_3040506',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500050200 AND component_type=1 AND component_id=50180 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040506 AND target_id2=0 AND target_value=0 AND component_sequence=6 AND required_count=1))));
INSERT INTO _roost_tasks_guard VALUES('reward_set_3040506',(NOT EXISTS(SELECT 1 FROM reward_sets WHERE reward_set_id=3040506 AND title<>'Kill the Queen of the Harpies!') AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE reward_set_id=3040506 AND NOT(source_type=2 AND source_id=3040506))AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE source_type=2 AND source_id=3040506 AND reward_set_id<>3040506)));
INSERT INTO _roost_tasks_guard VALUES('options_3040506',(NOT EXISTS(SELECT 1 FROM reward_options WHERE reward_set_id=3040506 AND NOT((option_id=2 AND label='Blackfeather Ablestone' AND common_to_all=0 AND class_mask=65535 AND flags=0) OR (option_id=3 AND label='Blackfeather Focus Stone' AND common_to_all=0 AND class_mask=65535 AND flags=0) OR (option_id=4 AND label='Blackfeather Healthstone' AND common_to_all=0 AND class_mask=65535 AND flags=0) OR (option_id=5 AND label='Blackfeather Powerstone' AND common_to_all=0 AND class_mask=65535 AND flags=0) OR (option_id=6 AND label='Blackfeather Shockstone' AND common_to_all=0 AND class_mask=65535 AND flags=0)))));
INSERT INTO _roost_tasks_guard VALUES('links_3040506',(NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_set_id=3040506 AND NOT((option_id=2 AND sequence=0 AND reward_id=304050602) OR (option_id=3 AND sequence=0 AND reward_id=304050603) OR (option_id=4 AND sequence=0 AND reward_id=304050604) OR (option_id=5 AND sequence=0 AND reward_id=304050605) OR (option_id=6 AND sequence=0 AND reward_id=304050606)))));
INSERT INTO _roost_tasks_guard VALUES('reward_304050602',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304050602 AND description<>'May2013 Roost task reward 304050602')AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304050602 AND NOT(reward_set_id=3040506 AND option_id=2))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304050602)));
INSERT INTO _roost_tasks_guard VALUES('reward_304050603',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304050603 AND description<>'May2013 Roost task reward 304050603')AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304050603 AND NOT(reward_set_id=3040506 AND option_id=3))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304050603)));
INSERT INTO _roost_tasks_guard VALUES('reward_304050604',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304050604 AND description<>'May2013 Roost task reward 304050604')AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304050604 AND NOT(reward_set_id=3040506 AND option_id=4))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304050604)));
INSERT INTO _roost_tasks_guard VALUES('reward_304050605',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304050605 AND description<>'May2013 Roost task reward 304050605')AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304050605 AND NOT(reward_set_id=3040506 AND option_id=5))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304050605)));
INSERT INTO _roost_tasks_guard VALUES('reward_304050606',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304050606 AND description<>'May2013 Roost task reward 304050606')AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304050606 AND NOT(reward_set_id=3040506 AND option_id=6))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304050606)));
INSERT INTO _roost_tasks_guard VALUES('criteria_3040507',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500050300 AND component_type=1 AND component_id=50181 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040507 AND target_id2=0 AND target_value=0 AND component_sequence=1 AND required_count=1))));
INSERT INTO _roost_tasks_guard VALUES('reward_set_3040507',(NOT EXISTS(SELECT 1 FROM reward_sets WHERE reward_set_id=3040507 AND title<>'Strike a Blow - Kill Harpies and Griffons!') AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE reward_set_id=3040507 AND NOT(source_type=2 AND source_id=3040507))AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE source_type=2 AND source_id=3040507 AND reward_set_id<>3040507)));
INSERT INTO _roost_tasks_guard VALUES('options_3040507',(NOT EXISTS(SELECT 1 FROM reward_options WHERE reward_set_id=3040507 AND NOT((option_id=1 AND label='Experience' AND common_to_all=1 AND class_mask=65535 AND flags=0) OR (option_id=2 AND label='Satyr Hunter''s Draught' AND common_to_all=0 AND class_mask=65535 AND flags=0)))));
INSERT INTO _roost_tasks_guard VALUES('links_3040507',(NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_set_id=3040507 AND NOT((option_id=1 AND sequence=0 AND reward_id=304050701) OR (option_id=2 AND sequence=0 AND reward_id=304050702)))));
INSERT INTO _roost_tasks_guard VALUES('reward_304050701',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304050701 AND description<>'May2013 Roost task reward 304050701')AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304050701 AND NOT(reward_set_id=3040507 AND option_id=1))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304050701)));
INSERT INTO _roost_tasks_guard VALUES('reward_304050702',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304050702 AND description<>'May2013 Roost task reward 304050702')AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304050702 AND NOT(reward_set_id=3040507 AND option_id=2))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304050702)));
INSERT INTO _roost_tasks_guard VALUES('criteria_3040508',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500050300 AND component_type=1 AND component_id=50182 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040508 AND target_id2=0 AND target_value=0 AND component_sequence=2 AND required_count=1))));
INSERT INTO _roost_tasks_guard VALUES('reward_set_3040508',(NOT EXISTS(SELECT 1 FROM reward_sets WHERE reward_set_id=3040508 AND title<>'Destroy! Knock the nests down!') AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE reward_set_id=3040508 AND NOT(source_type=2 AND source_id=3040508))AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE source_type=2 AND source_id=3040508 AND reward_set_id<>3040508)));
INSERT INTO _roost_tasks_guard VALUES('options_3040508',(NOT EXISTS(SELECT 1 FROM reward_options WHERE reward_set_id=3040508 AND NOT((option_id=1 AND label='Experience' AND common_to_all=1 AND class_mask=65535 AND flags=0) OR (option_id=2 AND label='Griffonbane Hammer' AND common_to_all=0 AND class_mask=65535 AND flags=0)))));
INSERT INTO _roost_tasks_guard VALUES('links_3040508',(NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_set_id=3040508 AND NOT((option_id=1 AND sequence=0 AND reward_id=304050801) OR (option_id=2 AND sequence=0 AND reward_id=304050802)))));
INSERT INTO _roost_tasks_guard VALUES('reward_304050801',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304050801 AND description<>'May2013 Roost task reward 304050801')AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304050801 AND NOT(reward_set_id=3040508 AND option_id=1))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304050801)));
INSERT INTO _roost_tasks_guard VALUES('reward_304050802',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304050802 AND description<>'May2013 Roost task reward 304050802')AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304050802 AND NOT(reward_set_id=3040508 AND option_id=2))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304050802)));
INSERT INTO _roost_tasks_guard VALUES('criteria_3040509',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500050300 AND component_type=1 AND component_id=50183 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040509 AND target_id2=0 AND target_value=0 AND component_sequence=3 AND required_count=1))));
INSERT INTO _roost_tasks_guard VALUES('reward_set_3040509',(NOT EXISTS(SELECT 1 FROM reward_sets WHERE reward_set_id=3040509 AND title<>'Cause some mayhem - Kill Gayatri!') AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE reward_set_id=3040509 AND NOT(source_type=2 AND source_id=3040509))AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE source_type=2 AND source_id=3040509 AND reward_set_id<>3040509)));
INSERT INTO _roost_tasks_guard VALUES('options_3040509',(NOT EXISTS(SELECT 1 FROM reward_options WHERE reward_set_id=3040509 AND NOT((option_id=1 AND label='Experience' AND common_to_all=1 AND class_mask=65535 AND flags=0) OR (option_id=2 AND label='Gayatri''s Shawl' AND common_to_all=0 AND class_mask=65535 AND flags=0)))));
INSERT INTO _roost_tasks_guard VALUES('links_3040509',(NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_set_id=3040509 AND NOT((option_id=1 AND sequence=0 AND reward_id=304050901) OR (option_id=2 AND sequence=0 AND reward_id=304050902)))));
INSERT INTO _roost_tasks_guard VALUES('reward_304050901',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304050901 AND description<>'May2013 Roost task reward 304050901')AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304050901 AND NOT(reward_set_id=3040509 AND option_id=1))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304050901)));
INSERT INTO _roost_tasks_guard VALUES('reward_304050902',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304050902 AND description<>'May2013 Roost task reward 304050902')AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304050902 AND NOT(reward_set_id=3040509 AND option_id=2))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304050902)));
INSERT INTO _roost_tasks_guard VALUES('criteria_3040510',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500050400 AND component_type=1 AND component_id=50184 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040510 AND target_id2=0 AND target_value=0 AND component_sequence=1 AND required_count=1))));
INSERT INTO _roost_tasks_guard VALUES('criteria_3040511',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500050400 AND component_type=1 AND component_id=50185 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040511 AND target_id2=0 AND target_value=0 AND component_sequence=2 AND required_count=1))));
INSERT INTO _roost_tasks_guard VALUES('criteria_3040512',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500050400 AND component_type=1 AND component_id=50186 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040512 AND target_id2=0 AND target_value=0 AND component_sequence=3 AND required_count=1))));
INSERT INTO _roost_tasks_guard VALUES('reward_set_3040512',(NOT EXISTS(SELECT 1 FROM reward_sets WHERE reward_set_id=3040512 AND title<>'Harass the Harpies!') AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE reward_set_id=3040512 AND NOT(source_type=2 AND source_id=3040512))AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE source_type=2 AND source_id=3040512 AND reward_set_id<>3040512)));
INSERT INTO _roost_tasks_guard VALUES('options_3040512',(NOT EXISTS(SELECT 1 FROM reward_options WHERE reward_set_id=3040512 AND NOT((option_id=1 AND label='Experience' AND common_to_all=1 AND class_mask=65535 AND flags=0) OR (option_id=2 AND label='Satyr Draught of Insight' AND common_to_all=0 AND class_mask=65535 AND flags=0)))));
INSERT INTO _roost_tasks_guard VALUES('links_3040512',(NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_set_id=3040512 AND NOT((option_id=1 AND sequence=0 AND reward_id=304051201) OR (option_id=2 AND sequence=0 AND reward_id=304051202)))));
INSERT INTO _roost_tasks_guard VALUES('reward_304051201',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304051201 AND description<>'May2013 Roost task reward 304051201')AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304051201 AND NOT(reward_set_id=3040512 AND option_id=1))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304051201)));
INSERT INTO _roost_tasks_guard VALUES('reward_304051202',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304051202 AND description<>'May2013 Roost task reward 304051202')AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304051202 AND NOT(reward_set_id=3040512 AND option_id=2))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304051202)));
INSERT INTO _roost_tasks_guard VALUES('criteria_3040513',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500050500 AND component_type=1 AND component_id=50187 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040513 AND target_id2=0 AND target_value=0 AND component_sequence=1 AND required_count=1))));
INSERT INTO _roost_tasks_guard VALUES('reward_set_3040513',(NOT EXISTS(SELECT 1 FROM reward_sets WHERE reward_set_id=3040513 AND title<>'Griffon Feathers') AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE reward_set_id=3040513 AND NOT(source_type=2 AND source_id=3040513))AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE source_type=2 AND source_id=3040513 AND reward_set_id<>3040513)));
INSERT INTO _roost_tasks_guard VALUES('options_3040513',(NOT EXISTS(SELECT 1 FROM reward_options WHERE reward_set_id=3040513 AND NOT((option_id=1 AND label='Experience' AND common_to_all=1 AND class_mask=65535 AND flags=0) OR (option_id=2 AND label='Griffon Feather Cap' AND common_to_all=0 AND class_mask=65535 AND flags=0)))));
INSERT INTO _roost_tasks_guard VALUES('links_3040513',(NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_set_id=3040513 AND NOT((option_id=1 AND sequence=0 AND reward_id=304051301) OR (option_id=2 AND sequence=0 AND reward_id=304051302)))));
INSERT INTO _roost_tasks_guard VALUES('reward_304051301',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304051301 AND description<>'May2013 Roost task reward 304051301')AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304051301 AND NOT(reward_set_id=3040513 AND option_id=1))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304051301)));
INSERT INTO _roost_tasks_guard VALUES('reward_304051302',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304051302 AND description<>'May2013 Roost task reward 304051302')AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304051302 AND NOT(reward_set_id=3040513 AND option_id=2))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304051302)));
INSERT INTO _roost_tasks_guard VALUES('criteria_3040514',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500050500 AND component_type=1 AND component_id=50188 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040514 AND target_id2=0 AND target_value=0 AND component_sequence=2 AND required_count=1))));
INSERT INTO _roost_tasks_guard VALUES('reward_set_3040514',(NOT EXISTS(SELECT 1 FROM reward_sets WHERE reward_set_id=3040514 AND title<>'Help poor Fenith!') AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE reward_set_id=3040514 AND NOT(source_type=2 AND source_id=3040514))AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE source_type=2 AND source_id=3040514 AND reward_set_id<>3040514)));
INSERT INTO _roost_tasks_guard VALUES('options_3040514',(NOT EXISTS(SELECT 1 FROM reward_options WHERE reward_set_id=3040514 AND NOT((option_id=2 AND label='Fenith''s Lunchbox' AND common_to_all=0 AND class_mask=65535 AND flags=0)))));
INSERT INTO _roost_tasks_guard VALUES('links_3040514',(NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_set_id=3040514 AND NOT((option_id=2 AND sequence=0 AND reward_id=304051402)))));
INSERT INTO _roost_tasks_guard VALUES('reward_304051402',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304051402 AND description<>'May2013 Roost task reward 304051402')AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304051402 AND NOT(reward_set_id=3040514 AND option_id=2))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304051402)));
INSERT INTO _roost_tasks_guard VALUES('criteria_3040515',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500050500 AND component_type=1 AND component_id=50189 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040515 AND target_id2=0 AND target_value=0 AND component_sequence=3 AND required_count=1))));
INSERT INTO _roost_tasks_guard VALUES('reward_set_3040515',(NOT EXISTS(SELECT 1 FROM reward_sets WHERE reward_set_id=3040515 AND title<>'A Small Wager') AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE reward_set_id=3040515 AND NOT(source_type=2 AND source_id=3040515))AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE source_type=2 AND source_id=3040515 AND reward_set_id<>3040515)));
INSERT INTO _roost_tasks_guard VALUES('options_3040515',(NOT EXISTS(SELECT 1 FROM reward_options WHERE reward_set_id=3040515 AND NOT((option_id=2 AND label='Dorinda''s Golden Mask' AND common_to_all=0 AND class_mask=65535 AND flags=0)))));
INSERT INTO _roost_tasks_guard VALUES('links_3040515',(NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_set_id=3040515 AND NOT((option_id=2 AND sequence=0 AND reward_id=304051502)))));
INSERT INTO _roost_tasks_guard VALUES('reward_304051502',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304051502 AND description<>'May2013 Roost task reward 304051502')AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304051502 AND NOT(reward_set_id=3040515 AND option_id=2))AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304051502)));
START TRANSACTION;
DELETE FROM task_activities WHERE taskid IN(3040501,3040502,3040503,3040504,3040505,3040506,3040507,3040508,3040509,3040510,3040511,3040512,3040513,3040514,3040515);
DELETE FROM tasks WHERE id IN(3040501,3040502,3040503,3040504,3040505,3040506,3040507,3040508,3040509,3040510,3040511,3040512,3040513,3040514,3040515);
INSERT INTO tasks(`id`,`type`,`title`,`description`,`reward_text`,`reward_id_list`,`cash_reward`,`exp_reward`,`reward_method`,`min_level`,`repeatable`,`faction_reward`,`faction_amount`,`enabled`,`duration`)VALUES
(3040501,2,'Blackfeather Roost, The Ledge','Deliver Griffon Treat to a tame Griffon; Speak with Fenith.','','',0,0,0,50,1,0,0,0,0),
(3040502,2,'Blackfeather Roost, The Grove','Deliver Griffon Treat to a tame Griffon.','','',0,0,0,50,1,0,0,0,0),
(3040503,2,'Blackfeather Roost, The Cliffs','Kill 2 a harpy noble; Speak with Coryn; Deliver Griffon Treat to a tame Griffon.','','',0,0,0,50,1,0,0,0,0),
(3040504,2,'Blackfeather Roost, The Mesa','Kill 1 Lady Inthra; Speak with Mestle; Deliver Griffon Treat to a tame Griffon.','','',0,0,0,50,1,0,0,0,0),
(3040505,2,'Reach the Royal Throne','Kill 1 Captain Slarus; Kill 5 Royal Guard; Deliver Royal Crest to Ashrana.','','',0,0,0,55,1,0,0,0,28800),
(3040506,2,'Kill the Queen of the Harpies!','Collect Royal Emblem.','','',0,0,3,55,1,0,0,0,28800),
(3040507,2,'Strike a Blow - Kill Harpies and Griffons!','Kill 25 harpies; Kill 5 a blackfeather griffon; Speak with Lucian.','','',0,0,3,55,1,0,0,0,0),
(3040508,2,'Destroy! Knock the nests down!','Destroy 2 ledge small harpy nests; Destroy 3 ledge large harpy nests; Destroy 2 grove small harpy nests; Destroy 3 grove large harpy nests; Destroy 2 cliffs small harpy nests; Destroy 3 cliffs large harpy nests; Destroy 5 mesa large harpy nests; Speak with Lucian.','','',0,0,3,60,1,0,0,0,0),
(3040509,2,'Cause some mayhem - Kill Gayatri!','Kill 1 Gayatri; Deliver Gayatri''s Heart to Lucian.','','',0,0,3,50,1,0,0,0,0),
(3040510,2,'Find My Son','Explore the entrance to Blackfeather Roost; Speak with Adrian; Speak with Elder Vasile.','','',0,1000,0,50,0,0,0,0,0),
(3040511,2,'Explore the Roost!','Explore Ledge nest; Explore Harpy Grove; Explore Cliffs; Explore Harpy Mesa; Speak with Adrian.','','',0,1000,0,55,0,0,0,0,0),
(3040512,2,'Harass the Harpies!','Kill 10 a blackfeather griffon; Speak with Adrian.','','',0,0,3,55,1,0,0,0,0),
(3040513,2,'Griffon Feathers','Explore near the Red Griffon Feather; Collect Red Griffon Feather; Explore near the Brown Griffon Feather; Collect Brown Griffon Feather; Explore near the Golden Griffon Feather; Collect Golden Griffon Feather; Explore near the Black Griffon Feather; Collect Black Griffon Feather; Explore near the White Griffon Feather; Collect White Griffon Feather; Deliver Red Griffon Feather to Jenn Stalbath; Deliver Brown Griffon Feather to Jenn Stalbath; Deliver Golden Griffon Feather to Jenn Stalbath; Deliver Black Griffon Feather to Jenn Stalbath; Deliver White Griffon Feather to Jenn Stalbath.','','',45000,0,3,40,0,0,0,0,0),
(3040514,2,'Help poor Fenith!','Kill 20 a mountain puma, a cunning mountain puma, a healthy mountain puma.','','',0,0,3,50,1,0,0,0,0),
(3040515,2,'A Small Wager','Search the Queen’s home for a trinket; Deliver Royal Trinket to Dorinda.','','',0,0,3,50,1,0,0,0,0);
INSERT INTO task_activities(`taskid`,`activityid`,`req_activity_id`,`step`,`activitytype`,`target_name`,`goalmethod`,`goalcount`,`description_override`,`npc_match_list`,`item_id_list`,`zones`,`spell_list`,`optional`,`min_x`,`max_x`,`min_y`,`max_y`,`min_z`,`max_z`)VALUES
(3040501,0,-1,1,1,'',0,1,'Deliver Griffon Treat to a tame Griffon','398020','28674','398','',0,0,0,0,0,0,0),
(3040501,1,-1,2,4,'',0,1,'Speak with Fenith','398018','','398','',0,0,0,0,0,0,0),
(3040502,0,-1,1,1,'',0,1,'Deliver Griffon Treat to a tame Griffon','398020','28675','398','',0,0,0,0,0,0,0),
(3040503,0,-1,1,2,'',0,2,'Kill 2 a harpy noble','398040|398048|398055','','398','',0,0,0,0,0,0,0),
(3040503,1,-1,2,4,'',0,1,'Speak with Coryn','398029','','398','',0,0,0,0,0,0,0),
(3040503,2,-1,3,1,'',0,1,'Deliver Griffon Treat to a tame Griffon','398045','28676','398','',0,0,0,0,0,0,0),
(3040504,0,-1,1,2,'',0,1,'Kill 1 Lady Inthra','398068','','398','',0,0,0,0,0,0,0),
(3040504,1,-1,2,4,'',0,1,'Speak with Mestle','398047','','398','',0,0,0,0,0,0,0),
(3040504,2,-1,3,1,'',0,1,'Deliver Griffon Treat to a tame Griffon','398020','28677','398','',0,0,0,0,0,0,0),
(3040505,0,-1,1,2,'',0,1,'Kill 1 Captain Slarus','398081','','398','',0,0,0,0,0,0,0),
(3040505,1,-1,1,2,'',0,5,'Kill 5 Royal Guard','398077|398080|398082','','398','',0,0,0,0,0,0,0),
(3040505,2,-1,2,1,'',0,1,'Deliver Royal Crest to Ashrana','398070','28672','398','',0,0,0,0,0,0,0),
(3040506,0,-1,1,3,'',0,1,'Collect Royal Emblem','','28673','398','',0,0,0,0,0,0,0),
(3040507,0,-1,1,2,'',0,25,'Kill 25 harpies','398026|398028|398030|398031|398035|398036|398038|398040|398041|398043|398044|398046|398048|398051|398052|398053|398055|398056|398057|398059|398060|398061|398062|398064|398065|398068|398069|398073|398074|398075|398077|398078|398079|398080|398081|398082|398083|398084|398085|398086|398087|398088','','398','',0,0,0,0,0,0,0),
(3040507,1,-1,1,2,'',0,5,'Kill 5 a blackfeather griffon','398037|398058|398063|398066|398071|398072','','398','',0,0,0,0,0,0,0),
(3040507,2,-1,2,4,'',0,1,'Speak with Lucian','398023','','398','',0,0,0,0,0,0,0),
(3040508,0,-1,1,2,'',0,2,'Destroy 2 ledge small harpy nests','398025','','398','',0,0,0,0,0,0,0),
(3040508,1,-1,1,2,'',0,3,'Destroy 3 ledge large harpy nests','398033','','398','',0,0,0,0,0,0,0),
(3040508,2,-1,1,2,'',0,2,'Destroy 2 grove small harpy nests','398032','','398','',0,0,0,0,0,0,0),
(3040508,3,-1,1,2,'',0,3,'Destroy 3 grove large harpy nests','398027','','398','',0,0,0,0,0,0,0),
(3040508,4,-1,1,2,'',0,2,'Destroy 2 cliffs small harpy nests','398049','','398','',0,0,0,0,0,0,0),
(3040508,5,-1,1,2,'',0,3,'Destroy 3 cliffs large harpy nests','398042','','398','',0,0,0,0,0,0,0),
(3040508,6,-1,1,2,'',0,5,'Destroy 5 mesa large harpy nests','398067','','398','',0,0,0,0,0,0,0),
(3040508,7,-1,2,4,'',0,1,'Speak with Lucian','398023','','398','',0,0,0,0,0,0,0),
(3040509,0,-1,1,2,'',0,1,'Kill 1 Gayatri','398065','','398','',0,0,0,0,0,0,0),
(3040509,1,-1,2,1,'',0,1,'Deliver Gayatri''s Heart to Lucian','398023','13617','398','',0,0,0,0,0,0,0),
(3040510,0,-1,1,5,'',0,1,'Explore the entrance to Blackfeather Roost','','','397','',0,3447,3567,1172,1292,224,284),
(3040510,1,-1,2,4,'',0,1,'Speak with Adrian','398022','','398','',0,0,0,0,0,0,0),
(3040510,2,-1,3,4,'',0,1,'Speak with Elder Vasile','397102','','397','',0,0,0,0,0,0,0),
(3040511,0,-1,1,5,'',0,1,'Explore Ledge nest','','','398','',0,-955,-895,3180,3240,-140.305,-100.305),
(3040511,1,-1,1,5,'',0,1,'Explore Harpy Grove','','','398','',0,1070,1130,3720,3780,-128.301,-88.301),
(3040511,2,-1,1,5,'',0,1,'Explore Cliffs','','','398','',0,-2981,-2921,4725,4785,-252.201,-212.201),
(3040511,3,-1,1,5,'',0,1,'Explore Harpy Mesa','','','398','',0,905,965,5920,5980,-45.818,-5.818000000000001),
(3040511,4,-1,2,4,'',0,1,'Speak with Adrian','398022','','398','',0,0,0,0,0,0,0),
(3040512,0,-1,1,2,'',0,10,'Kill 10 a blackfeather griffon','398037|398058|398063|398066|398071|398072','','398','',0,0,0,0,0,0,0),
(3040512,1,-1,2,4,'',0,1,'Speak with Adrian','398022','','398','',0,0,0,0,0,0,0),
(3040513,0,-1,1,5,'',0,1,'Explore near the Red Griffon Feather','','','398','',0,-230,-170,1560,1620,-322.767,-282.767),
(3040513,1,-1,1,255,'',0,1,'Collect Red Griffon Feather','','54655','398','',0,0,0,0,0,0,0),
(3040513,2,-1,2,5,'',0,1,'Explore near the Brown Griffon Feather','','','398','',0,-1320,-1260,3520,3580,-130.41,-90.41),
(3040513,3,-1,2,255,'',0,1,'Collect Brown Griffon Feather','','54663','398','',0,0,0,0,0,0,0),
(3040513,4,-1,3,5,'',0,1,'Explore near the Golden Griffon Feather','','','398','',0,1120,1180,3670,3730,-137.54500000000002,-97.545),
(3040513,5,-1,3,255,'',0,1,'Collect Golden Griffon Feather','','54664','398','',0,0,0,0,0,0,0),
(3040513,6,-1,4,5,'',0,1,'Explore near the Black Griffon Feather','','','398','',0,-530,-470,4780,4840,-71.22800000000001,-31.228),
(3040513,7,-1,4,255,'',0,1,'Collect Black Griffon Feather','','54665','398','',0,0,0,0,0,0,0),
(3040513,8,-1,5,5,'',0,1,'Explore near the White Griffon Feather','','','398','',0,1050,1110,6340,6400,1.251999999999999,41.251999999999995),
(3040513,9,-1,5,255,'',0,1,'Collect White Griffon Feather','','54666','398','',0,0,0,0,0,0,0),
(3040513,10,-1,6,1,'',0,1,'Deliver Red Griffon Feather to Jenn Stalbath','394097','54655','394','',0,0,0,0,0,0,0),
(3040513,11,-1,6,1,'',0,1,'Deliver Brown Griffon Feather to Jenn Stalbath','394097','54663','394','',0,0,0,0,0,0,0),
(3040513,12,-1,6,1,'',0,1,'Deliver Golden Griffon Feather to Jenn Stalbath','394097','54664','394','',0,0,0,0,0,0,0),
(3040513,13,-1,6,1,'',0,1,'Deliver Black Griffon Feather to Jenn Stalbath','394097','54665','394','',0,0,0,0,0,0,0),
(3040513,14,-1,6,1,'',0,1,'Deliver White Griffon Feather to Jenn Stalbath','394097','54666','394','',0,0,0,0,0,0,0),
(3040514,0,-1,1,2,'',0,20,'Kill 20 a mountain puma, a cunning mountain puma, a healthy mountain puma','398000|398002|398003|398010|398019|398092|398094','','398','',0,0,0,0,0,0,0),
(3040515,0,-1,1,5,'',0,1,'Search the Queen’s home for a trinket','','','398','',0,-230,-170,6354,6414,240,280),
(3040515,1,-1,2,1,'',0,1,'Deliver Royal Trinket to Dorinda','398039','28678','398','',0,0,0,0,0,0,0);
DELETE FROM achievement_criteria WHERE achievement_id=500050200 AND component_type=1 AND component_id=50175;
DELETE FROM achievement_criteria WHERE achievement_id=500050200 AND component_type=1 AND component_id=50176;
DELETE FROM achievement_criteria WHERE achievement_id=500050200 AND component_type=1 AND component_id=50177;
DELETE FROM achievement_criteria WHERE achievement_id=500050200 AND component_type=1 AND component_id=50178;
DELETE FROM achievement_criteria WHERE achievement_id=500050200 AND component_type=1 AND component_id=50179;
DELETE FROM achievement_criteria WHERE achievement_id=500050200 AND component_type=1 AND component_id=50180;
DELETE FROM achievement_criteria WHERE achievement_id=500050300 AND component_type=1 AND component_id=50181;
DELETE FROM achievement_criteria WHERE achievement_id=500050300 AND component_type=1 AND component_id=50182;
DELETE FROM achievement_criteria WHERE achievement_id=500050300 AND component_type=1 AND component_id=50183;
DELETE FROM achievement_criteria WHERE achievement_id=500050400 AND component_type=1 AND component_id=50184;
DELETE FROM achievement_criteria WHERE achievement_id=500050400 AND component_type=1 AND component_id=50185;
DELETE FROM achievement_criteria WHERE achievement_id=500050400 AND component_type=1 AND component_id=50186;
DELETE FROM achievement_criteria WHERE achievement_id=500050500 AND component_type=1 AND component_id=50187;
DELETE FROM achievement_criteria WHERE achievement_id=500050500 AND component_type=1 AND component_id=50188;
DELETE FROM achievement_criteria WHERE achievement_id=500050500 AND component_type=1 AND component_id=50189;
INSERT INTO achievement_criteria(`achievement_id`,`component_type`,`component_sequence`,`component_id`,`event_type`,`progress_mode`,`behavior`,`target_id`,`target_id2`,`target_value`,`required_count`,`enabled`)VALUES
(500050200,1,1,50175,4,3,0,3040501,0,0,1,0),
(500050200,1,2,50176,4,3,0,3040502,0,0,1,0),
(500050200,1,3,50177,4,3,0,3040503,0,0,1,0),
(500050200,1,4,50178,4,3,0,3040504,0,0,1,0),
(500050200,1,5,50179,4,3,0,3040505,0,0,1,0),
(500050200,1,6,50180,4,3,0,3040506,0,0,1,0),
(500050300,1,1,50181,4,3,0,3040507,0,0,1,0),
(500050300,1,2,50182,4,3,0,3040508,0,0,1,0),
(500050300,1,3,50183,4,3,0,3040509,0,0,1,0),
(500050400,1,1,50184,4,3,0,3040510,0,0,1,0),
(500050400,1,2,50185,4,3,0,3040511,0,0,1,0),
(500050400,1,3,50186,4,3,0,3040512,0,0,1,0),
(500050500,1,1,50187,4,3,0,3040513,0,0,1,0),
(500050500,1,2,50188,4,3,0,3040514,0,0,1,0),
(500050500,1,3,50189,4,3,0,3040515,0,0,1,0);
DELETE FROM reward_option_entries WHERE reward_set_id IN(3040506,3040507,3040508,3040509,3040512,3040513,3040514,3040515);
DELETE FROM reward_options WHERE reward_set_id IN(3040506,3040507,3040508,3040509,3040512,3040513,3040514,3040515);
DELETE FROM reward_sources WHERE reward_set_id IN(3040506,3040507,3040508,3040509,3040512,3040513,3040514,3040515);
DELETE FROM reward_sets WHERE reward_set_id IN(3040506,3040507,3040508,3040509,3040512,3040513,3040514,3040515);
DELETE FROM rewards WHERE reward_id IN(304050602,304050603,304050604,304050605,304050606,304050701,304050702,304050801,304050802,304050901,304050902,304051201,304051202,304051301,304051302,304051402,304051502);
INSERT INTO reward_sets(`reward_set_id`,`title`,`enabled`)VALUES
(3040506,'Kill the Queen of the Harpies!',0),
(3040507,'Strike a Blow - Kill Harpies and Griffons!',0),
(3040508,'Destroy! Knock the nests down!',0),
(3040509,'Cause some mayhem - Kill Gayatri!',0),
(3040512,'Harass the Harpies!',0),
(3040513,'Griffon Feathers',0),
(3040514,'Help poor Fenith!',0),
(3040515,'A Small Wager',0);
INSERT INTO reward_sources(`source_type`,`source_id`,`reward_set_id`,`enabled`)VALUES
(2,3040506,3040506,0),
(2,3040507,3040507,0),
(2,3040508,3040508,0),
(2,3040509,3040509,0),
(2,3040512,3040512,0),
(2,3040513,3040513,0),
(2,3040514,3040514,0),
(2,3040515,3040515,0);
INSERT INTO rewards(`reward_id`,`reward_type`,`reward_data_id`,`amount`,`description`,`enabled`)VALUES
(304050602,0,53601,1,'May2013 Roost task reward 304050602',0),
(304050603,0,53600,1,'May2013 Roost task reward 304050603',0),
(304050604,0,53597,1,'May2013 Roost task reward 304050604',0),
(304050605,0,53598,1,'May2013 Roost task reward 304050605',0),
(304050606,0,53599,1,'May2013 Roost task reward 304050606',0),
(304050701,1,1,1000,'May2013 Roost task reward 304050701',0),
(304050702,0,53607,1,'May2013 Roost task reward 304050702',0),
(304050801,1,1,1000,'May2013 Roost task reward 304050801',0),
(304050802,0,53610,1,'May2013 Roost task reward 304050802',0),
(304050901,1,1,1000,'May2013 Roost task reward 304050901',0),
(304050902,0,53609,1,'May2013 Roost task reward 304050902',0),
(304051201,1,1,1000,'May2013 Roost task reward 304051201',0),
(304051202,0,53608,1,'May2013 Roost task reward 304051202',0),
(304051301,1,1,1000,'May2013 Roost task reward 304051301',0),
(304051302,0,53606,1,'May2013 Roost task reward 304051302',0),
(304051402,0,53611,5,'May2013 Roost task reward 304051402',0),
(304051502,0,53612,1,'May2013 Roost task reward 304051502',0);
INSERT INTO reward_options(`reward_set_id`,`option_id`,`sequence`,`label`,`common_to_all`,`flags`,`enabled`,`class_mask`)VALUES
(3040506,2,2,'Blackfeather Ablestone',0,0,0,65535),
(3040506,3,3,'Blackfeather Focus Stone',0,0,0,65535),
(3040506,4,4,'Blackfeather Healthstone',0,0,0,65535),
(3040506,5,5,'Blackfeather Powerstone',0,0,0,65535),
(3040506,6,6,'Blackfeather Shockstone',0,0,0,65535),
(3040507,1,1,'Experience',1,0,0,65535),
(3040507,2,2,'Satyr Hunter''s Draught',0,0,0,65535),
(3040508,1,1,'Experience',1,0,0,65535),
(3040508,2,2,'Griffonbane Hammer',0,0,0,65535),
(3040509,1,1,'Experience',1,0,0,65535),
(3040509,2,2,'Gayatri''s Shawl',0,0,0,65535),
(3040512,1,1,'Experience',1,0,0,65535),
(3040512,2,2,'Satyr Draught of Insight',0,0,0,65535),
(3040513,1,1,'Experience',1,0,0,65535),
(3040513,2,2,'Griffon Feather Cap',0,0,0,65535),
(3040514,2,2,'Fenith''s Lunchbox',0,0,0,65535),
(3040515,2,2,'Dorinda''s Golden Mask',0,0,0,65535);
INSERT INTO reward_option_entries(`reward_set_id`,`option_id`,`sequence`,`reward_id`)VALUES
(3040506,2,0,304050602),
(3040506,3,0,304050603),
(3040506,4,0,304050604),
(3040506,5,0,304050605),
(3040506,6,0,304050606),
(3040507,1,0,304050701),
(3040507,2,0,304050702),
(3040508,1,0,304050801),
(3040508,2,0,304050802),
(3040509,1,0,304050901),
(3040509,2,0,304050902),
(3040512,1,0,304051201),
(3040512,2,0,304051202),
(3040513,1,0,304051301),
(3040513,2,0,304051302),
(3040514,2,0,304051402),
(3040515,2,0,304051502);
COMMIT;
