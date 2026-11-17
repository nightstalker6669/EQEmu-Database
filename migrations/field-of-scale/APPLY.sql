-- Guarded FoS additive upgrade for selected compatible MariaDB10.11 database.
-- Backup+offline writers required. One DELIMITER-aware stop-on-error connection.
-- No --force, seed replay, private state replacement or blind partialDDL retry.
SET @fos_prior_sql_mode=@@SESSION.sql_mode;
SET SESSION sql_mode=CONCAT_WS(',',NULLIF(@@SESSION.sql_mode,''),'STRICT_ALL_TABLES','NO_ENGINE_SUBSTITUTION');
SET @fos_transform002_source_sha256=NULL;
SET @fos_transform002_check_signature=NULL;

-- SOURCE-ONLY DATABASE-CUSTODY MIGRATION; NOT APPLIED OR ACTIVATED.
-- MariaDB 10.11 target, client must honor DELIMITER and STOP on first error.
-- Apply only in a coordinator-owned maintenance window with the matching writer.
-- No transaction wrapper: MariaDB DDL commits; partial execution is NOT retry-safe.
-- Guards inspect metadata only; no player/journal data are read or rewritten.
-- Preserve legacy physical journal, all original columns/keys, and pending rows.
DELIMITER $$
BEGIN NOT ATOMIC
  IF DATABASE() IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Food schema: select the intended database';
  END IF;
  IF (SELECT COUNT(*) FROM information_schema.tables
      WHERE table_schema=DATABASE() AND table_name='kithicor_poison_custody'
        AND table_type='BASE TABLE' AND engine='InnoDB') <> 1 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Food schema: original InnoDB custody table required';
  END IF;
  IF (SELECT COUNT(*) FROM information_schema.tables
      WHERE table_schema=DATABASE() AND table_name IN
        ('sod_weighted_delivery_state','sod_weighted_delivery_actions')) <> 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Food schema: semantic names occupied; do not replay';
  END IF;
  IF (SELECT COUNT(*) FROM information_schema.columns
      WHERE table_schema=DATABASE() AND table_name='kithicor_poison_custody') <> 24 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Food schema: physical column count differs; do not replay';
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
    SELECT 'created_at','int unsigned','NO','',''
    UNION ALL
    SELECT 'settled_at','int unsigned','YES','',''
  ) e JOIN information_schema.columns a
    ON a.table_schema=DATABASE() AND a.table_name='kithicor_poison_custody'
      AND a.column_name=e.n
      AND (CASE WHEN a.data_type IN ('int','bigint','tinyint','smallint')
           THEN REGEXP_REPLACE(a.column_type,'[(][0-9]+[)]','') ELSE a.column_type END)=e.t
      AND a.is_nullable=e.z AND COALESCE(a.character_set_name,'')=e.c
      AND COALESCE(a.collation_name,'')=e.l AND a.extra=''
      AND COALESCE(a.generation_expression,'')='') <> 24 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Food schema: original physical column shape differs';
  END IF;
  IF (SELECT COUNT(*) FROM information_schema.statistics
      WHERE table_schema=DATABASE() AND table_name='kithicor_poison_custody') <> 8 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Food schema: original physical index count differs';
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
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Food schema: original physical keys differ';
  END IF;
  IF (SELECT COUNT(*) FROM information_schema.tables
      WHERE table_schema=DATABASE() AND table_type='BASE TABLE' AND engine='InnoDB'
        AND table_name IN ('character_task_reward_instances','character_tasks','character_activities',
                          'housing_inventory_sessions','inventory','character_currency')) <> 6 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Food schema: transactional native/session/inventory foundation differs';
  END IF;

  -- Legacy rows gain Kith defaults through this single additive ALTER.
  -- No UPDATE/backfill/normalization, key changes, second physical journal or trigger.
  ALTER TABLE kithicor_poison_custody
    ADD COLUMN recipe_kind TINYINT UNSIGNED NOT NULL DEFAULT 1,
    ADD COLUMN recipe_context MEDIUMBLOB NULL DEFAULT NULL,
    ADD COLUMN abort_only TINYINT UNSIGNED NOT NULL DEFAULT 0;

  CREATE TABLE sod_weighted_delivery_state (
   character_id INT UNSIGNED NOT NULL,
   task_id INT UNSIGNED NOT NULL,
   occurrence_id BIGINT UNSIGNED NOT NULL,
   activity_id INT UNSIGNED NOT NULL,
   recipe_model INT UNSIGNED NOT NULL,
   revision BIGINT UNSIGNED NOT NULL DEFAULT 0,
   carry_pounds TINYINT UNSIGNED NOT NULL DEFAULT 0,
   carry_expires_at INT UNSIGNED NOT NULL DEFAULT 0,
   PRIMARY KEY (character_id,task_id,occurrence_id,activity_id),
   CHECK (task_id=920198 AND activity_id=1 AND recipe_model>0),
   CHECK (carry_pounds<10),
   CHECK ((carry_pounds=0 AND carry_expires_at=0) OR (carry_pounds>0 AND carry_expires_at>0))
  ) ENGINE=InnoDB;
  CREATE TABLE sod_weighted_delivery_actions (
   request_key CHAR(32) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
   character_id INT UNSIGNED NOT NULL,
   task_id INT UNSIGNED NOT NULL,
   occurrence_id BIGINT UNSIGNED NOT NULL,
   activity_id INT UNSIGNED NOT NULL,
   accepted_time INT UNSIGNED NOT NULL,
   recipe_model INT UNSIGNED NOT NULL,
   context_blob MEDIUMBLOB NOT NULL,
   status TINYINT UNSIGNED NOT NULL DEFAULT 0,
   updated_at INT UNSIGNED NOT NULL,
   PRIMARY KEY (request_key),
   KEY occurrence_status (character_id,task_id,occurrence_id,activity_id,status),
   CHECK (task_id=920198 AND activity_id=1 AND accepted_time>0 AND recipe_model>0),
   CHECK (status<=3)
  ) ENGINE=InnoDB;
END$$
DELIMITER ;

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

SET @fos_transform002_source_sha256='3e5e336c69a791844a72329a0e573e2efd4c1c88edcfd60cc4e4898f1e4e60b1';

-- SESSION METADATA BINDING, immediately after VERIFIED fresh Transform002.
-- No DDL or data DML. Same connection, stop-on-error; never run to adopt an
-- unrelated existing table. Parent batch sets source pin only after 002 succeeds.
DELIMITER $$
BEGIN NOT ATOMIC
  IF @fos_transform002_source_sha256 IS NULL OR @fos_transform002_source_sha256<>'3e5e336c69a791844a72329a0e573e2efd4c1c88edcfd60cc4e4898f1e4e60b1' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Message binding: verified fresh Transform002 required';
  END IF;
  IF (SELECT COUNT(*) FROM information_schema.check_constraints WHERE constraint_schema=DATABASE() AND table_name='sod_original_delivery_decisions')<>7
     OR (SELECT COUNT(*) FROM information_schema.check_constraints WHERE constraint_schema=DATABASE() AND table_name='sod_original_delivery_decisions' AND check_clause LIKE '%model_version%')<>1
     OR (SELECT COUNT(*) FROM information_schema.check_constraints WHERE constraint_schema=DATABASE() AND table_name='sod_original_delivery_decisions' AND check_clause LIKE '%task_id%')<>1
     OR (SELECT COUNT(*) FROM information_schema.check_constraints WHERE constraint_schema=DATABASE() AND table_name='sod_original_delivery_decisions' AND check_clause LIKE '%decision_kind%')<>1 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Message binding: exact002 seven-check preimage required';
  END IF;
  IF (SELECT COALESCE(SUM(OCTET_LENGTH(constraint_name)+OCTET_LENGTH(check_clause)+64),0)
      FROM information_schema.check_constraints WHERE constraint_schema=DATABASE() AND table_name='sod_original_delivery_decisions')>@@group_concat_max_len THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Message binding: metadata signature would truncate';
  END IF;
  SET @fos_transform002_database=DATABASE();
  SELECT SHA2(GROUP_CONCAT(CONCAT(OCTET_LENGTH(constraint_name),':',constraint_name,':',OCTET_LENGTH(check_clause),':',check_clause) ORDER BY constraint_name SEPARATOR '|'),256) INTO @fos_transform002_check_signature FROM information_schema.check_constraints WHERE constraint_schema=DATABASE() AND table_name='sod_original_delivery_decisions';
  SELECT constraint_name INTO @fos_transform002_foundation_name FROM information_schema.check_constraints WHERE constraint_schema=DATABASE() AND table_name='sod_original_delivery_decisions' AND check_clause LIKE '%model_version%';
  SELECT constraint_name INTO @fos_transform002_route_name FROM information_schema.check_constraints WHERE constraint_schema=DATABASE() AND table_name='sod_original_delivery_decisions' AND check_clause LIKE '%task_id%';
  SELECT constraint_name INTO @fos_transform002_final_name FROM information_schema.check_constraints WHERE constraint_schema=DATABASE() AND table_name='sod_original_delivery_decisions' AND check_clause LIKE '%decision_kind%';
END$$
DELIMITER ;

-- DATABASE CUSTODY SOURCE ONLY; NOT EXECUTED OR ACTIVATED.
-- Order: unchanged Food001 -> unchanged Transform002 -> immediate session
-- 002_CAPTURE_CHECK_BINDING -> Message003 -> ONE final content transaction.
-- MariaDB10.11, same DELIMITER-aware stop-on-error connection throughout.
-- Do not blindly adopt existing002: exact batch source pin plus freshly bound
-- complete actual CHECK metadata is required. No guessed constraint names.
-- Two independent DDL commits; partial failure stops without auto-drop/replay.
DELIMITER $$
BEGIN NOT ATOMIC
  IF @fos_transform002_source_sha256 IS NULL OR @fos_transform002_source_sha256<>'3e5e336c69a791844a72329a0e573e2efd4c1c88edcfd60cc4e4898f1e4e60b1'
     OR @fos_transform002_database IS NULL OR @fos_transform002_database<>DATABASE()
     OR @fos_transform002_check_signature IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Message003: fresh verified002 binding missing';
  END IF;
  IF (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema=DATABASE()
      AND table_name='sod_original_delivery_decisions' AND table_type='BASE TABLE' AND engine='InnoDB')<>1
     OR (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='sod_original_delivery_decisions')<>22 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Message003: exact22-column InnoDB decision table required';
  END IF;
  IF (SELECT COUNT(*) FROM (
    SELECT 'request_key' AS n,'char(32)' AS t,'NO' AS z,'ascii' AS c,'ascii_bin' AS l UNION ALL SELECT 'recipe_kind','tinyint unsigned','NO','','' UNION ALL SELECT 'model_version','int unsigned','NO','','' UNION ALL SELECT 'character_id','int unsigned','NO','','' UNION ALL SELECT 'account_id','int unsigned','NO','','' UNION ALL SELECT 'occurrence_kind','tinyint unsigned','NO','','' UNION ALL SELECT 'occurrence_id','bigint unsigned','NO','','' UNION ALL SELECT 'activity_id','int unsigned','NO','','' UNION ALL SELECT 'task_id','int unsigned','NO','','' UNION ALL SELECT 'accepted_time','int unsigned','NO','','' UNION ALL SELECT 'context_sha256','char(64)','NO','ascii','ascii_bin' UNION ALL SELECT 'decision_kind','tinyint unsigned','NO','','' UNION ALL SELECT 'reject_reason','smallint unsigned','NO','','' UNION ALL SELECT 'tail_before_count','int unsigned','YES','','' UNION ALL SELECT 'tail_target_count','int unsigned','YES','','' UNION ALL SELECT 'primary_before_count','int unsigned','YES','','' UNION ALL SELECT 'primary_target_count','int unsigned','YES','','' UNION ALL SELECT 'root0_accepted_units','int unsigned','NO','','' UNION ALL SELECT 'root1_accepted_units','int unsigned','NO','','' UNION ALL SELECT 'root2_accepted_units','int unsigned','NO','','' UNION ALL SELECT 'root3_accepted_units','int unsigned','NO','','' UNION ALL SELECT 'created_at','bigint unsigned','NO','',''
  ) e JOIN information_schema.columns a ON a.table_schema=DATABASE() AND a.table_name='sod_original_delivery_decisions' AND a.column_name=e.n
    AND (CASE WHEN a.data_type IN ('int','bigint','tinyint','smallint') THEN REGEXP_REPLACE(a.column_type,'[(][0-9]+[)]','') ELSE a.column_type END)=e.t
    AND a.is_nullable=e.z AND COALESCE(a.character_set_name,'')=e.c AND COALESCE(a.collation_name,'')=e.l
    AND a.extra='' AND COALESCE(a.generation_expression,'')='')<>22 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Message003: decision column shape differs';
  END IF;
  IF (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema=DATABASE() AND table_name='sod_original_delivery_decisions')<>1
     OR (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema=DATABASE() AND table_name='sod_original_delivery_decisions'
         AND index_name='PRIMARY' AND seq_in_index=1 AND column_name='request_key' AND non_unique=0 AND sub_part IS NULL AND index_type='BTREE')<>1 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Message003: original request-key PK differs';
  END IF;
  IF (SELECT COUNT(*) FROM information_schema.check_constraints WHERE constraint_schema=DATABASE() AND table_name='sod_original_delivery_decisions')<>7
     OR NOT ((SELECT SHA2(GROUP_CONCAT(CONCAT(OCTET_LENGTH(constraint_name),':',constraint_name,':',OCTET_LENGTH(check_clause),':',check_clause) ORDER BY constraint_name SEPARATOR '|'),256) FROM information_schema.check_constraints WHERE constraint_schema=DATABASE() AND table_name='sod_original_delivery_decisions') <=> @fos_transform002_check_signature) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Message003: exact002 CHECK preimage differs';
  END IF;
  IF @fos_transform002_foundation_name IS NULL OR @fos_transform002_route_name IS NULL OR @fos_transform002_final_name IS NULL
     OR @fos_transform002_foundation_name=@fos_transform002_route_name OR @fos_transform002_foundation_name=@fos_transform002_final_name
     OR @fos_transform002_route_name=@fos_transform002_final_name THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Message003: exact three002 names not bound';
  END IF;
  IF (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema=DATABASE() AND table_name='sod_original_message_selectors')<>0
     OR (SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema=DATABASE() AND table_name='sod_original_delivery_decisions'
         AND constraint_name IN ('fos_delivery_foundation_v3','fos_delivery_route_v3','fos_delivery_final_v3'))<>0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Message003: new namespace occupied; do not replay';
  END IF;

  SET @fos_message_alter=CONCAT('ALTER TABLE sod_original_delivery_decisions DROP CONSTRAINT `',REPLACE(@fos_transform002_foundation_name,'`','``'),'`, DROP CONSTRAINT `',REPLACE(@fos_transform002_route_name,'`','``'),'`, DROP CONSTRAINT `',REPLACE(@fos_transform002_final_name,'`','``'),'`, ADD CONSTRAINT fos_delivery_foundation_v3 CHECK ((recipe_kind=3 AND model_version>0 AND character_id>0 AND account_id>0
           AND occurrence_id>0 AND accepted_time>0) OR ((occurrence_kind=1 AND task_id BETWEEN 920200 AND 920203 AND activity_id=0) AND recipe_kind=3 AND model_version>0 AND character_id>0 AND account_id>0)), ADD CONSTRAINT fos_delivery_route_v3 CHECK (((occurrence_kind=1 AND task_id=920197 AND activity_id IN (0,1))
        OR (occurrence_kind=0 AND task_id=920207 AND activity_id IN (1,7,9))) OR (occurrence_kind=1 AND task_id BETWEEN 920200 AND 920203 AND activity_id=0)), ADD CONSTRAINT fos_delivery_final_v3 CHECK ((((occurrence_kind=1 AND task_id=920197 AND activity_id IN (0,1))
        OR (occurrence_kind=0 AND task_id=920207 AND activity_id IN (1,7,9))) AND (
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
    )) OR ((occurrence_kind=1 AND task_id BETWEEN 920200 AND 920203 AND activity_id=0)
      AND root0_accepted_units<=1 AND root1_accepted_units<=1
      AND root2_accepted_units<=1 AND root3_accepted_units<=1
      AND tail_before_count IS NULL AND tail_target_count IS NULL
      AND primary_before_count IS NULL AND primary_target_count IS NULL
      AND ((decision_kind=1 AND reject_reason=0 AND (root0_accepted_units+root1_accepted_units+root2_accepted_units+root3_accepted_units)=1 AND occurrence_id>0 AND accepted_time>0)
        OR (decision_kind=2 AND reject_reason BETWEEN 1 AND 4 AND (root0_accepted_units+root1_accepted_units+root2_accepted_units+root3_accepted_units)=0 AND occurrence_id=0 AND accepted_time=0))))');
  PREPARE fos_message_statement FROM @fos_message_alter;
  EXECUTE fos_message_statement;
  DEALLOCATE PREPARE fos_message_statement;

  CREATE TABLE sod_original_message_selectors (
request_key CHAR(32) CHARACTER SET ascii COLLATE ascii_bin NOT NULL PRIMARY KEY,
    character_id int unsigned NOT NULL,
    account_id int unsigned NOT NULL,
    task_id int unsigned NOT NULL,
    npc_type_id int unsigned NOT NULL,
    npc_entity_id int unsigned NOT NULL,
    npc_spawn_id int unsigned NOT NULL,
    selector_generation bigint unsigned NOT NULL,
    state tinyint unsigned NOT NULL,
    native_nonce bigint unsigned NULL DEFAULT NULL,
    native_roster_proof varbinary(120) NULL DEFAULT NULL,
    context_sha256 CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    created_at int unsigned NOT NULL,
    updated_at int unsigned NOT NULL,
    UNIQUE KEY native_nonce (character_id,native_nonce),
    KEY submitted_outbox (state,request_key),
    CHECK (OCTET_LENGTH(request_key)=32 AND BINARY request_key REGEXP '^[0-9a-f]{32}$'),
    CHECK (OCTET_LENGTH(context_sha256)=64 AND BINARY context_sha256 REGEXP '^[0-9a-f]{64}$'),
    CHECK (task_id BETWEEN 920200 AND 920203 AND selector_generation=1),
    CHECK ((state IN (0,2) AND native_nonce IS NULL AND native_roster_proof IS NULL)
        OR (state=1 AND native_nonce IS NOT NULL AND native_nonce>0
            AND native_roster_proof IS NOT NULL AND OCTET_LENGTH(native_roster_proof)=120))
  ) ENGINE=InnoDB;
END$$
DELIMITER ;

-- Database-owned ONE content transaction; exact approved owner fragments.
DELIMITER $$
BEGIN NOT ATOMIC
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;
  IF @@in_transaction<>0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS content: outer transaction prohibited';
  END IF;
  IF (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema=DATABASE()
      AND table_type='BASE TABLE' AND engine='InnoDB' AND table_name IN ('dynamic_zone_templates','grid','grid_entries','items','lootdrop','lootdrop_entries','loottable','loottable_entries','npc_faction','npc_spells','npc_spells_entries','npc_types','object','reward_option_entries','reward_options','reward_sets','reward_sources','rewards','rule_values','spawn2','spawnentry','spawngroup','task_activities','tasks','tasksets','zone','zone_points'))<>27 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS content: exact touched-table InnoDB foundation differs';
  END IF;
  START TRANSACTION;

-- Approved FoS NPC content DATA FRAGMENT; not executed.
-- Consume once inside Database-owned final aggregate transaction/application.
-- Exact proposal5c31978e, NPCbill54f80624, reservation439812d3.
-- Strings use hex conversion to avoid SQL-mode/backslash quoting changes.
-- Plain INSERT is intentional: duplicate-key conflict must stop the owner batch.
-- All five CAS updates require ROW_COUNT()=1; owner must stop/rollback on mismatch.
-- No USE/START/COMMIT/DDL/REPLACE/IGNORE/UPSERT, player tables or door/zonepoint writes.

