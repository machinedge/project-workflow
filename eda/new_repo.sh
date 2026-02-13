#!/bin/bash

# Time Series EDA Toolkit — New Repo Scaffolder
# Usage: ./new_repo.sh [--org <github-org>] [--editor claude|cursor|both] <repo-name>
#
# Creates a new git repo with the analysis toolkit pre-configured,
# and pushes it to GitHub under the specified org/user.
#
# The GitHub org/user can be set via:
#   1. --org flag (highest priority)
#   2. GITHUB_ORG environment variable
#
# Examples:
#   ./new_repo.sh my-analysis                        # Uses $GITHUB_ORG, both editors
#   ./new_repo.sh --org mycompany my-analysis        # Explicit org
#   ./new_repo.sh --editor cursor my-analysis        # Cursor only
#   ./new_repo.sh --org myco --editor claude analysis # All flags

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

# Resolve the directory where this script lives (the toolkit root)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Parse arguments
ORG=""
EDITOR="both"
REPO_NAME=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --org)
            ORG="$2"
            shift 2
            ;;
        --editor)
            EDITOR="$2"
            shift 2
            ;;
        *)
            REPO_NAME="$1"
            shift
            ;;
    esac
done

if [ -z "$REPO_NAME" ]; then
    echo "Usage: ./new_repo.sh [--org <github-org>] [--editor claude|cursor|both] <repo-name>"
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

# Create README
cat > "$REPO_DIR/README.md" << 'DOC_EOF'
# Time Series Analysis

This project uses the [MachinEdge Time Series EDA Toolkit](https://github.com/machinedge/ts-eda) for structured, multi-session analysis with AI coding assistants.

## Getting Started

1. Install dependencies: `uv sync` (or `pip install -e .`)
2. Open Claude Code or Cursor
3. Run `/intake` to begin the analysis
4. Follow the workflow: `/brief` → `/scope` → `/decompose` → `/start`

## Project Structure

```
docs/               Analysis documents (brief, scope, data profile, handoff notes)
notebooks/          Jupyter notebooks (working surface)
data/raw/           Untouched source data
data/processed/     Cleaned and transformed data
reports/            Synthesized findings and recommendations
```
DOC_EOF

# Run the toolkit setup (using absolute path to setup.sh)
"$SCRIPT_DIR/setup.sh" --editor "$EDITOR" "$REPO_DIR"

# Git init and push
cd "$REPO_DIR"
git init
git add .
git commit -m "Initial commit: analysis scaffold with time series EDA toolkit"

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
echo "Done! Analysis repo ready at: $REPO_DIR"
echo "GitHub: https://github.com/$ORG/$REPO_NAME"
echo ""
echo "Next steps:"
echo "  1. cd $REPO_DIR"
echo "  2. uv sync"
echo "  3. Place your data in data/raw/"
echo "  4. Open Claude Code or Cursor and run /intake"
echo ""
