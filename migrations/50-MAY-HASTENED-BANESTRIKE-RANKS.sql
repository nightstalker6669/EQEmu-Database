-- Offline candidate. Restore the two May passive ranks referenced by the existing chain.
DELIMITER $$
BEGIN NOT ATOMIC
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    START TRANSACTION;
    IF NOT EXISTS (
        SELECT 1 FROM aa_ability WHERE id=15074 AND BINARY name='Hastened Banestrike'
            AND first_rank_id=15074 AND type=4 AND grant_only=1 AND charges=0 AND enabled=1
    ) OR EXISTS (SELECT 1 FROM aa_ability WHERE id IN (15075,15076) OR first_rank_id IN (15075,15076))
    OR NOT EXISTS (
        SELECT 1 FROM aa_ranks WHERE id=15074 AND upper_hotkey_sid=-1 AND lower_hotkey_sid=-1
            AND title_sid=15074 AND desc_sid=15074 AND cost=0 AND level_req=1 AND spell=-1
            AND spell_type=0 AND recast_time=0 AND expansion=19 AND prev_id=-1 AND next_id=15075
    ) OR EXISTS (
        SELECT 1 FROM aa_ranks WHERE id IN (15075,15076)
            OR (id<>15074 AND (prev_id IN (15075,15076) OR next_id IN (15075,15076)))
    ) OR (SELECT COUNT(*) FROM aa_rank_effects WHERE rank_id=15074)<>1
    OR NOT EXISTS (
        SELECT 1 FROM aa_rank_effects WHERE rank_id=15074 AND slot=1 AND effect_id=264 AND base1=5 AND base2=15073
    ) OR EXISTS (SELECT 1 FROM aa_rank_effects WHERE rank_id IN (15075,15076))
    OR EXISTS (SELECT 1 FROM aa_rank_prereqs WHERE rank_id BETWEEN 15074 AND 15076 OR aa_id IN (15075,15076))
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Hastened Banestrike exact rank preimage mismatch'; END IF;

    INSERT INTO aa_ranks
        (id,upper_hotkey_sid,lower_hotkey_sid,title_sid,desc_sid,cost,level_req,
         spell,spell_type,recast_time,expansion,prev_id,next_id)
    VALUES
        (15075,-1,-1,15075,15075,0,1,-1,0,0,19,15074,15076),
        (15076,-1,-1,15076,15076,0,1,-1,0,0,19,15075,-1);
    IF ROW_COUNT() <> 2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Hastened Banestrike rank insert failed'; END IF;

    INSERT INTO aa_rank_effects (rank_id,slot,effect_id,base1,base2)
    VALUES (15075,1,264,10,15073), (15076,1,264,15,15073);
    IF ROW_COUNT() <> 2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Hastened Banestrike rank effect insert failed'; END IF;
    COMMIT;
END$$
DELIMITER ;
