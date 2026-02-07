# State Protocol — Foundation Template

## What Is State Protocol?

State Protocol is a **framework-agnostic standard** for performing safe, predictable state mutations. It ensures that every write operation is:

- **Idempotent** — repeating the same request produces the same result
- **Revision-tracked** — every mutation increments a version counter
- **Conflict-aware** — concurrent writes are detected and rejected, not silently merged

## Problems It Solves

| Problem | Without State Protocol | With State Protocol |
|---|---|---|
| Double writes | Silent data corruption | Idempotency via `requestId` — second write is a no-op |
| Stale UI overwrites | User A's changes lost when User B saves | `expectedRev` mismatch returns 409 Conflict |
| Retry storms | Duplicate records, inconsistent state | Same `requestId` → same result, no duplication |
| Race conditions | Last write wins, data loss | Optimistic concurrency rejects stale writes |
| Debugging mutations | "Who changed this and when?" | Every mutation produces a revision with traceable context |

## Why "Last Write Wins" Is Dangerous

"Last write wins" silently discards data. The second writer has no idea they overwrote
someone else's changes. In AI-assisted development, where multiple agents or parallel
processes may mutate state, this is catastrophic.

State Protocol makes conflicts **explicit** — they surface as errors, not silent data loss.

## What State Protocol Is NOT

- ❌ **Not a business rule system.** It governs *how* writes happen, not *what* is valid.
- ❌ **Not an ORM.** It defines a contract, not a data access layer.
- ❌ **Not transport-specific.** It works over HTTP, WebSocket, RPC, or any other channel.
- ❌ **Not auth-aware.** Authentication and authorization are orthogonal concerns.
