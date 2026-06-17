# Handoff Note: Create Claude Code Rules, Project Structure, PM and SWE Expert Skills

**Issue:** swe-feature-040 — Create Claude Code Rules, Project Structure, PM and SWE Expert Skills

## What Was Accomplished

Created the Claude Code platform-native implementation in `targets/ide/claude-code/`. Set up `CLAUDE.md` (shared principles + expert routing), `settings.json` (SessionStart hook), `session-primer.sh` (raw context extractor per ADR-009), PM and SWE role files, 4 commands (pm-start, pm-interview, pm-add-feature, swe-start), and 7 skills (pm-vision, pm-roadmap, pm-decompose, pm-update-plan, pm-postmortem, pm-handoff, swe-handoff). All adapted from the QA-reviewed Cursor implementation with script paths changed to `.claude/scripts/` and role files converted to plain markdown (no YAML frontmatter).

## Acceptance Criteria Status
- [x] `targets/ide/claude-code/` directory structure matches the design from sa-feature-033
- [x] Claude Code rules structure created with conditional expert loading
- [x] M10 recommendations applied (conditional roles, scoped handoffs, QA bug fix, doc loading in skills)
- [x] PM expert: all 10 skills mapped (3 commands + 6 skills + role) in Claude Code format
- [x] SWE expert: start (command) + handoff (skill) + role in Claude Code format
- [x] Shell scripts present in `targets/ide/claude-code/scripts/` (pre-existing from swe-feature-034)
- [x] `settings.json` created with `SessionStart` hook referencing `.claude/scripts/session-primer.sh`
- [x] `session-primer.sh` created — raw content extractor (project identity, current status, most recent handoff), not a summarizer
- [x] All skills reference shell scripts for mechanical operations
- [x] Each skill has its own context loading steps
- [x] docs-protocol content integrated appropriately (executor prefix convention, `devops-` convention in CLAUDE.md)

## Decisions Made This Session

| Decision | Reasoning |
|----------|-----------|
| No decisions beyond planned adaptation | Straight conversion from QA-reviewed Cursor files; no new architectural decisions needed. |

## Problems Encountered

Initial `session-primer.sh` had two bugs found during verification: (1) piping to the `append` function ran it in a subshell, losing accumulated output; (2) the sed pattern for extracting the Current Status section printed the `## Current Status` header twice. Fixed by using process substitution (`< <(...)`) instead of pipes, and simplifying the sed expression.

## Scope Changes

None. Task went exactly as planned — 16 new files matching the architecture spec.

## Files Created or Modified
- `targets/ide/claude-code/CLAUDE.md` — shared principles + expert routing (always loaded)
- `targets/ide/claude-code/settings.json` — SessionStart hook definition
- `targets/ide/claude-code/scripts/session-primer.sh` — raw project context extractor
- `targets/ide/claude-code/roles/project-manager.md` — PM role definition
- `targets/ide/claude-code/roles/swe.md` — SWE role definition
- `targets/ide/claude-code/commands/pm-start.md` — PM start command (5 phases)
- `targets/ide/claude-code/commands/pm-interview.md` — PM interview command (interactive)
- `targets/ide/claude-code/commands/pm-add-feature.md` — PM add-feature command (interactive, adaptive)
- `targets/ide/claude-code/commands/swe-start.md` — SWE start command (7 phases)
- `targets/ide/claude-code/skills/pm-vision/SKILL.md` — generate project brief from interview notes
- `targets/ide/claude-code/skills/pm-roadmap/SKILL.md` — create milestone plan
- `targets/ide/claude-code/skills/pm-decompose/SKILL.md` — break milestone into task issues
- `targets/ide/claude-code/skills/pm-update-plan/SKILL.md` — update brief and roadmap with new feature
- `targets/ide/claude-code/skills/pm-postmortem/SKILL.md` — milestone post-mortem analysis
- `targets/ide/claude-code/skills/pm-handoff/SKILL.md` — PM session handoff
- `targets/ide/claude-code/skills/swe-handoff/SKILL.md` — SWE session handoff

## What the Next Session Needs to Know

1. **PM and SWE experts are complete for Claude Code.** 16 files created: CLAUDE.md, settings.json, session-primer.sh, 2 roles, 4 commands, 7 skills.
2. **swe-feature-041 is next** — QA, DevOps, and System Architect experts for Claude Code. Same adaptation pattern: read Cursor files, change script paths to `.claude/scripts/`, convert role files to plain markdown, create skills and commands.
3. **The Cursor implementation is the source of truth for content.** Session-22 bug fixes (executor prefix, `devops-` convention) were applied to Cursor but the Claude Code files created this session already incorporate those conventions.
4. **session-primer.sh is tested and working.** Extracts project brief top 20 lines, Current Status section, and most recent handoff note. Caps output at 120 lines.
5. **team-status skill was NOT created** — it's a shared skill, not PM or SWE scoped. It should be created in swe-feature-041 alongside the remaining experts.

## Open Questions

None.
