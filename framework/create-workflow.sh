#!/bin/bash

# Create a new workflow from templates
# Usage: ./create-workflow.sh <workflow-name>
#
# Generates a new workflow directory at the repo root with all the necessary
# files pre-populated from templates. Template placeholders are replaced with
# sensible defaults based on the workflow name, and guidance comments are
# included to help you customize each file.
#
# Examples:
#   ./create-workflow.sh devops
#   ./create-workflow.sh content-writing
#   ./create-workflow.sh research

set -e

# ─────────────────────────────────────────────
# Parse arguments
# ─────────────────────────────────────────────

if [ -z "$1" ]; then
    echo "Usage: ./create-workflow.sh <workflow-name>"
    echo ""
    echo "Creates a new workflow directory from templates."
    echo "The name should be short and lowercase (e.g., 'devops', 'research')."
    exit 1
fi

WORKFLOW_NAME="$1"

# Validate name: lowercase, hyphens, numbers only
if [[ ! "$WORKFLOW_NAME" =~ ^[a-z0-9-]+$ ]]; then
    echo "Error: Workflow name must be lowercase letters, numbers, and hyphens only."
    echo "  Got: '$WORKFLOW_NAME'"
    echo "  Example: 'devops', 'content-writing', 'ml-ops'"
    exit 1
fi

# Resolve paths
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/templates"
TARGET_DIR="$REPO_ROOT/$WORKFLOW_NAME"

if [ -d "$TARGET_DIR" ]; then
    echo "Error: $TARGET_DIR already exists."
    exit 1
fi

if [ ! -d "$TEMPLATE_DIR" ]; then
    echo "Error: Templates directory not found at $TEMPLATE_DIR"
    exit 1
fi

# ─────────────────────────────────────────────
# Derive placeholder values from the name
# ─────────────────────────────────────────────

# Convert "content-writing" → "Content Writing"
WORKFLOW_DISPLAY_NAME=$(echo "$WORKFLOW_NAME" | sed 's/-/ /g' | sed 's/\b\(.\)/\u\1/g')

# Default document names (contributor can rename these)
BRIEF_DOC="project-brief.md"
BRIEF_DISPLAY_NAME="Project Brief"
BRIEF_DISPLAY_NAME_LOWER="project brief"
PLAN_DOC="plan.md"
PLAN_DISPLAY_NAME="Plan"
NOTES_DOC="interview-notes.md"
CURSOR_RULES_FILE="${WORKFLOW_NAME}-os.mdc"
ISSUE_LABEL="task"
WORK_UNIT="milestone"
WORK_UNIT_PLURAL="Milestones"

# Default command names (contributor can rename these)
INTERVIEW_COMMAND="interview"
BRIEF_COMMAND="brief"
PLAN_COMMAND="plan"
SYNTHESIS_COMMAND="synthesis"

# Default command descriptions
INTERVIEW_DESCRIPTION="Structured interview to understand goals, context, and constraints"
BRIEF_DESCRIPTION="Generate the project brief from interview notes"
PLAN_DESCRIPTION="Create the ${WORK_UNIT} plan with dependencies and risks"
SYNTHESIS_DESCRIPTION="Review completed ${WORK_UNIT} and synthesize results"

# Phase names for /start
PHASE_2_NAME="Plan the Approach"
PHASE_3_NAME="Design the Solution"
PHASE_4_NAME="Prepare"
PHASE_5_NAME="Execute"
PHASE_6_NAME="Verify"

echo "Creating workflow: $WORKFLOW_NAME"
echo "  Display name: $WORKFLOW_DISPLAY_NAME"
echo "  Directory: $TARGET_DIR"

# ─────────────────────────────────────────────
# Create directory structure
# ─────────────────────────────────────────────

mkdir -p "$TARGET_DIR/commands"

# ─────────────────────────────────────────────
# Process templates — replace placeholders
# ─────────────────────────────────────────────

