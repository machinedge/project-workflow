#!/bin/bash

# AI Project Toolkit — Setup
# Usage: ./setup.sh [--editor claude|cursor|both] [project-directory]
#
# Copies editor config and commands into a project directory.
# Commands are maintained once in this toolkit and copied to the
# right location for each editor.
#
# Examples:
#   ./setup.sh                          # Both editors, current directory
#   ./setup.sh --editor cursor ~/myproj # Cursor only
#   ./setup.sh --editor claude ~/myproj # Claude Code only
#   ./setup.sh ~/myproj                 # Both editors (default)

set -e

# Resolve the directory where this script lives (the toolkit root)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Parse arguments
EDITOR="both"
TARGET="."

while [[ $# -gt 0 ]]; do
    case $1 in
        --editor)
            EDITOR="$2"
            shift 2
            ;;
        *)
            TARGET="$1"
            shift
            ;;
    esac
done

# Validate editor value
if [[ ! "$EDITOR" =~ ^(claude|cursor|both)$ ]]; then
    echo "Error: --editor must be 'claude', 'cursor', or 'both' (got '$EDITOR')"
    exit 1
fi

# Validate commands source directory exists
if [ ! -d "$SCRIPT_DIR/commands" ]; then
    echo "Error: commands directory not found at $SCRIPT_DIR/commands"
    exit 1
fi

if [ "$TARGET" != "." ]; then
    mkdir -p "$TARGET"
fi

echo "Setting up project toolkit in: $TARGET (editor: $EDITOR)"

# ─────────────────────────────────────────────
# Shared docs directory
# ─────────────────────────────────────────────

mkdir -p "$TARGET/docs/tasks"
mkdir -p "$TARGET/docs/handoff-notes"

if [ ! -f "$TARGET/docs/lessons-log.md" ]; then
cat > "$TARGET/docs/lessons-log.md" << 'DOC_EOF'
# Lessons Log

## Things the AI Does Well on This Project
- [to be filled in as you learn]

## Things the AI Struggles With on This Project
- [to be filled in]

## Prompting Lessons
- [what phrasing gets better results]

## Technical Gotchas
- [bugs, API quirks, environment issues]

## Process Adjustments
- [changes to how you run sessions]
DOC_EOF
fi

# ─────────────────────────────────────────────
# Claude Code setup
# editor.md is copied as-is to .claude/CLAUDE.md
# ─────────────────────────────────────────────

if [ "$EDITOR" = "claude" ] || [ "$EDITOR" = "both" ]; then
    echo "  Setting up Claude Code (.claude/)..."
    mkdir -p "$TARGET/.claude/commands"
    cp "$SCRIPT_DIR/editor.md" "$TARGET/.claude/CLAUDE.md"
    cp "$SCRIPT_DIR"/commands/*.md "$TARGET/.claude/commands/"
fi

# ─────────────────────────────────────────────
# Cursor setup
# editor.md + YAML frontmatter → .cursor/rules/project-os.mdc
# ─────────────────────────────────────────────

if [ "$EDITOR" = "cursor" ] || [ "$EDITOR" = "both" ]; then
    echo "  Setting up Cursor (.cursor/)..."
    mkdir -p "$TARGET/.cursor/rules"
    mkdir -p "$TARGET/.cursor/commands"

    # Prepend Cursor's frontmatter to the shared editor rules
    {
        printf '%s\n' "---"
        printf '%s\n' "description: Project operating system — multi-session project management protocol"
        printf '%s\n' "alwaysApply: true"
        printf '%s\n' "---"
        printf '\n'
        cat "$SCRIPT_DIR/editor.md"
    } > "$TARGET/.cursor/rules/project-os.mdc"

    cp "$SCRIPT_DIR"/commands/*.md "$TARGET/.cursor/commands/"
fi

# ─────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────

echo ""
echo "Done! Project structure created:"
echo ""
find "$TARGET/docs" -type f 2>/dev/null | sort | while read f; do
    echo "  $f"
done
if [ "$EDITOR" = "claude" ] || [ "$EDITOR" = "both" ]; then
    find "$TARGET/.claude" -type f 2>/dev/null | sort | while read f; do
        echo "  $f"
    done
fi
if [ "$EDITOR" = "cursor" ] || [ "$EDITOR" = "both" ]; then
    find "$TARGET/.cursor" -type f 2>/dev/null | sort | while read f; do
        echo "  $f"
    done
fi
echo ""
echo "Next steps:"
echo "  1. cd $TARGET"
if [ "$EDITOR" = "claude" ]; then
    echo "  2. Open Claude Code and run /brainstorm"
elif [ "$EDITOR" = "cursor" ]; then
    echo "  2. Open Cursor and run /brainstorm in Agent mode"
else
    echo "  2. Open Claude Code or Cursor and run /brainstorm"
fi
echo "  3. Follow the workflow: /vision → /roadmap → /decompose → /start"
echo ""
