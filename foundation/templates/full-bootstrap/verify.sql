-- =============================================================================
-- verify.sql
-- Run after migrations to confirm schema was applied correctly
-- =============================================================================

SELECT 'Checking development_tasks...' AS step;
SELECT COUNT(*) AS development_tasks_exists
FROM information_schema.tables
WHERE table_name = 'development_tasks';

SELECT 'Checking ai_interactions...' AS step;
SELECT COUNT(*) AS ai_interactions_exists
FROM information_schema.tables
WHERE table_name = 'ai_interactions';

SELECT 'Checking idempotency_keys...' AS step;
SELECT COUNT(*) AS idempotency_keys_exists
FROM information_schema.tables
WHERE table_name = 'idempotency_keys';

SELECT 'Verification complete.' AS step;
