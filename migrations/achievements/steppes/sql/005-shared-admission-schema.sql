-- Optional content policy. No player state/ordinary task row changes.
SET NAMES utf8mb4;
SET SESSION check_constraint_checks=1;
CREATE TABLE IF NOT EXISTS shared_task_admission_policies (
 task_id INT UNSIGNED NOT NULL,
 late_join_min_level TINYINT UNSIGNED NOT NULL,
 enabled TINYINT UNSIGNED NOT NULL DEFAULT 0,
 PRIMARY KEY(task_id),
 CHECK(late_join_min_level BETWEEN 1 AND 255),
 CHECK(enabled IN(0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- CREATE IF NOT EXISTS is not validation. Reject an incompatible pre-existing table.
DROP TEMPORARY TABLE IF EXISTS _shared_policy_schema_guard;
CREATE TEMPORARY TABLE _shared_policy_schema_guard(ok TINYINT NOT NULL CHECK(ok=1)) ENGINE=InnoDB;
INSERT INTO _shared_policy_schema_guard VALUES(
 (SELECT COUNT(*)FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE()AND TABLE_NAME='shared_task_admission_policies'AND TABLE_TYPE='BASE TABLE'AND ENGINE='InnoDB')=1
 AND(SELECT COUNT(*)FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE()AND TABLE_NAME='shared_task_admission_policies')=3
 AND(SELECT COUNT(*)FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE()AND TABLE_NAME='shared_task_admission_policies'AND COLUMN_NAME='task_id'AND DATA_TYPE='int'AND LOCATE('unsigned',COLUMN_TYPE)>0 AND IS_NULLABLE='NO')=1
 AND(SELECT COUNT(*)FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE()AND TABLE_NAME='shared_task_admission_policies'AND COLUMN_NAME IN('late_join_min_level','enabled')AND DATA_TYPE='tinyint'AND LOCATE('unsigned',COLUMN_TYPE)>0 AND IS_NULLABLE='NO')=2
 AND(SELECT COUNT(*)FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=DATABASE()AND TABLE_NAME='shared_task_admission_policies'AND INDEX_NAME='PRIMARY')=1
 AND(SELECT COUNT(*)FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=DATABASE()AND TABLE_NAME='shared_task_admission_policies'AND INDEX_NAME='PRIMARY'AND COLUMN_NAME='task_id'AND SEQ_IN_INDEX=1)=1
);
DROP TEMPORARY TABLE _shared_policy_schema_guard;
