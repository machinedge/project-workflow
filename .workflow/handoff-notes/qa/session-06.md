# Handoff Note: Commands vs Skills Slash Prefix Cleanup Review

**Issue:** qa-feature-059 — QA Review: Commands vs Skills Slash Prefix Cleanup

## What Was Accomplished

Reviewed the 79-file ad-hoc cleanup from SWE session-30 that separated 9 commands (slash-invocable, keep `/`) from 21 skills (agent-discoverable, no `/`) across both Cursor and Claude Code target implementations, source expert definitions, command files, SKILL.md files, and READMEs. Filed 2 issues.

## Findings Summary
- **Must-fix:** 0 issues
- **Should-fix:** 1 issue
- **Nit:** 1 issue
- `issues/backlog/swe-bug-060.md` — Data-analyst role.md has mixed command/skill treatment (should-fix)
- `issues/backlog/swe-bug-061.md` — pm-add-feature.md wording inconsistency between Cursor and Claude Code (nit)

## Acceptance Criteria Status
- [x] All 9 commands correctly listed with `/` prefix across all role/rules files (both platforms + source)
- [x] All 21 skills correctly listed without `/` prefix across all role/rules files (both platforms + source)
- [x] Cross-references in command files correctly distinguish commands (keep `/`) from skills (no `/`)
- [x] Cross-references in SKILL.md files correctly distinguish commands from skills
- [x] Cursor and Claude Code implementations are consistent with each other (1 nit filed: swe-bug-061)
- [ ] Data-analyst source files are consistent (no mixed treatment) — FAIL (swe-bug-060 filed: `brief`, `scope`, `synthesize` still have `/` prefix; section not split into Commands/Skills)
- [x] No broken markdown formatting
- [x] READMEs accurately describe the commands vs skills distinction

## Decisions Made This Session

None. Review-only session — no architectural or design decisions required.

## Problems Encountered

None. All files were accessible and the review was straightforward.

## Files Reviewed

### Cursor target rules (6 files)
- `targets/ide/cursor/rules/project-os.mdc` — Skills convention section accurate
- `targets/ide/cursor/rules/{project-manager,swe,qa,devops,system-architect}-os.mdc` — all correctly split into Commands/Skills sections

### Claude Code target roles (6 files)
- `targets/ide/claude-code/CLAUDE.md` — Skills convention section accurate, matches Cursor
- `targets/ide/claude-code/roles/{project-manager,swe,qa,devops,system-architect}.md` — all correctly split, content-identical to Cursor (path differences only)

### Source expert roles (5 files)
- `experts/technical/{project-manager,swe,qa,devops,system-architect}/role.md` — all correctly split with generic (unprefixed) names

### Command files (18 files)
- `targets/ide/{cursor,claude-code}/commands/{pm,swe,qa,ops,sa}-start.md` — handoff skill references correctly use no `/`
- `targets/ide/{cursor,claude-code}/commands/{pm-interview,pm-add-feature,ops-env-discovery,ops-deploy}.md` — all cross-refs correct; 1 nit (pm-add-feature.md line 69 wording)

### SKILL.md files (42 files)
- All 21 Cursor + 21 Claude Code SKILL.md files — command references correctly keep `/`; skill cross-references correctly drop `/`; script paths use correct platform prefix

### Data-analyst source files (6 files)
- `experts/technical/data-analyst/role.md` — mixed treatment (swe-bug-060)
- `experts/technical/data-analyst/skills/{intake,brief,scope,synthesize,handoff}.md` — inconsistent cross-refs (swe-bug-060)

### READMEs (4 files)
- `README.md` — commands vs skills distinction accurate
- `targets/ide/cursor/README.md` — accurate (pre-existing `alwaysApply: true` error noted, out of scope)
- `targets/ide/claude-code/README.md` — accurate
- `targets/desktop-cli/claude/SKILL.md` — expert table correctly split into Commands and Agent Skills columns

## What the Next Session Needs to Know

1. **swe-bug-060 (data-analyst mixed treatment) is the only real finding.** The 5 core experts are fully consistent across both platforms. The data-analyst is under development and out of M11 scope, so this is a should-fix, not a blocker.

2. **swe-bug-061 (pm-add-feature wording) is a nit.** One-word difference on line 69 between platforms. Correct classification in both — just wording alignment.

3. **Pre-existing observation (not filed):** Cursor README line 88 incorrectly says expert role rules are `alwaysApply: true` when the actual `.mdc` files have `alwaysApply: false`. This predates session-30 and is outside the scope of this review. It should be addressed separately.

4. **The session-30 cleanup was high-quality.** 79 files changed with only 1 real inconsistency (in an out-of-scope expert). The core 5 experts across both platforms, all command files, all SKILL.md files, and all READMEs are correct.

## Open Questions

None.
