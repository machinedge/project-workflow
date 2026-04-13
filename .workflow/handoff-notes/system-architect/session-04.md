# Handoff Note: Redesign session-context as Raw Extractor Script

**Issue:** sa-feature-046 — Redesign session-context as Agent Skill Instead of Shell Script

## What Was Accomplished
Redesigned the `session-context` mechanism from an intelligent summarizer (agent work) to a raw content extractor script (`session-primer.sh`) that outputs file sections for the agent to process naturally. Documented as ADR-009. Updated the Claude Code hook configuration, directory structure, and downstream task (swe-feature-040).

## Acceptance Criteria Status
- [x] Architecture updated: `session-context` mechanism redesigned as equivalent (raw extractor script, per ADR-009)
- [x] Claude Code hook configuration updated in architecture (references `session-primer.sh`, scope clarified)
- [x] Script Specifications table in architecture updated (`session-context` was never in the table; added a note pointing to the hook-specific script spec)
- [x] Claude Code installed directory structure updated in architecture (`session-primer.sh` added to scripts listing)
- [x] Impact on downstream tasks documented (swe-feature-040 acceptance criteria updated; swe-feature-041 confirmed unaffected)

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|
| ADR-009: Session primer as raw extractor, not agent summarizer | The lesson from swe-feature-034 was that summarization is agent work. The fix: stop requiring summarization in the script. Raw content injection + agent reasoning achieves the same user story with simpler architecture and 100% hook reliability. |
| Rename `session-context.sh` → `session-primer.sh` | Signals the narrower scope (extraction, not summarization). Avoids confusion with the original "session-context" concept. |
| No Cursor equivalent | Cursor has no session-start hook. The gap only affects free-form chat (not `/start` or explicit skill invocation). Acceptable trade-off for simpler architecture. |
| No new skill artifact | A discoverable skill would have 70-80% reliability vs. the hook's 100%. For something that should fire every session, reliability wins. Keeps the skill count at 21. |

## Downstream Impact
- **SWE (swe-feature-040):** Must create `session-primer.sh` in `targets/ide/claude-code/scripts/`. Script extracts raw content (project identity, current status, most recent handoff) — no summarization. `settings.json` references `.claude/scripts/session-primer.sh`. Two acceptance criteria updated.
- **SWE (swe-feature-041):** No impact confirmed.
- **QA (qa-feature-042):** Can test hook by verifying `session-primer.sh` outputs raw sections from project-brief.md and the most recent handoff note.

## Problems Encountered
None. The design question had a clear answer once the two concerns (mechanical extraction vs. intelligent summarization) were separated.

## Files Created or Modified
- `docs/architecture.md` — ADR-009 added (decision table + body), Hook Configuration updated (script name, scope, behavioral spec), Claude Code directory structure updated (added `session-primer.sh`), Script Specifications note added
- `issues/backlog/swe-feature-040.md` — Two acceptance criteria updated to reference `session-primer.sh`

## What the Next Session Needs to Know
sa-feature-046 is resolved. The blocker for Claude Code skill tasks is cleared. The next SWE task is swe-feature-035 (Create Cursor Rules and Project Structure). When SWE reaches swe-feature-040 (Claude Code), the architecture now has a complete, coherent spec for the SessionStart hook: `session-primer.sh` extracts raw file content, agent processes it naturally.

The key implementation detail for `session-primer.sh`: it should (1) extract first few lines of `docs/project-brief.md`, (2) extract the "Current Status" section, (3) find the most recent handoff note across `docs/handoff-notes/`, and (4) cap output length to avoid flooding agent context.

## Open Questions
- None
