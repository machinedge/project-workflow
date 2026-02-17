#!/bin/bash

# Validate an expert definition for completeness and consistency
# Usage: ./validate.sh [<domain>/<expert-name>]
#        ./validate.sh                           # Validate all experts
#
# Checks that an expert has all required files and that they follow
# the expected structural patterns. Uses basic file checks and grep —
# no external dependencies needed.
#
# Examples:
#   ./validate.sh                         # Validate all experts
#   ./validate.sh technical/swe           # Validate a specific expert
#   ./validate.sh technical/data-analyst  # Validate the data analyst

set -e

# ─────────────────────────────────────────────
# Parse arguments
# ─────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null)"
if [ -z "$REPO_ROOT" ]; then
    _dir="$SCRIPT_DIR"
    while [ "$_dir" != "/" ]; do
        if [ -d "$_dir/.git" ] || [ -f "$_dir/SKILL.md" ]; then
            REPO_ROOT="$_dir"
            break
        fi
        _dir="$(dirname "$_dir")"
    done
fi
if [ -z "$REPO_ROOT" ]; then
    echo "Error: Could not find repository root from $SCRIPT_DIR"
    exit 1
fi

# ─────────────────────────────────────────────
# Validation logic for a single expert
# ─────────────────────────────────────────────

TOTAL_PASS=0
TOTAL_FAIL=0
TOTAL_WARN=0

