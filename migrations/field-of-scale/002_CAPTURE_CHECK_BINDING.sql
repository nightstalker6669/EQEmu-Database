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
