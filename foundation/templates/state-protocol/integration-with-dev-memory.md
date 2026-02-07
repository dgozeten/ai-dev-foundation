# State Protocol — Integration with Dev Memory

## How State Protocol Mutations Connect to Dev Memory

When a mutation is executed under the State Protocol, it SHOULD be logged
into the Dev Memory system for development-time traceability.

---

## What to Log

After a successful mutation, the following can be recorded as a Dev Memory interaction:

| Field | Value |
|---|---|
| `task_id` | The active development task (if one exists) |
| `role` | `"state-protocol"` |
| `content` | Summary of the mutation (resource, action, new rev) |
| `context` | `{ requestId, resourceId, rev, timestamp }` |

---

## Logging Rules

### 1. Fire-and-Forget

Dev Memory logging MUST be asynchronous and non-blocking.
The mutation response is returned to the caller **before** the Dev Memory write completes.

### 2. Dev Memory Failures MUST NOT Block Mutations

If the Dev Memory write fails:
- The mutation is still considered successful.
- A warning MAY be logged to the application logger.
- The mutation MUST NOT be rolled back.
- The caller MUST NOT receive an error.

### 3. No Active Task = No Log

If there is no active development task in the current context,
the Dev Memory log is silently skipped. This is expected behavior
in production or in sessions where Dev Memory is not enabled.

### 4. Optional but Recommended

This integration is opt-in. Projects that do not use Dev Memory
can ignore this entirely. However, for projects that use both
State Protocol and Dev Memory, enabling this integration provides:

- A timeline of all state mutations during development
- Correlation between AI decisions and state changes
- Post-session auditability without relying on chat memory
