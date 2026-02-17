#!/bin/bash

# MachinEdge Expert Teams — Install Skill into Claude Code
# Usage: ./install-skill.sh [--project <project-dir>]
#
# Copies the built skill package into the Claude Code skills directory.
# By default installs personally (~/.claude/skills/) so it's available
# across all projects. Use --project to install into a specific project.
#
# Examples:
#   ./install-skill.sh                          # Personal install
#   ./install-skill.sh --project ~/work/my-app  # Project-local install

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null || true)"
if [ -z "$REPO_ROOT" ]; then
    REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
fi

SKILL_NAME="machinedge-workflows"
SKILL_BUILD="$REPO_ROOT/package/build/skills/$SKILL_NAME"

# Parse arguments
PROJECT_DIR=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --project)
            PROJECT_DIR="$2"
            shift 2
            ;;
        *)
            echo "Usage: ./install-skill.sh [--project <project-dir>]"
            exit 1
            ;;
    esac
done

# Check that the skill has been built
if [ ! -d "$SKILL_BUILD" ]; then
    echo "Error: Skill not built yet. Run ./package/package.sh first."
    exit 1
fi

if [ ! -f "$SKILL_BUILD/SKILL.md" ]; then
    echo "Error: SKILL.md not found in build output at $SKILL_BUILD"
    exit 1
fi

# Determine install location
if [ -n "$PROJECT_DIR" ]; then
    if [ ! -d "$PROJECT_DIR" ]; then
        echo "Error: Project directory not found: $PROJECT_DIR"
        exit 1
    fi
    INSTALL_DIR="$PROJECT_DIR/.claude/skills/$SKILL_NAME"
    INSTALL_TYPE="project-local"
else
    INSTALL_DIR="$HOME/.claude/skills/$SKILL_NAME"
    INSTALL_TYPE="personal"
fi

# Install
if [ -d "$INSTALL_DIR" ]; then
    echo "Removing existing installation at $INSTALL_DIR..."
    rm -rf "$INSTALL_DIR"
fi

mkdir -p "$(dirname "$INSTALL_DIR")"
cp -R "$SKILL_BUILD" "$INSTALL_DIR"

echo ""
echo "Done! Skill installed ($INSTALL_TYPE)."
echo "  Location: $INSTALL_DIR"
echo ""
echo "Claude Code will auto-discover this skill. You can also invoke it with /machinedge-workflows."