replace_placeholders() {
    local input="$1"
    local output="$2"

    sed \
        -e "s|{{WORKFLOW_NAME}}|$WORKFLOW_NAME|g" \
        -e "s|{{WORKFLOW_DISPLAY_NAME}}|$WORKFLOW_DISPLAY_NAME|g" \
        -e "s|{{BRIEF_DOC}}|$BRIEF_DOC|g" \
        -e "s|{{BRIEF_DISPLAY_NAME}}|$BRIEF_DISPLAY_NAME|g" \
        -e "s|{{BRIEF_DISPLAY_NAME_LOWER}}|$BRIEF_DISPLAY_NAME_LOWER|g" \
        -e "s|{{PLAN_DOC}}|$PLAN_DOC|g" \
        -e "s|{{PLAN_DISPLAY_NAME}}|$PLAN_DISPLAY_NAME|g" \
        -e "s|{{NOTES_DOC}}|$NOTES_DOC|g" \
        -e "s|{{CURSOR_RULES_FILE}}|$CURSOR_RULES_FILE|g" \
        -e "s|{{ISSUE_LABEL}}|$ISSUE_LABEL|g" \
        -e "s|{{WORK_UNIT}}|$WORK_UNIT|g" \
        -e "s|{{WORK_UNIT_PLURAL}}|$WORK_UNIT_PLURAL|g" \
        -e "s|{{INTERVIEW_COMMAND}}|$INTERVIEW_COMMAND|g" \
        -e "s|{{BRIEF_COMMAND}}|$BRIEF_COMMAND|g" \
        -e "s|{{PLAN_COMMAND}}|$PLAN_COMMAND|g" \
        -e "s|{{SYNTHESIS_COMMAND}}|$SYNTHESIS_COMMAND|g" \
        -e "s|{{INTERVIEW_DESCRIPTION}}|$INTERVIEW_DESCRIPTION|g" \
        -e "s|{{BRIEF_DESCRIPTION}}|$BRIEF_DESCRIPTION|g" \
        -e "s|{{PLAN_DESCRIPTION}}|$PLAN_DESCRIPTION|g" \
        -e "s|{{SYNTHESIS_DESCRIPTION}}|$SYNTHESIS_DESCRIPTION|g" \
        -e "s|{{PHASE_2_NAME}}|$PHASE_2_NAME|g" \
        -e "s|{{PHASE_3_NAME}}|$PHASE_3_NAME|g" \
        -e "s|{{PHASE_4_NAME}}|$PHASE_4_NAME|g" \
        -e "s|{{PHASE_5_NAME}}|$PHASE_5_NAME|g" \
        -e "s|{{PHASE_6_NAME}}|$PHASE_6_NAME|g" \
        "$input" > "$output"
}

# Core files
replace_placeholders "$TEMPLATE_DIR/editor.md.tmpl" "$TARGET_DIR/editor.md"
replace_placeholders "$TEMPLATE_DIR/README.md.tmpl" "$TARGET_DIR/README.md"
replace_placeholders "$TEMPLATE_DIR/setup.sh.tmpl" "$TARGET_DIR/setup.sh"
replace_placeholders "$TEMPLATE_DIR/setup.ps1.tmpl" "$TARGET_DIR/setup.ps1"
replace_placeholders "$TEMPLATE_DIR/new_repo.sh.tmpl" "$TARGET_DIR/new_repo.sh"
replace_placeholders "$TEMPLATE_DIR/new_repo.ps1.tmpl" "$TARGET_DIR/new_repo.ps1"

# Make scripts executable
chmod +x "$TARGET_DIR/setup.sh"
chmod +x "$TARGET_DIR/new_repo.sh"

# Command files — rename from template slots to default command names
replace_placeholders "$TEMPLATE_DIR/commands/interview.md.tmpl" "$TARGET_DIR/commands/${INTERVIEW_COMMAND}.md"
replace_placeholders "$TEMPLATE_DIR/commands/brief.md.tmpl" "$TARGET_DIR/commands/${BRIEF_COMMAND}.md"
replace_placeholders "$TEMPLATE_DIR/commands/plan.md.tmpl" "$TARGET_DIR/commands/${PLAN_COMMAND}.md"
replace_placeholders "$TEMPLATE_DIR/commands/decompose.md.tmpl" "$TARGET_DIR/commands/decompose.md"
replace_placeholders "$TEMPLATE_DIR/commands/start.md.tmpl" "$TARGET_DIR/commands/start.md"
replace_placeholders "$TEMPLATE_DIR/commands/review.md.tmpl" "$TARGET_DIR/commands/review.md"
replace_placeholders "$TEMPLATE_DIR/commands/handoff.md.tmpl" "$TARGET_DIR/commands/handoff.md"
replace_placeholders "$TEMPLATE_DIR/commands/synthesis.md.tmpl" "$TARGET_DIR/commands/${SYNTHESIS_COMMAND}.md"

# ─────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────

echo ""
echo "Done! Workflow scaffolded at: $TARGET_DIR"
echo ""
echo "Files created:"
find "$TARGET_DIR" -type f | sort | while read f; do
    echo "  ${f#$REPO_ROOT/}"
done
echo ""
echo "Next steps:"
echo "  1. Edit $WORKFLOW_NAME/editor.md — customize the operating rules"
echo "  2. Edit $WORKFLOW_NAME/commands/*.md — customize each command"
echo "  3. Edit $WORKFLOW_NAME/README.md — write the workflow documentation"
echo "  4. Remove <!-- GUIDE: ... --> comments as you fill in real content"
echo "  5. Run: ./framework/validate.sh $WORKFLOW_NAME"
echo ""
echo "See docs/workflow-anatomy.md for the full reference on patterns and conventions."
echo ""
