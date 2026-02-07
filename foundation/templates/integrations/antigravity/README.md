# Antigravity Integration for ai-dev-foundation

This package makes Antigravity (Google Deepmind AI coding assistant)
**natively compatible** with Dev Memory logging.

When installed, Antigravity will automatically:
- Log every user request and AI response to Dev Memory
- Track which development task each interaction belongs to
- Preserve full context (timestamps, task boundaries, summaries)

---

## What Gets Installed

| File | Destination | Purpose |
|---|---|---|
| `dev-memory-log.md` | `.agent/workflows/` | Workflow Antigravity follows to log interactions |
| `antigravity-rules.md` | `.gemini/` | Rules injected into Antigravity's behavior |
| `log-interaction.sh` | `scripts/` | Shell script that POSTs to Dev Memory API |

---

## How It Works

```
User sends request
        ↓
Antigravity processes normally
        ↓
At task boundary completion, Antigravity calls:
    /dev-memory-log workflow
        ↓
Workflow calls log-interaction.sh
        ↓
log-interaction.sh POSTs to Dev Memory API
        ↓
Interaction recorded (fire-and-forget)
```

---

## Setup

From your project root:

```bash
bash /path/to/ai-dev-foundation/foundation/scripts/init.sh --antigravity
```

This copies the workflow, rules, and script. Nothing runs automatically
until you have a running Dev Memory API.

---

## Requirements

- Dev Memory API running (`POST /dev-memory/tasks/:id/interactions`)
- `DEV_MEMORY_URL` environment variable set (e.g., `http://localhost:3001`)
- `curl` available in PATH
