$ErrorActionPreference = "Stop"

# Atomically claims the next session number by creating a placeholder file.
# Prevents concurrent sessions from claiming the same number.
#
# Usage: next-session-number.ps1 <expert-name>
# Output: two-digit session number (e.g., "07")
# Side effect: creates .workflow/handoff-notes/<expert>/session-NN.md placeholder

if ($args.Count -lt 1) {
    Write-Error "Usage: next-session-number.ps1 <expert-name>"
    exit 1
}

$expert = $args[0]
$dir = ".workflow/handoff-notes/$expert"

if (-not (Test-Path $dir)) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
}

$max = 0
Get-ChildItem -Path $dir -Filter "session-*.md" -ErrorAction SilentlyContinue | ForEach-Object {
    if ($_.BaseName -match '(\d+)') {
        $num = [int]$Matches[1]
        if ($num -gt $max) { $max = $num }
    }
}

$next = $max + 1
$maxAttempts = 10

while ($next -le ($max + $maxAttempts)) {
    $candidate = Join-Path $dir ("session-{0:D2}.md" -f $next)
    try {
        $stream = [System.IO.File]::Open($candidate, [System.IO.FileMode]::CreateNew, [System.IO.FileAccess]::Write)
        $writer = New-Object System.IO.StreamWriter($stream)
        $writer.Write("<!-- session claimed -->")
        $writer.Close()
        $stream.Close()
        "{0:D2}" -f $next
        exit 0
    } catch [System.IO.IOException] {
        $next++
    }
}

Write-Error "Error: failed to claim a session number after $maxAttempts attempts"
exit 1
