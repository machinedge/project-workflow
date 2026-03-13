# Update Documentation References and Remove CLAUDE.md

**Type:** feature
**Expert:** swe
**Milestone:** M7
**Status:** backlog

## User Story

As a toolkit developer, I need the documentation to reflect the new directory structure so that I can navigate the repo and understand the layout without encountering stale references to `framework/` and `package/`.

## Description

Update every documentation file that references old `framework/` or `package/` paths. Remove `CLAUDE.md` (redundant with project brief + expert roles + agent-reference.md). Update the project brief, agent-reference.md, SKILL.md, docs-protocol, and any other docs with the new structure. Ensure the repo guide content from `CLAUDE.md` is preserved where appropriate (agent-reference.md).

## Acceptance Criteria

- [ ] `CLAUDE.md` is deleted from the repo root
- [ ] `framework/docs/agent-reference.md` (at its new path) reflects the new directory layout
- [ ] `package/SKILL.md` (at its new path) reflects the new structure
- [ ] `experts/technical/shared/docs-protocol.md` has no stale path references
- [ ] `docs/project-brief.md` "Notes for AI" section is updated (no reference to `CLAUDE.md`)
- [ ] `docs/overview.md`, `docs/getting-started.md`, `docs/workflow-anatomy.md` are updated if they reference old paths
- [ ] No documentation file in the repo contains references to old `framework/` or `package/` paths (search and verify)
- [ ] Essential repo-guide content from `CLAUDE.md` is preserved in agent-reference.md or equivalent

## Session 08 Summary

**What was done:** Updated all documentation files to reference new `targets/` and `tools/` layout, deleted `CLAUDE.md`, preserved essential content in `docs/agent-reference.md`, and updated `package.sh`/`package.ps1` to match SKILL.md's new path references.
**Handoff note:** `docs/handoff-notes/swe/session-08.md`
**All acceptance criteria met:** Yes

## Technical Notes

**Estimated effort:** Medium session
**Dependencies:** swe-feature-015 (scripts must be finalized so docs reference correct final paths)
**Inputs:** project brief (`docs/project-brief.md`), `CLAUDE.md`, `docs/architecture.md`, all docs files
**Out of scope:** Changing expert role files or skill definitions. Don't modify any script logic — only documentation content.
