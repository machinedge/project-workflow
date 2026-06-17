# Fix nits: /start tagline, docs-protocol description, PM docs-protocol path

**Type:** techdebt
**Expert:** swe
**Milestone:** [Expert Skill Restructure] Update SWE `/start` and docs-protocol for `architecture.md` (M5)
**Status:** backlog
**Severity:** should-fix
**Found by:** /review of swe-feature-002, swe-feature-003, swe-feature-004

## User Story

As a toolkit author, I want the skill files and docs-protocol to be internally consistent so that AI agents following them don't get contradictory or misleading instructions.

## Description

Three minor inconsistencies found during QA review:

1. QA and DevOps `/start` line 1 says "This is the most important command" — copied verbatim from SWE. For QA and DevOps, this is misleading since domain-specific skills like `/review` or `/pipeline` are arguably more central. Remove the line or make it accurate.

2. docs-protocol.md Document Locations table describes Handoff Notes as "organized by workflow (swe/, qa/, devops/, pm/)" but doesn't mention `system-architect/`. The tree diagram below does. Inconsistency.

3. PM role.md line 7 references `experts/shared/docs-protocol.md` but the correct path is `experts/technical/shared/docs-protocol.md`. Pre-existing issue.

## Acceptance Criteria

- [ ] QA `/start` line 1 is either removed or made accurate for QA
- [ ] DevOps `/start` line 1 is either removed or made accurate for DevOps
- [ ] docs-protocol.md Handoff Notes description in Document Locations table includes `system-architect/`
- [ ] PM `role.md` docs-protocol path corrected to `experts/technical/shared/docs-protocol.md`

## Technical Notes

**Estimated effort:** Small session
**File(s):** `experts/technical/qa/skills/start.md`, `experts/technical/devops/skills/start.md`, `experts/technical/shared/docs-protocol.md`, `experts/technical/project-manager/role.md`
