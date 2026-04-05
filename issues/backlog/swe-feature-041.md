# Create Claude Code QA, DevOps, and System Architect Expert Skills

**Type:** feature
**Expert:** swe
**Milestone:** M11
**Status:** backlog

## User Story

As a Claude Code user running QA, DevOps, or System Architect sessions, I want the same discoverable skills and auto-triggered handoffs as the Cursor version so that both platforms offer an equivalent experience.

## Description

Complete the Claude Code implementation by adding QA (6 files), DevOps (6 files), and System Architect (6 files) expert skills. Use the Cursor implementation (from swe-feature-037/038) as a working reference, adapting to Claude Code's native format.

## Acceptance Criteria

- [ ] QA expert: start (hybrid), handoff (hook), review (skill), test-plan (skill), regression (skill), bug-triage (skill)
- [ ] DevOps expert: start (hybrid), handoff (hook), env-discovery (command), pipeline (skill), release-plan (skill), deploy (command)
- [ ] SA expert: start (hybrid), handoff (hook), design (skill), research (skill), review (skill), update (skill)
- [ ] All skills reference shell scripts from Claude Code tools directory
- [ ] Each skill has its own context loading steps
- [ ] Safety-critical commands (deploy) maintain explicit approval gates
- [ ] Interview-style commands (env-discovery) remain explicit
- [ ] Consistent format across all 3 experts — same patterns as PM and SWE from swe-feature-040

## Technical Notes

**Estimated effort:** Medium session
**Dependencies:** swe-feature-040 (Claude Code structure + PM + SWE must exist first), swe-feature-037 (Cursor QA reference), swe-feature-038 (Cursor DevOps+SA reference)
**Inputs:** project brief, sa-feature-033 design, Cursor implementations in `targets/ide/cursor/`, Claude Code structure from swe-feature-040
**Out of scope:** Sync command. Install scripts.
