# MachinEdge Expert Teams — Install (Windows)
# Usage: .\install.ps1 [-NoClaude] [-Target <project-directory>]
#
# Installs the generic expert toolkit into a project from agents/:
#   AGENTS.md            Top-level operating-system file (read by Codex and any
#                        harness that follows the AGENTS.md convention).
#   CLAUDE.md -> AGENTS.md  Symlink (or copy fallback) so Claude Code reads the same file.
#   .agents\             Copy of the toolkit source (roles, commands, skills, scripts).
#   .claude\             Claude-native wiring — command/skill/role/script links into
#                        .agents\ plus the SessionStart settings hook. Skipped with -NoClaude.
#
# Note on symlinks: creating symlinks on Windows requires Developer Mode or an
# elevated shell. When symlink creation fails, this script falls back to copying
# (with a warning) so the install still completes.
#
# Examples:
#   .\install.ps1 -Target ~\myproj            # Full install
#   .\install.ps1 -NoClaude -Target ~\myproj  # Generic only (Codex / other harnesses)
#   .\install.ps1 -Target .                   # Current directory

param(
    [switch]$NoClaude,

    [string]$Target = "."
)

$ErrorActionPreference = "Stop"

$ScriptDir = $PSScriptRoot
$Source = Join-Path $ScriptDir "agents"

if (-not (Test-Path $Source)) {
    Write-Error "Error: toolkit source directory not found.`n  Expected: $Source"
    exit 2
}

if ($Target -ne ".") {
    New-Item -ItemType Directory -Path $Target -Force | Out-Null
}

$TargetFull = (Resolve-Path $Target).Path

Write-Host "MachinEdge Expert Teams - Install"
Write-Host "  Target: $TargetFull"
if ($NoClaude) {
    Write-Host "  Mode:   AGENTS.md flow only (-NoClaude)"
} else {
    Write-Host "  Mode:   AGENTS.md flow + Claude Code wiring"
}
Write-Host ""

# ─────────────────────────────────────────────
# Create shared project structure
# ─────────────────────────────────────────────

# docs/ always needed for core planning docs (project-brief, roadmap, architecture, etc.)
New-Item -ItemType Directory -Path (Join-Path $Target "docs") -Force | Out-Null

# ─────────────────────────────────────────────
# Migrate old directory layout to .sdlc/
# ─────────────────────────────────────────────

function Migrate-Directory {
    param([string]$Src, [string]$Dest)
    if (-not (Test-Path $Src)) { return $false }
    if (Test-Path $Dest) {
        Copy-Item "$Src/*" -Destination $Dest -Recurse -Force
        Remove-Item $Src -Recurse -Force
    } else {
        $parent = Split-Path $Dest -Parent
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
        Move-Item $Src -Destination $Dest
    }
    return $true
}

function Migrate-File {
    param([string]$Src, [string]$Dest)
    if (-not (Test-Path $Src)) { return $false }
    $parent = Split-Path $Dest -Parent
    New-Item -ItemType Directory -Path $parent -Force | Out-Null
    if (Test-Path $Dest) {
        Remove-Item $Src -Force
    } else {
        Move-Item $Src -Destination $Dest
    }
    return $true
}

$oldHandoff = Join-Path $Target "docs/handoff-notes"
$oldIssues = Join-Path $Target "issues"

if ((Test-Path $oldHandoff) -or (Test-Path $oldIssues)) {
    Write-Host "  Migrating artifacts to .sdlc/..."

    if (Migrate-Directory -Src (Join-Path $Target "docs/handoff-notes") -Dest (Join-Path $Target ".sdlc/handoff-notes")) {
        Write-Host "    docs/handoff-notes/ -> .sdlc/handoff-notes/"
    }
    if (Migrate-Directory -Src (Join-Path $Target "issues") -Dest (Join-Path $Target ".sdlc/issues")) {
        Write-Host "    issues/ -> .sdlc/issues/"
    }

    if (Migrate-File -Src (Join-Path $Target "docs/lessons-log.md") -Dest (Join-Path $Target ".sdlc/lessons-log.md")) {
        Write-Host "    docs/lessons-log.md -> .sdlc/lessons-log.md"
    }

    Get-ChildItem (Join-Path $Target "docs/interview-notes*.md") -ErrorAction SilentlyContinue | ForEach-Object {
        if (Migrate-File -Src $_.FullName -Dest (Join-Path $Target ".sdlc/$($_.Name)")) {
            Write-Host "    docs/$($_.Name) -> .sdlc/$($_.Name)"
        }
    }

    Get-ChildItem (Join-Path $Target "docs/research-*.md") -ErrorAction SilentlyContinue | ForEach-Object {
        if (Migrate-File -Src $_.FullName -Dest (Join-Path $Target ".sdlc/$($_.Name)")) {
            Write-Host "    docs/$($_.Name) -> .sdlc/$($_.Name)"
        }
    }

    Write-Host ""
}

