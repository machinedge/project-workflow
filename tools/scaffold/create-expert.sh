#!/bin/bash

# Create a new expert definition
# Usage: ./create-expert.sh --domain <domain> <expert-name>
#        ./create-expert.sh --domain <domain> --with-skills <expert-name>
#
# Creates the directory structure for a new expert under experts/<domain>/.
# By default, generates only role.md with required sections, skills/, and tools/.
# Use --with-skills to also scaffold the 8 default skill files from templates.
#
# Names are automatically normalized to lowercase-hyphenated format.
#
# Examples:
#   ./create-expert.sh --domain technical maintenance-planner
#   ./create-expert.sh --domain Technical "Content Writer"
#   ./create-expert.sh --domain technical --with-skills security-analyst

set -e

# ─────────────────────────────────────────────
# Parse arguments
# ─────────────────────────────────────────────

DOMAIN=""
EXPERT_NAME=""
WITH_SKILLS=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --domain)
            DOMAIN="$2"
            shift 2
            ;;
        --with-skills)
            WITH_SKILLS=true
            shift
            ;;
        *)
            EXPERT_NAME="$1"
            shift
            ;;
    esac
done

if [ -z "$EXPERT_NAME" ] || [ -z "$DOMAIN" ]; then
    echo "Usage: ./create-expert.sh --domain <domain> <expert-name>"
    echo ""
    echo "Creates the directory structure for a new expert definition."
    echo "Names are auto-normalized (e.g., 'Content Writer' → 'content-writer')."
    echo ""
    echo "Options:"
    echo "  --domain <domain>    Domain to create the expert under (required)"
    echo "  --with-skills        Also scaffold the 8 default skill files from templates"
    echo ""
    echo "Examples:"
    echo "  ./create-expert.sh --domain technical maintenance-planner"
    echo "  ./create-expert.sh --domain technical --with-skills security-analyst"
    exit 1
fi

# ─────────────────────────────────────────────
# Normalize names to lowercase-hyphenated
# ─────────────────────────────────────────────

normalize_name() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' _' '-' | sed 's/--*/-/g; s/^-//; s/-$//'
}

DOMAIN=$(normalize_name "$DOMAIN")
EXPERT_NAME=$(normalize_name "$EXPERT_NAME")

if [[ ! "$EXPERT_NAME" =~ ^[a-z0-9-]+$ ]]; then
    echo "Error: Expert name '$EXPERT_NAME' contains invalid characters after normalization."
    exit 1
fi

if [[ ! "$DOMAIN" =~ ^[a-z0-9-]+$ ]]; then
    echo "Error: Domain '$DOMAIN' contains invalid characters after normalization."
    exit 1
fi

# Resolve paths
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
TEMPLATE_DIR="$SCRIPT_DIR/templates"
TARGET_DIR="$REPO_ROOT/experts/$DOMAIN/$EXPERT_NAME"

if [ -d "$TARGET_DIR" ]; then
    echo "Error: $TARGET_DIR already exists."
    exit 1
fi

# ─────────────────────────────────────────────
# Derive display name
# ─────────────────────────────────────────────

# Convert "maintenance-planner" → "Maintenance Planner"
EXPERT_DISPLAY_NAME=$(echo "$EXPERT_NAME" | sed 's/-/ /g' | sed 's/\b\(.\)/\u\1/g')

echo "Creating expert: $EXPERT_NAME"
echo "  Domain: $DOMAIN"
echo "  Display name: $EXPERT_DISPLAY_NAME"
echo "  Directory: $TARGET_DIR"

# ─────────────────────────────────────────────
# Create directory structure
# ─────────────────────────────────────────────

mkdir -p "$TARGET_DIR/skills"
mkdir -p "$TARGET_DIR/tools"
touch "$TARGET_DIR/tools/.gitkeep"

# ─────────────────────────────────────────────
# Generate role.md with required sections
# ─────────────────────────────────────────────

cat > "$TARGET_DIR/role.md" << ROLE_EOF
# ${EXPERT_DISPLAY_NAME} Operating System

You are working as the ${EXPERT_DISPLAY_NAME} expert on a coordinated team.

## Document Locations

