-- DATABASE-CUSTODY SOURCE ONLY; NOT APPLIED OR ACTIVATED.
-- REQUIRED predecessor: unchanged 001_fos_food_custody_required.sql, SHA256
-- c2783fad063f04aadf1bed1f4cc9250f3a531a7bd85f55d053519c5264c981cc.
-- MariaDB10.11, DELIMITER-aware stop-on-error client; NOT MySQL8 syntax.
-- No surrounding transaction can roll back these independent DDL commits.
-- Exact metadata guards precede both DDL statements. No row DML/backfill.
-- Do not replay a partially applied migration; preserve state and inspect it.
DELIMITER $$
BEGIN NOT ATOMIC
  IF DATABASE() IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Transform schema: select the intended database';
  END IF;
  IF (SELECT COUNT(*) FROM information_schema.tables
      WHERE table_schema=DATABASE() AND table_type='BASE TABLE' AND engine='InnoDB'
        AND table_name IN ('kithicor_poison_custody','sod_weighted_delivery_state','sod_weighted_delivery_actions')) <> 3 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Transform schema: existing Food/physical InnoDB foundation required';
  END IF;
  IF (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema=DATABASE()
      AND table_name='sod_original_delivery_decisions') <> 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Transform schema: decision namespace occupied; do not replay';
  END IF;
  IF (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE()
      AND table_name='kithicor_poison_custody') <> 27 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Transform schema: exact Food27-column physical shape required';
  END IF;
  IF (SELECT COUNT(*) FROM (
    SELECT 'request_key' AS n,'char(32)' AS t,'NO' AS z,'ascii' AS c,'ascii_bin' AS l
    UNION ALL
    SELECT 'character_id','int unsigned','NO','',''
    UNION ALL
    SELECT 'account_id','int unsigned','NO','',''
    UNION ALL
    SELECT 'inventory_epoch','bigint unsigned','NO','',''
    UNION ALL
    SELECT 'inventory_token','binary(32)','NO','',''
    UNION ALL
    SELECT 'process_key','varbinary(96)','NO','',''
    UNION ALL
    SELECT 'client_key','varbinary(96)','NO','',''
    UNION ALL
    SELECT 'instance_id','int unsigned','NO','',''
    UNION ALL
    SELECT 'shared_task_id','bigint unsigned','NO','',''
    UNION ALL
    SELECT 'phase','tinyint unsigned','NO','',''
    UNION ALL
    SELECT 'chest','tinyint unsigned','NO','',''
    UNION ALL
    SELECT 'npc_type_id','int unsigned','NO','',''
    UNION ALL
    SELECT 'npc_entity_id','int unsigned','NO','',''
    UNION ALL
    SELECT 'npc_spawn_id','int unsigned','NO','',''
    UNION ALL
    SELECT 'source_slot','int unsigned','NO','',''
    UNION ALL
    SELECT 'source_guid','bigint unsigned','NO','',''
    UNION ALL
    SELECT 'source_charges','smallint unsigned','NO','',''
    UNION ALL
    SELECT 'preimage','mediumblob','NO','',''
    UNION ALL
    SELECT 'return_plan','mediumblob','NO','',''
    UNION ALL
    SELECT 'postimage','mediumblob','YES','',''
    UNION ALL
    SELECT 'physical','tinyint unsigned','NO','',''
    UNION ALL
    SELECT 'settled','tinyint unsigned','NO','',''
    UNION ALL
    SELECT 'settled_at','int unsigned','YES','',''
    UNION ALL
    SELECT 'created_at','int unsigned','NO','',''
    UNION ALL
    SELECT 'recipe_kind','tinyint unsigned','NO','',''
    UNION ALL
    SELECT 'recipe_context','mediumblob','YES','',''
    UNION ALL
    SELECT 'abort_only','tinyint unsigned','NO','',''
  ) e JOIN information_schema.columns a
    ON a.table_schema=DATABASE() AND a.table_name='kithicor_poison_custody' AND a.column_name=e.n
      AND (CASE WHEN a.data_type IN ('int','bigint','tinyint','smallint')
           THEN REGEXP_REPLACE(a.column_type,'[(][0-9]+[)]','') ELSE a.column_type END)=e.t
      AND a.is_nullable=e.z AND COALESCE(a.character_set_name,'')=e.c
      AND COALESCE(a.collation_name,'')=e.l AND a.extra=''
      AND COALESCE(a.generation_expression,'')='') <> 27 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Transform schema: physical column shape differs';
  END IF;
  IF (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE()
      AND table_name='kithicor_poison_custody'
      AND ((column_name='recipe_kind' AND column_default='1')
        OR (column_name='abort_only' AND column_default='0')
        OR (column_name='recipe_context' AND (column_default IS NULL OR UPPER(column_default)='NULL')))) <> 3 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Transform schema: original Food defaults differ';
  END IF;
  IF (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema=DATABASE()
      AND table_name='kithicor_poison_custody') <> 8 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Transform schema: original four keys required; do not replay';
  END IF;
  IF (SELECT COUNT(*) FROM (
    SELECT 'PRIMARY' AS n,1 AS s,'request_key' AS c,0 AS u
    UNION ALL
    SELECT 'actor_pending',1,'character_id',1
    UNION ALL
    SELECT 'actor_pending',2,'settled',1
    UNION ALL
    SELECT 'old_session',1,'character_id',1
    UNION ALL
    SELECT 'old_session',2,'inventory_epoch',1
    UNION ALL
    SELECT 'native_action',1,'shared_task_id',1
    UNION ALL
    SELECT 'native_action',2,'phase',1
    UNION ALL
    SELECT 'native_action',3,'chest',1
  ) e JOIN information_schema.statistics a
    ON a.table_schema=DATABASE() AND a.table_name='kithicor_poison_custody'
      AND a.index_name=e.n AND a.seq_in_index=e.s AND a.column_name=e.c
      AND a.non_unique=e.u AND a.sub_part IS NULL AND a.index_type='BTREE') <> 8 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Transform schema: original physical keys differ';
  END IF;

  -- Exact optional source-validated index. Same table/writer and immutable blobs.
  ALTER TABLE kithicor_poison_custody
    ADD INDEX recipe_outbox USING BTREE (recipe_kind,physical,settled,request_key);

  -- Final native decision only: no pending placeholder, context/physical copy,
  -- active-task/member FK, cascade, sequence, trigger or second debit engine.
  -- Shared acceptance/rejection belongs to World. Personal rows are accepted only.
  -- Cross-context per-root attribution/hash equality and immutable replay are
  -- enforced by the pinned source, not represented by duplicated columns here.
  CREATE TABLE sod_original_delivery_decisions (
    request_key CHAR(32) CHARACTER SET ascii COLLATE ascii_bin NOT NULL PRIMARY KEY,
    recipe_kind TINYINT UNSIGNED NOT NULL,
    model_version INT UNSIGNED NOT NULL,
    character_id INT UNSIGNED NOT NULL,
    account_id INT UNSIGNED NOT NULL,
    occurrence_kind TINYINT UNSIGNED NOT NULL,
    occurrence_id BIGINT UNSIGNED NOT NULL,
    activity_id INT UNSIGNED NOT NULL,
    task_id INT UNSIGNED NOT NULL,
    accepted_time INT UNSIGNED NOT NULL,
    context_sha256 CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    decision_kind TINYINT UNSIGNED NOT NULL,
    reject_reason SMALLINT UNSIGNED NOT NULL,
    tail_before_count INT UNSIGNED NULL,
    tail_target_count INT UNSIGNED NULL,
    primary_before_count INT UNSIGNED NULL,
    primary_target_count INT UNSIGNED NULL,
    root0_accepted_units INT UNSIGNED NOT NULL,
    root1_accepted_units INT UNSIGNED NOT NULL,
    root2_accepted_units INT UNSIGNED NOT NULL,
    root3_accepted_units INT UNSIGNED NOT NULL,
    created_at BIGINT UNSIGNED NOT NULL,
CHECK (OCTET_LENGTH(request_key)=32 AND BINARY request_key REGEXP '^[0-9a-f]{32}$'),
    CHECK (OCTET_LENGTH(context_sha256)=64 AND BINARY context_sha256 REGEXP '^[0-9a-f]{64}$'),
    CHECK (recipe_kind=3 AND model_version>0 AND character_id>0 AND account_id>0
           AND occurrence_id>0 AND accepted_time>0),
    CHECK ((occurrence_kind=1 AND task_id=920197 AND activity_id IN (0,1))
        OR (occurrence_kind=0 AND task_id=920207 AND activity_id IN (1,7,9))),
    CHECK (root0_accepted_units<=4 AND root1_accepted_units<=4
           AND root2_accepted_units<=4 AND root3_accepted_units<=4),
    CHECK ((tail_before_count IS NULL AND tail_target_count IS NULL
            AND primary_before_count IS NULL AND primary_target_count IS NULL)
        OR (tail_before_count IS NOT NULL AND tail_target_count IS NOT NULL
            AND primary_before_count IS NOT NULL AND primary_target_count IS NOT NULL
            AND tail_before_count<=tail_target_count AND tail_target_count<=4
            AND primary_before_count<=primary_target_count AND primary_target_count<=1)),
    CHECK (
      (decision_kind=1 AND reject_reason=0 AND (root0_accepted_units + root1_accepted_units + root2_accepted_units + root3_accepted_units)>0
       AND tail_before_count IS NOT NULL AND tail_target_count IS NOT NULL
       AND primary_before_count IS NOT NULL AND primary_target_count IS NOT NULL
       AND ((occurrence_kind=1
             AND tail_target_count+primary_target_count = tail_before_count+primary_before_count+(root0_accepted_units + root1_accepted_units + root2_accepted_units + root3_accepted_units))
         OR (occurrence_kind=0 AND (root0_accepted_units + root1_accepted_units + root2_accepted_units + root3_accepted_units)=1
             AND tail_before_count=0 AND tail_target_count=0
             AND primary_before_count=0 AND primary_target_count=1)))
      OR
      (decision_kind=2 AND occurrence_kind=1 AND reject_reason BETWEEN 1 AND 4 AND (root0_accepted_units + root1_accepted_units + root2_accepted_units + root3_accepted_units)=0
       AND ((tail_before_count IS NULL AND tail_target_count IS NULL
             AND primary_before_count IS NULL AND primary_target_count IS NULL)
         OR (tail_before_count IS NOT NULL AND tail_target_count IS NOT NULL
             AND primary_before_count IS NOT NULL AND primary_target_count IS NOT NULL
             AND tail_target_count=tail_before_count AND primary_target_count=primary_before_count)))
    )
  ) ENGINE=InnoDB;
END$$
DELIMITER ;
