#!/bin/bash

# AI Project Toolkit — Top-Level Setup
# Usage: ./setup.sh [--editor claude|cursor|both] [--workflows pm,swe,qa,devops] [project-directory]
#
# Installs one or more workflows into a project directory.
# Delegates to each workflow's individual setup.sh.
#
# Examples:
#   ./setup.sh ~/myproj                                  # All workflows, both editors
#   ./setup.sh --workflows pm,swe ~/myproj               # Just PM and SWE
#   ./setup.sh --workflows pm,swe,qa --editor cursor .   # PM+SWE+QA, Cursor only
#   ./setup.sh --editor claude ~/myproj                  # All workflows, Claude only

set -e

# Resolve the directory where this script lives (workflows/)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Parse arguments
EDITOR="both"
WORKFLOW_LIST="pm,swe,qa,devops"
TARGET="."

while [[ $# -gt 0 ]]; do
    case $1 in
        --editor)
            EDITOR="$2"
            shift 2
            ;;
        --workflows)
            WORKFLOW_LIST="$2"
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

# Validate workflow names
IFS=',' read -ra WORKFLOWS <<< "$WORKFLOW_LIST"
VALID_WORKFLOWS=("pm" "swe" "qa" "devops")
for wf in "${WORKFLOWS[@]}"; do
    wf=$(echo "$wf" | tr -d ' ')
    found=false
    for valid in "${VALID_WORKFLOWS[@]}"; do
        if [ "$wf" = "$valid" ]; then
            found=true
            break
        fi
    done
    if [ "$found" = false ]; then
        echo "Error: Unknown workflow '$wf'. Valid workflows: pm, swe, qa, devops"
        exit 1
    fi
done

echo "Setting up project toolkit in: $TARGET"
echo "  Workflows: $WORKFLOW_LIST"
echo "  Editor: $EDITOR"
echo ""

# ─────────────────────────────────────────────
# Run each workflow's setup script
# ─────────────────────────────────────────────

for wf in "${WORKFLOWS[@]}"; do
    wf=$(echo "$wf" | tr -d ' ')
    SETUP_SCRIPT="$SCRIPT_DIR/$wf/setup.sh"
    if [ -f "$SETUP_SCRIPT" ]; then
        "$SETUP_SCRIPT" --editor "$EDITOR" "$TARGET"
    else
        echo "  Warning: No setup script found for '$wf' workflow at $SETUP_SCRIPT"
    fi
done

# ─────────────────────────────────────────────
# Install shared commands (/status)
# ─────────────────────────────────────────────

echo ""
echo "  [shared] Installing shared commands..."

