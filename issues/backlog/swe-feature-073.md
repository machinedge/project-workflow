# Update agent-reference.md and READMEs for .workflow Paths

**Type:** feature
**Expert:** swe
**Milestone:** [Workflow Directory] Update structure and references (M13)
**Status:** backlog

## User Story

As a developer reading the project documentation, I need `agent-reference.md` and the platform READMEs to reflect the `.workflow/` directory structure, so that documentation matches the actual file layout.

## Description

Update `docs/agent-reference.md`, `targets/ide/cursor/README.md`, and `targets/ide/claude-code/README.md` to replace old path references with `.workflow/` equivalents. Update any directory tree diagrams to show the new structure.

## Acceptance Criteria

- [ ] `docs/agent-reference.md` repo tree diagram shows `.workflow/` instead of `issues/` and `docs/handoff-notes/`
- [ ] `docs/agent-reference.md` document contracts table references `.workflow/` paths
- [ ] `docs/agent-reference.md` "In-Repo Issue Tracking" section references `.workflow/issues/`
- [ ] `targets/ide/cursor/README.md` references `.workflow/` for managed artifacts
- [ ] `targets/ide/claude-code/README.md` references `.workflow/` for managed artifacts
- [ ] `grep -r 'docs/handoff-notes\|issues/' docs/agent-reference.md targets/ide/cursor/README.md targets/ide/claude-code/README.md` returns zero matches for old paths

## Technical Notes

**Estimated effort:** Small session
**Dependencies:** sa-feature-063
**Inputs:** `docs/project-brief.md`, sa-feature-063 path mapping, `docs/agent-reference.md`, `targets/ide/cursor/README.md`, `targets/ide/claude-code/README.md`
**Out of scope:** Source code files (rules, skills, scripts, commands)
