-- =============================================================================
-- 002_state_protocol.sql
-- State Protocol schema — idempotency_keys
-- =============================================================================

CREATE TABLE IF NOT EXISTS idempotency_keys (
    request_id   UUID PRIMARY KEY,
    resource_id  VARCHAR(255) NOT NULL,
    response     JSONB NOT NULL,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_idempotency_keys_resource_id
    ON idempotency_keys (resource_id);

CREATE INDEX IF NOT EXISTS idx_idempotency_keys_created_at
    ON idempotency_keys (created_at DESC);