if [ "$EDITOR" = "claude" ] || [ "$EDITOR" = "both" ]; then
    mkdir -p "$TARGET/.claude/commands"
    cp "$SCRIPT_DIR"/shared/commands/*.md "$TARGET/.claude/commands/"
fi

if [ "$EDITOR" = "cursor" ] || [ "$EDITOR" = "both" ]; then
    mkdir -p "$TARGET/.cursor/commands"
    cp "$SCRIPT_DIR"/shared/commands/*.md "$TARGET/.cursor/commands/"
fi

echo "    Shared commands installed: /status"

# ─────────────────────────────────────────────
# Generate the root CLAUDE.md / Cursor rules
# that explains the roles system
# ─────────────────────────────────────────────

# Build the list of installed roles and their commands
ROLE_LIST=""
COMMAND_LIST=""
for wf in "${WORKFLOWS[@]}"; do
    wf=$(echo "$wf" | tr -d ' ')
    case $wf in
        pm)
            ROLE_LIST="$ROLE_LIST\n- **PM** (\`.claude/roles/pm.md\`) — Product/project management: discovery, planning, scoping"
            COMMAND_LIST="$COMMAND_LIST\n- \`/interview\` — Structured interview for new projects (PM)"
            COMMAND_LIST="$COMMAND_LIST\n- \`/add_feature\` — Scope new work for existing project (PM)"
            COMMAND_LIST="$COMMAND_LIST\n- \`/vision\` — Generate project brief from interview (PM)"
            COMMAND_LIST="$COMMAND_LIST\n- \`/roadmap\` — Create milestone plan (PM)"
            COMMAND_LIST="$COMMAND_LIST\n- \`/decompose\` — Break milestone into tasks (PM)"
            COMMAND_LIST="$COMMAND_LIST\n- \`/postmortem\` — Review completed milestone (PM)"
            ;;
        swe)
            ROLE_LIST="$ROLE_LIST\n- **SWE** (\`.claude/roles/swe.md\`) — Software engineering: implementation, testing, verification"
            COMMAND_LIST="$COMMAND_LIST\n- \`/start\` — Begin execution session (SWE)"
            COMMAND_LIST="$COMMAND_LIST\n- \`/handoff\` — End session, produce handoff note (SWE)"
            ;;
        qa)
            ROLE_LIST="$ROLE_LIST\n- **QA** (\`.claude/roles/qa.md\`) — Quality assurance: review, test planning, regression"
            COMMAND_LIST="$COMMAND_LIST\n- \`/review\` — Fresh-eyes code review (QA)"
            COMMAND_LIST="$COMMAND_LIST\n- \`/test-plan\` — Generate test plan (QA)"
            COMMAND_LIST="$COMMAND_LIST\n- \`/regression\` — Run regression check (QA)"
            COMMAND_LIST="$COMMAND_LIST\n- \`/bug-triage\` — Prioritize bug backlog (QA)"
            ;;
        devops)
            ROLE_LIST="$ROLE_LIST\n- **DevOps** (\`.claude/roles/devops.md\`) — Build, test, deploy: environments, pipelines, releases"
            COMMAND_LIST="$COMMAND_LIST\n- \`/env-discovery\` — Capture environment context (DevOps)"
            COMMAND_LIST="$COMMAND_LIST\n- \`/pipeline\` — Define build/test/deploy pipeline (DevOps)"
            COMMAND_LIST="$COMMAND_LIST\n- \`/release-plan\` — Define release gates and rollback (DevOps)"
            COMMAND_LIST="$COMMAND_LIST\n- \`/deploy\` — Execute release with verification (DevOps)"
            ;;
    esac
done

# Always include /status
COMMAND_LIST="$COMMAND_LIST\n- \`/status\` — Cross-workflow project health summary (Shared)"

if [ "$EDITOR" = "claude" ] || [ "$EDITOR" = "both" ]; then
    echo ""
    echo "  [claude] Generating .claude/CLAUDE.md..."
    cat > "$TARGET/.claude/CLAUDE.md" << CLAUDE_EOF
# Project Operating System

This project uses a multi-workflow AI toolkit. Each session, you operate in a specific role.

## Roles

Read the role file for your active role at the start of every session:
$(echo -e "$ROLE_LIST")

## Starting a Session

1. Ask the user which role they want for this session (PM, SWE, QA, or DevOps).
2. Read the corresponding role file from \`.claude/roles/\`.
3. Follow that role's session protocol.

If the user jumps straight into a command (e.g. \`/start\`), infer the role from the command and load the appropriate role file automatically.

## Available Commands
$(echo -e "$COMMAND_LIST")

## Shared Principles

- You have no memory between sessions. Project documents ARE your memory.
- The project brief (\`docs/project-brief.md\`) is the source of truth.
- Keep the project brief under 1,000 words.
- Verify your work. "It should work" is not verification.
CLAUDE_EOF
fi

if [ "$EDITOR" = "cursor" ] || [ "$EDITOR" = "both" ]; then
    echo "  [cursor] Generating .cursor/rules/project-os.mdc..."
    cat > "$TARGET/.cursor/rules/project-os.mdc" << CURSOR_EOF
---
description: Project operating system — multi-workflow AI toolkit
alwaysApply: true
---

# Project Operating System

This project uses a multi-workflow AI toolkit. Each session, you operate in a specific role.

## Roles

Read the role file for your active role at the start of every session:
$(echo -e "$ROLE_LIST")

Role files are in \`.cursor/rules/\` as \`<workflow>-os.mdc\`.

## Starting a Session

1. Ask the user which role they want for this session (PM, SWE, QA, or DevOps).
2. Read the corresponding role rules file.
3. Follow that role's session protocol.

If the user jumps straight into a command (e.g. \`/start\`), infer the role from the command and load the appropriate role file automatically.

## Available Commands
$(echo -e "$COMMAND_LIST")

## Shared Principles

- You have no memory between sessions. Project documents ARE your memory.
- The project brief (\`docs/project-brief.md\`) is the source of truth.
- Keep the project brief under 1,000 words.
- Verify your work. "It should work" is not verification.
CURSOR_EOF
fi

# ─────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────

echo ""
echo "Done! Project structure:"
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
    echo "  2. Open Claude Code and run /interview to start a new project"
elif [ "$EDITOR" = "cursor" ]; then
    echo "  2. Open Cursor and run /interview in Agent mode to start a new project"
else
    echo "  2. Open Claude Code or Cursor and run /interview to start a new project"
fi
echo "  3. Or run /status to see the project health summary"
echo ""
