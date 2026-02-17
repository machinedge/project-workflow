# MachinEdge Expert Teams — Install Team (Docker) — Windows
# Usage: .\install-team.ps1 [-Experts pm,swe,qa,devops] [-Domain technical] [-ProjectName NAME] [-Target <project-directory>]
#
# Generates Docker infrastructure for running an expert team in containers.
# Creates a .octeam/ directory in the target project with docker-compose.yml,
# Matrix messaging (Conduit + Element Web), and per-expert configurations.
#
# Each expert runs in its own container based on the OpenClaw image, with
# its own git clone for true parallel work. The human interacts with the
# team through Element Web (Matrix client) in a browser.
#
# Expert short names are mapped to their full directory names:
#   pm → project-manager, swe → swe, qa → qa, devops → devops, data-analyst → data-analyst
#
# Examples:
#   .\install-team.ps1 -Target ~\myproj                                   # All core experts, defaults
#   .\install-team.ps1 -Experts "pm,swe" -Target ~\myproj                 # Just PM and SWE
#   .\install-team.ps1 -ProjectName acme-app -Target ~\myproj             # Custom project name

param(
    [string]$Experts = "project-manager,swe,qa,devops",
    [string]$Domain = "technical",
    [string]$ProjectName = "",
    [string]$Target = "."
)

$ErrorActionPreference = "Stop"

# ─────────────────────────────────────────────
# Resolve paths
# ─────────────────────────────────────────────

$ScriptDir = $PSScriptRoot
$RepoRoot = & git -C $ScriptDir rev-parse --show-toplevel 2>$null
if (-not $RepoRoot) {
    $dir = $ScriptDir
    while ($dir -and -not (Test-Path (Join-Path $dir ".git")) -and -not (Test-Path (Join-Path $dir "SKILL.md"))) {
        $dir = Split-Path $dir -Parent
    }
    $RepoRoot = $dir
}
if (-not $RepoRoot) {
    Write-Error "Error: Could not find repository or skill root from $ScriptDir"
    exit 1
}

$TemplateDir = Join-Path $ScriptDir "templates" "team"
if (-not (Test-Path $TemplateDir)) {
    Write-Error "Error: Template directory not found at $TemplateDir"
    exit 1
}

# ─────────────────────────────────────────────
# Parse target and project name
# ─────────────────────────────────────────────

if ($Target -ne ".") {
    New-Item -ItemType Directory -Path $Target -Force | Out-Null
}

if (-not $ProjectName) {
    $ProjectName = (Split-Path (Resolve-Path $Target) -Leaf).ToLower() -replace '[^a-z0-9-]', '-'
}

$OcteamDir = Join-Path $Target ".octeam"

# ─────────────────────────────────────────────
# Map short names to full expert directory names
# ─────────────────────────────────────────────

function Resolve-ExpertName {
    param([string]$Name)
    switch ($Name) {
        "pm"              { return "project-manager" }
        "project-manager" { return "project-manager" }
        "swe"             { return "swe" }
        "qa"              { return "qa" }
        "devops"          { return "devops" }
        "eda"             { return "data-analyst" }
        "data-analyst"    { return "data-analyst" }
        "ux"              { return "user-experience" }
        "user-experience" { return "user-experience" }
        default           { return $Name }
    }
}

$ExpertList = $Experts -split ',' | ForEach-Object {
    $resolved = Resolve-ExpertName $_.Trim()
    $expertDir = Join-Path $RepoRoot "experts" $Domain $resolved
    if (-not (Test-Path $expertDir)) {
        Write-Error "Error: Expert '$_' (resolved to '$resolved') not found at $expertDir"
        exit 1
    }
    $resolved
}

# ─────────────────────────────────────────────
# Prerequisite checks
# ─────────────────────────────────────────────

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Error "Error: docker is not installed or not in PATH`n  Install it: https://docs.docker.com/get-docker/"
    exit 1
}

