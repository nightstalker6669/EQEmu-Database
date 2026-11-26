-- Native RoF2 Collections for Fear in Pieces and Alaran in Chains.
-- Matched source required. Server item type 66 routes registration; RoF2 emits
-- native miscellaneous type 11 and the dedicated collectible bit.
-- XP uses the level-95 default EQEmu span as a documented reconstruction.
DELIMITER $$
BEGIN NOT ATOMIC
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    IF (SELECT COUNT(*) FROM zone
        WHERE id = 5893 AND zoneidnumber = 752 AND version = 0
          AND short_name = 'shardslanding' AND ruleset = 1 AND expansion = 19) <> 1
       OR (SELECT COUNT(*) FROM rule_sets WHERE ruleset_id = 1 AND name = 'default') <> 1
       OR (SELECT COUNT(*) FROM rule_values WHERE ruleset_id = 1
            AND rule_name = 'Zone:GlobalLootMultiplier' AND TRIM(rule_value) = '1') <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Collections zone or loot multiplier mismatch';
    END IF;

    IF (SELECT COUNT(*) FROM achievements WHERE id IN (2040752,2060752)
        AND enabled = 0 AND has_reward = 1 AND client_flag = 0 AND points = 10) <> 2
       OR (SELECT COUNT(*) FROM achievement_category_associations
           WHERE category_id = 2009 AND achievement_id IN (2040752,2060752)) <> 2
       OR (SELECT COUNT(*) FROM achievement_components
           WHERE achievement_id IN (2040752,2060752)) <> 16
       OR (SELECT COUNT(*)
           FROM achievement_components c
           JOIN achievement_associations a ON a.component_id = c.component_id
           JOIN items i ON i.id = CASE c.achievement_id
               WHEN 2040752 THEN 77388 + c.sequence
               WHEN 2060752 THEN 77423 + c.sequence END
           WHERE c.achievement_id IN (2040752,2060752) AND c.component_type = 1
             AND c.sequence BETWEEN 1 AND 8
             AND c.component_id = c.achievement_id + 1000 * (c.sequence - 1)
             AND a.required_count = 1 AND BINARY i.Name = BINARY c.name
             AND i.itemtype = 11 AND i.clickeffect = -1 AND i.clicktype = 0
             AND i.stacksize = 100) <> 16
       OR EXISTS (SELECT 1 FROM achievement_criteria WHERE achievement_id IN (2040752,2060752)
                  OR id BETWEEN 304098000 AND 304098015)
       OR EXISTS (SELECT 1 FROM rewards WHERE reward_id IN (304098300,304098301))
       OR EXISTS (SELECT 1 FROM reward_sources WHERE source_type = 1 AND source_id IN (2040752,2060752))
       OR EXISTS (SELECT 1 FROM reward_source_entries WHERE
                  (source_type = 1 AND source_id IN (2040752,2060752)) OR reward_id IN (304098300,304098301))
       OR EXISTS (SELECT 1 FROM reward_option_entries WHERE reward_id IN (304098300,304098301)) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Collections item, achievement, or reward preimage mismatch';
    END IF;

    IF (SELECT COUNT(*) FROM npc_types WHERE loottable_id = 0 AND maxlevel = 0 AND
          ((id = 752193 AND BINARY name = 'an_arena_sentry' AND level = 97)
        OR (id = 752195 AND BINARY name = 'an_arena_ward' AND level = 97)
        OR (id = 752206 AND BINARY name = 'a_conscripted_gladiator' AND level = 96)
        OR (id = 752209 AND BINARY name = 'a_conscripted_gladiator' AND level = 95))) <> 4
       OR (SELECT COUNT(DISTINCT e.npcID, s.id)
           FROM spawnentry e JOIN spawn2 s ON s.spawngroupID = e.spawngroupID
           WHERE e.npcID IN (752193,752195,752206,752209)
             AND s.zone = 'shardslanding' AND s.version = 0
             AND s.id IN (155462,155466,155478,155484,155510,155467,155506,155556,
                          155563,155575,155502,155503,155552,155560,155521,155531)) <> 16
       OR EXISTS (SELECT 1 FROM spawnentry e JOIN spawn2 s ON s.spawngroupID = e.spawngroupID
                  WHERE e.npcID IN (752193,752195,752206,752209) AND
                        (s.zone <> 'shardslanding' OR s.version <> 0 OR
                         s.id NOT IN (155462,155466,155478,155484,155510,155467,155506,155556,
                                      155563,155575,155502,155503,155552,155560,155521,155531)))
       OR EXISTS (SELECT 1 FROM loottable WHERE id = 304098100)
       OR EXISTS (SELECT 1 FROM lootdrop WHERE id = 304098101)
       OR EXISTS (SELECT 1 FROM loottable_entries WHERE loottable_id = 304098100 OR lootdrop_id = 304098101)
       OR EXISTS (SELECT 1 FROM lootdrop_entries WHERE lootdrop_id = 304098101 OR item_id BETWEEN 77424 AND 77431)
       OR EXISTS (SELECT 1 FROM npc_types WHERE loottable_id = 304098100)
       OR EXISTS (SELECT 1 FROM global_loot WHERE loottable_id = 304098100) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Collections arena population or loot preimage mismatch';
    END IF;

    UPDATE items SET itemtype = 66 WHERE itemtype = 11
      AND (id BETWEEN 77389 AND 77396 OR id BETWEEN 77424 AND 77431);
    IF ROW_COUNT() <> 16 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Collections item update count mismatch';
    END IF;

    INSERT INTO achievement_criteria
        (id,achievement_id,component_type,component_sequence,component_id,
         event_type,progress_mode,behavior,target_id,target_id2,target_value,required_count,enabled)
    SELECT 304097999 + c.sequence + CASE c.achievement_id WHEN 2060752 THEN 8 ELSE 0 END,
           c.achievement_id,c.component_type,c.sequence,c.component_id,14,2,0,
           CASE c.achievement_id WHEN 2040752 THEN 77388 ELSE 77423 END + c.sequence,
           0,1,1,1
    FROM achievement_components c
    WHERE c.achievement_id IN (2040752,2060752) AND c.component_type = 1;

    INSERT INTO rewards (reward_id,reward_type,reward_data_id,amount,description,enabled) VALUES
        (304098300,1,1,16610406,'Fear in Pieces experience',1),
        (304098301,1,1,16610406,'Alaran in Chains experience',1);
    INSERT INTO reward_source_entries (source_type,source_id,sequence,reward_id) VALUES
        (1,2040752,0,304098300),(1,2060752,0,304098301);

    INSERT INTO loottable (id,name,mincash,maxcash,avgcoin) VALUES
        (304098100,'Shard''s Landing - Alaran in Chains',0,0,0);
    INSERT INTO lootdrop (id,name) VALUES (304098101,'Alaran in Chains collectibles');
    INSERT INTO loottable_entries (loottable_id,lootdrop_id,multiplier,droplimit,mindrop,probability) VALUES
        (304098100,304098101,1,1,1,20);
    INSERT INTO lootdrop_entries
        (lootdrop_id,item_id,item_charges,equip_item,chance,multiplier,npc_min_level,npc_max_level)
    SELECT 304098101,id,1,0,12.5,1,0,0
    FROM items WHERE id BETWEEN 77424 AND 77431 AND itemtype = 66;

    UPDATE npc_types SET loottable_id = 304098100
    WHERE id IN (752193,752195,752206,752209) AND loottable_id = 0;
    IF ROW_COUNT() <> 4 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Collections arena assignment count mismatch';
    END IF;

    UPDATE achievements SET enabled = 1 WHERE id IN (2040752,2060752) AND enabled = 0;
    IF ROW_COUNT() <> 2 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Collections activation count mismatch';
    END IF;

    COMMIT;
END$$
DELIMITER ;
