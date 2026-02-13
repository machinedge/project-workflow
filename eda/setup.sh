#!/bin/bash

# Time Series EDA Toolkit — Setup
# Usage: ./setup.sh [--editor claude|cursor|both] [project-directory]
#
# Copies editor config and commands into a project directory,
# and creates the analysis-specific directory structure.
#
# Examples:
#   ./setup.sh                          # Both editors, current directory
#   ./setup.sh --editor cursor ~/myproj # Cursor only
#   ./setup.sh --editor claude ~/myproj # Claude Code only
#   ./setup.sh ~/myproj                 # Both editors (default)

set -e

# Resolve the directory where this script lives (the toolkit root)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Parse arguments
EDITOR="both"
TARGET="."

while [[ $# -gt 0 ]]; do
    case $1 in
        --editor)
            EDITOR="$2"
            shift 2
            ;;
        *)
            TARGET="$1"
            shift
            ;;
    esac
done

if [ "$TARGET" != "." ]; then
    mkdir -p "$TARGET"
fi

echo "Setting up time series EDA toolkit in: $TARGET (editor: $EDITOR)"

# ─────────────────────────────────────────────
# Analysis directory structure
# ─────────────────────────────────────────────

mkdir -p "$TARGET/docs/handoff-notes"
mkdir -p "$TARGET/notebooks"
mkdir -p "$TARGET/data/raw"
mkdir -p "$TARGET/data/processed"
mkdir -p "$TARGET/reports"

# Placeholder files so git tracks empty directories
touch "$TARGET/notebooks/.gitkeep"
touch "$TARGET/data/raw/.gitkeep"
touch "$TARGET/data/processed/.gitkeep"
touch "$TARGET/reports/.gitkeep"

# ─────────────────────────────────────────────
# Lessons log (analysis-focused)
# ─────────────────────────────────────────────

if [ ! -f "$TARGET/docs/lessons-log.md" ]; then
cat > "$TARGET/docs/lessons-log.md" << 'DOC_EOF'
# Lessons Log

Record analysis-specific gotchas, data quirks, method pitfalls, and domain knowledge here. Future sessions will read this to avoid repeating mistakes.

| Date | Lesson | Context |
|------|--------|---------|
DOC_EOF
fi

# ─────────────────────────────────────────────
# Data profile (living document)
# ─────────────────────────────────────────────

if [ ! -f "$TARGET/docs/data-profile.md" ]; then
cat > "$TARGET/docs/data-profile.md" << 'DOC_EOF'
# Data Profile

This is a living document. Every analysis session should leave it richer than it was found. Record what you learn about the data here — characteristics, quality issues, discovered patterns, statistical properties.

## Dataset Overview
[To be populated during first `/start` session]

## Variable Catalog
[To be populated — list of variables with types, distributions, missing rates]

## Temporal Characteristics
[To be populated — stationarity, seasonality, gaps, resolution]

## Quality Issues
[To be populated — missing data patterns, outliers, anomalies, data collection artifacts]

## Statistical Properties
[To be populated — distributions, correlations, autocorrelation structure]

## Discovery Log
| Date | Session | Discovery | Implication |
|------|---------|-----------|-------------|
DOC_EOF
fi

# ─────────────────────────────────────────────
# .gitignore (data files, notebooks checkpoints)
# ─────────────────────────────────────────────

