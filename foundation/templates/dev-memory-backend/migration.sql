-- Dev Memory Schema
-- PostgreSQL-compatible
-- No foreign keys to application tables

-- =============================================================================
-- development_tasks
-- =============================================================================

CREATE TABLE IF NOT EXISTS development_tasks (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title       TEXT NOT NULL,
    description TEXT,
    status      TEXT NOT NULL DEFAULT 'open',
    changes     JSONB DEFAULT '[]'::jsonb,
    context     JSONB DEFAULT '{}'::jsonb,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_development_tasks_created_at ON development_tasks (created_at DESC);
CREATE INDEX idx_development_tasks_status     ON development_tasks (status);

-- =============================================================================
-- ai_interactions
-- =============================================================================

CREATE TABLE IF NOT EXISTS ai_interactions (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id     UUID NOT NULL,
    role        TEXT NOT NULL,
    content     TEXT,
    context     JSONB DEFAULT '{}'::jsonb,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_ai_interactions_task_id    ON ai_interactions (task_id);
CREATE INDEX idx_ai_interactions_created_at ON ai_interactions (created_at DESC);
