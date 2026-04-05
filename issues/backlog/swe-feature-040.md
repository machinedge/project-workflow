# Create Claude Code Rules, Project Structure, PM and SWE Expert Skills

**Type:** feature
**Expert:** swe
**Milestone:** M11
**Status:** backlog

## User Story

As a Claude Code user, I want the same platform-native experience as Cursor — automatic expert loading, discoverable skills, auto-triggered handoffs — using Claude Code's native mechanisms.

## Description

Create the Claude Code implementation in `targets/ide/claude-code/`. Set up the rules structure (CLAUDE.md or `.claude/` rules), conditional expert loading, and PM + SWE expert skills. Use the Cursor implementation (from swe-feature-035/036/037) as a working reference, adapting to Claude Code's native format and conventions.

## Acceptance Criteria

- [ ] `targets/ide/claude-code/` directory structure matches the design from sa-feature-033
- [ ] Claude Code rules structure created with conditional expert loading
- [ ] M10 recommendations applied (conditional roles, scoped handoffs, QA bug fix, doc loading in skills)
- [ ] PM expert: all 10 skills mapped (commands, skills, hooks) in Claude Code format
- [ ] SWE expert: start (hybrid) + handoff (hook) in Claude Code format
- [ ] Shell scripts present in `targets/ide/claude-code/scripts/` (copied from Cursor — identical content)
- [ ] `settings.json` created with `SessionStart` hook referencing `.claude/scripts/session-context.sh` per architecture spec
- [ ] All skills reference shell scripts for mechanical operations
- [ ] Each skill has its own context loading steps
- [ ] docs-protocol content integrated appropriately

## Technical Notes

**Estimated effort:** Medium session
**Dependencies:** sa-feature-033 (design), swe-feature-034 (shell scripts), swe-feature-035 (Cursor rules — use as reference), swe-feature-036 (Cursor PM — use as reference), swe-feature-037 (Cursor SWE — use as reference)
**Inputs:** project brief, sa-feature-033 design, Cursor implementation in `targets/ide/cursor/`
**Out of scope:** QA, DevOps, SA experts (next task). Sync command. Install scripts.
