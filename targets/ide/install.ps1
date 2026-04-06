# MachinEdge Expert Teams — Install (Windows)
# Usage: .\install.ps1 [-Editor cursor|claude|both] [-Target <project-directory>]
#
# Installs platform-native expert files into a project directory by copying
# pre-built implementations from targets/ide/<platform>/.
#
# Examples:
#   .\install.ps1 -Target ~\myproj                          # Both editors
#   .\install.ps1 -Editor cursor -Target ~\myproj           # Cursor only
#   .\install.ps1 -Editor claude -Target ~\myproj           # Claude Code only
#   .\install.ps1 -Target .                                 # Current directory, both editors

param(
    [ValidateSet("cursor", "claude", "both")]
    [string]$Editor = "both",

    [string]$Target = "."
)

$ErrorActionPreference = "Stop"

$ScriptDir = $PSScriptRoot
$CursorSrc = Join-Path $ScriptDir "cursor"
$ClaudeSrc = Join-Path $ScriptDir "claude-code"

if (-not (Test-Path $CursorSrc) -or -not (Test-Path $ClaudeSrc)) {
    Write-Error "Error: Platform source directories not found.`n  Expected: $CursorSrc and $ClaudeSrc"
    exit 2
}

if ($Target -ne ".") {
    New-Item -ItemType Directory -Path $Target -Force | Out-Null
}

$TargetFull = (Resolve-Path $Target).Path

Write-Host "MachinEdge Expert Teams - Install"
Write-Host "  Target: $TargetFull"
Write-Host "  Editor: $Editor"
Write-Host ""

# ─────────────────────────────────────────────
# Create shared project structure
# ─────────────────────────────────────────────

foreach ($dir in @(
    "docs/handoff-notes",
    "issues/backlog",
    "issues/planned",
    "issues/in-progress",
    "issues/done"
)) {
    New-Item -ItemType Directory -Path (Join-Path $Target $dir) -Force | Out-Null
}

foreach ($expert in @("pm", "swe", "qa", "devops", "system-architect")) {
    New-Item -ItemType Directory -Path (Join-Path $Target "docs/handoff-notes/$expert") -Force | Out-Null
}

$lessonsLog = Join-Path $Target "docs/lessons-log.md"
if (-not (Test-Path $lessonsLog)) {
    @"
# Lessons Log

Record project-specific gotchas, patterns, and knowledge here. Future sessions will read this to avoid repeating mistakes.

| Lesson | Context |
|--------|---------|
"@ | Set-Content -Path $lessonsLog -Encoding UTF8
}

# ─────────────────────────────────────────────
# Clean previous installation (managed files only)
# ─────────────────────────────────────────────

$ManagedPrefixes = @("pm", "swe", "qa", "ops", "sa", "da", "ux", "team")

if ($Editor -eq "cursor" -or $Editor -eq "both") {
    Get-ChildItem (Join-Path $Target ".cursor/rules/*-os.mdc") -ErrorAction SilentlyContinue | Remove-Item -Force
    Remove-Item (Join-Path $Target ".cursor/rules/project-os.mdc") -ErrorAction SilentlyContinue -Force
    foreach ($prefix in $ManagedPrefixes) {
        Get-ChildItem (Join-Path $Target ".cursor/commands/${prefix}-*.md") -ErrorAction SilentlyContinue | Remove-Item -Force
        Get-ChildItem (Join-Path $Target ".cursor/skills/${prefix}-*") -Directory -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force
    }
    Get-ChildItem (Join-Path $Target ".cursor/scripts/move-issue.*") -ErrorAction SilentlyContinue | Remove-Item -Force
    Get-ChildItem (Join-Path $Target ".cursor/scripts/next-issue-number.*") -ErrorAction SilentlyContinue | Remove-Item -Force
    Get-ChildItem (Join-Path $Target ".cursor/scripts/next-session-number.*") -ErrorAction SilentlyContinue | Remove-Item -Force
    Get-ChildItem (Join-Path $Target ".cursor/scripts/update-issues-list.*") -ErrorAction SilentlyContinue | Remove-Item -Force
    Get-ChildItem (Join-Path $Target ".cursor/scripts/update-brief-status.*") -ErrorAction SilentlyContinue | Remove-Item -Force
}

