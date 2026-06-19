# TECHDEBT: Workflow accelerators still called milestone.js / documentation.js in ~9 docs

**Type:** techdebt
**Expert:** doc
**Status:** backlog
**Severity:** should-fix

## Description

The on-disk scripts are `agents/workflows/implement.js` and `agents/workflows/document.js` (Workflow names implement / document), but the older names `milestone.js` / `documentation.js` persist across the prose. Rename references repo-wide to match disk.

## Acceptance Criteria

- [ ] All references to `milestone.js` renamed to `implement.js` (and the workflow name to "implement")
- [ ] All references to `documentation.js` renamed to `document.js` (and the workflow name to "document")
- [ ] The following files are corrected: `README.md`, `docs/architecture.md`, `docs/project-brief.md`, `docs/roadmap.md`, `docs/documentation-plan.md`, `agents/roles/technical-writer.md`, `agents/skills/team-milestone/SKILL.md`, `agents/skills/team-docs/SKILL.md`

## Notes

**Found by:** Documentation review — surfaced across all four guide reviews.
**Files:** `README.md`, `docs/architecture.md`, `docs/project-brief.md`, `docs/roadmap.md`, `docs/documentation-plan.md`, `agents/roles/technical-writer.md`, `agents/skills/team-milestone/SKILL.md`, `agents/skills/team-docs/SKILL.md`
