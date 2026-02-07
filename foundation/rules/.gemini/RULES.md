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
