# Enhanced newrepo function with project workflow initialization
# Add this to your .zshrc or source it
#
# Usage:
#   newrepo my-project          # Creates repo with workflow structure
#   newrepo my-project --no-workflow  # Creates repo without workflow

# Location of your workflow template files
WORKFLOW_TEMPLATE_DIR="$HOME/.config/claude-workflow"

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
    cat > README.md << README_EOF
# $REPO_NAME

## Overview

[Project description]

## Getting Started

[Setup instructions]

## Development

This project uses a structured workflow. See \`.claude/CLAUDE.md\` for details.
README_EOF

    cat > .gitignore << GITIGNORE_EOF
# Python
__pycache__/
*.py[cod]
*\$py.class
.venv/
venv/
.env

# IDE
.vscode/
.idea/

# OS
.DS_Store

# Project
# sprints/archive/
GITIGNORE_EOF

    # Initialize project workflow (unless skipped)
    if [ "$SKIP_WORKFLOW" = false ]; then
        echo "Initializing project workflow..."
        
        if [ -d "$WORKFLOW_TEMPLATE_DIR/.claude" ]; then
            # Copy from local template
            cp -r "$WORKFLOW_TEMPLATE_DIR/.claude" .
        else
            # Create minimal structure if templates don't exist
            echo "⚠️  Full templates not found, creating minimal structure..."
            mkdir -p .claude/phases
            
            cat > .claude/CLAUDE.md << 'CLAUDE_EOF'
# Project Workflow

See `.claude/phases/` for phase-specific guides.

## Phases
1. Ideation → `docs/ideation.md`
2. Vision & Architecture → `docs/vision.md`, `docs/architecture.md`
3. Roadmap → `docs/roadmap.md`
4. Sprint Planning → `sprints/sprint-XX/`
5. Execution → Code + POSTMORTEM entries
6. Code Review → CODE_REVIEW.md
7. Retrospective → sprint-learnings.md

## Quick Start
1. Start Claude chat
2. Add `.claude/phases/01-ideation.md` as context
3. Share your idea
CLAUDE_EOF
            
            # Create placeholder phase files
            for i in 01-ideation 02-vision 03-roadmap 04-sprint-planning 05-execution 06-code-review 07-retrospective; do
                echo "# Phase: $i\n\nSee full templates for details." > ".claude/phases/$i.md"
            done
        fi
        
        # Create directory structure
        mkdir -p docs sprints/sprint-01/stories src
        
        # Initialize sprint files
        cat > sprints/sprint-01/STORIES_INDEX.md << 'SPRINT_EOF'
# Sprint 01 - Stories Index

## Sprint Overview

**Goal:** [To be defined during sprint planning]

**Milestone:** [From roadmap]

---

## Stories Overview

| ID | Title | Status | Dependencies | Complexity |
|----|-------|--------|--------------|------------|

---

## Story Status Legend

- ⬜ Not Started
- 🔄 In Progress  
- ✅ Completed
- ⏸️ Blocked

---

*Run Phase 4 (Sprint Planning) to populate this file.*
SPRINT_EOF

        cat > sprints/sprint-01/POSTMORTEM.md << 'PM_EOF'
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
PM_EOF

        touch sprints/sprint-01/stories/.gitkeep
        touch docs/.gitkeep
        touch src/.gitkeep
        
        echo "✅ Project workflow initialized"
    fi

    git init
    git add .
    git commit -m "Initial commit: project structure"

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

# Setup workflow templates from a source directory or repo
setup-workflow-templates() {
    local SOURCE="$1"
    local TEMPLATE_DIR="$HOME/.config/claude-workflow"
    
    if [ -z "$SOURCE" ]; then
        echo "Usage: setup-workflow-templates <source-path-or-repo>"
        echo ""
        echo "Examples:"
        echo "  setup-workflow-templates ~/Downloads/project-workflow"
        echo "  setup-workflow-templates git@github.com:user/workflow-templates.git"
        return 1
    fi
    
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
    
    # Check if source is a git repo or local path
    if [[ "$SOURCE" == git@* ]] || [[ "$SOURCE" == https://* ]]; then
        echo "Cloning from $SOURCE..."
        git clone "$SOURCE" "$TEMPLATE_DIR"
    elif [ -d "$SOURCE" ]; then
        echo "Copying from $SOURCE..."
        cp -r "$SOURCE"/* "$TEMPLATE_DIR/"
    else
        echo "❌ Source not found: $SOURCE"
        return 1
    fi
    
    echo "✅ Templates installed to $TEMPLATE_DIR"
}
