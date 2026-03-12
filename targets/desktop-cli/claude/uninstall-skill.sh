#!/bin/bash

# MachinEdge Expert Teams — Uninstall Skill from Claude Code
# Usage: ./uninstall-skill.sh [--project <project-dir>]
#
# Removes the installed skill from the Claude Code skills directory.
# By default removes the personal install (~/.claude/skills/).
# Use --project to remove from a specific project.
#
# Examples:
#   ./uninstall-skill.sh                          # Remove personal install
#   ./uninstall-skill.sh --project ~/work/my-app  # Remove project-local install

set -e

SKILL_NAME="machinedge-workflows"

# Parse arguments
PROJECT_DIR=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --project)
            PROJECT_DIR="$2"
            shift 2
            ;;
        *)
            echo "Usage: ./uninstall-skill.sh [--project <project-dir>]"
            exit 1
            ;;
    esac
done

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

# Uninstall
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Not installed ($INSTALL_TYPE): $INSTALL_DIR"
    exit 0
fi

rm -rf "$INSTALL_DIR"

echo ""
echo "Done! Skill uninstalled ($INSTALL_TYPE)."
echo "  Removed: $INSTALL_DIR"
