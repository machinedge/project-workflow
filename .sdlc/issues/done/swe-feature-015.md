# Update Install, Packaging, and Validation Scripts for New Layout

**Type:** feature
**Expert:** swe
**Milestone:** M6
**Status:** done

## User Story

As a project user, I need `install.sh` to still install experts into my project after the restructure so that the toolkit remains functional despite the directory reorganization.

## Description

Update all scripts that reference old `framework/` and `package/` paths to use the new directory layout. This includes install scripts (`install.sh`, `install.ps1`), packaging scripts (`package.sh`, `package.ps1`), validation (`validate.sh`), scaffolding (`create-expert.sh`, `create-expert.ps1`), and any internal path references. Verify each script runs without errors after the update.

## Acceptance Criteria

- [ ] `install.sh` and `install.ps1` work with the new directory layout (installs experts into a target project)
- [ ] `package.sh` and `package.ps1` build a `.skill` file from the new layout
- [ ] `validate.sh` validates expert definitions from the new paths
- [ ] `create-expert.sh` and `create-expert.ps1` scaffold new experts correctly
- [ ] Team install scripts (`install-team.sh`, `install-team.ps1`) reference correct paths for OpenClaw templates
- [ ] `install-skill.sh` and `install-skill.ps1` work with new layout
- [ ] No hardcoded references to old `framework/` or `package/` paths remain in any script

## Technical Notes

**Estimated effort:** Large session
**Dependencies:** swe-feature-014 (files must be in new locations before updating scripts)
**Inputs:** project brief (`docs/project-brief.md`), `docs/architecture.md`, all scripts in the new layout
**Out of scope:** Documentation updates (that's swe-feature-016). Don't modify expert definitions or skill files.

## Session 07 Summary

**What was done:** Updated 12 scripts to use new `targets/` and `tools/` paths. Verified with grep sweeps, `validate.sh`, `install.sh`, `list-experts.sh`, and `create-expert.sh`. All acceptance criteria met.
**Handoff note:** `docs/handoff-notes/swe/session-07.md`
**All acceptance criteria met:** Yes