if [ ! -f "$TARGET/.gitignore" ]; then
cat > "$TARGET/.gitignore" << 'DOC_EOF'
# Data files — track raw data with Git LFS or keep out of version control
# Uncomment the line below to ignore all data files:
# data/raw/*
data/processed/*
!data/processed/.gitkeep
!data/raw/.gitkeep

# Jupyter notebook checkpoints
.ipynb_checkpoints/

# Python
__pycache__/
*.py[cod]
*.egg-info/
.venv/
venv/

# uv
.uv/

# Environment
.env
*.env.local

# OS files
.DS_Store
Thumbs.db
DOC_EOF
fi

# ─────────────────────────────────────────────
# pyproject.toml (opinionated stack)
# ─────────────────────────────────────────────

if [ ! -f "$TARGET/pyproject.toml" ]; then
cat > "$TARGET/pyproject.toml" << 'DOC_EOF'
[project]
name = "ts-eda-analysis"
version = "0.1.0"
description = "Time series exploratory data analysis"
requires-python = ">=3.10"
dependencies = [
    # Core analysis
    "pandas>=2.0",
    "numpy>=1.24",
    "scikit-learn>=1.3",
    "statsmodels>=0.14",
    "scipy>=1.11",
    # Time series
    "sktime>=0.26",
    "tsfresh>=0.20",
    # Visualization
    "plotly>=5.18",
    "matplotlib>=3.8",
    "seaborn>=0.13",
    # Notebooks
    "jupyter>=1.0",
    "ipykernel>=6.0",
]

[tool.uv]
dev-dependencies = [
    "pytest>=7.0",
    "ruff>=0.1",
]
DOC_EOF
fi

# ─────────────────────────────────────────────
# Claude Code setup
# editor.md is copied as-is to .claude/CLAUDE.md
# ─────────────────────────────────────────────

if [ "$EDITOR" = "claude" ] || [ "$EDITOR" = "both" ]; then
    echo "  Setting up Claude Code (.claude/)..."
    mkdir -p "$TARGET/.claude/commands"
    cp "$SCRIPT_DIR/editor.md" "$TARGET/.claude/CLAUDE.md"
    cp "$SCRIPT_DIR"/commands/*.md "$TARGET/.claude/commands/"
fi

# ─────────────────────────────────────────────
# Cursor setup
# editor.md + YAML frontmatter → .cursor/rules/analysis-os.mdc
# ─────────────────────────────────────────────

if [ "$EDITOR" = "cursor" ] || [ "$EDITOR" = "both" ]; then
    echo "  Setting up Cursor (.cursor/)..."
    mkdir -p "$TARGET/.cursor/rules"
    mkdir -p "$TARGET/.cursor/commands"

    # Prepend Cursor's frontmatter to the shared editor rules
    {
        printf '%s\n' "---"
        printf '%s\n' "description: Analysis operating system — multi-session time series EDA protocol"
        printf '%s\n' "alwaysApply: true"
        printf '%s\n' "---"
        printf '\n'
        cat "$SCRIPT_DIR/editor.md"
    } > "$TARGET/.cursor/rules/analysis-os.mdc"

    cp "$SCRIPT_DIR"/commands/*.md "$TARGET/.cursor/commands/"
fi

# ─────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────

echo ""
echo "Done! Analysis project structure created:"
echo ""
find "$TARGET/docs" -type f 2>/dev/null | sort | while read f; do
    echo "  $f"
done
echo "  $TARGET/notebooks/"
echo "  $TARGET/data/raw/"
echo "  $TARGET/data/processed/"
echo "  $TARGET/reports/"
echo "  $TARGET/pyproject.toml"
if [ "$EDITOR" = "claude" ] || [ "$EDITOR" = "both" ]; then
    find "$TARGET/.claude" -type f 2>/dev/null | sort | while read f; do
        echo "  $f"
    done
fi
if [ "$EDITOR" = "cursor" ] || [ "$EDITOR" = "both" ]; then
    find "$TARGET/.cursor" -type f 2>/dev/null | sort | while read f; do
        echo "  $f"
    done
fi
echo ""
echo "Next steps:"
echo "  1. cd $TARGET"
echo "  2. uv sync  (or: pip install -e .)"
if [ "$EDITOR" = "claude" ]; then
    echo "  3. Open Claude Code and run /intake"
elif [ "$EDITOR" = "cursor" ]; then
    echo "  3. Open Cursor and run /intake in Agent mode"
else
    echo "  3. Open Claude Code or Cursor and run /intake"
fi
echo "  4. Follow the workflow: /brief → /scope → /decompose → /start"
echo ""
