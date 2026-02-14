# Time Series EDA Toolkit — Setup (Windows)
# Usage: .\setup.ps1 [-Editor claude|cursor|both] [-Target <project-directory>]
#
# Copies editor config and commands into a project directory,
# and creates the analysis-specific directory structure.
#
# Examples:
#   .\setup.ps1                              # Both editors, current directory
#   .\setup.ps1 -Editor cursor -Target ~\myproj  # Cursor only
#   .\setup.ps1 -Editor claude -Target ~\myproj  # Claude Code only
#   .\setup.ps1 -Target ~\myproj                  # Both editors (default)

param(
    [ValidateSet("claude", "cursor", "both")]
    [string]$Editor = "both",

    [string]$Target = "."
)

$ErrorActionPreference = "Stop"

# Resolve the directory where this script lives (the toolkit root)
$ScriptDir = $PSScriptRoot

if ($Target -ne ".") {
    New-Item -ItemType Directory -Path $Target -Force | Out-Null
}

Write-Host "Setting up time series EDA toolkit in: $Target (editor: $Editor)"

# ─────────────────────────────────────────────
# Analysis directory structure
# ─────────────────────────────────────────────

New-Item -ItemType Directory -Path "$Target/docs/handoff-notes" -Force | Out-Null
New-Item -ItemType Directory -Path "$Target/notebooks" -Force | Out-Null
New-Item -ItemType Directory -Path "$Target/data/raw" -Force | Out-Null
New-Item -ItemType Directory -Path "$Target/data/processed" -Force | Out-Null
New-Item -ItemType Directory -Path "$Target/reports" -Force | Out-Null

# Placeholder files so git tracks empty directories
@("$Target/notebooks/.gitkeep", "$Target/data/raw/.gitkeep", "$Target/data/processed/.gitkeep", "$Target/reports/.gitkeep") | ForEach-Object {
    if (-not (Test-Path $_)) { New-Item -ItemType File -Path $_ -Force | Out-Null }
}

# ─────────────────────────────────────────────
# Lessons log (analysis-focused)
# ─────────────────────────────────────────────

if (-not (Test-Path "$Target/docs/lessons-log.md")) {
    @"
# Lessons Log

Record analysis-specific gotchas, data quirks, method pitfalls, and domain knowledge here. Future sessions will read this to avoid repeating mistakes.

| Date | Lesson | Context |
|------|--------|---------|
"@ | Set-Content -Path "$Target/docs/lessons-log.md" -Encoding UTF8
}

# ─────────────────────────────────────────────
# Data profile (living document)
# ─────────────────────────────────────────────

if (-not (Test-Path "$Target/docs/data-profile.md")) {
    @"
# Data Profile

This is a living document. Every analysis session should leave it richer than it was found. Record what you learn about the data here — characteristics, quality issues, discovered patterns, statistical properties.

## Dataset Overview
[To be populated during first ``/start`` session]

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
"@ | Set-Content -Path "$Target/docs/data-profile.md" -Encoding UTF8
}

# ─────────────────────────────────────────────
# .gitignore (data files, notebook checkpoints)
# ─────────────────────────────────────────────

if (-not (Test-Path "$Target/.gitignore")) {
    @"
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
"@ | Set-Content -Path "$Target/.gitignore" -Encoding UTF8
}

# ─────────────────────────────────────────────
# pyproject.toml (opinionated stack)
# ─────────────────────────────────────────────

if (-not (Test-Path "$Target/pyproject.toml")) {
    @"
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
"@ | Set-Content -Path "$Target/pyproject.toml" -Encoding UTF8
}

# ─────────────────────────────────────────────
# Claude Code setup
# editor.md is copied as-is to .claude/CLAUDE.md
# ─────────────────────────────────────────────

if ($Editor -eq "claude" -or $Editor -eq "both") {
    Write-Host "  Setting up Claude Code (.claude/)..."
    New-Item -ItemType Directory -Path "$Target/.claude/commands" -Force | Out-Null
    Copy-Item "$ScriptDir/editor.md" -Destination "$Target/.claude/CLAUDE.md" -Force
    Copy-Item "$ScriptDir/commands/*.md" -Destination "$Target/.claude/commands/" -Force
}

# ─────────────────────────────────────────────
# Cursor setup
# editor.md + YAML frontmatter → .cursor/rules/analysis-os.mdc
# ─────────────────────────────────────────────

if ($Editor -eq "cursor" -or $Editor -eq "both") {
    Write-Host "  Setting up Cursor (.cursor/)..."
    New-Item -ItemType Directory -Path "$Target/.cursor/rules" -Force | Out-Null
    New-Item -ItemType Directory -Path "$Target/.cursor/commands" -Force | Out-Null

    # Prepend Cursor's frontmatter to the shared editor rules
    $frontmatter = @"
---
description: Analysis operating system — multi-session time series EDA protocol
alwaysApply: true
---

"@
    $editorContent = Get-Content "$ScriptDir/editor.md" -Raw
    ($frontmatter + $editorContent) | Set-Content -Path "$Target/.cursor/rules/analysis-os.mdc" -Encoding UTF8

    Copy-Item "$ScriptDir/commands/*.md" -Destination "$Target/.cursor/commands/" -Force
}

# ─────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────

Write-Host ""
Write-Host "Done! Analysis project structure created:"
Write-Host ""

Get-ChildItem "$Target/docs" -Recurse -File | Sort-Object FullName | ForEach-Object {
    Write-Host "  $($_.FullName)"
}
Write-Host "  $Target/notebooks/"
Write-Host "  $Target/data/raw/"
Write-Host "  $Target/data/processed/"
Write-Host "  $Target/reports/"
Write-Host "  $Target/pyproject.toml"

if ($Editor -eq "claude" -or $Editor -eq "both") {
    Get-ChildItem "$Target/.claude" -Recurse -File | Sort-Object FullName | ForEach-Object {
        Write-Host "  $($_.FullName)"
    }
}
if ($Editor -eq "cursor" -or $Editor -eq "both") {
    Get-ChildItem "$Target/.cursor" -Recurse -File | Sort-Object FullName | ForEach-Object {
        Write-Host "  $($_.FullName)"
    }
}

Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. cd $Target"
Write-Host "  2. uv sync  (or: pip install -e .)"
if ($Editor -eq "claude") {
    Write-Host "  3. Open Claude Code and run /intake"
} elseif ($Editor -eq "cursor") {
    Write-Host "  3. Open Cursor and run /intake in Agent mode"
} else {
    Write-Host "  3. Open Claude Code or Cursor and run /intake"
}
Write-Host "  4. Follow the workflow: /brief -> /scope -> /decompose -> /start"
Write-Host ""