-- items: 2 new rows
INSERT INTO `items` (`id`,`minstatus`,`Name`,`aagi`,`ac`,`accuracy`,`acha`,`adex`,`aint`,`artifactflag`,`asta`,`astr`,`attack`,`augrestrict`,`augslot1type`,`augslot1visible`,`augslot2type`,`augslot2visible`,`augslot3type`,`augslot3visible`,`augslot4type`,`augslot4visible`,`augslot5type`,`augslot5visible`,`augslot6type`,`augslot6visible`,`augtype`,`avoidance`,`awis`,`bagsize`,`bagslots`,`bagtype`,`bagwr`,`banedmgamt`,`banedmgraceamt`,`banedmgbody`,`banedmgrace`,`bardtype`,`bardvalue`,`book`,`casttime`,`casttime_`,`charmfile`,`charmfileid`,`classes`,`color`,`combateffects`,`extradmgskill`,`extradmgamt`,`price`,`cr`,`damage`,`damageshield`,`deity`,`delay`,`augdistiller`,`dotshielding`,`dr`,`clicktype`,`clicklevel2`,`elemdmgtype`,`elemdmgamt`,`endur`,`factionamt1`,`factionamt2`,`factionamt3`,`factionamt4`,`factionmod1`,`factionmod2`,`factionmod3`,`factionmod4`,`filename`,`focuseffect`,`fr`,`fvnodrop`,`haste`,`clicklevel`,`hp`,`regen`,`icon`,`idfile`,`itemclass`,`itemtype`,`ldonprice`,`ldontheme`,`ldonsold`,`light`,`lore`,`loregroup`,`magic`,`mana`,`manaregen`,`enduranceregen`,`material`,`herosforgemodel`,`maxcharges`,`mr`,`nodrop`,`norent`,`pendingloreflag`,`pr`,`procrate`,`races`,`range`,`reclevel`,`recskill`,`reqlevel`,`sellrate`,`shielding`,`size`,`skillmodtype`,`skillmodvalue`,`slots`,`clickeffect`,`spellshield`,`strikethrough`,`stunresist`,`summonedflag`,`tradeskills`,`favor`,`weight`,`UNK012`,`UNK013`,`benefitflag`,`UNK054`,`UNK059`,`booktype`,`recastdelay`,`recasttype`,`guildfavor`,`UNK123`,`UNK124`,`attuneable`,`nopet`,`updated`,`comment`,`UNK127`,`pointtype`,`potionbelt`,`potionbeltslots`,`stacksize`,`notransfer`,`stackable`,`UNK134`,`UNK137`,`proceffect`,`proctype`,`proclevel2`,`proclevel`,`UNK142`,`worneffect`,`worntype`,`wornlevel2`,`wornlevel`,`UNK147`,`focustype`,`focuslevel2`,`focuslevel`,`UNK152`,`scrolleffect`,`scrolltype`,`scrolllevel2`,`scrolllevel`,`UNK157`,`serialized`,`verified`,`serialization`,`source`,`UNK033`,`lorefile`,`UNK014`,`svcorruption`,`skillmodmax`,`UNK060`,`augslot1unk2`,`augslot2unk2`,`augslot3unk2`,`augslot4unk2`,`augslot5unk2`,`augslot6unk2`,`UNK120`,`UNK121`,`questitemflag`,`UNK132`,`clickunk5`,`clickunk6`,`clickunk7`,`procunk1`,`procunk2`,`procunk3`,`procunk4`,`procunk6`,`procunk7`,`wornunk1`,`wornunk2`,`wornunk3`,`wornunk4`,`wornunk5`,`wornunk6`,`wornunk7`,`focusunk1`,`focusunk2`,`focusunk3`,`focusunk4`,`focusunk5`,`focusunk6`,`focusunk7`,`scrollunk1`,`scrollunk2`,`scrollunk3`,`scrollunk4`,`scrollunk5`,`scrollunk6`,`scrollunk7`,`UNK193`,`purity`,`evoitem`,`evoid`,`evolvinglevel`,`evomax`,`clickname`,`procname`,`wornname`,`focusname`,`scrollname`,`dsmitigation`,`heroic_str`,`heroic_int`,`heroic_wis`,`heroic_agi`,`heroic_dex`,`heroic_sta`,`heroic_cha`,`heroic_pr`,`heroic_dr`,`heroic_fr`,`heroic_cr`,`heroic_mr`,`heroic_svcorrup`,`healamt`,`spelldmg`,`clairvoyance`,`backstabdmg`,`created`,`elitematerial`,`ldonsellbackrate`,`scriptfileid`,`expendablearrow`,`powersourcecapacity`,`bardeffect`,`bardeffecttype`,`bardlevel2`,`bardlevel`,`bardunk1`,`bardunk2`,`bardunk3`,`bardunk4`,`bardunk5`,`bardname`,`bardunk7`,`UNK214`,`subtype`,`UNK220`,`UNK221`,`heirloom`,`UNK223`,`UNK224`,`UNK225`,`UNK226`,`UNK227`,`UNK228`,`UNK229`,`UNK230`,`UNK231`,`UNK232`,`UNK233`,`UNK234`,`placeable`,`UNK236`,`UNK237`,`UNK238`,`UNK239`,`UNK240`,`UNK241`,`epicitem`,`housing_disable_rotation`,`housing_disable_free_placement`) VALUES
(199900,0,CONVERT(X'5365616c6564204d657373616765' USING utf8mb4),0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,CONVERT(X'' USING utf8mb4),CONVERT(X'30' USING utf8mb4),0,4278190080,CONVERT(X'30' USING utf8mb4),0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,CONVERT(X'4f46424d657373656e6765724e6f746531' USING utf8mb4),-1,0,0,0,0,0,0,2274,CONVERT(X'49543633' USING utf8mb4),2,32,0,0,0,0,CONVERT(X'5365616c656420776974682074686520536562696c697369616e20736967696c' USING utf8mb4),0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1.0,0,1,0,0,0,-1,0,0,0,0,0,0,10,0,1,0,0,0,0,0,0,0,0,0,0,0,CONVERT(X'323031352d31322d31322030303a34313a3236' USING utf8mb4),CONVERT(X'' USING utf8mb4),0,0,0,0,1,0,0,CONVERT(X'' USING utf8mb4),0,-1,0,0,0,0,-1,0,0,0,0,0,0,0,0,-1,0,0,0,0,NULL,CONVERT(X'323031362d30332d30342030303a32373a3439' USING utf8mb4),NULL,CONVERT(X'31335448464c4f4f52' USING utf8mb4),0,CONVERT(X'' USING utf8mb4),0,0,0,0,0,0,0,0,0,0,-1,0,1,CONVERT(X'30303030303030303030303030303030303030' USING utf8mb4),0,CONVERT(X'' USING utf8mb4),-1,0,0,0,0,CONVERT(X'' USING utf8mb4),-1,0,0,0,0,0,CONVERT(X'' USING utf8mb4),-1,0,0,0,0,0,CONVERT(X'' USING utf8mb4),-1,0,0,0,0,0,CONVERT(X'' USING utf8mb4),-1,0,0,0,0,0,0,CONVERT(X'' USING utf8mb4),CONVERT(X'' USING utf8mb4),CONVERT(X'' USING utf8mb4),CONVERT(X'' USING utf8mb4),CONVERT(X'' USING utf8mb4),0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,CONVERT(X'323031352d31322d31322030303a34313a3236' USING utf8mb4),0,70,0,0,0,-1,0,0,0,0,0,0,0,0,CONVERT(X'' USING utf8mb4),-1,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,-1,0,0,0,0,0,0,0,0,0,NULL,NULL),
(199901,0,CONVERT(X'5365616c6564204d657373616765' USING utf8mb4),0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,CONVERT(X'' USING utf8mb4),CONVERT(X'30' USING utf8mb4),0,4278190080,CONVERT(X'30' USING utf8mb4),0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,CONVERT(X'4f46424d657373656e6765724e6f746531' USING utf8mb4),-1,0,0,0,0,0,0,2274,CONVERT(X'49543633' USING utf8mb4),2,32,0,0,0,0,CONVERT(X'5365616c656420776974682074686520536562696c697369616e20736967696c' USING utf8mb4),0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1.0,0,1,0,0,0,-1,0,0,0,0,0,0,10,0,1,0,0,0,0,0,0,0,0,0,0,0,CONVERT(X'323031352d31322d31322030303a34313a3236' USING utf8mb4),CONVERT(X'' USING utf8mb4),0,0,0,0,1,0,0,CONVERT(X'' USING utf8mb4),0,-1,0,0,0,0,-1,0,0,0,0,0,0,0,0,-1,0,0,0,0,NULL,CONVERT(X'323031362d30332d30342030303a32373a3439' USING utf8mb4),NULL,CONVERT(X'31335448464c4f4f52' USING utf8mb4),0,CONVERT(X'' USING utf8mb4),0,0,0,0,0,0,0,0,0,0,-1,0,1,CONVERT(X'30303030303030303030303030303030303030' USING utf8mb4),0,CONVERT(X'' USING utf8mb4),-1,0,0,0,0,CONVERT(X'' USING utf8mb4),-1,0,0,0,0,0,CONVERT(X'' USING utf8mb4),-1,0,0,0,0,0,CONVERT(X'' USING utf8mb4),-1,0,0,0,0,0,CONVERT(X'' USING utf8mb4),-1,0,0,0,0,0,0,CONVERT(X'' USING utf8mb4),CONVERT(X'' USING utf8mb4),CONVERT(X'' USING utf8mb4),CONVERT(X'' USING utf8mb4),CONVERT(X'' USING utf8mb4),0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,CONVERT(X'323031352d31322d31322030303a34313a3236' USING utf8mb4),0,70,0,0,0,-1,0,0,0,0,0,0,0,0,CONVERT(X'' USING utf8mb4),-1,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,-1,0,0,0,0,0,0,0,0,0,NULL,NULL);
IF ROW_COUNT() <> 2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS NPC items insert count differs'; END IF;

-- npc_faction: 2 new rows
INSERT INTO `npc_faction` (`id`,`name`,`primaryfaction`,`ignore_primary_assist`) VALUES
(304066000,CONVERT(X'466f535f4c4f43414c5f6d697373696f6e5f686f7374696c65' USING utf8mb4),-4,0),
(304066001,CONVERT(X'466f535f4c4f43414c5f4b6f74685f686f7374696c65' USING utf8mb4),-7,1);
IF ROW_COUNT() <> 2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS NPC npc_faction insert count differs'; END IF;

