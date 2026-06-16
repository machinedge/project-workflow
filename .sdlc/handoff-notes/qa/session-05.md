# Handoff Note: Cross-Platform Regression and Install Verification

**Issue:** qa-feature-045 — Cross-Platform Regression and Install Verification

## What Was Accomplished

Final M11 regression covering both Cursor and Claude Code platform-native implementations. Tested: fresh install into clean projects, installed structure verification against architecture spec, sync command operation, shell script execution in installed context, settings.json merge, project brief success criteria walkthrough, document memory model regression, and README accuracy. Filed 3 issues.

## Findings Summary
- **Must-fix:** 1 issue
- **Should-fix:** 2 issues
- **Nit:** 0 issues
- `issues/backlog/swe-bug-056.md` — Install script creates `docs/handoff-notes/project-manager/` but all PM artifacts reference `docs/handoff-notes/pm/`
- `issues/backlog/swe-bug-057.md` — `update-brief-status` script missing from install cleanup section and both platform READMEs
- `issues/backlog/swe-bug-058.md` — Sync check command flags `.gitkeep` and `test-*` files as MISSING (false positives from intentional install exclusions)

## Acceptance Criteria Status
- [x] Cursor install produces a working project structure with rules, skills, tools, and hooks in correct locations — 6 rules, 9 commands, 21 skills, 10 scripts
- [x] Claude Code install produces a working project structure with rules, skills, tools in correct locations — CLAUDE.md, settings.json, 5 roles, 9 commands, 21 skills, 11 scripts
- [x] Sync command reports 0 differences between fresh Cursor and Claude Code shell scripts — `[OK] scripts: 10/10 shared scripts identical`
- [x] An expert session can be started in the installed Cursor project without typing `/start` for context loading — skills discoverable via YAML frontmatter with "what" and "when" triggers
- [x] Handoff auto-triggers when user signals completion in the installed project — trigger instruction in both `project-os.mdc` and `CLAUDE.md`; all 5 handoff SKILL.md descriptions include trigger phrases
- [x] Shell scripts execute correctly in the installed project — all 6 scripts tested (5 shared + session-primer.sh)
- [x] Project brief success criteria verified — all 5 [Platform-Native Refactor] criteria met
- [ ] No regressions to document memory model — `docs/` and `issues/` conventions preserved; one must-fix: install creates wrong PM directory (swe-bug-056)
- [x] All findings recorded as issue files
- [ ] README documentation is accurate and matches the actual installed structure — two gaps: wrong PM directory name (swe-bug-056), missing `update-brief-status` script (swe-bug-057)

## Decisions Made This Session

None. Review-only session — no architectural or design decisions required.

## Problems Encountered

None. All test infrastructure (temp install directories, script execution, sync commands) worked as expected.

## What Was Tested

- `targets/ide/install.sh --editor cursor /tmp/qa-test-cursor` — full install verified
- `targets/ide/install.sh --editor claude /tmp/qa-test-claude` — full install verified
- `tools/sync.sh diff` — cross-platform drift: 10/10 shared scripts identical; 14 expected differences (11 skills, 2 commands = script path substitutions; 1 `.gitkeep` coverage gap)
- `tools/sync.sh check /tmp/qa-test-cursor` — 3 false-positive MISSING flags (swe-bug-058)
- `tools/sync.sh check /tmp/qa-test-claude` — 1 expected settings.json difference (user settings preserved)
- Settings.json merge — user settings (`model`, `permissions`) preserved; hooks correctly added
- All shell scripts in installed context: `next-issue-number.sh` → 002; `move-issue.sh` → moved; `update-issues-list.sh` → generated; `next-session-number.sh swe` → 01 with placeholder; `update-brief-status.sh` → atomic update; `session-primer.sh` → raw context extraction
- 5 discoverable skills verified for YAML frontmatter quality (pm-vision, swe-handoff, qa-review, ops-pipeline, sa-design)
- 5 handoff skills verified for trigger phrases in descriptions
- 5 expert role rules + `project-os.mdc` + `CLAUDE.md` verified for document path references
- 3 start commands verified for context loading paths (swe-start, qa-start, pm-start)

## What the Next Session Needs to Know

1. **M11 cannot be marked complete until swe-bug-056 is fixed.** The install script creates the wrong PM handoff directory. This is a one-line fix in each install script (`project-manager` → `pm`) plus README updates.

2. **swe-bug-057 and swe-bug-058 should be fixed alongside swe-bug-056** since they touch the same files (install scripts and READMEs). All three can be addressed in a single SWE session.

3. **After fixes, a re-test of install and sync check is recommended** but should be quick — the fixes are mechanical and low-risk.

4. **PowerShell remains untested on Windows.** Same ongoing caveat from previous sessions.

5. **All 5 project brief [Platform-Native Refactor] success criteria are met.** The must-fix issue is in the install scaffolding, not in the platform implementations themselves.

## Open Questions

None.
