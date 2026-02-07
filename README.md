# ai-dev-foundation

The default starting point for serious AI-assisted software projects.

> *This foundation does not make AI smarter. It makes software development safer.*

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
| AI deletes working code | **Code Preservation** invariant — never remove existing code without approval |
| Rules exist only in chat | **Repository rules** survive session resets, contributor changes, and AI swaps |
| AI hallucinates file paths | **Hallucination Guard** requires proof (grep/search) or labeled assumptions |
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

Before the AI writes any code, it must produce — in order:

1. Task Summary
2. Scope Decision (frontend / backend / fullstack)
3. Blast Radius (files, DB, integrations, rollback)
4. Source of Truth Check
5. Tests & Verification
6. Secrets & Safety
7. Safe Defaults
8. Proof / Assumptions
9. Approval Request

No step may be skipped. The AI waits for human approval before proceeding. This is enforced via `RULES.md`, not conversation memory.

### Dev Memory

A database-backed system that records:

- What development tasks were performed
- What AI interactions occurred (prompts and responses)
- What changes were made and why

Dev Memory schema and API contract are included free. **[Pro]** includes a runnable Fastify server and Antigravity-native integration for automatic logging.

### State Protocol

A framework-agnostic standard for safe state mutations:

- **Idempotency** via `requestId` — retries are safe
- **Revision tracking** via `rev` — every mutation increments a version
- **Optimistic concurrency** via `expectedRev` — stale writes are rejected, not silently merged

"Last write wins" is not acceptable. State Protocol makes conflicts explicit.

### Code Preservation

AI must never delete, rename, or refactor existing working code unless explicitly approved. This rule is enforced at two levels:
- **File-based:** `RULES.md` Section F (included)
- **Database-backed:** `foundation_invariants` table **[Pro]** — survives even if rules are not loaded

### Safety Hardening v1

Six mandatory safety checks added to every implementation:

| Rule | What It Prevents |
|---|---|
| **Blast Radius Analysis** | Uncontrolled changes — high-impact if: >5 files, DB migration, critical module, or API contract change |
| **Source of Truth** | UI managing shared state without backend persistence |
| **Minimum Test Bar** | Shipping changes with zero verification |
| **Secrets Hygiene** | Committing tokens, logging keys, exposing dev endpoints |
| **Safe Defaults** | Breaking existing behavior with new features |
| **Hallucination Guard** | AI inventing file paths, routes, or columns that don't exist |

Full details: [docs/SAFETY.md](./docs/SAFETY.md) · Checklist: [docs/CHANGE_CHECKLIST.md](./docs/CHANGE_CHECKLIST.md)

### Backlog Discipline

AI must not implement every improvement it detects. Detected ideas go to a **decision buffer** (`BACKLOG.md`) and require explicit human approval before implementation.

---

## 🔒 Pro — Runnable Infrastructure

The free foundation gives you **rules and documentation.** The Pro tier gives you the **infrastructure that enforces them automatically.**

| Feature | Free | Pro |
|---|---|---|
| Decision Gate rules | ✅ | ✅ |
| Safety Hardening docs | ✅ | ✅ |
| Code Preservation rule | ✅ | ✅ |
| Backlog Discipline template | ✅ | ✅ |
| Change Checklist | ✅ | ✅ |
| Dev Memory Server (Fastify + pg) | — | ✅ |
| Antigravity integration | — | ✅ |
| Database-backed invariants | — | ✅ |
| `GET /invariants/check` endpoint | — | ✅ |
| Implementation Checklist template | — | ✅ |
| Fire-and-forget log script | — | ✅ |

**[⭐ Become a Sponsor → Get Pro](https://github.com/sponsors/dgozeten)**

---

## Quick Start

### 1. Clone the foundation

```bash
git clone https://github.com/dgozeten/ai-dev-foundation.git
```

### 2. Apply to your project

From **your project's root** (must be a git repo):

```bash
bash /path/to/ai-dev-foundation/foundation/scripts/init.sh
```

This copies rules and documentation only. No database, no server, no dependencies.

### 3. Pick your level

| Command | What It Does |
|---|---|
| `init.sh` | Rules + docs only |
| `init.sh --with-db` | + Copy migration SQL files (review before running) |
| `init.sh --with-db --run` | + Execute migrations immediately (`$DATABASE_URL` + `psql` required) |

> **[Pro]** Sponsors get the runnable Dev Memory server, Antigravity integration, and database-backed invariants. [Become a Sponsor →](https://github.com/sponsors/dgozeten)

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
ai-dev-foundation/                             # 🟢 FREE — Public
├── README.md
├── README-TR.md
├── LICENSE
├── docs/
│   ├── OVERVIEW.md                            # Mental model + flow diagram
│   ├── SAFETY.md                              # Safety Hardening v1 rules
│   └── CHANGE_CHECKLIST.md                    # Mandatory implementation checklist
└── foundation/
    ├── foundation.config.json
    ├── rules/
    │   ├── RULES.md                           # Pointer file
    │   └── .gemini/
    │       └── RULES.md                       # Source of truth (A-H sections)
    ├── scripts/
    │   └── init.sh                            # One-command bootstrap
    ├── templates/
    │   ├── BACKLOG.md                         # Decision buffer template
    │   ├── dev-memory-backend/                # Schema + API contract
    │   ├── state-protocol/                    # Primitives + patterns
    │   └── full-bootstrap/                    # Opt-in DB migrations
    └── patches/
```

```
ai-dev-foundation-pro/                         # 🔒 PRO — Sponsors only
├── dev-memory-server/                         # Runnable Fastify + pg server
├── migrations/                                # Foundation invariants SQL
├── integrations/antigravity/                  # Automatic logging workflow
├── templates/                                 # Implementation checklist
└── log-interaction.sh                         # Fire-and-forget logger
```

---

## License

MIT License — see [LICENSE](./LICENSE).
