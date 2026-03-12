# MachinEdge Expert Teams — Install Skill into Claude Code (Windows)
# Usage: .\install-skill.ps1 [-Project <project-dir>]
#
# Copies the built skill package into the Claude Code skills directory.
# By default installs personally (~\.claude\skills\) so it's available
# across all projects. Use -Project to install into a specific project.
#
# Examples:
#   .\install-skill.ps1                              # Personal install
#   .\install-skill.ps1 -Project ~\work\my-app       # Project-local install

param(
    [Parameter()]
    [string]$Project = ""
)

$ErrorActionPreference = "Stop"

$ScriptDir = $PSScriptRoot
try {
    $RepoRoot = git -C $ScriptDir rev-parse --show-toplevel 2>$null
} catch {
    $RepoRoot = $null
}
if ([string]::IsNullOrEmpty($RepoRoot)) {
    $RepoRoot = Split-Path $ScriptDir -Parent
}

$SkillName = "machinedge-workflows"
$SkillBuild = Join-Path $RepoRoot "package" "build" "skills" $SkillName

# Check that the skill has been built
if (-not (Test-Path $SkillBuild)) {
    Write-Error "Error: Skill not built yet. Run .\package\package.ps1 first."
    exit 1
}

$SkillMd = Join-Path $SkillBuild "SKILL.md"
if (-not (Test-Path $SkillMd)) {
    Write-Error "Error: SKILL.md not found in build output at $SkillBuild"
    exit 1
}

# Determine install location
if (-not [string]::IsNullOrEmpty($Project)) {
    if (-not (Test-Path $Project)) {
        Write-Error "Error: Project directory not found: $Project"
        exit 1
    }
    $InstallDir = Join-Path $Project ".claude" "skills" $SkillName
    $InstallType = "project-local"
} else {
    $InstallDir = Join-Path $HOME ".claude" "skills" $SkillName
    $InstallType = "personal"
}

# Install
if (Test-Path $InstallDir) {
    Write-Host "Removing existing installation at $InstallDir..."
    Remove-Item -Recurse -Force $InstallDir
}

$ParentDir = Split-Path $InstallDir -Parent
New-Item -ItemType Directory -Path $ParentDir -Force | Out-Null
Copy-Item -Path $SkillBuild -Destination $InstallDir -Recurse -Force

Write-Host ""
Write-Host "Done! Skill installed ($InstallType)."
Write-Host "  Location: $InstallDir"
Write-Host ""
Write-Host "Claude Code will auto-discover this skill. You can also invoke it with /machinedge-workflows."
