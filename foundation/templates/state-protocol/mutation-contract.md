# State Protocol — Mutation Contract

This document defines the standard contract for all state mutations
governed by the State Protocol.

---

## Input

Every mutation request MUST include:

| Field | Type | Required | Purpose |
|---|---|---|---|
| `requestId` | UUID | ✅ | Idempotency key — prevents duplicate processing |
| `resourceId` | string | ✅ | Target resource identifier |
| `expectedRev` | integer | ❌ | Optimistic concurrency — reject if stale |
| `payload` | object | ✅ | The mutation data (content varies by resource) |

---

## Behavior

### 1. Idempotency Check

Before processing, the server checks whether `requestId` has been seen before.

- **If seen:** Return the original result. Do NOT re-execute.
- **If not seen:** Proceed to conflict detection.

### 2. Conflict Detection

If `expectedRev` is provided:

- **If `expectedRev` matches current `rev`:** Proceed with mutation.
- **If mismatch:** Reject with conflict signal (409). Return the current `rev` and resource state so the caller can reconcile.

If `expectedRev` is omitted: skip conflict detection.

### 3. Mutation Execution

Apply the mutation atomically:

- Update the resource state
- Increment `rev` by 1
- Record `requestId` for future idempotency checks
- Set `updated_at` timestamp

### 4. No Silent Overwrite

The server MUST NOT:
- Silently merge conflicting writes
- Silently drop fields
- Silently ignore `expectedRev` mismatches
- Apply partial mutations without explicit support

---

## Output

Every successful mutation MUST return:

| Field | Type | Description |
|---|---|---|
| `ok` | boolean | `true` if mutation succeeded |
| `resource` | object | Full snapshot of the resource after mutation |
| `rev` | integer | The new revision number |
| `requestId` | UUID | Echo of the original `requestId` |

### On Conflict (409)

| Field | Type | Description |
|---|---|---|
| `ok` | boolean | `false` |
| `error` | string | `"CONFLICT"` |
| `currentRev` | integer | The actual current revision |
| `resource` | object | Current resource state for reconciliation |

### On Idempotent Replay

| Field | Type | Description |
|---|---|---|
| `ok` | boolean | `true` |
| `resource` | object | The resource snapshot from the original execution |
| `rev` | integer | The revision from the original execution |
| `replay` | boolean | `true` — indicates this is a replayed response |
