# MachinEdge Expert Teams — List Available Experts (Windows)
# Usage: .\list-experts.ps1 [experts-dir]
#
# Walks expert directories and prints a formatted summary of each expert,
# including role name, description, and available skills.
#
# If no experts-dir is given, resolves from the repo root.

param(
    [Parameter(Position = 0)]
    [string]$ExpertsDir = ""
)

$ErrorActionPreference = "Stop"

# Resolve experts directory
if ([string]::IsNullOrEmpty($ExpertsDir)) {
    $ScriptDir = $PSScriptRoot
    try {
        $RepoRoot = git -C $ScriptDir rev-parse --show-toplevel 2>$null
    } catch {
        $RepoRoot = $null
    }
    if ([string]::IsNullOrEmpty($RepoRoot)) {
        $RepoRoot = Split-Path (Split-Path $ScriptDir -Parent) -Parent
    }
    $ExpertsDir = Join-Path $RepoRoot "experts"
}

if (-not (Test-Path $ExpertsDir)) {
    Write-Error "Error: experts directory not found at $ExpertsDir"
    exit 1
}

Write-Host "MachinEdge Expert Teams — Available Experts"
Write-Host "============================================"
Write-Host ""

$Found = 0

foreach ($DomainDir in Get-ChildItem -Path $ExpertsDir -Directory) {
    foreach ($ExpertDir in Get-ChildItem -Path $DomainDir.FullName -Directory) {
        $ExpertName = $ExpertDir.Name
        if ($ExpertName -eq "shared") { continue }

        $RoleFile = Join-Path $ExpertDir.FullName "role.md"
        if (-not (Test-Path $RoleFile)) { continue }

        # Skip empty role files
        $Content = Get-Content -Path $RoleFile -ErrorAction SilentlyContinue
        if ($null -eq $Content -or $Content.Count -eq 0) {
            Write-Host "$ExpertName (under development)"
            Write-Host ""
            $Found++
            continue
        }

        # Extract heading (first line starting with "# ")
        $Heading = ""
        foreach ($Line in $Content) {
            if ($Line -match '^# (.+)$') {
                $Heading = $Matches[1]
                break
            }
        }

        # Extract description (first non-blank line after heading)
        $Description = ""
        $PastHeading = $false
        foreach ($Line in $Content) {
            if (-not $PastHeading) {
                if ($Line -match '^# ') { $PastHeading = $true }
                continue
            }
            if ($Line.Trim().Length -gt 0) {
                $Description = $Line
                break
            }
        }

        # Extract skills (lines matching "- `/command`" in ## Skills section)
        $InSkills = $false
        $Skills = @()
        foreach ($Line in $Content) {
            if ($Line -match '^## Skills$') {
                $InSkills = $true
                continue
            }
            if ($InSkills -and $Line -match '^## [^S]') {
                break
            }
            if ($InSkills -and $Line -match '^\- `/') {
                $Skills += $Line
            }
        }

        Write-Host "$ExpertName ($Heading)"
        if ($Description) {
            Write-Host "  $Description"
        }
        if ($Skills.Count -gt 0) {
            Write-Host "  Skills:"
            foreach ($Skill in $Skills) {
                Write-Host ("    " + ($Skill -replace '^\- ', ''))
            }
        }
        Write-Host ""
        $Found++
    }
}

if ($Found -eq 0) {
    Write-Host "No experts found under $ExpertsDir"
    exit 1
}

Write-Host "Total: $Found expert(s)"
