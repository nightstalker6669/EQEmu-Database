
-- Freeze distinct quest completion count with the durable reward occurrence.
-- NULL identifies a legacy/static reward; zero is a valid progression snapshot.
ALTER TABLE character_task_reward_selections
 ADD COLUMN IF NOT EXISTS progression_count INT UNSIGNED NULL DEFAULT NULL;
