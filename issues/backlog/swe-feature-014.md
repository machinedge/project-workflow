# Create Target-Class Directories and Relocate Files

**Type:** feature
**Expert:** swe
**Milestone:** M6
**Status:** backlog

## User Story

As a toolkit developer, I need the repo files organized into the new target-class layout so that each deployment target's code is isolated and the repo structure is self-explanatory.

## Description

Implement the directory restructure defined in `docs/architecture.md`. Create the new directory tree, move all files from `framework/` and `package/` to their new locations, and ensure OpenClaw templates/configs are isolated in their own target directory. This is the mechanical reorganization — script updates happen in the next task.

## Acceptance Criteria

- [ ] New directory structure matches what `docs/architecture.md` specifies
- [ ] All files from `framework/` have been moved to their new locations (nothing left behind except `framework/` itself for removal)
- [ ] All files from `package/` have been moved to their new locations (nothing left behind except `package/` itself for removal)
- [ ] OpenClaw code (templates, team install scripts) is in its own target directory
- [ ] `package/tools/` utilities (new_repo, list-experts) are in their designated location per architecture.md
- [ ] Old `framework/` and `package/` directories are removed
- [ ] No files are deleted — everything is relocated

## Technical Notes

**Estimated effort:** Medium session
**Dependencies:** sa-feature-013 (must know the target layout before moving files)
**Inputs:** project brief (`docs/project-brief.md`), `docs/architecture.md` (the layout to implement)
**Out of scope:** Updating script contents (paths, references inside scripts). That's swe-feature-015. Don't update docs — that's swe-feature-016.
