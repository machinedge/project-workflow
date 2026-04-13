# Issue filename prefix convention inconsistent across skills

**Type:** bug
**Expert:** swe
**Milestone:** M11
**Status:** backlog
**Severity:** should-fix
**Found by:** /qa-review of swe-feature-036, swe-feature-037, swe-feature-038 (qa-feature-039)

## Description

Two naming inconsistencies in issue file creation across Cursor-native skills:

### 1. Executor vs. finder prefix

The `project-os.mdc` convention says `issues/<status>/[expert]-[type]-[NNN].md` but doesn't clarify whether `[expert]` is the workflow that will **execute** the fix or the workflow that **found** the issue. Skills disagree:

- **Executor prefix (matches `pm-decompose` convention and pre-M11 canonical behavior):**
  - `pm-decompose`: `swe-feature-NNN`, `qa-feature-NNN`, `devops-feature-NNN`
  - `sa-review`: "Assign to the appropriate expert" — filename prefix = executor
  - Previous QA session (qa-feature-005): created `swe-bug-024` for SWE to fix

- **Finder prefix (new in Cursor-native templates):**
  - `qa-review`: creates `qa-bug-NNN` and `qa-techdebt-NNN` with `**Expert:** swe`
  - `qa-regression`: creates `qa-bug-NNN` with `**Expert:** swe`

### 2. DevOps prefix: `devops-` vs `ops-`

The routing prefix for DevOps is `ops` (used in commands/skills: `ops-start`, `ops-deploy`, etc.), but issue files use the full name:

- `pm-decompose`: `devops-feature-005.md`
- `ops-pipeline`: `devops-feature-[number].md`
- `ops-deploy`: `devops-bug-[number].md`
- `ops-start` example: `ops-feature-001` (inconsistent with the others)

## Acceptance Criteria

- [ ] `project-os.mdc` convention clarifies whether `[expert]` in the issue filename is the executor or the finder
- [ ] All issue-creating skills (`pm-decompose`, `qa-review`, `qa-regression`, `qa-start`, `sa-review`, `ops-pipeline`, `ops-deploy`) use the same convention consistently
- [ ] DevOps issue filename prefix is consistent across all skills (either always `devops-` or always `ops-`)
- [ ] `ops-start` example matches the chosen DevOps prefix convention

## Technical Notes

**Estimated effort:** Small
**File(s):**
- `targets/ide/cursor/rules/project-os.mdc` (convention clarification)
- `targets/ide/cursor/skills/qa-review/SKILL.md`
- `targets/ide/cursor/skills/qa-regression/SKILL.md`
- `targets/ide/cursor/commands/qa-start.md`
- `targets/ide/cursor/skills/ops-pipeline/SKILL.md`
- `targets/ide/cursor/commands/ops-deploy.md`
- `targets/ide/cursor/commands/ops-start.md`
- `targets/ide/cursor/skills/pm-decompose/SKILL.md`