$composeCheck = & docker compose version 2>$null
if (-not $composeCheck) {
    Write-Error "Error: docker compose plugin is not available`n  Install it: https://docs.docker.com/compose/install/"
    exit 1
}

# ─────────────────────────────────────────────
# Template helpers
# ─────────────────────────────────────────────

function Render-SimpleTemplate {
    param([string]$Template, [string]$Output)
    $content = [System.IO.File]::ReadAllText($Template)
    $content = $content -replace '{{PROJECT_NAME}}', $ProjectName
    [System.IO.File]::WriteAllText($Output, $content)
}

function Render-ExpertTemplate {
    param([string]$Template, [string]$Output, [string]$ExpertName)
    $content = [System.IO.File]::ReadAllText($Template)
    $content = $content -replace '{{EXPERT_NAME}}', $ExpertName
    [System.IO.File]::WriteAllText($Output, $content)
}

function Render-ComposeTemplate {
    param([string]$Template, [string]$Output, [string]$Services, [string]$Volumes, [string]$ExpertsCsv)
    $lines = [System.IO.File]::ReadAllLines($Template)
    $result = [System.Collections.Generic.List[string]]::new()
    foreach ($line in $lines) {
        if ($line -match '{{EXPERT_SERVICES}}') {
            $result.AddRange($Services -split "`n")
        } elseif ($line -match '{{EXPERT_VOLUMES}}') {
            $result.AddRange($Volumes -split "`n")
        } elseif ($line -match '{{EXPERT_LIST_CSV}}') {
            $result.Add(($line -replace '{{EXPERT_LIST_CSV}}', $ExpertsCsv))
        } else {
            $result.Add($line)
        }
    }
    [System.IO.File]::WriteAllLines($Output, $result.ToArray())
}

# ─────────────────────────────────────────────
# Status banner
# ─────────────────────────────────────────────

Write-Host "Setting up expert team (Docker) in: $Target/.octeam/"
Write-Host "  Project name: $ProjectName"
Write-Host "  Experts: $($ExpertList -join ' ')"
Write-Host "  Domain: $Domain"
Write-Host ""

# ─────────────────────────────────────────────
# Create directory structure
# ─────────────────────────────────────────────

foreach ($d in @(
    (Join-Path $OcteamDir "configs" "conduit"),
    (Join-Path $OcteamDir "configs" "element"),
    (Join-Path $OcteamDir "scripts"),
    (Join-Path $OcteamDir "data")
)) {
    New-Item -ItemType Directory -Path $d -Force | Out-Null
}

foreach ($expert in $ExpertList) {
    New-Item -ItemType Directory -Path (Join-Path $OcteamDir "configs" $expert "skills") -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $OcteamDir "configs" $expert "tools") -Force | Out-Null
}

# ─────────────────────────────────────────────
# Generate static and templated config files
# ─────────────────────────────────────────────

Copy-Item (Join-Path $TemplateDir "gitignore") -Destination (Join-Path $OcteamDir ".gitignore") -Force
Write-Host "  Generated .gitignore"

$envFile = Join-Path $OcteamDir ".env"
if (-not (Test-Path $envFile)) {
    Render-SimpleTemplate -Template (Join-Path $TemplateDir "env.template") -Output $envFile
    Write-Host "  Created .env template (edit with your API keys and git URL)"
} else {
    Write-Host "  .env already exists, preserving"
}

Render-SimpleTemplate -Template (Join-Path $TemplateDir "conduit.toml.template") -Output (Join-Path $OcteamDir "configs" "conduit" "conduit.toml")
Write-Host "  Generated configs/conduit/conduit.toml"

Render-SimpleTemplate -Template (Join-Path $TemplateDir "element-config.json.template") -Output (Join-Path $OcteamDir "configs" "element" "config.json")
Write-Host "  Generated configs/element/config.json"

