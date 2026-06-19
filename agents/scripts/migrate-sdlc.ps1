# MachinEdge Expert Teams — Migrate SDLC (PowerShell)
# Usage: .\migrate-sdlc.ps1 [target-directory]
#
# Relocates canonical spec artifacts from docs/ to .sdlc/:
#   - Named spec files (architecture.md, test-plan.md, etc.)
#   - Draft globs (docs/*-draft.md matching <spec>.*-draft.md)
#   - Spec subfolders (research/, security/, runbooks/)
#
# Leaves user-facing files untouched (docs/guides/, README.md, etc.).
# Idempotent: safe to re-run. Collision-safe: reports and skips, never clobbers.
# Exits 0 when clean; non-zero if any collision occurred.

param(
    [Parameter(ValueFromRemainingArguments=$true)]
    [string]$TargetArg = "."
)

# ─────────────────────────────────────────────
# Configuration and validation (SR-005)
# ─────────────────────────────────────────────

$Target = $TargetArg

# Validate target (SR-005)
if ([string]::IsNullOrWhiteSpace($Target)) {
    Write-Error "Error: target directory is empty or missing." -ErrorAction Stop
    exit 1
}

# Resolve and validate target path
try {
    $ResolvedTarget = Resolve-Path -Path $Target -ErrorAction Stop
    $Target = $ResolvedTarget.Path
} catch {
    Write-Error "Error: target directory does not exist or is not accessible: $TargetArg" -ErrorAction Stop
    exit 1
}

if (-not (Test-Path -Path $Target -PathType Container)) {
    Write-Error "Error: target is not a directory: $Target" -ErrorAction Stop
    exit 1
}

# State tracking
$CollisionsOccurred = $false
$RelocationList = @()

# ─────────────────────────────────────────────
# Migration functions
# ─────────────────────────────────────────────

