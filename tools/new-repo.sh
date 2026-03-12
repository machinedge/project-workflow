#!/bin/bash

# MachinEdge Expert Teams — New Repo Creator
# Usage: ./new_repo.sh [--org <github-org>] <repo-name>
#
# Creates a new git repo and pushes it to GitHub under the specified org/user.
# Expert installation is handled separately via install.sh.
#
# The GitHub org/user can be set via:
#   1. --org flag (highest priority)
#   2. GITHUB_ORG environment variable
#
# Examples:
#   ./new_repo.sh my-app                      # Uses $GITHUB_ORG
#   ./new_repo.sh --org mycompany my-app      # Explicit org

set -e

# Check prerequisites
if ! command -v git &> /dev/null; then
    echo "Error: git is not installed"
    exit 1
fi
if ! command -v gh &> /dev/null; then
    echo "Error: gh CLI is not installed (https://cli.github.com)"
    exit 1
fi

# Parse arguments
ORG=""
REPO_NAME=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --org)
            ORG="$2"
            shift 2
            ;;
        *)
            REPO_NAME="$1"
            shift
            ;;
    esac
done

if [ -z "$REPO_NAME" ]; then
    echo "Usage: ./new_repo.sh [--org <github-org>] <repo-name>"
    exit 1
fi

# Resolve org: flag > env var
if [ -z "$ORG" ]; then
    ORG="${GITHUB_ORG:-}"
fi
if [ -z "$ORG" ]; then
    echo "Error: GitHub org/user not specified."
    echo "  Set GITHUB_ORG in your environment or pass --org <github-org>"
    exit 1
fi

# Validate repo name
if [[ ! "$REPO_NAME" =~ ^[a-zA-Z0-9._-]+$ ]]; then
    echo "Error: Invalid repo name '$REPO_NAME'. Use only letters, numbers, hyphens, dots, and underscores."
    exit 1
fi

REPO_DIR="$HOME/work/$REPO_NAME"

if [ -d "$REPO_DIR" ]; then
    echo "Error: $REPO_DIR already exists"
    exit 1
fi

mkdir -p "$REPO_DIR"

# Initialize the repo
touch "$REPO_DIR/README.md"
touch "$REPO_DIR/.gitignore"

# Git init and push
cd "$REPO_DIR"
git init
git add .
git commit -m "Initial commit"

if ! gh repo create "$ORG/$REPO_NAME" --private; then
    echo "Failed to create GitHub repo. Cleaning up local repo."
    cd "$HOME"
    rm -rf "$REPO_DIR"
    exit 1
fi

git remote add origin "git@github.com:$ORG/$REPO_NAME.git"
git branch -M main
git push -u origin main

echo ""
echo "Done! Repo ready at: $REPO_DIR"
echo "GitHub: https://github.com/$ORG/$REPO_NAME"
echo ""
