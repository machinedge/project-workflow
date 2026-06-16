$ErrorActionPreference = "Stop"

if ($args.Count -lt 2) {
    Write-Error "Usage: move-issue.ps1 <filename> <target-status>`n  status: backlog | planned | in-progress | done"
    exit 1
}

$filename = $args[0]
$target = $args[1]
$validStatuses = @("backlog", "planned", "in-progress", "done")

if ($target -notin $validStatuses) {
    Write-Error "Invalid status '$target'. Must be one of: $($validStatuses -join ', ')"
    exit 1
}

if ($filename -notmatch '\.md$') { $filename += ".md" }

$sourceFile = $null
foreach ($dir in @(".sdlc/issues/backlog", ".sdlc/issues/planned", ".sdlc/issues/in-progress", ".sdlc/issues/done")) {
    $candidate = Join-Path $dir $filename
    if (Test-Path $candidate) {
        $sourceFile = $candidate
        break
    }
}

if (-not $sourceFile) {
    Write-Error "'$filename' not found in any issues directory"
    exit 1
}

$targetDir = ".sdlc/issues/$target"
$targetFile = Join-Path $targetDir $filename

if ($sourceFile -eq $targetFile) {
    Write-Output "'$filename' is already in '$target'"
    exit 0
}

if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir | Out-Null
}

Move-Item -Path $sourceFile -Destination $targetFile
$sourceDir = Split-Path $sourceFile -Parent
Write-Output "Moved '$filename' from '$sourceDir' to '$targetDir'"
