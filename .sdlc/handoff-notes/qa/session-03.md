# Handoff Note: Review Cursor Implementation for Completeness and Consistency

**Issue:** qa-feature-039 — Review Cursor Implementation for Completeness and Consistency

## What Was Accomplished

Systematic fresh-eyes review of the complete Cursor platform-native implementation (M11). Reviewed all 37+ files in `targets/ide/cursor/`: 6 rules, 9 commands, 21 skills, 4 shell scripts (.sh + .ps1 pairs), 1 test script. Verified structural completeness against sa-feature-033 architecture design, M10 recommendation implementation, cross-expert consistency, and canonical file mapping. Filed 3 issues.

## Findings Summary
- **Must-fix:** 0 issues
- **Should-fix:** 2 issues
- **Nit:** 1 issue
- `issues/backlog/swe-bug-050.md` — PowerShell `next-session-number.ps1` missing atomic session claiming (sa-bug-048 parity gap)
- `issues/backlog/swe-bug-051.md` — Issue filename prefix convention inconsistent across skills (executor vs. finder prefix; `devops-` vs `ops-`)
- `issues/backlog/swe-techdebt-052.md` — Dead `count` variable in `update-issues-list.sh`

## Acceptance Criteria Status
- [x] All 5 expert rules are conditional (`alwaysApply: false`); only `project-os` is always-on
- [x] Each expert has the correct number of skills/commands/hooks matching the design from sa-feature-033
- [x] No skill relies on session protocol preamble for context loading — each has its own loading steps
- [x] Handoff hooks reference shell scripts for mechanical operations (session numbering, issue movement, etc.)
- [x] Shell scripts are present, executable, and handle empty-directory edge cases
- [x] No must-fix issues found, or must-fix issues filed in `issues/backlog/`
- [x] Findings recorded as issue files per QA review conventions

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|

None. Review-only session — no architectural or design decisions required.

## Problems Encountered

None. The scope was well-defined and the implementation was thoroughly documented through SWE handoff notes (sessions 17-21).

