-- Shard's Landing v0, Fear in Pieces. Eight reconstructed fixed positions
-- from the retained named map group and verified server terrain.
-- IT11503_ACTORDEF is the retained ordinary yellow actor candidate. The 300-second interval
-- follows the retained stock ground rows.
DELIMITER $$
BEGIN NOT ATOMIC
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    IF (SELECT COUNT(*) FROM zone WHERE id = 5893 AND zoneidnumber = 752
        AND version = 0 AND short_name = 'shardslanding' AND expansion = 19) <> 1
       OR (SELECT COUNT(*) FROM items WHERE id BETWEEN 77389 AND 77396 AND itemtype = 66) <> 8
       OR (SELECT COUNT(*) FROM achievement_criteria WHERE achievement_id = 2040752
           AND event_type = 14 AND target_id BETWEEN 77389 AND 77396 AND enabled = 1) <> 8
       OR (SELECT COUNT(*) FROM ground_spawns WHERE zoneid = 752 AND version IN (-1,0)) > 42
       OR EXISTS (SELECT 1 FROM ground_spawns WHERE id BETWEEN 304098200 AND 304098207
                  OR item BETWEEN 77389 AND 77396)
       OR EXISTS (SELECT 1 FROM object WHERE itemid BETWEEN 77389 AND 77396) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Collections ground preimage or capacity mismatch';
    END IF;

    INSERT INTO ground_spawns
        (id,zoneid,version,max_x,max_y,max_z,min_x,min_y,heading,name,item,max_allowed,comment,respawn_timer,fix_z)
    VALUES
        (304098200,752,0,-151.2000,788.2654,0.100,-151.2000,788.2654,0,'IT11503_ACTORDEF',77389,1,'Fear in Pieces map marker 33',300,1),
        (304098201,752,0,-12.0005,184.6669,6.453,-12.0005,184.6669,0,'IT11503_ACTORDEF',77390,1,'Fear in Pieces map marker 25',300,1),
        (304098202,752,0,232.3456,550.3259,0.100,232.3456,550.3259,0,'IT11503_ACTORDEF',77391,1,'Fear in Pieces map marker 26',300,1),
        (304098203,752,0,-383.7434,1228.0767,64.519,-383.7434,1228.0767,0,'IT11503_ACTORDEF',77392,1,'Fear in Pieces map marker 27',300,1),
        (304098204,752,0,298.0752,1635.9336,0.100,298.0752,1635.9336,0,'IT11503_ACTORDEF',77393,1,'Fear in Pieces map marker 29',300,1),
        (304098205,752,0,-1458.3744,975.2220,12.269,-1458.3744,975.2220,0,'IT11503_ACTORDEF',77394,1,'Fear in Pieces map marker 30',300,1),
        (304098206,752,0,-603.7533,-410.1208,48.279,-603.7533,-410.1208,0,'IT11503_ACTORDEF',77395,1,'Fear in Pieces map marker 31',300,1),
        (304098207,752,0,63.7855,883.2502,0.100,63.7855,883.2502,0,'IT11503_ACTORDEF',77396,1,'Fear in Pieces map marker 38',300,1);
    IF ROW_COUNT() <> 8 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Collections ground insertion count mismatch';
    END IF;

    COMMIT;
END$$
DELIMITER ;
