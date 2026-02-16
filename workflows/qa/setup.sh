#!/bin/bash

# QA Workflow — Setup
# Usage: ./setup.sh [--editor claude|cursor|both] [project-directory]
#
# Installs QA workflow commands and editor config into a project directory.
#
# Examples:
#   ./setup.sh                          # Both editors, current directory
#   ./setup.sh --editor cursor ~/myproj # Cursor only
#   ./setup.sh --editor claude ~/myproj # Claude Code only
#   ./setup.sh ~/myproj                 # Both editors (default)

set -e

# Resolve the directory where this script lives (workflows/qa/)
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

if [ "$TARGET" != "." ]; then
    mkdir -p "$TARGET"
fi

echo "  [qa] Installing QA workflow in: $TARGET (editor: $EDITOR)"

# ─────────────────────────────────────────────
# Shared docs directory
# ─────────────────────────────────────────────

mkdir -p "$TARGET/docs/handoff-notes/pm"
mkdir -p "$TARGET/docs/handoff-notes/swe"
mkdir -p "$TARGET/docs/handoff-notes/qa"
mkdir -p "$TARGET/docs/handoff-notes/devops"

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
# editor.md → .claude/roles/qa.md
# commands → .claude/commands/
# ─────────────────────────────────────────────

if [ "$EDITOR" = "claude" ] || [ "$EDITOR" = "both" ]; then
    echo "    Setting up Claude Code (.claude/)..."
    mkdir -p "$TARGET/.claude/commands"
    mkdir -p "$TARGET/.claude/roles"
    cp "$SCRIPT_DIR/editor.md" "$TARGET/.claude/roles/qa.md"
    cp "$SCRIPT_DIR"/commands/*.md "$TARGET/.claude/commands/"
fi

# ─────────────────────────────────────────────
# Cursor setup
# editor.md + YAML frontmatter → .cursor/rules/qa-os.mdc
# commands → .cursor/commands/
# ─────────────────────────────────────────────

if [ "$EDITOR" = "cursor" ] || [ "$EDITOR" = "both" ]; then
    echo "    Setting up Cursor (.cursor/)..."
    mkdir -p "$TARGET/.cursor/rules"
    mkdir -p "$TARGET/.cursor/commands"

    # Prepend Cursor's frontmatter to the QA editor rules
    {
        printf '%s\n' "---"
        printf '%s\n' "description: QA operating system — quality assurance validation protocol"
        printf '%s\n' "alwaysApply: false"
        printf '%s\n' "---"
        printf '\n'
        cat "$SCRIPT_DIR/editor.md"
    } > "$TARGET/.cursor/rules/qa-os.mdc"

    cp "$SCRIPT_DIR"/commands/*.md "$TARGET/.cursor/commands/"
fi

# ─────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────

echo "    QA commands installed: /review, /test-plan, /regression, /bug-triage"
