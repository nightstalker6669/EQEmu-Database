-- Required before enabling shared METHODSELECT tasks. No player rows modified.
-- The uint64 shared run identity is never truncated or encoded in a timestamp.
CREATE TABLE IF NOT EXISTS character_shared_task_reward_instances (
 character_id INT(10) UNSIGNED NOT NULL,
 shared_task_id BIGINT(20) UNSIGNED NOT NULL,
 task_id INT(10) UNSIGNED NOT NULL,
 occurrence_id BIGINT(20) UNSIGNED NOT NULL,
 PRIMARY KEY(character_id,shared_task_id),
 UNIQUE KEY shared_task_reward_occurrence(occurrence_id),
 KEY shared_task_reward_task(character_id,task_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
