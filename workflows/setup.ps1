# AI Project Toolkit — Top-Level Setup (Windows)
# Usage: .\setup.ps1 [-Editor claude|cursor|both] [-Workflows pm,swe,qa,devops] [-Target <project-directory>]
#
# Installs one or more workflows into a project directory.
# Delegates to each workflow's individual setup.ps1.
#
# Examples:
#   .\setup.ps1 -Target ~\myproj                                    # All workflows, both editors
#   .\setup.ps1 -Workflows "pm,swe" -Target ~\myproj                # Just PM and SWE
#   .\setup.ps1 -Workflows "pm,swe,qa" -Editor cursor -Target .     # PM+SWE+QA, Cursor only
#   .\setup.ps1 -Editor claude -Target ~\myproj                     # All workflows, Claude only

param(
    [ValidateSet("claude", "cursor", "both")]
    [string]$Editor = "both",

    [string]$Workflows = "pm,swe,qa,devops",

    [string]$Target = "."
)

$ErrorActionPreference = "Stop"

# Resolve the directory where this script lives (workflows/)
$ScriptDir = $PSScriptRoot

if ($Target -ne ".") {
    New-Item -ItemType Directory -Path $Target -Force | Out-Null
}

# Validate workflow names
$ValidWorkflows = @("pm", "swe", "qa", "devops")
$WorkflowList = $Workflows -split ',' | ForEach-Object { $_.Trim() }
foreach ($wf in $WorkflowList) {
    if ($wf -notin $ValidWorkflows) {
        Write-Error "Error: Unknown workflow '$wf'. Valid workflows: pm, swe, qa, devops"
        exit 1
    }
}

Write-Host "Setting up project toolkit in: $Target"
Write-Host "  Workflows: $Workflows"
Write-Host "  Editor: $Editor"
Write-Host ""

# ─────────────────────────────────────────────
# Run each workflow's setup script
# ─────────────────────────────────────────────

foreach ($wf in $WorkflowList) {
    $SetupScript = Join-Path $ScriptDir $wf "setup.ps1"
    if (Test-Path $SetupScript) {
        & $SetupScript -Editor $Editor -Target $Target
    } else {
        Write-Warning "No setup script found for '$wf' workflow at $SetupScript"
    }
}

# ─────────────────────────────────────────────
# Install shared commands (/status)
# ─────────────────────────────────────────────

Write-Host ""
Write-Host "  [shared] Installing shared commands..."

if ($Editor -eq "claude" -or $Editor -eq "both") {
    New-Item -ItemType Directory -Path "$Target/.claude/commands" -Force | Out-Null
    Copy-Item "$ScriptDir/shared/commands/*.md" -Destination "$Target/.claude/commands/" -Force
}

if ($Editor -eq "cursor" -or $Editor -eq "both") {
    New-Item -ItemType Directory -Path "$Target/.cursor/commands" -Force | Out-Null
    Copy-Item "$ScriptDir/shared/commands/*.md" -Destination "$Target/.cursor/commands/" -Force
}

Write-Host "    Shared commands installed: /status"

# ─────────────────────────────────────────────
# Generate the root CLAUDE.md / Cursor rules
# ─────────────────────────────────────────────

# Build the list of installed roles and their commands
$RoleLines = @()
$CommandLines = @()

foreach ($wf in $WorkflowList) {
    switch ($wf) {
        "pm" {
            $RoleLines += "- **PM** (``.claude/roles/pm.md``) --- Product/project management: discovery, planning, scoping"
            $CommandLines += "- ``/interview`` --- Structured interview for new projects (PM)"
            $CommandLines += "- ``/add_feature`` --- Scope new work for existing project (PM)"
            $CommandLines += "- ``/vision`` --- Generate project brief from interview (PM)"
            $CommandLines += "- ``/roadmap`` --- Create milestone plan (PM)"
            $CommandLines += "- ``/decompose`` --- Break milestone into tasks (PM)"
            $CommandLines += "- ``/postmortem`` --- Review completed milestone (PM)"
        }
        "swe" {
            $RoleLines += "- **SWE** (``.claude/roles/swe.md``) --- Software engineering: implementation, testing, verification"
            $CommandLines += "- ``/start`` --- Begin execution session (SWE)"
            $CommandLines += "- ``/handoff`` --- End session, produce handoff note (SWE)"
        }
        "qa" {
            $RoleLines += "- **QA** (``.claude/roles/qa.md``) --- Quality assurance: review, test planning, regression"
            $CommandLines += "- ``/review`` --- Fresh-eyes code review (QA)"
            $CommandLines += "- ``/test-plan`` --- Generate test plan (QA)"
            $CommandLines += "- ``/regression`` --- Run regression check (QA)"
            $CommandLines += "- ``/bug-triage`` --- Prioritize bug backlog (QA)"
        }
        "devops" {
            $RoleLines += "- **DevOps** (``.claude/roles/devops.md``) --- Build, test, deploy: environments, pipelines, releases"
            $CommandLines += "- ``/env-discovery`` --- Capture environment context (DevOps)"
            $CommandLines += "- ``/pipeline`` --- Define build/test/deploy pipeline (DevOps)"
            $CommandLines += "- ``/release-plan`` --- Define release gates and rollback (DevOps)"
            $CommandLines += "- ``/deploy`` --- Execute release with verification (DevOps)"
        }
    }
}

