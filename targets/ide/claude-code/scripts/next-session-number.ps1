$ErrorActionPreference = "Stop"

if ($args.Count -lt 1) {
    Write-Error "Usage: next-session-number.ps1 <expert-name>"
    exit 1
}

$expert = $args[0]
$dir = "docs/handoff-notes/$expert"

$max = 0
if (Test-Path $dir) {
    Get-ChildItem -Path $dir -Filter "session-*.md" | ForEach-Object {
        if ($_.BaseName -match '(\d+)') {
            $num = [int]$Matches[1]
            if ($num -gt $max) { $max = $num }
        }
    }
}

"{0:D2}" -f ($max + 1)