# Ensure .sdlc/ structure is complete (fresh install or post-migration)
foreach ($dir in @(
    ".sdlc/issues/backlog",
    ".sdlc/issues/planned",
    ".sdlc/issues/in-progress",
    ".sdlc/issues/done"
)) {
    New-Item -ItemType Directory -Path (Join-Path $Target $dir) -Force | Out-Null
}

foreach ($expert in @("pm", "swe", "qa", "devops", "system-architect", "security-engineer", "ux")) {
    New-Item -ItemType Directory -Path (Join-Path $Target ".sdlc/handoff-notes/$expert") -Force | Out-Null
}

$lessonsLog = Join-Path $Target ".sdlc/lessons-log.md"
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
# Preserves user content in docs/, .sdlc/, and
# user-owned .claude/settings*.json.
# ─────────────────────────────────────────────

# Legacy platform directory from the pre-AGENTS.md layout
Remove-Item (Join-Path $Target ".cursor") -Recurse -Force -ErrorAction SilentlyContinue

# Managed .agents/ payload (leave any user-added files in .agents/ alone)
foreach ($name in @("roles", "commands", "skills", "scripts", "workflows")) {
    Remove-Item (Join-Path $Target ".agents/$name") -Recurse -Force -ErrorAction SilentlyContinue
}
Remove-Item (Join-Path $Target ".agents/AGENTS.md") -Force -ErrorAction SilentlyContinue
Remove-Item (Join-Path $Target ".agents/settings.json") -Force -ErrorAction SilentlyContinue

# Managed .claude/ links (symlinks or prior copies); preserve real settings files
foreach ($name in @("commands", "skills", "roles", "scripts", "workflows")) {
    Remove-Item (Join-Path $Target ".claude/$name") -Recurse -Force -ErrorAction SilentlyContinue
}
# Legacy real CLAUDE.md from prior copy-based installs (now a root link)
Remove-Item (Join-Path $Target ".claude/CLAUDE.md") -Force -ErrorAction SilentlyContinue

# ─────────────────────────────────────────────
# Helpers
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

function Copy-Scripts {
    param([string]$Src, [string]$Dest)
    New-Item -ItemType Directory -Path $Dest -Force | Out-Null
    Get-ChildItem $Src -File -ErrorAction SilentlyContinue | Where-Object {
        $_.Name -notmatch '^test-' -and $_.Name -ne '.gitkeep'
    } | ForEach-Object {
        Copy-Item $_.FullName -Destination $Dest -Force
    }
}

function Copy-Commands {
    param([string]$Src, [string]$Dest)
    New-Item -ItemType Directory -Path $Dest -Force | Out-Null
    Get-ChildItem (Join-Path $Src "*.md") -ErrorAction SilentlyContinue | ForEach-Object {
        Copy-Item $_.FullName -Destination $Dest -Force
    }
}

# Create a symlink; on failure (no Developer Mode / not elevated), fall back to a copy.
# Returns $true if a real symlink was created, $false if it fell back to copying.
function New-LinkOrCopy {
    param([string]$LinkPath, [string]$TargetPath, [switch]$Directory)
    try {
        New-Item -ItemType SymbolicLink -Path $LinkPath -Target $TargetPath -Force -ErrorAction Stop | Out-Null
        return $true
    } catch {
        if ($Directory) {
            Copy-Item $TargetPath -Destination $LinkPath -Recurse -Force
        } else {
            Copy-Item $TargetPath -Destination $LinkPath -Force
        }
        return $false
    }
}

function Merge-Settings {
    param([string]$TargetDir)
    $existing = Join-Path $TargetDir ".claude/settings.json"
    $source = Join-Path $Source "settings.json"

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
# Safety: never silently clobber a user's own AGENTS.md / CLAUDE.md
# ─────────────────────────────────────────────

$SrcAgents = Join-Path $Source "AGENTS.md"
$TargetAgents = Join-Path $Target "AGENTS.md"
$TargetClaude = Join-Path $Target "CLAUDE.md"

function Test-IsSymlink {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return $false }
    return [bool]((Get-Item $Path -Force).Attributes -band [System.IO.FileAttributes]::ReparsePoint)
}

if ((Test-Path $TargetAgents) -and -not (Test-IsSymlink $TargetAgents)) {
    if ((Get-FileHash $SrcAgents).Hash -ne (Get-FileHash $TargetAgents).Hash) {
        Copy-Item $TargetAgents -Destination "$TargetAgents.pre-install.bak" -Force
        Write-Host "  WARNING: existing AGENTS.md backed up to AGENTS.md.pre-install.bak"
    }
}

if ((Test-Path $TargetClaude) -and -not (Test-IsSymlink $TargetClaude)) {
    Copy-Item $TargetClaude -Destination "$TargetClaude.pre-install.bak" -Force
    Write-Host "  WARNING: existing CLAUDE.md backed up to CLAUDE.md.pre-install.bak"
}
Remove-Item $TargetClaude -Force -ErrorAction SilentlyContinue

