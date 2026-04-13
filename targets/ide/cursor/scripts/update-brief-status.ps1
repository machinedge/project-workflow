$ErrorActionPreference = "Stop"

# Atomically updates the "Last updated" line in docs/project-brief.md under a lock.
# Prevents concurrent sessions from silently overwriting each other's status.
#
# Usage: update-brief-status.ps1 <issue-id> <status-description>
# Example: update-brief-status.ps1 swe-feature-049 "built concurrent handoff scripts"
# Output: "OK" on success
# Side effect: modifies docs/project-brief.md

if ($args.Count -lt 2) {
    Write-Error "Usage: update-brief-status.ps1 <issue-id> <status-description>"
    exit 1
}

$issueId = $args[0]
$statusDesc = ($args | Select-Object -Skip 1) -join " "

$brief = "docs/project-brief.md"
$lockfile = "docs/.update-brief.lock"

if (-not (Test-Path $brief)) {
    Write-Error "Error: $brief not found"
    exit 1
}

function Acquire-Lock {
    $maxWait = 10
    $waited = 0

    while ($true) {
        try {
            $stream = [System.IO.File]::Open($lockfile, [System.IO.FileMode]::CreateNew, [System.IO.FileAccess]::Write)
            $writer = New-Object System.IO.StreamWriter($stream)
            $writer.Write($PID)
            $writer.Close()
            $stream.Close()
            return
        } catch [System.IO.IOException] {
            if ($waited -ge $maxWait) {
                if (Test-Path $lockfile) {
                    $lockAge = ((Get-Date) - (Get-Item $lockfile).LastWriteTime).TotalSeconds
                    if ($lockAge -gt 5) {
                        Remove-Item -Force $lockfile
                        try {
                            $stream = [System.IO.File]::Open($lockfile, [System.IO.FileMode]::CreateNew, [System.IO.FileAccess]::Write)
                            $writer = New-Object System.IO.StreamWriter($stream)
                            $writer.Write($PID)
                            $writer.Close()
                            $stream.Close()
                            return
                        } catch [System.IO.IOException] {
                            # Fall through to error
                        }
                    }
                }
                Write-Error "Error: could not acquire lock after ${maxWait}s"
                exit 1
            }
            Start-Sleep -Seconds 1
            $waited++
        }
    }
}

Acquire-Lock

try {
    $newLine = "- **Last updated:** $issueId complete; $statusDesc"
    $content = Get-Content $brief -Encoding UTF8
    $found = $false
    $result = @()

    foreach ($line in $content) {
        if ($line -like "- **Last updated:***") {
            $result += $newLine
            $found = $true
        } else {
            $result += $line
        }
    }

    if (-not $found) {
        Write-Error "Error: could not find '- **Last updated:**' line in $brief"
        exit 1
    }

    $result | Set-Content $brief -Encoding UTF8
    Write-Output "OK"
} finally {
    if (Test-Path $lockfile) {
        Remove-Item -Force $lockfile
    }
}
