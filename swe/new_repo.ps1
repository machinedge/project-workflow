# AI Project Toolkit — New Repo Scaffolder (Windows)
# Usage: .\new_repo.ps1 <repo-name> [claude|cursor|both]
#
# Creates a new git repo with the toolkit pre-configured,
# and pushes it to GitHub under machinedge/.
#
# Examples:
#   .\new_repo.ps1 my-app              # Both editors (default)
#   .\new_repo.ps1 my-app cursor       # Cursor only
#   .\new_repo.ps1 my-app claude       # Claude Code only

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$RepoName,

    [Parameter(Position = 1)]
    [ValidateSet("claude", "cursor", "both")]
    [string]$Editor = "both"
)

$ErrorActionPreference = "Stop"

# Resolve the directory where this script lives (the toolkit root)
$ScriptDir = $PSScriptRoot

$RepoDir = Join-Path $HOME "work/$RepoName"

if (Test-Path $RepoDir) {
    Write-Error "Error: $RepoDir already exists"
    exit 1
}

New-Item -ItemType Directory -Path $RepoDir -Force | Out-Null

# Initialize the repo
New-Item -ItemType File -Path "$RepoDir/README.md" -Force | Out-Null
New-Item -ItemType File -Path "$RepoDir/.gitignore" -Force | Out-Null

# Run the toolkit setup (using absolute path to setup.ps1)
& "$ScriptDir/setup.ps1" -Editor $Editor -Target $RepoDir

# Git init and push
Push-Location $RepoDir
try {
    git init
    git add .
    git commit -m "Initial commit: project scaffold with AI toolkit"

    gh repo create "machinedge/$RepoName" --private
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Failed to create GitHub repo. Local repo is ready at $RepoDir"
        exit 1
    }

    git remote add origin "git@github.com:machinedge/$RepoName.git"
    git branch -M main
    git push -u origin main
} finally {
    Pop-Location
}

Write-Host ""
Write-Host "Done! Repo ready at: $RepoDir"
Write-Host "GitHub: https://github.com/machinedge/$RepoName"
Write-Host ""
