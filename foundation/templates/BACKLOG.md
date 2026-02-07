# Backlog — Decision Buffer

Nothing in this file may be implemented without explicit human approval.

---

## What This Backlog Is

This backlog is a record of things that were **consciously not implemented**.

Every item here represents a risk, concern, idea, or improvement that was identified during development — and deliberately set aside. These are not forgotten. They are deferred.

The backlog exists to prevent premature action. It is a decision buffer between "this might be worth doing" and "we are doing this now."

Items enter the backlog when they are detected. They leave only when a human explicitly approves them for implementation.

## What This Backlog Is NOT

- **Not a task list.** Tasks are approved work. Backlog items are unapproved.
- **Not a bug tracker.** Bugs are defects that need fixing. Backlog items are choices that need making.
- **Not a TODO list.** TODOs imply intent to act. Backlog items carry no such promise.
- **Not a future roadmap.** Some items here may never be implemented. That is acceptable.

---

## Backlog Item Format

Every backlog item must follow this exact structure:

```
BACKLOG ITEM:
- ID: BACKLOG-NNN
- Title:
- Category: (architecture | safety | scalability | UX | performance | tech-debt)
- Detected by: (human | AI)
- Context:
- Why this exists:
- Why NOT now:
- Risk if implemented now:
- Risk if never implemented:
- Suggested revisit condition:
- Status: (open | acknowledged | rejected | approved-for-implementation)
```

**Rules:**

- Every field is mandatory. No field may be left blank.
- The `Status` field controls the lifecycle. Only `approved-for-implementation` permits work to begin.
- Items with status `open` or `acknowledged` must not result in any code, migration, or behavioral change.

---

## Decision Gate Rule

The following rules govern who may do what with backlog items:

**AI may:**
- Identify potential backlog items during development
- Document backlog items using the format above
- Recommend revisit conditions

**AI must NOT:**
- Implement any backlog item
- Begin preparatory work for a backlog item
- Refactor code in anticipation of a backlog item
- Treat a backlog item as an implicit approval

**Only a human may move an item to implementation.** The following phrases constitute explicit approval:

- "Implement this"
- "Do it now"
- "Move this to active development"

Any other phrasing — including "sounds good", "interesting", or "maybe later" — does **not** constitute approval.

---

## Relationship to Other Systems

This backlog exists alongside two other foundation systems. Each has a distinct role:

| System | What It Tracks |
|---|---|
| **Dev Memory** | What happened — decisions made, context recorded |
| **State Protocol** | How changes happen — safe, idempotent, conflict-aware mutations |
| **Backlog** | What must NOT happen yet — deferred decisions awaiting approval |

Dev Memory looks backward. State Protocol governs the present. The backlog protects the future.

Backlog protects the system from premature correctness.

---

## Items

### BACKLOG-001

```
BACKLOG ITEM:
- ID: BACKLOG-001
- Title: Introduce event sourcing for Dev Memory
- Category: architecture
- Detected by: AI
- Context: Dev Memory currently uses mutable rows with PATCH updates on task status.
- Why this exists: Event sourcing would provide a complete, immutable history of every state transition — not just the latest state.
- Why NOT now: The current schema is sufficient for v1.0. Event sourcing adds storage complexity, requires a projection layer, and changes the query model. The foundation is not yet adopted widely enough to justify this overhead.
- Risk if implemented now: Over-engineering. Increased onboarding friction. Migration complexity for existing adopters.
- Risk if never implemented: Acceptable. Mutable state with Dev Memory logging provides adequate traceability for most projects.
- Suggested revisit condition: When more than 3 active projects use Dev Memory and report insufficient history granularity.
- Status: open
```

### BACKLOG-002

```
BACKLOG ITEM:
- ID: BACKLOG-002
- Title: Add a visual dashboard for backlog and Dev Memory
- Category: UX
- Detected by: AI
- Context: All foundation data is currently accessed via SQL queries or raw markdown files.
- Why this exists: A lightweight web UI could make backlog review, Dev Memory browsing, and task inspection more accessible to non-technical stakeholders.
- Why NOT now: This foundation is explicitly infrastructure-only. Adding a frontend introduces framework dependencies, build tooling, and maintenance burden that contradict the "no framework assumptions" principle.
- Risk if implemented now: Scope creep. The foundation becomes a product instead of a protocol. Framework lock-in.
- Risk if never implemented: Low. Technical users can query data directly. If adoption grows, a separate UI project can consume the APIs without modifying the foundation.
- Suggested revisit condition: When a team requests visual access and is willing to own the frontend as a separate project.
- Status: open
```
