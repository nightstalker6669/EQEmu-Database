-- Reviewed activation for an existing standard mercenary catalogue.
-- Operator: set this ruleset to the one your server actually uses.
SET @mercenary_ruleset_id = 1;
INSERT INTO rule_values (ruleset_id,rule_name,rule_value,notes) VALUES
 (@mercenary_ruleset_id,'Mercs:AllowMercs','true','Enable native mercenary hiring and management'),
 (@mercenary_ruleset_id,'Mercs:MaxMercenaries','3','Explicit emulator roster-capacity policy; one active contract, no marketplace entitlement inference'),
 (@mercenary_ruleset_id,'Mercs:ScaleAboveContentLevel','true','Explicit level86-100 scaling fallback when exact standard content rows are absent')
ON DUPLICATE KEY UPDATE rule_value=VALUES(rule_value),notes=VALUES(notes);
-- Only standard seeded liaisons bearing the intended title become class71.
-- Do not change arbitrary guards, custom merchants, expansion filtering or prices.
UPDATE npc_types n JOIN merc_merchant_entries m ON m.merchant_id=n.id
 SET n.class=71 WHERE n.class<>71 AND n.lastname LIKE '%Mercenary Liaison';
