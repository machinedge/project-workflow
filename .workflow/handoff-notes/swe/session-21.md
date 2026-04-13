# Handoff Note: Create Cursor-Native DevOps and System Architect Expert Skills

**Issue:** swe-feature-038 — Create Cursor-Native DevOps and System Architect Expert Skills

## What Was Accomplished

Transformed all 12 canonical skill files (6 DevOps, 6 SA) into Cursor-native formats in `targets/ide/cursor/`. Created 4 commands (ops-start, ops-deploy, ops-env-discovery, sa-start) and 8 discoverable skills (ops-pipeline, ops-release-plan, ops-handoff, sa-design, sa-research, sa-review, sa-update, sa-handoff). Each skill has YAML frontmatter with discovery-optimized descriptions, its own context loading, and references to `.cursor/scripts/` for mechanical operations.

Additionally, discovered a concurrency bug where this session and the swe-feature-037 session both computed session-20 as the next handoff number, resulting in 037's handoff note being silently overwritten. Filed `sa-bug-048` to address session numbering and project brief race conditions.

## Acceptance Criteria Status

- [x] DevOps `start` → hybrid command with approval gates (5 phases)
- [x] DevOps `handoff` → auto-trigger skill with trigger phrases in description
- [x] DevOps `env-discovery` → Cursor command (structured interview, heavy human interaction)
- [x] DevOps `pipeline` → discoverable skill (design from env-context, user reviews)
- [x] DevOps `release-plan` → discoverable skill (produce plan, user reviews)
- [x] DevOps `deploy` → Cursor command (safety-critical — 7 steps with multiple approval gates)
- [x] SA `start` → hybrid command with approval gates (7 phases)
- [x] SA `handoff` → auto-trigger skill with trigger phrases in description
- [x] SA `design` → discoverable skill (analytical design with user trade-off decisions)
- [x] SA `research` → discoverable skill (autonomous investigation, user decides on recommendation)
- [x] SA `review` → discoverable skill (autonomous architectural review)
- [x] SA `update` → discoverable skill (user must approve architectural changes)
- [x] All skills reference shell scripts from `.cursor/scripts/` for mechanical operations
- [x] Each skill has its own context loading steps

## Decisions Made This Session

| Decision | Reasoning |
|----------|-----------|
| Skill descriptions follow "what + when" pattern | Per lessons log: descriptions answering both "what does this do?" and "when should the agent use it?" perform better for agent discovery. |
| SA handoff uses `system-architect` as expert name arg to `next-session-number.sh` | Matches the handoff notes directory name `docs/handoff-notes/system-architect/`. |
| DevOps handoff uses `devops` as expert name arg | Matches the handoff notes directory name `docs/handoff-notes/devops/`. |
| Concurrency bug filed as `sa-bug-048` (system-architect scope) | Session numbering and project brief overwrites are architectural design concerns, not implementation bugs in a specific skill. |

## Problems Encountered

Concurrent session collision: this session and swe-feature-037 both ran in parallel and both computed session-20 as the next handoff number. swe-feature-037's handoff note was silently overwritten by this session's `session-20.md`. The project brief "Last updated" field also skipped 037. Filed `sa-bug-048` with possible approaches (atomic numbering, check-before-write, append-only updates).

This handoff is written as session-21 to avoid further collision with the existing session-20.

## Scope Changes

Added: discovery and filing of concurrency bug `sa-bug-048`. Not in the original task scope but directly observed during handoff.

## Files Created or Modified

- `targets/ide/cursor/commands/ops-start.md` — DevOps start command (5 phases, approval gates)
- `targets/ide/cursor/commands/ops-deploy.md` — Safety-critical deployment command (7 steps, multiple confirmation points)
- `targets/ide/cursor/commands/ops-env-discovery.md` — Environment context interview command
- `targets/ide/cursor/commands/sa-start.md` — SA start command (7 phases, approval gates)
- `targets/ide/cursor/skills/ops-pipeline/SKILL.md` — Pipeline design from env-context
- `targets/ide/cursor/skills/ops-release-plan/SKILL.md` — Release gates and rollback procedures
- `targets/ide/cursor/skills/ops-handoff/SKILL.md` — DevOps session handoff with auto-trigger
- `targets/ide/cursor/skills/sa-design/SKILL.md` — Initial system architecture design
- `targets/ide/cursor/skills/sa-research/SKILL.md` — Technical investigation with recommendation
- `targets/ide/cursor/skills/sa-review/SKILL.md` — Implementation vs. architectural intent review
- `targets/ide/cursor/skills/sa-update/SKILL.md` — Evolve architecture from feedback
- `targets/ide/cursor/skills/sa-handoff/SKILL.md` — SA session handoff with auto-trigger
- `issues/backlog/sa-bug-048.md` — Concurrency bug for session numbering and project brief overwrites

## What the Next Session Needs to Know

1. **DevOps and SA experts are complete for Cursor.** All 12 skills converted (4 commands + 8 skills).
2. **All five experts now have Cursor-native skills.** PM (swe-feature-036: 3 commands + 7 skills), DevOps (this session: 3 commands + 3 skills), SA (this session: 1 command + 5 skills). SWE and QA were handled by swe-feature-037.
3. **team-status was already created** during swe-feature-036. No duplication needed.
4. **Script references are consistent.** `ops-handoff` and `sa-handoff` use `next-session-number.sh`, `move-issue.sh`, and `update-issues-list.sh`. `ops-pipeline`, `ops-deploy`, and `sa-review` use `next-issue-number.sh` and `update-issues-list.sh` for issue creation.
5. **The `sa-start.md` in `.cursor/commands/`** (installed location) predates this work. The new one in `targets/ide/cursor/commands/` is the toolkit source with proper prefix updates (`/sa-research`, `/sa-handoff`).
6. **session-20.md contains this session's (038) content**, not swe-feature-037's. The 037 handoff note was lost due to a concurrent session collision. `sa-bug-048` filed to address the underlying design issue.
7. **sa-bug-048** is an architecture-scoped bug about concurrent session safety. Needs SA to design a solution before SWE implements.

## Open Questions

None.
