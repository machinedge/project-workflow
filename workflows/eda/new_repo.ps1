# Time Series EDA Toolkit — New Repo Scaffolder (Windows)
# Usage: .\new_repo.ps1 [-Org <github-org>] [-Editor claude|cursor|both] <repo-name>
#
# Creates a new git repo with the analysis toolkit pre-configured,
# and pushes it to GitHub under the specified org/user.
#
# The GitHub org/user can be set via:
#   1. -Org parameter (highest priority)
#   2. GITHUB_ORG environment variable
#
# Examples:
#   .\new_repo.ps1 my-analysis                          # Uses $env:GITHUB_ORG, both editors
#   .\new_repo.ps1 -Org mycompany my-analysis           # Explicit org
#   .\new_repo.ps1 -Editor cursor my-analysis           # Cursor only
#   .\new_repo.ps1 -Org myco -Editor claude analysis    # All flags

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$RepoName,

    [Parameter()]
    [string]$Org = "",

    [Parameter()]
    [ValidateSet("claude", "cursor", "both")]
    [string]$Editor = "both"
)

$ErrorActionPreference = "Stop"

# Check prerequisites
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Error: git is not installed"
    exit 1
}
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Error "Error: gh CLI is not installed (https://cli.github.com)"
    exit 1
}

# Resolve org: parameter > env var
if ([string]::IsNullOrEmpty($Org)) {
    $Org = $env:GITHUB_ORG
}
if ([string]::IsNullOrEmpty($Org)) {
    Write-Error "Error: GitHub org/user not specified. Set GITHUB_ORG in your environment or pass -Org <github-org>"
    exit 1
}

# Validate repo name
if ($RepoName -notmatch '^[a-zA-Z0-9._-]+$') {
    Write-Error "Error: Invalid repo name '$RepoName'. Use only letters, numbers, hyphens, dots, and underscores."
    exit 1
}

# Resolve the directory where this script lives (the toolkit root)
$ScriptDir = $PSScriptRoot

$RepoDir = Join-Path $HOME "work" $RepoName

if (Test-Path $RepoDir) {
    Write-Error "Error: $RepoDir already exists"
    exit 1
}

New-Item -ItemType Directory -Path $RepoDir -Force | Out-Null

# Create README
@"
# Time Series Analysis

This project uses the [MachinEdge Time Series EDA Toolkit](https://github.com/machinedge/ts-eda) for structured, multi-session analysis with AI coding assistants.

## Getting Started

1. Install dependencies: ``uv sync`` (or ``pip install -e .``)
2. Open Claude Code or Cursor
3. Run ``/intake`` to begin the analysis
4. Follow the workflow: ``/brief`` -> ``/scope`` -> ``/decompose`` -> ``/start``

## Project Structure

``````
docs/               Analysis documents (brief, scope, data profile, handoff notes)
notebooks/          Jupyter notebooks (working surface)
data/raw/           Untouched source data
data/processed/     Cleaned and transformed data
reports/            Synthesized findings and recommendations
``````
"@ | Set-Content -Path "$RepoDir/README.md" -Encoding UTF8

# Run the toolkit setup (using absolute path to setup.ps1)
& "$ScriptDir/setup.ps1" -Editor $Editor -Target $RepoDir

# Git init and push
Push-Location $RepoDir
try {
    git init
    git add .
    git commit -m "Initial commit: analysis scaffold with time series EDA toolkit"

    gh repo create "$Org/$RepoName" --private
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Failed to create GitHub repo. Cleaning up local repo."
        Pop-Location
        Remove-Item -Recurse -Force $RepoDir
        exit 1
    }

    git remote add origin "git@github.com:$Org/$RepoName.git"
    git branch -M main
    git push -u origin main
} finally {
    Pop-Location
}

Write-Host ""
Write-Host "Done! Analysis repo ready at: $RepoDir"
Write-Host "GitHub: https://github.com/$Org/$RepoName"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. cd $RepoDir"
Write-Host "  2. uv sync"
Write-Host "  3. Place your data in data/raw/"
Write-Host "  4. Open Claude Code or Cursor and run /intake"
Write-Host ""
