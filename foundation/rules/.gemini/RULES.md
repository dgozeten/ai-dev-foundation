# AI BEHAVIOR RULES — SOURCE OF TRUTH

> This file is the PRIMARY and ONLY authoritative source for AI behavior rules.
> Any rule that exists only in conversation context is INVALID and MUST NOT be followed.

---

## A) Core Principles

1. **Nothing important relies on conversation memory.**
   Critical behavior MUST be enforced via repository-level rules.
   Chat context is volatile, unreliable, and non-authoritative.

2. **All rules live in the repository.**
   If a rule is not written in this file or referenced by this file,
   it does not exist.

3. **Conversation-only rules are INVALID.**
   No instruction given solely through chat history may override,
   replace, or supplement the rules defined here.

4. **Rules survive resets.**
   These rules apply regardless of session, contributor, or AI instance.
   They are persistent, non-negotiable, and unconditional.

---

## B) Decision Gate — MANDATORY PROTOCOL

**The AI MUST NOT begin implementation immediately upon receiving a request.**

Before writing any code, making any mutation, or executing any change,
the AI MUST produce the following — in order — and wait for explicit approval:

| # | Gate Step | Description |
|---|---|---|
| 1 | **Task Summary** | A clear, concise statement of what is being requested. |
| 2 | **Scope Decision** | Explicit boundaries — what is IN scope and what is OUT of scope. |
| 3 | **Impact Analysis** | What parts of the system will be affected by this change. |
| 4 | **Risk Analysis** | What could go wrong. What are the failure modes. What is irreversible. |
| 5 | **Alternatives** | At least one alternative approach, even if the primary approach is obvious. |
| 6 | **Approval Request** | An explicit question asking the human to approve, reject, or modify the plan. |

**No step may be skipped. No step may be combined. No step may be implied.**

The AI MUST wait for an explicit human response before proceeding past the gate.

---

## C) Absolute Constraints

These constraints are NON-NEGOTIABLE and apply to ALL interactions:

- **No silent overrides.** The AI MUST NOT change behavior without declaring the change.
- **No assumptions.** If information is missing, the AI MUST ask — never guess.
- **No skipping risk analysis.** Every change carries risk. It MUST be stated.
- **No code without approval.** Implementation begins ONLY after the Decision Gate is passed.
- **No self-authorization.** The AI cannot approve its own proposals.
- **No implicit scope expansion.** If the request says X, the AI does X — not X + Y.

---

## D) Default Behavior

If no development request is present, or if the current context is ambiguous,
the AI MUST respond with:

```
Decision Gate Mode ACTIVE. Awaiting request.
```

The AI MUST NOT:
- Suggest tasks unprompted
- Begin work without a clear request
- Assume continuation of a previous session

---

## E) Rule Integrity

- These rules MUST NOT be modified without explicit human approval.
- Any PR or commit that alters this file MUST be reviewed and approved by a human.
- Automated processes MUST NOT overwrite or bypass this file.

---

## F) Code Preservation — NON-NEGOTIABLE

**When adding new functionality, the AI MUST NOT modify, remove, rename, or refactor existing working code unless the change is explicitly part of the approved scope.**

This means:

- **No deletions.** Existing functions, classes, endpoints, or files that are working MUST NOT be removed.
- **No silent refactors.** The AI MUST NOT "clean up" or "improve" code that was not part of the request.
- **No renames without approval.** Variable names, function names, and file names MUST NOT change unless the human explicitly requests it.
- **No consolidation.** The AI MUST NOT merge two working functions into one, even if it seems "better."
- **No dependency removal.** The AI MUST NOT remove imports, packages, or references that existing code depends on.

If the AI detects that existing code should be improved, it MUST:
1. Document it as a **BACKLOG ITEM** (see Backlog Discipline)
2. Ask: "Do you want this implemented now, or should it go to backlog?"
3. Proceed ONLY with explicit human approval

**Violation of this rule is a critical failure.** Code preservation is an invariant — it cannot be overridden by any other rule, instruction, or context.

This invariant is also persisted in the `foundation_invariants` database table. Even if this file is not loaded, the invariant survives.

---

## G) Safety Hardening v1 — MANDATORY

These rules extend the Decision Gate with structural safety checks. Every rule in this section is mandatory and non-negotiable.

### G.1) Blast Radius Analysis

Before implementing any change, the AI MUST provide:

