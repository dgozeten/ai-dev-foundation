#!/bin/sh
# =============================================================================
# ai-dev-foundation — Bootstrap Script
# =============================================================================
#
# This script applies the ai-dev-foundation to any existing git repository.
#
# Usage:
#   /path/to/ai-dev-foundation/foundation/scripts/init.sh
#
# Must be run from the ROOT of the target git repository.
#
# Behavior:
#   - Creates required directories
#   - Copies foundation files (rules, dev-memory, state-protocol)
#   - Will NOT overwrite existing files
#   - Commits applied files to git
#
# =============================================================================

set -e

# ---------------------------------------------------------------------------
# Resolve the foundation source directory (relative to this script)
# ---------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FOUNDATION_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# ---------------------------------------------------------------------------
# 1. Verify we are in a git repository root
# ---------------------------------------------------------------------------
if [ ! -d ".git" ]; then
    echo "ERROR: This script must be run from the root of a git repository."
    echo "       Current directory: $(pwd)"
    exit 1
fi

echo "=== ai-dev-foundation: Applying to $(pwd) ==="
echo ""

# ---------------------------------------------------------------------------
# Helper: copy a file safely (no overwrite)
# ---------------------------------------------------------------------------
safe_copy() {
    src="$1"
    dest="$2"

    if [ -f "$dest" ]; then
        echo "  SKIP (exists): $dest"
    else
        cp "$src" "$dest"
        echo "  COPY: $dest"
    fi
}

# ---------------------------------------------------------------------------
# 2. Create target directories
# ---------------------------------------------------------------------------
echo "Creating directories..."

mkdir -p .gemini
mkdir -p docs/dev-memory
mkdir -p docs/state-protocol

echo ""

# ---------------------------------------------------------------------------
# 3. Copy files
# ---------------------------------------------------------------------------
echo "Copying foundation files..."

# Rules
safe_copy "$FOUNDATION_DIR/rules/.gemini/RULES.md" ".gemini/RULES.md"
safe_copy "$FOUNDATION_DIR/rules/RULES.md"          "RULES.md"

# Dev Memory backend template
for file in "$FOUNDATION_DIR/templates/dev-memory-backend"/*; do
    filename="$(basename "$file")"
    safe_copy "$file" "docs/dev-memory/$filename"
done

# State Protocol template
for file in "$FOUNDATION_DIR/templates/state-protocol"/*; do
    filename="$(basename "$file")"
    safe_copy "$file" "docs/state-protocol/$filename"
done

echo ""

# ---------------------------------------------------------------------------
# 5. Git integration
# ---------------------------------------------------------------------------
echo "Staging and committing..."

git add .gemini/ RULES.md docs/dev-memory/ docs/state-protocol/ 2>/dev/null || true

# Only commit if there are staged changes
if git diff --cached --quiet; then
    echo ""
    echo "=== No new files to commit (foundation already applied). ==="
else
    git commit -m "chore: apply ai-dev-foundation"
    echo ""
    echo "=== ai-dev-foundation applied successfully. ==="
fi
