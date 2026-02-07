# Your AI Coding Assistant Forgets Everything. Here's How to Fix That.

*A practical framework for making AI-assisted development safe, traceable, and repeatable.*

---

Every morning, you open your AI coding assistant. You explain the project. You set the rules. You tell it not to delete working code. You tell it to wait for approval.

And then the session resets.

Tomorrow, it will forget all of it. The rules you spent 20 minutes explaining? Gone. The database schema it was supposed to respect? It will hallucinate new column names. The function you told it never to touch? Rewritten from scratch.

**This is the fundamental flaw of AI-assisted development:** the AI forgets.

Not sometimes. Always.

---

## The Cost of Forgetting

If you've used Cursor, Copilot, Windsurf, or any AI coding tool seriously, you've hit these:

- The AI "cleaned up" a function that took you 3 hours to write
- It invented a database column that doesn't exist
- It silently changed an API response shape that broke your mobile app
- It committed a real API key as an "example"
- It refactored 12 files when you asked for a one-line fix

These aren't edge cases. They're the default behavior when AI operates without persistent constraints.

---

## What If Rules Survived Session Resets?

That's the core idea behind **[ai-dev-foundation](https://github.com/dgozeten/ai-dev-foundation)** — an open-source infrastructure layer I built to make AI-assisted development predictable.

It's not a framework. It's not a library. It's a set of **rules, protocols, and schemas** that you drop into any project. The AI reads them on every session start. No conversation memory needed.

Here's what it enforces:

### 1. Decision Gate — No Code Without Permission

Before writing a single line, the AI must produce:

1. **Task Summary** — what is being done
2. **Scope Decision** — frontend, backend, or fullstack
3. **Blast Radius** — which files, databases, and integrations are affected
4. **Source of Truth Check** — is shared state persisted correctly?
5. **Tests & Verification** — at least one smoke test, curl, or unit plan
6. **Secrets & Safety** — are there tokens in the diff?
7. **Safe Defaults** — is the new feature opt-in and backward compatible?
8. **Proof / Assumptions** — grep results or labeled assumptions
9. **Approval Request** — explicit "may I proceed?"

No step can be skipped. The AI waits for a human to say "yes."

This isn't a suggestion. It's enforced through a `RULES.md` file that lives in the repository — not in chat memory.

### 2. Code Preservation — Never Delete Working Code

This one rule alone would have saved me dozens of hours:

> *When adding new functionality, the AI MUST NOT modify, remove, rename, or refactor existing working code unless the change is explicitly part of the approved scope.*

No "cleaning up." No "simplifying." No merging two working functions into one because it looks "better."

This rule is enforced at two levels:
- **File-based:** `RULES.md` in the repository
- **Database-backed:** A `foundation_invariants` table that the AI checks before every mutation

Even if the AI doesn't load the rules file, the database tells it: *don't touch existing code.*

### 3. Dev Memory — Decisions That Survive

A database-backed system that records:

- What development tasks were performed
- What AI interactions occurred (prompts and responses)
- What changes were made and why

So when you come back in 3 months and ask "why was this endpoint designed this way?" — there's an actual answer. Not a guess. Not a hallucination. A timestamped record of the decision.

The foundation includes a **runnable Fastify server** that you can spin up with one command and an **Antigravity integration** for automatic prompt/response logging.

### 4. Safety Hardening — Six Rules AI Must Follow

Every implementation must pass six mandatory checks:

| Rule | What It Prevents |
|---|---|
| **Blast Radius** | Changes spreading across >5 files, DB, critical modules, or API contracts without acknowledgment |
| **Source of Truth** | UI managing shared state without backend persistence |
| **Minimum Test Bar** | Shipping with zero verification |
| **Secrets Hygiene** | Committing tokens or logging API keys |
| **Safe Defaults** | Breaking existing behavior with new features |
| **Hallucination Guard** | AI inventing file paths or DB columns that don't exist |

The Hallucination Guard is worth calling out: if the AI references a file, table, or endpoint, it must either **show grep proof** or **label it as an assumption and stop.** No more invented paths.

### 5. Backlog Discipline — Ideas ≠ Implementations

AI loves to "improve things while it's in there." This leads to silent scope creep.

The rule is simple: if the AI detects an improvement opportunity, it goes to `BACKLOG.md`. The human decides if and when it gets implemented. The AI cannot self-authorize any improvement.

---

## How It Works in Practice

```bash
# Clone the foundation
git clone https://github.com/dgozeten/ai-dev-foundation.git

# Apply to your project (rules + docs only)
bash /path/to/ai-dev-foundation/foundation/scripts/init.sh

# Or go full stack: server + DB + automatic logging
bash init.sh --with-server --with-db --antigravity
```

That single command copies:
- AI behavior rules (`RULES.md`)
- Safety documentation
- Implementation checklists
- Optionally: a runnable Dev Memory server with PostgreSQL schema

The AI reads the rules on session start. Every session. No reminding needed.

---

## When NOT to Use This

Be honest about scope. This adds structure that slows you down — intentionally.

Don't use it for:
- Throwaway scripts
- One-day proof of concepts
- Solo experiments you'll never return to

Use it when the project **matters** — when decisions need to survive, when AI behavior needs to be governed, and when you can't afford a silent `rm -rf` disguised as a refactor.

---

## The Uncomfortable Truth

We've been treating AI coding assistants like junior developers who just need better prompts.

They're not.

They're **stateless execution engines** operating on volatile context. Every session is a blank slate. Every conversation starts from zero. The only way to make their behavior reliable is to make the rules **persistent, enforceable, and non-negotiable.**

That's what this foundation does.

It doesn't make AI smarter. It makes software development safer.

---

**GitHub:** [github.com/dgozeten/ai-dev-foundation](https://github.com/dgozeten/ai-dev-foundation)
**License:** MIT — use it, fork it, adapt it.

*If you've ever lost code to an AI "improvement," you know why this exists.*
