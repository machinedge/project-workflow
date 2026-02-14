#!/bin/bash

# Validate a workflow for completeness and consistency
# Usage: ./validate.sh <workflow-directory-name>
#
# Checks that a workflow has all required files and that they follow
# the expected structural patterns. Uses basic file checks and grep —
# no external dependencies needed.
#
# Examples:
#   ./validate.sh swe          # Validate the SWE workflow
#   ./validate.sh eda          # Validate the EDA workflow
#   ./validate.sh my-workflow  # Validate a custom workflow

set -e

# ─────────────────────────────────────────────
# Parse arguments
# ─────────────────────────────────────────────

if [ -z "$1" ]; then
    echo "Usage: ./validate.sh <workflow-directory-name>"
    echo ""
    echo "Validates a workflow for completeness and consistency."
    echo "Pass the directory name relative to the repo root (e.g., 'swe', 'eda')."
    exit 1
fi

WORKFLOW_NAME="$1"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
WORKFLOW_DIR="$REPO_ROOT/$WORKFLOW_NAME"

if [ ! -d "$WORKFLOW_DIR" ]; then
    echo "Error: Directory not found: $WORKFLOW_DIR"
    exit 1
fi

# ─────────────────────────────────────────────
# Counters
# ─────────────────────────────────────────────

PASS=0
FAIL=0
WARN=0

pass() {
    echo "  ✓ $1"
    PASS=$((PASS + 1))
}

fail() {
    echo "  ✗ $1"
    FAIL=$((FAIL + 1))
}

warn() {
    echo "  ⚠ $1"
    WARN=$((WARN + 1))
}

echo "Validating workflow: $WORKFLOW_NAME"
echo "  Directory: $WORKFLOW_DIR"
echo ""

# ─────────────────────────────────────────────
# 1. Required files
# ─────────────────────────────────────────────

echo "Required files:"

if [ -f "$WORKFLOW_DIR/editor.md" ]; then
    pass "editor.md exists"
else
    fail "editor.md is missing"
fi

if [ -f "$WORKFLOW_DIR/README.md" ]; then
    pass "README.md exists"
else
    fail "README.md is missing"
fi

if [ -f "$WORKFLOW_DIR/setup.sh" ]; then
    pass "setup.sh exists"
    if [ -x "$WORKFLOW_DIR/setup.sh" ]; then
        pass "setup.sh is executable"
    else
        warn "setup.sh is not executable (run: chmod +x $WORKFLOW_NAME/setup.sh)"
    fi
else
    fail "setup.sh is missing"
fi

if [ -f "$WORKFLOW_DIR/setup.ps1" ]; then
    pass "setup.ps1 exists"
else
    warn "setup.ps1 is missing (Windows support)"
fi

if [ -f "$WORKFLOW_DIR/new_repo.sh" ]; then
    pass "new_repo.sh exists"
    if [ -x "$WORKFLOW_DIR/new_repo.sh" ]; then
        pass "new_repo.sh is executable"
    else
        warn "new_repo.sh is not executable (run: chmod +x $WORKFLOW_NAME/new_repo.sh)"
    fi
else
    warn "new_repo.sh is missing (optional but recommended)"
fi

if [ -f "$WORKFLOW_DIR/new_repo.ps1" ]; then
    pass "new_repo.ps1 exists"
else
    warn "new_repo.ps1 is missing (Windows support)"
fi

echo ""

# ─────────────────────────────────────────────
# 2. Command files
# ─────────────────────────────────────────────

echo "Command files:"

if [ -d "$WORKFLOW_DIR/commands" ]; then
    pass "commands/ directory exists"
else
    fail "commands/ directory is missing"
    echo ""
    echo "Summary: $PASS passed, $FAIL failed, $WARN warnings"
    exit 1
fi

CMD_COUNT=$(find "$WORKFLOW_DIR/commands" -name "*.md" -type f | wc -l | tr -d ' ')

if [ "$CMD_COUNT" -ge 8 ]; then
    pass "$CMD_COUNT command files found (8 expected)"
elif [ "$CMD_COUNT" -ge 5 ]; then
    warn "$CMD_COUNT command files found (8 expected — some slots may be intentionally omitted)"
else
    fail "Only $CMD_COUNT command files found (minimum 5 expected)"
fi

# Check that the commands referenced in editor.md actually exist
if [ -f "$WORKFLOW_DIR/editor.md" ]; then
    # Extract command names from editor.md (lines matching "- `/commandname`")
    EDITOR_COMMANDS=$(grep -oP '`/\K[a-z_-]+' "$WORKFLOW_DIR/editor.md" 2>/dev/null || true)

    if [ -n "$EDITOR_COMMANDS" ]; then
        for cmd in $EDITOR_COMMANDS; do
            if [ -f "$WORKFLOW_DIR/commands/${cmd}.md" ]; then
                pass "Command /$cmd has matching file"
            else
                fail "editor.md references /$cmd but commands/${cmd}.md is missing"
            fi
        done
    else
        warn "Could not extract command names from editor.md"
    fi
fi

echo ""

# ─────────────────────────────────────────────
# 3. editor.md structure
# ─────────────────────────────────────────────

echo "editor.md structure:"

