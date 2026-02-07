# ai-dev-foundation

A reusable AI development infrastructure foundation.

## Purpose

This repository provides the shared scaffolding and configuration layer for AI-assisted development workflows. It is **not** a product or application — it is the backbone that bootstraps consistent tooling across all projects.

## Core Modules

| Module | Description |
|---|---|
| **Decision Gate** | Template-driven checkpoints that enforce review before critical mutations |
| **Dev Memory** | Persistent context store for cross-session knowledge retention |
| **State Protocol** | Deterministic state synchronization between agent and environment |
| **Rules** | Shared rule definitions that govern agent behavior |
| **Auto Task Binding** | Automatic task context creation and binding on session start |

## Structure

```
foundation/
├── foundation.config.json   # Central configuration & feature flags
├── rules/                   # Shared rule definitions
├── scripts/
│   └── init.sh              # One-command bootstrap script
├── templates/
│   ├── dev-memory-backend/  # Dev Memory schema + API contract
│   ├── state-protocol/      # State Protocol primitives + patterns
│   └── full-bootstrap/      # Opt-in database migrations
└── patches/                 # Incremental patches for upgrades
```

## Database Bootstrap (Opt-in)

By default, `init.sh` does **not** touch your database.

| Command | Effect |
|---|---|
| `init.sh` | Rules + docs only. No DB changes. |
| `init.sh --with-db` | Also copies migration files. Does NOT execute them. |
| `init.sh --with-db --run` | Copies + executes migrations. Requires `$DATABASE_URL` and explicit confirmation. |

**Why opt-in?** Running SQL is irreversible. The Decision Gate principle applies — no mutation without explicit consent.

## License

Private — internal use only.