# Get-RelativePath: render a path relative to $Target with forward slashes,
# so move/report output matches the installer's "docs/X → .sdlc/X" convention
# (and the bash script's output byte-for-byte).
function Get-RelativePath {
    param([string]$Path)
    $rel = $Path
    if ($Path.StartsWith($Target)) {
        $rel = $Path.Substring($Target.Length).TrimStart('\', '/')
    }
    return ($rel -replace '\\', '/')
}

# Migrate-File: Move src to dest if dest doesn't exist. On collision, report and leave both.
function Migrate-File {
    param(
        [string]$Src,
        [string]$Dest
    )

    # Absent source = nothing to do (optional)
    if (-not (Test-Path -Path $Src -PathType Leaf)) {
        return
    }

    # Collision: dest already exists
    if (Test-Path -Path $Dest) {
        Write-Error "COLLISION: $Src and $Dest both exist; not moving. Resolve manually." -ErrorAction Continue
        $script:CollisionsOccurred = $true
        return
    }

    # Move it
    $DestDir = Split-Path -Parent $Dest
    if (-not (Test-Path -Path $DestDir -PathType Container)) {
        New-Item -ItemType Directory -Path $DestDir -Force | Out-Null
    }

    Move-Item -Path $Src -Destination $Dest -Force
    Write-Output ("  {0} → {1}" -f (Get-RelativePath $Src), (Get-RelativePath $Dest))
    $script:RelocationList += "$Src->$Dest"
}

# Migrate-Dir: Move src/ to dest/ if dest doesn't exist. On collision, report and skip.
function Migrate-Dir {
    param(
        [string]$Src,
        [string]$Dest
    )

    # Absent source = nothing to do (optional)
    if (-not (Test-Path -Path $Src -PathType Container)) {
        return
    }

    # Collision: dest already exists
    if (Test-Path -Path $Dest) {
        Write-Error "COLLISION: $Src and $Dest both exist; not moving. Resolve manually." -ErrorAction Continue
        $script:CollisionsOccurred = $true
        return
    }

    # Move it
    $DestDir = Split-Path -Parent $Dest
    if (-not (Test-Path -Path $DestDir -PathType Container)) {
        New-Item -ItemType Directory -Path $DestDir -Force | Out-Null
    }

    Move-Item -Path $Src -Destination $Dest -Force
    Write-Output ("  {0} → {1}" -f (Get-RelativePath $Src), (Get-RelativePath $Dest))
    $script:RelocationList += "$Src->$Dest"
}

# ─────────────────────────────────────────────
# Migrate canonical files
# ─────────────────────────────────────────────

# Canonical file inventory (from docs/architecture.m19-draft.md, ADR-M19-3)
$CanonicalFiles = @(
    'architecture.md',
    'pipeline.md',
    'components.md',
    'documentation-plan.md',
    'test-plan.md',
    'security-requirements.md',
    'ux-guidelines.md',
    'task-detail-standard.md',
    'env-context.md',
    'release-plan.md'
)

# Canonical spec names (without extension). A draft migrates only when its
# basename matches <spec>.*-draft.md. Any other *-draft.md (e.g. a user's
# my-blog-post-draft.md) is left untouched.
$CanonicalSpecs = @(
    'architecture',
    'pipeline',
    'components',
    'documentation-plan',
    'test-plan',
    'security-requirements',
    'ux-guidelines',
    'task-detail-standard',
    'env-context',
    'release-plan'
)

# Test-CanonicalDraft: true if basename matches <canonical-spec>.*-draft.md
function Test-CanonicalDraft {
    param([string]$Name)
    if ($Name -notlike '*-draft.md') {
        return $false
    }
    foreach ($spec in $CanonicalSpecs) {
        if ($Name -like "$spec.*-draft.md") {
            return $true
        }
    }
    return $false
}

foreach ($f in $CanonicalFiles) {
    $Src = Join-Path -Path $Target -ChildPath "docs\$f"
    $Dest = Join-Path -Path $Target -ChildPath ".sdlc\$f"
    Migrate-File -Src $Src -Dest $Dest
}

# ─────────────────────────────────────────────
# Migrate draft globs
# ─────────────────────────────────────────────

# Expand docs/*-draft.md and filter to the canonical <spec>.*-draft.md pattern
# (i.e., only migration-owned drafts, not arbitrary user files such as a blog post).
$DocsPath = Join-Path -Path $Target -ChildPath "docs"
if (Test-Path -Path $DocsPath -PathType Container) {
    $DraftFiles = Get-ChildItem -Path $DocsPath -Filter '*-draft.md' -File
    foreach ($file in $DraftFiles) {
        # Only migrate drafts of canonical specs; leave any other *-draft.md untouched.
        if (-not (Test-CanonicalDraft $file.Name)) { continue }
        $Src = $file.FullName
        $FileName = $file.Name
        $Dest = Join-Path -Path $Target -ChildPath ".sdlc\$FileName"
        Migrate-File -Src $Src -Dest $Dest
    }
}

# ─────────────────────────────────────────────
# Migrate spec subfolders
# ─────────────────────────────────────────────

$SubDirs = @('research', 'security', 'runbooks')
foreach ($subdir in $SubDirs) {
    $Src = Join-Path -Path $Target -ChildPath "docs\$subdir"
    $Dest = Join-Path -Path $Target -ChildPath ".sdlc\$subdir"
    Migrate-Dir -Src $Src -Dest $Dest
}

# ─────────────────────────────────────────────
# Verify: re-scan docs/ for any remaining inventory items
# ─────────────────────────────────────────────

function Test-Clean {
    $RemainingItems = $false

    # Check for remaining canonical files
    foreach ($f in $CanonicalFiles) {
        $Path = Join-Path -Path $Target -ChildPath "docs\$f"
        if (Test-Path -Path $Path -PathType Leaf) {
            Write-Error "Verification failed: $Path still exists (should be moved)" -ErrorAction Continue
            $RemainingItems = $true
        }
    }

    # Check for remaining canonical draft globs. A correctly-skipped user draft
    # (non-canonical) is NOT a failure here.
    $DocsPath = Join-Path -Path $Target -ChildPath "docs"
    if (Test-Path -Path $DocsPath -PathType Container) {
        $DraftFiles = Get-ChildItem -Path $DocsPath -Filter '*-draft.md' -File
        foreach ($file in $DraftFiles) {
            if (-not (Test-CanonicalDraft $file.Name)) { continue }
            Write-Error "Verification failed: $(Get-RelativePath $file.FullName) still exists (should be moved)" -ErrorAction Continue
            $RemainingItems = $true
        }
    }

    # Check for remaining spec subfolders
    foreach ($subdir in $SubDirs) {
        $Path = Join-Path -Path $Target -ChildPath "docs\$subdir"
        if (Test-Path -Path $Path -PathType Container) {
            Write-Error "Verification failed: $Path still exists (should be moved)" -ErrorAction Continue
            $RemainingItems = $true
        }
    }

    return -not $RemainingItems
}

# ─────────────────────────────────────────────
# Report and exit
# ─────────────────────────────────────────────

if (-not (Test-Clean)) {
    Write-Error "Error: Verification failed — some inventory items remain in docs/." -ErrorAction Stop
    exit 1
}

# Collisions: report and exit non-zero. Do NOT print the "Already clean" line —
# it would be misleading on a collision-only run.
if ($CollisionsOccurred) {
    Write-Output ""
    Write-Error "Error: One or more collisions occurred. Resolve manually, then re-run." -ErrorAction Continue
    exit 1
}

# Success: print an explicit verification summary.
if ($RelocationList.Count -gt 0) {
    Write-Output "Migration complete: $($RelocationList.Count) spec(s) relocated, docs/ now clean of specs."
} else {
    Write-Output "Already clean — no specs to migrate."
}

exit 0