-- lootdrop: 7 new rows
INSERT INTO `lootdrop` (`id`,`name`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(304066000,CONVERT(X'4c4f43414c5f464f535f476f7264616b' USING utf8mb4),-1,-1,NULL,NULL),
(304066001,CONVERT(X'4c4f43414c5f464f535f536869656c64' USING utf8mb4),-1,-1,NULL,NULL),
(304066002,CONVERT(X'4c4f43414c5f464f535f506574726966696564536b756c6c' USING utf8mb4),-1,-1,NULL,NULL),
(304066003,CONVERT(X'4c4f43414c5f464f535f536b656c6574616c48616e64' USING utf8mb4),-1,-1,NULL,NULL),
(304066004,CONVERT(X'4c4f43414c5f464f535f4461726b626c61646553776f726473' USING utf8mb4),-1,-1,NULL,NULL),
(304066005,CONVERT(X'4c4f43414c5f464f535f4d657373616765427572796e6169' USING utf8mb4),-1,-1,NULL,NULL),
(304066006,CONVERT(X'4c4f43414c5f464f535f4d6573736167654b75726e' USING utf8mb4),-1,-1,NULL,NULL);
IF ROW_COUNT() <> 7 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS NPC lootdrop insert count differs'; END IF;

-- lootdrop_entries: 41 new rows
INSERT INTO `lootdrop_entries` (`lootdrop_id`,`item_id`,`item_charges`,`equip_item`,`chance`,`disabled_chance`,`trivial_min_level`,`trivial_max_level`,`multiplier`,`npc_min_level`,`npc_max_level`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(304066000,17346,1,0,100,0.0,0,0,1,0,0,-1,-1,CONVERT(X'' USING utf8mb4),CONVERT(X'' USING utf8mb4)),
(304066001,17490,1,0,100,0.0,0,0,1,0,0,-1,-1,CONVERT(X'' USING utf8mb4),CONVERT(X'' USING utf8mb4)),
(304066002,17289,1,0,100,0.0,0,0,1,0,0,-1,-1,CONVERT(X'' USING utf8mb4),CONVERT(X'' USING utf8mb4)),
(304066003,40407,1,0,100,0.0,0,0,1,0,0,-1,-1,CONVERT(X'' USING utf8mb4),CONVERT(X'' USING utf8mb4)),
(304066004,17506,1,0,100,0.0,0,0,2,0,0,-1,-1,CONVERT(X'' USING utf8mb4),CONVERT(X'' USING utf8mb4)),
(304066005,10037,1,1,3.224,0.0,0,0,1,0,0,-1,-1,NULL,NULL),
(304066005,17554,1,1,13.267,0.0,0,0,2,0,0,-1,-1,NULL,NULL),
(304066005,17556,1,1,1.936,0.0,0,0,1,0,0,-1,-1,NULL,NULL),
(304066005,21961,1,1,22.105,0.0,0,0,2,0,0,-1,-1,NULL,NULL),
(304066005,22503,1,1,1.756,0.0,0,0,1,0,0,-1,-1,NULL,NULL),
(304066005,22522,1,1,22.669,0.0,0,0,2,0,0,-1,-1,NULL,NULL),
(304066005,35086,1,1,5.166,0.0,0,0,2,0,0,-1,-1,NULL,NULL),
(304066005,35089,1,1,5.249,0.0,0,0,2,0,0,-1,-1,NULL,NULL),
(304066005,40581,1,1,6.473,0.0,0,0,2,0,0,-1,-1,NULL,NULL),
(304066005,199900,1,1,18.855,0.0,0,0,1,0,0,-1,-1,NULL,NULL),
(304066005,88311,1,1,7.659,0.0,0,0,2,0,0,-1,-1,NULL,NULL),
(304066005,88312,1,1,7.249,0.0,0,0,2,0,0,-1,-1,NULL,NULL),
(304066005,88313,1,1,7.434,0.0,0,0,2,0,0,-1,-1,NULL,NULL),
(304066005,88314,1,1,8.697,0.0,0,0,2,0,0,-1,-1,NULL,NULL),
(304066005,88315,1,1,8.018,0.0,0,0,2,0,0,-1,-1,NULL,NULL),
(304066005,88316,1,1,8.575,0.0,0,0,2,0,0,-1,-1,NULL,NULL),
(304066005,88317,1,1,8.421,0.0,0,0,2,0,0,-1,-1,NULL,NULL),
(304066005,88318,1,1,18.234,0.0,0,0,2,0,0,-1,-1,NULL,NULL),
(304066006,10037,1,1,3.224,0.0,0,0,1,0,0,-1,-1,NULL,NULL),
(304066006,17554,1,1,13.267,0.0,0,0,2,0,0,-1,-1,NULL,NULL),
(304066006,17556,1,1,1.936,0.0,0,0,1,0,0,-1,-1,NULL,NULL),
(304066006,21961,1,1,22.105,0.0,0,0,2,0,0,-1,-1,NULL,NULL),
(304066006,22503,1,1,1.756,0.0,0,0,1,0,0,-1,-1,NULL,NULL),
(304066006,22522,1,1,22.669,0.0,0,0,2,0,0,-1,-1,NULL,NULL),
(304066006,35086,1,1,5.166,0.0,0,0,2,0,0,-1,-1,NULL,NULL),
(304066006,35089,1,1,5.249,0.0,0,0,2,0,0,-1,-1,NULL,NULL),
(304066006,40581,1,1,6.473,0.0,0,0,2,0,0,-1,-1,NULL,NULL),
(304066006,199901,1,1,18.855,0.0,0,0,1,0,0,-1,-1,NULL,NULL),
(304066006,88311,1,1,7.659,0.0,0,0,2,0,0,-1,-1,NULL,NULL),
(304066006,88312,1,1,7.249,0.0,0,0,2,0,0,-1,-1,NULL,NULL),
(304066006,88313,1,1,7.434,0.0,0,0,2,0,0,-1,-1,NULL,NULL),
(304066006,88314,1,1,8.697,0.0,0,0,2,0,0,-1,-1,NULL,NULL),
(304066006,88315,1,1,8.018,0.0,0,0,2,0,0,-1,-1,NULL,NULL),
(304066006,88316,1,1,8.575,0.0,0,0,2,0,0,-1,-1,NULL,NULL),
(304066006,88317,1,1,8.421,0.0,0,0,2,0,0,-1,-1,NULL,NULL),
(304066006,88318,1,1,18.234,0.0,0,0,2,0,0,-1,-1,NULL,NULL);
IF ROW_COUNT() <> 41 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS NPC lootdrop_entries insert count differs'; END IF;

-- loottable: 7 new rows
INSERT INTO `loottable` (`id`,`name`,`mincash`,`maxcash`,`avgcoin`,`done`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(304066000,CONVERT(X'4c4f43414c5f464f535f476f7264616b' USING utf8mb4),0,0,0,0,-1,-1,NULL,NULL),
(304066001,CONVERT(X'4c4f43414c5f464f535f536869656c64' USING utf8mb4),0,0,0,0,-1,-1,NULL,NULL),
(304066002,CONVERT(X'4c4f43414c5f464f535f506574726966696564536b756c6c' USING utf8mb4),0,0,0,0,-1,-1,NULL,NULL),
(304066003,CONVERT(X'4c4f43414c5f464f535f536b656c6574616c48616e64' USING utf8mb4),0,0,0,0,-1,-1,NULL,NULL),
(304066004,CONVERT(X'4c4f43414c5f464f535f4461726b626c61646553776f726473' USING utf8mb4),0,0,0,0,-1,-1,NULL,NULL),
(304066005,CONVERT(X'4c4f43414c5f464f535f4d657373616765427572796e6169' USING utf8mb4),80,8000,0,0,-1,-1,NULL,NULL),
(304066006,CONVERT(X'4c4f43414c5f464f535f4d6573736167654b75726e' USING utf8mb4),80,8000,0,0,-1,-1,NULL,NULL);
IF ROW_COUNT() <> 7 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS NPC loottable insert count differs'; END IF;

-- loottable_entries: 9 new rows
INSERT INTO `loottable_entries` (`loottable_id`,`lootdrop_id`,`multiplier`,`droplimit`,`mindrop`,`probability`) VALUES
(304066000,304066000,1,1,1,100),
(304066001,304066001,1,1,1,100),
(304066002,304066002,1,1,1,100),
(304066003,304066003,1,1,1,100),
(304066004,304066004,1,1,1,100),
(304066005,114795,1,1,0,100.0),
(304066005,304066005,1,2,0,100.0),
(304066006,114795,1,1,0,100.0),
(304066006,304066006,1,2,0,100.0);
IF ROW_COUNT() <> 9 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS NPC loottable_entries insert count differs'; END IF;

-- npc_spells: 3 new rows
INSERT INTO `npc_spells` (`id`,`name`,`parent_list`,`attack_proc`,`proc_chance`,`range_proc`,`rproc_chance`,`defensive_proc`,`dproc_chance`,`fail_recast`,`engaged_no_sp_recast_min`,`engaged_no_sp_recast_max`,`engaged_b_self_chance`,`engaged_b_other_chance`,`engaged_d_chance`,`pursue_no_sp_recast_min`,`pursue_no_sp_recast_max`,`pursue_d_chance`,`idle_no_sp_recast_min`,`idle_no_sp_recast_max`,`idle_b_chance`) VALUES
(304066000,CONVERT(X'4c4f43414c5f464f535f41756469656e63653a426f7373' USING utf8mb4),0,-1,0,-1,0,-1,0,2000,1000,1000,0,0,100,0,0,0,0,0,0),
(304066001,CONVERT(X'4c4f43414c5f464f535f4b6e6f776c656467653a476f7264616b' USING utf8mb4),0,-1,0,-1,0,-1,0,2000,1000,1000,0,0,100,0,0,0,0,0,0),
(304066002,CONVERT(X'4c4f43414c5f464f535f576f726c643a4c6f7374447261676f6e7374616c6b6572' USING utf8mb4),0,-1,0,-1,0,-1,0,2000,1000,1000,0,0,100,0,0,0,0,0,0);
IF ROW_COUNT() <> 3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS NPC npc_spells insert count differs'; END IF;

-- npc_spells_entries: 3 new rows
INSERT INTO `npc_spells_entries` (`id`,`npc_spells_id`,`spellid`,`type`,`minlevel`,`maxlevel`,`manacost`,`recast_delay`,`priority`,`resist_adjust`,`min_hp`,`max_hp`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(304066000,304066000,17608,1,1,255,0,30,1,NULL,0,60,-1,-1,NULL,NULL),
(304066001,304066001,13350,2048,1,255,0,35,1,NULL,0,100,-1,-1,NULL,NULL),
(304066002,304066002,17622,1,1,255,0,20,1,NULL,0,100,-1,-1,NULL,NULL);
IF ROW_COUNT() <> 3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS NPC npc_spells_entries insert count differs'; END IF;

-- npc_types: 22 new rows
INSERT INTO `npc_types` (`id`,`name`,`lastname`,`level`,`race`,`class`,`bodytype`,`hp`,`mana`,`gender`,`texture`,`helmtexture`,`herosforgemodel`,`size`,`hp_regen_rate`,`hp_regen_per_second`,`mana_regen_rate`,`loottable_id`,`merchant_id`,`greed`,`alt_currency_id`,`npc_spells_id`,`npc_spells_effects_id`,`npc_faction_id`,`adventure_template_id`,`trap_template`,`mindmg`,`maxdmg`,`attack_count`,`npcspecialattks`,`special_abilities`,`aggroradius`,`assistradius`,`face`,`luclin_hairstyle`,`luclin_haircolor`,`luclin_eyecolor`,`luclin_eyecolor2`,`luclin_beardcolor`,`luclin_beard`,`drakkin_heritage`,`drakkin_tattoo`,`drakkin_details`,`armortint_id`,`armortint_red`,`armortint_green`,`armortint_blue`,`d_melee_texture1`,`d_melee_texture2`,`ammo_idfile`,`prim_melee_type`,`sec_melee_type`,`ranged_type`,`runspeed`,`MR`,`CR`,`DR`,`FR`,`PR`,`Corrup`,`PhR`,`see_invis`,`see_invis_undead`,`qglobal`,`AC`,`npc_aggro`,`spawn_limit`,`attack_speed`,`attack_delay`,`findable`,`STR`,`STA`,`DEX`,`AGI`,`_INT`,`WIS`,`CHA`,`see_hide`,`see_improved_hide`,`trackable`,`isbot`,`exclude`,`ATK`,`Accuracy`,`Avoidance`,`slow_mitigation`,`version`,`maxlevel`,`scalerate`,`private_corpse`,`unique_spawn_by_name`,`underwater`,`isquest`,`emoteid`,`spellscale`,`healscale`,`no_target_hotkey`,`raid_target`,`armtexture`,`bracertexture`,`handtexture`,`legtexture`,`feettexture`,`light`,`walkspeed`,`peqid`,`unique_`,`fixed`,`ignore_despawn`,`show_name`,`untargetable`,`charm_ac`,`charm_min_dmg`,`charm_max_dmg`,`charm_attack_delay`,`charm_accuracy_rating`,`charm_avoidance_rating`,`charm_atk`,`skip_global_loot`,`rare_spawn`,`stuck_behavior`,`model`,`flymode`,`always_aggro`,`exp_mod`,`heroic_strikethrough`,`faction_amount`,`keeps_sold_items`,`is_parcel_merchant`,`multiquest_enabled`,`npc_tint_id`) VALUES
(452900,CONVERT(X'5468657373696c6160735f52756e656d6173746572' USING utf8mb4),CONVERT(X'' USING utf8mb4),82,128,10,1,190000,0,1,1,0,0,6.0,0,0,0,0,0,0,0,0,0,304066000,0,0,750,1800,2,CONVERT(X'' USING utf8mb4),CONVERT(X'312c315e31362c315e32312c31' USING utf8mb4),50,20,5,255,255,0,0,255,255,0,0,0,0,0,0,0,10707,216,CONVERT(X'49543130' USING utf8mb4),28,28,7,1.25,100,80,80,80,80,80,80,0,0,0,950,0,0,0.0,30,0,200,200,200,200,200,200,150,0,0,1,0,1,400,0,0,0,0,0,100,0,0,0,1,0,100.0,100.0,0,0,0,0,0,0,0,0,0.5,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,100,0,0,0,0,0,0),
(452901,CONVERT(X'5468657373696c6160735f426c6164656d6173746572' USING utf8mb4),CONVERT(X'' USING utf8mb4),82,128,1,1,190000,0,0,3,0,0,6.0,0,0,0,0,0,0,0,0,0,304066000,0,0,800,1900,2,CONVERT(X'' USING utf8mb4),CONVERT(X'312c315e322c312c31302c31323030302c3336303030305e31362c315e32312c31' USING utf8mb4),50,20,8,255,255,0,0,255,255,0,0,0,0,0,0,0,11314,0,CONVERT(X'49543130' USING utf8mb4),28,28,7,1.25,100,80,80,80,80,80,80,0,0,0,1000,0,0,0.0,30,0,200,200,200,200,200,200,150,0,0,1,0,1,450,0,0,0,0,0,100,0,0,0,1,0,100.0,100.0,0,0,0,0,0,0,0,0,0.5,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,100,0,0,0,0,0,0),
(452902,CONVERT(X'5468657373696c615f7468655f4461726b' USING utf8mb4),CONVERT(X'' USING utf8mb4),84,128,1,1,410000,15000,0,11,0,0,6.0,0,0,0,0,0,0,0,304066000,0,304066000,0,0,1000,2300,2,CONVERT(X'' USING utf8mb4),CONVERT(X'332c312c31305e352c312c32305e31352c315e32312c31' USING utf8mb4),50,20,5,255,255,0,0,255,255,0,0,0,0,0,0,0,10201,10695,CONVERT(X'49543130' USING utf8mb4),28,28,7,1.25,100,80,80,80,80,80,80,0,0,0,1300,0,0,0.0,30,0,200,200,200,200,200,200,150,0,0,1,0,1,500,0,0,0,0,0,100,0,0,0,1,0,100.0,100.0,0,0,0,0,0,0,0,0,0.5,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,100,0,0,0,0,0,0),
(452903,CONVERT(X'616e5f696d70657269616c5f656767' USING utf8mb4),CONVERT(X'' USING utf8mb4),80,445,1,5,10000,0,2,2,0,0,4.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,CONVERT(X'' USING utf8mb4),CONVERT(X'33392c31' USING utf8mb4),0,0,0,0,0,0,0,0,255,0,0,0,0,0,0,0,0,0,CONVERT(X'49543130' USING utf8mb4),28,28,7,0.0,100,80,80,80,80,80,80,0,0,0,100,0,0,0.0,30,0,200,200,200,200,200,200,150,0,0,1,0,1,0,0,0,0,0,0,100,0,0,0,1,0,100.0,100.0,0,0,0,0,0,0,0,0,0.0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,100,0,0,0,0,0,0),
(452904,CONVERT(X'615f726561725f67756172645f74726f6f706572' USING utf8mb4),CONVERT(X'' USING utf8mb4),82,128,1,1,100000,0,0,3,0,0,6.0,0,0,0,0,0,0,0,0,0,304066000,0,0,650,1550,2,CONVERT(X'' USING utf8mb4),CONVERT(X'32312c315e32372c315e35322c31' USING utf8mb4),50,20,7,255,255,0,0,255,255,0,0,0,0,0,0,0,108,10665,CONVERT(X'49543130' USING utf8mb4),28,28,7,1.25,100,80,80,80,80,80,80,1,0,0,900,0,0,0.0,30,0,200,200,200,200,200,200,150,0,0,1,0,1,350,0,0,0,0,0,100,0,0,0,1,0,100.0,100.0,0,0,0,0,0,0,0,0,0.5,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,100,0,0,0,0,0,0),
(452905,CONVERT(X'615f726561725f67756172645f6a75676765726e617574' USING utf8mb4),CONVERT(X'' USING utf8mb4),83,160,1,5,200000,0,2,1,1,0,8.0,0,0,0,0,0,0,0,0,0,304066000,0,0,900,2100,2,CONVERT(X'' USING utf8mb4),CONVERT(X'32312c315e32372c315e35322c31' USING utf8mb4),50,20,0,0,0,0,0,0,255,0,0,0,0,0,0,0,0,0,CONVERT(X'49543130' USING utf8mb4),28,28,7,1.25,100,80,80,80,80,80,80,1,0,0,1200,0,0,0.0,30,0,200,200,200,200,200,200,150,0,0,1,0,1,450,0,0,0,0,0,100,0,0,0,1,0,100.0,100.0,0,0,0,0,0,0,0,0,0.5,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,100,0,0,0,0,0,0),
(452906,CONVERT(X'615f726561725f67756172645f7363616c656272616e64' USING utf8mb4),CONVERT(X'' USING utf8mb4),82,128,10,1,130000,0,0,1,0,0,6.0,0,0,0,0,0,0,0,0,0,304066000,0,0,700,1700,2,CONVERT(X'' USING utf8mb4),CONVERT(X'32312c315e32372c315e35322c31' USING utf8mb4),50,20,3,255,255,0,0,255,255,0,0,0,0,0,0,0,11311,10781,CONVERT(X'49543130' USING utf8mb4),28,28,7,1.25,100,80,80,80,80,80,80,1,0,0,950,0,0,0.0,30,0,200,200,200,200,200,200,150,0,0,1,0,1,400,0,0,0,0,0,100,0,0,0,1,0,100.0,100.0,0,0,0,0,0,0,0,0,0.5,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,100,0,0,0,0,0,0),
(452907,CONVERT(X'47756172645f4361707461696e5f5465737a6b' USING utf8mb4),CONVERT(X'' USING utf8mb4),84,128,1,1,260000,0,0,12,0,0,6.0,0,0,0,0,0,0,0,0,0,304066000,0,0,1000,2300,2,CONVERT(X'' USING utf8mb4),CONVERT(X'32312c315e32372c315e35322c31' USING utf8mb4),50,20,8,255,255,0,0,255,255,0,0,0,0,0,0,0,10852,0,CONVERT(X'49543130' USING utf8mb4),28,28,7,1.25,100,80,80,80,80,80,80,1,0,0,1300,0,0,0.0,30,0,200,200,200,200,200,200,150,0,0,1,0,1,500,0,0,0,0,0,100,0,0,0,1,0,100.0,100.0,0,0,0,0,0,0,0,0,0.5,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,100,0,0,0,0,0,0),
(452908,CONVERT(X'615f636f72727570745f7363686f6c6172' USING utf8mb4),CONVERT(X'' USING utf8mb4),82,128,11,1,120000,0,0,11,0,0,6.0,0,0,0,0,0,0,0,0,0,304066000,0,0,550,1400,2,CONVERT(X'' USING utf8mb4),CONVERT(X'31362c315e32312c31' USING utf8mb4),50,20,7,255,255,0,0,255,255,0,0,0,0,0,0,0,10201,10695,CONVERT(X'49543130' USING utf8mb4),28,28,7,1.25,100,80,80,80,80,80,80,0,0,0,850,0,0,0.0,30,0,200,200,200,200,200,200,150,0,0,1,0,1,300,0,0,0,0,0,100,0,0,0,1,0,100.0,100.0,0,0,0,0,0,0,0,0,0.5,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,100,0,0,0,0,0,0),
(452909,CONVERT(X'615f436f727275707465645f42656775696c6572' USING utf8mb4),CONVERT(X'' USING utf8mb4),82,128,14,1,150000,0,0,1,0,0,6.0,0,0,0,0,0,0,0,0,0,304066000,0,0,650,1600,2,CONVERT(X'' USING utf8mb4),CONVERT(X'31362c315e32312c31' USING utf8mb4),50,20,4,255,255,0,0,255,255,0,0,0,0,0,0,0,11319,216,CONVERT(X'49543130' USING utf8mb4),28,28,7,1.25,100,80,80,80,80,80,80,0,0,0,950,0,0,0.0,30,0,200,200,200,200,200,200,150,0,0,1,0,1,350,0,0,0,0,0,100,0,0,0,1,0,100.0,100.0,0,0,0,0,0,0,0,0,0.5,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,100,0,0,0,0,0,0),
(452910,CONVERT(X'436f65726365725f476f7264616b' USING utf8mb4),CONVERT(X'' USING utf8mb4),84,128,14,1,200000,15000,1,15,0,0,6.0,0,0,0,304066000,0,0,0,304066001,0,304066000,0,0,800,1900,2,CONVERT(X'' USING utf8mb4),CONVERT(X'32312c31' USING utf8mb4),50,20,3,255,255,0,0,255,255,0,0,0,0,0,0,0,10504,0,CONVERT(X'49543130' USING utf8mb4),28,28,7,1.25,100,80,80,80,80,80,80,0,0,0,1200,0,0,0.0,30,0,200,200,200,200,200,200,150,0,0,1,0,1,450,0,0,0,0,0,100,0,0,0,1,0,100.0,100.0,0,0,0,0,0,0,0,0,0.5,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,100,0,0,0,0,0,0),
(452911,CONVERT(X'615f647261676f6e62616e655f74726f6f706572' USING utf8mb4),CONVERT(X'' USING utf8mb4),83,128,1,1,200000,0,0,2,0,0,6.0,0,0,0,0,0,0,0,0,0,304066000,0,0,900,2100,2,CONVERT(X'' USING utf8mb4),CONVERT(X'312c315e322c312c31302c31323030302c3336303030305e352c312c32305e32312c31' USING utf8mb4),50,20,1,255,255,0,0,255,255,0,0,0,0,0,0,0,82,11315,CONVERT(X'49543130' USING utf8mb4),28,28,7,1.25,100,80,80,80,80,80,80,0,0,0,1100,0,0,0.0,30,0,200,200,200,200,200,200,150,0,0,1,0,1,450,0,0,0,0,0,100,0,0,0,1,0,100.0,100.0,0,0,0,0,0,0,0,0,0.5,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,100,0,0,0,0,0,0),
(452912,CONVERT(X'4e616c61737a7479615f566f78656e616b' USING utf8mb4),CONVERT(X'' USING utf8mb4),84,128,1,1,345000,0,0,16,0,0,6.0,0,0,0,0,0,0,0,0,0,304066000,0,0,1100,2400,2,CONVERT(X'' USING utf8mb4),CONVERT(X'322c312c31302c31323030302c3336303030305e352c312c32305e31352c315e31362c315e32312c315e32372c315e35322c31' USING utf8mb4),50,20,7,255,255,0,0,255,255,0,0,0,0,0,0,0,10528,10646,CONVERT(X'49543130' USING utf8mb4),28,28,7,1.25,100,80,80,80,80,80,80,1,0,0,1350,0,0,0.0,30,0,200,200,200,200,200,200,150,0,0,1,0,1,500,0,0,0,0,0,100,0,0,0,1,0,100.0,100.0,0,0,0,0,0,0,0,0,0.5,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,100,0,0,0,0,0,0),
(452913,CONVERT(X'5368656c65737a6b615f566f78656e616b' USING utf8mb4),CONVERT(X'' USING utf8mb4),84,128,1,1,350000,0,1,1,0,0,6.0,0,0,0,0,0,0,0,0,0,304066000,0,0,1100,2400,2,CONVERT(X'' USING utf8mb4),CONVERT(X'322c312c31302c31323030302c3336303030305e352c312c32305e31352c315e31362c315e32312c315e32372c315e35322c31' USING utf8mb4),50,20,6,255,255,0,0,255,255,0,0,0,0,0,0,0,11311,10781,CONVERT(X'49543130' USING utf8mb4),28,28,7,1.25,100,80,80,80,80,80,80,1,0,0,1350,0,0,0.0,30,0,200,200,200,200,200,200,150,0,0,1,0,1,500,0,0,0,0,0,100,0,0,0,1,0,100.0,100.0,0,0,0,0,0,0,0,0,0.5,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,100,0,0,0,0,0,0),
(452914,CONVERT(X'5a6f66666c65725f7468655f4472616b65736c61796572' USING utf8mb4),CONVERT(X'' USING utf8mb4),84,128,1,1,425000,0,0,3,0,0,6.0,0,0,0,0,0,0,0,0,0,304066000,0,0,1200,2700,2,CONVERT(X'' USING utf8mb4),CONVERT(X'322c312c31302c31323030302c3336303030305e352c312c32305e31352c315e31362c315e32312c315e32372c315e35322c31' USING utf8mb4),50,20,7,255,255,0,0,255,255,0,0,0,0,0,0,0,108,10665,CONVERT(X'49543130' USING utf8mb4),28,28,7,1.25,100,80,80,80,80,80,80,1,0,0,1450,0,0,0.0,30,0,200,200,200,200,200,200,150,0,0,1,0,1,550,0,0,0,0,0,100,0,0,0,1,0,100.0,100.0,0,0,0,0,0,0,0,0,0.5,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,100,0,0,0,0,0,0),
(452915,CONVERT(X'4a6f72616c75735f7468655f52656c656e746c657373' USING utf8mb4),CONVERT(X'' USING utf8mb4),85,128,1,1,506000,0,0,7,0,0,7.0,0,0,0,0,0,0,0,0,0,304066000,0,0,1400,3100,2,CONVERT(X'' USING utf8mb4),CONVERT(X'322c312c31302c31323030302c3336303030305e342c312c355e31352c315e31362c315e32312c315e32372c315e35322c31' USING utf8mb4),50,20,5,255,255,0,0,255,255,0,0,0,0,0,0,0,300,0,CONVERT(X'49543130' USING utf8mb4),28,28,7,1.25,100,80,80,80,80,80,80,1,0,0,1500,0,0,0.0,30,0,200,200,200,200,200,200,150,0,0,1,0,1,600,0,0,0,0,0,100,0,0,0,1,0,100.0,100.0,0,0,0,0,0,0,0,0,0.5,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,100,0,0,0,0,0,0),
(452916,CONVERT(X'536869656c645f477561726469616e5f4e6569736b61' USING utf8mb4),CONVERT(X'' USING utf8mb4),85,160,1,5,430000,0,2,1,1,0,8.0,0,0,0,304066001,0,0,0,0,0,304066000,0,0,1250,2800,2,CONVERT(X'' USING utf8mb4),CONVERT(X'332c312c31305e31352c315e31362c315e32312c31' USING utf8mb4),50,20,0,0,0,0,0,0,255,0,0,0,0,0,0,0,0,0,CONVERT(X'49543130' USING utf8mb4),28,28,7,1.25,100,80,80,350,80,80,80,0,0,0,1500,0,0,0.0,30,0,200,200,200,200,200,200,150,0,0,1,0,1,550,0,0,0,0,0,100,0,0,0,1,0,100.0,100.0,0,0,0,0,0,0,0,0,0.5,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,100,0,0,0,0,0,0),
(452917,CONVERT(X'436f6d6d616e6465725f4b6f7468' USING utf8mb4),CONVERT(X'' USING utf8mb4),80,161,1,3,170000,0,2,0,0,0,6.0,0,0,0,304066002,0,0,0,0,0,304066001,0,0,550,1500,2,CONVERT(X'' USING utf8mb4),CONVERT(X'33372c3130' USING utf8mb4),50,20,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,CONVERT(X'49543130' USING utf8mb4),28,28,7,1.25,40,40,40,40,40,80,80,0,0,0,1000,0,0,0.0,30,0,200,200,200,200,200,200,150,0,0,1,0,1,350,0,0,0,0,0,100,0,0,0,1,0,100.0,100.0,0,0,0,0,0,0,0,0,0.5,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,100,0,0,0,0,0,0),
(452918,CONVERT(X'43616c6574686f73' USING utf8mb4),CONVERT(X'546865204c6976696e6720466c616d65' USING utf8mb4),90,75,1,24,60000,0,2,1,133,0,6.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,CONVERT(X'' USING utf8mb4),CONVERT(X'31392c315e32302c315e32342c315e32352c315e33392c31' USING utf8mb4),0,0,0,19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,CONVERT(X'49543130' USING utf8mb4),28,28,7,0.0,100,80,80,80,80,80,80,0,0,0,500,0,0,0.0,30,0,200,200,200,200,200,200,150,0,0,1,0,1,0,0,0,0,0,0,100,0,0,0,1,0,100.0,100.0,0,0,0,0,0,0,0,0,0.0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,100,0,0,0,0,0,0),
(452919,CONVERT(X'546861726f666660735f426f6e6573' USING utf8mb4),CONVERT(X'' USING utf8mb4),80,383,62,5,6000,0,2,0,0,0,3.0,0,0,0,304066003,0,0,0,0,0,0,0,0,0,0,1,CONVERT(X'' USING utf8mb4),CONVERT(X'33392c31' USING utf8mb4),0,0,0,0,0,0,0,0,255,0,0,0,0,0,0,0,0,0,CONVERT(X'49543130' USING utf8mb4),28,28,7,0.0,100,80,80,80,80,80,80,0,0,0,100,0,0,0.0,30,0,200,200,200,200,200,200,150,0,0,1,0,1,0,0,0,0,0,0,100,0,0,0,1,0,100.0,100.0,0,0,0,0,0,0,0,0,0.0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,100,0,0,0,0,0,0),
(452920,CONVERT(X'615f536562696c697369616e5f647261676f6e7374616c6b6572' USING utf8mb4),CONVERT(X'' USING utf8mb4),85,128,1,1,225000,15000,0,3,0,0,6.0,0,0,0,304066004,0,0,0,304066002,0,304066000,0,0,800,1800,2,CONVERT(X'' USING utf8mb4),CONVERT(X'31362c315e32312c31' USING utf8mb4),50,20,4,2,1,0,0,255,255,0,0,0,0,0,0,0,11315,10790,CONVERT(X'49543130' USING utf8mb4),28,28,7,1.25,100,80,80,80,80,80,80,0,0,0,1100,0,0,0.0,30,0,200,200,200,200,200,200,150,0,0,1,0,1,400,0,0,0,0,0,100,0,0,0,1,0,100.0,100.0,0,0,0,0,0,0,0,0,0.5,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,100,0,0,0,0,0,0),
(452921,CONVERT(X'616e5f496d70657269616c5f73656e747279' USING utf8mb4),CONVERT(X'' USING utf8mb4),80,128,1,1,85000,0,1,3,0,0,6.0,0,0,0,0,0,0,0,0,0,304066000,0,0,500,1300,2,CONVERT(X'' USING utf8mb4),CONVERT(X'32312c31' USING utf8mb4),50,20,8,255,255,0,0,255,255,0,0,0,0,0,0,0,11316,0,CONVERT(X'49543130' USING utf8mb4),28,28,7,1.25,100,80,80,80,80,80,80,0,0,0,800,0,0,0.0,30,0,200,200,200,200,200,200,150,0,0,1,0,1,300,0,0,0,0,0,100,0,0,0,1,0,100.0,100.0,0,0,0,0,0,0,0,0,0.5,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,100,0,0,0,0,0,0);
IF ROW_COUNT() <> 22 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS NPC npc_types insert count differs'; END IF;

-- grid: 1 new rows
INSERT INTO `grid` (`id`,`zoneid`,`type`,`type2`) VALUES
(304066000,78,0,0);
IF ROW_COUNT() <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS NPC grid insert count differs'; END IF;

-- grid_entries: 4 new rows
INSERT INTO `grid_entries` (`gridid`,`zoneid`,`number`,`x`,`y`,`z`,`heading`,`pause`,`centerpoint`) VALUES
(304066000,78,1,121.0,-1869.0,-45.59153856844955,0,60,0),
(304066000,78,2,145.0,-1869.0,-49.32393786792415,0,60,0),
(304066000,78,3,145.0,-1845.0,-49.32233465798848,0,60,0),
(304066000,78,4,121.0,-1845.0,-45.58993535851386,0,60,0);
IF ROW_COUNT() <> 4 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS NPC grid_entries insert count differs'; END IF;

-- object: 1 new rows
INSERT INTO `object` (`id`,`zoneid`,`version`,`xpos`,`ypos`,`zpos`,`heading`,`itemid`,`charges`,`objectname`,`type`,`icon`,`size_percentage`,`unknown24`,`unknown60`,`unknown64`,`unknown68`,`unknown72`,`unknown76`,`unknown84`,`size`,`solid_type`,`incline`,`tilt_x`,`tilt_y`,`display_name`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(304066000,454,2,678.625,2.25,-17.874006271362305,0,0,0,CONVERT(X'495431313138335f4143544f52444546' USING utf8mb4),255,0,0.0,0,0,0,0,0,0,0,100.0,0,0,0.0,0.0,CONVERT(X'' USING utf8mb4),-1,-1,NULL,NULL);
IF ROW_COUNT() <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS NPC object insert count differs'; END IF;

-- spawngroup: 72 new rows
INSERT INTO `spawngroup` (`id`,`name`,`spawn_limit`,`dist`,`max_x`,`min_x`,`max_y`,`min_y`,`delay`,`mindelay`,`despawn`,`despawn_timer`,`wp_spawns`) VALUES
(304066000,CONVERT(X'4c4f43414c5f464f535f41756469656e63655f72756e656d61737465725f31' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066001,CONVERT(X'4c4f43414c5f464f535f41756469656e63655f72756e656d61737465725f32' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066002,CONVERT(X'4c4f43414c5f464f535f41756469656e63655f626c6164656d61737465725f31' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066003,CONVERT(X'4c4f43414c5f464f535f41756469656e63655f626c6164656d61737465725f32' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066004,CONVERT(X'4c4f43414c5f464f535f42726f6f645f4567673031' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066005,CONVERT(X'4c4f43414c5f464f535f42726f6f645f4567673032' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066006,CONVERT(X'4c4f43414c5f464f535f42726f6f645f4567673033' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066007,CONVERT(X'4c4f43414c5f464f535f42726f6f645f4567673034' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066008,CONVERT(X'4c4f43414c5f464f535f42726f6f645f4567673035' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066009,CONVERT(X'4c4f43414c5f464f535f42726f6f645f4567673036' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066010,CONVERT(X'4c4f43414c5f464f535f42726f6f645f4567673037' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066011,CONVERT(X'4c4f43414c5f464f535f42726f6f645f4567673038' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066012,CONVERT(X'4c4f43414c5f464f535f42726f6f645f4567673039' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066013,CONVERT(X'4c4f43414c5f464f535f42726f6f645f4567673130' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066014,CONVERT(X'4c4f43414c5f464f535f42726f6f645f4567673131' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066015,CONVERT(X'4c4f43414c5f464f535f42726f6f645f4567673132' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066016,CONVERT(X'4c4f43414c5f464f535f42726f6f645f4567673133' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066017,CONVERT(X'4c4f43414c5f464f535f42726f6f645f4567673134' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066018,CONVERT(X'4c4f43414c5f464f535f42726f6f645f4567673135' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066019,CONVERT(X'4c4f43414c5f464f535f42726f6f645f4567673136' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066020,CONVERT(X'4c4f43414c5f464f535f42726f6f645f4567673137' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066021,CONVERT(X'4c4f43414c5f464f535f42726f6f645f4567673138' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066022,CONVERT(X'4c4f43414c5f464f535f42726f6f645f4567673139' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066023,CONVERT(X'4c4f43414c5f464f535f42726f6f645f4567673230' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066024,CONVERT(X'4c4f43414c5f464f535f42726f6f645f4567673231' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066025,CONVERT(X'4c4f43414c5f464f535f4b6e6f776c656467655f5363686f6c617231' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066026,CONVERT(X'4c4f43414c5f464f535f4b6e6f776c656467655f5363686f6c617232' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066027,CONVERT(X'4c4f43414c5f464f535f4b6e6f776c656467655f5363686f6c617233' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066028,CONVERT(X'4c4f43414c5f464f535f4b6e6f776c656467655f5363686f6c617234' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066029,CONVERT(X'4c4f43414c5f464f535f4b6e6f776c656467655f5363686f6c617235' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066030,CONVERT(X'4c4f43414c5f464f535f4b6e6f776c656467655f5363686f6c617236' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066031,CONVERT(X'4c4f43414c5f464f535f5068616c616e785f536f75746831' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066032,CONVERT(X'4c4f43414c5f464f535f5068616c616e785f536f75746832' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066033,CONVERT(X'4c4f43414c5f464f535f5068616c616e785f536f75746833' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066034,CONVERT(X'4c4f43414c5f464f535f5068616c616e785f536f75746834' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066035,CONVERT(X'4c4f43414c5f464f535f5068616c616e785f536f75746835' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066036,CONVERT(X'4c4f43414c5f464f535f5068616c616e785f536f75746836' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066037,CONVERT(X'4c4f43414c5f464f535f5068616c616e785f536f75746837' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066038,CONVERT(X'4c4f43414c5f464f535f5068616c616e785f536f75746838' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066039,CONVERT(X'4c4f43414c5f464f535f5068616c616e785f4e6f72746831' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066040,CONVERT(X'4c4f43414c5f464f535f5068616c616e785f4e6f72746832' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066041,CONVERT(X'4c4f43414c5f464f535f5068616c616e785f4e6f72746833' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066042,CONVERT(X'4c4f43414c5f464f535f5068616c616e785f4e6f72746834' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066043,CONVERT(X'4c4f43414c5f464f535f5068616c616e785f4e6f72746835' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066044,CONVERT(X'4c4f43414c5f464f535f5068616c616e785f4e6f72746836' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066045,CONVERT(X'4c4f43414c5f464f535f5068616c616e785f4e6f72746837' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066046,CONVERT(X'4c4f43414c5f464f535f536869656c645f4e616c6173' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066047,CONVERT(X'4c4f43414c5f464f535f536869656c645f5368656c6573' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066048,CONVERT(X'4c4f43414c5f464f535f536869656c645f5a6f66666c6572' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066049,CONVERT(X'4c4f43414c5f464f535f536869656c645f4a6f72616c7573' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066050,CONVERT(X'4c4f43414c5f464f535f41756469656e63655f4261636b67726f756e6431' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066051,CONVERT(X'4c4f43414c5f464f535f41756469656e63655f4261636b67726f756e6432' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066052,CONVERT(X'4c4f43414c5f464f535f41756469656e63655f4261636b67726f756e6433' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066053,CONVERT(X'4c4f43414c5f464f535f41756469656e63655f4261636b67726f756e6434' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066054,CONVERT(X'4c4f43414c5f464f535f42726f6f645f4261636b67726f756e6431' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066055,CONVERT(X'4c4f43414c5f464f535f42726f6f645f4261636b67726f756e6432' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066056,CONVERT(X'4c4f43414c5f464f535f42726f6f645f4261636b67726f756e6433' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066057,CONVERT(X'4c4f43414c5f464f535f42726f6f645f4261636b67726f756e6434' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066058,CONVERT(X'4c4f43414c5f464f535f4b6e6f776c656467655f4261636b67726f756e6431' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066059,CONVERT(X'4c4f43414c5f464f535f4b6e6f776c656467655f4261636b67726f756e6432' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066060,CONVERT(X'4c4f43414c5f464f535f5068616c616e785f4261636b67726f756e6431' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066061,CONVERT(X'4c4f43414c5f464f535f5068616c616e785f4261636b67726f756e6432' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066062,CONVERT(X'4c4f43414c5f464f535f5068616c616e785f4261636b67726f756e6433' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066063,CONVERT(X'4c4f43414c5f464f535f5068616c616e785f4261636b67726f756e6434' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066064,CONVERT(X'4c4f43414c5f464f535f536869656c645f4261636b67726f756e6431' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066065,CONVERT(X'4c4f43414c5f464f535f536869656c645f4261636b67726f756e6432' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066066,CONVERT(X'4c4f43414c5f464f535f536869656c645f4261636b67726f756e6433' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066067,CONVERT(X'4c4f43414c5f464f535f536869656c645f4261636b67726f756e6434' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066068,CONVERT(X'4c4f43414c5f464f535f576f726c645f4b6f7468' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066069,CONVERT(X'4c4f43414c5f464f535f576f726c645f546861726f6666426f6e6573' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066070,CONVERT(X'4c4f43414c5f464f535f576f726c645f426f6e6573477561726431' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0),
(304066071,CONVERT(X'4c4f43414c5f464f535f576f726c645f426f6e6573477561726432' USING utf8mb4),1,0.0,0.0,0.0,0.0,0.0,45000,15000,0,100,0);
IF ROW_COUNT() <> 72 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS NPC spawngroup insert count differs'; END IF;

-- spawnentry: 72 new rows
INSERT INTO `spawnentry` (`spawngroupID`,`npcID`,`chance`,`condition_value_filter`,`min_time`,`max_time`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(304066000,452900,100,1,0,0,-1,-1,NULL,NULL),
(304066001,452900,100,1,0,0,-1,-1,NULL,NULL),
(304066002,452901,100,1,0,0,-1,-1,NULL,NULL),
(304066003,452901,100,1,0,0,-1,-1,NULL,NULL),
(304066004,452903,100,1,0,0,-1,-1,NULL,NULL),
(304066005,452903,100,1,0,0,-1,-1,NULL,NULL),
(304066006,452903,100,1,0,0,-1,-1,NULL,NULL),
(304066007,452903,100,1,0,0,-1,-1,NULL,NULL),
(304066008,452903,100,1,0,0,-1,-1,NULL,NULL),
(304066009,452903,100,1,0,0,-1,-1,NULL,NULL),
(304066010,452903,100,1,0,0,-1,-1,NULL,NULL),
(304066011,452903,100,1,0,0,-1,-1,NULL,NULL),
(304066012,452903,100,1,0,0,-1,-1,NULL,NULL),
(304066013,452903,100,1,0,0,-1,-1,NULL,NULL),
(304066014,452903,100,1,0,0,-1,-1,NULL,NULL),
(304066015,452903,100,1,0,0,-1,-1,NULL,NULL),
(304066016,452903,100,1,0,0,-1,-1,NULL,NULL),
(304066017,452903,100,1,0,0,-1,-1,NULL,NULL),
(304066018,452903,100,1,0,0,-1,-1,NULL,NULL),
(304066019,452903,100,1,0,0,-1,-1,NULL,NULL),
(304066020,452903,100,1,0,0,-1,-1,NULL,NULL),
(304066021,452903,100,1,0,0,-1,-1,NULL,NULL),
(304066022,452903,100,1,0,0,-1,-1,NULL,NULL),
(304066023,452903,100,1,0,0,-1,-1,NULL,NULL),
(304066024,452903,100,1,0,0,-1,-1,NULL,NULL),
(304066025,452908,100,1,0,0,-1,-1,NULL,NULL),
(304066026,452908,100,1,0,0,-1,-1,NULL,NULL),
(304066027,452908,100,1,0,0,-1,-1,NULL,NULL),
(304066028,452908,100,1,0,0,-1,-1,NULL,NULL),
(304066029,452908,100,1,0,0,-1,-1,NULL,NULL),
(304066030,452908,100,1,0,0,-1,-1,NULL,NULL),
(304066031,452911,100,1,0,0,-1,-1,NULL,NULL),
(304066032,452911,100,1,0,0,-1,-1,NULL,NULL),
(304066033,452911,100,1,0,0,-1,-1,NULL,NULL),
(304066034,452911,100,1,0,0,-1,-1,NULL,NULL),
(304066035,452911,100,1,0,0,-1,-1,NULL,NULL),
(304066036,452911,100,1,0,0,-1,-1,NULL,NULL),
(304066037,452911,100,1,0,0,-1,-1,NULL,NULL),
(304066038,452911,100,1,0,0,-1,-1,NULL,NULL),
(304066039,452911,100,1,0,0,-1,-1,NULL,NULL),
(304066040,452911,100,1,0,0,-1,-1,NULL,NULL),
(304066041,452911,100,1,0,0,-1,-1,NULL,NULL),
(304066042,452911,100,1,0,0,-1,-1,NULL,NULL),
(304066043,452911,100,1,0,0,-1,-1,NULL,NULL),
(304066044,452911,100,1,0,0,-1,-1,NULL,NULL),
(304066045,452911,100,1,0,0,-1,-1,NULL,NULL),
(304066046,452912,100,1,0,0,-1,-1,NULL,NULL),
(304066047,452913,100,1,0,0,-1,-1,NULL,NULL),
(304066048,452914,100,1,0,0,-1,-1,NULL,NULL),
(304066049,452915,100,1,0,0,-1,-1,NULL,NULL),
(304066050,452921,100,1,0,0,-1,-1,NULL,NULL),
(304066051,452921,100,1,0,0,-1,-1,NULL,NULL),
(304066052,452921,100,1,0,0,-1,-1,NULL,NULL),
(304066053,452921,100,1,0,0,-1,-1,NULL,NULL),
(304066054,452921,100,1,0,0,-1,-1,NULL,NULL),
(304066055,452921,100,1,0,0,-1,-1,NULL,NULL),
(304066056,452921,100,1,0,0,-1,-1,NULL,NULL),
(304066057,452921,100,1,0,0,-1,-1,NULL,NULL),
(304066058,452921,100,1,0,0,-1,-1,NULL,NULL),
(304066059,452921,100,1,0,0,-1,-1,NULL,NULL),
(304066060,452921,100,1,0,0,-1,-1,NULL,NULL),
(304066061,452921,100,1,0,0,-1,-1,NULL,NULL),
(304066062,452921,100,1,0,0,-1,-1,NULL,NULL),
(304066063,452921,100,1,0,0,-1,-1,NULL,NULL),
(304066064,452921,100,1,0,0,-1,-1,NULL,NULL),
(304066065,452921,100,1,0,0,-1,-1,NULL,NULL),
(304066066,452921,100,1,0,0,-1,-1,NULL,NULL),
(304066067,452921,100,1,0,0,-1,-1,NULL,NULL),
(304066068,452917,100,1,0,0,-1,-1,NULL,NULL),
(304066069,452919,100,1,0,0,-1,-1,NULL,NULL),
(304066070,452921,100,1,0,0,-1,-1,NULL,NULL),
(304066071,452921,100,1,0,0,-1,-1,NULL,NULL);
IF ROW_COUNT() <> 72 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS NPC spawnentry insert count differs'; END IF;

-- spawn2: 72 new rows
INSERT INTO `spawn2` (`id`,`spawngroupID`,`zone`,`version`,`x`,`y`,`z`,`heading`,`respawntime`,`variance`,`pathgrid`,`path_when_zone_idle`,`_condition`,`cond_value`,`animation`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`) VALUES
(304066000,304066000,CONVERT(X'6f6c646b75726e' USING utf8mb4),1,-225.5,-23.625,233.75,379.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066001,304066001,CONVERT(X'6f6c646b75726e' USING utf8mb4),1,-324.0,-74.125,234.97102189214846,459.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066002,304066002,CONVERT(X'6f6c646b75726e' USING utf8mb4),1,-130.875,-17.5,232.5898638964299,404.75,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066003,304066003,CONVERT(X'6f6c646b75726e' USING utf8mb4),1,-231.875,36.375,233.75,251.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066004,304066004,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),1,325.0,16.125,-131.63317229092493,382.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066005,304066005,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),1,678.625,2.25,-23.374006271362305,378.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066006,304066006,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),1,18.125,-34.75,2.609527526310719,426.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066007,304066007,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),1,256.375,-275.125,-51.015869140625,251.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066008,304066008,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),1,232.875,274.0,-55.18845748901367,439.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066009,304066009,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),1,516.0,184.375,-51.490189437074875,381.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066010,304066010,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),1,521.375,-164.25,-51.490699768066406,378.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066011,304066011,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),1,104.875,131.625,-21.534927368164062,380.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066012,304066012,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),1,134.0,-147.0,-21.534927368164062,501.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066013,304066013,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),1,487.0,-10.875,-87.1919937133789,380.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066014,304066014,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),1,318.5,-131.5,-87.9441146850586,310.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066015,304066015,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),1,365.125,157.5,-87.9441146850586,129.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066016,304066016,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),1,197.0,40.0,-96.83992767333984,254.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066017,304066017,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),1,417.875,-102.25,-51.48392066662195,317.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066018,304066018,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),1,410.0,67.75,-97.64300537109375,321.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066019,304066019,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),1,142.5,3.75,-30.43932342529297,127.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066020,304066020,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),1,589.875,-13.875,-25.874000549316406,355.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066021,304066021,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),1,625.375,65.5,-23.374006271362305,274.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066022,304066022,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),1,469.0,-219.625,-51.4907078280127,508.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066023,304066023,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),1,17.625,35.125,2.506998916390618,331.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066024,304066024,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),1,485.875,-29.125,-22.985084533691406,380.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066025,304066025,CONVERT(X'6f6c646b6165736f726161' USING utf8mb4),1,283.0,-2031.0,-156.25051635782776,217.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066026,304066026,CONVERT(X'6f6c646b6165736f726161' USING utf8mb4),1,121.875,-2034.75,-164.26065234562995,275.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066027,304066027,CONVERT(X'6f6c646b6165736f726161' USING utf8mb4),1,36.625,-2123.0,-196.25639941969933,399.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066028,304066028,CONVERT(X'6f6c646b6165736f726161' USING utf8mb4),1,217.0,-2105.25,-196.25564575195312,2.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066029,304066029,CONVERT(X'6f6c646b6165736f726161' USING utf8mb4),1,-2425.0,-1447.0,-756.259033203125,111.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066030,304066030,CONVERT(X'6f6c646b6165736f726161' USING utf8mb4),1,-2434.875,-877.75,-766.2511496825828,134.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066031,304066031,CONVERT(X'6f6c646b75726e' USING utf8mb4),2,-243.5,-139.875,45.75,0.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066032,304066032,CONVERT(X'6f6c646b75726e' USING utf8mb4),2,-239.10137939453125,-139.875,45.75,0.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066033,304066033,CONVERT(X'6f6c646b75726e' USING utf8mb4),2,-248.5,-139.875,45.75,0.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066034,304066034,CONVERT(X'6f6c646b75726e' USING utf8mb4),2,-243.5,-144.875,45.75,0.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066035,304066035,CONVERT(X'6f6c646b75726e' USING utf8mb4),2,-243.5,-134.875,45.75,0.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066036,304066036,CONVERT(X'6f6c646b75726e' USING utf8mb4),2,-239.10137939453125,-144.875,45.75,0.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066037,304066037,CONVERT(X'6f6c646b75726e' USING utf8mb4),2,-239.10137939453125,-134.875,45.75,0.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066038,304066038,CONVERT(X'6f6c646b75726e' USING utf8mb4),2,-248.5,-144.875,45.75,0.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066039,304066039,CONVERT(X'6f6c646b75726e' USING utf8mb4),2,-244.25,120.75,45.75,0.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066040,304066040,CONVERT(X'6f6c646b75726e' USING utf8mb4),2,-249.25,120.75,45.75,0.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066041,304066041,CONVERT(X'6f6c646b75726e' USING utf8mb4),2,-244.25,115.75,45.75,0.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066042,304066042,CONVERT(X'6f6c646b75726e' USING utf8mb4),2,-244.25,125.75,45.75,0.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066043,304066043,CONVERT(X'6f6c646b75726e' USING utf8mb4),2,-239.25,120.75,45.75,0.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066044,304066044,CONVERT(X'6f6c646b75726e' USING utf8mb4),2,-249.25,115.75,45.75,0.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066045,304066045,CONVERT(X'6f6c646b75726e' USING utf8mb4),2,-249.25,125.75,45.75,0.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066046,304066046,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),2,18.125,-34.75,3.8595275263107194,426.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066047,304066047,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),2,516.0,184.375,-50.240189437074875,381.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066048,304066048,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),2,487.0,-10.875,-85.9419937133789,380.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066049,304066049,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),2,410.0,67.75,-95.76800537109375,321.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066050,304066050,CONVERT(X'6f6c646b75726e' USING utf8mb4),1,-22.75,-202.0,3.7500000000000004,385.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066051,304066051,CONVERT(X'6f6c646b75726e' USING utf8mb4),1,-78.0,-202.0,3.7500000000000004,128.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066052,304066052,CONVERT(X'6f6c646b75726e' USING utf8mb4),1,163.75,-179.625,3.7500000000000004,480.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066053,304066053,CONVERT(X'6f6c646b75726e' USING utf8mb4),1,157.875,-167.0,3.7500000000000004,257.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066054,304066054,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),1,18.125,-34.75,3.8595275263107194,426.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066055,304066055,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),1,34.5,-5.25,3.823935950935937,377.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066056,304066056,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),1,32.125,6.0,3.7930321374841567,378.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066057,304066057,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),1,17.625,35.125,3.7569989163906183,331.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066058,304066058,CONVERT(X'6f6c646b6165736f726161' USING utf8mb4),1,-1.0,-147.75,3.7503904761798443,384.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066059,304066059,CONVERT(X'6f6c646b6165736f726161' USING utf8mb4),1,-39.0,-147.5,3.750368073775013,132.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066060,304066060,CONVERT(X'6f6c646b75726e' USING utf8mb4),2,-22.75,-202.0,3.7500000000000004,385.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066061,304066061,CONVERT(X'6f6c646b75726e' USING utf8mb4),2,-78.0,-202.0,3.7500000000000004,128.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066062,304066062,CONVERT(X'6f6c646b75726e' USING utf8mb4),2,163.75,-179.625,3.7500000000000004,480.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066063,304066063,CONVERT(X'6f6c646b75726e' USING utf8mb4),2,157.875,-167.0,3.7500000000000004,257.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066064,304066064,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),2,18.125,-34.75,3.8595275263107194,426.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066065,304066065,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),2,34.5,-5.25,3.823935950935937,377.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066066,304066066,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),2,32.125,6.0,3.7930321374841567,378.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066067,304066067,CONVERT(X'6f6c646b6165736f726162' USING utf8mb4),2,17.625,35.125,3.7569989163906183,331.0,86400,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066068,304066068,CONVERT(X'6669656c646f66626f6e65' USING utf8mb4),0,121.0,-1869.0,-41.84153856844955,0.0,1200,0,304066000,0,0,1,0,-1,-1,NULL,NULL),
(304066069,304066069,CONVERT(X'6f6c646669656c646f66626f6e65' USING utf8mb4),0,-62.875,-1595.75,-37.427345277402104,0.0,1200,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066070,304066070,CONVERT(X'6f6c646669656c646f66626f6e65' USING utf8mb4),0,-70.875,-1595.75,-37.395390271307996,0.0,1200,0,0,0,0,1,0,-1,-1,NULL,NULL),
(304066071,304066071,CONVERT(X'6f6c646669656c646f66626f6e65' USING utf8mb4),0,-54.875,-1595.75,-35.5523466576072,0.0,1200,0,0,0,0,1,0,-1,-1,NULL,NULL);
IF ROW_COUNT() <> 72 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS NPC spawn2 insert count differs'; END IF;

-- CAS npc_types 452157; full donor preimage, only loottable_id changes.
UPDATE `npc_types` SET `loottable_id`=304066005 WHERE BINARY CAST(`id` AS CHAR) <=> CONVERT(X'343532313537' USING utf8mb4) AND BINARY CAST(`name` AS CHAR) <=> CONVERT(X'615f536562696c697369616e5f6d657373656e676572' USING utf8mb4) AND BINARY CAST(`lastname` AS CHAR) <=> CONVERT(X'' USING utf8mb4) AND BINARY CAST(`level` AS CHAR) <=> CONVERT(X'3830' USING utf8mb4) AND BINARY CAST(`race` AS CHAR) <=> CONVERT(X'313238' USING utf8mb4) AND BINARY CAST(`class` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`bodytype` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`hp` AS CHAR) <=> CONVERT(X'37323030' USING utf8mb4) AND BINARY CAST(`mana` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`gender` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`texture` AS CHAR) <=> CONVERT(X'32' USING utf8mb4) AND BINARY CAST(`helmtexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`herosforgemodel` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`size` AS CHAR) <=> CONVERT(X'36' USING utf8mb4) AND BINARY CAST(`hp_regen_rate` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`hp_regen_per_second` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`mana_regen_rate` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`loottable_id` AS CHAR) <=> CONVERT(X'3934333937' USING utf8mb4) AND BINARY CAST(`merchant_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`greed` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`alt_currency_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`npc_spells_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`npc_spells_effects_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`npc_faction_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`adventure_template_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`trap_template` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`mindmg` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`maxdmg` AS CHAR) <=> CONVERT(X'34' USING utf8mb4) AND BINARY CAST(`attack_count` AS CHAR) <=> CONVERT(X'2d31' USING utf8mb4) AND BINARY CAST(`npcspecialattks` AS CHAR) <=> CONVERT(X'' USING utf8mb4) AND BINARY CAST(`special_abilities` AS CHAR) <=> CONVERT(X'' USING utf8mb4) AND BINARY CAST(`aggroradius` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`assistradius` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`face` AS CHAR) <=> CONVERT(X'34' USING utf8mb4) AND BINARY CAST(`luclin_hairstyle` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`luclin_haircolor` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`luclin_eyecolor` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`luclin_eyecolor2` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`luclin_beardcolor` AS CHAR) <=> CONVERT(X'323535' USING utf8mb4) AND BINARY CAST(`luclin_beard` AS CHAR) <=> CONVERT(X'323535' USING utf8mb4) AND BINARY CAST(`drakkin_heritage` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`drakkin_tattoo` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`drakkin_details` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`armortint_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`armortint_red` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`armortint_green` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`armortint_blue` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`d_melee_texture1` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`d_melee_texture2` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`ammo_idfile` AS CHAR) <=> CONVERT(X'49543130' USING utf8mb4) AND BINARY CAST(`prim_melee_type` AS CHAR) <=> CONVERT(X'3238' USING utf8mb4) AND BINARY CAST(`sec_melee_type` AS CHAR) <=> CONVERT(X'3238' USING utf8mb4) AND BINARY CAST(`ranged_type` AS CHAR) <=> CONVERT(X'37' USING utf8mb4) AND BINARY CAST(`runspeed` AS CHAR) <=> CONVERT(X'312e3235' USING utf8mb4) AND BINARY CAST(`MR` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`CR` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`DR` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`FR` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`PR` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`Corrup` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`PhR` AS CHAR) <=> CONVERT(X'313030' USING utf8mb4) AND BINARY CAST(`see_invis` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`see_invis_undead` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`qglobal` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`AC` AS CHAR) <=> CONVERT(X'333932' USING utf8mb4) AND BINARY CAST(`npc_aggro` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`spawn_limit` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`attack_speed` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`attack_delay` AS CHAR) <=> CONVERT(X'3330' USING utf8mb4) AND BINARY CAST(`findable` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`STR` AS CHAR) <=> CONVERT(X'333130' USING utf8mb4) AND BINARY CAST(`STA` AS CHAR) <=> CONVERT(X'333130' USING utf8mb4) AND BINARY CAST(`DEX` AS CHAR) <=> CONVERT(X'333130' USING utf8mb4) AND BINARY CAST(`AGI` AS CHAR) <=> CONVERT(X'333130' USING utf8mb4) AND BINARY CAST(`_INT` AS CHAR) <=> CONVERT(X'333130' USING utf8mb4) AND BINARY CAST(`WIS` AS CHAR) <=> CONVERT(X'333130' USING utf8mb4) AND BINARY CAST(`CHA` AS CHAR) <=> CONVERT(X'333130' USING utf8mb4) AND BINARY CAST(`see_hide` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`see_improved_hide` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`trackable` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`isbot` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`exclude` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`ATK` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`Accuracy` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`Avoidance` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`slow_mitigation` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`version` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`maxlevel` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`scalerate` AS CHAR) <=> CONVERT(X'313030' USING utf8mb4) AND BINARY CAST(`private_corpse` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`unique_spawn_by_name` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`underwater` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`isquest` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`emoteid` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`spellscale` AS CHAR) <=> CONVERT(X'313030' USING utf8mb4) AND BINARY CAST(`healscale` AS CHAR) <=> CONVERT(X'313030' USING utf8mb4) AND BINARY CAST(`no_target_hotkey` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`raid_target` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`armtexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`bracertexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`handtexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`legtexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`feettexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`light` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`walkspeed` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`peqid` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`unique_` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`fixed` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`ignore_despawn` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`show_name` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`untargetable` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_ac` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_min_dmg` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_max_dmg` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_attack_delay` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_accuracy_rating` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_avoidance_rating` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_atk` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`skip_global_loot` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`rare_spawn` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`stuck_behavior` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`model` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`flymode` AS CHAR) <=> CONVERT(X'2d31' USING utf8mb4) AND BINARY CAST(`always_aggro` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`exp_mod` AS CHAR) <=> CONVERT(X'313030' USING utf8mb4) AND BINARY CAST(`heroic_strikethrough` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`faction_amount` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`keeps_sold_items` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`is_parcel_merchant` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`multiquest_enabled` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`npc_tint_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4);
IF ROW_COUNT() <> 1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS NPC full-preimage CAS failed: 452157';
END IF;

-- CAS npc_types 452158; full donor preimage, only loottable_id changes.
UPDATE `npc_types` SET `loottable_id`=304066005 WHERE BINARY CAST(`id` AS CHAR) <=> CONVERT(X'343532313538' USING utf8mb4) AND BINARY CAST(`name` AS CHAR) <=> CONVERT(X'615f536562696c697369616e5f6d657373656e676572' USING utf8mb4) AND BINARY CAST(`lastname` AS CHAR) <=> CONVERT(X'' USING utf8mb4) AND BINARY CAST(`level` AS CHAR) <=> CONVERT(X'3832' USING utf8mb4) AND BINARY CAST(`race` AS CHAR) <=> CONVERT(X'313238' USING utf8mb4) AND BINARY CAST(`class` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`bodytype` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`hp` AS CHAR) <=> CONVERT(X'37353434' USING utf8mb4) AND BINARY CAST(`mana` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`gender` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`texture` AS CHAR) <=> CONVERT(X'32' USING utf8mb4) AND BINARY CAST(`helmtexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`herosforgemodel` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`size` AS CHAR) <=> CONVERT(X'36' USING utf8mb4) AND BINARY CAST(`hp_regen_rate` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`hp_regen_per_second` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`mana_regen_rate` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`loottable_id` AS CHAR) <=> CONVERT(X'3934333937' USING utf8mb4) AND BINARY CAST(`merchant_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`greed` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`alt_currency_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`npc_spells_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`npc_spells_effects_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`npc_faction_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`adventure_template_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`trap_template` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`mindmg` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`maxdmg` AS CHAR) <=> CONVERT(X'34' USING utf8mb4) AND BINARY CAST(`attack_count` AS CHAR) <=> CONVERT(X'2d31' USING utf8mb4) AND BINARY CAST(`npcspecialattks` AS CHAR) <=> CONVERT(X'' USING utf8mb4) AND BINARY CAST(`special_abilities` AS CHAR) <=> CONVERT(X'' USING utf8mb4) AND BINARY CAST(`aggroradius` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`assistradius` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`face` AS CHAR) <=> CONVERT(X'32' USING utf8mb4) AND BINARY CAST(`luclin_hairstyle` AS CHAR) <=> CONVERT(X'32' USING utf8mb4) AND BINARY CAST(`luclin_haircolor` AS CHAR) <=> CONVERT(X'32' USING utf8mb4) AND BINARY CAST(`luclin_eyecolor` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`luclin_eyecolor2` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`luclin_beardcolor` AS CHAR) <=> CONVERT(X'323535' USING utf8mb4) AND BINARY CAST(`luclin_beard` AS CHAR) <=> CONVERT(X'323535' USING utf8mb4) AND BINARY CAST(`drakkin_heritage` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`drakkin_tattoo` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`drakkin_details` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`armortint_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`armortint_red` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`armortint_green` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`armortint_blue` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`d_melee_texture1` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`d_melee_texture2` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`ammo_idfile` AS CHAR) <=> CONVERT(X'49543130' USING utf8mb4) AND BINARY CAST(`prim_melee_type` AS CHAR) <=> CONVERT(X'3238' USING utf8mb4) AND BINARY CAST(`sec_melee_type` AS CHAR) <=> CONVERT(X'3238' USING utf8mb4) AND BINARY CAST(`ranged_type` AS CHAR) <=> CONVERT(X'37' USING utf8mb4) AND BINARY CAST(`runspeed` AS CHAR) <=> CONVERT(X'312e3235' USING utf8mb4) AND BINARY CAST(`MR` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`CR` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`DR` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`FR` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`PR` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`Corrup` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`PhR` AS CHAR) <=> CONVERT(X'313038' USING utf8mb4) AND BINARY CAST(`see_invis` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`see_invis_undead` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`qglobal` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`AC` AS CHAR) <=> CONVERT(X'343031' USING utf8mb4) AND BINARY CAST(`npc_aggro` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`spawn_limit` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`attack_speed` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`attack_delay` AS CHAR) <=> CONVERT(X'3330' USING utf8mb4) AND BINARY CAST(`findable` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`STR` AS CHAR) <=> CONVERT(X'333137' USING utf8mb4) AND BINARY CAST(`STA` AS CHAR) <=> CONVERT(X'333137' USING utf8mb4) AND BINARY CAST(`DEX` AS CHAR) <=> CONVERT(X'333137' USING utf8mb4) AND BINARY CAST(`AGI` AS CHAR) <=> CONVERT(X'333137' USING utf8mb4) AND BINARY CAST(`_INT` AS CHAR) <=> CONVERT(X'333137' USING utf8mb4) AND BINARY CAST(`WIS` AS CHAR) <=> CONVERT(X'333137' USING utf8mb4) AND BINARY CAST(`CHA` AS CHAR) <=> CONVERT(X'333137' USING utf8mb4) AND BINARY CAST(`see_hide` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`see_improved_hide` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`trackable` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`isbot` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`exclude` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`ATK` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`Accuracy` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`Avoidance` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`slow_mitigation` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`version` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`maxlevel` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`scalerate` AS CHAR) <=> CONVERT(X'313030' USING utf8mb4) AND BINARY CAST(`private_corpse` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`unique_spawn_by_name` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`underwater` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`isquest` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`emoteid` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`spellscale` AS CHAR) <=> CONVERT(X'313030' USING utf8mb4) AND BINARY CAST(`healscale` AS CHAR) <=> CONVERT(X'313030' USING utf8mb4) AND BINARY CAST(`no_target_hotkey` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`raid_target` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`armtexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`bracertexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`handtexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`legtexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`feettexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`light` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`walkspeed` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`peqid` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`unique_` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`fixed` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`ignore_despawn` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`show_name` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`untargetable` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_ac` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_min_dmg` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_max_dmg` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_attack_delay` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_accuracy_rating` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_avoidance_rating` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_atk` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`skip_global_loot` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`rare_spawn` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`stuck_behavior` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`model` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`flymode` AS CHAR) <=> CONVERT(X'2d31' USING utf8mb4) AND BINARY CAST(`always_aggro` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`exp_mod` AS CHAR) <=> CONVERT(X'313030' USING utf8mb4) AND BINARY CAST(`heroic_strikethrough` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`faction_amount` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`keeps_sold_items` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`is_parcel_merchant` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`multiquest_enabled` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`npc_tint_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4);
IF ROW_COUNT() <> 1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS NPC full-preimage CAS failed: 452158';
END IF;

-- CAS npc_types 452211; full donor preimage, only loottable_id changes.
UPDATE `npc_types` SET `loottable_id`=304066005 WHERE BINARY CAST(`id` AS CHAR) <=> CONVERT(X'343532323131' USING utf8mb4) AND BINARY CAST(`name` AS CHAR) <=> CONVERT(X'615f536562696c697369616e5f6d657373656e676572' USING utf8mb4) AND BINARY CAST(`lastname` AS CHAR) <=> CONVERT(X'' USING utf8mb4) AND BINARY CAST(`level` AS CHAR) <=> CONVERT(X'3831' USING utf8mb4) AND BINARY CAST(`race` AS CHAR) <=> CONVERT(X'313238' USING utf8mb4) AND BINARY CAST(`class` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`bodytype` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`hp` AS CHAR) <=> CONVERT(X'37333731' USING utf8mb4) AND BINARY CAST(`mana` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`gender` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`texture` AS CHAR) <=> CONVERT(X'32' USING utf8mb4) AND BINARY CAST(`helmtexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`herosforgemodel` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`size` AS CHAR) <=> CONVERT(X'36' USING utf8mb4) AND BINARY CAST(`hp_regen_rate` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`hp_regen_per_second` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`mana_regen_rate` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`loottable_id` AS CHAR) <=> CONVERT(X'3934333937' USING utf8mb4) AND BINARY CAST(`merchant_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`greed` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`alt_currency_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`npc_spells_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`npc_spells_effects_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`npc_faction_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`adventure_template_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`trap_template` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`mindmg` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`maxdmg` AS CHAR) <=> CONVERT(X'34' USING utf8mb4) AND BINARY CAST(`attack_count` AS CHAR) <=> CONVERT(X'2d31' USING utf8mb4) AND BINARY CAST(`npcspecialattks` AS CHAR) <=> CONVERT(X'' USING utf8mb4) AND BINARY CAST(`special_abilities` AS CHAR) <=> CONVERT(X'' USING utf8mb4) AND BINARY CAST(`aggroradius` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`assistradius` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`face` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`luclin_hairstyle` AS CHAR) <=> CONVERT(X'32' USING utf8mb4) AND BINARY CAST(`luclin_haircolor` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`luclin_eyecolor` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`luclin_eyecolor2` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`luclin_beardcolor` AS CHAR) <=> CONVERT(X'323535' USING utf8mb4) AND BINARY CAST(`luclin_beard` AS CHAR) <=> CONVERT(X'323535' USING utf8mb4) AND BINARY CAST(`drakkin_heritage` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`drakkin_tattoo` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`drakkin_details` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`armortint_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`armortint_red` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`armortint_green` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`armortint_blue` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`d_melee_texture1` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`d_melee_texture2` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`ammo_idfile` AS CHAR) <=> CONVERT(X'49543130' USING utf8mb4) AND BINARY CAST(`prim_melee_type` AS CHAR) <=> CONVERT(X'3238' USING utf8mb4) AND BINARY CAST(`sec_melee_type` AS CHAR) <=> CONVERT(X'3238' USING utf8mb4) AND BINARY CAST(`ranged_type` AS CHAR) <=> CONVERT(X'37' USING utf8mb4) AND BINARY CAST(`runspeed` AS CHAR) <=> CONVERT(X'312e3235' USING utf8mb4) AND BINARY CAST(`MR` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`CR` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`DR` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`FR` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`PR` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`Corrup` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`PhR` AS CHAR) <=> CONVERT(X'313034' USING utf8mb4) AND BINARY CAST(`see_invis` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`see_invis_undead` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`qglobal` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`AC` AS CHAR) <=> CONVERT(X'333937' USING utf8mb4) AND BINARY CAST(`npc_aggro` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`spawn_limit` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`attack_speed` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`attack_delay` AS CHAR) <=> CONVERT(X'3330' USING utf8mb4) AND BINARY CAST(`findable` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`STR` AS CHAR) <=> CONVERT(X'333134' USING utf8mb4) AND BINARY CAST(`STA` AS CHAR) <=> CONVERT(X'333134' USING utf8mb4) AND BINARY CAST(`DEX` AS CHAR) <=> CONVERT(X'333134' USING utf8mb4) AND BINARY CAST(`AGI` AS CHAR) <=> CONVERT(X'333134' USING utf8mb4) AND BINARY CAST(`_INT` AS CHAR) <=> CONVERT(X'333134' USING utf8mb4) AND BINARY CAST(`WIS` AS CHAR) <=> CONVERT(X'333134' USING utf8mb4) AND BINARY CAST(`CHA` AS CHAR) <=> CONVERT(X'333134' USING utf8mb4) AND BINARY CAST(`see_hide` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`see_improved_hide` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`trackable` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`isbot` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`exclude` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`ATK` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`Accuracy` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`Avoidance` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`slow_mitigation` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`version` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`maxlevel` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`scalerate` AS CHAR) <=> CONVERT(X'313030' USING utf8mb4) AND BINARY CAST(`private_corpse` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`unique_spawn_by_name` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`underwater` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`isquest` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`emoteid` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`spellscale` AS CHAR) <=> CONVERT(X'313030' USING utf8mb4) AND BINARY CAST(`healscale` AS CHAR) <=> CONVERT(X'313030' USING utf8mb4) AND BINARY CAST(`no_target_hotkey` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`raid_target` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`armtexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`bracertexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`handtexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`legtexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`feettexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`light` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`walkspeed` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`peqid` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`unique_` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`fixed` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`ignore_despawn` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`show_name` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`untargetable` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_ac` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_min_dmg` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_max_dmg` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_attack_delay` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_accuracy_rating` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_avoidance_rating` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_atk` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`skip_global_loot` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`rare_spawn` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`stuck_behavior` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`model` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`flymode` AS CHAR) <=> CONVERT(X'2d31' USING utf8mb4) AND BINARY CAST(`always_aggro` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`exp_mod` AS CHAR) <=> CONVERT(X'313030' USING utf8mb4) AND BINARY CAST(`heroic_strikethrough` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`faction_amount` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`keeps_sold_items` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`is_parcel_merchant` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`multiquest_enabled` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`npc_tint_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4);
IF ROW_COUNT() <> 1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS NPC full-preimage CAS failed: 452211';
END IF;

-- CAS npc_types 452282; full donor preimage, only loottable_id changes.
UPDATE `npc_types` SET `loottable_id`=304066006 WHERE BINARY CAST(`id` AS CHAR) <=> CONVERT(X'343532323832' USING utf8mb4) AND BINARY CAST(`name` AS CHAR) <=> CONVERT(X'615f536562696c697369616e5f6d657373656e676572' USING utf8mb4) AND BINARY CAST(`lastname` AS CHAR) <=> CONVERT(X'' USING utf8mb4) AND BINARY CAST(`level` AS CHAR) <=> CONVERT(X'3830' USING utf8mb4) AND BINARY CAST(`race` AS CHAR) <=> CONVERT(X'313238' USING utf8mb4) AND BINARY CAST(`class` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`bodytype` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`hp` AS CHAR) <=> CONVERT(X'37323030' USING utf8mb4) AND BINARY CAST(`mana` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`gender` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`texture` AS CHAR) <=> CONVERT(X'32' USING utf8mb4) AND BINARY CAST(`helmtexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`herosforgemodel` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`size` AS CHAR) <=> CONVERT(X'36' USING utf8mb4) AND BINARY CAST(`hp_regen_rate` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`hp_regen_per_second` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`mana_regen_rate` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`loottable_id` AS CHAR) <=> CONVERT(X'3934333937' USING utf8mb4) AND BINARY CAST(`merchant_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`greed` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`alt_currency_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`npc_spells_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`npc_spells_effects_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`npc_faction_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`adventure_template_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`trap_template` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`mindmg` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`maxdmg` AS CHAR) <=> CONVERT(X'34' USING utf8mb4) AND BINARY CAST(`attack_count` AS CHAR) <=> CONVERT(X'2d31' USING utf8mb4) AND BINARY CAST(`npcspecialattks` AS CHAR) <=> CONVERT(X'' USING utf8mb4) AND BINARY CAST(`special_abilities` AS CHAR) <=> CONVERT(X'' USING utf8mb4) AND BINARY CAST(`aggroradius` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`assistradius` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`face` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`luclin_hairstyle` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`luclin_haircolor` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`luclin_eyecolor` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`luclin_eyecolor2` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`luclin_beardcolor` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`luclin_beard` AS CHAR) <=> CONVERT(X'323535' USING utf8mb4) AND BINARY CAST(`drakkin_heritage` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`drakkin_tattoo` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`drakkin_details` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`armortint_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`armortint_red` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`armortint_green` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`armortint_blue` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`d_melee_texture1` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`d_melee_texture2` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`ammo_idfile` AS CHAR) <=> CONVERT(X'49543130' USING utf8mb4) AND BINARY CAST(`prim_melee_type` AS CHAR) <=> CONVERT(X'3238' USING utf8mb4) AND BINARY CAST(`sec_melee_type` AS CHAR) <=> CONVERT(X'3238' USING utf8mb4) AND BINARY CAST(`ranged_type` AS CHAR) <=> CONVERT(X'37' USING utf8mb4) AND BINARY CAST(`runspeed` AS CHAR) <=> CONVERT(X'312e3235' USING utf8mb4) AND BINARY CAST(`MR` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`CR` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`DR` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`FR` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`PR` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`Corrup` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`PhR` AS CHAR) <=> CONVERT(X'313030' USING utf8mb4) AND BINARY CAST(`see_invis` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`see_invis_undead` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`qglobal` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`AC` AS CHAR) <=> CONVERT(X'333932' USING utf8mb4) AND BINARY CAST(`npc_aggro` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`spawn_limit` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`attack_speed` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`attack_delay` AS CHAR) <=> CONVERT(X'3330' USING utf8mb4) AND BINARY CAST(`findable` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`STR` AS CHAR) <=> CONVERT(X'333130' USING utf8mb4) AND BINARY CAST(`STA` AS CHAR) <=> CONVERT(X'333130' USING utf8mb4) AND BINARY CAST(`DEX` AS CHAR) <=> CONVERT(X'333130' USING utf8mb4) AND BINARY CAST(`AGI` AS CHAR) <=> CONVERT(X'333130' USING utf8mb4) AND BINARY CAST(`_INT` AS CHAR) <=> CONVERT(X'333130' USING utf8mb4) AND BINARY CAST(`WIS` AS CHAR) <=> CONVERT(X'333130' USING utf8mb4) AND BINARY CAST(`CHA` AS CHAR) <=> CONVERT(X'333130' USING utf8mb4) AND BINARY CAST(`see_hide` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`see_improved_hide` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`trackable` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`isbot` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`exclude` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`ATK` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`Accuracy` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`Avoidance` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`slow_mitigation` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`version` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`maxlevel` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`scalerate` AS CHAR) <=> CONVERT(X'313030' USING utf8mb4) AND BINARY CAST(`private_corpse` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`unique_spawn_by_name` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`underwater` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`isquest` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`emoteid` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`spellscale` AS CHAR) <=> CONVERT(X'313030' USING utf8mb4) AND BINARY CAST(`healscale` AS CHAR) <=> CONVERT(X'313030' USING utf8mb4) AND BINARY CAST(`no_target_hotkey` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`raid_target` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`armtexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`bracertexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`handtexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`legtexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`feettexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`light` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`walkspeed` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`peqid` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`unique_` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`fixed` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`ignore_despawn` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`show_name` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`untargetable` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_ac` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_min_dmg` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_max_dmg` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_attack_delay` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_accuracy_rating` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_avoidance_rating` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_atk` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`skip_global_loot` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`rare_spawn` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`stuck_behavior` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`model` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`flymode` AS CHAR) <=> CONVERT(X'2d31' USING utf8mb4) AND BINARY CAST(`always_aggro` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`exp_mod` AS CHAR) <=> CONVERT(X'313030' USING utf8mb4) AND BINARY CAST(`heroic_strikethrough` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`faction_amount` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`keeps_sold_items` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`is_parcel_merchant` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`multiquest_enabled` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`npc_tint_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4);
IF ROW_COUNT() <> 1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS NPC full-preimage CAS failed: 452282';
END IF;

-- CAS npc_types 452286; full donor preimage, only loottable_id changes.
UPDATE `npc_types` SET `loottable_id`=304066006 WHERE BINARY CAST(`id` AS CHAR) <=> CONVERT(X'343532323836' USING utf8mb4) AND BINARY CAST(`name` AS CHAR) <=> CONVERT(X'615f536562696c697369616e5f6d657373656e676572' USING utf8mb4) AND BINARY CAST(`lastname` AS CHAR) <=> CONVERT(X'' USING utf8mb4) AND BINARY CAST(`level` AS CHAR) <=> CONVERT(X'3831' USING utf8mb4) AND BINARY CAST(`race` AS CHAR) <=> CONVERT(X'313238' USING utf8mb4) AND BINARY CAST(`class` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`bodytype` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`hp` AS CHAR) <=> CONVERT(X'37333731' USING utf8mb4) AND BINARY CAST(`mana` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`gender` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`texture` AS CHAR) <=> CONVERT(X'32' USING utf8mb4) AND BINARY CAST(`helmtexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`herosforgemodel` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`size` AS CHAR) <=> CONVERT(X'36' USING utf8mb4) AND BINARY CAST(`hp_regen_rate` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`hp_regen_per_second` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`mana_regen_rate` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`loottable_id` AS CHAR) <=> CONVERT(X'3934333937' USING utf8mb4) AND BINARY CAST(`merchant_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`greed` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`alt_currency_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`npc_spells_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`npc_spells_effects_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`npc_faction_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`adventure_template_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`trap_template` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`mindmg` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`maxdmg` AS CHAR) <=> CONVERT(X'34' USING utf8mb4) AND BINARY CAST(`attack_count` AS CHAR) <=> CONVERT(X'2d31' USING utf8mb4) AND BINARY CAST(`npcspecialattks` AS CHAR) <=> CONVERT(X'' USING utf8mb4) AND BINARY CAST(`special_abilities` AS CHAR) <=> CONVERT(X'' USING utf8mb4) AND BINARY CAST(`aggroradius` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`assistradius` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`face` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`luclin_hairstyle` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`luclin_haircolor` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`luclin_eyecolor` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`luclin_eyecolor2` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`luclin_beardcolor` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`luclin_beard` AS CHAR) <=> CONVERT(X'323535' USING utf8mb4) AND BINARY CAST(`drakkin_heritage` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`drakkin_tattoo` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`drakkin_details` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`armortint_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`armortint_red` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`armortint_green` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`armortint_blue` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`d_melee_texture1` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`d_melee_texture2` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`ammo_idfile` AS CHAR) <=> CONVERT(X'49543130' USING utf8mb4) AND BINARY CAST(`prim_melee_type` AS CHAR) <=> CONVERT(X'3238' USING utf8mb4) AND BINARY CAST(`sec_melee_type` AS CHAR) <=> CONVERT(X'3238' USING utf8mb4) AND BINARY CAST(`ranged_type` AS CHAR) <=> CONVERT(X'37' USING utf8mb4) AND BINARY CAST(`runspeed` AS CHAR) <=> CONVERT(X'312e3235' USING utf8mb4) AND BINARY CAST(`MR` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`CR` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`DR` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`FR` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`PR` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`Corrup` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`PhR` AS CHAR) <=> CONVERT(X'313034' USING utf8mb4) AND BINARY CAST(`see_invis` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`see_invis_undead` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`qglobal` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`AC` AS CHAR) <=> CONVERT(X'333937' USING utf8mb4) AND BINARY CAST(`npc_aggro` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`spawn_limit` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`attack_speed` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`attack_delay` AS CHAR) <=> CONVERT(X'3330' USING utf8mb4) AND BINARY CAST(`findable` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`STR` AS CHAR) <=> CONVERT(X'333134' USING utf8mb4) AND BINARY CAST(`STA` AS CHAR) <=> CONVERT(X'333134' USING utf8mb4) AND BINARY CAST(`DEX` AS CHAR) <=> CONVERT(X'333134' USING utf8mb4) AND BINARY CAST(`AGI` AS CHAR) <=> CONVERT(X'333134' USING utf8mb4) AND BINARY CAST(`_INT` AS CHAR) <=> CONVERT(X'333134' USING utf8mb4) AND BINARY CAST(`WIS` AS CHAR) <=> CONVERT(X'333134' USING utf8mb4) AND BINARY CAST(`CHA` AS CHAR) <=> CONVERT(X'333134' USING utf8mb4) AND BINARY CAST(`see_hide` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`see_improved_hide` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`trackable` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`isbot` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`exclude` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`ATK` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`Accuracy` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`Avoidance` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`slow_mitigation` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`version` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`maxlevel` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`scalerate` AS CHAR) <=> CONVERT(X'313030' USING utf8mb4) AND BINARY CAST(`private_corpse` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`unique_spawn_by_name` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`underwater` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`isquest` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`emoteid` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`spellscale` AS CHAR) <=> CONVERT(X'313030' USING utf8mb4) AND BINARY CAST(`healscale` AS CHAR) <=> CONVERT(X'313030' USING utf8mb4) AND BINARY CAST(`no_target_hotkey` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`raid_target` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`armtexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`bracertexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`handtexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`legtexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`feettexture` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`light` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`walkspeed` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`peqid` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`unique_` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`fixed` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`ignore_despawn` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`show_name` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`untargetable` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_ac` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_min_dmg` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_max_dmg` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_attack_delay` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_accuracy_rating` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_avoidance_rating` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`charm_atk` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`skip_global_loot` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`rare_spawn` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`stuck_behavior` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`model` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`flymode` AS CHAR) <=> CONVERT(X'2d31' USING utf8mb4) AND BINARY CAST(`always_aggro` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`exp_mod` AS CHAR) <=> CONVERT(X'313030' USING utf8mb4) AND BINARY CAST(`heroic_strikethrough` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`faction_amount` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`keeps_sold_items` AS CHAR) <=> CONVERT(X'31' USING utf8mb4) AND BINARY CAST(`is_parcel_merchant` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`multiquest_enabled` AS CHAR) <=> CONVERT(X'30' USING utf8mb4) AND BINARY CAST(`npc_tint_id` AS CHAR) <=> CONVERT(X'30' USING utf8mb4);
IF ROW_COUNT() <> 1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS NPC full-preimage CAS failed: 452286';
END IF;



-- Remaining-only approved FoS content. NPC fragment is already owned by Database; DO NOT insert it again.

-- No transaction/DDL/player-state statements. Database wraps this with its one guarded aggregate transaction.

IF NOT EXISTS(SELECT 1 FROM zone_points WHERE `id` <=> 1706 AND BINARY `zone` <=> BINARY CONVERT(0x6f6c646b6165736f726162 USING utf8mb4) AND `version` <=> 0 AND `number` <=> 10 AND `y` <=> 0.0 AND `x` <=> 0.0 AND `z` <=> 0.0 AND `heading` <=> 0.0 AND `target_y` <=> -1884.0 AND `target_x` <=> -610.0 AND `target_z` <=> -50.0 AND `target_heading` <=> 487.0 AND `zoneinst` <=> 0 AND `target_zone_id` <=> 452 AND `target_instance` <=> 0 AND `buffer` <=> 0.0 AND `client_version_mask` <=> 4294967295 AND `min_expansion` <=> -1 AND `max_expansion` <=> -1 AND `content_flags` <=> NULL AND `content_flags_disabled` <=> NULL AND `is_virtual` <=> 0 AND `height` <=> 0 AND `width` <=> 0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS authentic exit donor preimage differs'; END IF;

IF NOT EXISTS(SELECT 1 FROM zone_points WHERE `id` <=> 1707 AND BINARY `zone` <=> BINARY CONVERT(0x6f6c646b6165736f726161 USING utf8mb4) AND `version` <=> 0 AND `number` <=> 10 AND `y` <=> 0.0 AND `x` <=> 0.0 AND `z` <=> 0.0 AND `heading` <=> 0.0 AND `target_y` <=> -2168.0 AND `target_x` <=> 27.0 AND `target_z` <=> -50.0 AND `target_heading` <=> 66.0 AND `zoneinst` <=> 0 AND `target_zone_id` <=> 452 AND `target_instance` <=> 0 AND `buffer` <=> 0.0 AND `client_version_mask` <=> 4294967295 AND `min_expansion` <=> -1 AND `max_expansion` <=> -1 AND `content_flags` <=> NULL AND `content_flags_disabled` <=> NULL AND `is_virtual` <=> 0 AND `height` <=> 0 AND `width` <=> 0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS authentic exit donor preimage differs'; END IF;

IF NOT EXISTS(SELECT 1 FROM zone_points WHERE `id` <=> 1730 AND BINARY `zone` <=> BINARY CONVERT(0x6f6c646b75726e USING utf8mb4) AND `version` <=> 0 AND `number` <=> 0 AND `y` <=> 0.0 AND `x` <=> 0.0 AND `z` <=> 0.0 AND `heading` <=> 0.0 AND `target_y` <=> 428.0 AND `target_x` <=> 898.0 AND `target_z` <=> 100.0 AND `target_heading` <=> 262.0 AND `zoneinst` <=> 0 AND `target_zone_id` <=> 452 AND `target_instance` <=> 0 AND `buffer` <=> 0.0 AND `client_version_mask` <=> 4294967295 AND `min_expansion` <=> -1 AND `max_expansion` <=> -1 AND `content_flags` <=> NULL AND `content_flags_disabled` <=> NULL AND `is_virtual` <=> 0 AND `height` <=> 0 AND `width` <=> 0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS authentic exit donor preimage differs'; END IF;

IF NOT EXISTS(SELECT 1 FROM zone_points WHERE `id` <=> 1731 AND BINARY `zone` <=> BINARY CONVERT(0x6f6c646b75726e USING utf8mb4) AND `version` <=> 0 AND `number` <=> 10 AND `y` <=> 0.0 AND `x` <=> 0.0 AND `z` <=> 0.0 AND `heading` <=> 0.0 AND `target_y` <=> 428.0 AND `target_x` <=> 898.0 AND `target_z` <=> 100.0 AND `target_heading` <=> 262.0 AND `zoneinst` <=> 0 AND `target_zone_id` <=> 452 AND `target_instance` <=> 0 AND `buffer` <=> 0.0 AND `client_version_mask` <=> 4294967295 AND `min_expansion` <=> -1 AND `max_expansion` <=> -1 AND `content_flags` <=> NULL AND `content_flags_disabled` <=> NULL AND `is_virtual` <=> 0 AND `height` <=> 0 AND `width` <=> 0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS authentic exit donor preimage differs'; END IF;

IF EXISTS(SELECT 1 FROM zone_points WHERE zone=CONVERT(0x6f6c646b6165736f726162 USING utf8mb4) AND version=1 AND number=10) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS mission exit identity occupied'; END IF;

IF EXISTS(SELECT 1 FROM zone_points WHERE zone=CONVERT(0x6f6c646b6165736f726162 USING utf8mb4) AND version=2 AND number=10) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS mission exit identity occupied'; END IF;

IF EXISTS(SELECT 1 FROM zone_points WHERE zone=CONVERT(0x6f6c646b6165736f726161 USING utf8mb4) AND version=1 AND number=10) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS mission exit identity occupied'; END IF;

IF EXISTS(SELECT 1 FROM zone_points WHERE zone=CONVERT(0x6f6c646b75726e USING utf8mb4) AND version=1 AND number=0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS mission exit identity occupied'; END IF;

IF EXISTS(SELECT 1 FROM zone_points WHERE zone=CONVERT(0x6f6c646b75726e USING utf8mb4) AND version=2 AND number=0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS mission exit identity occupied'; END IF;

IF EXISTS(SELECT 1 FROM zone_points WHERE zone=CONVERT(0x6f6c646b75726e USING utf8mb4) AND version=1 AND number=10) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS mission exit identity occupied'; END IF;

IF EXISTS(SELECT 1 FROM zone_points WHERE zone=CONVERT(0x6f6c646b75726e USING utf8mb4) AND version=2 AND number=10) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS mission exit identity occupied'; END IF;

IF EXISTS(SELECT 1 FROM `tasks` WHERE id IN (920197,920198,920199,920200,920201,920202,920203,920204,920205,920206,920207,920208,920209,920210,920211,920212,920213,920214,920215)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS tasks preimage not empty'; END IF;

INSERT INTO `tasks` (`id`,`type`,`duration`,`duration_code`,`title`,`description`,`reward_text`,`reward_id_list`,`cash_reward`,`exp_reward`,`reward_method`,`reward_points`,`reward_point_type`,`min_level`,`max_level`,`level_spread`,`min_players`,`max_players`,`repeatable`,`faction_reward`,`completion_emote`,`replay_timer_group`,`replay_timer_seconds`,`request_timer_group`,`request_timer_seconds`,`dz_template_id`,`lock_activity_id`,`faction_amount`,`enabled`) VALUES
(920197,1,0,0,CONVERT(0x4472616b652053636f75726765 USING utf8mb4),CONVERT(0x496b7361722053636f75726765205461696c20746f205365766572696c6f75730a4461726b656e6564204472616b6520536b756c6c20746f205365766572696c6f75730a6e6563726f6d616e63657220726573706f6e7369626c6520666f722063757273656420736b756c6c20696e204b6165736f72614c6962726172790a4461726b656e6564204472616b6520536b756c6c20746f205365766572696c6f7573 USING utf8mb4),CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),'',0,0,3,0,0,65,100,15,1,6,1,0,'',0,14400,0,0,0,-1,0,1),
(920198,2,0,0,CONVERT(0x466f6f6420537570706c696573 USING utf8mb4),CONVERT(0x536562696c697369616e2068756e7465720a63617263617373657320696e2074656e2d706f756e6420756e6974730a5365766572696c6f7573 USING utf8mb4),CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),'',0,0,3,0,0,65,100,15,1,6,1,0,'',0,0,0,0,0,-1,0,1),
(920199,2,0,0,CONVERT(0x546865204772616e6420496c6c7573696f6e USING utf8mb4),CONVERT(0x5075726966790a49646c650a41666f6f740a536b756c6c0a506861726120446172 USING utf8mb4),CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),'',0,0,3,0,0,65,100,15,1,6,0,0,'',0,0,0,0,0,-1,0,1),
(920200,1,21600,0,CONVERT(0x52616973696e6720436162696c6973 USING utf8mb4),CONVERT(0x536562696c697369616e20626f6e656361737465720a536562696c697369616e20626f6e6574726f6f7065720a4a616c656460446172 USING utf8mb4),CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),'',0,0,3,0,0,65,100,15,1,6,1,0,'',0,21600,0,0,0,-1,0,1),
(920201,1,21600,0,CONVERT(0x5361726e616b205265636f76657279 USING utf8mb4),CONVERT(0x536562696c697369616e20747261636b65720a776f756e6465642065736361706564207361726e616b20636f6e66657373696f6e0a53452068617463686572790a736f6b6f6b61722068617463686c696e670a5472616b616e6f6e USING utf8mb4),CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),'',0,0,3,0,0,65,100,15,1,6,1,0,'',0,21600,0,0,0,-1,0,1),
(920202,1,21600,0,CONVERT(0x5361726e616b205265636f76657279 USING utf8mb4),CONVERT(0x536562696c697369616e20747261636b6572730a5361726e616b20636f6e66657373696f6e206e656172323070657263656e740a4e5769736c616e646d656574696e670a536562696c697369616e20656d6973736172790a5472616b616e6f6e USING utf8mb4),CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),'',0,0,3,0,0,65,100,15,1,6,1,0,'',0,21600,0,0,0,-1,0,1),
(920203,1,21600,0,CONVERT(0x5361726e616b205265636f76657279 USING utf8mb4),CONVERT(0x536562696c697369616e20747261636b65720a776f756e6465642065736361706564207361726e616b20636f6e66657373696f6e0a536562696c697369616e20706174726f6c206c65616465720a5472616b616e6f6e USING utf8mb4),CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),'',0,0,3,0,0,65,100,15,1,6,1,0,'',0,21600,0,0,0,-1,0,1),
(920204,2,0,0,CONVERT(0x537570706c696573 USING utf8mb4),CONVERT(0x62617272656c206f7220626f78206f6e204b75726e7468697264666c6f6f720a5472616b616e6f6e USING utf8mb4),CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),'',0,0,3,0,0,65,100,15,1,6,1,0,'',0,0,0,0,0,-1,0,1),
(920205,2,0,0,CONVERT(0x4576696c2041666f6f74 USING utf8mb4),CONVERT(0x466f6f74206f6620746865204d61737465720a466f6f74206f6620746865204d617374657220746f20506861726120446172 USING utf8mb4),CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),'',0,0,3,0,0,65,100,15,1,6,0,0,'',0,0,0,0,0,-1,0,1),
(920206,2,0,0,CONVERT(0x49646c652048616e6473 USING utf8mb4),CONVERT(0x5368616465206f6620546861726f66662065617274686c792072656d61696e730a536b656c6574616c2048616e64206f66204e6563726f7073792066726f6d20546861726f666620626f6e65730a536b656c6574616c2048616e64206f66204e6563726f70737920746f20506861726120446172 USING utf8mb4),CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),'',0,0,3,0,0,65,100,15,1,6,0,0,'',0,0,0,0,0,-1,0,1),
(920207,2,0,0,CONVERT(0x5075726966792074686520426f6479 USING utf8mb4),CONVERT(0x496b73617220526962636167650a496b736172205269626361676520746f205068617261204461720a5361792072696263616765202f20696d70757265207269626361676520746f2061637475616c2054616c656e646f720a496b736172205269626361676520746f2054616c656e646f720a536562696c697369616e20466972650a536562696c697369616e204669726520746f2054616c656e646f720a566973636964205461720a5669736369642054617220746f2054616c656e646f720a4c6976696e6720466c616d652074656d706c650a436f6174656420496b736172205269626361676520746f2043616c6574686f730a507572696669656420496b736172205269626361676520746f20506861726120446172 USING utf8mb4),CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),'',0,0,3,0,0,65,100,15,1,6,0,0,'',0,0,0,0,0,-1,0,1),
(920208,2,0,0,CONVERT(0x54686520536b756c6c206f662074686520416e6369656e74 USING utf8mb4),CONVERT(0x50657472696669656420536b756c6c206f6620436f6d6d616e646572204b6f74682066726f6d204f524947494e414c4669656c646f66426f6e6520756e64656164436f6d6d616e6465724b6f74680a50657472696669656420536b756c6c206f6620436f6d6d616e646572204b6f746820746f20506861726120446172 USING utf8mb4),CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),'',0,0,3,0,0,65,100,15,1,6,0,0,'',0,0,0,0,0,-1,0,1),
(920209,1,900,0,CONVERT(0x4c6f737420616e6420466f756e64 USING utf8mb4),CONVERT(0x656d6572616c645f636f727073650a677265795f636f727073650a6b72697a6c656b0a736562696c697369616e5f647261676f6e68756e746572730a4461726b626c616465204c6f6e6773776f72640a4461726b626c616465204c6f6e6773776f726420746f204a616c656460446172 USING utf8mb4),CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),'',0,0,3,0,0,65,100,15,1,6,1,0,'',0,21600,0,0,0,-1,0,1),
(920210,1,86400,0,CONVERT(0x5061726c657920776974682047616e616b USING utf8mb4),CONVERT(0x5669616c206f6620496b73617220426c6f6f6420746f205472616b616e6f6e0a496b73617220426f6e6520746f205472616b616e6f6e0a41637475616c205472616b616e6f6e20696c6c7573696f6e206b6579776f726420616e64206f726967696e616c20636173740a436f6d706c657465206f726967696e616c2047616e616b206469616c6f677565207468726f7567682073657276653b20696c6c7573696f6e20666164657320616e6420666f75722067756172647320656e676167650a496d70657269616c20477561726469616e204d656b74610a496d70657269616c20477561726469616e20486573616c79740a496d70657269616c2041647669736f7220526573796c61720a496d70657269616c2041647669736f722053657374616b0a4a616c656460446172 USING utf8mb4),CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),'',0,0,3,0,0,65,100,15,1,6,1,0,'',0,0,0,21600,0,-1,0,1),
(920211,1,21600,0,CONVERT(0x41756469656e6365207769746820746865205761726d6173746572 USING utf8mb4),CONVERT(0x4b75726e206d697373696f6e0a666f7572205468657373696c61206775617264732064656665617465640a5468657373696c6120746865204461726b USING utf8mb4),CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),'',0,0,3,0,0,65,100,15,1,6,1,0,'',0,21600,0,0,920211,-1,0,1),
(920212,1,21600,0,CONVERT(0x5468652042726f6f64206f6620616e20456d7065726f72 USING utf8mb4),CONVERT(0x4861746368657279206d697373696f6e0a696d70657269616c206567670a646566656e64657220776176657320656e64696e67205465737a6b USING utf8mb4),CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),'',0,0,3,0,0,65,100,15,1,6,1,0,'',0,21600,0,0,920212,-1,0,1),
(920213,1,21600,0,CONVERT(0x546865205072696365206f66204b6e6f776c65646765 USING utf8mb4),CONVERT(0x4c696272617279206d697373696f6e0a61637475616c20416b726f6d6964204372797374616c206974656d2d636c69636b206f6e207175616c696679696e6720776f756e64656420636f7272757074207363686f6c61720a74776f2062656775696c65722064656174687320616e642074686972642073757272656e6465720a447261676f6e62616e6520456e6368616e746d656e742066726f6d20436f657263657220476f7264616b0a447261676f6e62616e6520456e6368616e746d656e7420746f204a616c656460446172 USING utf8mb4),CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),'',0,0,3,0,0,65,100,15,1,6,1,0,'',0,21600,0,0,920213,-1,0,1),
(920214,1,21600,0,CONVERT(0x4465666561742074686520447261676f6e62616e65205068616c616e78 USING utf8mb4),CONVERT(0x4b75726e206d697373696f6e0a647261676f6e62616e652074726f6f7065720a4a616c656460446172 USING utf8mb4),CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),'',0,0,3,0,0,65,100,15,1,6,1,0,'',0,21600,0,0,920214,-1,0,1),
(920215,1,21600,0,CONVERT(0x416e20496d70656e65747261626c6520536869656c64 USING utf8mb4),CONVERT(0x4861746368657279206d697373696f6e0a5368696d6d6572696e6720447261676f6e62616e6520536869656c640a5368696d6d6572696e6720447261676f6e62616e6520536869656c6420746f204a616c656460446172 USING utf8mb4),CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),'',0,0,3,0,0,65,100,15,1,6,1,0,'',0,21600,0,0,920215,-1,0,1);

IF ROW_COUNT()<>19 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS tasks inserted count differs'; END IF;

IF EXISTS(SELECT 1 FROM `dynamic_zone_templates` WHERE id IN (920211,920212,920213,920214,920215)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS dynamic_zone_templates preimage not empty'; END IF;

INSERT INTO `dynamic_zone_templates` (`id`,`zone_id`,`zone_version`,`name`,`min_players`,`max_players`,`duration_seconds`,`dz_switch_id`,`compass_zone_id`,`compass_x`,`compass_y`,`compass_z`,`return_zone_id`,`return_x`,`return_y`,`return_z`,`return_h`,`override_zone_in`,`zone_in_x`,`zone_in_y`,`zone_in_z`,`zone_in_h`) VALUES
(920211,455,1,CONVERT(0x41756469656e6365207769746820746865205761726d6173746572 USING utf8mb4),1,6,21600,0,452,901.432,526.152,98.9111,452,898,428,100,262,1,25,-318,4,127),
(920212,454,1,CONVERT(0x5468652042726f6f64206f6620616e20456d7065726f72 USING utf8mb4),1,6,21600,0,452,-561.569,-1915.07,-48.5638,452,-610,-1884,-50,487,1,33.3125,0.375,4,378),
(920213,453,1,CONVERT(0x546865205072696365206f66204b6e6f776c65646765 USING utf8mb4),1,6,21600,0,452,31.629,-2215.26,-48.5638,452,27,-2168,-50,66,1,-20,-147.625,4,384),
(920214,455,2,CONVERT(0x4465666561742074686520447261676f6e62616e65205068616c616e78 USING utf8mb4),1,6,21600,0,452,901.432,526.152,98.9111,452,898,428,100,262,1,25,-318,4,127),
(920215,454,2,CONVERT(0x416e20496d70656e65747261626c6520536869656c64 USING utf8mb4),1,6,21600,0,452,-561.569,-1915.07,-48.5638,452,-610,-1884,-50,487,1,33.3125,0.375,4,378);

IF ROW_COUNT()<>5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS dynamic_zone_templates inserted count differs'; END IF;

IF EXISTS(SELECT 1 FROM `task_activities` WHERE taskid IN (920197,920198,920199,920200,920201,920202,920203,920204,920205,920206,920207,920208,920209,920210,920211,920212,920213,920214,920215)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS task_activities preimage not empty'; END IF;

INSERT INTO `task_activities` (`taskid`,`activityid`,`req_activity_id`,`step`,`activitytype`,`target_name`,`goalmethod`,`goalcount`,`description_override`,`npc_match_list`,`item_id_list`,`item_list`,`dz_switch_id`,`min_x`,`min_y`,`min_z`,`max_x`,`max_y`,`max_z`,`skill_list`,`spell_list`,`zones`,`zone_version`,`optional`,`list_group`) VALUES
(920197,0,-1,0,1,CONVERT(0x496b7361722053636f75726765205461696c20746f205365766572696c6f7573 USING utf8mb4),0,4,CONVERT(0x496b7361722053636f75726765205461696c20746f205365766572696c6f7573 USING utf8mb4),CONVERT(0x343532313038 USING utf8mb4),CONVERT(0x3838333235 USING utf8mb4),'',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920197,1,-1,0,1,CONVERT(0x4461726b656e6564204472616b6520536b756c6c20746f205365766572696c6f7573 USING utf8mb4),0,1,CONVERT(0x4461726b656e6564204472616b6520536b756c6c20746f205365766572696c6f7573 USING utf8mb4),CONVERT(0x343532313038 USING utf8mb4),CONVERT(0x3838333236 USING utf8mb4),'',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920197,2,-1,1,0,CONVERT(0x6e6563726f6d616e63657220726573706f6e7369626c6520666f722063757273656420736b756c6c20696e204b6165736f72614c696272617279 USING utf8mb4),2,1,CONVERT(0x6e6563726f6d616e63657220726573706f6e7369626c6520666f722063757273656420736b756c6c20696e204b6165736f72614c696272617279 USING utf8mb4),'','','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343533 USING utf8mb4),0,0,0),
(920197,3,-1,2,1,CONVERT(0x4461726b656e6564204472616b6520536b756c6c20746f205365766572696c6f7573 USING utf8mb4),0,1,CONVERT(0x4461726b656e6564204472616b6520536b756c6c20746f205365766572696c6f7573 USING utf8mb4),CONVERT(0x343532313038 USING utf8mb4),CONVERT(0x3838333236 USING utf8mb4),'',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920198,0,-1,0,2,CONVERT(0x536562696c697369616e2068756e746572 USING utf8mb4),0,6,CONVERT(0x536562696c697369616e2068756e746572 USING utf8mb4),CONVERT(0x343532313731 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920198,1,-1,0,0,CONVERT(0x63617263617373657320696e2074656e2d706f756e6420756e697473 USING utf8mb4),2,10,CONVERT(0x63617263617373657320696e2074656e2d706f756e6420756e697473 USING utf8mb4),'','','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920198,2,-1,1,4,CONVERT(0x5365766572696c6f7573 USING utf8mb4),0,1,CONVERT(0x5365766572696c6f7573 USING utf8mb4),CONVERT(0x343532313038 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920199,0,-1,0,0,CONVERT(0x507572696679 USING utf8mb4),2,1,CONVERT(0x507572696679 USING utf8mb4),'','','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920199,1,-1,0,0,CONVERT(0x49646c65 USING utf8mb4),2,1,CONVERT(0x49646c65 USING utf8mb4),'','','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920199,2,-1,0,0,CONVERT(0x41666f6f74 USING utf8mb4),2,1,CONVERT(0x41666f6f74 USING utf8mb4),'','','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920199,3,-1,0,0,CONVERT(0x536b756c6c USING utf8mb4),2,1,CONVERT(0x536b756c6c USING utf8mb4),'','','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920199,4,-1,1,4,CONVERT(0x506861726120446172 USING utf8mb4),0,1,CONVERT(0x506861726120446172 USING utf8mb4),CONVERT(0x343532313530 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920200,0,-1,0,2,CONVERT(0x536562696c697369616e20626f6e65636173746572 USING utf8mb4),0,2,CONVERT(0x536562696c697369616e20626f6e65636173746572 USING utf8mb4),CONVERT(0x3435323031377c3435323033397c3435323034327c3435323035317c3435323035357c3435323039327c3435323039377c3435323039387c3435323130397c3435323138347c3435323138367c3435323139377c3435323231397c3435323232357c3435323233317c3435323233347c3435323233387c3435323234317c3435323234337c3435323236367c3435323237307c3435323237347c3435323237357c3435323237377c343532323738 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920200,1,-1,0,2,CONVERT(0x536562696c697369616e20626f6e6574726f6f706572 USING utf8mb4),0,8,CONVERT(0x536562696c697369616e20626f6e6574726f6f706572 USING utf8mb4),CONVERT(0x343532303731 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920200,2,-1,1,4,CONVERT(0x4a616c656460446172 USING utf8mb4),0,1,CONVERT(0x4a616c656460446172 USING utf8mb4),CONVERT(0x343532313437 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920201,0,-1,0,2,CONVERT(0x536562696c697369616e20747261636b6572 USING utf8mb4),0,3,CONVERT(0x536562696c697369616e20747261636b6572 USING utf8mb4),CONVERT(0x3435323032317c3435323032347c343532303236 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920201,1,-1,1,0,CONVERT(0x776f756e6465642065736361706564207361726e616b20636f6e66657373696f6e USING utf8mb4),2,1,CONVERT(0x776f756e6465642065736361706564207361726e616b20636f6e66657373696f6e USING utf8mb4),'','','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920201,2,-1,2,0,CONVERT(0x5345206861746368657279 USING utf8mb4),2,1,CONVERT(0x5345206861746368657279 USING utf8mb4),'','','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920201,3,-1,3,2,CONVERT(0x736f6b6f6b61722068617463686c696e67 USING utf8mb4),0,4,CONVERT(0x736f6b6f6b61722068617463686c696e67 USING utf8mb4),CONVERT(0x343532323538 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920201,4,-1,4,4,CONVERT(0x5472616b616e6f6e USING utf8mb4),0,1,CONVERT(0x5472616b616e6f6e USING utf8mb4),CONVERT(0x343532303739 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920202,0,-1,0,2,CONVERT(0x536562696c697369616e20747261636b657273 USING utf8mb4),0,3,CONVERT(0x536562696c697369616e20747261636b657273 USING utf8mb4),CONVERT(0x3435323032317c3435323032347c343532303236 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920202,1,-1,1,0,CONVERT(0x5361726e616b20636f6e66657373696f6e206e656172323070657263656e74 USING utf8mb4),2,1,CONVERT(0x5361726e616b20636f6e66657373696f6e206e656172323070657263656e74 USING utf8mb4),'','','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920202,2,-1,2,0,CONVERT(0x4e5769736c616e646d656574696e67 USING utf8mb4),2,1,CONVERT(0x4e5769736c616e646d656574696e67 USING utf8mb4),'','','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920202,3,-1,3,2,CONVERT(0x536562696c697369616e20656d697373617279 USING utf8mb4),0,1,CONVERT(0x536562696c697369616e20656d697373617279 USING utf8mb4),CONVERT(0x343532313036 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920202,4,-1,4,4,CONVERT(0x5472616b616e6f6e USING utf8mb4),0,1,CONVERT(0x5472616b616e6f6e USING utf8mb4),CONVERT(0x343532303739 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920203,0,-1,0,2,CONVERT(0x536562696c697369616e20747261636b6572 USING utf8mb4),0,3,CONVERT(0x536562696c697369616e20747261636b6572 USING utf8mb4),CONVERT(0x3435323032317c3435323032347c343532303236 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920203,1,-1,1,0,CONVERT(0x776f756e6465642065736361706564207361726e616b20636f6e66657373696f6e USING utf8mb4),2,1,CONVERT(0x776f756e6465642065736361706564207361726e616b20636f6e66657373696f6e USING utf8mb4),'','','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920203,2,-1,2,2,CONVERT(0x536562696c697369616e20706174726f6c206c6561646572 USING utf8mb4),0,1,CONVERT(0x536562696c697369616e20706174726f6c206c6561646572 USING utf8mb4),CONVERT(0x343532303435 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920203,3,-1,3,4,CONVERT(0x5472616b616e6f6e USING utf8mb4),0,1,CONVERT(0x5472616b616e6f6e USING utf8mb4),CONVERT(0x343532303739 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920204,0,-1,0,2,CONVERT(0x62617272656c206f7220626f78206f6e204b75726e7468697264666c6f6f72 USING utf8mb4),0,8,CONVERT(0x62617272656c206f7220626f78206f6e204b75726e7468697264666c6f6f72 USING utf8mb4),CONVERT(0x3435353032307c343535303333 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343535 USING utf8mb4),0,0,0),
(920204,1,-1,1,4,CONVERT(0x5472616b616e6f6e USING utf8mb4),0,1,CONVERT(0x5472616b616e6f6e USING utf8mb4),CONVERT(0x343532303739 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920205,0,-1,0,3,CONVERT(0x466f6f74206f6620746865204d6173746572 USING utf8mb4),0,1,CONVERT(0x466f6f74206f6620746865204d6173746572 USING utf8mb4),'',CONVERT(0x3337373634 USING utf8mb4),'',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920205,1,-1,1,1,CONVERT(0x466f6f74206f6620746865204d617374657220746f20506861726120446172 USING utf8mb4),0,1,CONVERT(0x466f6f74206f6620746865204d617374657220746f20506861726120446172 USING utf8mb4),CONVERT(0x343532313530 USING utf8mb4),CONVERT(0x3337373634 USING utf8mb4),'',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920206,0,-1,0,4,CONVERT(0x5368616465206f6620546861726f66662065617274686c792072656d61696e73 USING utf8mb4),0,1,CONVERT(0x5368616465206f6620546861726f66662065617274686c792072656d61696e73 USING utf8mb4),CONVERT(0x343532303839 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920206,1,-1,1,3,CONVERT(0x536b656c6574616c2048616e64206f66204e6563726f7073792066726f6d20546861726f666620626f6e6573 USING utf8mb4),0,1,CONVERT(0x536b656c6574616c2048616e64206f66204e6563726f7073792066726f6d20546861726f666620626f6e6573 USING utf8mb4),'',CONVERT(0x3430343037 USING utf8mb4),'',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920206,2,-1,2,1,CONVERT(0x536b656c6574616c2048616e64206f66204e6563726f70737920746f20506861726120446172 USING utf8mb4),0,1,CONVERT(0x536b656c6574616c2048616e64206f66204e6563726f70737920746f20506861726120446172 USING utf8mb4),CONVERT(0x343532313530 USING utf8mb4),CONVERT(0x3430343037 USING utf8mb4),'',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920207,0,-1,0,3,CONVERT(0x496b7361722052696263616765 USING utf8mb4),0,1,CONVERT(0x496b7361722052696263616765 USING utf8mb4),'',CONVERT(0x3137333831 USING utf8mb4),'',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920207,1,-1,1,1,CONVERT(0x496b736172205269626361676520746f20506861726120446172 USING utf8mb4),0,1,CONVERT(0x496b736172205269626361676520746f20506861726120446172 USING utf8mb4),CONVERT(0x343532313530 USING utf8mb4),CONVERT(0x3137333831 USING utf8mb4),'',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920207,2,-1,2,0,CONVERT(0x5361792072696263616765202f20696d70757265207269626361676520746f2061637475616c2054616c656e646f72 USING utf8mb4),2,1,CONVERT(0x5361792072696263616765202f20696d70757265207269626361676520746f2061637475616c2054616c656e646f72 USING utf8mb4),'','','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920207,3,-1,3,1,CONVERT(0x496b736172205269626361676520746f2054616c656e646f72 USING utf8mb4),0,1,CONVERT(0x496b736172205269626361676520746f2054616c656e646f72 USING utf8mb4),CONVERT(0x343532313333 USING utf8mb4),CONVERT(0x3137333831 USING utf8mb4),'',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920207,4,-1,4,3,CONVERT(0x536562696c697369616e2046697265 USING utf8mb4),0,1,CONVERT(0x536562696c697369616e2046697265 USING utf8mb4),'',CONVERT(0x3430313533 USING utf8mb4),'',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920207,5,-1,5,1,CONVERT(0x536562696c697369616e204669726520746f2054616c656e646f72 USING utf8mb4),0,1,CONVERT(0x536562696c697369616e204669726520746f2054616c656e646f72 USING utf8mb4),CONVERT(0x343532313333 USING utf8mb4),CONVERT(0x3430313533 USING utf8mb4),'',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920207,6,-1,6,3,CONVERT(0x56697363696420546172 USING utf8mb4),0,1,CONVERT(0x56697363696420546172 USING utf8mb4),'',CONVERT(0x3530303034 USING utf8mb4),'',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920207,7,-1,7,1,CONVERT(0x5669736369642054617220746f2054616c656e646f72 USING utf8mb4),0,1,CONVERT(0x5669736369642054617220746f2054616c656e646f72 USING utf8mb4),CONVERT(0x343532313333 USING utf8mb4),CONVERT(0x3530303034 USING utf8mb4),'',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920207,8,-1,8,0,CONVERT(0x4c6976696e6720466c616d652074656d706c65 USING utf8mb4),2,1,CONVERT(0x4c6976696e6720466c616d652074656d706c65 USING utf8mb4),'','','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920207,9,-1,9,1,CONVERT(0x436f6174656420496b736172205269626361676520746f2043616c6574686f73 USING utf8mb4),0,1,CONVERT(0x436f6174656420496b736172205269626361676520746f2043616c6574686f73 USING utf8mb4),CONVERT(0x343532393138 USING utf8mb4),CONVERT(0x3337373633 USING utf8mb4),'',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920207,10,-1,10,1,CONVERT(0x507572696669656420496b736172205269626361676520746f20506861726120446172 USING utf8mb4),0,1,CONVERT(0x507572696669656420496b736172205269626361676520746f20506861726120446172 USING utf8mb4),CONVERT(0x343532313530 USING utf8mb4),CONVERT(0x3137333838 USING utf8mb4),'',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920208,0,-1,0,3,CONVERT(0x50657472696669656420536b756c6c206f6620436f6d6d616e646572204b6f74682066726f6d204f524947494e414c4669656c646f66426f6e6520756e646561 USING utf8mb4),0,1,CONVERT(0x50657472696669656420536b756c6c206f6620436f6d6d616e646572204b6f74682066726f6d204f524947494e414c4669656c646f66426f6e6520756e64656164436f6d6d616e6465724b6f7468 USING utf8mb4),'',CONVERT(0x3137323839 USING utf8mb4),'',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x3738 USING utf8mb4),0,0,0),
(920208,1,-1,1,1,CONVERT(0x50657472696669656420536b756c6c206f6620436f6d6d616e646572204b6f746820746f20506861726120446172 USING utf8mb4),0,1,CONVERT(0x50657472696669656420536b756c6c206f6620436f6d6d616e646572204b6f746820746f20506861726120446172 USING utf8mb4),CONVERT(0x343532313530 USING utf8mb4),CONVERT(0x3137323839 USING utf8mb4),'',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920209,0,-1,0,0,CONVERT(0x656d6572616c645f636f72707365 USING utf8mb4),2,1,CONVERT(0x656d6572616c645f636f72707365 USING utf8mb4),'','','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920209,1,-1,1,0,CONVERT(0x677265795f636f72707365 USING utf8mb4),2,1,CONVERT(0x677265795f636f72707365 USING utf8mb4),'','','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920209,2,-1,2,0,CONVERT(0x6b72697a6c656b USING utf8mb4),2,1,CONVERT(0x6b72697a6c656b USING utf8mb4),'','','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920209,3,-1,3,2,CONVERT(0x736562696c697369616e5f647261676f6e68756e74657273 USING utf8mb4),0,3,CONVERT(0x736562696c697369616e5f647261676f6e68756e74657273 USING utf8mb4),CONVERT(0x343532393230 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920209,4,-1,4,3,CONVERT(0x4461726b626c616465204c6f6e6773776f7264 USING utf8mb4),0,1,CONVERT(0x4461726b626c616465204c6f6e6773776f7264 USING utf8mb4),'',CONVERT(0x3137353036 USING utf8mb4),'',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920209,5,-1,5,1,CONVERT(0x4461726b626c616465204c6f6e6773776f726420746f204a616c656460446172 USING utf8mb4),0,1,CONVERT(0x4461726b626c616465204c6f6e6773776f726420746f204a616c656460446172 USING utf8mb4),CONVERT(0x343532313437 USING utf8mb4),CONVERT(0x3137353036 USING utf8mb4),'',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920210,0,-1,0,1,CONVERT(0x5669616c206f6620496b73617220426c6f6f6420746f205472616b616e6f6e USING utf8mb4),0,4,CONVERT(0x5669616c206f6620496b73617220426c6f6f6420746f205472616b616e6f6e USING utf8mb4),CONVERT(0x343532303739 USING utf8mb4),CONVERT(0x3838333035 USING utf8mb4),'',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920210,1,-1,0,1,CONVERT(0x496b73617220426f6e6520746f205472616b616e6f6e USING utf8mb4),0,4,CONVERT(0x496b73617220426f6e6520746f205472616b616e6f6e USING utf8mb4),CONVERT(0x343532303739 USING utf8mb4),CONVERT(0x3838333036 USING utf8mb4),'',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920210,2,-1,1,0,CONVERT(0x41637475616c205472616b616e6f6e20696c6c7573696f6e206b6579776f726420616e64206f726967696e616c2063617374 USING utf8mb4),2,1,CONVERT(0x41637475616c205472616b616e6f6e20696c6c7573696f6e206b6579776f726420616e64206f726967696e616c2063617374 USING utf8mb4),'','','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920210,3,-1,2,0,CONVERT(0x436f6d706c657465206f726967696e616c2047616e616b206469616c6f677565207468726f7567682073657276653b20696c6c7573696f6e2066616465732061 USING utf8mb4),2,1,CONVERT(0x436f6d706c657465206f726967696e616c2047616e616b206469616c6f677565207468726f7567682073657276653b20696c6c7573696f6e20666164657320616e6420666f75722067756172647320656e67616765 USING utf8mb4),'','','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920210,4,-1,3,2,CONVERT(0x496d70657269616c20477561726469616e204d656b7461 USING utf8mb4),0,1,CONVERT(0x496d70657269616c20477561726469616e204d656b7461 USING utf8mb4),CONVERT(0x343532313637 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920210,5,-1,3,2,CONVERT(0x496d70657269616c20477561726469616e20486573616c7974 USING utf8mb4),0,1,CONVERT(0x496d70657269616c20477561726469616e20486573616c7974 USING utf8mb4),CONVERT(0x343532313630 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920210,6,-1,3,2,CONVERT(0x496d70657269616c2041647669736f7220526573796c6172 USING utf8mb4),0,1,CONVERT(0x496d70657269616c2041647669736f7220526573796c6172 USING utf8mb4),CONVERT(0x343532313539 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920210,7,-1,3,2,CONVERT(0x496d70657269616c2041647669736f722053657374616b USING utf8mb4),0,1,CONVERT(0x496d70657269616c2041647669736f722053657374616b USING utf8mb4),CONVERT(0x343532313631 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920210,8,-1,4,4,CONVERT(0x4a616c656460446172 USING utf8mb4),0,1,CONVERT(0x4a616c656460446172 USING utf8mb4),CONVERT(0x343532313437 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920211,0,-1,0,11,CONVERT(0x4b75726e206d697373696f6e USING utf8mb4),0,1,CONVERT(0x4b75726e206d697373696f6e USING utf8mb4),'','','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343535 USING utf8mb4),1,0,0),
(920211,1,-1,1,0,CONVERT(0x666f7572205468657373696c6120677561726473206465666561746564 USING utf8mb4),2,1,CONVERT(0x666f7572205468657373696c6120677561726473206465666561746564 USING utf8mb4),'','','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343535 USING utf8mb4),1,0,0),
(920211,2,-1,2,2,CONVERT(0x5468657373696c6120746865204461726b USING utf8mb4),0,1,CONVERT(0x5468657373696c6120746865204461726b USING utf8mb4),CONVERT(0x343532393032 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343535 USING utf8mb4),1,0,0),
(920212,0,-1,0,11,CONVERT(0x4861746368657279206d697373696f6e USING utf8mb4),0,1,CONVERT(0x4861746368657279206d697373696f6e USING utf8mb4),'','','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343534 USING utf8mb4),1,0,0),
(920212,1,-1,1,2,CONVERT(0x696d70657269616c20656767 USING utf8mb4),0,21,CONVERT(0x696d70657269616c20656767 USING utf8mb4),CONVERT(0x343532393033 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343534 USING utf8mb4),1,0,0),
(920212,2,-1,2,0,CONVERT(0x646566656e64657220776176657320656e64696e67205465737a6b USING utf8mb4),2,1,CONVERT(0x646566656e64657220776176657320656e64696e67205465737a6b USING utf8mb4),'','','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343534 USING utf8mb4),1,0,0),
(920213,0,-1,0,11,CONVERT(0x4c696272617279206d697373696f6e USING utf8mb4),0,1,CONVERT(0x4c696272617279206d697373696f6e USING utf8mb4),'','','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343533 USING utf8mb4),1,0,0),
(920213,1,-1,1,0,CONVERT(0x61637475616c20416b726f6d6964204372797374616c206974656d2d636c69636b206f6e207175616c696679696e6720776f756e64656420636f727275707420 USING utf8mb4),2,1,CONVERT(0x61637475616c20416b726f6d6964204372797374616c206974656d2d636c69636b206f6e207175616c696679696e6720776f756e64656420636f7272757074207363686f6c6172 USING utf8mb4),'','','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343533 USING utf8mb4),1,0,0),
(920213,2,-1,2,0,CONVERT(0x74776f2062656775696c65722064656174687320616e642074686972642073757272656e646572 USING utf8mb4),2,3,CONVERT(0x74776f2062656775696c65722064656174687320616e642074686972642073757272656e646572 USING utf8mb4),'','','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343533 USING utf8mb4),1,0,0),
(920213,3,-1,3,3,CONVERT(0x447261676f6e62616e6520456e6368616e746d656e742066726f6d20436f657263657220476f7264616b USING utf8mb4),0,1,CONVERT(0x447261676f6e62616e6520456e6368616e746d656e742066726f6d20436f657263657220476f7264616b USING utf8mb4),'',CONVERT(0x3137333436 USING utf8mb4),'',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343533 USING utf8mb4),1,0,0),
(920213,4,-1,4,1,CONVERT(0x447261676f6e62616e6520456e6368616e746d656e7420746f204a616c656460446172 USING utf8mb4),0,1,CONVERT(0x447261676f6e62616e6520456e6368616e746d656e7420746f204a616c656460446172 USING utf8mb4),CONVERT(0x343532313437 USING utf8mb4),CONVERT(0x3137333436 USING utf8mb4),'',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920214,0,-1,0,11,CONVERT(0x4b75726e206d697373696f6e USING utf8mb4),0,1,CONVERT(0x4b75726e206d697373696f6e USING utf8mb4),'','','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343535 USING utf8mb4),2,0,0),
(920214,1,-1,1,2,CONVERT(0x647261676f6e62616e652074726f6f706572 USING utf8mb4),0,15,CONVERT(0x647261676f6e62616e652074726f6f706572 USING utf8mb4),CONVERT(0x343532393131 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343535 USING utf8mb4),2,0,0),
(920214,2,-1,2,4,CONVERT(0x4a616c656460446172 USING utf8mb4),0,1,CONVERT(0x4a616c656460446172 USING utf8mb4),CONVERT(0x343532313437 USING utf8mb4),'','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0),
(920215,0,-1,0,11,CONVERT(0x4861746368657279206d697373696f6e USING utf8mb4),0,1,CONVERT(0x4861746368657279206d697373696f6e USING utf8mb4),'','','',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343534 USING utf8mb4),2,0,0),
(920215,1,-1,1,3,CONVERT(0x5368696d6d6572696e6720447261676f6e62616e6520536869656c64 USING utf8mb4),0,1,CONVERT(0x5368696d6d6572696e6720447261676f6e62616e6520536869656c64 USING utf8mb4),'',CONVERT(0x3137343930 USING utf8mb4),'',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343534 USING utf8mb4),2,0,0),
(920215,2,-1,2,1,CONVERT(0x5368696d6d6572696e6720447261676f6e62616e6520536869656c6420746f204a616c656460446172 USING utf8mb4),0,1,CONVERT(0x5368696d6d6572696e6720447261676f6e62616e6520536869656c6420746f204a616c656460446172 USING utf8mb4),CONVERT(0x343532313437 USING utf8mb4),CONVERT(0x3137343930 USING utf8mb4),'',0,0,0,0,0,0,0,CONVERT(0x2d31 USING utf8mb4),CONVERT(0x30 USING utf8mb4),CONVERT(0x343532 USING utf8mb4),0,0,0);

IF ROW_COUNT()<>81 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS task_activities inserted count differs'; END IF;

IF EXISTS(SELECT 1 FROM `tasksets` WHERE id IN (11,12,13,14,15,16,17)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS tasksets preimage not empty'; END IF;

INSERT INTO `tasksets` (`id`,`taskid`) VALUES
(11,920198),
(12,920197),
(13,920199),
(13,920205),
(13,920206),
(13,920207),
(13,920208),
(14,920204),
(15,920211),
(15,920212),
(15,920213),
(15,920214),
(15,920215),
(16,920200),
(17,920202),
(17,920203),
(17,920201);

IF ROW_COUNT()<>17 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS tasksets inserted count differs'; END IF;

IF EXISTS(SELECT 1 FROM `reward_sets` WHERE reward_set_id IN (920197,920198,920199,920200,920201,920202,920203,920204,920205,920206,920207,920208,920209,920210,920211,920212,920213,920214,920215)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS reward_sets preimage not empty'; END IF;

INSERT INTO `reward_sets` (`reward_set_id`,`title`,`enabled`) VALUES
(920197,CONVERT(0x4472616b652053636f75726765 USING utf8mb4),1),
(920198,CONVERT(0x466f6f6420537570706c696573 USING utf8mb4),1),
(920199,CONVERT(0x546865204772616e6420496c6c7573696f6e USING utf8mb4),1),
(920200,CONVERT(0x52616973696e6720436162696c6973 USING utf8mb4),1),
(920201,CONVERT(0x5361726e616b205265636f76657279 USING utf8mb4),1),
(920202,CONVERT(0x5361726e616b205265636f76657279 USING utf8mb4),1),
(920203,CONVERT(0x5361726e616b205265636f76657279 USING utf8mb4),1),
(920204,CONVERT(0x537570706c696573 USING utf8mb4),1),
(920205,CONVERT(0x4576696c2041666f6f74 USING utf8mb4),1),
(920206,CONVERT(0x49646c652048616e6473 USING utf8mb4),1),
(920207,CONVERT(0x5075726966792074686520426f6479 USING utf8mb4),1),
(920208,CONVERT(0x54686520536b756c6c206f662074686520416e6369656e74 USING utf8mb4),1),
(920209,CONVERT(0x4c6f737420616e6420466f756e64 USING utf8mb4),1),
(920210,CONVERT(0x5061726c657920776974682047616e616b USING utf8mb4),1),
(920211,CONVERT(0x41756469656e6365207769746820746865205761726d6173746572 USING utf8mb4),1),
(920212,CONVERT(0x5468652042726f6f64206f6620616e20456d7065726f72 USING utf8mb4),1),
(920213,CONVERT(0x546865205072696365206f66204b6e6f776c65646765 USING utf8mb4),1),
(920214,CONVERT(0x4465666561742074686520447261676f6e62616e65205068616c616e78 USING utf8mb4),1),
(920215,CONVERT(0x416e20496d70656e65747261626c6520536869656c64 USING utf8mb4),1);

IF ROW_COUNT()<>19 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS reward_sets inserted count differs'; END IF;

IF EXISTS(SELECT 1 FROM `reward_options` WHERE reward_set_id IN (920197,920198,920199,920200,920201,920202,920203,920204,920205,920206,920207,920208,920209,920210,920211,920212,920213,920214,920215)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS reward_options preimage not empty'; END IF;

INSERT INTO `reward_options` (`reward_set_id`,`option_id`,`sequence`,`label`,`common_to_all`,`flags`,`enabled`,`class_mask`) VALUES
(920197,1,0,CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),1,0,1,65535),
(920198,1,0,CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),1,0,1,65535),
(920199,1,0,CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),1,0,1,65535),
(920200,1,0,CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),1,0,1,65535),
(920201,1,0,CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),1,0,1,65535),
(920202,1,0,CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),1,0,1,65535),
(920203,1,0,CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),1,0,1,65535),
(920204,1,0,CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),1,0,1,65535),
(920205,1,0,CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),1,0,1,65535),
(920206,1,0,CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),1,0,1,65535),
(920207,1,0,CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),1,0,1,65535),
(920208,1,0,CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),1,0,1,65535),
(920209,1,0,CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),1,0,1,65535),
(920210,1,0,CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),1,0,1,65535),
(920211,1,0,CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),1,0,1,65535),
(920212,1,0,CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),1,0,1,65535),
(920213,1,0,CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),1,0,1,65535),
(920214,1,0,CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),1,0,1,65535),
(920215,1,0,CONVERT(0x52696e67206f66205363616c652072657761726473 USING utf8mb4),1,0,1,65535);

IF ROW_COUNT()<>19 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS reward_options inserted count differs'; END IF;

IF EXISTS(SELECT 1 FROM `rewards` WHERE reward_id IN (3839201971,3839201972,3839201973,3839201974,3839201981,3839201982,3839201983,3839201984,3839201991,3839201992,3839201993,3839201994,3839201995,3839202001,3839202002,3839202003,3839202004,3839202011,3839202012,3839202013,3839202014,3839202021,3839202022,3839202023,3839202024,3839202031,3839202032,3839202033,3839202034,3839202041,3839202042,3839202043,3839202044,3839202051,3839202052,3839202053,3839202054,3839202061,3839202062,3839202063,3839202064,3839202071,3839202072,3839202073,3839202074,3839202081,3839202082,3839202083,3839202084,3839202091,3839202092,3839202093,3839202094,3839202101,3839202102,3839202103,3839202104,3839202111,3839202112,3839202113,3839202114,3839202121,3839202122,3839202123,3839202124,3839202131,3839202132,3839202133,3839202134,3839202141,3839202142,3839202143,3839202144,3839202151,3839202152,3839202153,3839202154)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS rewards preimage not empty'; END IF;

INSERT INTO `rewards` (`reward_id`,`reward_type`,`reward_data_id`,`amount`,`description`,`enabled`) VALUES
(3839201971,4,15,360,CONVERT(0x4368726f6e6f62696e6573 USING utf8mb4),1),
(3839201972,1,1,1,CONVERT(0x457870657269656e6365 USING utf8mb4),1),
(3839201973,6,1224,20,CONVERT(0x54796e6f632c20486572616c64206f66205363616c652066616374696f6e USING utf8mb4),1),
(3839201974,0,42757,1,CONVERT(0x496b736172204c65667420466f6f7420426f6e6573 USING utf8mb4),1),
(3839201981,4,15,45,CONVERT(0x4368726f6e6f62696e6573 USING utf8mb4),1),
(3839201982,1,1,1,CONVERT(0x457870657269656e6365 USING utf8mb4),1),
(3839201983,6,1224,10,CONVERT(0x54796e6f632c20486572616c64206f66205363616c652066616374696f6e USING utf8mb4),1),
(3839201984,0,42771,1,CONVERT(0x496b7361722052696768742055707065722041726d20426f6e6573 USING utf8mb4),1),
(3839201991,4,15,60,CONVERT(0x4368726f6e6f62696e6573 USING utf8mb4),1),
(3839201992,1,1,1,CONVERT(0x457870657269656e6365 USING utf8mb4),1),
(3839201993,6,1224,50,CONVERT(0x54796e6f632c20486572616c64206f66205363616c652066616374696f6e USING utf8mb4),1),
(3839201994,0,42763,1,CONVERT(0x496b736172204c656674205269626361676520426f6e6573 USING utf8mb4),1),
(3839201995,0,80061,1,CONVERT(0x426f6e65204d61736b206f662074686520416e6369656e7420496b736172 USING utf8mb4),1),
(3839202001,4,15,45,CONVERT(0x4368726f6e6f62696e6573 USING utf8mb4),1),
(3839202002,1,1,1,CONVERT(0x457870657269656e6365 USING utf8mb4),1),
(3839202003,6,1224,20,CONVERT(0x54796e6f632c20486572616c64206f66205363616c652066616374696f6e USING utf8mb4),1),
(3839202004,0,42768,1,CONVERT(0x496b736172205269676874204c6f7765722041726d20426f6e6573 USING utf8mb4),1),
(3839202011,4,15,45,CONVERT(0x4368726f6e6f62696e6573 USING utf8mb4),1),
(3839202012,1,1,1,CONVERT(0x457870657269656e6365 USING utf8mb4),1),
(3839202013,6,1224,20,CONVERT(0x54796e6f632c20486572616c64206f66205363616c652066616374696f6e USING utf8mb4),1),
(3839202014,0,42773,1,CONVERT(0x496b7361722048697020426f6e65 USING utf8mb4),1),
(3839202021,4,15,45,CONVERT(0x4368726f6e6f62696e6573 USING utf8mb4),1),
(3839202022,1,1,1,CONVERT(0x457870657269656e6365 USING utf8mb4),1),
(3839202023,6,1224,20,CONVERT(0x54796e6f632c20486572616c64206f66205363616c652066616374696f6e USING utf8mb4),1),
(3839202024,0,42774,1,CONVERT(0x496b736172204c656674205570706572204c656720426f6e6573 USING utf8mb4),1),
(3839202031,4,15,45,CONVERT(0x4368726f6e6f62696e6573 USING utf8mb4),1),
(3839202032,1,1,1,CONVERT(0x457870657269656e6365 USING utf8mb4),1),
(3839202033,6,1224,20,CONVERT(0x54796e6f632c20486572616c64206f66205363616c652066616374696f6e USING utf8mb4),1),
(3839202034,0,42775,1,CONVERT(0x496b736172205269676874205570706572204c656720426f6e6573 USING utf8mb4),1),
(3839202041,4,15,25,CONVERT(0x4368726f6e6f62696e6573 USING utf8mb4),1),
(3839202042,1,1,1,CONVERT(0x457870657269656e6365 USING utf8mb4),1),
(3839202043,6,1224,10,CONVERT(0x54796e6f632c20486572616c64206f66205363616c652066616374696f6e USING utf8mb4),1),
(3839202044,0,42762,1,CONVERT(0x496b736172204c656674204c6f7765722041726d20426f6e6573 USING utf8mb4),1),
(3839202051,4,15,45,CONVERT(0x4368726f6e6f62696e6573 USING utf8mb4),1),
(3839202052,1,1,1,CONVERT(0x457870657269656e6365 USING utf8mb4),1),
(3839202053,6,1224,10,CONVERT(0x54796e6f632c20486572616c64206f66205363616c652066616374696f6e USING utf8mb4),1),
(3839202054,0,42766,1,CONVERT(0x496b7361722052696768742048616e6420426f6e6573 USING utf8mb4),1),
(3839202061,4,15,140,CONVERT(0x4368726f6e6f62696e6573 USING utf8mb4),1),
(3839202062,1,1,1,CONVERT(0x457870657269656e6365 USING utf8mb4),1),
(3839202063,6,1224,10,CONVERT(0x54796e6f632c20486572616c64206f66205363616c652066616374696f6e USING utf8mb4),1),
(3839202064,0,42765,1,CONVERT(0x496b736172204c6566742048616e6420426f6e6573 USING utf8mb4),1),
(3839202071,4,15,60,CONVERT(0x4368726f6e6f62696e6573 USING utf8mb4),1),
(3839202072,1,1,1,CONVERT(0x457870657269656e6365 USING utf8mb4),1),
(3839202073,6,1224,10,CONVERT(0x54796e6f632c20486572616c64206f66205363616c652066616374696f6e USING utf8mb4),1),
(3839202074,0,42764,1,CONVERT(0x496b736172205269676874205269626361676520426f6e6573 USING utf8mb4),1),
(3839202081,4,15,45,CONVERT(0x4368726f6e6f62696e6573 USING utf8mb4),1),
(3839202082,1,1,1,CONVERT(0x457870657269656e6365 USING utf8mb4),1),
(3839202083,6,1224,10,CONVERT(0x54796e6f632c20486572616c64206f66205363616c652066616374696f6e USING utf8mb4),1),
(3839202084,0,42767,1,CONVERT(0x496b736172205461696c20426f6e6573 USING utf8mb4),1),
(3839202091,4,15,15,CONVERT(0x4368726f6e6f62696e6573 USING utf8mb4),1),
(3839202092,1,1,1,CONVERT(0x457870657269656e6365 USING utf8mb4),1),
(3839202093,6,1224,20,CONVERT(0x54796e6f632c20486572616c64206f66205363616c652066616374696f6e USING utf8mb4),1),
(3839202094,0,42769,1,CONVERT(0x496b736172204a6177626f6e65 USING utf8mb4),1),
(3839202101,4,15,45,CONVERT(0x4368726f6e6f62696e6573 USING utf8mb4),1),
(3839202102,1,1,1,CONVERT(0x457870657269656e6365 USING utf8mb4),1),
(3839202103,6,1224,20,CONVERT(0x54796e6f632c20486572616c64206f66205363616c652066616374696f6e USING utf8mb4),1),
(3839202104,0,42770,1,CONVERT(0x496b736172204c6566742055707065722041726d20426f6e6573 USING utf8mb4),1),
(3839202111,4,15,17,CONVERT(0x4368726f6e6f62696e6573 USING utf8mb4),1),
(3839202112,1,1,1,CONVERT(0x457870657269656e6365 USING utf8mb4),1),
(3839202113,6,1224,25,CONVERT(0x54796e6f632c20486572616c64206f66205363616c652066616374696f6e USING utf8mb4),1),
(3839202114,0,42872,1,CONVERT(0x54696d6573686561722052656420467261676d656e742044656e61 USING utf8mb4),1),
(3839202121,4,15,22,CONVERT(0x4368726f6e6f62696e6573 USING utf8mb4),1),
(3839202122,1,1,1,CONVERT(0x457870657269656e6365 USING utf8mb4),1),
(3839202123,6,1224,25,CONVERT(0x54796e6f632c20486572616c64206f66205363616c652066616374696f6e USING utf8mb4),1),
(3839202124,0,42870,1,CONVERT(0x54696d6573686561722052656420467261676d656e742042657a61 USING utf8mb4),1),
(3839202131,4,15,22,CONVERT(0x4368726f6e6f62696e6573 USING utf8mb4),1),
(3839202132,1,1,1,CONVERT(0x457870657269656e6365 USING utf8mb4),1),
(3839202133,6,1224,25,CONVERT(0x54796e6f632c20486572616c64206f66205363616c652066616374696f6e USING utf8mb4),1),
(3839202134,0,42869,1,CONVERT(0x54696d6573686561722052656420467261676d656e7420417a6961 USING utf8mb4),1),
(3839202141,4,15,25,CONVERT(0x4368726f6e6f62696e6573 USING utf8mb4),1),
(3839202142,1,1,1,CONVERT(0x457870657269656e6365 USING utf8mb4),1),
(3839202143,6,1224,25,CONVERT(0x54796e6f632c20486572616c64206f66205363616c652066616374696f6e USING utf8mb4),1),
(3839202144,0,42873,1,CONVERT(0x54696d6573686561722052656420467261676d656e7420456e61 USING utf8mb4),1),
(3839202151,4,15,15,CONVERT(0x4368726f6e6f62696e6573 USING utf8mb4),1),
(3839202152,1,1,1,CONVERT(0x457870657269656e6365 USING utf8mb4),1),
(3839202153,6,1224,25,CONVERT(0x54796e6f632c20486572616c64206f66205363616c652066616374696f6e USING utf8mb4),1),
(3839202154,0,42871,1,CONVERT(0x54696d6573686561722052656420467261676d656e742043617a61 USING utf8mb4),1);

IF ROW_COUNT()<>77 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS rewards inserted count differs'; END IF;

IF EXISTS(SELECT 1 FROM `reward_option_entries` WHERE reward_set_id IN (920197,920198,920199,920200,920201,920202,920203,920204,920205,920206,920207,920208,920209,920210,920211,920212,920213,920214,920215)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS reward_option_entries preimage not empty'; END IF;

INSERT INTO `reward_option_entries` (`reward_set_id`,`option_id`,`sequence`,`reward_id`) VALUES
(920197,1,0,3839201971),
(920197,1,1,3839201972),
(920197,1,2,3839201973),
(920197,1,3,3839201974),
(920198,1,0,3839201981),
(920198,1,1,3839201982),
(920198,1,2,3839201983),
(920198,1,3,3839201984),
(920199,1,0,3839201991),
(920199,1,1,3839201992),
(920199,1,2,3839201993),
(920199,1,3,3839201994),
(920199,1,4,3839201995),
(920200,1,0,3839202001),
(920200,1,1,3839202002),
(920200,1,2,3839202003),
(920200,1,3,3839202004),
(920201,1,0,3839202011),
(920201,1,1,3839202012),
(920201,1,2,3839202013),
(920201,1,3,3839202014),
(920202,1,0,3839202021),
(920202,1,1,3839202022),
(920202,1,2,3839202023),
(920202,1,3,3839202024),
(920203,1,0,3839202031),
(920203,1,1,3839202032),
(920203,1,2,3839202033),
(920203,1,3,3839202034),
(920204,1,0,3839202041),
(920204,1,1,3839202042),
(920204,1,2,3839202043),
(920204,1,3,3839202044),
(920205,1,0,3839202051),
(920205,1,1,3839202052),
(920205,1,2,3839202053),
(920205,1,3,3839202054),
(920206,1,0,3839202061),
(920206,1,1,3839202062),
(920206,1,2,3839202063),
(920206,1,3,3839202064),
(920207,1,0,3839202071),
(920207,1,1,3839202072),
(920207,1,2,3839202073),
(920207,1,3,3839202074),
(920208,1,0,3839202081),
(920208,1,1,3839202082),
(920208,1,2,3839202083),
(920208,1,3,3839202084),
(920209,1,0,3839202091),
(920209,1,1,3839202092),
(920209,1,2,3839202093),
(920209,1,3,3839202094),
(920210,1,0,3839202101),
(920210,1,1,3839202102),
(920210,1,2,3839202103),
(920210,1,3,3839202104),
(920211,1,0,3839202111),
(920211,1,1,3839202112),
(920211,1,2,3839202113),
(920211,1,3,3839202114),
(920212,1,0,3839202121),
(920212,1,1,3839202122),
(920212,1,2,3839202123),
(920212,1,3,3839202124),
(920213,1,0,3839202131),
(920213,1,1,3839202132),
(920213,1,2,3839202133),
(920213,1,3,3839202134),
(920214,1,0,3839202141),
(920214,1,1,3839202142),
(920214,1,2,3839202143),
(920214,1,3,3839202144),
(920215,1,0,3839202151),
(920215,1,1,3839202152),
(920215,1,2,3839202153),
(920215,1,3,3839202154);

IF ROW_COUNT()<>77 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS reward_option_entries inserted count differs'; END IF;

IF EXISTS(SELECT 1 FROM `reward_sources` WHERE source_type=2 AND source_id IN (920197,920198,920199,920200,920201,920202,920203,920204,920205,920206,920207,920208,920209,920210,920211,920212,920213,920214,920215)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS reward_sources preimage not empty'; END IF;

INSERT INTO `reward_sources` (`source_type`,`source_id`,`reward_set_id`,`enabled`) VALUES
(2,920197,920197,1),
(2,920198,920198,1),
(2,920199,920199,1),
(2,920200,920200,1),
(2,920201,920201,1),
(2,920202,920202,1),
(2,920203,920203,1),
(2,920204,920204,1),
(2,920205,920205,1),
(2,920206,920206,1),
(2,920207,920207,1),
(2,920208,920208,1),
(2,920209,920209,1),
(2,920210,920210,1),
(2,920211,920211,1),
(2,920212,920212,1),
(2,920213,920213,1),
(2,920214,920214,1),
(2,920215,920215,1);

IF ROW_COUNT()<>19 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS reward_sources inserted count differs'; END IF;

IF EXISTS(SELECT 1 FROM `zone_points` WHERE id IN (304066100,304066101,304066102,304066103,304066104,304066105,304066106)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS zone_points preimage not empty'; END IF;

INSERT INTO `zone_points` (`id`,`zone`,`version`,`number`,`y`,`x`,`z`,`heading`,`target_y`,`target_x`,`target_z`,`target_heading`,`zoneinst`,`target_zone_id`,`target_instance`,`buffer`,`client_version_mask`,`min_expansion`,`max_expansion`,`content_flags`,`content_flags_disabled`,`is_virtual`,`height`,`width`) VALUES
(304066100,CONVERT(0x6f6c646b6165736f726162 USING utf8mb4),1,10,0.0,0.0,0.0,0.0,-1884.0,-610.0,-50.0,487.0,0,452,0,0.0,4294967295,-1,-1,NULL,NULL,0,0,0),
(304066101,CONVERT(0x6f6c646b6165736f726162 USING utf8mb4),2,10,0.0,0.0,0.0,0.0,-1884.0,-610.0,-50.0,487.0,0,452,0,0.0,4294967295,-1,-1,NULL,NULL,0,0,0),
(304066102,CONVERT(0x6f6c646b6165736f726161 USING utf8mb4),1,10,0.0,0.0,0.0,0.0,-2168.0,27.0,-50.0,66.0,0,452,0,0.0,4294967295,-1,-1,NULL,NULL,0,0,0),
(304066103,CONVERT(0x6f6c646b75726e USING utf8mb4),1,0,0.0,0.0,0.0,0.0,428.0,898.0,100.0,262.0,0,452,0,0.0,4294967295,-1,-1,NULL,NULL,0,0,0),
(304066104,CONVERT(0x6f6c646b75726e USING utf8mb4),2,0,0.0,0.0,0.0,0.0,428.0,898.0,100.0,262.0,0,452,0,0.0,4294967295,-1,-1,NULL,NULL,0,0,0),
(304066105,CONVERT(0x6f6c646b75726e USING utf8mb4),1,10,0.0,0.0,0.0,0.0,428.0,898.0,100.0,262.0,0,452,0,0.0,4294967295,-1,-1,NULL,NULL,0,0,0),
(304066106,CONVERT(0x6f6c646b75726e USING utf8mb4),2,10,0.0,0.0,0.0,0.0,428.0,898.0,100.0,262.0,0,452,0,0.0,4294967295,-1,-1,NULL,NULL,0,0,0);

IF ROW_COUNT()<>7 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS zone_points inserted count differs'; END IF;

UPDATE zone SET min_status=0 WHERE zoneidnumber=452 AND version=0 AND min_status=80;

IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS normal-zone access preimage differs'; END IF;

UPDATE zone SET min_status=0 WHERE zoneidnumber=453 AND version=0 AND min_status=80;

IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS normal-zone access preimage differs'; END IF;

UPDATE zone SET min_status=0 WHERE zoneidnumber=454 AND version=0 AND min_status=80;

IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS normal-zone access preimage differs'; END IF;

UPDATE zone SET min_status=0 WHERE zoneidnumber=455 AND version=0 AND min_status=80;

IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS normal-zone access preimage differs'; END IF;

UPDATE zone SET min_status=0 WHERE zoneidnumber=462 AND version=0 AND min_status=80;

IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS normal-zone access preimage differs'; END IF;

IF EXISTS(SELECT 1 FROM rule_values WHERE ruleset_id=1 AND rule_name='SodProgression:EnableFieldOfScaleSlice') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS activation rule preimage not absent'; END IF;

INSERT INTO rule_values(ruleset_id,rule_name,rule_value,notes) VALUES(1,'SodProgression:EnableFieldOfScaleSlice','true','Approved Field of Scale group progression; native earned Void D and J4 gates');

IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS activation insert differs'; END IF;


  COMMIT;
  SELECT 'FOS_CONTENT_KNOWN_COMMIT' AS content_receipt,659 AS inserted_rows,
         5 AS npc_loot_CAS,5 AS zone_access_CAS;
END$$
DELIMITER ;

-- Exact applied3-row native all-enabled supplement; no player enables/history.
DELIMITER $$
BEGIN NOT ATOMIC
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
 START TRANSACTION;
-- Database wraps this fragment in one guarded transaction/procedure.

-- Three native all-enabled taskset markers; no player state or task definitions changed.

IF (SELECT COUNT(*) FROM tasksets WHERE id=11)<>1 OR (SELECT COUNT(*) FROM tasksets WHERE id=11 AND taskid IN (920198))<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS personal taskset 11 preimage differs'; END IF;

IF (SELECT COUNT(*) FROM tasksets WHERE id=13)<>5 OR (SELECT COUNT(*) FROM tasksets WHERE id=13 AND taskid IN (920199,920205,920206,920207,920208))<>5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS personal taskset 13 preimage differs'; END IF;

IF (SELECT COUNT(*) FROM tasksets WHERE id=14)<>1 OR (SELECT COUNT(*) FROM tasksets WHERE id=14 AND taskid IN (920204))<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS personal taskset 14 preimage differs'; END IF;

INSERT INTO tasksets (id,taskid) VALUES (11,0),(13,0),(14,0);

IF ROW_COUNT()<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FoS personal taskset marker inserted count differs'; END IF;

 COMMIT;
END$$
DELIMITER ;

SET SESSION sql_mode=@fos_prior_sql_mode;
