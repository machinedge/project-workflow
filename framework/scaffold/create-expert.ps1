# Create a new expert definition (Windows)
# Usage: .\create-expert.ps1 -Domain <domain> <expert-name>
#        .\create-expert.ps1 -Domain <domain> -WithSkills <expert-name>
#
# Creates the directory structure for a new expert under experts/<domain>/.
# By default, generates only role.md with required sections, skills/, and tools/.
# Use -WithSkills to also scaffold the 8 default skill files from templates.
#
# Names are automatically normalized to lowercase-hyphenated format.
#
# Examples:
#   .\create-expert.ps1 -Domain technical maintenance-planner
#   .\create-expert.ps1 -Domain Technical "Content Writer"
#   .\create-expert.ps1 -Domain technical -WithSkills security-analyst

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$ExpertName,

    [Parameter(Mandatory = $true)]
    [string]$Domain,

    [switch]$WithSkills
)

$ErrorActionPreference = "Stop"

# ─────────────────────────────────────────────
# Normalize names to lowercase-hyphenated
# ─────────────────────────────────────────────

function Normalize-Name {
    param([string]$Name)
    $Name = $Name.ToLower() -replace '[ _]', '-' -replace '-{2,}', '-' -replace '^-|-$', ''
    return $Name
}

$Domain = Normalize-Name $Domain
$ExpertName = Normalize-Name $ExpertName

if ($ExpertName -notmatch '^[a-z0-9-]+$') {
    Write-Error "Expert name '$ExpertName' contains invalid characters after normalization."
    exit 1
}

if ($Domain -notmatch '^[a-z0-9-]+$') {
    Write-Error "Domain '$Domain' contains invalid characters after normalization."
    exit 1
}

# Resolve paths
$ScriptDir = $PSScriptRoot
$RepoRoot = Split-Path $ScriptDir -Parent
$TemplateDir = Join-Path $ScriptDir "templates"
$TargetDir = Join-Path $RepoRoot "experts" $Domain $ExpertName

if (Test-Path $TargetDir) {
    Write-Error "Error: $TargetDir already exists."
    exit 1
}

# ─────────────────────────────────────────────
# Derive display name
# ─────────────────────────────────────────────

$DisplayName = ($ExpertName -replace '-', ' ') -replace '(?:^| )(.)', { $_.Value.ToUpper() }

Write-Host "Creating expert: $ExpertName"
Write-Host "  Domain: $Domain"
Write-Host "  Display name: $DisplayName"
Write-Host "  Directory: $TargetDir"

# ─────────────────────────────────────────────
# Create directory structure
# ─────────────────────────────────────────────

New-Item -ItemType Directory -Path "$TargetDir/skills" -Force | Out-Null
New-Item -ItemType Directory -Path "$TargetDir/tools" -Force | Out-Null
New-Item -ItemType File -Path "$TargetDir/tools/.gitkeep" -Force | Out-Null

# ─────────────────────────────────────────────
# Generate role.md with required sections
# ─────────────────────────────────────────────

@"
# ${DisplayName} Operating System

You are working as the ${DisplayName} expert on a coordinated team.

## Document Locations

| Document | Path | Purpose |
|----------|------|---------|
| Project Brief | ``docs/project-brief.md`` | Goals, constraints, decisions, status. READ THIS FIRST. |
| Handoff Notes | ``docs/handoff-notes/${ExpertName}/session-NN.md`` | What happened in each past session. |
| Docs Protocol | ``experts/${Domain}/shared/docs-protocol.md`` | Cross-expert document contracts. |

## Session Protocol

### Starting a session
1. Read ``docs/project-brief.md`` (always --- no exceptions)
2. Read the most recent handoff note in ``docs/handoff-notes/${ExpertName}/``
3. Read the issue or task you've been assigned
4. Confirm your understanding before starting work

### During a session
- Stay within scope. If you discover something out of scope, flag it, don't do it.
- Verify your work before declaring the task complete.

