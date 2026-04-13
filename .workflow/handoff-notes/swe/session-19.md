# Handoff Note: Create Cursor-Native PM Expert Skills

**Issue:** swe-feature-036 — Create Cursor-Native PM Expert Skills

## What Was Accomplished

Transformed all 10 PM canonical skill files into Cursor-native formats in `targets/ide/cursor/`. Created 3 commands (pm-start, pm-interview, pm-add-feature) and 7 discoverable skills (pm-vision, pm-roadmap, pm-decompose, pm-update-plan, pm-postmortem, pm-handoff, team-status). Each skill has YAML frontmatter with discovery-optimized descriptions, its own context loading, and references to `.cursor/scripts/` for mechanical operations.

## Acceptance Criteria Status

- [x] `interview` → Cursor command (requires heavy human interaction)
- [x] `add_feature` → Cursor command (requires human interaction for medium/large features)
- [x] `vision` → discoverable skill (autonomous with light review)
- [x] `roadmap` → discoverable skill (autonomous with light review)
- [x] `decompose` → discoverable skill (autonomous with light review)
- [x] `update_plan` → discoverable skill (autonomous with light review)
- [x] `postmortem` → discoverable skill (autonomous with light review)
- [x] `start` → hybrid command with approval gates at Phase 1 and 2
- [x] `handoff` → auto-trigger skill with trigger phrases in description
- [x] `status` → discoverable skill (fully autonomous, no human interaction)
- [x] All skills reference shell scripts from `.cursor/scripts/` for mechanical operations
- [x] Each skill has its own context loading steps

## Decisions Made This Session

| Decision | Reasoning |
|----------|-----------|
| Added System Architect to postmortem and team-status context loading | SA expert exists now but wasn't in the canonical files written before SA was created. Cross-workflow artifacts should include all active experts. |
| Added `docs/architecture.md` to team-status downstream artifacts check | Consistent with the artifact being a first-class project document that all experts should be aware of. |
| Skill descriptions follow "what + when" pattern | Per lessons log: descriptions answering both "what does this do?" and "when should the agent use it?" perform better for agent discovery. |

## Problems Encountered

None. The architecture design (sa-feature-033) was detailed enough, and the pattern established by swe-feature-035 (rules) and the existing `sa-start.md` command made implementation straightforward.

## Scope Changes

None. Task went exactly as planned — 3 commands + 7 skills, matching the architecture mapping table.

## Files Created or Modified

- `targets/ide/cursor/commands/pm-start.md` — PM start command (5 phases, approval gates)
- `targets/ide/cursor/commands/pm-interview.md` — New project interview command
- `targets/ide/cursor/commands/pm-add-feature.md` — Feature scoping command (adaptive complexity)
- `targets/ide/cursor/skills/pm-vision/SKILL.md` — Generate project brief from interview notes
- `targets/ide/cursor/skills/pm-roadmap/SKILL.md` — Create milestone plan
- `targets/ide/cursor/skills/pm-decompose/SKILL.md` — Break milestone into issue files
- `targets/ide/cursor/skills/pm-update-plan/SKILL.md` — Integrate new feature into brief/roadmap
- `targets/ide/cursor/skills/pm-postmortem/SKILL.md` — Milestone retrospective
- `targets/ide/cursor/skills/pm-handoff/SKILL.md` — Session handoff with auto-trigger
- `targets/ide/cursor/skills/team-status/SKILL.md` — Cross-workflow health summary (roleless per ADR-010)

## What the Next Session Needs to Know

1. **PM expert is complete for Cursor.** All 10 skills converted. The pattern is established for the remaining experts (SWE, QA, DevOps, SA).
2. **Remaining experts are simpler.** SWE has only 2 skills (start, handoff). QA has 6. DevOps has 6. SA has 6. The PM was the largest with 10.
3. **team-status is done.** It's a shared/team skill, not PM-specific. No need to create it again in other expert tasks.
4. **Script references are consistent.** `pm-decompose` uses `next-issue-number.sh` and `update-issues-list.sh`. `pm-handoff` uses `next-session-number.sh`, `move-issue.sh`, and `update-issues-list.sh`. Same scripts will be referenced by other experts' decompose/handoff equivalents.
5. **The `.gitkeep` files in `commands/` and `skills/` can be cleaned up** now that real files exist, but they're harmless if left.

## Open Questions

None.
