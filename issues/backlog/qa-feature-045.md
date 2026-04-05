# QA: Cross-Platform Regression and Install Verification

**Type:** feature
**Expert:** qa
**Milestone:** M11
**Status:** backlog

## Description

Final regression check across the entire M11 milestone. Verify both platforms install correctly into a clean project, the sync command works, and all success criteria from the project brief are met. This is the gate before M11 can be marked complete.

## Scope

- Install into a clean project directory using the Cursor install path — verify the full file structure is created
- Install into a clean project directory using the Claude Code install path — verify the full file structure is created
- Verify sync command reports no drift between fresh installations of both platforms
- Walk through the project brief success criteria for [Platform-Native Refactor] — verify each one
- Verify shell scripts work in the installed project context (not just in the repo)
- Check for regressions against earlier milestones — do the document memory model (`docs/`, `issues/`) conventions still work?
- Verify the management/update workflow — can a user update their installation?

## Acceptance Criteria

- [ ] Cursor install produces a working project structure with rules, skills, tools, and hooks in correct locations
- [ ] Claude Code install produces a working project structure with rules, skills, tools in correct locations
- [ ] Sync command reports 0 differences between fresh Cursor and Claude Code shell scripts
- [ ] An expert session can be started in the installed Cursor project without typing `/start` for context loading
- [ ] Handoff auto-triggers when user signals completion in the installed project
- [ ] Shell scripts execute correctly in the installed project (next-issue-number, move-issue, etc.)
- [ ] Project brief success criteria verified: native implementations, discoverable skills, auto-triggered handoffs, hidden shell scripts, sync command
- [ ] No regressions to document memory model — `docs/` and `issues/` conventions preserved
- [ ] All findings recorded as issue files; any must-fix issues block M11 completion
- [ ] README documentation is accurate and matches the actual installed structure

## Notes

**Depends on:** swe-feature-043 (sync command), swe-feature-044 (install scripts + docs)
**Inputs:** project brief (success criteria), all SWE and QA handoff notes for M11, installed project directories
