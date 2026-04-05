# Update architecture.md script specifications for update-brief-status

**Type:** techdebt
**Expert:** system-architect
**Milestone:** —
**Status:** backlog
**Severity:** should-fix

## Description

`swe-feature-049` added a new script `update-brief-status.sh` (+ `.ps1`) to both Cursor and Claude Code platforms. The script atomically updates the "Last updated" line in `docs/project-brief.md` under a lockfile, replacing the previous instruction-based approach in all handoff skills.

The script specifications table in `docs/architecture.md` (under "Shared Specifications") needs to be updated to include this new script alongside the existing four (`next-issue-number.sh`, `move-issue.sh`, `update-issues-list.sh`, `next-session-number.sh`).

## Acceptance Criteria

- [ ] `update-brief-status.sh` added to the script specifications table in `docs/architecture.md` with arguments, output, and "Used By" columns
- [ ] Entry accurately reflects the script's behavior: lockfile-based atomic update of the "Last updated" line

## Technical Notes

**Estimated effort:** Trivial (single table row addition)
**Dependencies:** swe-feature-049 (done)
**Inputs:** `targets/ide/cursor/scripts/update-brief-status.sh` for reference

## Session 07 Summary

**What was done:** Added `update-brief-status.sh` to the script specifications table in `docs/architecture.md` with arguments, output, and "Used By" columns.
**Handoff note:** `docs/handoff-notes/system-architect/session-07.md`
**All acceptance criteria met:** Yes
