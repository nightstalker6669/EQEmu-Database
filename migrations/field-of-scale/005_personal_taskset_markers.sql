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
