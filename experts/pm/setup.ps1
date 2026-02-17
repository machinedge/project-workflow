# PM Workflow — Setup (Windows)
# Usage: .\setup.ps1 [-Editor claude|cursor|both] [-Target <project-directory>]
#
# Installs PM workflow commands and editor config into a project directory.
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

# Resolve the directory where this script lives (workflows/pm/)
$ScriptDir = $PSScriptRoot

if ($Target -ne ".") {
    New-Item -ItemType Directory -Path $Target -Force | Out-Null
}

Write-Host "  [pm] Installing PM workflow in: $Target (editor: $Editor)"

# ─────────────────────────────────────────────
# Shared docs directory
# ─────────────────────────────────────────────

New-Item -ItemType Directory -Path "$Target/docs/handoff-notes/pm" -Force | Out-Null
New-Item -ItemType Directory -Path "$Target/docs/handoff-notes/swe" -Force | Out-Null
New-Item -ItemType Directory -Path "$Target/docs/handoff-notes/qa" -Force | Out-Null
New-Item -ItemType Directory -Path "$Target/docs/handoff-notes/devops" -Force | Out-Null

if (-not (Test-Path "$Target/docs/lessons-log.md")) {
    @"
# Lessons Log

## Things the AI Does Well on This Project
- [to be filled in as you learn]

## Things the AI Struggles With on This Project
- [to be filled in]

## Prompting Lessons
- [what phrasing gets better results]

## Technical Gotchas
- [bugs, API quirks, environment issues]

## Process Adjustments
- [changes to how you run sessions]
"@ | Set-Content -Path "$Target/docs/lessons-log.md" -Encoding UTF8
}

# ─────────────────────────────────────────────
# Claude Code setup
# editor.md → .claude/roles/pm.md
# commands → .claude/commands/
# ─────────────────────────────────────────────

if ($Editor -eq "claude" -or $Editor -eq "both") {
    Write-Host "    Setting up Claude Code (.claude/)..."
    New-Item -ItemType Directory -Path "$Target/.claude/commands" -Force | Out-Null
    New-Item -ItemType Directory -Path "$Target/.claude/roles" -Force | Out-Null
    Copy-Item "$ScriptDir/editor.md" -Destination "$Target/.claude/roles/pm.md" -Force
    Copy-Item "$ScriptDir/commands/*.md" -Destination "$Target/.claude/commands/" -Force
}

# ─────────────────────────────────────────────
# Cursor setup
# editor.md + YAML frontmatter → .cursor/rules/pm-os.mdc
# commands → .cursor/commands/
# ─────────────────────────────────────────────

if ($Editor -eq "cursor" -or $Editor -eq "both") {
    Write-Host "    Setting up Cursor (.cursor/)..."
    New-Item -ItemType Directory -Path "$Target/.cursor/rules" -Force | Out-Null
    New-Item -ItemType Directory -Path "$Target/.cursor/commands" -Force | Out-Null

    # Prepend Cursor's frontmatter to the PM editor rules
    $frontmatter = @"
---
description: PM operating system — product/project management protocol
alwaysApply: false
---

"@
    $editorContent = Get-Content "$ScriptDir/editor.md" -Raw
    ($frontmatter + $editorContent) | Set-Content -Path "$Target/.cursor/rules/pm-os.mdc" -Encoding UTF8

    Copy-Item "$ScriptDir/commands/*.md" -Destination "$Target/.cursor/commands/" -Force
}

# ─────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────

Write-Host "    PM commands installed: /interview, /add_feature, /vision, /roadmap, /decompose, /postmortem"
