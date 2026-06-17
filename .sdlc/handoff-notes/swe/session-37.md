# Handoff Note: Update Skills for .workflow Paths

**Issue:** swe-feature-066 — Update Cursor Skills for .workflow Paths
**Issue:** swe-feature-070 — Update Claude Code Skills for .workflow Paths

## What Was Accomplished

Updated all 36 SKILL.md files (18 per platform) in `targets/ide/cursor/skills/` and `targets/ide/claude-code/skills/` to replace old artifact paths with `.sdlc/` equivalents per ADR-011. This completes step 3 (skills) of the M13 implementation order for both platforms.

## Acceptance Criteria Status

### swe-feature-066 (Cursor)
- [x] PM skills (pm-decompose, pm-handoff, pm-postmortem, pm-update-plan, pm-vision) reference `.sdlc/` for handoff notes, interview notes, issues, and lessons-log
- [x] SWE skill (swe-handoff) references `.sdlc/` for handoff notes, issues, and lessons-log
- [x] QA skills (qa-bug-triage, qa-handoff, qa-regression, qa-review, qa-test-plan) reference `.sdlc/` for handoff notes, issues, and lessons-log
- [x] DevOps skills (ops-handoff, ops-pipeline, ops-release-plan) reference `.sdlc/` for handoff notes, issues, and lessons-log
- [x] SA skills (sa-design, sa-handoff, sa-review) reference `.sdlc/` for handoff notes, interview notes, issues, and lessons-log
- [x] team-status skill references `.sdlc/` for issues and handoff notes
- [x] grep confirms zero stale references in `targets/ide/cursor/skills/`

### swe-feature-070 (Claude Code)
- [x] PM skills (pm-decompose, pm-handoff, pm-postmortem, pm-update-plan, pm-vision) reference `.sdlc/` for handoff notes, interview notes, issues, and lessons-log
- [x] SWE skill (swe-handoff) references `.sdlc/` for handoff notes, issues, and lessons-log
- [x] QA skills (qa-bug-triage, qa-handoff, qa-regression, qa-review, qa-test-plan) reference `.sdlc/` for handoff notes, issues, and lessons-log
- [x] DevOps skills (ops-handoff, ops-pipeline, ops-release-plan) reference `.sdlc/` for handoff notes, issues, and lessons-log
- [x] SA skills (sa-design, sa-handoff, sa-review) reference `.sdlc/` for handoff notes, interview notes, issues, and lessons-log
- [x] team-status skill references `.sdlc/` for issues and handoff notes
- [x] grep confirms zero stale references in `targets/ide/claude-code/skills/`

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|
| None | Purely mechanical path replacement per ADR-011, mirroring sessions 34-36 |

## Problems Encountered
None.

## Scope Changes
None — executed exactly as scoped. 3 files per platform required no changes (pm-roadmap, sa-research, sa-update) because they only reference `docs/` files that stay in place.

## Files Created or Modified
- `targets/ide/cursor/skills/*/SKILL.md` — 18 files updated (pm-decompose, pm-handoff, pm-postmortem, pm-update-plan, pm-vision, swe-handoff, qa-bug-triage, qa-handoff, qa-regression, qa-review, qa-test-plan, ops-handoff, ops-pipeline, ops-release-plan, sa-design, sa-handoff, sa-review, team-status)
- `targets/ide/claude-code/skills/*/SKILL.md` — 18 files updated (same set)

## What the Next Session Needs to Know
Steps 1 (conventions/roles), 2 (commands), and 3 (skills) are now complete for both Cursor and Claude Code. The remaining M13 steps in order:
1. ~~Update conventions (rules/roles)~~ — done (064 Cursor + 068 Claude Code)
2. ~~Update commands~~ — done (065 Cursor + 069 Claude Code)
3. ~~Update skills~~ — done (066 Cursor + 070 Claude Code)
4. Update scripts — shell/PowerShell (067 Cursor, 071 Claude Code)
5. Update install scripts (072)
6. Update docs and READMEs (073)
7. Reinstall and verify (074)

## Open Questions
- [ ] None
