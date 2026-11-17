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
