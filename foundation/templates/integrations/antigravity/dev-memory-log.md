---
description: Log AI interactions to Dev Memory after completing a task
---

# Dev Memory Interaction Log

This workflow logs the current interaction to the Dev Memory API.
It is called automatically at the end of task boundary completions.

## Prerequisites

- `DEV_MEMORY_URL` environment variable must be set
- `scripts/log-interaction.sh` must exist in the project
- A Dev Memory API must be running and reachable

## Steps

1. Check if `DEV_MEMORY_URL` is set. If not, skip silently.

2. Check if an active development task exists. If not, skip silently.

3. Log the user request:
// turbo
```bash
bash scripts/log-interaction.sh \
  --task-id "$ACTIVE_TASK_ID" \
  --role "human" \
  --content "$USER_REQUEST_SUMMARY"
```

4. Log the AI response:
// turbo
```bash
bash scripts/log-interaction.sh \
  --task-id "$ACTIVE_TASK_ID" \
  --role "ai" \
  --content "$AI_RESPONSE_SUMMARY"
```

5. If either log call fails, print a warning but do NOT stop execution.

## Important

- This workflow MUST NOT block any other workflow or task.
- If Dev Memory is unreachable, continue normally.
- Never retry failed log attempts.
- Never throw errors from this workflow.
