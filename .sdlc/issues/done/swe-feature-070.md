# Update Claude Code Skills for .workflow Paths

**Type:** feature
**Expert:** swe
**Milestone:** [Workflow Directory] Update structure and references (M13)
**Status:** backlog

## User Story

As a developer using Claude Code, I need all expert skills to reference `.sdlc/` paths, so that skill execution reads and writes managed artifacts to the correct location.

## Description

Update all SKILL.md files in `targets/ide/claude-code/skills/` to replace old path references with `.sdlc/` equivalents. This covers ~17 skill files across PM, SWE, QA, DevOps, SA, and team-status skills.

## Acceptance Criteria

- [ ] PM skills (pm-decompose, pm-handoff, pm-postmortem, pm-update-plan, pm-vision) reference `.sdlc/` for handoff notes, interview notes, issues, and lessons-log
- [ ] SWE skill (swe-handoff) references `.sdlc/` for handoff notes, issues, and lessons-log
- [ ] QA skills (qa-bug-triage, qa-handoff, qa-regression, qa-review, qa-test-plan) reference `.sdlc/` for handoff notes, issues, and lessons-log
- [ ] DevOps skills (ops-handoff, ops-pipeline, ops-release-plan) reference `.sdlc/` for handoff notes, issues, and lessons-log
- [ ] SA skills (sa-design, sa-handoff, sa-review) reference `.sdlc/` for handoff notes, interview notes, issues, and lessons-log
- [ ] team-status skill references `.sdlc/` for issues and handoff notes
- [ ] `grep -r 'docs/handoff-notes\|docs/lessons-log\|docs/interview-notes\|issues/' targets/ide/claude-code/skills/` returns zero matches

## Technical Notes

**Estimated effort:** Medium session (17 files, mechanical changes)
**Dependencies:** sa-feature-063, swe-feature-066 (use Cursor skills as reference for consistency)
**Inputs:** `docs/project-brief.md`, sa-feature-063 path mapping, `targets/ide/claude-code/skills/`
**Out of scope:** Rules, commands, and scripts

## Session 37 Summary

**What was done:** Updated all 18 SKILL.md files in `targets/ide/claude-code/skills/` to replace `docs/handoff-notes/`, `docs/lessons-log.md`, `docs/interview-notes`, and `issues/` paths with `.sdlc/` equivalents. Verified zero stale references via grep.
**Handoff note:** `docs/handoff-notes/swe/session-37.md`
**All acceptance criteria met:** Yes
