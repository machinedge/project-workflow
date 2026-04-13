# Design Platform-Native Architecture for Cursor and Claude Code

**Type:** feature
**Expert:** system-architect
**Milestone:** M11
**Status:** backlog

## User Story

As a toolkit developer, I need a clear architecture mapping of how each canonical expert file translates to platform-native concepts in Cursor and Claude Code so that SWE can implement the platform-native versions without ambiguity.

## Description

Design the platform-native architecture for both Cursor and Claude Code. Map each of the 45 canonical expert files to the correct platform-native concept (rule, skill, command, hook, tool). Define the directory structure for both platforms, how auto-triggering works, and how shell scripts integrate. Produce a design document that SWE tasks execute against.

## Acceptance Criteria

- [ ] Every canonical file in `experts/technical/` has a defined mapping to a Cursor-native concept (rule, skill, command, hook, or tool)
- [ ] Every canonical file has a defined mapping to a Claude Code-native concept
- [ ] Directory structure defined for `targets/ide/cursor/` (what goes where, naming conventions)
- [ ] Directory structure defined for `targets/ide/claude-code/` (what goes where, naming conventions)
- [ ] Cursor skill discovery mechanism validated — how does the agent find and invoke discoverable skills?
- [ ] Claude Code skill/hook mechanism validated — what events can trigger behavior?
- [ ] Shell script integration points defined (where scripts live in repo vs. installed project)
- [ ] Handoff auto-trigger mechanism defined for both platforms (what triggers it, how it works)
- [ ] Context auto-loading mechanism defined for both platforms (how `/start` Phase 1 becomes automatic)
- [ ] M10 recommendations (1-4) mapped to specific implementation steps
- [ ] Design saved to `docs/architecture.md` (updated, not replaced)

## Technical Notes

**Estimated effort:** Medium session
**Dependencies:** —
**Inputs:** project brief, `docs/interview-notes-platform-native-refactor.md`, `docs/research-context-optimization.md`, `docs/architecture.md`, current Cursor rules in `.cursor/rules/`
**Out of scope:** Implementation — this task produces design only. Data Analyst and UX experts.

## Session 03 Summary

**What was done:** Designed complete platform-native architecture for both Cursor and Claude Code. Mapped all 45 canonical files to platform concepts, defined directory structures, auto-trigger mechanisms, shell script specs, and absorbed M10 recommendations. Produced 4 new ADRs (005-008).
**Handoff note:** `docs/handoff-notes/system-architect/session-03.md`
**All acceptance criteria met:** Yes
