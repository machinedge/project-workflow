# Design Target-Class Directory Layout

**Type:** feature
**Expert:** system-architect
**Milestone:** M6
**Status:** done

## User Story

As a toolkit developer, I need a clear, self-explanatory directory structure organized by deployment target class so that I can add new targets (Kiro, BeeAI, etc.) without modifying core files or other targets.

## Description

Design the new top-level directory structure for the repo, replacing the current `framework/` and `package/` split. The three target classes are: IDE (Cursor, VSCode, Kiro, Continue.io), Desktop/Code (Claude Desktop, Claude Code, Cowork — `.skill` packaging), and Autonomous (OpenClaw, Hermes, BeeAI — multi-agent with containers/message buses). Produce `docs/architecture.md` with the layout, rationale, and extensibility model.

## Acceptance Criteria

- [x] `docs/architecture.md` exists and documents the new directory layout
- [x] Layout has a clear place for each of: scaffold, validate, install scripts, packaging scripts, per-target configs, OpenClaw templates, repo utilities (new_repo, list-experts), and framework docs
- [x] Extensibility model is defined — adding a new target requires creating one directory and optionally one script, with no changes to core files or other targets
- [x] OpenClaw code has a designated slot (preserved, not deleted)
- [x] `package/tools/` utilities (new_repo, list-experts) have a designated home separate from packaging
- [x] Trade-offs between considered alternatives are documented
- [x] Architecture is reviewed with the user before finalizing

## Technical Notes

**Estimated effort:** Medium session
**Dependencies:** None
**Inputs:** project brief (`docs/project-brief.md`), interview notes (`docs/interview-notes-deployment-restructure.md`), current directory listing of `framework/` and `package/`, `CLAUDE.md` (to understand what it covers)
**Out of scope:** Implementation — this task produces the design only. Don't move files or write scripts.
