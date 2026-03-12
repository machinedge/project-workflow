# Package the machinedge-workflows skill into a distributable .skill file
# Usage: .\targets\desktop-cli\claude\package.ps1
#
# Assembles the skill directory structure (copying experts/ into
# skills/machinedge-workflows/experts/), downloads packaging tools
# from GitHub if needed, validates, and produces machinedge-workflows.skill
# in the build/ directory.
#
# Examples:
#   .\targets\desktop-cli\claude\package.ps1

$ErrorActionPreference = "Stop"

# ─────────────────────────────────────────────
# Resolve paths
# ─────────────────────────────────────────────

$ScriptDir = $PSScriptRoot
try {
    $RepoRoot = git -C $ScriptDir rev-parse --show-toplevel 2>$null
} catch {
    $RepoRoot = $null
}
if ([string]::IsNullOrEmpty($RepoRoot)) {
    $TestDir = $ScriptDir
    while ($TestDir -ne [System.IO.Path]::GetPathRoot($TestDir)) {
        if ((Test-Path (Join-Path $TestDir ".git")) -or (Test-Path (Join-Path $TestDir "SKILL.md"))) {
            $RepoRoot = $TestDir
            break
        }
        $TestDir = Split-Path $TestDir -Parent
    }
}
if ([string]::IsNullOrEmpty($RepoRoot)) {
    Write-Error "Error: Could not find repository root from $ScriptDir"
    exit 1
}

$BuildDir = Join-Path $RepoRoot "targets" "desktop-cli" "claude" "build"
$SkillName = "machinedge-workflows"
$SkillSrc = Join-Path $RepoRoot "targets" "desktop-cli" "claude"
$ExpertsSrc = Join-Path $RepoRoot "experts"
$SkillBuild = Join-Path $BuildDir "skills" $SkillName

# ─────────────────────────────────────────────
# Prerequisite checks
# ─────────────────────────────────────────────

$SkillMd = Join-Path $SkillSrc "SKILL.md"
if (-not (Test-Path $SkillMd)) {
    Write-Error "Error: SKILL.md not found at $SkillMd`n  Are you running this from the project root?"
    exit 1
}

if (-not (Test-Path $ExpertsSrc)) {
    Write-Error "Error: experts/ directory not found at $ExpertsSrc"
    exit 1
}

if (-not (Get-Command python3 -ErrorAction SilentlyContinue)) {
    Write-Error "Error: python3 is required but not found in PATH"
    exit 1
}

# ─────────────────────────────────────────────
# Clean build directory
# ─────────────────────────────────────────────

Write-Host "Cleaning build directory..."
if (Test-Path $BuildDir) {
    Remove-Item -Recurse -Force $BuildDir
}
New-Item -ItemType Directory -Path $SkillBuild -Force | Out-Null

# ─────────────────────────────────────────────
# Assemble skill directory
# ─────────────────────────────────────────────

Write-Host "Copying skill files..."
Copy-Item -Path (Join-Path $SkillSrc "SKILL.md") -Destination $SkillBuild

Write-Host "Copying repo utilities into skill package..."
$ToolsDest = Join-Path $SkillBuild "tools"
New-Item -ItemType Directory -Path $ToolsDest -Force | Out-Null
Copy-Item -Path (Join-Path $RepoRoot "tools" "new-repo.sh") -Destination $ToolsDest
Copy-Item -Path (Join-Path $RepoRoot "tools" "new-repo.ps1") -Destination $ToolsDest
Copy-Item -Path (Join-Path $RepoRoot "tools" "list-experts.sh") -Destination $ToolsDest
Copy-Item -Path (Join-Path $RepoRoot "tools" "list-experts.ps1") -Destination $ToolsDest

Write-Host "Copying experts into skill package..."
Copy-Item -Path $ExpertsSrc -Destination (Join-Path $SkillBuild "experts") -Recurse -Force

# Include install scripts in framework/install/ layout (matches SKILL.md references)
Write-Host "Copying install scripts..."
$InstallDest = Join-Path $SkillBuild "framework" "install"
New-Item -ItemType Directory -Path $InstallDest -Force | Out-Null
Copy-Item -Path (Join-Path $RepoRoot "targets" "ide" "install.sh") -Destination $InstallDest
Copy-Item -Path (Join-Path $RepoRoot "targets" "ide" "install.ps1") -Destination $InstallDest
Copy-Item -Path (Join-Path $RepoRoot "targets" "autonomous" "openclaw" "install-team.sh") -Destination $InstallDest
Copy-Item -Path (Join-Path $RepoRoot "targets" "autonomous" "openclaw" "install-team.ps1") -Destination $InstallDest

Write-Host "Copying install templates..."
$TemplateDest = Join-Path $InstallDest "templates"
New-Item -ItemType Directory -Path $TemplateDest -Force | Out-Null
Copy-Item -Path (Join-Path $RepoRoot "targets" "autonomous" "openclaw" "templates" "*") -Destination $TemplateDest -Recurse -Force

# ─────────────────────────────────────────────
# Ensure packaging tools are available
# ─────────────────────────────────────────────

$PackageScript = Join-Path $BuildDir "package_skill.py"
$ValidateScript = Join-Path $BuildDir "quick_validate.py"

$GitHubRaw = "https://raw.githubusercontent.com/anthropics/skills/main/skills/skill-creator/scripts"

function Download-IfMissing {
    param([string]$FilePath)
    $Name = Split-Path $FilePath -Leaf
    $Url = "$GitHubRaw/$Name"

    if (Test-Path $FilePath) {
        Write-Host "  Found $Name locally"
        return
    }

    Write-Host "  Downloading $Name from GitHub..."
    Invoke-WebRequest -Uri $Url -OutFile $FilePath -UseBasicParsing
    Write-Host "  Downloaded $Name"
}

Write-Host "Checking packaging tools..."
Download-IfMissing $PackageScript
Download-IfMissing $ValidateScript

# ─────────────────────────────────────────────
# Package the skill
# ─────────────────────────────────────────────

Write-Host ""
Write-Host "Packaging skill..."

$env:PYTHONPATH = "$ScriptDir;$($env:PYTHONPATH)"

python3 $PackageScript $SkillBuild $BuildDir

# ─────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────

$SkillFile = Join-Path $BuildDir "$SkillName.skill"

if (Test-Path $SkillFile) {
    $Size = (Get-Item $SkillFile).Length
    $SizeKB = [math]::Round($Size / 1KB, 1)
    Write-Host ""
    Write-Host "Done! Skill packaged successfully."
    Write-Host "  Output: $SkillFile (${SizeKB}KB)"
    Write-Host ""
    Write-Host "To install:"
    Write-Host "  .\install-skill.ps1                          # Personal (all projects)"
    Write-Host "  .\install-skill.ps1 -Project <project-dir>   # Project-local"
} else {
    Write-Host ""
    Write-Error "Error: Expected output file not found at $SkillFile`n  The packager may have failed silently."
    exit 1
}
