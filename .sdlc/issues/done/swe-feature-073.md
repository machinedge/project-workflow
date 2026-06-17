# Update agent-reference.md and READMEs for .workflow Paths

**Type:** feature
**Expert:** swe
**Milestone:** [Workflow Directory] Update structure and references (M13)
**Status:** backlog

## User Story

As a developer reading the project documentation, I need `agent-reference.md` and the platform READMEs to reflect the `.sdlc/` directory structure, so that documentation matches the actual file layout.

## Description

Update `docs/agent-reference.md`, `targets/ide/cursor/README.md`, and `targets/ide/claude-code/README.md` to replace old path references with `.sdlc/` equivalents. Update any directory tree diagrams to show the new structure.

## Acceptance Criteria

- [ ] `docs/agent-reference.md` repo tree diagram shows `.sdlc/` instead of `issues/` and `docs/handoff-notes/`
- [ ] `docs/agent-reference.md` document contracts table references `.sdlc/` paths
- [ ] `docs/agent-reference.md` "In-Repo Issue Tracking" section references `.sdlc/issues/`
- [ ] `targets/ide/cursor/README.md` references `.sdlc/` for managed artifacts
- [ ] `targets/ide/claude-code/README.md` references `.sdlc/` for managed artifacts
- [ ] `grep -r 'docs/handoff-notes\|issues/' docs/agent-reference.md targets/ide/cursor/README.md targets/ide/claude-code/README.md` returns zero matches for old paths

## Technical Notes

**Estimated effort:** Small session
**Dependencies:** sa-feature-063
**Inputs:** `docs/project-brief.md`, sa-feature-063 path mapping, `docs/agent-reference.md`, `targets/ide/cursor/README.md`, `targets/ide/claude-code/README.md`
**Out of scope:** Source code files (rules, skills, scripts, commands)

## Session 40 Summary

**What was done:** Updated all three documentation files (agent-reference.md, Cursor README, Claude Code README) to replace stale `docs/handoff-notes/`, `docs/lessons-log.md`, and `issues/` references with `.sdlc/` equivalents.
**Handoff note:** `docs/handoff-notes/swe/session-40.md`
**All acceptance criteria met:** Yes
