# AI Interaction Logging — Integration Guide

This guide explains how to wire up automatic prompt/response logging
in your project using the Dev Memory `ai_interactions` table.

Nothing in this guide is mandatory. Logging is opt-in.
Your application must work identically with or without it.

---

## Overview

Every time your system exchanges a message with an AI (prompt in, response out),
that exchange can be recorded in Dev Memory for traceability.

This allows you to answer:
- What did the AI suggest?
- What prompt produced that output?
- Which development task was active at the time?
- What context was provided?

---

## When to Log

Log an interaction when:
- A user or system sends a prompt to an AI provider
- The AI returns a response
- A development task is active (optional but recommended)

Do NOT log:
- Health checks or ping requests
- Automated retries of the same prompt (use `requestId` for deduplication)
- Production user-facing AI features (this is for development traceability, not product analytics)

---

## What to Log

Each interaction maps to `POST /dev-memory/tasks/:id/interactions`:

```
{
  "role": "human" | "ai" | "system",
  "content": "<the prompt or response text>",
  "context": {
    "provider": "openai | anthropic | google | other",
    "model": "gpt-4 | claude-3 | gemini-pro | ...",
    "token_count": 1234,
    "duration_ms": 850,
    "request_id": "uuid-for-deduplication"
  }
}
```

**Rules:**
- `role: "human"` → the prompt sent to the AI
- `role: "ai"` → the response received from the AI
- `role: "system"` → system prompts or injected context
- You may log prompt and response as two separate interactions, or combine them into one. Choose one convention and be consistent.

---

## Integration Pattern (Pseudocode)

The following is framework-agnostic pseudocode. Adapt to your stack.

```
function callAI(prompt, taskId):
    response = aiProvider.send(prompt)

    // Fire-and-forget — do NOT await this
    logInteraction(taskId, "human", prompt)
    logInteraction(taskId, "ai", response)

    return response


function logInteraction(taskId, role, content):
    try:
        POST /dev-memory/tasks/{taskId}/interactions
        body: { role, content, context: { provider, model, timestamp } }
    catch error:
        // Log warning, do NOT throw
        console.warn("Dev Memory log failed:", error.message)
```

**Critical rules:**
1. `logInteraction` must be **fire-and-forget** — never block the AI response
2. If the log fails, the caller must **not** receive an error
3. If no `taskId` is active, skip logging silently

---

## Middleware Approach

If your project uses a middleware pattern (Express, Koa, NestJS interceptors, etc.),
you can create a middleware that wraps AI calls:

```
Pseudocode:

middleware aiLoggingMiddleware(request, response, next):
    originalResponse = next()

    if activeDevTask exists:
        fire-and-forget:
            log(activeDevTask.id, "human", request.prompt)
            log(activeDevTask.id, "ai", originalResponse.content)

    return originalResponse
```

This keeps logging concerns separate from business logic.

---

## What NOT to Do

- **Do NOT log synchronously.** If the log blocks the AI call, you have a runtime dependency on Dev Memory. This violates the foundation principle.
- **Do NOT log in production.** This is development infrastructure. Gate it with an environment check.
- **Do NOT store sensitive data.** If prompts contain secrets, API keys, or PII, sanitize before logging.
- **Do NOT retry failed logs.** A missed log entry is acceptable. A retry storm is not.

---

## Verification

After wiring up logging, verify by:

1. Making an AI call with an active dev task
2. Querying: `GET /dev-memory/tasks/:id/interactions`
3. Confirming both the prompt and response appear in chronological order

If the interactions table is empty but your AI calls succeed, logging is silently failing.
Check your `logInteraction` error handler for suppressed warnings.
