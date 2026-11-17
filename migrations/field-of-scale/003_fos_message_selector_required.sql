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
