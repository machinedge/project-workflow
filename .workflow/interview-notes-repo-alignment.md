# Interview Notes — Repo Alignment Cleanup

## What
Remove dead-weight directories (`experts/`, `tools/`, `targets/desktop-cli/`, `targets/autonomous/`) and align all documentation with the platform-native paradigm (Cursor + Claude Code in `targets/ide/`).

## Why
Post-M11, these directories and the contributing guide describe a superseded workflow. A contributor following `CONTRIBUTING.md` today would produce artifacts in the wrong format in directories that don't matter. All 11 milestones are complete — this is cleanup at a natural stopping point.

## Scope

### In
- Delete `experts/` directory entirely
- Delete `tools/` directory entirely
- Delete `targets/desktop-cli/` directory entirely
- Delete `targets/autonomous/` directory entirely
- Rewrite `CONTRIBUTING.md` — simplified to "install the workflow, dogfood it, contribute back"
- Update `targets/ide/cursor/README.md`
- Update all docs that reference removed directories:
  - `docs/project-brief.md`
  - `docs/architecture.md`
  - `docs/agent-reference.md`
  - `experts/technical/shared/docs-protocol.md` (moves or is removed with `experts/`)
  - `docs/roadmap.md`
  - `docs/lessons-log.md`
  - Any other files with stale references (systematic grep to find)

### Out
- Modifying platform-native implementations in `targets/ide/` (they work)
- Adding new experts (Data Analyst, UX — separate work)
- Re-creating scaffold/validate tooling for the new paradigm (document as future work)
- Rebuilding `sync.sh` or `new-repo.sh` — document and rebuild as needed

## Success Criteria
- No stale references to `experts/`, `tools/`, `targets/desktop-cli/`, or `targets/autonomous/` anywhere in the repo
- `CONTRIBUTING.md` accurately describes how to install, use, and contribute using the current paradigm
- `targets/ide/` is the only target directory
- Platform-native implementations remain unmodified and functional

## Risks
| Risk | Impact | Mitigation |
|------|--------|------------|
| Stale references missed | Confusion for contributors | Systematic grep before closing |
| Loss of scaffold templates as institutional knowledge | Future expert authoring is harder | 5 existing experts in `targets/ide/` serve as living examples |
| No `.skill` packaging after removing `targets/desktop-cli/` | Can't distribute as Claude skill | Document as future work if needed |
| `sync.sh` removal means no automated cross-platform alignment | Manual drift between Cursor and Claude Code | Document and rebuild as needed |
