# MachinEdge Expert Teams — New Repo Scaffolder (Windows)
# Usage: .\new_repo.ps1 [-Org <github-org>] [-Editor claude|cursor|both] [-Experts pm,swe,qa,devops] <repo-name>
#
# Creates a new git repo with selected experts pre-configured,
# and pushes it to GitHub under the specified org/user.
#
# The GitHub org/user can be set via:
#   1. -Org parameter (highest priority)
#   2. GITHUB_ORG environment variable
#
# Examples:
#   .\new_repo.ps1 my-app                                            # Uses $env:GITHUB_ORG, all experts, both editors
#   .\new_repo.ps1 -Org mycompany my-app                             # Explicit org
#   .\new_repo.ps1 -Experts "pm,swe" my-app                          # Just PM and SWE
#   .\new_repo.ps1 -Experts "pm,swe,qa" -Editor cursor app           # PM+SWE+QA, Cursor only

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$RepoName,

    [Parameter()]
    [string]$Org = "",

    [Parameter()]
    [ValidateSet("claude", "cursor", "both")]
    [string]$Editor = "both",

    [Parameter()]
    [string]$Experts = "project-manager,swe,qa,devops"
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

# Resolve paths: this script lives in experts/technical/project-manager/tools/
$ScriptDir = $PSScriptRoot
$RepoRoot = Split-Path (Split-Path (Split-Path (Split-Path $ScriptDir -Parent) -Parent) -Parent) -Parent
$SetupScript = Join-Path $RepoRoot "framework" "install" "install.ps1"

if (-not (Test-Path $SetupScript)) {
    Write-Error "Error: framework/install/install.ps1 not found at $SetupScript"
    exit 1
}

$RepoDir = Join-Path $HOME "work" $RepoName

if (Test-Path $RepoDir) {
    Write-Error "Error: $RepoDir already exists"
    exit 1
}

New-Item -ItemType Directory -Path $RepoDir -Force | Out-Null

# Initialize the repo
New-Item -ItemType File -Path "$RepoDir/README.md" -Force | Out-Null
New-Item -ItemType File -Path "$RepoDir/.gitignore" -Force | Out-Null

# Run the framework setup script
Write-Host "Installing expert team..."
& $SetupScript -Editor $Editor -Experts $Experts -Target $RepoDir

# Git init and push
Push-Location $RepoDir
try {
    git init
    git add .
    git commit -m "Initial commit: project scaffold with MachinEdge Expert Teams (experts: $Experts)"

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
Write-Host "Done! Repo ready at: $RepoDir"
Write-Host "GitHub: https://github.com/$Org/$RepoName"
Write-Host "Experts installed: $Experts"
Write-Host ""