# ─────────────────────────────────────────────
# Translate expert definitions to OpenClaw format
# ─────────────────────────────────────────────

foreach ($expert in $ExpertList) {
    $ExpertSrc = Join-Path $RepoRoot "experts" $Domain $expert
    Write-Host "  [$expert] Translating expert definition..."

    # role.md → AGENTS.md
    $roleFile = Join-Path $ExpertSrc "role.md"
    if (Test-Path $roleFile) {
        Copy-Item $roleFile -Destination (Join-Path $OcteamDir "configs" $expert "AGENTS.md") -Force
        Write-Host "    role.md -> AGENTS.md"
    }

    # skills/*.md → skills/<name>/SKILL.md (with YAML frontmatter)
    $skillsDir = Join-Path $ExpertSrc "skills"
    if (Test-Path $skillsDir) {
        $skillCount = 0
        Get-ChildItem (Join-Path $skillsDir "*.md") -ErrorAction SilentlyContinue | ForEach-Object {
            $skillName = $_.BaseName
            $skillDir = Join-Path $OcteamDir "configs" $expert "skills" $skillName
            New-Item -ItemType Directory -Path $skillDir -Force | Out-Null

            $firstLine = Get-Content $_.FullName -TotalCount 1
            $skillDesc = $firstLine -replace '^#\s*', ''

            $skillContent = Get-Content $_.FullName -Raw
            $frontmatter = "---`nname: $skillName`ndescription: `"$skillDesc`"`n---`n`n"
            [System.IO.File]::WriteAllText((Join-Path $skillDir "SKILL.md"), ($frontmatter + $skillContent))

            $skillCount++
        }
        if ($skillCount -gt 0) {
            Write-Host "    $skillCount skill(s) translated"
        }
    }

    # tools/ → tools/ (copy directly, skip .gitkeep)
    $toolsDir = Join-Path $ExpertSrc "tools"
    if (Test-Path $toolsDir) {
        $tools = Get-ChildItem $toolsDir -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne ".gitkeep" }
        if ($tools) {
            $tools | ForEach-Object {
                Copy-Item $_.FullName -Destination (Join-Path $OcteamDir "configs" $expert "tools" $_.Name) -Force
            }
            Write-Host "    $($tools.Count) tool(s) copied"
        }
    }

    # Per-expert env overrides (create template if not exists)
    $expertEnvFile = Join-Path $OcteamDir "configs" $expert "env"
    if (-not (Test-Path $expertEnvFile)) {
        Render-ExpertTemplate -Template (Join-Path $TemplateDir "expert-env.template") -Output $expertEnvFile -ExpertName $expert
    }
}

# ─────────────────────────────────────────────
# Translate shared skills (copied into every expert)
# ─────────────────────────────────────────────

$SharedDir = Join-Path $RepoRoot "experts" $Domain "shared"
$SharedSkillsDir = Join-Path $SharedDir "skills"
if (Test-Path $SharedSkillsDir) {
    Write-Host ""
    Write-Host "  [shared] Translating shared skills..."
    $sharedCount = 0
    Get-ChildItem (Join-Path $SharedSkillsDir "*.md") -ErrorAction SilentlyContinue | ForEach-Object {
        $skillName = "team-$($_.BaseName)"
        $firstLine = Get-Content $_.FullName -TotalCount 1
        $skillDesc = $firstLine -replace '^#\s*', ''
        $skillContent = Get-Content $_.FullName -Raw

        foreach ($expert in $ExpertList) {
            $skillDir = Join-Path $OcteamDir "configs" $expert "skills" $skillName
            New-Item -ItemType Directory -Path $skillDir -Force | Out-Null
            $frontmatter = "---`nname: $skillName`ndescription: `"$skillDesc`"`n---`n`n"
            [System.IO.File]::WriteAllText((Join-Path $skillDir "SKILL.md"), ($frontmatter + $skillContent))
        }
        $sharedCount++
    }
    if ($sharedCount -gt 0) {
        Write-Host "    $sharedCount shared skill(s) -> all experts"
    }
}