validate_expert() {
    local EXPERT_PATH="$1"
    local EXPERT_DIR="$REPO_ROOT/experts/$EXPERT_PATH"
    local EXPERT_NAME
    EXPERT_NAME=$(basename "$EXPERT_PATH")

    if [ ! -d "$EXPERT_DIR" ]; then
        echo "Error: Directory not found: $EXPERT_DIR"
        return 1
    fi

    # Counters
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

    echo "Validating expert: $EXPERT_PATH"
    echo "  Directory: $EXPERT_DIR"
    echo ""

    # ─────────────────────────────────────────────
    # 1. Required files and directories
    # ─────────────────────────────────────────────

    echo "Required structure:"

    if [ -f "$EXPERT_DIR/role.md" ]; then
        pass "role.md exists"
    else
        fail "role.md is missing"
    fi

    if [ -d "$EXPERT_DIR/skills" ]; then
        pass "skills/ directory exists"
    else
        fail "skills/ directory is missing"
    fi

    if [ -d "$EXPERT_DIR/tools" ]; then
        pass "tools/ directory exists"
    else
        fail "tools/ directory is missing"
    fi

    echo ""

    # ─────────────────────────────────────────────
    # 2. Skill files
    # ─────────────────────────────────────────────

    echo "Skill files:"

    SKILL_COUNT=$(find "$EXPERT_DIR/skills" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')

    if [ "$SKILL_COUNT" -ge 1 ]; then
        pass "$SKILL_COUNT skill file(s) found"
    else
        warn "No skill files found in skills/ (add skills as you develop them)"
    fi

    # Check that skills referenced in role.md actually exist
    if [ -f "$EXPERT_DIR/role.md" ]; then
        # Extract skill names from role.md (lines matching "- `skillname`" or "- `/skillname`")
        ROLE_SKILLS=$(grep -oP '`/?(\K[a-z_-]+)(?=`)' "$EXPERT_DIR/role.md" 2>/dev/null | sort -u || true)

        if [ -n "$ROLE_SKILLS" ]; then
            for skill in $ROLE_SKILLS; do
                # Skip non-skill references (paths, docs, etc.)
                if echo "$skill" | grep -qP '/|\.'; then
                    continue
                fi
                if [ -f "$EXPERT_DIR/skills/${skill}.md" ]; then
                    pass "Skill '$skill' has matching file"
                else
                    # Only warn — skills might be listed before being created
                    warn "role.md references '$skill' but skills/${skill}.md not found"
                fi
            done
        fi
    fi

    echo ""

    # ─────────────────────────────────────────────
    # 3. role.md structure
    # ─────────────────────────────────────────────

    echo "role.md structure:"

    if [ -f "$EXPERT_DIR/role.md" ]; then
        ROLE_CONTENT="$EXPERT_DIR/role.md"

        if grep -q "## Document Locations" "$ROLE_CONTENT" 2>/dev/null; then
            pass "Has 'Document Locations' section"
        else
            fail "Missing 'Document Locations' section"
        fi

        if grep -q "## Session Protocol" "$ROLE_CONTENT" 2>/dev/null; then
            pass "Has 'Session Protocol' section"
        else
            fail "Missing 'Session Protocol' section"
        fi

        if grep -q "## Skills" "$ROLE_CONTENT" 2>/dev/null; then
            pass "Has 'Skills' section"
        else
            fail "Missing 'Skills' section"
        fi

        if grep -q "## Principles" "$ROLE_CONTENT" 2>/dev/null; then
            pass "Has 'Principles' section"
        else
            fail "Missing 'Principles' section"
        fi

        # Check for core principles
        if grep -qi "no memory between sessions" "$ROLE_CONTENT" 2>/dev/null; then
            pass "Includes 'no memory between sessions' principle"
        else
            warn "Missing core principle about no memory between sessions"
        fi

        if grep -qi "source of truth" "$ROLE_CONTENT" 2>/dev/null; then
            pass "References a source of truth document"
        else
            warn "Missing reference to source of truth document"
        fi
    fi

    echo ""

    # ─────────────────────────────────────────────
    # 4. Skill content checks
    # ─────────────────────────────────────────────

    echo "Skill content checks:"

    # Check start skill for 7-phase structure
    START_SKILL=$(find "$EXPERT_DIR/skills" -name "start.md" -type f 2>/dev/null | head -1)
    if [ -n "$START_SKILL" ]; then
        PHASE_COUNT=$(grep -c "^## Phase" "$START_SKILL" 2>/dev/null || echo "0")
        if [ "$PHASE_COUNT" -ge 7 ]; then
            pass "start skill has $PHASE_COUNT phases (7 expected)"
        elif [ "$PHASE_COUNT" -ge 5 ]; then
            warn "start skill has $PHASE_COUNT phases (7 expected)"
        elif [ "$PHASE_COUNT" -ge 1 ]; then
            fail "start skill has only $PHASE_COUNT phases (minimum 5 expected)"
        fi

        if grep -qi "approval\|wait for.*confirmation\|wait for.*approval" "$START_SKILL" 2>/dev/null; then
            pass "start skill has approval gates"
        else
            warn "start skill may be missing approval gates"
        fi
    fi

    # Check handoff skill for note template
    HANDOFF_SKILL=$(find "$EXPERT_DIR/skills" -name "handoff.md" -type f 2>/dev/null | head -1)
    if [ -n "$HANDOFF_SKILL" ]; then
        if grep -q "handoff-notes" "$HANDOFF_SKILL" 2>/dev/null; then
            pass "handoff skill references handoff-notes directory"
        else
            warn "handoff skill doesn't reference handoff-notes directory"
        fi
    fi

    # Check for in-repo issue tracking (not external GitHub Issues)
    DECOMPOSE_SKILL=$(find "$EXPERT_DIR/skills" -name "decompose.md" -type f 2>/dev/null | head -1)
    if [ -n "$DECOMPOSE_SKILL" ]; then
        if grep -q "issues/" "$DECOMPOSE_SKILL" 2>/dev/null; then
            pass "decompose skill references in-repo issues/"
        else
            warn "decompose skill doesn't reference in-repo issues/"
        fi
    fi

    echo ""

    # ─────────────────────────────────────────────
    # 5. Template placeholder check
    # ─────────────────────────────────────────────

    echo "Placeholder check:"

    PLACEHOLDER_COUNT=$(grep -r "{{[A-Z_]*}}" "$EXPERT_DIR" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$PLACEHOLDER_COUNT" -eq 0 ]; then
        pass "No unreplaced {{PLACEHOLDER}} markers found"
    else
        warn "$PLACEHOLDER_COUNT lines still contain {{PLACEHOLDER}} markers (fill these in)"
    fi

    GUIDE_COUNT=$(grep -r "<!-- GUIDE:" "$EXPERT_DIR" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$GUIDE_COUNT" -eq 0 ]; then
        pass "No <!-- GUIDE: --> comments remaining"
    else
        warn "$GUIDE_COUNT guidance comments remaining (remove as you customize)"
    fi

    echo ""

    # ─────────────────────────────────────────────
    # Summary for this expert
    # ─────────────────────────────────────────────

    echo "─────────────────────────────────────────────"
    echo "$EXPERT_PATH: $PASS passed, $FAIL failed, $WARN warnings"
    echo "─────────────────────────────────────────────"
    echo ""

    TOTAL_PASS=$((TOTAL_PASS + PASS))
    TOTAL_FAIL=$((TOTAL_FAIL + FAIL))
    TOTAL_WARN=$((TOTAL_WARN + WARN))

    return 0
}

# ─────────────────────────────────────────────
# Main: validate one or all experts
# ─────────────────────────────────────────────

if [ -n "$1" ]; then
    # Validate a specific expert
    validate_expert "$1"
else
    # Validate all experts
    echo "Validating all experts..."
    echo ""

    FOUND=0
    for domain_dir in "$REPO_ROOT"/experts/*/; do
        domain=$(basename "$domain_dir")
        for expert_dir in "$domain_dir"*/; do
            expert=$(basename "$expert_dir")
            # Skip 'shared' — it's not an expert
            if [ "$expert" = "shared" ]; then
                continue
            fi
            if [ -f "$expert_dir/role.md" ] || [ -d "$expert_dir/skills" ]; then
                validate_expert "$domain/$expert"
                FOUND=$((FOUND + 1))
            fi
        done
    done

    if [ "$FOUND" -eq 0 ]; then
        echo "No experts found under experts/."
        exit 1
    fi
fi

# ─────────────────────────────────────────────
# Overall summary
# ─────────────────────────────────────────────

if [ -z "$1" ]; then
    echo "═════════════════════════════════════════════"
    echo "Overall: $TOTAL_PASS passed, $TOTAL_FAIL failed, $TOTAL_WARN warnings"
    echo "═════════════════════════════════════════════"
fi

if [ "$TOTAL_FAIL" -gt 0 ]; then
    echo ""
    echo "There are failures that should be fixed."
    exit 1
elif [ "$TOTAL_WARN" -gt 0 ]; then
    echo ""
    echo "Structure is valid. Warnings are suggestions for improvement."
    exit 0
else
    echo ""
    echo "All checks passed!"
    exit 0
fi
