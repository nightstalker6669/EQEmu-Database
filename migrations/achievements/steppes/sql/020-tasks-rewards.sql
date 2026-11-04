-- Complete disabled Steppes journal/reward candidate. OFFLINE, NOT INSTALLED.
SET NAMES utf8mb4;
SET SESSION check_constraint_checks=1;
DROP TEMPORARY TABLE IF EXISTS _steppes_guard;
CREATE TEMPORARY TABLE _steppes_guard(label VARCHAR(100)PRIMARY KEY,ok TINYINT NOT NULL,CHECK(ok=1))ENGINE=InnoDB;
INSERT INTO _steppes_guard VALUES('review',(COALESCE(@steppes_reviewed,0)=1));
INSERT INTO _steppes_guard VALUES('task_identity',(NOT EXISTS(SELECT 1 FROM tasks WHERE id IN(3040601,3040602,3040603,3040604,3040605,3040606,3040607,3040608,3040609,3040610,3040611,3040612,3040613) AND NOT((id=3040601 AND type=2 AND title='Clay for Selana') OR (id=3040602 AND type=2 AND title='Wood for Carving') OR (id=3040603 AND type=2 AND title='Cull the Gnolls') OR (id=3040604 AND type=2 AND title='Cull the Goblins') OR (id=3040605 AND type=1 AND title='Sweeping the Steppes: Goblins') OR (id=3040606 AND type=1 AND title='Sweeping the Steppes: Gnolls') OR (id=3040607 AND type=1 AND title='Sowing Dissent') OR (id=3040608 AND type=2 AND title='Book for Toegnasher') OR (id=3040609 AND type=1 AND title='Treasure of the Dead') OR (id=3040610 AND type=1 AND title='Web of Curiosity') OR (id=3040611 AND type=2 AND title='The Talking Plant') OR (id=3040612 AND type=2 AND title='The Library') OR (id=3040613 AND type=2 AND title='The Destroyed Portal')))));
INSERT INTO _steppes_guard VALUES('item_identity',((SELECT COUNT(*)FROM items WHERE (id=13063 AND Name='Piece of Parchment') OR (id=53613 AND Name='Totem of the Stonemight') OR (id=53614 AND Name='Gnollbiter') OR (id=53615 AND Name='Gnollcracker') OR (id=53616 AND Name='Gnollcleaver') OR (id=53617 AND Name='Darkfell Starstone') OR (id=53618 AND Name='Stonemight Cupcake') OR (id=53619 AND Name='Darkfell Wineshot') OR (id=53623 AND Name='Saplift Potion') OR (id=53628 AND Name='Healing Mud') OR (id=53629 AND Name='Assassin Weave Cape') OR (id=53630 AND Name='Plundered Krithgorian Knife') OR (id=53632 AND Name='Necklace of Warportal Fragments') OR (id=53635 AND Name='Toegnasher''s Token') OR (id=54667 AND Name='Ancient Charm') OR (id=54668 AND Name='Ancient Giant Book One') OR (id=54669 AND Name='Ancient Giant Book Two') OR (id=54670 AND Name='Portal Rock') OR (id=54671 AND Name='Portal Fragment') OR (id=84238 AND Name='Lump of Elemental Clay') OR (id=84239 AND Name='Living Wood Sample') OR (id=84240 AND Name='Darkfell Fang') OR (id=84241 AND Name='Stonemight Ear') OR (id=84243 AND Name='Gnoll Rune Trap') OR (id=87206 AND Name='Portal Fragment') OR (id=87207 AND Name='Portal Fragment') OR (id=87208 AND Name='Portal Fragment') OR (id=88137 AND Name='Ancient Parchment') OR (id=88138 AND Name='Ancient Parchment') OR (id=88139 AND Name='Ancient Parchment') OR (id=88140 AND Name='Copy of Druidic Rune') OR (id=88141 AND Name='Drakkin Trail Mix') OR (id=88142 AND Name='Fresh Glacier Water') OR (id=108404 AND Name='Intricate Soldier''s Gorget') OR (id=108405 AND Name='Intricate Soldier''s Pauldrons') OR (id=108414 AND Name='Intricate Scryer''s Necklace') OR (id=108415 AND Name='Intricate Scryer''s Shoulderpads') OR (id=108588 AND Name='Intricate Consigned Hammer') OR (id=108589 AND Name='Intricate Consigned Mace') OR (id=108590 AND Name='Intricate Consigned Katana') OR (id=108591 AND Name='Intricate Consigned Scimitar') OR (id=108592 AND Name='Intricate Consigned Sacrificial Dagger') OR (id=108598 AND Name='Intricate Consigned Bow') OR (id=108599 AND Name='Intricate Consigned Hammered Buckler') OR (id=108600 AND Name='Intricate Consigned Targ Shield'))=45));
INSERT INTO _steppes_guard VALUES('npc_identity',((SELECT COUNT(*)FROM npc_types WHERE (id=394153 AND name='Selana') OR (id=394191 AND name='Daer`Lagar') OR (id=394200 AND name='Warden_Jakar') OR (id=399010 AND name='a_Stonemight_goblin') OR (id=399011 AND name='a_Stonemight_goblin') OR (id=399013 AND name='a_Stonemight_goblin') OR (id=399014 AND name='a_Stonemight_goblin') OR (id=399017 AND name='a_Stonemight_elder') OR (id=399019 AND name='a_Stonemight_goblin') OR (id=399021 AND name='a_Stonemight_goblin') OR (id=399022 AND name='a_Stonemight_stonebinder') OR (id=399023 AND name='a_Stonemight_shaman') OR (id=399024 AND name='a_Stonemight_elder') OR (id=399025 AND name='a_Stonemight_goblin') OR (id=399026 AND name='a_Stonemight_tracker') OR (id=399028 AND name='a_Stonemight_stonebinder') OR (id=399030 AND name='a_Stonemight_warrior') OR (id=399031 AND name='a_Stonemight_tracker') OR (id=399032 AND name='Yavia') OR (id=399038 AND name='a_Stonemight_veteran') OR (id=399039 AND name='a_Stonemight_goblin') OR (id=399042 AND name='a_Stonemight_shaman') OR (id=399044 AND name='an_earthen_elemental') OR (id=399046 AND name='an_earthen_elemental') OR (id=399047 AND name='a_Stonemight_stonebinder') OR (id=399049 AND name='#Stonemight_Chieftain_Swiftear') OR (id=399050 AND name='a_Stonemight_shaman') OR (id=399051 AND name='a_Stonemight_raider') OR (id=399052 AND name='a_Stonemight_hunter') OR (id=399053 AND name='a_massive_elemental') OR (id=399056 AND name='a_Stonemight_marauder') OR (id=399057 AND name='a_Darkfell_elder') OR (id=399063 AND name='a_massive_elemental') OR (id=399064 AND name='a_massive_elemental') OR (id=399070 AND name='#Moldren_the_Wise') OR (id=399073 AND name='#Wilped_the_Withered') OR (id=399075 AND name='a_Darkfell_archer') OR (id=399076 AND name='a_Darkfell_archer') OR (id=399094 AND name='a_Darkfell_scavenger') OR (id=399096 AND name='a_Darkfell_huntmaster') OR (id=399097 AND name='a_Darkfell_sharpshooter') OR (id=399098 AND name='a_Darkfell_gnoll') OR (id=399099 AND name='a_Darkfell_gnoll') OR (id=399100 AND name='#Toegnasher') OR (id=399101 AND name='a_Darkfell_shaman') OR (id=399102 AND name='a_Darkfell_gnoll') OR (id=399103 AND name='a_Darkfell_gnoll') OR (id=399104 AND name='a_Darkfell_gnoll') OR (id=399105 AND name='a_Darkfell_gnoll') OR (id=399107 AND name='a_Darkfell_gnoll') OR (id=399108 AND name='a_Darkfell_shaman') OR (id=399109 AND name='a_Darkfell_gnoll') OR (id=399110 AND name='a_Darkfell_gnoll') OR (id=399111 AND name='a_Darkfell_shaman') OR (id=399113 AND name='a_Darkfell_captain') OR (id=399115 AND name='a_Darkfell_warrior') OR (id=399117 AND name='a_Darkfell_hunter') OR (id=399118 AND name='a_Darkfell_gnoll') OR (id=399119 AND name='a_Darkfell_warrior') OR (id=399125 AND name='a_Darkfell_scavenger') OR (id=399127 AND name='a_Darkfell_shaman') OR (id=399128 AND name='a_Darkfell_gnoll') OR (id=399129 AND name='a_Darkfell_archer') OR (id=399130 AND name='a_Darkfell_scavenger') OR (id=399136 AND name='a_Darkfell_gnoll') OR (id=399139 AND name='Bordan_the_Cursed') OR (id=399140 AND name='a_Darkfell_elder') OR (id=399141 AND name='a_Darkfell_captain') OR (id=399142 AND name='a_Darkfell_elder') OR (id=399153 AND name='a_Darkfell_militant') OR (id=399154 AND name='a_Darkfell_militant'))=71));
INSERT INTO _steppes_guard VALUES('component_identity',((SELECT COUNT(*)FROM achievement_components WHERE (achievement_id=500060200 AND component_type=1 AND component_id=50196 AND sequence=7 AND name='Selana - Clay for Selana') OR (achievement_id=500060200 AND component_type=1 AND component_id=50195 AND sequence=6 AND name='Daer`Lagar - Wood for Carving') OR (achievement_id=500060200 AND component_type=1 AND component_id=50193 AND sequence=4 AND name='Warden Jakar - Cull the Gnolls') OR (achievement_id=500060200 AND component_type=1 AND component_id=50192 AND sequence=3 AND name='Warden Jakar - Cull the Goblins') OR (achievement_id=500060200 AND component_type=1 AND component_id=50190 AND sequence=1 AND name='Warden Jakar - Sweeping the Steppes: Goblins') OR (achievement_id=500060200 AND component_type=1 AND component_id=50191 AND sequence=2 AND name='Warden Jakar - Sweeping the Steppes: Gnolls') OR (achievement_id=500060200 AND component_type=1 AND component_id=50194 AND sequence=5 AND name='Warden Jakar - Sowing Dissent') OR (achievement_id=500060300 AND component_type=1 AND component_id=50199 AND sequence=3 AND name='Toegnasher - Book for Toegnasher') OR (achievement_id=500060300 AND component_type=1 AND component_id=50198 AND sequence=2 AND name='Bordan the Cursed - Treasure of the Dead') OR (achievement_id=500060300 AND component_type=1 AND component_id=50197 AND sequence=1 AND name='Yavia - Web of Curiosity') OR (achievement_id=500060400 AND component_type=1 AND component_id=50200 AND sequence=1 AND name='Moldren the Wise - The Talking Plant') OR (achievement_id=500060400 AND component_type=1 AND component_id=50201 AND sequence=2 AND name='Moldren the Wise - The Library') OR (achievement_id=500060400 AND component_type=1 AND component_id=50202 AND sequence=3 AND name='Wilped the Withered - The Destroyed Portal'))=13));
INSERT INTO _steppes_guard VALUES('criteria_3040601',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500060200 AND component_type=1 AND component_id=50196 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040601 AND target_id2=0 AND target_value=0 AND component_sequence=7 AND required_count=1))));
INSERT INTO _steppes_guard VALUES('criteria_3040602',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500060200 AND component_type=1 AND component_id=50195 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040602 AND target_id2=0 AND target_value=0 AND component_sequence=6 AND required_count=1))));
INSERT INTO _steppes_guard VALUES('criteria_3040603',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500060200 AND component_type=1 AND component_id=50193 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040603 AND target_id2=0 AND target_value=0 AND component_sequence=4 AND required_count=1))));
INSERT INTO _steppes_guard VALUES('criteria_3040604',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500060200 AND component_type=1 AND component_id=50192 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040604 AND target_id2=0 AND target_value=0 AND component_sequence=3 AND required_count=1))));
INSERT INTO _steppes_guard VALUES('criteria_3040605',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500060200 AND component_type=1 AND component_id=50190 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040605 AND target_id2=0 AND target_value=0 AND component_sequence=1 AND required_count=1))));
INSERT INTO _steppes_guard VALUES('criteria_3040606',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500060200 AND component_type=1 AND component_id=50191 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040606 AND target_id2=0 AND target_value=0 AND component_sequence=2 AND required_count=1))));
INSERT INTO _steppes_guard VALUES('set_3040606',(NOT EXISTS(SELECT 1 FROM reward_sets WHERE reward_set_id=3040606 AND title<>'Sweeping the Steppes: Gnolls') AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE reward_set_id=3040606 AND NOT(source_type=2 AND source_id=3040606)) AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE source_type=2 AND source_id=3040606 AND reward_set_id<>3040606)));
INSERT INTO _steppes_guard VALUES('reward_304060610',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304060610 AND description<>'May2013 Steppes reward 304060610') AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304060610 AND NOT(reward_set_id=3040606 AND option_id=1)) AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304060610)));
INSERT INTO _steppes_guard VALUES('reward_304060620',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304060620 AND description<>'May2013 Steppes reward 304060620') AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304060620 AND NOT(reward_set_id=3040606 AND option_id=2)) AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304060620)));
INSERT INTO _steppes_guard VALUES('reward_304060630',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304060630 AND description<>'May2013 Steppes reward 304060630') AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304060630 AND NOT(reward_set_id=3040606 AND option_id=3)) AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304060630)));
INSERT INTO _steppes_guard VALUES('reward_304060640',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304060640 AND description<>'May2013 Steppes reward 304060640') AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304060640 AND NOT(reward_set_id=3040606 AND option_id=4)) AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304060640)));
INSERT INTO _steppes_guard VALUES('options_3040606',(NOT EXISTS(SELECT 1 FROM reward_options WHERE reward_set_id=3040606 AND NOT((option_id=1 AND label='Experience' AND common_to_all=1 AND class_mask=65535 AND flags=0) OR (option_id=2 AND label='Gnollbiter' AND common_to_all=0 AND class_mask=65535 AND flags=0) OR (option_id=3 AND label='Gnollcracker' AND common_to_all=0 AND class_mask=65535 AND flags=0) OR (option_id=4 AND label='Gnollcleaver' AND common_to_all=0 AND class_mask=65535 AND flags=0)))));
INSERT INTO _steppes_guard VALUES('links_3040606',(NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_set_id=3040606 AND NOT((option_id=1 AND sequence=0 AND reward_id=304060610) OR (option_id=2 AND sequence=0 AND reward_id=304060620) OR (option_id=3 AND sequence=0 AND reward_id=304060630) OR (option_id=4 AND sequence=0 AND reward_id=304060640)))));
INSERT INTO _steppes_guard VALUES('criteria_3040607',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500060200 AND component_type=1 AND component_id=50194 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040607 AND target_id2=0 AND target_value=0 AND component_sequence=5 AND required_count=1))));
INSERT INTO _steppes_guard VALUES('criteria_3040608',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500060300 AND component_type=1 AND component_id=50199 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040608 AND target_id2=0 AND target_value=0 AND component_sequence=3 AND required_count=1))));
INSERT INTO _steppes_guard VALUES('criteria_3040609',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500060300 AND component_type=1 AND component_id=50198 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040609 AND target_id2=0 AND target_value=0 AND component_sequence=2 AND required_count=1))));
INSERT INTO _steppes_guard VALUES('criteria_3040610',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500060300 AND component_type=1 AND component_id=50197 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040610 AND target_id2=0 AND target_value=0 AND component_sequence=1 AND required_count=1))));
INSERT INTO _steppes_guard VALUES('criteria_3040611',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500060400 AND component_type=1 AND component_id=50200 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040611 AND target_id2=0 AND target_value=0 AND component_sequence=1 AND required_count=1))));
INSERT INTO _steppes_guard VALUES('criteria_3040612',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500060400 AND component_type=1 AND component_id=50201 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040612 AND target_id2=0 AND target_value=0 AND component_sequence=2 AND required_count=1))));
INSERT INTO _steppes_guard VALUES('criteria_3040613',(NOT EXISTS(SELECT 1 FROM achievement_criteria WHERE achievement_id=500060400 AND component_type=1 AND component_id=50202 AND NOT(event_type=4 AND progress_mode=3 AND behavior=0 AND target_id=3040613 AND target_id2=0 AND target_value=0 AND component_sequence=3 AND required_count=1))));
INSERT INTO _steppes_guard VALUES('set_3040691',(NOT EXISTS(SELECT 1 FROM reward_sets WHERE reward_set_id=3040691 AND title<>'Conquering The Steppes (61-70)') AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE reward_set_id=3040691 AND NOT(source_type=1 AND source_id=500060200)) AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE source_type=1 AND source_id=500060200 AND reward_set_id<>3040691)));
INSERT INTO _steppes_guard VALUES('reward_304069110',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304069110 AND description<>'May2013 Steppes reward 304069110') AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304069110 AND NOT(reward_set_id=3040691 AND option_id=1)) AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304069110)));
INSERT INTO _steppes_guard VALUES('reward_304069111',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304069111 AND description<>'May2013 Steppes reward 304069111') AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304069111 AND NOT(reward_set_id=3040691 AND option_id=1)) AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304069111)));
INSERT INTO _steppes_guard VALUES('reward_304069120',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304069120 AND description<>'May2013 Steppes reward 304069120') AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304069120 AND NOT(reward_set_id=3040691 AND option_id=2)) AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304069120)));
INSERT INTO _steppes_guard VALUES('reward_304069121',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304069121 AND description<>'May2013 Steppes reward 304069121') AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304069121 AND NOT(reward_set_id=3040691 AND option_id=2)) AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304069121)));
INSERT INTO _steppes_guard VALUES('reward_304069130',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304069130 AND description<>'May2013 Steppes reward 304069130') AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304069130 AND NOT(reward_set_id=3040691 AND option_id=3)) AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304069130)));
INSERT INTO _steppes_guard VALUES('reward_304069131',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304069131 AND description<>'May2013 Steppes reward 304069131') AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304069131 AND NOT(reward_set_id=3040691 AND option_id=3)) AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304069131)));
INSERT INTO _steppes_guard VALUES('reward_304069140',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304069140 AND description<>'May2013 Steppes reward 304069140') AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304069140 AND NOT(reward_set_id=3040691 AND option_id=4)) AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304069140)));
INSERT INTO _steppes_guard VALUES('reward_304069141',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304069141 AND description<>'May2013 Steppes reward 304069141') AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304069141 AND NOT(reward_set_id=3040691 AND option_id=4)) AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304069141)));
INSERT INTO _steppes_guard VALUES('reward_304069150',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304069150 AND description<>'May2013 Steppes reward 304069150') AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304069150 AND NOT(reward_set_id=3040691 AND option_id=5)) AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304069150)));
INSERT INTO _steppes_guard VALUES('reward_304069151',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304069151 AND description<>'May2013 Steppes reward 304069151') AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304069151 AND NOT(reward_set_id=3040691 AND option_id=5)) AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304069151)));
INSERT INTO _steppes_guard VALUES('reward_304069160',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304069160 AND description<>'May2013 Steppes reward 304069160') AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304069160 AND NOT(reward_set_id=3040691 AND option_id=6)) AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304069160)));
INSERT INTO _steppes_guard VALUES('reward_304069161',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304069161 AND description<>'May2013 Steppes reward 304069161') AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304069161 AND NOT(reward_set_id=3040691 AND option_id=6)) AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304069161)));
INSERT INTO _steppes_guard VALUES('options_3040691',(NOT EXISTS(SELECT 1 FROM reward_options WHERE reward_set_id=3040691 AND NOT((option_id=1 AND label='Intricate Consigned Bow' AND common_to_all=0 AND class_mask=49629 AND flags=0) OR (option_id=2 AND label='Intricate Consigned Hammer' AND common_to_all=0 AND class_mask=49629 AND flags=0) OR (option_id=3 AND label='Intricate Consigned Katana' AND common_to_all=0 AND class_mask=49629 AND flags=0) OR (option_id=4 AND label='Intricate Consigned Sacrificial Dagger' AND common_to_all=0 AND class_mask=49629 AND flags=0) OR (option_id=5 AND label='Intricate Consigned Scimitar' AND common_to_all=0 AND class_mask=49629 AND flags=0) OR (option_id=6 AND label='Intricate caster shield and mace' AND common_to_all=0 AND class_mask=15906 AND flags=0)))));
INSERT INTO _steppes_guard VALUES('links_3040691',(NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_set_id=3040691 AND NOT((option_id=1 AND sequence=0 AND reward_id=304069110) OR (option_id=1 AND sequence=1 AND reward_id=304069111) OR (option_id=2 AND sequence=0 AND reward_id=304069120) OR (option_id=2 AND sequence=1 AND reward_id=304069121) OR (option_id=3 AND sequence=0 AND reward_id=304069130) OR (option_id=3 AND sequence=1 AND reward_id=304069131) OR (option_id=4 AND sequence=0 AND reward_id=304069140) OR (option_id=4 AND sequence=1 AND reward_id=304069141) OR (option_id=5 AND sequence=0 AND reward_id=304069150) OR (option_id=5 AND sequence=1 AND reward_id=304069151) OR (option_id=6 AND sequence=0 AND reward_id=304069160) OR (option_id=6 AND sequence=1 AND reward_id=304069161)))));
INSERT INTO _steppes_guard VALUES('set_3040692',(NOT EXISTS(SELECT 1 FROM reward_sets WHERE reward_set_id=3040692 AND title<>'Steppe Right Up (Steppes 60+)') AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE reward_set_id=3040692 AND NOT(source_type=1 AND source_id=500060300)) AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE source_type=1 AND source_id=500060300 AND reward_set_id<>3040692)));
INSERT INTO _steppes_guard VALUES('reward_304069210',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304069210 AND description<>'May2013 Steppes reward 304069210') AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304069210 AND NOT(reward_set_id=3040692 AND option_id=1)) AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304069210)));
INSERT INTO _steppes_guard VALUES('reward_304069220',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304069220 AND description<>'May2013 Steppes reward 304069220') AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304069220 AND NOT(reward_set_id=3040692 AND option_id=2)) AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304069220)));
INSERT INTO _steppes_guard VALUES('options_3040692',(NOT EXISTS(SELECT 1 FROM reward_options WHERE reward_set_id=3040692 AND NOT((option_id=1 AND label='Intricate Soldier''s Gorget' AND common_to_all=0 AND class_mask=49629 AND flags=0) OR (option_id=2 AND label='Intricate Scryer''s Necklace' AND common_to_all=0 AND class_mask=15906 AND flags=0)))));
INSERT INTO _steppes_guard VALUES('links_3040692',(NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_set_id=3040692 AND NOT((option_id=1 AND sequence=0 AND reward_id=304069210) OR (option_id=2 AND sequence=0 AND reward_id=304069220)))));
INSERT INTO _steppes_guard VALUES('set_3040693',(NOT EXISTS(SELECT 1 FROM reward_sets WHERE reward_set_id=3040693 AND title<>'Rebuilding the Portal (Steppes 60+)') AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE reward_set_id=3040693 AND NOT(source_type=1 AND source_id=500060400)) AND NOT EXISTS(SELECT 1 FROM reward_sources WHERE source_type=1 AND source_id=500060400 AND reward_set_id<>3040693)));
INSERT INTO _steppes_guard VALUES('reward_304069310',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304069310 AND description<>'May2013 Steppes reward 304069310') AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304069310 AND NOT(reward_set_id=3040693 AND option_id=1)) AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304069310)));
INSERT INTO _steppes_guard VALUES('reward_304069320',(NOT EXISTS(SELECT 1 FROM rewards WHERE reward_id=304069320 AND description<>'May2013 Steppes reward 304069320') AND NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_id=304069320 AND NOT(reward_set_id=3040693 AND option_id=2)) AND NOT EXISTS(SELECT 1 FROM reward_source_entries WHERE reward_id=304069320)));
INSERT INTO _steppes_guard VALUES('options_3040693',(NOT EXISTS(SELECT 1 FROM reward_options WHERE reward_set_id=3040693 AND NOT((option_id=1 AND label='Intricate Soldier''s Pauldrons' AND common_to_all=0 AND class_mask=49629 AND flags=0) OR (option_id=2 AND label='Intricate Scryer''s Shoulderpads' AND common_to_all=0 AND class_mask=15906 AND flags=0)))));
INSERT INTO _steppes_guard VALUES('links_3040693',(NOT EXISTS(SELECT 1 FROM reward_option_entries WHERE reward_set_id=3040693 AND NOT((option_id=1 AND sequence=0 AND reward_id=304069310) OR (option_id=2 AND sequence=0 AND reward_id=304069320)))));
START TRANSACTION;
DELETE FROM task_activities WHERE taskid IN(3040601,3040602,3040603,3040604,3040605,3040606,3040607,3040608,3040609,3040610,3040611,3040612,3040613);
DELETE FROM tasks WHERE id IN(3040601,3040602,3040603,3040604,3040605,3040606,3040607,3040608,3040609,3040610,3040611,3040612,3040613);
INSERT INTO tasks(`id`,`type`,`duration`,`title`,`description`,`reward_text`,`reward_id_list`,`cash_reward`,`exp_reward`,`reward_method`,`min_level`,`level_spread`,`min_players`,`max_players`,`repeatable`,`faction_reward`,`faction_amount`,`enabled`)VALUES
(3040601,2,0,'Clay for Selana','Kill earthen and massive elementals; Loot Lump of Elemental Clay; Deliver clay to Selana.','','53628,10',0,1000,0,65,0,1,1,1,0,0,0),
(3040602,2,0,'Wood for Carving','Collect Living Wood Samples; Deliver wood to Daer`Lagar.','','53623,10',0,1000,0,65,0,1,1,1,0,0,0),
(3040603,2,0,'Cull the Gnolls','Collect Darkfell Fangs (held items accepted); Deliver Darkfell Fangs to Warden Jakar.','','53619,5',0,1000,0,60,0,1,1,1,0,0,0),
(3040604,2,0,'Cull the Goblins','Collect Stonemight Ears (held items accepted); Deliver Stonemight Ears to Warden Jakar.','','53618,5',0,1000,0,62,0,1,1,1,0,0,0),
(3040605,1,21600,'Sweeping the Steppes: Goblins','Slay Stonemight goblins; Kill the domesticated bear; Return to Warden Jakar.','','53613',0,1000,0,60,0,1,6,0,0,0,0),
(3040606,1,0,'Sweeping the Steppes: Gnolls','Slay Darkfell gnolls; Kill the tribal defenders; Kill the Darkfell elites; Return to Warden Jakar.','','',0,0,3,55,0,1,6,1,0,0,0),
(3040607,1,0,'Sowing Dissent','Steal and set a Gnoll Rune Trap in the goblin camps; Watch three goblins be slain by the trap; Return to Warden Jakar.','','53617',0,1000,0,60,0,1,6,1,0,0,0),
(3040608,2,0,'Book for Toegnasher','Deliver the first ancient page; Deliver the second ancient page; Deliver the third ancient page; Make a rubbing of the druid stone with parchment on cursor; Deliver Copy of Druidic Rune.','','53635',0,1000,0,70,0,1,1,1,0,0,0),
(3040609,1,0,'Treasure of the Dead','Find the burial chamber where Bordan obtained his curse; Check the treasure chest; Kill the Crypt Guardian; Return to Bordan the Cursed.','','53630',0,0,0,60,15,3,6,1,0,0,0),
(3040610,1,0,'Web of Curiosity','Deliver Drakkin Trail Mix to Yavia; Deliver Fresh Glacier Water to Yavia; Kill assassin spiderlings; Deliver Drakkin Trail Mix to Yavia; Deliver Fresh Glacier Water to Yavia; Kill assassin spiders; Deliver Drakkin Trail Mix to Yavia; Deliver Fresh Glacier Water to Yavia; Kill assassin spiders; Deliver Drakkin Trail Mix to Yavia; Deliver Fresh Glacier Water to Yavia; Kill mature assassin spiders; Deliver Drakkin Trail Mix to Yavia; Deliver Fresh Glacier Water to Yavia; Kill assassin spider queen; Speak to Yavia.','','53629',0,1000,0,53,0,1,6,1,0,0,0),
(3040611,2,0,'The Talking Plant','Explore the ancient giant crypt far to the north; Slay the Prophet Spirit; Loot the Ancient Charm; Deliver Ancient Charm to Moldren the Wise.','','87206',0,1000,0,65,0,1,1,0,0,0,0),
(3040612,2,0,'The Library','Explore Valdeholm homes with bookcases; Grab Ancient Giant Book One; Grab Ancient Giant Book Two; Deliver Ancient Giant Book One to Moldren; Deliver Ancient Giant Book Two to Moldren.','','87207',0,1000,0,60,0,1,1,1,0,0,0),
(3040613,2,0,'The Destroyed Portal','Loot Portal Fragments from Direwind golems; Loot Portal Rocks from Icefall kobolds; Explore the site of the destroyed portal; Kill the Portal Guardian; Deliver Portal Fragments to Moldren; Deliver Portal Rocks to Moldren.','','53632|87208',0,1000,0,60,0,1,1,1,0,0,0);
INSERT INTO task_activities(`taskid`,`activityid`,`req_activity_id`,`step`,`activitytype`,`target_name`,`goalmethod`,`goalcount`,`description_override`,`npc_match_list`,`item_id_list`,`zones`,`spell_list`,`optional`,`min_x`,`max_x`,`min_y`,`max_y`,`min_z`,`max_z`)VALUES
(3040601,0,-1,0,2,'',0,10,'Kill earthen and massive elementals','399044|399046|399053|399063|399064','','399','',0,0,0,0,0,0,0),
(3040601,1,-1,0,3,'',0,4,'Loot Lump of Elemental Clay','','84238','399','',0,0,0,0,0,0,0),
(3040601,2,-1,1,1,'',0,4,'Deliver clay to Selana','394153','84238','394','',0,0,0,0,0,0,0),
(3040602,0,-1,0,3,'',0,4,'Collect Living Wood Samples','','84239','399','',0,0,0,0,0,0,0),
(3040602,1,-1,1,1,'',0,4,'Deliver wood to Daer`Lagar','394191','84239','394','',0,0,0,0,0,0,0),
(3040603,0,-1,0,255,'',0,10,'Collect Darkfell Fangs (held items accepted)','','84240','399','',0,0,0,0,0,0,0),
(3040603,1,-1,1,1,'',0,10,'Deliver Darkfell Fangs to Warden Jakar','394200','84240','394','',0,0,0,0,0,0,0),
(3040604,0,-1,0,255,'',0,10,'Collect Stonemight Ears (held items accepted)','','84241','399','',0,0,0,0,0,0,0),
(3040604,1,-1,1,1,'',0,10,'Deliver Stonemight Ears to Warden Jakar','394200','84241','394','',0,0,0,0,0,0,0),
(3040605,0,-1,0,2,'',0,30,'Slay Stonemight goblins','399010|399011|399013|399014|399017|399019|399021|399022|399023|399024|399025|399026|399028|399030|399031|399038|399039|399042|399047|399049|399050|399051|399052|399056','','399','',0,0,0,0,0,0,0),
(3040605,1,-1,1,255,'',0,1,'Kill the domesticated bear','','','399','',0,0,0,0,0,0,0),
(3040605,2,-1,2,4,'',0,1,'Return to Warden Jakar','394200','','394','',0,0,0,0,0,0,0),
(3040606,0,-1,0,2,'',0,20,'Slay Darkfell gnolls','399057|399075|399076|399094|399096|399097|399098|399099|399101|399102|399103|399104|399105|399107|399108|399109|399110|399111|399113|399115|399117|399118|399119|399125|399127|399128|399129|399130|399136|399140|399141|399142|399153|399154','','399','',0,0,0,0,0,0,0),
(3040606,1,-1,0,255,'',0,4,'Kill the tribal defenders','','','399','',0,0,0,0,0,0,0),
(3040606,2,-1,0,255,'',0,3,'Kill the Darkfell elites','','','399','',0,0,0,0,0,0,0),
(3040606,3,-1,1,4,'',0,1,'Return to Warden Jakar','394200','','394','',0,0,0,0,0,0,0),
(3040607,0,-1,0,255,'',0,1,'Steal and set a Gnoll Rune Trap in the goblin camps','','84243','399','',0,0,0,0,0,0,0),
(3040607,1,-1,1,255,'',0,1,'Watch three goblins be slain by the trap','','','399','',0,0,0,0,0,0,0),
(3040607,2,-1,2,4,'',0,1,'Return to Warden Jakar','394200','','394','',0,0,0,0,0,0,0),
(3040608,0,-1,0,1,'',0,1,'Deliver the first ancient page','399100','88137','399','',0,0,0,0,0,0,0),
(3040608,1,-1,0,1,'',0,1,'Deliver the second ancient page','399100','88138','399','',0,0,0,0,0,0,0),
(3040608,2,-1,0,1,'',0,1,'Deliver the third ancient page','399100','88139','399','',0,0,0,0,0,0,0),
(3040608,3,-1,1,255,'',0,1,'Make a rubbing of the druid stone with parchment on cursor','','13063','399','',0,0,0,0,0,0,0),
(3040608,4,-1,2,1,'',0,1,'Deliver Copy of Druidic Rune','399100','88140','399','',0,0,0,0,0,0,0),
(3040609,0,-1,0,255,'',0,1,'Find the burial chamber where Bordan obtained his curse','','','399','',0,0,0,0,0,0,0),
(3040609,1,-1,1,255,'',0,1,'Check the treasure chest','','','399','',0,0,0,0,0,0,0),
(3040609,2,-1,2,255,'',0,1,'Kill the Crypt Guardian','','','399','',0,0,0,0,0,0,0),
(3040609,3,-1,3,4,'',0,1,'Return to Bordan the Cursed','399139','','399','',0,0,0,0,0,0,0),
(3040610,0,-1,0,1,'',0,1,'Deliver Drakkin Trail Mix to Yavia','399032','88141','399','',0,0,0,0,0,0,0),
(3040610,1,-1,0,1,'',0,1,'Deliver Fresh Glacier Water to Yavia','399032','88142','399','',0,0,0,0,0,0,0),
(3040610,2,-1,1,255,'',0,2,'Kill assassin spiderlings','','','399','',0,0,0,0,0,0,0),
(3040610,3,-1,2,1,'',0,1,'Deliver Drakkin Trail Mix to Yavia','399032','88141','399','',0,0,0,0,0,0,0),
(3040610,4,-1,2,1,'',0,1,'Deliver Fresh Glacier Water to Yavia','399032','88142','399','',0,0,0,0,0,0,0),
(3040610,5,-1,3,255,'',0,2,'Kill assassin spiders','','','399','',0,0,0,0,0,0,0),
(3040610,6,-1,4,1,'',0,1,'Deliver Drakkin Trail Mix to Yavia','399032','88141','399','',0,0,0,0,0,0,0),
(3040610,7,-1,4,1,'',0,1,'Deliver Fresh Glacier Water to Yavia','399032','88142','399','',0,0,0,0,0,0,0),
(3040610,8,-1,5,255,'',0,3,'Kill assassin spiders','','','399','',0,0,0,0,0,0,0),
(3040610,9,-1,6,1,'',0,1,'Deliver Drakkin Trail Mix to Yavia','399032','88141','399','',0,0,0,0,0,0,0),
(3040610,10,-1,6,1,'',0,1,'Deliver Fresh Glacier Water to Yavia','399032','88142','399','',0,0,0,0,0,0,0),
(3040610,11,-1,7,255,'',0,2,'Kill mature assassin spiders','','','399','',0,0,0,0,0,0,0),
(3040610,12,-1,8,1,'',0,1,'Deliver Drakkin Trail Mix to Yavia','399032','88141','399','',0,0,0,0,0,0,0),
(3040610,13,-1,8,1,'',0,1,'Deliver Fresh Glacier Water to Yavia','399032','88142','399','',0,0,0,0,0,0,0),
(3040610,14,-1,9,255,'',0,1,'Kill assassin spider queen','','','399','',0,0,0,0,0,0,0),
(3040610,15,-1,10,4,'',0,1,'Speak to Yavia','399032','','399','',0,0,0,0,0,0,0),
(3040611,0,-1,0,255,'',0,1,'Explore the ancient giant crypt far to the north','','','399','',0,0,0,0,0,0,0),
(3040611,1,-1,1,255,'',0,1,'Slay the Prophet Spirit','','','399','',0,0,0,0,0,0,0),
(3040611,2,-1,2,3,'',0,1,'Loot the Ancient Charm','','54667','399','',0,0,0,0,0,0,0),
(3040611,3,-1,3,1,'',0,1,'Deliver Ancient Charm to Moldren the Wise','399070','54667','399','',0,0,0,0,0,0,0),
(3040612,0,-1,0,255,'',0,1,'Explore Valdeholm homes with bookcases','','','401','',0,0,0,0,0,0,0),
(3040612,1,-1,1,3,'',0,1,'Grab Ancient Giant Book One','','54668','401','',0,0,0,0,0,0,0),
(3040612,2,-1,1,3,'',0,1,'Grab Ancient Giant Book Two','','54669','401','',0,0,0,0,0,0,0),
(3040612,3,-1,2,1,'',0,1,'Deliver Ancient Giant Book One to Moldren','399070','54668','399','',0,0,0,0,0,0,0),
(3040612,4,-1,2,1,'',0,1,'Deliver Ancient Giant Book Two to Moldren','399070','54669','399','',0,0,0,0,0,0,0),
(3040613,0,-1,0,3,'',0,4,'Loot Portal Fragments from Direwind golems','','54671','405','',0,0,0,0,0,0,0),
(3040613,1,-1,0,3,'',0,4,'Loot Portal Rocks from Icefall kobolds','','54670','400','',0,0,0,0,0,0,0),
(3040613,2,-1,1,255,'',0,1,'Explore the site of the destroyed portal','','','399','',0,0,0,0,0,0,0),
(3040613,3,-1,2,255,'',0,1,'Kill the Portal Guardian','','','399','',0,0,0,0,0,0,0),
(3040613,4,-1,3,1,'',0,4,'Deliver Portal Fragments to Moldren','399070','54671','399','',0,0,0,0,0,0,0),
(3040613,5,-1,3,1,'',0,4,'Deliver Portal Rocks to Moldren','399070','54670','399','',0,0,0,0,0,0,0);
DELETE FROM achievement_criteria WHERE achievement_id=500060200 AND component_type=1 AND component_id=50196;
DELETE FROM achievement_criteria WHERE achievement_id=500060200 AND component_type=1 AND component_id=50195;
DELETE FROM achievement_criteria WHERE achievement_id=500060200 AND component_type=1 AND component_id=50193;
DELETE FROM achievement_criteria WHERE achievement_id=500060200 AND component_type=1 AND component_id=50192;
DELETE FROM achievement_criteria WHERE achievement_id=500060200 AND component_type=1 AND component_id=50190;
DELETE FROM achievement_criteria WHERE achievement_id=500060200 AND component_type=1 AND component_id=50191;
DELETE FROM achievement_criteria WHERE achievement_id=500060200 AND component_type=1 AND component_id=50194;
DELETE FROM achievement_criteria WHERE achievement_id=500060300 AND component_type=1 AND component_id=50199;
DELETE FROM achievement_criteria WHERE achievement_id=500060300 AND component_type=1 AND component_id=50198;
DELETE FROM achievement_criteria WHERE achievement_id=500060300 AND component_type=1 AND component_id=50197;
DELETE FROM achievement_criteria WHERE achievement_id=500060400 AND component_type=1 AND component_id=50200;
DELETE FROM achievement_criteria WHERE achievement_id=500060400 AND component_type=1 AND component_id=50201;
DELETE FROM achievement_criteria WHERE achievement_id=500060400 AND component_type=1 AND component_id=50202;
INSERT INTO achievement_criteria(`achievement_id`,`component_type`,`component_sequence`,`component_id`,`event_type`,`progress_mode`,`behavior`,`target_id`,`target_id2`,`target_value`,`required_count`,`enabled`)VALUES
(500060200,1,7,50196,4,3,0,3040601,0,0,1,0),
(500060200,1,6,50195,4,3,0,3040602,0,0,1,0),
(500060200,1,4,50193,4,3,0,3040603,0,0,1,0),
(500060200,1,3,50192,4,3,0,3040604,0,0,1,0),
(500060200,1,1,50190,4,3,0,3040605,0,0,1,0),
(500060200,1,2,50191,4,3,0,3040606,0,0,1,0),
(500060200,1,5,50194,4,3,0,3040607,0,0,1,0),
(500060300,1,3,50199,4,3,0,3040608,0,0,1,0),
(500060300,1,2,50198,4,3,0,3040609,0,0,1,0),
(500060300,1,1,50197,4,3,0,3040610,0,0,1,0),
(500060400,1,1,50200,4,3,0,3040611,0,0,1,0),
(500060400,1,2,50201,4,3,0,3040612,0,0,1,0),
(500060400,1,3,50202,4,3,0,3040613,0,0,1,0);
DELETE FROM reward_option_entries WHERE reward_set_id IN(3040606,3040691,3040692,3040693);
DELETE FROM reward_options WHERE reward_set_id IN(3040606,3040691,3040692,3040693);
DELETE FROM reward_sources WHERE reward_set_id IN(3040606,3040691,3040692,3040693);
DELETE FROM reward_sets WHERE reward_set_id IN(3040606,3040691,3040692,3040693);
DELETE FROM rewards WHERE reward_id IN(304060610,304060620,304060630,304060640,304069110,304069111,304069120,304069121,304069130,304069131,304069140,304069141,304069150,304069151,304069160,304069161,304069210,304069220,304069310,304069320);
INSERT INTO reward_sets(`reward_set_id`,`title`,`enabled`)VALUES
(3040606,'Sweeping the Steppes: Gnolls',0),
(3040691,'Conquering The Steppes (61-70)',0),
(3040692,'Steppe Right Up (Steppes 60+)',0),
(3040693,'Rebuilding the Portal (Steppes 60+)',0);
INSERT INTO reward_sources(`source_type`,`source_id`,`reward_set_id`,`enabled`)VALUES
(2,3040606,3040606,0),
(1,500060200,3040691,0),
(1,500060300,3040692,0),
(1,500060400,3040693,0);
INSERT INTO rewards(`reward_id`,`reward_type`,`reward_data_id`,`amount`,`description`,`enabled`)VALUES
(304060610,1,1,1000,'May2013 Steppes reward 304060610',0),
(304060620,0,53614,1,'May2013 Steppes reward 304060620',0),
(304060630,0,53615,1,'May2013 Steppes reward 304060630',0),
(304060640,0,53616,1,'May2013 Steppes reward 304060640',0),
(304069110,0,108599,1,'May2013 Steppes reward 304069110',0),
(304069111,0,108598,1,'May2013 Steppes reward 304069111',0),
(304069120,0,108599,1,'May2013 Steppes reward 304069120',0),
(304069121,0,108588,1,'May2013 Steppes reward 304069121',0),
(304069130,0,108599,1,'May2013 Steppes reward 304069130',0),
(304069131,0,108590,1,'May2013 Steppes reward 304069131',0),
(304069140,0,108599,1,'May2013 Steppes reward 304069140',0),
(304069141,0,108592,1,'May2013 Steppes reward 304069141',0),
(304069150,0,108599,1,'May2013 Steppes reward 304069150',0),
(304069151,0,108591,1,'May2013 Steppes reward 304069151',0),
(304069160,0,108600,1,'May2013 Steppes reward 304069160',0),
(304069161,0,108589,1,'May2013 Steppes reward 304069161',0),
(304069210,0,108404,1,'May2013 Steppes reward 304069210',0),
(304069220,0,108414,1,'May2013 Steppes reward 304069220',0),
(304069310,0,108405,1,'May2013 Steppes reward 304069310',0),
(304069320,0,108415,1,'May2013 Steppes reward 304069320',0);
INSERT INTO reward_options(`reward_set_id`,`option_id`,`sequence`,`label`,`common_to_all`,`flags`,`enabled`,`class_mask`)VALUES
(3040606,1,1,'Experience',1,0,0,65535),
(3040606,2,2,'Gnollbiter',0,0,0,65535),
(3040606,3,3,'Gnollcracker',0,0,0,65535),
(3040606,4,4,'Gnollcleaver',0,0,0,65535),
(3040691,1,1,'Intricate Consigned Bow',0,0,0,49629),
(3040691,2,2,'Intricate Consigned Hammer',0,0,0,49629),
(3040691,3,3,'Intricate Consigned Katana',0,0,0,49629),
(3040691,4,4,'Intricate Consigned Sacrificial Dagger',0,0,0,49629),
(3040691,5,5,'Intricate Consigned Scimitar',0,0,0,49629),
(3040691,6,6,'Intricate caster shield and mace',0,0,0,15906),
(3040692,1,1,'Intricate Soldier''s Gorget',0,0,0,49629),
(3040692,2,2,'Intricate Scryer''s Necklace',0,0,0,15906),
(3040693,1,1,'Intricate Soldier''s Pauldrons',0,0,0,49629),
(3040693,2,2,'Intricate Scryer''s Shoulderpads',0,0,0,15906);
INSERT INTO reward_option_entries(`reward_set_id`,`option_id`,`sequence`,`reward_id`)VALUES
(3040606,1,0,304060610),
(3040606,2,0,304060620),
(3040606,3,0,304060630),
(3040606,4,0,304060640),
(3040691,1,0,304069110),
(3040691,1,1,304069111),
(3040691,2,0,304069120),
(3040691,2,1,304069121),
(3040691,3,0,304069130),
(3040691,3,1,304069131),
(3040691,4,0,304069140),
(3040691,4,1,304069141),
(3040691,5,0,304069150),
(3040691,5,1,304069151),
(3040691,6,0,304069160),
(3040691,6,1,304069161),
(3040692,1,0,304069210),
(3040692,2,0,304069220),
(3040693,1,0,304069310),
(3040693,2,0,304069320);
COMMIT;
