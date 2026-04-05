# MachinEdge Expert Teams — Sync Command (Windows)
# Usage: .\sync.ps1 [-Yes] <Mode> [ProjectDir]
#
# Compares Cursor and Claude Code platform implementations for drift (maintainers),
# or checks/updates an installed toolkit against the source (users).
#
# Modes:
#   diff                     Compare Cursor and Claude Code implementations
#   check [project-dir]      Check installed toolkit against source (default: .)
#   apply [project-dir]      Update installed toolkit from source (with confirmation)
#
# Flags:
#   -Yes                     Skip confirmation prompt (apply mode)
#
# Exit codes:
#   0 — in sync (diff/check) or all updates applied (apply)
#   1 — differences found
#   2 — usage error or missing prerequisites
#
# Output markers (for agent/script consumption):
#   [OK]                     File or category is in sync
#   [DIFFERS]                File content differs
#   [MISSING:<location>]     File exists in one location but not the other
#   [SKIPPED]                File requires manual handling (e.g., settings.json)
#   [UPDATED]                File was updated (apply mode)
#
# Environment:
#   SYNC_REPO_ROOT           Override toolkit repo root (default: derived from script location)

param(
    [switch]$Yes,
    [Parameter(Position = 0, Mandatory = $true)]
    [ValidateSet("diff", "check", "apply")]
    [string]$Mode,
    [Parameter(Position = 1)]
    [string]$ProjectDir = "."
)

$ErrorActionPreference = "Stop"

$ScriptDir = $PSScriptRoot
if ($env:SYNC_REPO_ROOT) {
    $RepoRoot = $env:SYNC_REPO_ROOT
} else {
    $RepoRoot = Split-Path $ScriptDir -Parent
}

$CursorDir = Join-Path $RepoRoot "targets/ide/cursor"
$ClaudeDir = Join-Path $RepoRoot "targets/ide/claude-code"

$script:Diffs = 0

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

