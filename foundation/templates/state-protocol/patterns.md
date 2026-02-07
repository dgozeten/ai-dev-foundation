# State Protocol — Patterns

This document describes the supported mutation patterns and when to use each.

---

## Pattern A: UPSERT (Single-Row State)

**Description:** One resource = one row. Mutations update the same row in place.
The `rev` tracks how many times the row has been mutated.

**When to use:**
- Configuration objects (settings, preferences, feature flags)
- Single-entity state (e.g., "current allocation for room X")
- Resources where only the latest state matters

**Pros:**
- Simple to implement and query
- Low storage overhead
- Natural fit for optimistic concurrency via `rev`

**Cons:**
- No built-in history — previous states are overwritten
- Requires separate audit mechanism if history is needed

**Migration implications:** Minimal — single table with `rev` column.

---

## Pattern B: History + Single-Active

**Description:** Every mutation creates a new row. One row is marked as `active`.
Previous rows are retained as immutable history.

**When to use:**
- Resources where audit trail is important
- State that needs rollback capability
- Scenarios where "what was the state at time T?" must be answerable

**Pros:**
- Full history preserved automatically
- Rollback is trivial — repoint the active marker
- Debugging is straightforward — every state transition is a row

**Cons:**
- Higher storage consumption
- Queries for "current state" require filtering by active flag
- Write amplification — every mutation inserts a row

**Migration implications:** Requires a history table or a `is_active` / `active_at` column.
Consider partitioning by time for large datasets.

---

## Pattern C: Compound Keys (`resourceId` = composite)

**Description:** The `resourceId` is composed of multiple business dimensions,
e.g., `unitId:date` or `tenantId:configKey`. Each compound key identifies
a unique mutable resource with its own `rev`.

**When to use:**
- Multi-dimensional state (e.g., per-unit-per-day pricing)
- Tenant-scoped or context-scoped configuration
- Resources where identity is inherently multi-part

**Pros:**
- Natural representation of multi-dimensional data
- Each compound key has independent concurrency control
- Avoids artificial single-ID indirection

**Cons:**
- Key composition logic must be consistent across all callers
- Index design requires care for compound key queries
- Serialization of compound keys must be deterministic

**Migration implications:** Primary key or unique constraint on the compound columns.
Ensure consistent key ordering (e.g., always `unitId:date`, never `date:unitId`).

---

## Choosing a Pattern

| Consideration | Pattern A | Pattern B | Pattern C |
|---|---|---|---|
| History needed? | ❌ | ✅ | Depends |
| Storage efficiency | ✅ High | ❌ Lower | ✅ High |
| Query simplicity | ✅ Simple | ⚠️ Filter required | ⚠️ Compound key logic |
| Rollback support | ❌ Manual | ✅ Built-in | ❌ Manual |
| Multi-dimensional identity | ❌ | ❌ | ✅ |

Patterns can be combined. For example, Pattern C (compound keys) can use
Pattern B (history) for each compound resource when audit trails are required.
