# Interview Notes: Deployment Layer Restructure

## What

Restructure the `framework/` and `package/` directories into a clean, extensible layout organized by deployment target class. Move OpenClaw code into its own target slot (not delete). Remove `CLAUDE.md` (redundant with project brief + expert roles).

### Three target classes identified:
1. **IDE targets** — Cursor, VSCode, Kiro, Continue.io, etc. Install experts as commands/rules within the user's IDE.
2. **Desktop/Code environments** — Claude Desktop, Claude Code, Cowork. The `.skill` packaging approach.
3. **Autonomous agent frameworks** — OpenClaw, Hermes, BeeAI (IBM), etc. Multi-agent coordination with containers/message buses.

### Current problems:
- `framework/` and `package/` have overlapping responsibilities
- `package/tools/` contains repo management utilities that aren't packaging
- `install/targets/` is an unused placeholder
- `install/templates/team/` is OpenClaw-specific but tangled with core install
- `CLAUDE.md` duplicates content from project brief and agent-reference.md

## Why

- **Release blocker:** Current branch can't be released because the structure confuses users — OpenClaw artifacts that don't work, unused directories, unclear `framework/` vs `package/` split.
- **Development friction:** When working on new features (especially automated agent support), changes aren't atomic. AI agents bleed into unrelated deployment scripts because responsibilities are tangled.
- **Tech debt compounding:** Every change makes the structure worse. Must clean up before adding new targets.

## Scope

### In Scope
- Full restructure of `framework/` and `package/` into a layout organized by target class
- Move OpenClaw code into its own target directory (preserve, don't delete)
- Remove `CLAUDE.md` (redundant)
- Clean up all cross-references in docs (project brief, agent-reference.md, SKILL.md, docs-protocol)
- Design the extensibility model so adding a new target is atomic and self-contained
- Update `install.sh` / `install.ps1` if paths change

### Out of Scope
- Implementing new targets (Kiro, BeeAI, etc.) — structural reorganization only
- Fixing OpenClaw — just reorganize it
- Changes to expert definitions (`experts/`)

## Success Criteria

1. Directory layout is self-explanatory — someone new can understand it without a guide
2. Adding a new target is atomic — no changes to core files or other targets needed
3. Existing functionality still works — `install.sh` installs experts, `package.sh` builds `.skill`
4. OpenClaw code is preserved but isolated in its own target directory
5. Docs are updated — project brief, agent-reference.md, SKILL.md reflect the new structure
6. `CLAUDE.md` removed

## Risks

- **Breaking changes:** Accepted. No backward compat constraint.
- **Scope creep into target implementation:** Mitigated by scope definition — reorganize only, don't fix OpenClaw.
- **Git history:** Feature branch, manageable.
- **Structure might not be perfect:** Design for what we know now, iterate later.

## Open Questions

- What should the new top-level directory structure look like? (To be designed during implementation — System Architect task.)

## Next Step

Run `/pm-update-plan` to integrate this into the project brief and roadmap.
