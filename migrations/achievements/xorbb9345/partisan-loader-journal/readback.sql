-- Capture all physical columns, including untouched schema extensions.
SELECT * FROM `tasks` WHERE `id` IN (3040474,3040475,3040476) ORDER BY `id`;
SELECT * FROM `task_activities` WHERE (`taskid`=3040474 AND `activityid` IN (1,6,16)) OR (`taskid`=3040475 AND `activityid`=3) ORDER BY `taskid`,`activityid`;
