#!/bin/bash

# Project Workflow Bootstrap
# 
# This script initializes the Claude-assisted project workflow structure.
# It can be run standalone or integrated with your newrepo function.
#
# Usage:
#   ./init-project-workflow.sh [project-dir]
#   
# If no project-dir is provided, uses current directory.

set -e

PROJECT_DIR="${1:-.}"

# Ensure we're in the project directory
cd "$PROJECT_DIR"

echo "Initializing project workflow structure..."

# Create directory structure
mkdir -p .claude/phases
mkdir -p docs
mkdir -p sprints/sprint-01/stories
mkdir -p src

# Download phase files from your template repo (or copy from local)
# For now, we'll create placeholder references

cat > .claude/CLAUDE.md << 'CLAUDE_EOF'
# Project Workflow System

This project uses a structured workflow for planning, execution, and continuous improvement. Claude assists as a collaborative partner throughout each phase.

## Workflow Phases

| Phase | Purpose | Input | Output | Guide |
|-------|---------|-------|--------|-------|
| 1. Ideation | Extract ideas from your head | Brain dump / rough notes | `docs/ideation.md` | [01-ideation.md](phases/01-ideation.md) |
| 2. Vision & Architecture | Define what we're building and why | Ideation output | `docs/vision.md`, `docs/architecture.md` | [02-vision.md](phases/02-vision.md) |
| 3. Roadmap | Plan milestones and MVP evolution | Vision + Architecture | `docs/roadmap.md` | [03-roadmap.md](phases/03-roadmap.md) |
| 4. Sprint Planning | Break milestone into executable stories | Roadmap milestone | `sprints/sprint-XX/` | [04-sprint-planning.md](phases/04-sprint-planning.md) |
| 5. Execution | Implement, test, document | Story file | Code + POSTMORTEM entries | [05-execution.md](phases/05-execution.md) |
| 6. Code Review | Multi-perspective quality review | Completed code | `CODE_REVIEW.md`, `INDEPENDENT_CODE_REVIEW.md` | [06-code-review.md](phases/06-code-review.md) |
| 7. Retrospective | Extract learnings, update docs | Sprint postmortems | `sprint-learnings.md`, updated roadmap | [07-retrospective.md](phases/07-retrospective.md) |

## Quick Start

1. Start a new Claude chat/session
2. Add `.claude/phases/01-ideation.md` as context
3. Share your initial idea
4. Claude will ask questions to extract your thinking
5. When you approve the ideation doc, start a new session for Phase 2

## How Claude Works With You

- **Asks questions one at a time** to extract information
- **Generates drafts** for your review
- **Iterates** based on your feedback
- **Finalizes** when you approve ("ok, it looks good")

## Directory Structure

```
.claude/           # Workflow guides
docs/              # Planning documents (vision, architecture, roadmap)
sprints/           # Sprint artifacts
  sprint-XX/
    STORIES_INDEX.md
    stories/
    POSTMORTEM.md
    CODE_REVIEW.md
src/               # Your code
```

See individual phase guides in `.claude/phases/` for detailed instructions.
CLAUDE_EOF

echo "Created .claude/CLAUDE.md"

# Create phase files (abbreviated versions - full versions should come from template repo)
# In practice, you'd copy these from a central location or download them

cat > .claude/phases/01-ideation.md << 'EOF'
# Phase 1: Ideation

## Purpose
Extract raw ideas, concerns, goals, and problems into a structured document.

## Output
- `docs/ideation.md`

## How It Works
1. Share your initial thoughts (however rough)
2. Claude asks clarifying questions one at a time
3. Claude generates a draft ideation document
4. You review and iterate
5. Approve when ready: "ok, it looks good"

## Starting the Phase
Tell Claude: "I'm starting Phase 1 - Ideation. Here's my rough idea: [your thoughts]"

See full guide for question examples and document template.
EOF

cat > .claude/phases/02-vision.md << 'EOF'
# Phase 2: Vision & Architecture

## Purpose
Transform ideation into clear vision statement and initial architecture.

## Input
- `docs/ideation.md`

## Output
- `docs/vision.md`
- `docs/architecture.md`

## How It Works
1. Load ideation.md as context
2. Claude asks about value proposition, scope, success criteria
3. Generate and iterate on vision.md
4. Claude asks about technical approach
5. Generate and iterate on architecture.md

See full guide for question examples and document templates.
EOF

cat > .claude/phases/03-roadmap.md << 'EOF'
# Phase 3: Roadmap