# ─────────────────────────────────────────────
# Install generic payload into .agents/
# ─────────────────────────────────────────────

Write-Host "  Installing .agents/ ..."

$agentsRoles = Join-Path $Target ".agents/roles"
New-Item -ItemType Directory -Path $agentsRoles -Force | Out-Null
Copy-Item (Join-Path $Source "roles/*.md") -Destination $agentsRoles -Force
Copy-Commands -Src (Join-Path $Source "commands") -Dest (Join-Path $Target ".agents/commands")
Copy-Skills   -Src (Join-Path $Source "skills")   -Dest (Join-Path $Target ".agents/skills")
Copy-Scripts  -Src (Join-Path $Source "scripts")  -Dest (Join-Path $Target ".agents/scripts")
$srcWorkflows = Join-Path $Source "workflows"
if (Test-Path $srcWorkflows) {
    $destWorkflows = Join-Path $Target ".agents/workflows"
    New-Item -ItemType Directory -Path $destWorkflows -Force | Out-Null
    Copy-Item (Join-Path $srcWorkflows "*.js") -Destination $destWorkflows -Force -ErrorAction SilentlyContinue
}
Copy-Item $SrcAgents -Destination (Join-Path $Target ".agents/AGENTS.md") -Force
$srcSettings = Join-Path $Source "settings.json"
if (Test-Path $srcSettings) {
    Copy-Item $srcSettings -Destination (Join-Path $Target ".agents/settings.json") -Force
}

# AGENTS.md at the project root + CLAUDE.md symlink (or copy fallback)
Copy-Item $SrcAgents -Destination $TargetAgents -Force
$claudeLinked = New-LinkOrCopy -LinkPath $TargetClaude -TargetPath $TargetAgents
if (-not $claudeLinked) {
    Write-Host "    NOTE: symlinks unavailable — CLAUDE.md written as a copy (enable Developer Mode for symlinks)"
}

$roleCount = (Get-ChildItem (Join-Path $Target ".agents/roles/*.md") -ErrorAction SilentlyContinue).Count
$cmdCount = (Get-ChildItem (Join-Path $Target ".agents/commands/*.md") -ErrorAction SilentlyContinue).Count
$skillCount = (Get-ChildItem (Join-Path $Target ".agents/skills") -Directory -ErrorAction SilentlyContinue).Count
$scriptCount = (Get-ChildItem (Join-Path $Target ".agents/scripts") -File -ErrorAction SilentlyContinue).Count
Write-Host "    AGENTS.md + CLAUDE.md"
Write-Host "    Roles: $roleCount files"
Write-Host "    Commands: $cmdCount files"
Write-Host "    Skills: $skillCount folders"
Write-Host "    Scripts: $scriptCount files"

# ─────────────────────────────────────────────
# Claude Code wiring (native discovery + SessionStart hook)
# ─────────────────────────────────────────────

if (-not $NoClaude) {
    Write-Host "  Wiring .claude/ for Claude Code ..."
    $claudeDir = Join-Path $Target ".claude"
    New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null

    $copied = $false
    $claudeLinks = @("commands", "skills", "roles", "scripts")
    if (Test-Path (Join-Path $Target ".agents/workflows")) { $claudeLinks += "workflows" }
    foreach ($name in $claudeLinks) {
        $linkPath = Join-Path $claudeDir $name
        $targetPath = Join-Path $Target ".agents/$name"
        $linked = New-LinkOrCopy -LinkPath $linkPath -TargetPath (Resolve-Path $targetPath).Path -Directory
        if (-not $linked) { $copied = $true }
    }
    if ($copied) {
        Write-Host "    NOTE: symlinks unavailable — .claude/* written as copies (enable Developer Mode for symlinks)"
    } else {
        Write-Host "    Symlinks: .claude/{commands,skills,roles,scripts,workflows} -> ../.agents/*"
    }
    Merge-Settings -TargetDir $Target
}

# ─────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────

Write-Host ""
Write-Host "Done! Installed to: $TargetFull"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. cd $TargetFull"
if ($NoClaude) {
    Write-Host "  2. Open your AGENTS.md-aware harness; it reads AGENTS.md + .agents/"
} else {
    Write-Host "  2. Open Claude Code (or a Codex/AGENTS.md harness) and run /pm-interview to start"
}
Write-Host "  3. Or run /team-status to see the project health summary"
Write-Host ""
Write-Host "Uninstall:"
Write-Host "  Remove-Item AGENTS.md, CLAUDE.md -Force"
Write-Host "  Remove-Item .agents -Recurse -Force"
Write-Host "  Remove-Item .claude/commands, .claude/skills, .claude/roles, .claude/scripts -Recurse -Force"
Write-Host "  # Manually remove the SessionStart hook from .claude/settings.json if desired"
Write-Host "  Project documents (docs/, .sdlc/) are yours - they are not removed."
Write-Host ""
