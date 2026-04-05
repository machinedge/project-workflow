# Redesign session-context as Agent Skill Instead of Shell Script

**Type:** feature
**Expert:** system-architect
**Milestone:** M11
**Status:** backlog

## User Story

As a Claude Code user starting a session, I want the agent to read project documents and produce a compressed context summary so that I'm oriented quickly without manually loading files.

## Description

The current architecture (sa-feature-033) specifies `session-context` as a shell script (`.claude/scripts/session-context.sh`) invoked by Claude Code's `SessionStart` hook. During implementation of swe-feature-034, it was determined that this is the wrong mechanism: extracting relevant information from project documents, identifying the most recent handoff, and compressing it into a usable summary is agent work, not a mechanical file operation.

The System Architect needs to redesign `session-context` as a discoverable skill (or equivalent agent-driven mechanism) and update the architecture accordingly. Key questions:

1. Should `session-context` become a discoverable skill (SKILL.md) that the agent runs at session start?
2. How does this interact with Claude Code's `SessionStart` hook? The hook runs shell commands, not skills. Options include: removing the hook entirely (rely on skill discovery + role instruction), having the hook output a lightweight prompt that triggers the skill, or a different approach.
3. Does Cursor get an equivalent skill, or is this Claude Code-only (since Cursor has no session-start hook)?
4. How does this relate to the existing `/start` commands which already load context? Is `session-context` for non-`/start` sessions (direct skill invocation)?

## Acceptance Criteria

- [ ] Architecture updated: `session-context` mechanism redesigned as agent skill or equivalent
- [ ] Claude Code hook configuration updated (or removed) in architecture
- [ ] Script Specifications table in architecture updated (remove `session-context` if no longer a script)
- [ ] Claude Code installed directory structure updated in architecture
- [ ] Impact on downstream tasks (swe-feature-040, swe-feature-041) documented

## Technical Notes

**Estimated effort:** Small session
**Dependencies:** sa-feature-033 (original design)
**Inputs:** architecture.md (current hook configuration, script specifications), swe-feature-034 finding
**Out of scope:** Implementation of the skill itself (that belongs to the Claude Code skill tasks).
