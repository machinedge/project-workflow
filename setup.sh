#!/bin/bash

# Project Toolkit — Project Scaffolder
# Usage: ./setup.sh [--editor claude|cursor|both] [project-directory]
#
# Creates the full project structure with editor config,
# commands, and empty docs ready to go.
#
# Examples:
#   ./setup.sh                          # Both editors, current directory
#   ./setup.sh --editor cursor ~/myproj # Cursor only
#   ./setup.sh --editor claude ~/myproj # Claude Code only
#   ./setup.sh ~/myproj                 # Both editors (default)

set -e

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

if [ "$TARGET" != "." ]; then
    mkdir -p "$TARGET"
fi

echo "Setting up project toolkit in: $TARGET (editor: $EDITOR)"

# Create shared directory structure
mkdir -p "$TARGET/docs/tasks"
mkdir -p "$TARGET/docs/handoff-notes"

# ─────────────────────────────────────────────
# Claude Code setup
# ─────────────────────────────────────────────

if [ "$EDITOR" = "claude" ] || [ "$EDITOR" = "both" ]; then
    echo "  Setting up Claude Code (.claude/)..."
    mkdir -p "$TARGET/.claude/commands"
    cp -r ./.claude "$TARGET/.claude"
    cp -r ./commands "$TARGET/.claude/commands"
fi

# ─────────────────────────────────────────────
# Cursor setup
# ─────────────────────────────────────────────

if [ "$EDITOR" = "cursor" ] || [ "$EDITOR" = "both" ]; then
    echo "  Setting up Cursor (.cursor/)..."
    mkdir -p "$TARGET/.cursor/commands"
    cp -r ./.cursor "$TARGET/.cursor"
    cp -r ./cursor "$TARGET/.cursor/commands"
fi

# ─────────────────────────────────────────────
# Shared docs
# ─────────────────────────────────────────────

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

echo ""
echo "Done! Project structure created:"
echo ""
find "$TARGET/docs" -type f | sort | while read f; do
    echo "  $f"
done
if [ "$EDITOR" = "claude" ] || [ "$EDITOR" = "both" ]; then
    find "$TARGET/.claude" -type f | sort | while read f; do
        echo "  $f"
    done
fi
if [ "$EDITOR" = "cursor" ] || [ "$EDITOR" = "both" ]; then
    find "$TARGET/.cursor" -type f | sort | while read f; do
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
