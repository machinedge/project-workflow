# Create a new workflow from templates (Windows)
# Usage: .\create-workflow.ps1 <workflow-name>
#
# Generates a new workflow directory at the repo root with all the necessary
# files pre-populated from templates.
#
# Examples:
#   .\create-workflow.ps1 devops
#   .\create-workflow.ps1 content-writing
#   .\create-workflow.ps1 research

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$WorkflowName
)

$ErrorActionPreference = "Stop"

# Validate name
if ($WorkflowName -notmatch '^[a-z0-9-]+$') {
    Write-Error "Error: Workflow name must be lowercase letters, numbers, and hyphens only. Got: '$WorkflowName'"
    exit 1
}

# Resolve paths
$ScriptDir = $PSScriptRoot
$RepoRoot = Split-Path $ScriptDir -Parent
$TemplateDir = Join-Path $ScriptDir "templates"
$TargetDir = Join-Path $RepoRoot $WorkflowName

if (Test-Path $TargetDir) {
    Write-Error "Error: $TargetDir already exists."
    exit 1
}

if (-not (Test-Path $TemplateDir)) {
    Write-Error "Error: Templates directory not found at $TemplateDir"
    exit 1
}

# ─────────────────────────────────────────────
# Derive placeholder values
# ─────────────────────────────────────────────

$DisplayName = ($WorkflowName -replace '-', ' ') -replace '(?:^| )(.)', { $_.Value.ToUpper() }

# Placeholder map
$Placeholders = @{
    '{{WORKFLOW_NAME}}'              = $WorkflowName
    '{{WORKFLOW_DISPLAY_NAME}}'      = $DisplayName
    '{{BRIEF_DOC}}'                  = 'project-brief.md'
    '{{BRIEF_DISPLAY_NAME}}'         = 'Project Brief'
    '{{BRIEF_DISPLAY_NAME_LOWER}}'   = 'project brief'
    '{{PLAN_DOC}}'                   = 'plan.md'
    '{{PLAN_DISPLAY_NAME}}'          = 'Plan'
    '{{NOTES_DOC}}'                  = 'interview-notes.md'
    '{{CURSOR_RULES_FILE}}'          = "$WorkflowName-os.mdc"
    '{{ISSUE_LABEL}}'                = 'task'
    '{{WORK_UNIT}}'                  = 'milestone'
    '{{WORK_UNIT_PLURAL}}'           = 'Milestones'
    '{{INTERVIEW_COMMAND}}'          = 'interview'
    '{{BRIEF_COMMAND}}'              = 'brief'
    '{{PLAN_COMMAND}}'               = 'plan'
    '{{SYNTHESIS_COMMAND}}'          = 'synthesis'
    '{{INTERVIEW_DESCRIPTION}}'      = 'Structured interview to understand goals, context, and constraints'
    '{{BRIEF_DESCRIPTION}}'          = 'Generate the project brief from interview notes'
    '{{PLAN_DESCRIPTION}}'           = 'Create the milestone plan with dependencies and risks'
    '{{SYNTHESIS_DESCRIPTION}}'      = 'Review completed milestone and synthesize results'
    '{{PHASE_2_NAME}}'               = 'Plan the Approach'
    '{{PHASE_3_NAME}}'               = 'Design the Solution'
    '{{PHASE_4_NAME}}'               = 'Prepare'
    '{{PHASE_5_NAME}}'               = 'Execute'
    '{{PHASE_6_NAME}}'               = 'Verify'
}

Write-Host "Creating workflow: $WorkflowName"
Write-Host "  Display name: $DisplayName"
Write-Host "  Directory: $TargetDir"

# ─────────────────────────────────────────────
# Create directory structure
# ─────────────────────────────────────────────

New-Item -ItemType Directory -Path "$TargetDir/commands" -Force | Out-Null

# ─────────────────────────────────────────────
# Process templates
# ─────────────────────────────────────────────

function Replace-Placeholders {
    param([string]$InputPath, [string]$OutputPath)

    $content = Get-Content $InputPath -Raw
    foreach ($key in $Placeholders.Keys) {
        $content = $content.Replace($key, $Placeholders[$key])
    }
    $content | Set-Content -Path $OutputPath -Encoding UTF8
}

# Core files
Replace-Placeholders "$TemplateDir/editor.md.tmpl" "$TargetDir/editor.md"
Replace-Placeholders "$TemplateDir/README.md.tmpl" "$TargetDir/README.md"
Replace-Placeholders "$TemplateDir/setup.sh.tmpl" "$TargetDir/setup.sh"
Replace-Placeholders "$TemplateDir/setup.ps1.tmpl" "$TargetDir/setup.ps1"
Replace-Placeholders "$TemplateDir/new_repo.sh.tmpl" "$TargetDir/new_repo.sh"
Replace-Placeholders "$TemplateDir/new_repo.ps1.tmpl" "$TargetDir/new_repo.ps1"

# Command files
Replace-Placeholders "$TemplateDir/commands/interview.md.tmpl" "$TargetDir/commands/interview.md"
Replace-Placeholders "$TemplateDir/commands/brief.md.tmpl" "$TargetDir/commands/brief.md"
Replace-Placeholders "$TemplateDir/commands/plan.md.tmpl" "$TargetDir/commands/plan.md"
Replace-Placeholders "$TemplateDir/commands/decompose.md.tmpl" "$TargetDir/commands/decompose.md"
Replace-Placeholders "$TemplateDir/commands/start.md.tmpl" "$TargetDir/commands/start.md"
Replace-Placeholders "$TemplateDir/commands/review.md.tmpl" "$TargetDir/commands/review.md"
Replace-Placeholders "$TemplateDir/commands/handoff.md.tmpl" "$TargetDir/commands/handoff.md"
Replace-Placeholders "$TemplateDir/commands/synthesis.md.tmpl" "$TargetDir/commands/synthesis.md"

# ─────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────

Write-Host ""
Write-Host "Done! Workflow scaffolded at: $TargetDir"
Write-Host ""
Write-Host "Files created:"
Get-ChildItem $TargetDir -Recurse -File | Sort-Object FullName | ForEach-Object {
    Write-Host "  $($_.FullName.Substring($RepoRoot.Length + 1))"
}
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Edit $WorkflowName/editor.md - customize the operating rules"
Write-Host "  2. Edit $WorkflowName/commands/*.md - customize each command"
Write-Host "  3. Edit $WorkflowName/README.md - write the workflow documentation"
Write-Host "  4. Remove <!-- GUIDE: ... --> comments as you fill in real content"
Write-Host "  5. Run: .\framework\validate.ps1 $WorkflowName"
Write-Host ""
Write-Host "See docs/workflow-anatomy.md for the full reference on patterns and conventions."
Write-Host ""
