# MachinEdge Expert Teams — Install (Windows)
# Usage: .\install.ps1 [-Editor claude|cursor|both] [-Experts pm,swe,qa,devops] [-Domain technical] [-Target <project-directory>]
#
# Installs one or more experts into a project directory by translating
# platform-agnostic expert definitions into editor-specific configurations.
#
# Expert short names are mapped to their full directory names:
#   pm → project-manager, swe → swe, qa → qa, devops → devops, data-analyst → data-analyst
#
# Skill prefix mapping (for flat command namespaces):
#   pm- → project-manager, swe- → swe, qa- → qa, ops- → devops
#   da- → data-analyst, ux- → user-experience, team- → shared
#
# Examples:
#   .\install.ps1 -Target ~\myproj                                      # All core experts, both editors
#   .\install.ps1 -Experts "pm,swe" -Target ~\myproj                    # Just PM and SWE
#   .\install.ps1 -Experts "pm,swe,qa" -Editor cursor -Target .         # PM+SWE+QA, Cursor only
#   .\install.ps1 -Editor claude -Target ~\myproj                       # All core experts, Claude only

param(
    [ValidateSet("claude", "cursor", "both")]
    [string]$Editor = "both",

    [string]$Experts = "project-manager,swe,qa,devops",

    [string]$Domain = "technical",

    [string]$Target = "."
)

$ErrorActionPreference = "Stop"

# Resolve paths
$ScriptDir = $PSScriptRoot
# Skill root is two levels up from framework/install/
$SkillRoot = (Resolve-Path (Join-Path $ScriptDir ".." "..")).Path
if (-not (Test-Path (Join-Path $SkillRoot "experts"))) {
    Write-Error "Error: Could not find experts/ directory at $(Join-Path $SkillRoot 'experts')`n  Expected script location: <skill-root>/framework/install/"
    exit 1
}

if ($Target -ne ".") {
    New-Item -ItemType Directory -Path $Target -Force | Out-Null
}

# ─────────────────────────────────────────────
# Map short names to full expert directory names
# ─────────────────────────────────────────────

function Resolve-ExpertName {
    param([string]$Name)
    switch ($Name) {
        "pm"              { return "project-manager" }
        "project-manager" { return "project-manager" }
        "swe"             { return "swe" }
        "qa"              { return "qa" }
        "devops"          { return "devops" }
        "eda"             { return "data-analyst" }
        "data-analyst"    { return "data-analyst" }
        "ux"              { return "user-experience" }
        "user-experience" { return "user-experience" }
        default           { return $Name }
    }
}

# ─────────────────────────────────────────────
# Map expert directory names to short prefixes
# Used to namespace skills in flat command directories
# ─────────────────────────────────────────────

function Resolve-ExpertPrefix {
    param([string]$Name)
    switch ($Name) {
        "project-manager" { return "pm" }
        "swe"             { return "swe" }
        "qa"              { return "qa" }
        "devops"          { return "ops" }
        "data-analyst"    { return "da" }
        "user-experience" { return "ux" }
        default           { return $Name }
    }
}

$ExpertList = $Experts -split ',' | ForEach-Object {
    $resolved = Resolve-ExpertName $_.Trim()
    $expertDir = Join-Path $SkillRoot "experts" $Domain $resolved
    if (-not (Test-Path $expertDir)) {
        Write-Error "Error: Expert '$_' (resolved to '$resolved') not found at $expertDir"
        exit 1
    }
    $resolved
}

Write-Host "Setting up expert team in: $Target"
Write-Host "  Experts: $($ExpertList -join ', ')"
Write-Host "  Domain: $Domain"
Write-Host "  Editor: $Editor"
Write-Host ""

# ─────────────────────────────────────────────
# Create shared project structure
# ─────────────────────────────────────────────

New-Item -ItemType Directory -Path "$Target/docs/handoff-notes" -Force | Out-Null
New-Item -ItemType Directory -Path "$Target/issues" -Force | Out-Null

if (-not (Test-Path "$Target/docs/lessons-log.md")) {
    @"
# Lessons Log

Record project-specific gotchas, patterns, and knowledge here. Future sessions will read this to avoid repeating mistakes.

| Date | Lesson | Context |
|------|--------|---------|
"@ | Set-Content -Path "$Target/docs/lessons-log.md" -Encoding UTF8
}

# Create handoff-notes subdirectories for each expert
foreach ($expert in $ExpertList) {
    New-Item -ItemType Directory -Path "$Target/docs/handoff-notes/$expert" -Force | Out-Null
}

# ─────────────────────────────────────────────
# Clean previous installation (managed files only)
# Preserves user content in docs/, issues/, and
# any custom commands without our known prefixes
# ─────────────────────────────────────────────

