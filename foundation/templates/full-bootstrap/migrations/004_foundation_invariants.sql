-- =============================================================================
-- 004_foundation_invariants.sql
-- Database-backed invariants that AI must check before any mutation
-- =============================================================================

CREATE TABLE IF NOT EXISTS foundation_invariants (
    id          TEXT PRIMARY KEY,
    title       TEXT NOT NULL,
    description TEXT NOT NULL,
    category    TEXT NOT NULL CHECK (category IN ('preservation', 'safety', 'governance', 'integrity')),
    severity    TEXT NOT NULL DEFAULT 'critical' CHECK (severity IN ('critical', 'warning', 'advisory')),
    active      BOOLEAN NOT NULL DEFAULT true,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_invariants_active ON foundation_invariants (active) WHERE active = true;
CREATE INDEX IF NOT EXISTS idx_invariants_category ON foundation_invariants (category);

-- =============================================================================
-- Seed: Code Preservation Invariant
-- =============================================================================

INSERT INTO foundation_invariants (id, title, description, category, severity)
VALUES (
    'INV-001',
    'Code Preservation',
    'When adding new functionality, AI MUST NOT modify, remove, rename, or refactor existing working code unless the change is explicitly part of the approved scope. No deletions, no silent refactors, no renames without approval, no consolidation, no dependency removal. Violation is a critical failure.',
    'preservation',
    'critical'
)
ON CONFLICT (id) DO NOTHING;

-- =============================================================================
-- Seed: Decision Gate Invariant
-- =============================================================================

INSERT INTO foundation_invariants (id, title, description, category, severity)
VALUES (
    'INV-002',
    'Decision Gate Required',
    'AI MUST NOT begin implementation without completing the full Decision Gate protocol (Task Summary, Scope, Impact, Risk, Alternatives, Approval). No step may be skipped, combined, or implied.',
    'governance',
    'critical'
)
ON CONFLICT (id) DO NOTHING;

-- =============================================================================
-- Seed: Backlog Discipline Invariant
-- =============================================================================

INSERT INTO foundation_invariants (id, title, description, category, severity)
VALUES (
    'INV-003',
    'Backlog Discipline',
    'AI MUST NOT implement improvements, refactors, or enhancements that are not explicitly approved. Detected improvements must be documented as BACKLOG ITEMs and require explicit human approval before implementation.',
    'governance',
    'critical'
)
ON CONFLICT (id) DO NOTHING;
