# MachinEdge Expert Teams — Uninstall Skill from Claude Code (Windows)
# Usage: .\uninstall-skill.ps1 [-Project <project-dir>]
#
# Removes the installed skill from the Claude Code skills directory.
# By default removes the personal install (~\.claude\skills\).
# Use -Project to remove from a specific project.
#
# Examples:
#   .\uninstall-skill.ps1                              # Remove personal install
#   .\uninstall-skill.ps1 -Project ~\work\my-app       # Remove project-local install

param(
    [Parameter()]
    [string]$Project = ""
)

$ErrorActionPreference = "Stop"

$SkillName = "machinedge-workflows"

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

# Uninstall
if (-not (Test-Path $InstallDir)) {
    Write-Host "Not installed ($InstallType): $InstallDir"
    exit 0
}

Remove-Item -Recurse -Force $InstallDir

Write-Host ""
Write-Host "Done! Skill uninstalled ($InstallType)."
Write-Host "  Removed: $InstallDir"