# ─────────────────────────────────────────────
# Generate runtime scripts from templates
# ─────────────────────────────────────────────

Copy-Item (Join-Path $TemplateDir "expert-entrypoint.sh") -Destination (Join-Path $OcteamDir "scripts" "expert-entrypoint.sh") -Force
Copy-Item (Join-Path $TemplateDir "setup-matrix.sh") -Destination (Join-Path $OcteamDir "scripts" "setup-matrix.sh") -Force
Write-Host ""
Write-Host "  Generated scripts/expert-entrypoint.sh"
Write-Host "  Generated scripts/setup-matrix.sh"

# ─────────────────────────────────────────────
# Generate docker-compose.yml from template
# ─────────────────────────────────────────────

$serviceTemplate = [System.IO.File]::ReadAllText((Join-Path $TemplateDir "expert-service.yml.template"))
$expertServices = ""
$expertVolumes = ""
$expertListCsv = ""

foreach ($expert in $ExpertList) {
    if ($expertListCsv) {
        $expertListCsv += ",$expert"
    } else {
        $expertListCsv = $expert
    }

    $service = $serviceTemplate -replace '{{EXPERT_NAME}}', $expert
    if ($expertServices) {
        $expertServices += "`n$service"
    } else {
        $expertServices = $service
    }

    if ($expertVolumes) {
        $expertVolumes += "`n  ${expert}-workspace:"
    } else {
        $expertVolumes = "  ${expert}-workspace:"
    }
}

Render-ComposeTemplate `
    -Template (Join-Path $TemplateDir "docker-compose.yml.template") `
    -Output (Join-Path $OcteamDir "docker-compose.yml") `
    -Services $expertServices `
    -Volumes $expertVolumes `
    -ExpertsCsv $expertListCsv
Write-Host ""
Write-Host "  Generated docker-compose.yml"

# ─────────────────────────────────────────────
# Create shared project docs structure
# ─────────────────────────────────────────────

New-Item -ItemType Directory -Path (Join-Path $Target "docs" "handoff-notes") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $Target "issues") -Force | Out-Null

$lessonsFile = Join-Path $Target "docs" "lessons-log.md"
if (-not (Test-Path $lessonsFile)) {
    Copy-Item (Join-Path $TemplateDir "lessons-log.md") -Destination $lessonsFile -Force
}

foreach ($expert in $ExpertList) {
    New-Item -ItemType Directory -Path (Join-Path $Target "docs" "handoff-notes" $expert) -Force | Out-Null
}

# ─────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────

Write-Host ""
Write-Host "Done! Team infrastructure generated:"
Write-Host ""
Get-ChildItem $OcteamDir -Recurse -File -ErrorAction SilentlyContinue | Sort-Object FullName | ForEach-Object {
    Write-Host "  $($_.FullName)"
}
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Edit .octeam/.env with your API keys and git URL"
Write-Host "  2. cd $Target/.octeam"
Write-Host "  3. docker compose up -d"
Write-Host "  4. Wait for all services to start (~30 seconds)"
Write-Host "  5. Open http://localhost:8009 in your browser (Element Web)"
Write-Host "  6. Login as 'admin' with the password from .env (MATRIX_ADMIN_PASSWORD)"
Write-Host "  7. Join the #project room to interact with your expert team"
Write-Host ""
Write-Host "Useful commands:"
Write-Host "  docker compose ps                        # Show running containers"
Write-Host "  docker compose logs -f                   # Watch all logs"
Write-Host "  docker compose logs -f project-manager   # Watch PM logs"
Write-Host "  docker compose run --rm matrix-setup     # Re-run Matrix setup"
Write-Host "  docker compose down                      # Stop the team"
Write-Host "  docker compose down -v                   # Stop and remove all data"
Write-Host ""
