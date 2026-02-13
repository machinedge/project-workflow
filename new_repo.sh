#!/bin/bash

# AI Project Toolkit — New Repo Scaffolder
# Usage: ./new_repo.sh <repo-name> [claude|cursor|both]
#
# Creates a new git repo with the toolkit pre-configured,
# and pushes it to GitHub under machinedge/.
#
# Examples:
#   ./new_repo.sh my-app              # Both editors (default)
#   ./new_repo.sh my-app cursor       # Cursor only
#   ./new_repo.sh my-app claude       # Claude Code only

set -e

if [ -z "$1" ]; then
    echo "Usage: ./new_repo.sh <repo-name> [claude|cursor|both]"
    exit 1
fi

# Resolve the directory where this script lives (the toolkit root)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

REPO_NAME="$1"
EDITOR="${2:-both}"
REPO_DIR="$HOME/work/$REPO_NAME"

if [ -d "$REPO_DIR" ]; then
    echo "Error: $REPO_DIR already exists"
    exit 1
fi

mkdir -p "$REPO_DIR"

# Initialize the repo
touch "$REPO_DIR/README.md"
touch "$REPO_DIR/.gitignore"

# Run the toolkit setup (using absolute path to setup.sh)
"$SCRIPT_DIR/setup.sh" --editor "$EDITOR" "$REPO_DIR"

# Git init and push
cd "$REPO_DIR"
git init
git add .
git commit -m "Initial commit: project scaffold with AI toolkit"

gh repo create "machinedge/$REPO_NAME" --private || {
    echo "Failed to create GitHub repo. Local repo is ready at $REPO_DIR"
    exit 1
}

git remote add origin "git@github.com:machinedge/$REPO_NAME.git"
git branch -M main
git push -u origin main

echo ""
echo "Done! Repo ready at: $REPO_DIR"
echo "GitHub: https://github.com/machinedge/$REPO_NAME"
echo ""
