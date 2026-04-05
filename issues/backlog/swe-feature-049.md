# Robust concurrent handoff: script-based project brief updates and session claiming

**Type:** feature
**Expert:** swe
**Milestone:** —
**Status:** backlog
**Severity:** nice-to-have

## Description

`sa-bug-048` fixed the most critical concurrency issue (session number collision) by making `next-session-number.sh` atomic via `set -C` (noclobber). It also added agent instructions to re-read and merge the project brief before overwriting.

However, the project brief conflict detection is instruction-based — it relies on the agent to comply. A more robust approach would move the mechanical parts of handoff (session claiming, project brief status update) into a script that enforces correctness.

### Proposed approach

Create a `write-handoff-status.sh` script that:

1. Accepts expert name, issue identifier, and a brief status line as arguments
2. Appends a timestamped entry to the "Current Status" section (or a new `docs/status-log.md` file) instead of overwriting it
3. Updates the "Last updated" field atomically
4. Returns success/failure so the handoff skill knows whether it succeeded

This would replace the current "read and update the project brief" step in all handoff skills with a single script call for the mechanical parts. The agent would still add new decisions to the "Key Decisions Made" table (which is additive and rarely conflicts).

### Alternative: git-based conflict detection

A lighter alternative: a `check-brief-conflicts.sh` script that checks `git diff docs/project-brief.md` before the agent writes, and prints a warning if uncommitted changes exist from another session. This keeps the current overwrite pattern but makes conflicts visible.

## Acceptance Criteria

- [ ] Project brief updates from concurrent sessions cannot silently overwrite each other (enforced by script, not just agent instructions)
- [ ] The solution works on both Cursor and Claude Code platforms
- [ ] Handoff skills are updated to use the new script
- [ ] Backward compatible — works even if only one session is running

## Technical Notes

**Estimated effort:** Small-medium session
**Dependencies:** sa-bug-048 (atomic session numbering — already done)
**Inputs:** Handoff skills (`*-handoff/SKILL.md`), project brief structure
**Out of scope:** Multi-user locking, distributed systems
