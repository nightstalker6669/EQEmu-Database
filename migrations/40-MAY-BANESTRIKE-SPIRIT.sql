-- Offline candidate. An unplaced transient Wisp presentation for original Banestrike.
DELIMITER $$
BEGIN NOT ATOMIC
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    START TRANSACTION;
    IF EXISTS (SELECT 1 FROM npc_types WHERE id=304099980)
        OR EXISTS (SELECT 1 FROM pets WHERE type='SumBaneSpirit' OR npcID=304099980)
        OR EXISTS (SELECT 1 FROM spawnentry WHERE npcID=304099980)
        OR EXISTS (SELECT 1 FROM zone_state_spawns WHERE npc_id=304099980)
        OR NOT EXISTS (SELECT 1 FROM spells_new WHERE id=37668 AND BINARY teleport_zone='SumBaneSpirit'
                       AND effectid1=152 AND effect_base_value1=1 AND max1=10)
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Banestrike spirit exact preimage mismatch'; END IF;

    INSERT INTO npc_types
        (id,name,level,race,`class`,bodytype,hp,mana,gender,texture,size,loottable_id,merchant_id,
         npc_spells_id,npc_spells_effects_id,npc_faction_id,mindmg,maxdmg,attack_count,
         aggroradius,assistradius,runspeed,walkspeed,npc_aggro,trackable,findable,emoteid,
         spellscale,show_name,no_target_hotkey,untargetable,skip_global_loot,rare_spawn)
    VALUES
        (304099980,'Bane Spirit',1,69,1,23,1,0,2,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
         100,1,1,1,1,0);
    IF ROW_COUNT() <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Banestrike spirit insert failed'; END IF;

    INSERT INTO pets (type,petpower,npcID,temp,petcontrol,petnaming,monsterflag,equipmentset)
    VALUES ('SumBaneSpirit',0,304099980,1,0,0,0,-1);
    IF ROW_COUNT() <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Banestrike pet insert failed'; END IF;
    COMMIT;
END$$
DELIMITER ;
