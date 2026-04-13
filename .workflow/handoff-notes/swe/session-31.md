# Handoff Note: Data-Analyst Mixed Treatment + pm-add-feature Wording Fix

**Issues:** swe-bug-060, swe-bug-061

## What Was Accomplished

Fixed two QA-filed bugs from qa-session-06:

1. **swe-bug-060:** The data-analyst expert's `role.md` was left in a mixed state by the session-30 ad-hoc cleanup. Three skills (`brief`, `scope`, `synthesize`) still had `/` prefix, the section wasn't split into Commands/Skills, and cross-references in skill files were inconsistent. All fixed to match the pattern established for the 5 core experts.

2. **swe-bug-061:** `pm-add-feature.md` line 69 had a minor wording difference between Cursor and Claude Code. Claude Code version now matches Cursor exactly.

## Acceptance Criteria Status

### swe-bug-060
- [x] `role.md` has separate "## Commands" and "## Skills (agent-discoverable)" sections
- [x] Only `/intake` and `/start` have `/` prefix (commands)
- [x] `brief`, `scope`, `decompose`, `review`, `handoff`, `synthesize` listed without `/` (skills)
- [x] Skill file titles (`brief.md`, `scope.md`, `synthesize.md`) have `/` removed
- [x] Cross-references in all data-analyst skill files are consistent (commands keep `/`, skills don't)

### swe-bug-061
- [x] Line 69 is identical in both `targets/ide/cursor/commands/pm-add-feature.md` and `targets/ide/claude-code/commands/pm-add-feature.md`

## Decisions Made This Session

None. All changes were mechanical, following the pattern established in session-30.

## Problems Encountered

None.

## Scope Changes

None. Both bugs were small and well-defined.

## Files Created or Modified

| File | Change |
|------|--------|
| `experts/technical/data-analyst/role.md` | Split "## Skills" into "## Commands" + "## Skills (agent-discoverable)" |
| `experts/technical/data-analyst/skills/brief.md` | Title: `# /brief` → `# brief` |
| `experts/technical/data-analyst/skills/scope.md` | Title: `# /scope` → `# scope`; cross-ref: `/brief` → `brief` |
| `experts/technical/data-analyst/skills/synthesize.md` | Title: `# /synthesize` → `# synthesize` |
| `experts/technical/data-analyst/skills/intake.md` | Cross-ref: `/synthesize` → `synthesize` |
| `targets/ide/claude-code/commands/pm-add-feature.md` | Line 69 aligned with Cursor wording |

**Total: 6 files changed**

## What the Next Session Needs to Know

1. All QA-filed issues from qa-session-06 are now resolved (swe-bug-060, swe-bug-061).
2. The data-analyst expert is "under development" and has no platform-native target files (no files in `targets/ide/cursor/` or `targets/ide/claude-code/`). The fixes here are to the canonical source in `experts/technical/data-analyst/` only.
3. The remaining M11 work is the install script and sync command.
