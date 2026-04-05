# Interview Notes — Platform-Native Refactor

**Feature:** Move from command-driven workflow to platform-native rules, skills, tools, and hooks
**Context:** Bundled with M10 context optimization recommendations into one combined milestone

## What

Refactor the entire expert workflow system from explicit slash commands to platform-native concepts (rules, skills, tools, hooks). Comprehensive audit of all 45 expert markdown files identified:

- **6 role files** → conditionally loaded **rules** (one per session, not all 6)
- **~22 skill files** currently exposed as commands but mostly autonomous → platform-native discoverable **skills**
- **6 handoff files** → **hooks** / auto-triggered behaviors on session end
- **~7 mechanical operations** repeated across 10+ files → reusable **shell scripts** hidden in `.cursor/tools/` and `.claude/tools/`
- **4 interview-style files** (pm/interview, pm/add_feature large, devops/env-discovery, da/intake) + **deploy** → remain explicit **commands** (require human interaction)
- **6 `/start` files** → hybrid: context loading becomes automatic, approval gates remain

Additionally:
- Fork `experts/technical/` (currently platform-agnostic canonical definitions) into platform-native implementations in `targets/ide/cursor/` and `targets/ide/claude-code/`
- `experts/technical/` stays as a reference, no longer the source of truth
- Translation layer concept is retired — each platform is a first-class implementation that evolves independently
- Build a sync/management command that keeps Cursor and Claude Code implementations aligned and ships to users for installation management

## Why

- The current command-driven model creates friction — users must know and type slash commands for operations that should be automatic
- Industry moving toward rules-based, skills-based, tools-based AI configuration
- Platform-agnostic canonical definitions + translation layer adds complexity without proportional value when only targeting two platforms
- M10 research already identified that the workspace rules model is inefficient (~280 lines of irrelevant expert context per session)

## Scope

### In
- Absorb M10 context optimization recommendations (conditional rules, QA bug fix, scoped handoff loading)
- Fork `experts/technical/` into platform-native implementations in `targets/ide/cursor/` and `targets/ide/claude-code/`
- Refactor ~22 autonomous command-skills into platform-native discoverable skills
- Refactor 6 handoffs into hooks/auto-triggered behaviors
- Extract ~7 mechanical operations as shell scripts, hidden in `.cursor/tools/` and `.claude/tools/`
- Restructure 6 `/start` skills (auto context loading, approval gates remain)
- Keep 4 interview files + deploy as explicit commands
- Build sync/management command for repo maintainers and end users
- Update install scripts and READMEs

### Out
- OpenClaw / autonomous target class
- Desktop/CLI target class (`.skill` packages)
- Data Analyst expert (under development, not finalized)
- User Experience expert (not started)
- MCP tools (deferred — shell scripts first, MCP wrapper later if needed)
- Scaffold/validate development tooling updates
- Changes to the document memory model (`docs/`, `issues/`)

### Key decisions
- Cursor and Claude Code only — OpenClaw out of scope
- Platform-agnostic canonical definitions retired — each platform gets its own native implementation
- `experts/technical/` kept as reference, not deleted
- Shell scripts (not MCP tools) for mechanical operations — lightest dependency burden
- Scripts hidden in platform config directories (`.cursor/tools/`, `.claude/tools/`), not user-facing

## Success

- User can install the toolkit and have a productive session without typing slash commands for things that should be automatic
- AI recognizes which expert role to use without being told to load a role file
- Handoff happens automatically when user signals "I'm done" — no `/handoff` needed
- Context loads automatically when starting work — no `/start` needed for context loading (approval gates still explicit)
- Mechanical operations (issue numbering, file movement, list updates) happen via hidden scripts without user awareness
- Sync command can detect and flag drift between Cursor and Claude Code implementations
- Users can manage/update their installation via the included management command

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Platform divergence becomes maintenance burden | High | Medium | Sync/management command keeps implementations aligned; included as a feature |
| Skills that should auto-trigger don't fire reliably | Medium | Medium | Respond as bugs; acceptance test during QA |
| Shell scripts break across OS/shell environments | Low | Medium | Ship both .sh and .ps1 (existing pattern); respond to bugs |
| Cursor and Claude Code evolve their platform concepts | Medium | Medium | Respond to platform changes as they happen |
| Install experience becomes more complex | Medium | Low | Management command simplifies updates; clear README documentation |

## Flags and Open Items

- [ ] Exact Cursor mechanism for discoverable skills needs validation — how does Cursor's SKILL.md discovery work for skills stored in `.cursor/`?
- [ ] Claude Code's hook mechanism for auto-triggering handoff needs investigation — what events can trigger behavior?
- [ ] The sync command's scope needs definition during decomposition — how much automation vs. reporting?
- [ ] Data Analyst skills still have date references (3 files) — clean up when that expert is finalized, not in this milestone