if ($Editor -eq "claude" -or $Editor -eq "both") {
    # Remove managed commands (known prefixes only)
    foreach ($prefix in @("pm", "swe", "qa", "ops", "da", "ux", "team")) {
        Get-ChildItem "$Target/.claude/commands/${prefix}-*.md" -ErrorAction SilentlyContinue | Remove-Item -Force
    }
    # Remove managed roles and generated root config
    if (Test-Path "$Target/.claude/roles") { Remove-Item "$Target/.claude/roles" -Recurse -Force }
    Remove-Item "$Target/.claude/CLAUDE.md" -ErrorAction SilentlyContinue -Force
}

if ($Editor -eq "cursor" -or $Editor -eq "both") {
    # Remove managed commands (known prefixes only)
    foreach ($prefix in @("pm", "swe", "qa", "ops", "da", "ux", "team")) {
        Get-ChildItem "$Target/.cursor/commands/${prefix}-*.md" -ErrorAction SilentlyContinue | Remove-Item -Force
    }
    # Remove managed rules and generated root config
    Get-ChildItem "$Target/.cursor/rules/*-os.mdc" -ErrorAction SilentlyContinue | Remove-Item -Force
    Remove-Item "$Target/.cursor/rules/project-os.mdc" -ErrorAction SilentlyContinue -Force
}

# ─────────────────────────────────────────────
# Install each expert's definition
# ─────────────────────────────────────────────

foreach ($expert in $ExpertList) {
    $ExpertSrc = Join-Path $SkillRoot "experts" $Domain $expert
    Write-Host "  [$expert] Installing expert definition..."

    # Claude Code: role.md → .claude/roles/<expert>.md, skills → .claude/commands/
    if ($Editor -eq "claude" -or $Editor -eq "both") {
        New-Item -ItemType Directory -Path "$Target/.claude/roles" -Force | Out-Null
        New-Item -ItemType Directory -Path "$Target/.claude/commands" -Force | Out-Null

        $roleFile = Join-Path $ExpertSrc "role.md"
        if (Test-Path $roleFile) {
            Copy-Item $roleFile -Destination "$Target/.claude/roles/$expert.md" -Force
        }

        $skillsDir = Join-Path $ExpertSrc "skills"
        if (Test-Path $skillsDir) {
            $prefix = Resolve-ExpertPrefix $expert
            Get-ChildItem "$skillsDir/*.md" -ErrorAction SilentlyContinue | ForEach-Object {
                $normalizedName = $_.Name -replace '_', '-'
                Copy-Item $_.FullName -Destination "$Target/.claude/commands/${prefix}-${normalizedName}" -Force
            }
        }
    }

    # Cursor: role.md → .cursor/rules/<expert>-os.mdc (with frontmatter), skills → .cursor/commands/
    if ($Editor -eq "cursor" -or $Editor -eq "both") {
        New-Item -ItemType Directory -Path "$Target/.cursor/rules" -Force | Out-Null
        New-Item -ItemType Directory -Path "$Target/.cursor/commands" -Force | Out-Null

        $roleFile = Join-Path $ExpertSrc "role.md"
        if (Test-Path $roleFile) {
            $frontmatter = @"
---
description: $expert expert --- operating rules
alwaysApply: true
---

"@
            $roleContent = Get-Content $roleFile -Raw
            ($frontmatter + $roleContent) | Set-Content -Path "$Target/.cursor/rules/${expert}-os.mdc" -Encoding UTF8
        }

        $skillsDir = Join-Path $ExpertSrc "skills"
        if (Test-Path $skillsDir) {
            $prefix = Resolve-ExpertPrefix $expert
            Get-ChildItem "$skillsDir/*.md" -ErrorAction SilentlyContinue | ForEach-Object {
                $normalizedName = $_.Name -replace '_', '-'
                Copy-Item $_.FullName -Destination "$Target/.cursor/commands/${prefix}-${normalizedName}" -Force
            }
        }
    }

    # Copy expert tools to project if any exist (beyond .gitkeep)
    $toolsDir = Join-Path $ExpertSrc "tools"
    if (Test-Path $toolsDir) {
        $tools = Get-ChildItem $toolsDir -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne ".gitkeep" }
        if ($tools) {
            New-Item -ItemType Directory -Path "$Target/tools/$expert" -Force | Out-Null
            $tools | ForEach-Object { Copy-Item $_.FullName -Destination "$Target/tools/$expert/" -Force }
            Write-Host "    Copied $($tools.Count) tool(s) to tools/$expert/"
        }
    }
}

# ─────────────────────────────────────────────
# Install shared skills (e.g., /status)
# ─────────────────────────────────────────────

$SharedDir = Join-Path $SkillRoot "experts" $Domain "shared"
$SharedSkillsDir = Join-Path $SharedDir "skills"
if (Test-Path $SharedSkillsDir) {
    Write-Host ""
    Write-Host "  [shared] Installing shared skills..."

    if ($Editor -eq "claude" -or $Editor -eq "both") {
        Get-ChildItem "$SharedSkillsDir/*.md" -ErrorAction SilentlyContinue | ForEach-Object {
            $normalizedName = $_.Name -replace '_', '-'
            Copy-Item $_.FullName -Destination "$Target/.claude/commands/team-${normalizedName}" -Force
        }
    }

    if ($Editor -eq "cursor" -or $Editor -eq "both") {
        Get-ChildItem "$SharedSkillsDir/*.md" -ErrorAction SilentlyContinue | ForEach-Object {
            $normalizedName = $_.Name -replace '_', '-'
            Copy-Item $_.FullName -Destination "$Target/.cursor/commands/team-${normalizedName}" -Force
        }
    }
}

