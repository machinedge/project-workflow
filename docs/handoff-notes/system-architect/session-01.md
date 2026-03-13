# System Architect Session 01 — Handoff

**Date:** 2026-03-12
**Issue:** sa-feature-013 (Design Target-Class Directory Layout)
**Status:** Complete

## What Was Done

Designed the new directory layout for `docs/architecture.md`, replacing the tangled `framework/` + `package/` split with a structure organized by deployment target class.

### Key decisions made (all accepted by user):
1. **Target-class hierarchy** (`targets/ide/`, `targets/desktop-cli/`, `targets/autonomous/`) — three fundamentally different deployment mechanisms reflected in directory structure
2. **Top-level `tools/`** for scaffold, validate, new-repo, list-experts — separated from deployment targets
3. **Framework docs merged** — `agent-reference.md` into `docs/`, `CONTRIBUTING.md` to repo root
4. **`desktop-cli/` with per-target subdirs** — user requested this over flat `desktop/` to accommodate future tools (Gemini, Warp); Claude artifacts go under `targets/desktop-cli/claude/`

### Artifacts produced:
- `docs/architecture.md` — full layout, data flow, extensibility model, migration mapping, 4 ADRs

## Acceptance Criteria Verification

- [x] `docs/architecture.md` exists and documents the new directory layout
- [x] Layout has a clear place for each of: scaffold, validate, install scripts, packaging scripts, per-target configs, OpenClaw templates, repo utilities, and framework docs
- [x] Extensibility model is defined — one directory, optionally one script, zero changes elsewhere
- [x] OpenClaw code has a designated slot (`targets/autonomous/openclaw/`)
- [x] Repo utilities have a designated home separate from packaging (`tools/`)
- [x] Trade-offs between considered alternatives are documented (4 ADRs)
- [x] Architecture reviewed with user before finalizing

## What's Next

- **swe-feature-014** and **swe-feature-015** (M6): Implement the directory restructure — move files per the migration mapping in `docs/architecture.md`
- **swe-feature-016** and **qa-feature-017** (M7): Update docs, remove `CLAUDE.md`, verify functionality
- All scripts that reference `framework/` or `package/` paths will need internal path updates during implementation