| Document | Path | Purpose |
|----------|------|---------|
| Project Brief | \`docs/project-brief.md\` | Goals, constraints, decisions, status. READ THIS FIRST. |
| Handoff Notes | \`docs/handoff-notes/${EXPERT_NAME}/session-NN.md\` | What happened in each past session. |
| Docs Protocol | \`experts/${DOMAIN}/shared/docs-protocol.md\` | Cross-expert document contracts. |

## Session Protocol

### Starting a session
1. Read \`docs/project-brief.md\` (always — no exceptions)
2. Read the most recent handoff note in \`docs/handoff-notes/${EXPERT_NAME}/\`
3. Read the issue or task you've been assigned
4. Confirm your understanding before starting work

### During a session
- Stay within scope. If you discover something out of scope, flag it, don't do it.
- Verify your work before declaring the task complete.

### Ending a session
Produce a handoff note and save it to \`docs/handoff-notes/${EXPERT_NAME}/session-NN.md\`.

## Skills

<!-- List available skills here as you develop them. -->

## Principles

- You have no memory between sessions. Project documents ARE your memory.
- The project brief is the source of truth. If something contradicts it, ask the user.
- Every task includes verification. "It should work" is not verification.
ROLE_EOF

# ─────────────────────────────────────────────
# Optionally scaffold skill files from templates
# ─────────────────────────────────────────────

if [ "$WITH_SKILLS" = true ]; then
    if [ ! -d "$TEMPLATE_DIR/skills" ]; then
        echo "Warning: Templates directory not found at $TEMPLATE_DIR/skills — skipping skill scaffolding."
    else
        echo "  Scaffolding default skill files from templates..."

        replace_placeholders() {
            local input="$1"
            local output="$2"

            sed \
                -e "s|{{EXPERT_NAME}}|$EXPERT_NAME|g" \
                -e "s|{{EXPERT_DISPLAY_NAME}}|$EXPERT_DISPLAY_NAME|g" \
                -e "s|{{DOMAIN}}|$DOMAIN|g" \
                -e "s|{{BRIEF_DOC}}|project-brief.md|g" \
                -e "s|{{BRIEF_DISPLAY_NAME}}|Project Brief|g" \
                -e "s|{{BRIEF_DISPLAY_NAME_LOWER}}|project brief|g" \
                -e "s|{{PLAN_DOC}}|plan.md|g" \
                -e "s|{{PLAN_DISPLAY_NAME}}|Plan|g" \
                -e "s|{{NOTES_DOC}}|interview-notes.md|g" \
                -e "s|{{ISSUE_LABEL}}|task|g" \
                -e "s|{{WORK_UNIT}}|milestone|g" \
                -e "s|{{WORK_UNIT_PLURAL}}|Milestones|g" \
                -e "s|{{INTERVIEW_SKILL}}|interview|g" \
                -e "s|{{BRIEF_SKILL}}|brief|g" \
                -e "s|{{PLAN_SKILL}}|plan|g" \
                -e "s|{{SYNTHESIS_SKILL}}|synthesis|g" \
                -e "s|{{INTERVIEW_DESCRIPTION}}|Structured interview to understand goals, context, and constraints|g" \
                -e "s|{{BRIEF_DESCRIPTION}}|Generate the project brief from interview notes|g" \
                -e "s|{{PLAN_DESCRIPTION}}|Create the milestone plan with dependencies and risks|g" \
                -e "s|{{SYNTHESIS_DESCRIPTION}}|Review completed milestone and synthesize results|g" \
                -e "s|{{PHASE_2_NAME}}|Plan the Approach|g" \
                -e "s|{{PHASE_3_NAME}}|Design the Solution|g" \
                -e "s|{{PHASE_4_NAME}}|Prepare|g" \
                -e "s|{{PHASE_5_NAME}}|Execute|g" \
                -e "s|{{PHASE_6_NAME}}|Verify|g" \
                "$input" > "$output"
        }

        for tmpl in "$TEMPLATE_DIR"/skills/*.md.tmpl; do
            if [ -f "$tmpl" ]; then
                skill_name=$(basename "$tmpl" .md.tmpl)
                replace_placeholders "$tmpl" "$TARGET_DIR/skills/${skill_name}.md"
            fi
        done
    fi
fi

# ─────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────

echo ""
echo "Done! Expert scaffolded at: $TARGET_DIR"
echo ""
echo "Files created:"
find "$TARGET_DIR" -type f | sort | while read f; do
    echo "  ${f#$REPO_ROOT/}"
done
echo ""
echo "Next steps:"
echo "  1. Edit experts/$DOMAIN/$EXPERT_NAME/role.md — define identity and operating rules"
echo "  2. Add skills to experts/$DOMAIN/$EXPERT_NAME/skills/"
echo "  3. Run: ./framework/validate/validate.sh $DOMAIN/$EXPERT_NAME"
echo ""
