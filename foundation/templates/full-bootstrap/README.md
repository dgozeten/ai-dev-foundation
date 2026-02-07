# Full Bootstrap — Opt-in Database Schema

## Overview

This template provides **optional** database migrations for Dev Memory and State Protocol.

**By default, nothing touches your database.** Migrations are only applied when you explicitly request them.

---

## Why Opt-in?

- Not every project needs a database for dev tooling
- Running SQL against a database is a **destructive, irreversible action**
- The Decision Gate principle applies: **no mutation without explicit consent**

---

## Contents

| File | Purpose |
|---|---|
| `migrations/001_dev_memory.sql` | `development_tasks` and `ai_interactions` tables |
| `migrations/002_state_protocol.sql` | `idempotency_keys` table for mutation deduplication |
| `migrations/003_example_rev_columns.sql` | Example `rev`-based column patterns (reference only) |
| `verify.sql` | Verification query to confirm schema was applied correctly |

---

## How to Use

### Option A: Copy migrations only (review before running)

```bash
/path/to/ai-dev-foundation/foundation/scripts/init.sh --with-db
```

This copies migration files to `migrations/foundation/` in your project.
**Nothing is executed.** You review and run them yourself.

### Option B: Copy + run migrations

```bash
/path/to/ai-dev-foundation/foundation/scripts/init.sh --with-db --run
```

This copies the files AND executes them against `$DATABASE_URL`.
**Requires explicit confirmation before execution.**

---

## Rollback

These tables are isolated — no foreign keys to your application.
To remove:

```sql
DROP TABLE IF EXISTS ai_interactions;
DROP TABLE IF EXISTS development_tasks;
DROP TABLE IF EXISTS idempotency_keys;
```

Then delete the migration files from your project.

---

## Requirements

- PostgreSQL (compatible with 12+)
- `$DATABASE_URL` environment variable (only for `--run`)
- `psql` CLI tool (only for `--run`)