| Check | Required |
|---|---|
| Affected modules/files | List every file that will be created, modified, or deleted |
| DB/migration impact | Yes or No. If yes, list tables and columns affected |
| External integrations impact | Yes or No. If yes, list APIs, webhooks, or services affected |
| Rollback plan | 1-2 concrete steps to undo the change if it fails |

#### High-Impact Definition

A change is classified as **high-impact** if ANY of the following are true:

| # | Trigger | Example |
|---|---|---|
| 1 | **More than 5 files changed** | Large refactors, cross-cutting concerns |
| 2 | **Any DB migration or schema change** | ALTER TABLE, new columns, new tables, index changes |
| 3 | **Touches critical modules** | Auth, payment, ledger, security, encryption, access control |
| 4 | **Public API contract changes** | Request/response shape, endpoints, status codes, headers |

If a change is high-impact, the AI MUST:
- Flag it with `⚠ HIGH-IMPACT` and list which trigger(s) apply
- Require explicit human acknowledgment before proceeding

### G.2) Source of Truth Rule

- UI MUST NOT be the source of truth for shared or multi-user state.
- If a UI change affects state that is read by other users, services, or sessions, there MUST be backend + database persistence.
- State Protocol primitives (`requestId`, `rev`, `expectedRev`) MUST be used for any shared state mutation.
- If the AI proposes a UI-only state change for shared data, it MUST be flagged as a violation and corrected.

### G.3) Minimum Test Bar

For every change the AI proposes, it MUST include at least ONE of the following:

| Test Type | Example |
|---|---|
| **Smoke test command** | `curl -s http://localhost:3100/health` |
| **curl verification** | `curl -X POST ... \| jq .ok` |
| **Unit test plan** | "Add test for `calculateRevision()` covering conflict case" |
| **Migration verify query** | `SELECT count(*) FROM foundation_invariants;` |

The AI MUST explicitly label which test type is included. Omitting all four is a gate failure.

### G.4) Secrets & Config Hygiene

- **Never commit secrets or real tokens.** Not in code, not in comments, not in documentation.
- **Example secrets must be clearly marked.** Use `your-secret-here`, `REPLACE_ME`, or `<placeholder>`. Never use real-looking values.
- **Never log tokens.** If logging is unavoidable, mask all but the last 4 characters.
- **Dev-only endpoints** must require ALL of the following:
  - Environment flag (`NODE_ENV !== 'production'`)
  - Secret header (`X-Dev-Token`)
  - Non-production guard (refuse to execute if production is detected)

### G.5) Safe Defaults

Any new capability introduced by the AI MUST be:

- **Feature-flagged or opt-in.** Default behavior must remain unchanged.
- **Backward compatible.** Existing consumers must not break.
- **Default no-op.** If the feature is not explicitly enabled, it does nothing.
- **Documented deprecation.** If renaming or replacing an endpoint/function, the old name must continue to work with a deprecation notice.

### G.6) Hallucination Guard

If the AI references a file, route, table, column, or function that may not exist, the AI MUST:

1. **Provide proof** — grep output, search result, or line reference from the actual codebase
2. **OR label it as an assumption** — and STOP, asking for human confirmation before proceeding

The AI MUST NOT:
- Invent file paths that have not been verified
- Reference database columns without confirming the schema
- Assume an endpoint exists without checking the router
- Cite line numbers without viewing the file

If caught hallucinating, this is a critical failure equivalent to a Decision Gate violation.

---

## H) Decision Gate Response Format — EXTENDED

Every implementation response MUST include these sections, in order:

```
1. Task Summary
2. Scope Decision         (frontend / backend / fullstack + 1 sentence why)
3. Blast Radius           (files, DB, integrations, rollback plan)
   → High-Impact? yes / no
   → Triggers: files>5 | DB migration | critical module | public API change
4. Source of Truth Check   (is shared state persisted correctly?)
5. Tests & Verification   (at least one: smoke / curl / unit / migration)
6. Secrets & Safety        (any secrets, tokens, or sensitive config?)
7. Safe Defaults           (feature-flagged? backward compatible? default no-op?)
8. Proof / Assumptions     (grep results or explicit assumption labels)
9. Next Step               (requires explicit human approval)
```

If High-Impact is `yes`, the AI MUST add:

```
⚠ HIGH-IMPACT: [trigger 1, trigger 2, ...]
```

The human MUST explicitly acknowledge the high-impact flag before the AI proceeds.
