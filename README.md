# ai-dev-foundation

The default starting point for serious AI-assisted software projects.

**Version:** v1.0.0 · **Status:** Stable foundation

---

## What Is This?

`ai-dev-foundation` is an opinionated infrastructure layer that makes AI-assisted development **safe, traceable, and repeatable**.

It is not a framework. It is not a library. It is a set of **rules, protocols, and schemas** that you apply to any backend project so that AI operates under explicit constraints — not conversational goodwill.

## What Problem Does It Solve?

AI coding assistants suffer from a fundamental flaw: they forget.

Every new session starts from zero. Decisions evaporate. Context is lost. Rules established in one conversation do not survive into the next. The result is unpredictable behavior, silent overwrites, and untraceable mutations.

This foundation solves that by making critical behavior **persistent and enforceable**:

| Problem | How This Foundation Addresses It |
|---|---|
| AI forgets past decisions | **Dev Memory** persists development context in a database |
| AI acts without permission | **Decision Gate** requires explicit human approval before any mutation |
| AI silently overwrites state | **State Protocol** enforces revision tracking and conflict detection |
| Rules exist only in chat | **Repository rules** survive session resets, contributor changes, and AI swaps |
| Mutations are untraceable | Every change is logged with context — who, what, why |

## What This Is NOT

- Not an application framework
- Not a backend or frontend scaffold
- Not an ORM, auth system, or deployment tool
- Not tied to any specific AI provider
- Not a product — it is infrastructure

---

## Core Concepts

### Decision Gate

Before the AI writes any code, it must produce:

1. Task Summary
2. Scope Decision
3. Impact Analysis
4. Risk Analysis
5. Alternatives
6. Explicit approval request

No step may be skipped. The AI waits for human approval before proceeding. This is enforced via `RULES.md`, not conversation memory.

### Dev Memory

A database-backed system that records:

- What development tasks were performed
- What AI interactions occurred
- What changes were made and why

Dev Memory is **not** a production audit log. It exists for development-time traceability — so that "why was this written this way?" has an answer even after the chat is gone.

### State Protocol

A framework-agnostic standard for safe state mutations:

- **Idempotency** via `requestId` — retries are safe
- **Revision tracking** via `rev` — every mutation increments a version
- **Optimistic concurrency** via `expectedRev` — stale writes are rejected, not silently merged

"Last write wins" is not acceptable. State Protocol makes conflicts explicit.

---

## Quick Start

### 1. Apply the foundation to any project

```bash
git clone https://github.com/dgozeten/ai-dev-foundation.git
cd your-project
bash /path/to/ai-dev-foundation/foundation/scripts/init.sh
```

This copies:
- AI behavior rules → `.gemini/RULES.md` and `RULES.md`
- Dev Memory documentation → `docs/dev-memory/`
- State Protocol documentation → `docs/state-protocol/`

No database changes. No dependencies. No framework assumptions.

### 2. Optional: include database migrations

```bash
bash /path/to/ai-dev-foundation/foundation/scripts/init.sh --with-db
```

This copies migration files to `migrations/foundation/` in your project. **Nothing is executed.** You review them and run manually.

### 3. Optional: copy and run migrations

```bash
bash /path/to/ai-dev-foundation/foundation/scripts/init.sh --with-db --run
```

Requires `$DATABASE_URL` and `psql`. Asks for explicit `"yes"` confirmation before executing.

---

## When NOT to Use This

Be honest about scope. This foundation adds overhead that is not justified for:

- **Throwaway scripts** — if the code lives for a day, traceability is irrelevant
- **One-day proof of concepts** — decision gates slow down exploration by design
- **Projects without persistence** — Dev Memory and State Protocol assume a database exists (or will exist)
- **UI-only demos** — this is backend infrastructure; purely frontend work does not benefit
- **Solo experiments with no continuity** — if you will never return to the project, there is nothing to remember

Use this when the project **matters** — when decisions need to survive, when AI behavior needs to be governed, and when mutations must be traceable.

---

## Release Philosophy

- **Additive rules only.** Existing rules are never weakened or removed — only refined or extended.
- **Database migrations are always opt-in.** The default bootstrap never touches your database.
- **No silent breaking changes.** If a change would break an existing project using this foundation, it is documented, versioned, and requires explicit adoption.
- **Stability over features.** This is infrastructure. It must be boring, predictable, and reliable.

---

## Project Structure

```
ai-dev-foundation/
├── README.md
├── README-TR.md
├── .gitignore
└── foundation/
    ├── foundation.config.json
    ├── rules/
    │   ├── RULES.md                           # Pointer file
    │   └── .gemini/
    │       └── RULES.md                       # Source of truth for AI behavior
    ├── scripts/
    │   └── init.sh                            # One-command bootstrap
    ├── templates/
    │   ├── dev-memory-backend/                # Schema + API contract
    │   ├── state-protocol/                    # Primitives + patterns
    │   └── full-bootstrap/                    # Opt-in DB migrations
    └── patches/
```

---

## License

Private — internal use only.