function Get-RelativeFiles {
    param([string]$Dir)
    if (-not (Test-Path $Dir)) { return @() }
    Get-ChildItem -Path $Dir -Recurse -File |
        ForEach-Object { $_.FullName.Substring($Dir.Length + 1).Replace('\', '/') } |
        Sort-Object
}

function Get-Subdirs {
    param([string]$Dir)
    if (-not (Test-Path $Dir)) { return @() }
    Get-ChildItem -Path $Dir -Directory |
        ForEach-Object { $_.Name } |
        Sort-Object
}

function Test-ShouldSkip {
    param([string]$RelPath)
    return $RelPath -eq "README.md"
}

function Compare-FileContent {
    param([string]$File1, [string]$File2)
    $hash1 = (Get-FileHash -Path $File1 -Algorithm MD5).Hash
    $hash2 = (Get-FileHash -Path $File2 -Algorithm MD5).Hash
    return $hash1 -eq $hash2
}

# ---------------------------------------------------------------------------
# Diff mode
# ---------------------------------------------------------------------------

function Compare-FileLists {
    param([string]$Label, [string]$Dir1, [string]$Dir2)

    $list1 = @(Get-RelativeFiles $Dir1)
    $list2 = @(Get-RelativeFiles $Dir2)

    $only1 = @($list1 | Where-Object { $_ -notin $list2 })
    $only2 = @($list2 | Where-Object { $_ -notin $list1 })

    if ($only1.Count -eq 0 -and $only2.Count -eq 0) {
        Write-Host "[OK] ${Label}: $($list1.Count) in both platforms"
    } else {
        foreach ($f in $only1) {
            Write-Host "[MISSING:claude-code] ${Label}: $f"
            $script:Diffs++
        }
        foreach ($f in $only2) {
            Write-Host "[MISSING:cursor] ${Label}: $f"
            $script:Diffs++
        }
    }
}

function Compare-SkillCoverage {
    $cursorSkills = @(Get-Subdirs (Join-Path $CursorDir "skills"))
    $claudeSkills = @(Get-Subdirs (Join-Path $ClaudeDir "skills"))

    $onlyCursor = @($cursorSkills | Where-Object { $_ -notin $claudeSkills })
    $onlyClaude = @($claudeSkills | Where-Object { $_ -notin $cursorSkills })

    if ($onlyCursor.Count -eq 0 -and $onlyClaude.Count -eq 0) {
        Write-Host "[OK] skills: $($cursorSkills.Count) in both platforms"
    } else {
        foreach ($s in $onlyCursor) {
            Write-Host "[MISSING:claude-code] skill: $s"
            $script:Diffs++
        }
        foreach ($s in $onlyClaude) {
            Write-Host "[MISSING:cursor] skill: $s"
            $script:Diffs++
        }
    }
}

function Compare-DirContent {
    param([string]$Label, [string]$Dir1, [string]$Dir2)

    $files = @(Get-RelativeFiles $Dir1)
    $ok = 0; $bad = 0

    foreach ($f in $files) {
        $path2 = Join-Path $Dir2 $f
        if (-not (Test-Path $path2)) { continue }

        if (Compare-FileContent (Join-Path $Dir1 $f) $path2) {
            $ok++
        } else {
            Write-Host "[DIFFERS] ${Label}: $f"
            $bad++
        }
    }

    if ($bad -eq 0) {
        Write-Host "[OK] ${Label}: $ok/$ok identical"
    } else {
        $script:Diffs += $bad
    }
}

function Compare-SkillsContent {
    $cursorSkills = @(Get-Subdirs (Join-Path $CursorDir "skills"))
    $claudeSkills = @(Get-Subdirs (Join-Path $ClaudeDir "skills"))
    $shared = @($cursorSkills | Where-Object { $_ -in $claudeSkills })

    $ok = 0; $bad = 0

    foreach ($skill in $shared) {
        $f1 = Join-Path $CursorDir "skills/$skill/SKILL.md"
        $f2 = Join-Path $ClaudeDir "skills/$skill/SKILL.md"
        if (-not (Test-Path $f1) -or -not (Test-Path $f2)) { continue }

        if (Compare-FileContent $f1 $f2) {
            $ok++
        } else {
            Write-Host "[DIFFERS] skills: $skill/SKILL.md"
            $bad++
        }
    }

    if ($bad -eq 0) {
        Write-Host "[OK] skills: $ok/$ok identical"
    } else {
        $script:Diffs += $bad
    }
}

function Compare-SharedScripts {
    $cursorScripts = @(Get-RelativeFiles (Join-Path $CursorDir "scripts"))
    $claudeScripts = @(Get-RelativeFiles (Join-Path $ClaudeDir "scripts"))
    $shared = @($cursorScripts | Where-Object { $_ -in $claudeScripts })

    if ($shared.Count -eq 0) {
        Write-Host "[OK] scripts: no shared scripts"
        return
    }

    $ok = 0; $bad = 0

    foreach ($f in $shared) {
        $f1 = Join-Path $CursorDir "scripts/$f"
        $f2 = Join-Path $ClaudeDir "scripts/$f"

        if (Compare-FileContent $f1 $f2) {
            $ok++
        } else {
            Write-Host "[DIFFERS] scripts: $f"
            $bad++
        }
    }

    if ($bad -eq 0) {
        Write-Host "[OK] scripts: $ok/$ok shared scripts identical"
    } else {
        $script:Diffs += $bad
    }
}

function Invoke-DiffMode {
    $script:Diffs = 0

    if (-not (Test-Path $CursorDir)) {
        Write-Host "Error: Cursor directory not found at $CursorDir"
        exit 2
    }
    if (-not (Test-Path $ClaudeDir)) {
        Write-Host "Error: Claude Code directory not found at $ClaudeDir"
        exit 2
    }

    Write-Host "=== MachinEdge Sync: diff mode ==="
    Write-Host ""

    Write-Host "--- Coverage ---"
    Compare-FileLists "commands" (Join-Path $CursorDir "commands") (Join-Path $ClaudeDir "commands")
    Compare-SkillCoverage
    Write-Host ""

    Write-Host "--- Content: commands ---"
    Compare-DirContent "commands" (Join-Path $CursorDir "commands") (Join-Path $ClaudeDir "commands")
    Write-Host ""

    Write-Host "--- Content: skills ---"
    Compare-SkillsContent
    Write-Host ""

    Write-Host "--- Content: scripts (shared) ---"
    Compare-SharedScripts
    Write-Host ""

    Write-Host "--- Summary ---"
    if ($script:Diffs -eq 0) {
        Write-Host "Status: IN SYNC"
        exit 0
    } else {
        Write-Host "Differences: $($script:Diffs)"
        Write-Host "Status: DRIFT DETECTED"
        exit 1
    }
}

# ---------------------------------------------------------------------------
# Check / Apply mode
# ---------------------------------------------------------------------------

function Get-Platform {
    param([string]$ProjDir)
    if (Test-Path (Join-Path $ProjDir ".cursor/rules/project-os.mdc")) {
        return "cursor"
    } elseif (Test-Path (Join-Path $ProjDir ".claude/CLAUDE.md")) {
        return "claude-code"
    }
    return ""
}

function Get-InstallDir {
    param([string]$Platform, [string]$ProjDir)
    switch ($Platform) {
        "cursor" { return Join-Path $ProjDir ".cursor" }
        "claude-code" { return Join-Path $ProjDir ".claude" }
    }
}

function Invoke-CheckMode {
    param([string]$ProjDir)
    $ProjDir = (Resolve-Path $ProjDir).Path
    $script:Diffs = 0

    Write-Host "=== MachinEdge Sync: check mode ==="
    Write-Host ""

    $platform = Get-Platform $ProjDir
    if ([string]::IsNullOrEmpty($platform)) {
        Write-Host "Error: No toolkit installation detected in $ProjDir"
        Write-Host "  Expected .cursor/rules/project-os.mdc or .claude/CLAUDE.md"
        exit 2
    }

    $sourceDir = Join-Path $RepoRoot "targets/ide/$platform"
    $installDir = Get-InstallDir $platform $ProjDir

    if (-not (Test-Path $sourceDir)) {
        Write-Host "Error: Source directory not found at $sourceDir"
        exit 2
    }

    Write-Host "Platform: $platform"
    Write-Host "Project: $ProjDir"
    Write-Host ""

    $sourceFiles = @(Get-RelativeFiles $sourceDir)
    $ok = 0

    foreach ($f in $sourceFiles) {
        if (Test-ShouldSkip $f) { continue }

        $src = Join-Path $sourceDir $f
        $dst = Join-Path $installDir $f

        if (-not (Test-Path $dst)) {
            Write-Host "[MISSING:install] $f"
            $script:Diffs++
        } elseif (Compare-FileContent $src $dst) {
            $ok++
        } else {
            if ($f -eq "settings.json") {
                Write-Host "[DIFFERS] $f (settings.json — check manually, hooks may need merging)"
            } else {
                Write-Host "[DIFFERS] $f"
            }
            $script:Diffs++
        }
    }

    if ($ok -gt 0 -and $script:Diffs -eq 0) {
        Write-Host "[OK] $ok files up to date"
    } elseif ($ok -gt 0) {
        Write-Host ""
        Write-Host "$ok file(s) up to date"
    }

    Write-Host ""
    Write-Host "--- Summary ---"
    if ($script:Diffs -eq 0) {
        Write-Host "Status: IN SYNC"
        exit 0
    } else {
        Write-Host "Differences: $($script:Diffs)"
        Write-Host "Status: OUT OF DATE"
        exit 1
    }
}

function Invoke-ApplyMode {
    param([string]$ProjDir)
    $ProjDir = (Resolve-Path $ProjDir).Path
    $updates = 0
    $skipped = 0

    Write-Host "=== MachinEdge Sync: apply mode ==="
    Write-Host ""

    $platform = Get-Platform $ProjDir
    if ([string]::IsNullOrEmpty($platform)) {
        Write-Host "Error: No toolkit installation detected in $ProjDir"
        Write-Host "  Expected .cursor/rules/project-os.mdc or .claude/CLAUDE.md"
        exit 2
    }

    $sourceDir = Join-Path $RepoRoot "targets/ide/$platform"
    $installDir = Get-InstallDir $platform $ProjDir

    if (-not (Test-Path $sourceDir)) {
        Write-Host "Error: Source directory not found at $sourceDir"
        exit 2
    }

    Write-Host "Platform: $platform"
    Write-Host "Project: $ProjDir"
    Write-Host ""

    $sourceFiles = @(Get-RelativeFiles $sourceDir)
    $filesToUpdate = @()

    foreach ($f in $sourceFiles) {
        if (Test-ShouldSkip $f) { continue }

        $src = Join-Path $sourceDir $f
        $dst = Join-Path $installDir $f

        if ($f -eq "settings.json") {
            if ((Test-Path $dst) -and -not (Compare-FileContent $src $dst)) {
                Write-Host "[SKIPPED] $f — requires manual merging"
                $skipped++
            }
            continue
        }

        if (-not (Test-Path $dst)) {
            $filesToUpdate += $f
        } elseif (-not (Compare-FileContent $src $dst)) {
            $filesToUpdate += $f
        }
    }

    if ($filesToUpdate.Count -eq 0) {
        Write-Host "All files are up to date."
        if ($skipped -gt 0) {
            Write-Host "($skipped file(s) skipped — require manual handling)"
        }
        Write-Host ""
        Write-Host "Status: IN SYNC"
        exit 0
    }

    Write-Host "$($filesToUpdate.Count) file(s) to update:"
    Write-Host ""
    foreach ($f in $filesToUpdate) {
        $dst = Join-Path $installDir $f
        if (-not (Test-Path $dst)) {
            Write-Host "  NEW: $f"
        } else {
            Write-Host "  MOD: $f"
        }
    }
    Write-Host ""

    if (-not $Yes) {
        $confirm = Read-Host "Apply all updates? [y/N]"
        if ($confirm -notmatch '^[Yy]$') {
            Write-Host "Aborted."
            Write-Host ""
            Write-Host "--- Summary ---"
            Write-Host "Differences: $($filesToUpdate.Count)"
            Write-Host "Status: OUT OF DATE"
            exit 1
        }
    }

    foreach ($f in $filesToUpdate) {
        $src = Join-Path $sourceDir $f
        $dst = Join-Path $installDir $f
        $dstDir = Split-Path $dst -Parent
        if (-not (Test-Path $dstDir)) {
            New-Item -ItemType Directory -Path $dstDir -Force | Out-Null
        }
        Copy-Item -Path $src -Destination $dst -Force
        Write-Host "[UPDATED] $f"
        $updates++
    }

    Write-Host ""
    Write-Host "--- Summary ---"
    Write-Host "Updated: $updates file(s)"
    if ($skipped -gt 0) {
        Write-Host "Skipped: $skipped file(s) (require manual handling)"
    }
    Write-Host "Status: UPDATED"
    exit 0
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

switch ($Mode) {
    "diff" { Invoke-DiffMode }
    "check" { Invoke-CheckMode $ProjectDir }
    "apply" { Invoke-ApplyMode $ProjectDir }
}
