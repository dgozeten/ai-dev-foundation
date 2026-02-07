#!/bin/sh
# =============================================================================
# ai-dev-foundation — Bootstrap Script
# =============================================================================
#
# This script applies the ai-dev-foundation to any existing git repository.
#
# Usage:
#   /path/to/ai-dev-foundation/foundation/scripts/init.sh [OPTIONS]
#
# Options:
#   (none)       Apply rules, docs only. No database changes.
#   --with-db    Also copy migration files to migrations/foundation/
#   --run        Used with --with-db. Copy AND execute migrations.
#                Requires $DATABASE_URL and psql. Asks for confirmation.
#
# Must be run from the ROOT of the target git repository.
#
# Behavior:
#   - Creates required directories
#   - Copies foundation files (rules, dev-memory, state-protocol)
#   - Will NOT overwrite existing files
#   - Commits applied files to git
#   - Database changes are OPT-IN only
#
# =============================================================================

set -e

# ---------------------------------------------------------------------------
# Resolve the foundation source directory (relative to this script)
# ---------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FOUNDATION_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# ---------------------------------------------------------------------------
# Parse arguments
# ---------------------------------------------------------------------------
WITH_DB=false
RUN_MIGRATIONS=false
WITH_ANTIGRAVITY=false

for arg in "$@"; do
    case "$arg" in
        --with-db)      WITH_DB=true ;;
        --run)          RUN_MIGRATIONS=true ;;
        --antigravity)  WITH_ANTIGRAVITY=true ;;
        *)
            echo "ERROR: Unknown argument: $arg"
            echo "Usage: init.sh [--with-db [--run]] [--antigravity]"
            exit 1
            ;;
    esac
done

# --run requires --with-db
if [ "$RUN_MIGRATIONS" = true ] && [ "$WITH_DB" = false ]; then
    echo "ERROR: --run requires --with-db"
    echo "Usage: init.sh --with-db --run"
    exit 1
fi

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
# 3. Copy foundation files
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
# 4. Database migrations (opt-in)
# ---------------------------------------------------------------------------
if [ "$WITH_DB" = true ]; then
    echo "Copying database migrations..."
    mkdir -p migrations/foundation

    for file in "$FOUNDATION_DIR/templates/full-bootstrap/migrations"/*.sql; do
        filename="$(basename "$file")"
        safe_copy "$file" "migrations/foundation/$filename"
    done

    safe_copy "$FOUNDATION_DIR/templates/full-bootstrap/verify.sql" "migrations/foundation/verify.sql"

    echo ""

    # Run migrations if --run is specified
    if [ "$RUN_MIGRATIONS" = true ]; then
        # Validate DATABASE_URL
        if [ -z "$DATABASE_URL" ]; then
            echo "ERROR: DATABASE_URL is not set."
            echo "       Export DATABASE_URL before using --run."
            exit 1
        fi

        # Validate psql is available
        if ! command -v psql >/dev/null 2>&1; then
            echo "ERROR: psql is not installed or not in PATH."
            exit 1
        fi

        # Explicit confirmation — Decision Gate principle
        echo "========================================"
        echo "WARNING: You are about to run migrations"
        echo "against: $DATABASE_URL"
        echo "========================================"
        echo ""
        printf "Type 'yes' to confirm: "
        read -r confirm

        if [ "$confirm" != "yes" ]; then
            echo "Aborted. Migration files were copied but NOT executed."
        else
            echo ""
            echo "Running migrations..."

            for file in migrations/foundation/0*.sql; do
                echo "  EXEC: $file"
                psql "$DATABASE_URL" -f "$file"
            done

            echo ""
            echo "Running verification..."
            psql "$DATABASE_URL" -f migrations/foundation/verify.sql

            echo ""
            echo "=== Database migrations applied successfully. ==="
        fi
    else
        echo "Migration files copied. Review them, then run manually:"
        echo "  psql \$DATABASE_URL -f migrations/foundation/001_dev_memory.sql"
        echo "  psql \$DATABASE_URL -f migrations/foundation/002_state_protocol.sql"
    fi

    echo ""
fi

# ---------------------------------------------------------------------------
# 5. Antigravity integration (opt-in)
# ---------------------------------------------------------------------------
if [ "$WITH_ANTIGRAVITY" = true ]; then
    echo "Installing Antigravity integration..."

    # Workflow
    mkdir -p .agent/workflows
    safe_copy "$FOUNDATION_DIR/templates/integrations/antigravity/dev-memory-log.md" ".agent/workflows/dev-memory-log.md"

    # Antigravity-specific rules (append to .gemini/)
    safe_copy "$FOUNDATION_DIR/templates/integrations/antigravity/antigravity-rules.md" ".gemini/antigravity-rules.md"

    # Log script
    mkdir -p scripts
    safe_copy "$FOUNDATION_DIR/../scripts/log-interaction.sh" "scripts/log-interaction.sh"
    if [ -f "scripts/log-interaction.sh" ]; then
        chmod +x scripts/log-interaction.sh
    fi

    echo ""
fi

# ---------------------------------------------------------------------------
# 6. Git integration
# ---------------------------------------------------------------------------
echo "Staging and committing..."

git add .gemini/ RULES.md docs/dev-memory/ docs/state-protocol/ 2>/dev/null || true

# Also stage migrations if they were copied
if [ "$WITH_DB" = true ]; then
    git add migrations/foundation/ 2>/dev/null || true
fi

# Also stage Antigravity files if they were copied
if [ "$WITH_ANTIGRAVITY" = true ]; then
    git add .agent/workflows/ scripts/ 2>/dev/null || true
fi

# Only commit if there are staged changes
if git diff --cached --quiet; then
    echo ""
    echo "=== No new files to commit (foundation already applied). ==="
else
    git commit -m "chore: apply ai-dev-foundation"
    echo ""
    echo "=== ai-dev-foundation applied successfully. ==="
fi
