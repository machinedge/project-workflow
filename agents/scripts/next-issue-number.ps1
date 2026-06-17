$ErrorActionPreference = "Stop"

if (-not (Test-Path ".sdlc/issues")) {
    Write-Error "'.sdlc/issues/' directory not found. Run this script from the project root."
    exit 1
}

$max = 0
foreach ($dir in @(".sdlc/issues/backlog", ".sdlc/issues/planned", ".sdlc/issues/in-progress", ".sdlc/issues/done")) {
    if (-not (Test-Path $dir)) { continue }
    Get-ChildItem -Path $dir -Filter "*.md" | ForEach-Object {
        if ($_.BaseName -match '(\d+)$') {
            $num = [int]$Matches[1]
            if ($num -gt $max) { $max = $num }
        }
    }
}

"{0:D3}" -f ($max + 1)
