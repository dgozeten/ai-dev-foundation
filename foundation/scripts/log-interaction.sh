#!/bin/sh
# =============================================================================
# log-interaction.sh — Post an interaction to the Dev Memory API
# =============================================================================
#
# Usage:
#   bash scripts/log-interaction.sh \
#     --task-id <uuid> \
#     --role <human|ai|system> \
#     --content "summary of the interaction"
#
# Environment:
#   DEV_MEMORY_URL  — Base URL of the Dev Memory API (required)
#
# Behavior:
#   - POSTs to /dev-memory/tasks/:id/interactions
#   - Fire-and-forget: exits 0 even on failure
#   - Prints warnings on failure, never errors
#
# =============================================================================

set -e

# ---------------------------------------------------------------------------
# Parse arguments
# ---------------------------------------------------------------------------
TASK_ID=""
ROLE=""
CONTENT=""

while [ $# -gt 0 ]; do
    case "$1" in
        --task-id) TASK_ID="$2"; shift 2 ;;
        --role)    ROLE="$2";    shift 2 ;;
        --content) CONTENT="$2"; shift 2 ;;
        *)
            echo "WARN [dev-memory]: Unknown argument: $1" >&2
            shift
            ;;
    esac
done

# ---------------------------------------------------------------------------
# Validate
# ---------------------------------------------------------------------------
if [ -z "$DEV_MEMORY_URL" ]; then
    # No URL configured — skip silently (expected in projects without Dev Memory)
    exit 0
fi

if [ -z "$TASK_ID" ]; then
    echo "WARN [dev-memory]: No --task-id provided, skipping log" >&2
    exit 0
fi

if [ -z "$ROLE" ]; then
    echo "WARN [dev-memory]: No --role provided, skipping log" >&2
    exit 0
fi

# ---------------------------------------------------------------------------
# Build JSON payload
# ---------------------------------------------------------------------------
TIMESTAMP="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

# Escape content for JSON (basic: replace newlines and quotes)
ESCAPED_CONTENT="$(printf '%s' "$CONTENT" | sed 's/\\/\\\\/g; s/"/\\"/g' | tr '\n' ' ')"

PAYLOAD="$(cat <<EOF
{
  "role": "$ROLE",
  "content": "$ESCAPED_CONTENT",
  "context": {
    "source": "antigravity",
    "logged_at": "$TIMESTAMP"
  }
}
EOF
)"

# ---------------------------------------------------------------------------
# POST to Dev Memory API (fire-and-forget)
# ---------------------------------------------------------------------------
URL="${DEV_MEMORY_URL}/dev-memory/tasks/${TASK_ID}/interactions"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
    -X POST \
    -H "Content-Type: application/json" \
    -d "$PAYLOAD" \
    --connect-timeout 3 \
    --max-time 5 \
    "$URL" 2>/dev/null) || true

if [ -n "$HTTP_CODE" ] && [ "$HTTP_CODE" -ge 200 ] && [ "$HTTP_CODE" -lt 300 ] 2>/dev/null; then
    : # Success — silent
elif [ -n "$HTTP_CODE" ] && [ "$HTTP_CODE" != "000" ]; then
    echo "WARN [dev-memory]: Log failed with HTTP $HTTP_CODE for task $TASK_ID" >&2
else
    echo "WARN [dev-memory]: Could not reach Dev Memory API at $URL" >&2
fi

# Always exit 0 — logging must never fail the caller
exit 0
