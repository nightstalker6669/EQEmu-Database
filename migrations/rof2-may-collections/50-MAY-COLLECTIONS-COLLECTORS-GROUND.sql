-- May Collections. Apply only in the complete matched batch.
DELIMITER $$
BEGIN NOT ATOMIC
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    START TRANSACTION;

    IF (SELECT COUNT(*) FROM ground_spawns WHERE (BINARY `comment`=CONVERT(0x4175746f2067656e65726174656420627920436f6c6c6563746f722e2046495820544845204954454d494421 USING utf8mb4) AND `content_flags`<=>NULL AND `content_flags_disabled`<=>NULL AND `fix_z`<=>1 AND `heading`<=>CAST(0 AS FLOAT) AND `id`<=>1611 AND `item`<=>1001 AND `max_allowed`<=>1 AND `max_expansion`<=>-1 AND `max_x`<=>CAST(-140 AS FLOAT) AND `max_y`<=>CAST(515 AS FLOAT) AND `max_z`<=>CAST(72 AS FLOAT) AND `min_expansion`<=>-1 AND `min_x`<=>CAST(-140 AS FLOAT) AND `min_y`<=>CAST(515 AS FLOAT) AND BINARY `name`=CONVERT(0x495431313530345f4143544f52444546 USING utf8mb4) AND `respawn_timer`<=>300 AND `version`<=>0 AND `zoneid`<=>752)
          OR (BINARY `comment`=CONVERT(0x4175746f2067656e65726174656420627920436f6c6c6563746f722e2046495820544845204954454d494421 USING utf8mb4) AND `content_flags`<=>NULL AND `content_flags_disabled`<=>NULL AND `fix_z`<=>1 AND `heading`<=>CAST(0 AS FLOAT) AND `id`<=>1616 AND `item`<=>1001 AND `max_allowed`<=>1 AND `max_expansion`<=>-1 AND `max_x`<=>CAST(-653 AS FLOAT) AND `max_y`<=>CAST(183 AS FLOAT) AND `max_z`<=>CAST(33 AS FLOAT) AND `min_expansion`<=>-1 AND `min_x`<=>CAST(-653 AS FLOAT) AND `min_y`<=>CAST(183 AS FLOAT) AND BINARY `name`=CONVERT(0x495431313530345f4143544f52444546 USING utf8mb4) AND `respawn_timer`<=>300 AND `version`<=>0 AND `zoneid`<=>752)
          OR (BINARY `comment`=CONVERT(0x4175746f2067656e65726174656420627920436f6c6c6563746f722e2046495820544845204954454d494421 USING utf8mb4) AND `content_flags`<=>NULL AND `content_flags_disabled`<=>NULL AND `fix_z`<=>1 AND `heading`<=>CAST(0 AS FLOAT) AND `id`<=>1636 AND `item`<=>1001 AND `max_allowed`<=>1 AND `max_expansion`<=>-1 AND `max_x`<=>CAST(-870 AS FLOAT) AND `max_y`<=>CAST(-351 AS FLOAT) AND `max_z`<=>CAST(-449 AS FLOAT) AND `min_expansion`<=>-1 AND `min_x`<=>CAST(-870 AS FLOAT) AND `min_y`<=>CAST(-351 AS FLOAT) AND BINARY `name`=CONVERT(0x495431313530345f4143544f52444546 USING utf8mb4) AND `respawn_timer`<=>300 AND `version`<=>0 AND `zoneid`<=>753)
          OR (BINARY `comment`=CONVERT(0x4175746f2067656e65726174656420627920436f6c6c6563746f722e2046495820544845204954454d494421 USING utf8mb4) AND `content_flags`<=>NULL AND `content_flags_disabled`<=>NULL AND `fix_z`<=>1 AND `heading`<=>CAST(0 AS FLOAT) AND `id`<=>1647 AND `item`<=>1001 AND `max_allowed`<=>1 AND `max_expansion`<=>-1 AND `max_x`<=>CAST(1522 AS FLOAT) AND `max_y`<=>CAST(-439 AS FLOAT) AND `max_z`<=>CAST(92 AS FLOAT) AND `min_expansion`<=>-1 AND `min_x`<=>CAST(1522 AS FLOAT) AND `min_y`<=>CAST(-439 AS FLOAT) AND BINARY `name`=CONVERT(0x495431313530345f4143544f52444546 USING utf8mb4) AND `respawn_timer`<=>300 AND `version`<=>0 AND `zoneid`<=>753)
          OR (BINARY `comment`=CONVERT(0x4175746f2067656e65726174656420627920436f6c6c6563746f722e2046495820544845204954454d494421 USING utf8mb4) AND `content_flags`<=>NULL AND `content_flags_disabled`<=>NULL AND `fix_z`<=>1 AND `heading`<=>CAST(0 AS FLOAT) AND `id`<=>1590 AND `item`<=>1001 AND `max_allowed`<=>1 AND `max_expansion`<=>-1 AND `max_x`<=>CAST(1528 AS FLOAT) AND `max_y`<=>CAST(1165 AS FLOAT) AND `max_z`<=>CAST(-25 AS FLOAT) AND `min_expansion`<=>-1 AND `min_x`<=>CAST(1528 AS FLOAT) AND `min_y`<=>CAST(1165 AS FLOAT) AND BINARY `name`=CONVERT(0x495431313530345f4143544f52444546 USING utf8mb4) AND `respawn_timer`<=>300 AND `version`<=>0 AND `zoneid`<=>754)
          OR (BINARY `comment`=CONVERT(0x4175746f2067656e65726174656420627920436f6c6c6563746f722e2046495820544845204954454d494421 USING utf8mb4) AND `content_flags`<=>NULL AND `content_flags_disabled`<=>NULL AND `fix_z`<=>1 AND `heading`<=>CAST(0 AS FLOAT) AND `id`<=>1597 AND `item`<=>1001 AND `max_allowed`<=>1 AND `max_expansion`<=>-1 AND `max_x`<=>CAST(1528 AS FLOAT) AND `max_y`<=>CAST(1165 AS FLOAT) AND `max_z`<=>CAST(-25 AS FLOAT) AND `min_expansion`<=>-1 AND `min_x`<=>CAST(1528 AS FLOAT) AND `min_y`<=>CAST(1165 AS FLOAT) AND BINARY `name`=CONVERT(0x495431313530345f4143544f52444546 USING utf8mb4) AND `respawn_timer`<=>300 AND `version`<=>0 AND `zoneid`<=>754)
          OR (BINARY `comment`=CONVERT(0x4175746f2067656e65726174656420627920436f6c6c6563746f722e2046495820544845204954454d494421 USING utf8mb4) AND `content_flags`<=>NULL AND `content_flags_disabled`<=>NULL AND `fix_z`<=>1 AND `heading`<=>CAST(0 AS FLOAT) AND `id`<=>1436 AND `item`<=>1001 AND `max_allowed`<=>1 AND `max_expansion`<=>-1 AND `max_x`<=>CAST(1491 AS FLOAT) AND `max_y`<=>CAST(-2057 AS FLOAT) AND `max_z`<=>CAST(217 AS FLOAT) AND `min_expansion`<=>-1 AND `min_x`<=>CAST(1491 AS FLOAT) AND `min_y`<=>CAST(-2057 AS FLOAT) AND BINARY `name`=CONVERT(0x495431313530345f4143544f52444546 USING utf8mb4) AND `respawn_timer`<=>300 AND `version`<=>0 AND `zoneid`<=>755)
          OR (BINARY `comment`=CONVERT(0x4175746f2067656e65726174656420627920436f6c6c6563746f722e2046495820544845204954454d494421 USING utf8mb4) AND `content_flags`<=>NULL AND `content_flags_disabled`<=>NULL AND `fix_z`<=>1 AND `heading`<=>CAST(0 AS FLOAT) AND `id`<=>1444 AND `item`<=>1001 AND `max_allowed`<=>1 AND `max_expansion`<=>-1 AND `max_x`<=>CAST(5463 AS FLOAT) AND `max_y`<=>CAST(-1990 AS FLOAT) AND `max_z`<=>CAST(458 AS FLOAT) AND `min_expansion`<=>-1 AND `min_x`<=>CAST(5463 AS FLOAT) AND `min_y`<=>CAST(-1990 AS FLOAT) AND BINARY `name`=CONVERT(0x495431313530345f4143544f52444546 USING utf8mb4) AND `respawn_timer`<=>300 AND `version`<=>0 AND `zoneid`<=>755)
          OR (BINARY `comment`=CONVERT(0x4175746f2067656e65726174656420627920436f6c6c6563746f722e2046495820544845204954454d494421 USING utf8mb4) AND `content_flags`<=>NULL AND `content_flags_disabled`<=>NULL AND `fix_z`<=>1 AND `heading`<=>CAST(0 AS FLOAT) AND `id`<=>1412 AND `item`<=>1001 AND `max_allowed`<=>1 AND `max_expansion`<=>-1 AND `max_x`<=>CAST(708 AS FLOAT) AND `max_y`<=>CAST(-274 AS FLOAT) AND `max_z`<=>CAST(-545 AS FLOAT) AND `min_expansion`<=>-1 AND `min_x`<=>CAST(708 AS FLOAT) AND `min_y`<=>CAST(-274 AS FLOAT) AND BINARY `name`=CONVERT(0x495431313530345f4143544f52444546 USING utf8mb4) AND `respawn_timer`<=>300 AND `version`<=>0 AND `zoneid`<=>756)
          OR (BINARY `comment`=CONVERT(0x4175746f2067656e65726174656420627920436f6c6c6563746f722e2046495820544845204954454d494421 USING utf8mb4) AND `content_flags`<=>NULL AND `content_flags_disabled`<=>NULL AND `fix_z`<=>1 AND `heading`<=>CAST(0 AS FLOAT) AND `id`<=>1414 AND `item`<=>1001 AND `max_allowed`<=>1 AND `max_expansion`<=>-1 AND `max_x`<=>CAST(704 AS FLOAT) AND `max_y`<=>CAST(-199 AS FLOAT) AND `max_z`<=>CAST(-544 AS FLOAT) AND `min_expansion`<=>-1 AND `min_x`<=>CAST(704 AS FLOAT) AND `min_y`<=>CAST(-199 AS FLOAT) AND BINARY `name`=CONVERT(0x495431313530345f4143544f52444546 USING utf8mb4) AND `respawn_timer`<=>300 AND `version`<=>0 AND `zoneid`<=>756)
          OR (BINARY `comment`=CONVERT(0x4175746f2067656e65726174656420627920436f6c6c6563746f722e2046495820544845204954454d494421 USING utf8mb4) AND `content_flags`<=>NULL AND `content_flags_disabled`<=>NULL AND `fix_z`<=>1 AND `heading`<=>CAST(0 AS FLOAT) AND `id`<=>1270 AND `item`<=>1001 AND `max_allowed`<=>1 AND `max_expansion`<=>-1 AND `max_x`<=>CAST(213 AS FLOAT) AND `max_y`<=>CAST(767 AS FLOAT) AND `max_z`<=>CAST(-115 AS FLOAT) AND `min_expansion`<=>-1 AND `min_x`<=>CAST(213 AS FLOAT) AND `min_y`<=>CAST(767 AS FLOAT) AND BINARY `name`=CONVERT(0x495431313530345f4143544f52444546 USING utf8mb4) AND `respawn_timer`<=>300 AND `version`<=>0 AND `zoneid`<=>757)
          OR (BINARY `comment`=CONVERT(0x4175746f2067656e65726174656420627920436f6c6c6563746f722e2046495820544845204954454d494421 USING utf8mb4) AND `content_flags`<=>NULL AND `content_flags_disabled`<=>NULL AND `fix_z`<=>1 AND `heading`<=>CAST(0 AS FLOAT) AND `id`<=>1273 AND `item`<=>1001 AND `max_allowed`<=>1 AND `max_expansion`<=>-1 AND `max_x`<=>CAST(-152 AS FLOAT) AND `max_y`<=>CAST(1541 AS FLOAT) AND `max_z`<=>CAST(-33 AS FLOAT) AND `min_expansion`<=>-1 AND `min_x`<=>CAST(-152 AS FLOAT) AND `min_y`<=>CAST(1541 AS FLOAT) AND BINARY `name`=CONVERT(0x495431313530345f4143544f52444546 USING utf8mb4) AND `respawn_timer`<=>300 AND `version`<=>0 AND `zoneid`<=>757)
          OR (BINARY `comment`=CONVERT(0x4175746f2067656e65726174656420627920436f6c6c6563746f722e2046495820544845204954454d494421 USING utf8mb4) AND `content_flags`<=>NULL AND `content_flags_disabled`<=>NULL AND `fix_z`<=>1 AND `heading`<=>CAST(0 AS FLOAT) AND `id`<=>1455 AND `item`<=>1001 AND `max_allowed`<=>1 AND `max_expansion`<=>-1 AND `max_x`<=>CAST(591 AS FLOAT) AND `max_y`<=>CAST(-766 AS FLOAT) AND `max_z`<=>CAST(1168 AS FLOAT) AND `min_expansion`<=>-1 AND `min_x`<=>CAST(591 AS FLOAT) AND `min_y`<=>CAST(-766 AS FLOAT) AND BINARY `name`=CONVERT(0x495431313530345f4143544f52444546 USING utf8mb4) AND `respawn_timer`<=>300 AND `version`<=>0 AND `zoneid`<=>758)
          OR (BINARY `comment`=CONVERT(0x4175746f2067656e65726174656420627920436f6c6c6563746f722e2046495820544845204954454d494421 USING utf8mb4) AND `content_flags`<=>NULL AND `content_flags_disabled`<=>NULL AND `fix_z`<=>1 AND `heading`<=>CAST(0 AS FLOAT) AND `id`<=>1470 AND `item`<=>1001 AND `max_allowed`<=>1 AND `max_expansion`<=>-1 AND `max_x`<=>CAST(-694 AS FLOAT) AND `max_y`<=>CAST(-202 AS FLOAT) AND `max_z`<=>CAST(1167 AS FLOAT) AND `min_expansion`<=>-1 AND `min_x`<=>CAST(-694 AS FLOAT) AND `min_y`<=>CAST(-202 AS FLOAT) AND BINARY `name`=CONVERT(0x495431313530345f4143544f52444546 USING utf8mb4) AND `respawn_timer`<=>300 AND `version`<=>0 AND `zoneid`<=>758)
          OR (BINARY `comment`=CONVERT(0x4175746f2067656e65726174656420627920436f6c6c6563746f722e2046495820544845204954454d494421 USING utf8mb4) AND `content_flags`<=>NULL AND `content_flags_disabled`<=>NULL AND `fix_z`<=>1 AND `heading`<=>CAST(0 AS FLOAT) AND `id`<=>1487 AND `item`<=>1001 AND `max_allowed`<=>1 AND `max_expansion`<=>-1 AND `max_x`<=>CAST(-74 AS FLOAT) AND `max_y`<=>CAST(5136 AS FLOAT) AND `max_z`<=>CAST(216 AS FLOAT) AND `min_expansion`<=>-1 AND `min_x`<=>CAST(-74 AS FLOAT) AND `min_y`<=>CAST(5136 AS FLOAT) AND BINARY `name`=CONVERT(0x495431313530345f4143544f52444546 USING utf8mb4) AND `respawn_timer`<=>300 AND `version`<=>0 AND `zoneid`<=>759)
          OR (BINARY `comment`=CONVERT(0x4175746f2067656e65726174656420627920436f6c6c6563746f722e2046495820544845204954454d494421 USING utf8mb4) AND `content_flags`<=>NULL AND `content_flags_disabled`<=>NULL AND `fix_z`<=>1 AND `heading`<=>CAST(0 AS FLOAT) AND `id`<=>1531 AND `item`<=>1001 AND `max_allowed`<=>1 AND `max_expansion`<=>-1 AND `max_x`<=>CAST(-55 AS FLOAT) AND `max_y`<=>CAST(2310 AS FLOAT) AND `max_z`<=>CAST(10 AS FLOAT) AND `min_expansion`<=>-1 AND `min_x`<=>CAST(-55 AS FLOAT) AND `min_y`<=>CAST(2310 AS FLOAT) AND BINARY `name`=CONVERT(0x495431313530345f4143544f52444546 USING utf8mb4) AND `respawn_timer`<=>300 AND `version`<=>0 AND `zoneid`<=>759)
          OR (BINARY `comment`=CONVERT(0x4175746f2067656e65726174656420627920436f6c6c6563746f722e2046495820544845204954454d494421 USING utf8mb4) AND `content_flags`<=>NULL AND `content_flags_disabled`<=>NULL AND `fix_z`<=>1 AND `heading`<=>CAST(0 AS FLOAT) AND `id`<=>1353 AND `item`<=>1001 AND `max_allowed`<=>1 AND `max_expansion`<=>-1 AND `max_x`<=>CAST(812 AS FLOAT) AND `max_y`<=>CAST(-234 AS FLOAT) AND `max_z`<=>CAST(-69 AS FLOAT) AND `min_expansion`<=>-1 AND `min_x`<=>CAST(812 AS FLOAT) AND `min_y`<=>CAST(-234 AS FLOAT) AND BINARY `name`=CONVERT(0x495431313530345f4143544f52444546 USING utf8mb4) AND `respawn_timer`<=>300 AND `version`<=>0 AND `zoneid`<=>760)
          OR (BINARY `comment`=CONVERT(0x4175746f2067656e65726174656420627920436f6c6c6563746f722e2046495820544845204954454d494421 USING utf8mb4) AND `content_flags`<=>NULL AND `content_flags_disabled`<=>NULL AND `fix_z`<=>1 AND `heading`<=>CAST(0 AS FLOAT) AND `id`<=>1354 AND `item`<=>1001 AND `max_allowed`<=>1 AND `max_expansion`<=>-1 AND `max_x`<=>CAST(621 AS FLOAT) AND `max_y`<=>CAST(-474 AS FLOAT) AND `max_z`<=>CAST(-68 AS FLOAT) AND `min_expansion`<=>-1 AND `min_x`<=>CAST(621 AS FLOAT) AND `min_y`<=>CAST(-474 AS FLOAT) AND BINARY `name`=CONVERT(0x495431313530345f4143544f52444546 USING utf8mb4) AND `respawn_timer`<=>300 AND `version`<=>0 AND `zoneid`<=>760)
          OR (BINARY `comment`=CONVERT(0x4175746f2067656e65726174656420627920436f6c6c6563746f722e2046495820544845204954454d494421 USING utf8mb4) AND `content_flags`<=>NULL AND `content_flags_disabled`<=>NULL AND `fix_z`<=>1 AND `heading`<=>CAST(0 AS FLOAT) AND `id`<=>1405 AND `item`<=>1001 AND `max_allowed`<=>1 AND `max_expansion`<=>-1 AND `max_x`<=>CAST(708 AS FLOAT) AND `max_y`<=>CAST(-274 AS FLOAT) AND `max_z`<=>CAST(-545 AS FLOAT) AND `min_expansion`<=>-1 AND `min_x`<=>CAST(708 AS FLOAT) AND `min_y`<=>CAST(-274 AS FLOAT) AND BINARY `name`=CONVERT(0x495431313530335f4143544f52444546 USING utf8mb4) AND `respawn_timer`<=>300 AND `version`<=>0 AND `zoneid`<=>756)
          OR (BINARY `comment`=CONVERT(0x4175746f2067656e65726174656420627920436f6c6c6563746f722e2046495820544845204954454d494421 USING utf8mb4) AND `content_flags`<=>NULL AND `content_flags_disabled`<=>NULL AND `fix_z`<=>1 AND `heading`<=>CAST(0 AS FLOAT) AND `id`<=>1406 AND `item`<=>1001 AND `max_allowed`<=>1 AND `max_expansion`<=>-1 AND `max_x`<=>CAST(708 AS FLOAT) AND `max_y`<=>CAST(-274 AS FLOAT) AND `max_z`<=>CAST(-545 AS FLOAT) AND `min_expansion`<=>-1 AND `min_x`<=>CAST(708 AS FLOAT) AND `min_y`<=>CAST(-274 AS FLOAT) AND BINARY `name`=CONVERT(0x495431313530335f4143544f52444546 USING utf8mb4) AND `respawn_timer`<=>300 AND `version`<=>0 AND `zoneid`<=>756)
          OR (BINARY `comment`=CONVERT(0x4175746f2067656e65726174656420627920436f6c6c6563746f722e2046495820544845204954454d494421 USING utf8mb4) AND `content_flags`<=>NULL AND `content_flags_disabled`<=>NULL AND `fix_z`<=>1 AND `heading`<=>CAST(0 AS FLOAT) AND `id`<=>1409 AND `item`<=>1001 AND `max_allowed`<=>1 AND `max_expansion`<=>-1 AND `max_x`<=>CAST(708 AS FLOAT) AND `max_y`<=>CAST(-274 AS FLOAT) AND `max_z`<=>CAST(-545 AS FLOAT) AND `min_expansion`<=>-1 AND `min_x`<=>CAST(708 AS FLOAT) AND `min_y`<=>CAST(-274 AS FLOAT) AND BINARY `name`=CONVERT(0x495431313530335f4143544f52444546 USING utf8mb4) AND `respawn_timer`<=>300 AND `version`<=>0 AND `zoneid`<=>756)
          OR (BINARY `comment`=CONVERT(0x4175746f2067656e65726174656420627920436f6c6c6563746f722e2046495820544845204954454d494421 USING utf8mb4) AND `content_flags`<=>NULL AND `content_flags_disabled`<=>NULL AND `fix_z`<=>1 AND `heading`<=>CAST(0 AS FLOAT) AND `id`<=>1415 AND `item`<=>1001 AND `max_allowed`<=>1 AND `max_expansion`<=>-1 AND `max_x`<=>CAST(708 AS FLOAT) AND `max_y`<=>CAST(-274 AS FLOAT) AND `max_z`<=>CAST(-545 AS FLOAT) AND `min_expansion`<=>-1 AND `min_x`<=>CAST(708 AS FLOAT) AND `min_y`<=>CAST(-274 AS FLOAT) AND BINARY `name`=CONVERT(0x495431313530335f4143544f52444546 USING utf8mb4) AND `respawn_timer`<=>300 AND `version`<=>0 AND `zoneid`<=>756)
          OR (BINARY `comment`=CONVERT(0x4175746f2067656e65726174656420627920436f6c6c6563746f722e2046495820544845204954454d494421 USING utf8mb4) AND `content_flags`<=>NULL AND `content_flags_disabled`<=>NULL AND `fix_z`<=>1 AND `heading`<=>CAST(0 AS FLOAT) AND `id`<=>1417 AND `item`<=>1001 AND `max_allowed`<=>1 AND `max_expansion`<=>-1 AND `max_x`<=>CAST(708 AS FLOAT) AND `max_y`<=>CAST(-274 AS FLOAT) AND `max_z`<=>CAST(-545 AS FLOAT) AND `min_expansion`<=>-1 AND `min_x`<=>CAST(708 AS FLOAT) AND `min_y`<=>CAST(-274 AS FLOAT) AND BINARY `name`=CONVERT(0x495431313530335f4143544f52444546 USING utf8mb4) AND `respawn_timer`<=>300 AND `version`<=>0 AND `zoneid`<=>756)) <> 23 OR
    (SELECT COUNT(*) FROM achievement_criteria c JOIN items i ON i.id=c.target_id WHERE c.event_type=14 AND c.enabled=1 AND i.itemtype=66 AND (c.achievement_id,c.target_id) IN ((2090755,77518),(2090755,77519),(2090755,77520),(2090755,77521),(2090755,77522),(2090755,77523),(2090755,77524),(2090755,77525),(2090755,77526))) <> 9 OR
    (SELECT COUNT(*) FROM ground_spawn_collectibles WHERE `ground_spawn_id` IN (1273,1354,1412,1436,1455,1487,1590,1616,1636)) <> 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Collections exact red source preimage mismatch';
    END IF;

    UPDATE ground_spawns SET `min_x`=-653,`max_x`=-653,`min_y`=183,`max_y`=183,`max_z`=0.5,`item`=77521,`respawn_timer`=300,`fix_z`=1,`max_allowed`=1 WHERE id=1616 AND item=1001;

    IF ROW_COUNT() <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Collections affected rows mismatch: red source 1616';
    END IF;

    UPDATE ground_spawns SET `min_x`=-870,`max_x`=-870,`min_y`=-351,`max_y`=-351,`max_z`=-452.301,`item`=77518,`respawn_timer`=300,`fix_z`=1,`max_allowed`=1 WHERE id=1636 AND item=1001;

    IF ROW_COUNT() <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Collections affected rows mismatch: red source 1636';
    END IF;

    UPDATE ground_spawns SET `min_x`=1528,`max_x`=1528,`min_y`=1165,`max_y`=1165,`max_z`=-59.469,`item`=77522,`respawn_timer`=300,`fix_z`=1,`max_allowed`=1 WHERE id=1590 AND item=1001;

    IF ROW_COUNT() <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Collections affected rows mismatch: red source 1590';
    END IF;

    UPDATE ground_spawns SET `min_x`=1491,`max_x`=1491,`min_y`=-2057,`max_y`=-2057,`max_z`=211.489,`item`=77525,`respawn_timer`=300,`fix_z`=1,`max_allowed`=1 WHERE id=1436 AND item=1001;

    IF ROW_COUNT() <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Collections affected rows mismatch: red source 1436';
    END IF;

    UPDATE ground_spawns SET `min_x`=708,`max_x`=708,`min_y`=-274,`max_y`=-274,`max_z`=-545,`item`=77524,`respawn_timer`=300,`fix_z`=1,`max_allowed`=1 WHERE id=1412 AND item=1001;

    IF ROW_COUNT() <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Collections affected rows mismatch: red source 1412';
    END IF;

    UPDATE ground_spawns SET `min_x`=-152,`max_x`=-152,`min_y`=1539,`max_y`=1539,`max_z`=-37.771,`item`=77519,`respawn_timer`=300,`fix_z`=1,`max_allowed`=1 WHERE id=1273 AND item=1001;

    IF ROW_COUNT() <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Collections affected rows mismatch: red source 1273';
    END IF;

    UPDATE ground_spawns SET `min_x`=591,`max_x`=591,`min_y`=-766,`max_y`=-766,`max_z`=1165.499,`item`=77520,`respawn_timer`=300,`fix_z`=1,`max_allowed`=1 WHERE id=1455 AND item=1001;

    IF ROW_COUNT() <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Collections affected rows mismatch: red source 1455';
    END IF;

    UPDATE ground_spawns SET `min_x`=-74,`max_x`=-74,`min_y`=5136,`max_y`=5136,`max_z`=214.094,`item`=77526,`respawn_timer`=300,`fix_z`=1,`max_allowed`=1 WHERE id=1487 AND item=1001;

    IF ROW_COUNT() <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Collections affected rows mismatch: red source 1487';
    END IF;

    UPDATE ground_spawns SET `min_x`=619,`max_x`=619,`min_y`=-474,`max_y`=-474,`max_z`=-92.071,`item`=77523,`respawn_timer`=300,`fix_z`=1,`max_allowed`=1 WHERE id=1354 AND item=1001;

    IF ROW_COUNT() <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Collections affected rows mismatch: red source 1354';
    END IF;

    UPDATE ground_spawns SET `max_allowed`=0 WHERE `id` IN (1270,1353,1405,1406,1409,1414,1415,1417,1444,1470,1531,1597,1611,1647) AND max_allowed=1;

    IF ROW_COUNT() <> 14 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Collections affected rows mismatch: retired exact capture placeholders';
    END IF;

    INSERT INTO `ground_spawn_collectibles` (`ground_spawn_id`,`item_id`) VALUES
        (1616,77521),
        (1636,77518),
        (1590,77522),
        (1436,77525),
        (1412,77524),
        (1273,77519),
        (1455,77520),
        (1487,77526),
        (1354,77523);

    IF ROW_COUNT() <> 9 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='May Collections affected rows mismatch: red single-member collectible pools';
    END IF;

    COMMIT;
END$$
DELIMITER ;