## Purpose
Define MVP and plan evolution toward full vision.

## Input
- `docs/vision.md`
- `docs/architecture.md`

## Output
- `docs/roadmap.md`

## How It Works
1. Load vision and architecture as context
2. Claude helps identify minimal viable scope
3. Sequence remaining capabilities into milestones
4. Generate and iterate on roadmap

See full guide for question examples and document template.
EOF

cat > .claude/phases/04-sprint-planning.md << 'EOF'
# Phase 4: Sprint Planning

## Purpose
Break a roadmap milestone into executable stories.

## Input
- `docs/roadmap.md`
- `docs/architecture.md`
- Previous sprint learnings (if any)

## Output
- `sprints/sprint-XX/STORIES_INDEX.md`
- `sprints/sprint-XX/stories/*.md`
- `sprints/sprint-XX/POSTMORTEM.md` (initialized)

## How It Works
1. Identify target milestone
2. Claude helps decompose into stories
3. Define acceptance criteria and testing strategy
4. Generate story files

See full guide for story format and templates.
EOF

cat > .claude/phases/05-execution.md << 'EOF'
# Phase 5: Execution

## Purpose
Implement stories with Claude as pair programming partner.

## Input
- Story file from `sprints/sprint-XX/stories/`
- `docs/architecture.md`

## Output
- Implemented, tested code
- POSTMORTEM.md entry

## How It Works
1. Load story file as context
2. Claude asks clarifying questions
3. Implement incrementally
4. Test and document
5. Add postmortem entry

Run in Claude Code or IDE with Claude integration.

See full guide for execution checklist and postmortem format.
EOF

cat > .claude/phases/06-code-review.md << 'EOF'
# Phase 6: Code Review

## Purpose
Multi-model review to catch issues before release.

## Input
- Completed code
- Architecture context

## Output
- `CODE_REVIEW.md` (multi-model results)
- `INDEPENDENT_CODE_REVIEW.md` (skeptical synthesis)

## How It Works
1. Run review prompt through multiple AI models
2. Collect results in CODE_REVIEW.md
3. Run independent skeptical review
4. Address critical issues before closing sprint

See full guide for review prompts and templates.
EOF

cat > .claude/phases/07-retrospective.md << 'EOF'
# Phase 7: Retrospective

## Purpose
Synthesize learnings and update planning documents.

## Input
- `POSTMORTEM.md`
- `CODE_REVIEW.md`
- Planning documents

## Output
- Sprint-level retrospective in POSTMORTEM.md
- `sprint-learnings.md`
- Updated roadmap/architecture (if needed)

## How It Works
1. Review all postmortem entries
2. Identify patterns and insights
3. Complete sprint-level retrospective
4. Generate condensed learnings
5. Update planning docs as needed

See full guide for retrospective questions and templates.
EOF

echo "Created phase guides in .claude/phases/"

# Create placeholder docs
touch docs/.gitkeep
touch src/.gitkeep

# Initialize sprint structure
cat > sprints/sprint-01/STORIES_INDEX.md << 'EOF'
# Sprint 01 - Stories Index

## Sprint Overview

**Goal:** [To be defined during sprint planning]

**Milestone:** [From roadmap]

**Duration:** [Estimated]

---

## Stories Overview

| ID | Title | Status | Dependencies | Complexity |
|----|-------|--------|--------------|------------|
| | | | | |

---

*Run Phase 4 (Sprint Planning) to populate this file.*
EOF

cat > sprints/sprint-01/POSTMORTEM.md << 'EOF'
# Sprint 01 - Postmortems

This document captures learnings from each story to improve future development.

---

*Story entries will be added during Phase 5 (Execution).*

---

## Sprint-Level Retrospective

*(To be filled during Phase 7)*

### Overall What Went Well:
-

### Overall What Went Poorly:
-

### Key Learnings:
-

### Process Improvements for Next Sprint:
-
EOF

touch sprints/sprint-01/stories/.gitkeep

echo "Created sprint structure in sprints/sprint-01/"

# Update .gitignore
cat >> .gitignore << 'EOF'

# Project workflow
# (Uncomment if you want to exclude certain artifacts)
# sprints/archive/
EOF

echo "Updated .gitignore"