if [ -f "$WORKFLOW_DIR/editor.md" ]; then
    EDITOR_CONTENT="$WORKFLOW_DIR/editor.md"

    if grep -q "## Document Locations" "$EDITOR_CONTENT" 2>/dev/null; then
        pass "Has 'Document Locations' section"
    else
        fail "Missing 'Document Locations' section"
    fi

    if grep -q "## Session Protocol" "$EDITOR_CONTENT" 2>/dev/null; then
        pass "Has 'Session Protocol' section"
    else
        fail "Missing 'Session Protocol' section"
    fi

    if grep -q "## Slash Commands" "$EDITOR_CONTENT" 2>/dev/null; then
        pass "Has 'Slash Commands' section"
    else
        fail "Missing 'Slash Commands' section"
    fi

    if grep -q "## Principles" "$EDITOR_CONTENT" 2>/dev/null; then
        pass "Has 'Principles' section"
    else
        fail "Missing 'Principles' section"
    fi

    # Check for core principles
    if grep -qi "no memory between sessions" "$EDITOR_CONTENT" 2>/dev/null; then
        pass "Includes 'no memory between sessions' principle"
    else
        warn "Missing core principle about no memory between sessions"
    fi

    if grep -qi "source of truth" "$EDITOR_CONTENT" 2>/dev/null; then
        pass "References a source of truth document"
    else
        warn "Missing reference to source of truth document"
    fi
fi

echo ""

# ─────────────────────────────────────────────
# 4. Command content checks
# ─────────────────────────────────────────────

echo "Command content checks:"

# Check /start command for 7-phase structure
START_CMD=$(find "$WORKFLOW_DIR/commands" -name "start.md" -type f 2>/dev/null | head -1)
if [ -n "$START_CMD" ]; then
    PHASE_COUNT=$(grep -c "^## Phase" "$START_CMD" 2>/dev/null || echo "0")
    if [ "$PHASE_COUNT" -ge 7 ]; then
        pass "/start has $PHASE_COUNT phases (7 expected)"
    elif [ "$PHASE_COUNT" -ge 5 ]; then
        warn "/start has $PHASE_COUNT phases (7 expected)"
    else
        fail "/start has only $PHASE_COUNT phases (minimum 5 expected)"
    fi

    if grep -qi "approval\|wait for.*confirmation\|wait for.*approval" "$START_CMD" 2>/dev/null; then
        pass "/start has approval gates"
    else
        fail "/start is missing approval gates"
    fi
else
    fail "No start.md command found"
fi

# Check handoff command for note template
HANDOFF_CMD=$(find "$WORKFLOW_DIR/commands" -name "handoff.md" -type f 2>/dev/null | head -1)
if [ -n "$HANDOFF_CMD" ]; then
    if grep -q "handoff-notes" "$HANDOFF_CMD" 2>/dev/null; then
        pass "/handoff references handoff-notes directory"
    else
        fail "/handoff doesn't reference handoff-notes directory"
    fi

    if grep -qi "Next Session Needs to Know" "$HANDOFF_CMD" 2>/dev/null; then
        pass "/handoff includes 'Next Session Needs to Know' section"
    else
        warn "/handoff missing 'Next Session Needs to Know' section"
    fi
else
    fail "No handoff.md command found"
fi

# Check decompose command for GitHub issue creation
DECOMPOSE_CMD=$(find "$WORKFLOW_DIR/commands" -name "decompose.md" -type f 2>/dev/null | head -1)
if [ -n "$DECOMPOSE_CMD" ]; then
    if grep -q "gh issue create" "$DECOMPOSE_CMD" 2>/dev/null; then
        pass "/decompose uses gh issue create"
    else
        warn "/decompose doesn't reference gh issue create"
    fi

    if grep -qi "user story\|As a" "$DECOMPOSE_CMD" 2>/dev/null; then
        pass "/decompose uses user story format"
    else
        warn "/decompose doesn't use user story format"
    fi
else
    warn "No decompose.md command found"
fi

# Check review command for fresh-eyes requirement
REVIEW_CMD=$(find "$WORKFLOW_DIR/commands" -name "review.md" -type f 2>/dev/null | head -1)
if [ -n "$REVIEW_CMD" ]; then
    if grep -qi "separate session\|fresh.eyes\|fresh eyes" "$REVIEW_CMD" 2>/dev/null; then
        pass "/review mentions separate session / fresh eyes"
    else
        warn "/review doesn't mention fresh-eyes / separate session requirement"
    fi
else
    warn "No review.md command found"
fi

echo ""

# ─────────────────────────────────────────────
# 5. Template placeholder check
# ─────────────────────────────────────────────

echo "Placeholder check:"

PLACEHOLDER_COUNT=$(grep -r "{{[A-Z_]*}}" "$WORKFLOW_DIR" 2>/dev/null | wc -l | tr -d ' ')
if [ "$PLACEHOLDER_COUNT" -eq 0 ]; then
    pass "No unreplaced {{PLACEHOLDER}} markers found"
else
    warn "$PLACEHOLDER_COUNT lines still contain {{PLACEHOLDER}} markers (fill these in)"
fi

GUIDE_COUNT=$(grep -r "<!-- GUIDE:" "$WORKFLOW_DIR" 2>/dev/null | wc -l | tr -d ' ')
if [ "$GUIDE_COUNT" -eq 0 ]; then
    pass "No <!-- GUIDE: --> comments remaining"
else
    warn "$GUIDE_COUNT guidance comments remaining (remove as you customize)"
fi

echo ""

# ─────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────

echo "─────────────────────────────────────────────"
echo "Results: $PASS passed, $FAIL failed, $WARN warnings"
echo "─────────────────────────────────────────────"

if [ "$FAIL" -gt 0 ]; then
    echo ""
    echo "There are failures that should be fixed before the workflow is ready."
    exit 1
elif [ "$WARN" -gt 0 ]; then
    echo ""
    echo "Workflow structure is valid. Warnings are suggestions for improvement."
    exit 0
else
    echo ""
    echo "Workflow looks good!"
    exit 0
fi