if ($Editor -eq "claude" -or $Editor -eq "both") {
    Remove-Item (Join-Path $Target ".claude/CLAUDE.md") -ErrorAction SilentlyContinue -Force
    if (Test-Path (Join-Path $Target ".claude/roles")) {
        Remove-Item (Join-Path $Target ".claude/roles") -Recurse -Force
    }
    foreach ($prefix in $ManagedPrefixes) {
        Get-ChildItem (Join-Path $Target ".claude/commands/${prefix}-*.md") -ErrorAction SilentlyContinue | Remove-Item -Force
        Get-ChildItem (Join-Path $Target ".claude/skills/${prefix}-*") -Directory -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force
    }
    Get-ChildItem (Join-Path $Target ".claude/scripts/move-issue.*") -ErrorAction SilentlyContinue | Remove-Item -Force
    Get-ChildItem (Join-Path $Target ".claude/scripts/next-issue-number.*") -ErrorAction SilentlyContinue | Remove-Item -Force
    Get-ChildItem (Join-Path $Target ".claude/scripts/next-session-number.*") -ErrorAction SilentlyContinue | Remove-Item -Force
    Get-ChildItem (Join-Path $Target ".claude/scripts/update-issues-list.*") -ErrorAction SilentlyContinue | Remove-Item -Force
    Get-ChildItem (Join-Path $Target ".claude/scripts/update-brief-status.*") -ErrorAction SilentlyContinue | Remove-Item -Force
    Remove-Item (Join-Path $Target ".claude/scripts/session-primer.sh") -ErrorAction SilentlyContinue -Force
}

# ─────────────────────────────────────────────
# Helper: copy skills (each is a subfolder with SKILL.md)
# ─────────────────────────────────────────────

function Copy-Skills {
    param([string]$Src, [string]$Dest)
    New-Item -ItemType Directory -Path $Dest -Force | Out-Null
    Get-ChildItem $Src -Directory -ErrorAction SilentlyContinue | ForEach-Object {
        $skillDest = Join-Path $Dest $_.Name
        New-Item -ItemType Directory -Path $skillDest -Force | Out-Null
        $skillFile = Join-Path $_.FullName "SKILL.md"
        if (Test-Path $skillFile) {
            Copy-Item $skillFile -Destination $skillDest -Force
        }
    }
}

# ─────────────────────────────────────────────
# Helper: copy scripts, skip test/dev files
# ─────────────────────────────────────────────

function Copy-Scripts {
    param([string]$Src, [string]$Dest)
    New-Item -ItemType Directory -Path $Dest -Force | Out-Null
    Get-ChildItem $Src -File -ErrorAction SilentlyContinue | Where-Object {
        $_.Name -notmatch '^test-' -and $_.Name -ne '.gitkeep'
    } | ForEach-Object {
        Copy-Item $_.FullName -Destination $Dest -Force
    }
}

# ─────────────────────────────────────────────
# Helper: copy commands, skip .gitkeep
# ─────────────────────────────────────────────

function Copy-Commands {
    param([string]$Src, [string]$Dest)
    New-Item -ItemType Directory -Path $Dest -Force | Out-Null
    Get-ChildItem (Join-Path $Src "*.md") -ErrorAction SilentlyContinue | ForEach-Object {
        Copy-Item $_.FullName -Destination $Dest -Force
    }
}

# ─────────────────────────────────────────────
# Helper: merge settings.json (Claude Code hooks)
# ─────────────────────────────────────────────

function Merge-Settings {
    param([string]$TargetDir)
    $existing = Join-Path $TargetDir ".claude/settings.json"
    $source = Join-Path $ClaudeSrc "settings.json"

    if (-not (Test-Path $source)) { return }

    if (-not (Test-Path $existing)) {
        Copy-Item $source -Destination $existing -Force
        Write-Host "    Settings: created .claude/settings.json"
        return
    }

    try {
        $existingJson = Get-Content $existing -Raw | ConvertFrom-Json
        $newJson = Get-Content $source -Raw | ConvertFrom-Json

        if (-not (Get-Member -InputObject $existingJson -Name "hooks" -MemberType Properties)) {
            $existingJson | Add-Member -NotePropertyName "hooks" -NotePropertyValue ([PSCustomObject]@{})
        }

        $newJson.hooks.PSObject.Properties | ForEach-Object {
            if (Get-Member -InputObject $existingJson.hooks -Name $_.Name -MemberType Properties) {
                $existingJson.hooks.$($_.Name) = $_.Value
            } else {
                $existingJson.hooks | Add-Member -NotePropertyName $_.Name -NotePropertyValue $_.Value
            }
        }

        $existingJson | ConvertTo-Json -Depth 10 | Set-Content $existing -Encoding UTF8
        Write-Host "    Settings: merged hooks into existing .claude/settings.json"
    } catch {
        Write-Host "    WARNING: Could not merge settings.json: $_"
        Write-Host "    Please manually merge hooks from: $source"
        Write-Host "    Into: $existing"
    }
}

# ─────────────────────────────────────────────
# Install Cursor
# ─────────────────────────────────────────────

