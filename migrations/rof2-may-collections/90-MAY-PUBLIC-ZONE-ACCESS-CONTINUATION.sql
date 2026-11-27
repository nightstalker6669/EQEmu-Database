-- May 2013 restored-zone access continuation after SQL80.
-- Accept exact published 80 preimages or the known existing development status profile.
DELIMITER $$
BEGIN NOT ATOMIC
    DECLARE already_open INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    START TRANSACTION;

    IF (SELECT COUNT(*) FROM zone WHERE id IN (5886,5887,5890,5891,5894)
        AND version=0 AND expansion=19 AND min_status=0) <> 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May access continuation requires SQL80';
    END IF;

    SELECT COUNT(*) INTO already_open FROM zone WHERE min_status=0 AND id IN (8,52,67,69,71,96,100,105,177,198,268,270,271,273,309,311,314,385,399,400,409,432);
    IF already_open NOT IN (0,22)
        OR (SELECT COUNT(*) FROM zone WHERE (id,zoneidnumber,version,expansion,BINARY short_name) IN (
          (8,369,0,11,'arcstone'),
          (16,422,0,13,'barren'),
          (22,469,0,15,'bertoxtemple'),
          (29,423,0,13,'buriedsea'),
          (52,365,0,10,'corathus'),
          (59,446,0,14,'crystallos'),
          (67,372,0,11,'devastation'),
          (69,470,0,15,'discord'),
          (71,354,0,10,'drachnidhive'),
          (75,442,0,14,'dragonscale'),
          (91,331,0,8,'draniksewersa'),
          (96,351,0,10,'dreadspire'),
          (100,362,0,10,'eastkorlach'),
          (105,378,0,11,'elddar'),
          (118,998,0,7,'fhalls'),
          (158,440,0,14,'gyrospireb'),
          (159,441,0,14,'gyrospirez'),
          (169,444,0,14,'hillsofshade'),
          (177,347,0,10,'illsalin'),
          (192,416,0,13,'kattacastrum'),
          (198,476,0,15,'korascian'),
          (207,443,0,14,'lopingplains'),
          (209,429,0,13,'maidensgrave'),
          (210,437,0,14,'mansion'),
          (268,452,0,15,'oldfieldofbone'),
          (270,453,0,15,'oldkaesoraa'),
          (271,454,0,15,'oldkaesorab'),
          (273,455,0,15,'oldkurn'),
          (309,374,0,11,'rage'),
          (311,477,0,15,'rathechamber'),
          (314,370,0,11,'relic'),
          (342,439,0,14,'shipworkshop'),
          (364,438,0,14,'steamfactory'),
          (385,376,0,11,'takishruins'),
          (399,462,0,15,'thevoidd'),
          (400,463,0,15,'thevoide'),
          (409,475,0,15,'toskirakk'),
          (432,358,0,10,'westkorlach'),
          (438,419,0,13,'zhisza'),
          (440,480,0,16,'brellsrest'),
          (441,483,0,16,'coolingchamber'),
          (442,488,0,16,'pellucid'),
          (443,485,0,16,'arthicrex'),
          (444,486,0,16,'foundation'),
          (445,482,0,16,'underquarry'),
          (5556,704,0,17,'thulelibrary'),
          (5559,706,0,17,'fallen'),
          (5560,700,0,17,'feerrott2'),
          (5561,703,0,17,'housegarden'),
          (5565,701,0,17,'thulehouse1'),
          (5567,705,0,17,'well'),
          (5865,724,0,18,'argath'),
          (5869,728,0,18,'beastdomain'),
          (5870,729,0,18,'resplendent'),
          (5873,732,0,18,'cityofbronze'),
          (5874,733,0,18,'sepulcher'),
          (5875,734,0,18,'eastsepulcher'),
          (5876,735,0,18,'westsepulcher')
      )
            AND (min_status=80 OR (min_status=0 AND id IN (8,52,67,69,71,96,100,105,177,198,268,270,271,273,309,311,314,385,399,400,409,432)))) <> 58 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May access continuation status profile mismatch';
    END IF;

    UPDATE zone SET min_status=0 WHERE min_status=80 AND (id,zoneidnumber,version,expansion,BINARY short_name) IN (
          (8,369,0,11,'arcstone'),
          (16,422,0,13,'barren'),
          (22,469,0,15,'bertoxtemple'),
          (29,423,0,13,'buriedsea'),
          (52,365,0,10,'corathus'),
          (59,446,0,14,'crystallos'),
          (67,372,0,11,'devastation'),
          (69,470,0,15,'discord'),
          (71,354,0,10,'drachnidhive'),
          (75,442,0,14,'dragonscale'),
          (91,331,0,8,'draniksewersa'),
          (96,351,0,10,'dreadspire'),
          (100,362,0,10,'eastkorlach'),
          (105,378,0,11,'elddar'),
          (118,998,0,7,'fhalls'),
          (158,440,0,14,'gyrospireb'),
          (159,441,0,14,'gyrospirez'),
          (169,444,0,14,'hillsofshade'),
          (177,347,0,10,'illsalin'),
          (192,416,0,13,'kattacastrum'),
          (198,476,0,15,'korascian'),
          (207,443,0,14,'lopingplains'),
          (209,429,0,13,'maidensgrave'),
          (210,437,0,14,'mansion'),
          (268,452,0,15,'oldfieldofbone'),
          (270,453,0,15,'oldkaesoraa'),
          (271,454,0,15,'oldkaesorab'),
          (273,455,0,15,'oldkurn'),
          (309,374,0,11,'rage'),
          (311,477,0,15,'rathechamber'),
          (314,370,0,11,'relic'),
          (342,439,0,14,'shipworkshop'),
          (364,438,0,14,'steamfactory'),
          (385,376,0,11,'takishruins'),
          (399,462,0,15,'thevoidd'),
          (400,463,0,15,'thevoide'),
          (409,475,0,15,'toskirakk'),
          (432,358,0,10,'westkorlach'),
          (438,419,0,13,'zhisza'),
          (440,480,0,16,'brellsrest'),
          (441,483,0,16,'coolingchamber'),
          (442,488,0,16,'pellucid'),
          (443,485,0,16,'arthicrex'),
          (444,486,0,16,'foundation'),
          (445,482,0,16,'underquarry'),
          (5556,704,0,17,'thulelibrary'),
          (5559,706,0,17,'fallen'),
          (5560,700,0,17,'feerrott2'),
          (5561,703,0,17,'housegarden'),
          (5565,701,0,17,'thulehouse1'),
          (5567,705,0,17,'well'),
          (5865,724,0,18,'argath'),
          (5869,728,0,18,'beastdomain'),
          (5870,729,0,18,'resplendent'),
          (5873,732,0,18,'cityofbronze'),
          (5874,733,0,18,'sepulcher'),
          (5875,734,0,18,'eastsepulcher'),
          (5876,735,0,18,'westsepulcher')
      );
    IF ROW_COUNT() <> 58 - already_open THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May access continuation affected row count mismatch';
    END IF;
    COMMIT;
END$$
DELIMITER ;
