# Handoff Note: Create Claude Code QA, DevOps, and System Architect Expert Skills

**Issue:** swe-feature-041 — Create Claude Code QA, DevOps, and System Architect Expert Skills

## What Was Accomplished

Created all QA, DevOps, and System Architect expert files for the Claude Code platform implementation in `targets/ide/claude-code/`. 21 files total: 3 role files, 5 commands, and 13 skills. All adapted from the QA-reviewed Cursor implementation with script paths changed to `.claude/scripts/` and role files converted to plain markdown (no Cursor `.mdc` frontmatter).

## Acceptance Criteria Status
- [x] QA expert: start (command), handoff (skill), review (skill), test-plan (skill), regression (skill), bug-triage (skill)
- [x] DevOps expert: start (command), handoff (skill), env-discovery (command), pipeline (skill), release-plan (skill), deploy (command)
- [x] SA expert: start (command), handoff (skill), design (skill), research (skill), review (skill), update (skill)
- [x] All skills reference shell scripts from Claude Code scripts directory (`.claude/scripts/`)
- [x] Each skill has its own context loading steps
- [x] Safety-critical commands (deploy) maintain explicit approval gates
- [x] Interview-style commands (env-discovery) remain explicit
- [x] Consistent format across all 3 experts — same patterns as PM and SWE from swe-feature-040

## Decisions Made This Session

| Decision | Reasoning |
|----------|-----------|
| No decisions beyond planned adaptation | Straight conversion from QA-reviewed Cursor files; no new architectural decisions needed. |

## Problems Encountered

None. All 21 files were mechanical adaptations with no surprises.

## Scope Changes

None. Task went exactly as planned.

## Files Created or Modified

- `targets/ide/claude-code/roles/qa.md` — QA role definition
- `targets/ide/claude-code/roles/devops.md` — DevOps role definition
- `targets/ide/claude-code/roles/system-architect.md` — SA role definition
- `targets/ide/claude-code/commands/qa-start.md` — QA start command (6 phases)
- `targets/ide/claude-code/commands/ops-start.md` — DevOps start command (5 phases)
- `targets/ide/claude-code/commands/sa-start.md` — SA start command (7 phases)
- `targets/ide/claude-code/commands/ops-deploy.md` — deploy command (interactive, 7 steps)
- `targets/ide/claude-code/commands/ops-env-discovery.md` — env discovery command (interactive, 3 steps)
- `targets/ide/claude-code/skills/qa-handoff/SKILL.md` — QA session handoff
- `targets/ide/claude-code/skills/qa-review/SKILL.md` — fresh-eyes code review
- `targets/ide/claude-code/skills/qa-test-plan/SKILL.md` — test plan generation
- `targets/ide/claude-code/skills/qa-regression/SKILL.md` — milestone regression check
- `targets/ide/claude-code/skills/qa-bug-triage/SKILL.md` — bug backlog triage
- `targets/ide/claude-code/skills/ops-handoff/SKILL.md` — DevOps session handoff
- `targets/ide/claude-code/skills/ops-pipeline/SKILL.md` — pipeline definition
- `targets/ide/claude-code/skills/ops-release-plan/SKILL.md` — release gates and rollback
- `targets/ide/claude-code/skills/sa-handoff/SKILL.md` — SA session handoff
- `targets/ide/claude-code/skills/sa-design/SKILL.md` — system architecture creation
- `targets/ide/claude-code/skills/sa-research/SKILL.md` — technical research with recommendation
- `targets/ide/claude-code/skills/sa-review/SKILL.md` — architecture conformance review
- `targets/ide/claude-code/skills/sa-update/SKILL.md` — architecture evolution

## What the Next Session Needs to Know

1. **Claude Code implementation is now complete for all 5 core experts** (PM, SWE, QA, DevOps, SA). Combined with swe-feature-040, the full set is: 5 roles, 9 commands, 21 skills.
2. **`team-status` skill is missing from Claude Code.** It exists in Cursor (`targets/ide/cursor/skills/team-status/SKILL.md`) but was not included in swe-feature-040 or swe-feature-041 acceptance criteria. Session-23 flagged it for this session, but it's not in the issue's scope. Needs a follow-up task or can be added during a QA review fix cycle.
3. **No install script or sync command exists yet.** Both are listed as out of scope for these feature tasks.
4. **The Cursor implementation has been QA-reviewed** (qa-feature-039). The Claude Code files are direct adaptations, so the same content quality applies.

## Open Questions

- [ ] Should `team-status` be filed as a separate issue or added during the next available session?