if ($Editor -eq "cursor" -or $Editor -eq "both") {
    Write-Host "  [cursor] Installing platform-native files..."

    $rulesDir = Join-Path $Target ".cursor/rules"
    New-Item -ItemType Directory -Path $rulesDir -Force | Out-Null
    Copy-Item (Join-Path $CursorSrc "rules/*.mdc") -Destination $rulesDir -Force

    Copy-Commands -Src (Join-Path $CursorSrc "commands") -Dest (Join-Path $Target ".cursor/commands")
    Copy-Skills -Src (Join-Path $CursorSrc "skills") -Dest (Join-Path $Target ".cursor/skills")
    Copy-Scripts -Src (Join-Path $CursorSrc "scripts") -Dest (Join-Path $Target ".cursor/scripts")

    $ruleCount = (Get-ChildItem (Join-Path $Target ".cursor/rules/*.mdc") -ErrorAction SilentlyContinue).Count
    $cmdCount = (Get-ChildItem (Join-Path $Target ".cursor/commands/*.md") -ErrorAction SilentlyContinue).Count
    $skillCount = (Get-ChildItem (Join-Path $Target ".cursor/skills") -Directory -ErrorAction SilentlyContinue).Count
    $scriptCount = (Get-ChildItem (Join-Path $Target ".cursor/scripts") -File -ErrorAction SilentlyContinue).Count
    Write-Host "    Rules: $ruleCount files"
    Write-Host "    Commands: $cmdCount files"
    Write-Host "    Skills: $skillCount folders"
    Write-Host "    Scripts: $scriptCount files"
}

# ─────────────────────────────────────────────
# Install Claude Code
# ─────────────────────────────────────────────

if ($Editor -eq "claude" -or $Editor -eq "both") {
    Write-Host "  [claude] Installing platform-native files..."

    $claudeDir = Join-Path $Target ".claude"
    New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null
    Copy-Item (Join-Path $ClaudeSrc "CLAUDE.md") -Destination $claudeDir -Force

    $rolesDir = Join-Path $Target ".claude/roles"
    New-Item -ItemType Directory -Path $rolesDir -Force | Out-Null
    Copy-Item (Join-Path $ClaudeSrc "roles/*.md") -Destination $rolesDir -Force

    Copy-Commands -Src (Join-Path $ClaudeSrc "commands") -Dest (Join-Path $Target ".claude/commands")
    Copy-Skills -Src (Join-Path $ClaudeSrc "skills") -Dest (Join-Path $Target ".claude/skills")
    Copy-Scripts -Src (Join-Path $ClaudeSrc "scripts") -Dest (Join-Path $Target ".claude/scripts")

    Merge-Settings -TargetDir $Target

    $roleCount = (Get-ChildItem (Join-Path $Target ".claude/roles/*.md") -ErrorAction SilentlyContinue).Count
    $cmdCount = (Get-ChildItem (Join-Path $Target ".claude/commands/*.md") -ErrorAction SilentlyContinue).Count
    $skillCount = (Get-ChildItem (Join-Path $Target ".claude/skills") -Directory -ErrorAction SilentlyContinue).Count
    $scriptCount = (Get-ChildItem (Join-Path $Target ".claude/scripts") -File -ErrorAction SilentlyContinue).Count
    Write-Host "    Roles: $roleCount files"
    Write-Host "    Commands: $cmdCount files"
    Write-Host "    Skills: $skillCount folders"
    Write-Host "    Scripts: $scriptCount files"
}

# ─────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────

$ToolkitRoot = (Resolve-Path (Join-Path $ScriptDir ".." "..")).Path
$SyncPs1 = Join-Path $ToolkitRoot "tools/sync.ps1"

Write-Host ""
Write-Host "Done! Installed to: $TargetFull"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. cd $TargetFull"
if ($Editor -eq "claude") {
    Write-Host "  2. Open Claude Code and run /pm-interview to start a new project"
} elseif ($Editor -eq "cursor") {
    Write-Host "  2. Open Cursor and run /pm-interview in Agent mode to start a new project"
} else {
    Write-Host "  2. Open Claude Code or Cursor and run /pm-interview to start a new project"
}
Write-Host "  3. Or run /team-status to see the project health summary"
Write-Host ""
if (Test-Path $SyncPs1) {
    Write-Host "Maintenance:"
    Write-Host "  To check for updates:  $SyncPs1 check $TargetFull"
    Write-Host "  To apply updates:      $SyncPs1 apply $TargetFull"
}
Write-Host ""
Write-Host "Uninstall:"
Write-Host "  To remove the toolkit, delete the managed files:"
if ($Editor -eq "cursor" -or $Editor -eq "both") {
    Write-Host "    Remove-Item .cursor/rules/*-os.mdc, .cursor/rules/project-os.mdc"
    Write-Host "    Remove-Item .cursor/commands/{pm,swe,qa,ops,sa,team}-*.md"
    Write-Host "    Remove-Item .cursor/skills/{pm,swe,qa,ops,sa,team}-* -Recurse"
    Write-Host "    Remove-Item .cursor/scripts/ -Recurse"
}
if ($Editor -eq "claude" -or $Editor -eq "both") {
    Write-Host "    Remove-Item .claude/CLAUDE.md"
    Write-Host "    Remove-Item .claude/roles/, .claude/commands/{pm,swe,qa,ops,sa,team}-*.md"
    Write-Host "    Remove-Item .claude/skills/{pm,swe,qa,ops,sa,team}-* -Recurse"
    Write-Host "    Remove-Item .claude/scripts/ -Recurse"
    Write-Host "    # Manually remove hooks from .claude/settings.json if desired"
}
Write-Host "  Project documents (docs/, issues/) are yours - they are not removed."
Write-Host ""