echo ""
echo "✅ Project workflow initialized!"
echo ""
echo "Next steps:"
echo "  1. Start a new Claude chat"
echo "  2. Add .claude/phases/01-ideation.md as context"
echo "  3. Share your initial idea"
echo ""
echo "Directory structure created:"
echo "  .claude/          - Workflow guides"
echo "  .claude/phases/   - Phase-specific instructions"
echo "  docs/             - Planning documents"
echo "  sprints/          - Sprint artifacts"
echo "  src/              - Your code"
EOF

echo "Created init-project-workflow.sh"

# Create the enhanced newrepo function
cat > newrepo-enhanced.zsh << 'ZSHEOF'
# Enhanced newrepo function with project workflow initialization
# Add this to your .zshrc or source it

# Location of your workflow template files
# Option 1: Local directory
WORKFLOW_TEMPLATE_DIR="$HOME/.config/claude-workflow"

# Option 2: Git repo (uncomment to use)
# WORKFLOW_TEMPLATE_REPO="git@github.com:machinedge/project-workflow-template.git"

newrepo() {
    if [ -z "$1" ]; then
        echo "Usage: newrepo <repo-name> [--no-workflow]"
        return 1
    fi

    REPO_NAME="$1"
    SKIP_WORKFLOW=false
    
    if [ "$2" = "--no-workflow" ]; then
        SKIP_WORKFLOW=true
    fi

    REPO_DIR="$HOME/work/$REPO_NAME"

    mkdir -p "$REPO_DIR" && \
    pushd "$REPO_DIR" || return 1

    # Initialize basic files
    touch README.md
    touch .gitignore

    # Initialize project workflow (unless skipped)
    if [ "$SKIP_WORKFLOW" = false ]; then
        echo "Initializing project workflow..."
        
        if [ -d "$WORKFLOW_TEMPLATE_DIR" ]; then
            # Copy from local template
            cp -r "$WORKFLOW_TEMPLATE_DIR/.claude" .
            mkdir -p docs sprints/sprint-01/stories src
            
            # Initialize sprint files
            cat > sprints/sprint-01/STORIES_INDEX.md << 'SPRINT_EOF'
# Sprint 01 - Stories Index

## Sprint Overview

**Goal:** [To be defined during sprint planning]

---

## Stories Overview

| ID | Title | Status | Dependencies | Complexity |
|----|-------|--------|--------------|------------|

---

*Run Phase 4 (Sprint Planning) to populate this file.*
SPRINT_EOF

            cat > sprints/sprint-01/POSTMORTEM.md << 'PM_EOF'
# Sprint 01 - Postmortems

This document captures learnings from each story.

---

## Sprint-Level Retrospective

*(To be filled during Phase 7)*
PM_EOF

            touch sprints/sprint-01/stories/.gitkeep
            touch docs/.gitkeep
            touch src/.gitkeep
            
            echo "✅ Project workflow initialized"
        else
            echo "⚠️  Workflow template not found at $WORKFLOW_TEMPLATE_DIR"
            echo "   Run without workflow or set up templates first"
        fi
    fi

    git init
    git add .
    git commit -m "Initial commit: project structure with workflow"

    gh repo create "machinedge/$REPO_NAME" --private || {
        echo "Failed to create GitHub repo"
        popd
        return 1
    }
    git remote add origin "git@github.com:machinedge/$REPO_NAME"
    git branch -M main
    git push -u origin main
    
    echo ""
    echo "✅ Repository created: machinedge/$REPO_NAME"
    echo "📁 Location: $REPO_DIR"
    
    if [ "$SKIP_WORKFLOW" = false ]; then
        echo ""
        echo "🚀 To start:"
        echo "   1. Open Claude chat"
        echo "   2. Add .claude/phases/01-ideation.md as context"
        echo "   3. Share your initial idea"
    fi
}

# Helper to set up the workflow template directory
setup-workflow-templates() {
    TEMPLATE_DIR="$HOME/.config/claude-workflow"
    
    if [ -d "$TEMPLATE_DIR" ]; then
        echo "Template directory already exists at $TEMPLATE_DIR"
        read -p "Overwrite? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return 1
        fi
        rm -rf "$TEMPLATE_DIR"
    fi
    
    mkdir -p "$TEMPLATE_DIR"
    
    echo "Download workflow templates to $TEMPLATE_DIR"
    echo "You can:"
    echo "  1. Copy files manually from your template source"
    echo "  2. Clone from a template repo"
    echo ""
    echo "Template directory created at: $TEMPLATE_DIR"
}
ZSHEOF

echo "Created newrepo-enhanced.zsh"
