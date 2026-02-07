# Dev Memory — Integration Notes

## How to Plug This Into a Project

1. **Run the migration.**
   Execute `migration.sql` against your development/staging database.
   These tables have no foreign keys to your application — they are fully isolated.

2. **Implement the endpoints.**
   Use `api-contract.md` as your specification.
   Mount them under `/dev-memory/` or any prefix you choose.

3. **Gate access appropriately.**
   Dev Memory endpoints should be accessible in development and staging only.
   They MUST NOT be exposed in production unless explicitly intended.

---

## AI Interaction Logging

Logging AI interactions is **optional but strongly recommended**.

When enabled, every request/response cycle between the AI and the system
is recorded against the active development task. This provides:

- Full traceability of AI-driven changes
- Ability to replay or audit AI decisions after the fact
- Context that survives chat resets and session boundaries

To enable: call `POST /dev-memory/tasks/:id/interactions` after each
meaningful AI interaction within your development tooling.

---

## State Protocol Integration

The **State Protocol** (defined separately in this foundation) can hook into
Dev Memory to:

- Record state snapshots alongside tasks
- Track revision numbers that correspond to development milestones
- Provide deterministic reconnection context

This integration is optional and will be defined in a future foundation step.

---

## Critical Rule

> **Dev Memory MUST NEVER block business logic.**
>
> - If Dev Memory is down, the application continues normally.
> - If a Dev Memory write fails, it fails silently or logs a warning — never throws.
> - Dev Memory is a development aid, not a runtime dependency.
> - No application feature may depend on Dev Memory data.
