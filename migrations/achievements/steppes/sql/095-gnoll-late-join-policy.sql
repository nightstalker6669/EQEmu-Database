-- Reviewed historical exception included after task activation.
-- Request and every initial member remain governed by tasks.min_level55.
-- Only late invite/join minimum changes to54. Below54 and initial54 are unproved.
-- Apply only after schema preflight and matched world/zone build with datetime prerequisite.
-- Explicit same-session @steppes_shared_policy_reviewed=1 required. Never use --force.
SET NAMES utf8mb4;
SET SESSION check_constraint_checks=1;
DROP TEMPORARY TABLE IF EXISTS _shared_policy_guard;
CREATE TEMPORARY TABLE _shared_policy_guard(ok TINYINT NOT NULL CHECK(ok=1))ENGINE=InnoDB;
START TRANSACTION;
SET @steppes_shared_policy_ok=COALESCE(@steppes_shared_policy_reviewed,0)=1
 AND(SELECT COUNT(*)FROM tasks WHERE id=3040606 AND type=1 AND BINARY title=BINARY'Sweeping the Steppes: Gnolls'AND min_level=55 AND max_level=0 AND repeatable=1 AND enabled=1)=1
 AND NOT EXISTS(SELECT 1 FROM shared_task_admission_policies WHERE task_id=3040606 AND NOT(late_join_min_level=54 AND enabled IN(0,1)));
INSERT INTO _shared_policy_guard VALUES(COALESCE(@steppes_shared_policy_ok,0));
INSERT INTO shared_task_admission_policies(task_id,late_join_min_level,enabled)
 SELECT 3040606,54,1 WHERE @steppes_shared_policy_ok=1
 ON DUPLICATE KEY UPDATE enabled=IF(@steppes_shared_policy_ok=1,VALUES(enabled),enabled);
COMMIT;
SET @steppes_shared_policy_ok=NULL;
DROP TEMPORARY TABLE _shared_policy_guard;
