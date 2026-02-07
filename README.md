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
├── scripts/                 # Automation & bootstrap scripts
├── templates/               # Decision gate & workflow templates
└── patches/                 # Incremental patches for upgrades
```

## License

Private — internal use only.