## Files Reviewed
- `targets/ide/cursor/rules/project-os.mdc` — always-applied router; correct structure, covers routing, conventions, principles
- `targets/ide/cursor/rules/project-manager-os.mdc` — conditional PM role; simplified per M10
- `targets/ide/cursor/rules/swe-os.mdc` — conditional SWE role; includes escalation principle
- `targets/ide/cursor/rules/qa-os.mdc` — conditional QA role; M10 Rec 4 fix applied (own handoff notes)
- `targets/ide/cursor/rules/devops-os.mdc` — conditional DevOps role; retains cross-expert handoffs per M10 scoping
- `targets/ide/cursor/rules/system-architect-os.mdc` — conditional SA role; scoped handoff loading
- `targets/ide/cursor/commands/pm-start.md` — 5-phase PM start with approval gates
- `targets/ide/cursor/commands/pm-interview.md` — 10-category interview with rules
- `targets/ide/cursor/commands/pm-add-feature.md` — adaptive complexity assessment
- `targets/ide/cursor/commands/swe-start.md` — 7-phase SWE start with architecture escalation
- `targets/ide/cursor/commands/qa-start.md` — 6-phase QA start with Verify phase (swe-bug-024 fix)
- `targets/ide/cursor/commands/ops-start.md` — 5-phase DevOps start
- `targets/ide/cursor/commands/ops-deploy.md` — 7-step safety-critical deployment
- `targets/ide/cursor/commands/ops-env-discovery.md` — 6-category environment interview
- `targets/ide/cursor/commands/sa-start.md` — 7-phase SA start with Research and Design phases
- `targets/ide/cursor/skills/pm-vision/SKILL.md` — project brief generation
- `targets/ide/cursor/skills/pm-roadmap/SKILL.md` — milestone planning
- `targets/ide/cursor/skills/pm-decompose/SKILL.md` — milestone decomposition with issue templates (naming inconsistency found here)
- `targets/ide/cursor/skills/pm-update-plan/SKILL.md` — surgical brief/roadmap updates
- `targets/ide/cursor/skills/pm-postmortem/SKILL.md` — cross-expert milestone retrospective
- `targets/ide/cursor/skills/pm-handoff/SKILL.md` — PM session handoff with atomic claiming
- `targets/ide/cursor/skills/swe-handoff/SKILL.md` — SWE session handoff with atomic claiming
- `targets/ide/cursor/skills/qa-handoff/SKILL.md` — QA session handoff with atomic claiming
- `targets/ide/cursor/skills/qa-review/SKILL.md` — code review with issue creation (naming inconsistency found here)
- `targets/ide/cursor/skills/qa-test-plan/SKILL.md` — test plan generation
- `targets/ide/cursor/skills/qa-regression/SKILL.md` — milestone regression check (naming inconsistency found here)
- `targets/ide/cursor/skills/qa-bug-triage/SKILL.md` — bug backlog prioritization
- `targets/ide/cursor/skills/ops-handoff/SKILL.md` — DevOps session handoff with atomic claiming
- `targets/ide/cursor/skills/ops-pipeline/SKILL.md` — pipeline design (naming inconsistency found here)
- `targets/ide/cursor/skills/ops-release-plan/SKILL.md` — release gates and rollback
- `targets/ide/cursor/skills/sa-handoff/SKILL.md` — SA session handoff with atomic claiming
- `targets/ide/cursor/skills/sa-design/SKILL.md` — initial architecture design
- `targets/ide/cursor/skills/sa-research/SKILL.md` — technical investigation
- `targets/ide/cursor/skills/sa-review/SKILL.md` — implementation vs. architecture review
- `targets/ide/cursor/skills/sa-update/SKILL.md` — architecture evolution
- `targets/ide/cursor/skills/team-status/SKILL.md` — roleless cross-workflow status (ADR-010)
- `targets/ide/cursor/scripts/next-issue-number.sh` — scans issues, outputs next 3-digit number
- `targets/ide/cursor/scripts/next-issue-number.ps1` — PowerShell equivalent, functional parity
- `targets/ide/cursor/scripts/next-session-number.sh` — atomic claiming with noclobber
- `targets/ide/cursor/scripts/next-session-number.ps1` — **missing atomic claiming** (swe-bug-050)
- `targets/ide/cursor/scripts/move-issue.sh` — issue file movement between status dirs
- `targets/ide/cursor/scripts/move-issue.ps1` — PowerShell equivalent, functional parity
- `targets/ide/cursor/scripts/update-issues-list.sh` — issues-list.md regeneration (dead variable, swe-techdebt-052)
- `targets/ide/cursor/scripts/update-issues-list.ps1` — PowerShell equivalent, no dead variable
- `docs/research-context-optimization.md` — M10 research (consumed for verification)

## What the Next Session Needs to Know

1. **The Cursor implementation is structurally sound.** No must-fix issues. The architecture design (sa-feature-033) was faithfully implemented. All M10 recommendations are correctly applied.

2. **Two should-fix issues before Claude Code work:**
   - swe-bug-050: Fix `next-session-number.ps1` atomic claiming. If Claude Code shares the same PS1 scripts, this should be fixed first.
   - swe-bug-051: Clarify and standardize the issue filename prefix convention. This affects how issues are named going forward across all experts.

3. **The existing test plan (`docs/test-plan.md`) covers M3-M5 only.** No formal test plan exists for M11. The 31-test script suite validates mechanical operations but not skill/command content.

4. **Cursor-side M11 tasks complete:** swe-feature-034 through swe-feature-038 all delivered. qa-feature-039 (this review) confirms the implementation. Next M11 work is Claude Code (swe-feature-040, swe-feature-041) or the remaining items (sync command, install update, final regression).

## Open Questions

None.