# ─────────────────────────────────────────────
# Generate the root CLAUDE.md / Cursor rules
# ─────────────────────────────────────────────

$RoleLines = @()
$SkillLines = @()

foreach ($expert in $ExpertList) {
    $ExpertSrc = Join-Path $SkillRoot "experts" $Domain $expert

    # Extract display name from first line of role.md
    $roleFile = Join-Path $ExpertSrc "role.md"
    if (Test-Path $roleFile) {
        $firstLine = (Get-Content $roleFile -TotalCount 1) -replace '^#\s*', '' -replace ' Operating System$', ''
        $DisplayName = $firstLine
    } else {
        $DisplayName = $expert
    }

    $RoleLines += "- **$DisplayName** (``.claude/roles/$expert.md``)"

    $skillsDir = Join-Path $ExpertSrc "skills"
    if (Test-Path $skillsDir) {
        $prefix = Resolve-ExpertPrefix $expert
        Get-ChildItem "$skillsDir/*.md" -ErrorAction SilentlyContinue | ForEach-Object {
            $skillName = $_.BaseName -replace '_', '-'
            $SkillLines += "- ``/${prefix}-${skillName}`` ($DisplayName)"
        }
    }
}

# Add shared skills
if (Test-Path $SharedSkillsDir) {
    Get-ChildItem "$SharedSkillsDir/*.md" -ErrorAction SilentlyContinue | ForEach-Object {
        $skillName = $_.BaseName -replace '_', '-'
        $SkillLines += "- ``/team-${skillName}`` (Shared)"
    }
}

$RolesBlock = $RoleLines -join "`n"
$SkillsBlock = $SkillLines -join "`n"

if ($Editor -eq "claude" -or $Editor -eq "both") {
    Write-Host ""
    Write-Host "  [claude] Generating .claude/CLAUDE.md..."
    @"
# Project Operating System

This project uses the MachinEdge Expert Teams toolkit. Each session, you operate as a specific expert.

## Experts

Read the role file for your active expert at the start of every session:
$RolesBlock

## Starting a Session

1. Ask the user which expert role they want for this session.
2. Read the corresponding role file from ``.claude/roles/``.
3. Follow that expert's session protocol.

If the user jumps straight into a skill (e.g. ``/swe-start``), infer the expert from the skill prefix and load the appropriate role file automatically. Skill prefixes: pm=Project Manager, swe=SWE, qa=QA, ops=DevOps, da=Data Analyst, ux=User Experience, team=Shared.

## Available Skills
$SkillsBlock

## Shared Principles

- You have no memory between sessions. Project documents ARE your memory.
- The project brief (``docs/project-brief.md``) is the source of truth.
- Keep the project brief under 1,000 words.
- Verify your work. "It should work" is not verification.
- Issues are tracked in ``issues/``, not external services.
"@ | Set-Content -Path "$Target/.claude/CLAUDE.md" -Encoding UTF8
}

if ($Editor -eq "cursor" -or $Editor -eq "both") {
    Write-Host "  [cursor] Generating .cursor/rules/project-os.mdc..."
    @"
---
description: Project operating system --- MachinEdge Expert Teams
alwaysApply: true
---

# Project Operating System

This project uses the MachinEdge Expert Teams toolkit. Each session, you operate as a specific expert.

## Experts

Read the role file for your active expert at the start of every session:
$RolesBlock

Role files are in ``.cursor/rules/`` as ``<expert>-os.mdc``.

## Starting a Session

1. Ask the user which expert role they want for this session.
2. Read the corresponding role rules file.
3. Follow that expert's session protocol.

If the user jumps straight into a skill (e.g. ``/swe-start``), infer the expert from the skill prefix and load the appropriate role file automatically. Skill prefixes: pm=Project Manager, swe=SWE, qa=QA, ops=DevOps, da=Data Analyst, ux=User Experience, team=Shared.

## Available Skills
$SkillsBlock

## Shared Principles

- You have no memory between sessions. Project documents ARE your memory.
- The project brief (``docs/project-brief.md``) is the source of truth.
- Keep the project brief under 1,000 words.
- Verify your work. "It should work" is not verification.
- Issues are tracked in ``issues/``, not external services.
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
    Write-Host "  2. Open Claude Code and run /pm-interview to start a new project"
} elseif ($Editor -eq "cursor") {
    Write-Host "  2. Open Cursor and run /pm-interview in Agent mode to start a new project"
} else {
    Write-Host "  2. Open Claude Code or Cursor and run /pm-interview to start a new project"
}
Write-Host "  3. Or run /team-status to see the project health summary"
Write-Host ""
