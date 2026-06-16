$ErrorActionPreference = "Stop"

if (-not (Test-Path ".sdlc/issues")) {
    Write-Error "'.sdlc/issues/' directory not found. Run this script from the project root."
    exit 1
}

$output = ".sdlc/issues/issues-list.md"

$header = @"
# Issues List

| File | Title | Expert | Type | Milestone | Prerequisites | Status |
|------|-------|--------|------|-----------|---------------|--------|
"@

$rows = @()
foreach ($dir in @(".sdlc/issues/backlog", ".sdlc/issues/planned", ".sdlc/issues/in-progress", ".sdlc/issues/done")) {
    if (-not (Test-Path $dir)) { continue }
    $status = Split-Path $dir -Leaf
    foreach ($file in Get-ChildItem -Path $dir -Filter "*.md") {
        $content = Get-Content $file.FullName -Raw
        $filename = $file.BaseName

        $title = ""
        if ($content -match '(?m)^# (.+)') { $title = $Matches[1].Trim() }

        $type = ""
        if ($content -match '(?m)^\*\*Type:\*\*\s*(.+)') { $type = $Matches[1].Trim() }

        $expert = ""
        if ($content -match '(?m)^\*\*Expert:\*\*\s*(.+)') { $expert = $Matches[1].Trim() }

        $milestone = ""
        if ($content -match '(?m)^\*\*Milestone:\*\*\s*(.+)') { $milestone = $Matches[1].Trim() }

        $deps = [char]0x2014  # em dash
        if ($content -match '(?m)^\*\*Dependencies:\*\*\s*(.+)') {
            $depsRaw = $Matches[1].Trim()
            if ($depsRaw -eq "None" -or $depsRaw -eq "none" -or $depsRaw -eq "") {
                $deps = [char]0x2014
            } else {
                $deps = $depsRaw -replace '\s*\([^)]*\)', ''
            }
        }

        $num = 0
        if ($filename -match '(\d+)$') { $num = [int]$Matches[1] }

        $rows += [PSCustomObject]@{
            Num  = $num
            Line = "| $filename | $title | $expert | $type | $milestone | $deps | $status |"
        }
    }
}

$sortedLines = $rows | Sort-Object Num | ForEach-Object { $_.Line }
$body = $sortedLines -join "`n"
if ($body) {
    "$header`n$body`n" | Set-Content -Path $output -NoNewline -Encoding UTF8
} else {
    "$header" | Set-Content -Path $output -NoNewline -Encoding UTF8
}

Write-Output "Updated $output"
