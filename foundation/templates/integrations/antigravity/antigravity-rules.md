# Antigravity — Dev Memory Integration Rules

These rules extend the base RULES.md with Antigravity-specific behavior
for automatic interaction logging.

---

## Automatic Logging Rule

When operating in a project that has Dev Memory enabled:

1. At the END of each task boundary (after `notify_user` or task completion),
   Antigravity MUST log the interaction summary to Dev Memory.

2. The log entry MUST include:
   - The user's request (summarized, not verbatim if too long)
   - The AI's response summary (what was done, not full output)
   - The active task ID (if one exists)
   - Timestamp

3. Logging MUST be fire-and-forget:
   - If `DEV_MEMORY_URL` is not set → skip silently
   - If the API is unreachable → warn and continue
   - If the POST fails → warn and continue
   - Never block task completion for logging

---

## Invariant Pre-Check Rule

Before ANY code mutation (creating, editing, or deleting files), Antigravity MUST:

1. Call `GET $DEV_MEMORY_URL/invariants/check`
2. Read all returned invariants
3. Verify that the planned mutation does NOT violate any invariant
4. If a violation is detected → STOP and report the violation to the human
5. If the API is unreachable → fall back to RULES.md invariants (Section F)

This check is non-negotiable. The database is the final authority on active invariants.

---

## Task Binding Rule

When Antigravity starts a new session in a project with Dev Memory:

1. Check if an active development task exists
2. If yes → bind to it (use its ID for logging)
3. If no → create a new task via `POST /dev-memory/tasks` and bind to it
4. If Dev Memory is unavailable → work normally without logging

---

## What NOT to Log

- File contents or full code blocks (too large, use summaries)
- Sensitive data (API keys, passwords, tokens)
- Automated health checks or status polls
- Duplicate entries from retried tool calls