# Always include /status
$CommandLines += "- ``/status`` --- Cross-workflow project health summary (Shared)"

$RolesBlock = $RoleLines -join "`n"
$CommandsBlock = $CommandLines -join "`n"

if ($Editor -eq "claude" -or $Editor -eq "both") {
    Write-Host ""
    Write-Host "  [claude] Generating .claude/CLAUDE.md..."
    @"
# Project Operating System

This project uses a multi-workflow AI toolkit. Each session, you operate in a specific role.

## Roles

Read the role file for your active role at the start of every session:
$RolesBlock

## Starting a Session

1. Ask the user which role they want for this session (PM, SWE, QA, or DevOps).
2. Read the corresponding role file from ``.claude/roles/``.
3. Follow that role's session protocol.

If the user jumps straight into a command (e.g. ``/start``), infer the role from the command and load the appropriate role file automatically.

## Available Commands
$CommandsBlock

## Shared Principles

- You have no memory between sessions. Project documents ARE your memory.
- The project brief (``docs/project-brief.md``) is the source of truth.
- Keep the project brief under 1,000 words.
- Verify your work. "It should work" is not verification.
"@ | Set-Content -Path "$Target/.claude/CLAUDE.md" -Encoding UTF8
}

if ($Editor -eq "cursor" -or $Editor -eq "both") {
    Write-Host "  [cursor] Generating .cursor/rules/project-os.mdc..."
    @"
---
description: Project operating system --- multi-workflow AI toolkit
alwaysApply: true
---

# Project Operating System

This project uses a multi-workflow AI toolkit. Each session, you operate in a specific role.

## Roles

Read the role file for your active role at the start of every session:
$RolesBlock

Role files are in ``.cursor/rules/`` as ``<workflow>-os.mdc``.

## Starting a Session

1. Ask the user which role they want for this session (PM, SWE, QA, or DevOps).
2. Read the corresponding role rules file.
3. Follow that role's session protocol.

If the user jumps straight into a command (e.g. ``/start``), infer the role from the command and load the appropriate role file automatically.

## Available Commands
$CommandsBlock

## Shared Principles

- You have no memory between sessions. Project documents ARE your memory.
- The project brief (``docs/project-brief.md``) is the source of truth.
- Keep the project brief under 1,000 words.
- Verify your work. "It should work" is not verification.
"@ | Set-Content -Path "$Target/.cursor/rules/project-os.mdc" -Encoding UTF8
}

# ─────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────

Write-Host ""
Write-Host "Done! Project structure:"
Write-Host ""

Get-ChildItem "$Target/docs" -Recurse -File -ErrorAction SilentlyContinue | Sort-Object FullName | ForEach-Object {
    Write-Host "  $($_.FullName)"
}
if ($Editor -eq "claude" -or $Editor -eq "both") {
    Get-ChildItem "$Target/.claude" -Recurse -File -ErrorAction SilentlyContinue | Sort-Object FullName | ForEach-Object {
        Write-Host "  $($_.FullName)"
    }
}
if ($Editor -eq "cursor" -or $Editor -eq "both") {
    Get-ChildItem "$Target/.cursor" -Recurse -File -ErrorAction SilentlyContinue | Sort-Object FullName | ForEach-Object {
        Write-Host "  $($_.FullName)"
    }
}

Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. cd $Target"
if ($Editor -eq "claude") {
    Write-Host "  2. Open Claude Code and run /interview to start a new project"
} elseif ($Editor -eq "cursor") {
    Write-Host "  2. Open Cursor and run /interview in Agent mode to start a new project"
} else {
    Write-Host "  2. Open Claude Code or Cursor and run /interview to start a new project"
}
Write-Host "  3. Or run /status to see the project health summary"
Write-Host ""
