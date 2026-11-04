
-- Optional per-task membership and option gates. Empty tables preserve static rewards.
CREATE TABLE IF NOT EXISTS task_reward_progression_members (
 task_id INT UNSIGNED NOT NULL,
 qualifying_task_id INT UNSIGNED NOT NULL,
 PRIMARY KEY (task_id, qualifying_task_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS task_reward_option_gates (
 task_id INT UNSIGNED NOT NULL,
 option_id INT UNSIGNED NOT NULL,
 minimum_completions INT UNSIGNED NOT NULL,
 PRIMARY KEY (task_id, option_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