### Ending a session
Produce a handoff note and save it to ``docs/handoff-notes/${ExpertName}/session-NN.md``.

## Skills

<!-- List available skills here as you develop them. -->

## Principles

- You have no memory between sessions. Project documents ARE your memory.
- The project brief is the source of truth. If something contradicts it, ask the user.
- Every task includes verification. "It should work" is not verification.
"@ | Set-Content -Path "$TargetDir/role.md" -Encoding UTF8

# ─────────────────────────────────────────────
# Optionally scaffold skill files from templates
# ─────────────────────────────────────────────

if ($WithSkills) {
    $SkillTemplateDir = Join-Path $TemplateDir "skills"
    if (-not (Test-Path $SkillTemplateDir)) {
        Write-Warning "Templates directory not found at $SkillTemplateDir - skipping skill scaffolding."
    } else {
        Write-Host "  Scaffolding default skill files from templates..."

        $Placeholders = @{
            '{{EXPERT_NAME}}'              = $ExpertName
            '{{EXPERT_DISPLAY_NAME}}'      = $DisplayName
            '{{DOMAIN}}'                   = $Domain
            '{{BRIEF_DOC}}'                = 'project-brief.md'
            '{{BRIEF_DISPLAY_NAME}}'       = 'Project Brief'
            '{{BRIEF_DISPLAY_NAME_LOWER}}' = 'project brief'
            '{{PLAN_DOC}}'                 = 'plan.md'
            '{{PLAN_DISPLAY_NAME}}'        = 'Plan'
            '{{NOTES_DOC}}'                = 'interview-notes.md'
            '{{ISSUE_LABEL}}'              = 'task'
            '{{WORK_UNIT}}'                = 'milestone'
            '{{WORK_UNIT_PLURAL}}'         = 'Milestones'
            '{{INTERVIEW_SKILL}}'          = 'interview'
            '{{BRIEF_SKILL}}'              = 'brief'
            '{{PLAN_SKILL}}'               = 'plan'
            '{{SYNTHESIS_SKILL}}'          = 'synthesis'
            '{{INTERVIEW_DESCRIPTION}}'    = 'Structured interview to understand goals, context, and constraints'
            '{{BRIEF_DESCRIPTION}}'        = 'Generate the project brief from interview notes'
            '{{PLAN_DESCRIPTION}}'         = 'Create the milestone plan with dependencies and risks'
            '{{SYNTHESIS_DESCRIPTION}}'    = 'Review completed milestone and synthesize results'
            '{{PHASE_2_NAME}}'             = 'Plan the Approach'
            '{{PHASE_3_NAME}}'             = 'Design the Solution'
            '{{PHASE_4_NAME}}'             = 'Prepare'
            '{{PHASE_5_NAME}}'             = 'Execute'
            '{{PHASE_6_NAME}}'             = 'Verify'
        }

        Get-ChildItem "$SkillTemplateDir/*.md.tmpl" | ForEach-Object {
            $skillName = $_.BaseName -replace '\.md$', ''
            $content = Get-Content $_.FullName -Raw
            foreach ($key in $Placeholders.Keys) {
                $content = $content.Replace($key, $Placeholders[$key])
            }
            $content | Set-Content -Path "$TargetDir/skills/${skillName}.md" -Encoding UTF8
        }
    }
}

# ─────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────

Write-Host ""
Write-Host "Done! Expert scaffolded at: $TargetDir"
Write-Host ""
Write-Host "Files created:"
Get-ChildItem $TargetDir -Recurse -File | Sort-Object FullName | ForEach-Object {
    Write-Host "  $($_.FullName.Substring($RepoRoot.Length + 1))"
}
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Edit experts/$Domain/$ExpertName/role.md - define identity and operating rules"
Write-Host "  2. Add skills to experts/$Domain/$ExpertName/skills/"
Write-Host "  3. Run: .\framework\validate.sh $Domain/$ExpertName"
Write-Host ""
