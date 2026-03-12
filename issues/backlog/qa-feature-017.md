# QA: Verify Deployment Restructure End-to-End

**Type:** feature
**Expert:** qa
**Milestone:** M7
**Status:** backlog

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

- [ ] All verification checks pass or issues are filed for failures
- [ ] Findings documented in QA handoff note

## Notes

**Depends on:** swe-feature-016 (all restructure work must be complete)
**Inputs:** `docs/architecture.md`, `docs/interview-notes-deployment-restructure.md` (success criteria), SWE handoff notes from swe-feature-014 through swe-feature-016
