# Concurrent session conflicts: session numbering and project brief overwrites

**Type:** bug
**Expert:** system-architect
**Milestone:** —
**Status:** backlog
**Severity:** should-fix

## Description

When multiple expert sessions run concurrently (e.g., two SWE sessions working on different issues), the handoff workflow has two race conditions:

1. **Session number collision.** Both sessions call `next-session-number.sh` (or compute the next number manually), get the same number, and write to the same `session-NN.md` file. The last writer wins; the other session's handoff note is silently lost.

2. **Project brief last-writer-wins.** Both sessions update `docs/project-brief.md` at handoff time. The last writer's version overwrites the other's changes (current status, last updated, next task fields).

### Observed instance

- swe-feature-037 and swe-feature-038 ran concurrently.
- Both computed session-20 as the next number.
- swe-feature-038 wrote `session-20.md` with its content.
- swe-feature-037 committed afterward, capturing 038's version of `session-20.md` and an overwritten project brief.
- swe-feature-037's handoff note was lost entirely.
- The project brief "Last updated" field jumped from swe-feature-036 to swe-feature-038, with no record of 037.

## Acceptance Criteria

- [ ] Concurrent sessions cannot write to the same session number file
- [ ] Project brief updates from concurrent sessions do not silently overwrite each other
- [ ] A session that detects a conflict reports it rather than silently losing data

## Technical Notes

**Estimated effort:** Medium session
**Dependencies:** None
**Inputs:** Handoff skills (`*-handoff/SKILL.md`), shell scripts (`next-session-number.sh`)
**Out of scope:** Full distributed locking — this is a single-user tool. Simple collision detection or atomic operations are sufficient.

### Possible approaches

- **Atomic session numbering:** `next-session-number.sh` could use a lockfile or atomic file creation (`mkdir` as a lock, or `set -o noclobber` for writes) to prevent two sessions from claiming the same number.
- **Check-before-write:** Handoff skills could verify the target file doesn't already exist before writing. If it does, increment and try again.
- **Append-only project brief updates:** Instead of overwriting the Current Status section, append a timestamped entry. Or use a separate `docs/session-log.md` for per-session status lines.
- **Git-based conflict detection:** Handoff skills could check `git status` before writing and warn if the target files have uncommitted changes from another session.
