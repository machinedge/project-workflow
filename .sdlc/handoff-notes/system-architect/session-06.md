# Handoff Note: Fix Concurrent Session Conflicts

**Issue:** sa-bug-048 — Concurrent session conflicts: session numbering and project brief overwrites

## What Was Accomplished
Fixed the session numbering race condition by rewriting `next-session-number.sh` to atomically claim numbers using `set -C` (noclobber / `O_CREAT|O_EXCL`). Updated all 5 Cursor handoff skills with claim semantics and project brief conflict-awareness instructions. Created follow-up `swe-feature-049` for script-enforced project brief protection.

## Acceptance Criteria Status
- [x] Concurrent sessions cannot write to the same session number file — atomic claim via `set -C` with retry loop
- [x] Project brief updates from concurrent sessions do not silently overwrite each other — instruction-based: agents re-read and merge before writing; script enforcement deferred to swe-feature-049
- [x] A session that detects a conflict reports it rather than silently losing data — session numbers: auto-increment on collision; project brief: agents instructed to warn user on unresolvable conflicts

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|
| Atomic file creation (`set -C` / noclobber) over lockfiles or `mkdir`-based locks | `set -C` maps to `O_CREAT\|O_EXCL` at the kernel level — truly atomic, POSIX-compliant, zero external dependencies. Lockfiles add cleanup complexity; `mkdir` locks are less idiomatic for this use case. |
| Instruction-based project brief conflict detection (now) + script-enforced (later) | Full script-based markdown section merging is complex and fragile. Agent instructions to re-read and merge are pragmatic for a single-user tool where concurrency is uncommon. Script enforcement captured as swe-feature-049. |
| Script creates placeholder file as side effect of claiming | Changes `next-session-number.sh` from pure query to claim-and-create. The handoff skill overwrites the placeholder with real content. This is the simplest atomic claim mechanism — no separate lock/unlock step. |

## Downstream Impact
- **SWE (Claude Code skills):** When creating Claude Code handoff skills, use the updated Step 1 ("claim") and Step 5 ("re-read and merge") patterns from the Cursor versions.
- **SWE (swe-feature-049):** Follow-up to replace instruction-based project brief protection with a script-enforced approach.
- **All experts:** Handoff behavior changed — `next-session-number.sh` now creates the file. Skills overwrite the placeholder. No workflow change for the agent, just awareness that the file already exists when writing.

## Problems Encountered
None. Clean implementation — the `set -C` approach worked on first attempt. Concurrent test confirmed two simultaneous invocations get different numbers.

## Files Created or Modified
- `targets/ide/cursor/scripts/next-session-number.sh` — rewritten with atomic claim
- `targets/ide/claude-code/scripts/next-session-number.sh` — same rewrite
- `targets/ide/cursor/skills/swe-handoff/SKILL.md` — Step 1 claim semantics, Step 5 conflict awareness
- `targets/ide/cursor/skills/pm-handoff/SKILL.md` — same
- `targets/ide/cursor/skills/qa-handoff/SKILL.md` — same
- `targets/ide/cursor/skills/ops-handoff/SKILL.md` — same
- `targets/ide/cursor/skills/sa-handoff/SKILL.md` — same
- `docs/architecture.md` — script specification updated with side-effect note
- `issues/backlog/swe-feature-049.md` — feature request for robust project brief updates

## What the Next Session Needs to Know
sa-bug-048 is resolved. The session numbering race condition is fully fixed. The project brief race condition has an instruction-based mitigation (agents re-read before writing) with swe-feature-049 tracking the script-enforced solution. Claude Code handoff skills don't exist yet — when SWE creates them, they should follow the updated Cursor patterns.

## Open Questions
- None
