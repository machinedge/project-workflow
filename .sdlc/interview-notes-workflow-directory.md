# Interview Notes — .workflow Directory Structure

## What

Split workflow artifacts into two tiers:

- **`docs/`** — User-facing planning documents and project-specific content. Retains: `project-brief.md`, `roadmap.md`, `test-plan.md`, `architecture.md`, `agent-reference.md`. Also holds any user-generated documentation specific to the project.
- **`.sdlc/`** — Managed workflow artifacts (agent memory system). Contains:
  - `handoff-notes/` (all expert subdirectories: `pm/`, `swe/`, `qa/`, `devops/`, `sa/`)
  - `interview-notes-*.md`
  - `lessons-log.md`
  - `research-*.md`
  - `issues/` (`backlog/`, `planned/`, `in-progress/`, `done/`, `issues-list.md`)

The top-level `issues/` directory goes away entirely. The `docs/` directory becomes a mixed space where the workflow keeps its core planning docs alongside user-generated project documentation.

## Why

1. **Noise reduction for humans.** Handoff notes, issues, and session artifacts are an agent memory system. They clutter the project tree for human developers who don't interact with them directly.
2. **Future data portability.** Consolidating managed artifacts under `.sdlc/` creates a clear boundary — a defined surface for what could eventually be persisted to a database or external store.

## Scope

### In

- New `.sdlc/` directory structure created on fresh install
- Migration logic in the install script: detect old layout (`docs/handoff-notes/`, `docs/interview-notes-*`, `docs/lessons-log.md`, `docs/research-*`, `issues/`), move files to `.sdlc/`
- Update all path references in expert role files, skills, and scripts on both platforms (Cursor and Claude Code)
- Update `project-os.mdc` conventions to reflect new paths

### Boundary Decisions

- `.sdlc/` is NOT auto-added to `.gitignore` — left to the user
- `agent-reference.md` stays in `docs/` (project-specific)
- `lessons-log.md` moves to `.sdlc/`

### Out

- Database/persistence layer (future work)
- Changes to issue format or workflow logic
- New experts or skills

## Success Criteria

- Fresh install into a new project creates `.sdlc/` structure from the start
- Installing over an existing project (old structure) migrates all artifacts into `.sdlc/` without data loss
- After migration, all experts can start sessions, pick up issues, write handoff notes, and read/write correct paths — nothing breaks
- No stale path references remain in any role file, skill, or script
- Validated by installing into this project and running expert sessions

## Risks

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Path reference coverage — missing a reference means an expert silently reads/writes the wrong location | High | Medium | Systematic grep audit of all path references across both platforms before and after changes |
| Migration edge cases — user-created files in `docs/` that aren't standard workflow artifacts | Medium | Medium | Migration only moves known artifacts by name pattern; leaves everything else untouched |
| Partial migration state — install fails halfway, files split between old and new locations | High | Low | Migration script should be atomic or at minimum idempotent (safe to re-run) |
| Script hardcoded paths — shell scripts in `.cursor/scripts/` and `.claude/scripts/` reference old paths | High | High | Include scripts in the path reference audit; update alongside role files and skills |
