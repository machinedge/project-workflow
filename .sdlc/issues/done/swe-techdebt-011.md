# Add update_plan to PM role.md Skills section

**Type:** techdebt
**Expert:** swe
**Milestone:** [Expert Skill Restructure] Standardize `/start` and `/handoff` across PM, QA, DevOps (M4)
**Status:** backlog
**Severity:** should-fix
**Found by:** /review of swe-feature-002 (pre-existing gap flagged in session-01 handoff)

## User Story

As a toolkit user, I want all available PM commands listed in the PM role.md so that I can discover and use `/update-plan` without having to guess it exists.

## Description

The file `experts/technical/project-manager/skills/update_plan.md` exists on disk but isn't listed in PM `role.md`'s Skills section. This was flagged as a pre-existing gap in SWE session-01 handoff notes. Users won't know the command is available unless they browse the filesystem.

## Acceptance Criteria

- [ ] PM `role.md` Skills section includes `/update-plan` with a brief description
- [ ] Description is consistent with the style of other listed skills

## Technical Notes

**Estimated effort:** Small session
**File(s):** `experts/technical/project-manager/role.md`
