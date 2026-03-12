#!/bin/bash

# MachinEdge Expert Teams — List Available Experts
# Usage: ./list-experts.sh [experts-dir]
#
# Walks expert directories and prints a formatted summary of each expert,
# including role name, description, and available skills.
#
# If no experts-dir is given, resolves from the repo root.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Resolve experts directory
if [ -n "$1" ]; then
    EXPERTS_DIR="$1"
else
    REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null || true)"
    if [ -z "$REPO_ROOT" ]; then
        REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
    fi
    EXPERTS_DIR="$REPO_ROOT/experts"
fi

if [ ! -d "$EXPERTS_DIR" ]; then
    echo "Error: experts directory not found at $EXPERTS_DIR"
    exit 1
fi

echo "MachinEdge Expert Teams — Available Experts"
echo "============================================"
echo ""

FOUND=0
for domain_dir in "$EXPERTS_DIR"/*/; do
    [ -d "$domain_dir" ] || continue
    for expert_dir in "$domain_dir"*/; do
        [ -d "$expert_dir" ] || continue
        expert=$(basename "$expert_dir")
        [ "$expert" = "shared" ] && continue

        role_file="$expert_dir/role.md"
        [ -f "$role_file" ] || continue

        # Skip empty role files
        if [ ! -s "$role_file" ]; then
            echo "$expert (under development)"
            echo ""
            FOUND=$((FOUND + 1))
            continue
        fi

        # Extract heading (first line starting with "# ")
        heading=$(grep -m1 '^# ' "$role_file" | sed 's/^# //')

        # Extract description (first non-blank line after the heading)
        description=$(awk 'NR>1 && /^.+$/ {print; exit}' "$role_file")

        # Extract skills (lines matching "- `/command`" between "## Skills" and next "##")
        skills=$(awk '/^## Skills$/,/^## [^S]/' "$role_file" | grep -E '^\- `/' || true)

        echo "$expert ($heading)"
        if [ -n "$description" ]; then
            echo "  $description"
        fi
        if [ -n "$skills" ]; then
            echo "  Skills:"
            echo "$skills" | sed 's/^- /    /'
        fi
        echo ""
        FOUND=$((FOUND + 1))
    done
done

if [ "$FOUND" -eq 0 ]; then
    echo "No experts found under $EXPERTS_DIR"
    exit 1
fi

echo "Total: $FOUND expert(s)"
