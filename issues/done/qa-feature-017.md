# QA: Verify Deployment Restructure End-to-End

**Type:** feature
**Expert:** qa
**Milestone:** M7
**Status:** done

## Description

Verify the entire Deployment Restructure (M6 + M7) against the success criteria from the interview notes and the architecture design. Test that install, packaging, validation, and scaffolding all work. Confirm OpenClaw code is preserved and isolated. Check that docs are consistent and `CLAUDE.md` is gone. Validate that the extensibility model works by checking whether a hypothetical new target could be added atomically.

## Scope

- Verify install scripts work end-to-end (`install.sh` installs experts into a test project)
- Verify packaging works (`package.sh` builds a `.skill` file)
- Verify validation works (`validate.sh` passes for all experts)
- Verify scaffolding works (`create-expert.sh` creates a new expert)
- Verify OpenClaw code is preserved in its own target directory (not deleted, not tangled)
- Verify extensibility model — adding a new target is atomic (no core file changes needed)
- Verify all documentation references are consistent with new layout
- Verify `CLAUDE.md` is removed
- Verify no references to old `framework/` or `package/` paths remain anywhere

## Acceptance Criteria

- [x] All verification checks pass or issues are filed for failures
- [x] Findings documented in QA handoff note

## Notes

**Depends on:** swe-feature-016 (all restructure work must be complete)
**Inputs:** `docs/architecture.md`, `docs/interview-notes-deployment-restructure.md` (success criteria), SWE handoff notes from swe-feature-014 through swe-feature-016

## Session 01 Summary

**What was done:** Full end-to-end verification of the Deployment Restructure (M6 + M7). 9 verification areas covered. 1 must-fix, 3 should-fix, and 1 nit found — all documentation issues. Core infrastructure (validation, install, scaffolding, OpenClaw isolation, extensibility, stale paths) is clean.
**Handoff note:** `docs/handoff-notes/qa/session-01.md`
**All acceptance criteria met:** Yes
