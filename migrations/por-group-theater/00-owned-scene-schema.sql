CREATE TABLE IF NOT EXISTS por_group_scene_state (
    shared_task_id BIGINT UNSIGNED NOT NULL,
    task_id INT UNSIGNED NOT NULL,
    instance_id INT UNSIGNED NOT NULL,
    anchor_id INT UNSIGNED NOT NULL DEFAULT 0,
    character_id INT UNSIGNED NOT NULL,
    scene_step TINYINT UNSIGNED NOT NULL,
    PRIMARY KEY (shared_task_id, task_id, instance_id, anchor_id),
    CONSTRAINT por_group_scene_positive CHECK (
        shared_task_id > 0 AND instance_id > 0 AND character_id > 0
    ),
    CONSTRAINT por_group_scene_domain CHECK (
        (task_id = 920301 AND anchor_id = 0 AND scene_step = 1) OR
        (task_id = 920302 AND anchor_id = 0 AND scene_step BETWEEN 0 AND 9) OR
        (task_id = 920306 AND anchor_id BETWEEN 304081536 AND 304082047 AND scene_step = 1)
    )
) ENGINE=InnoDB;
