# Handoff Note: Define Routing for Cross-Expert Skills (team- prefix)

**Issue:** sa-feature-047 — Define Routing for Cross-Expert Skills (team- prefix)

## What Was Accomplished
Decided that `team-` prefixed skills run roleless — no expert role is loaded. These cross-expert skills rely on the always-loaded project-os context (`project-os.mdc` / `CLAUDE.md`) and their own self-contained SKILL.md instructions. Documented as ADR-010. Updated the Cursor `project-os.mdc` routing line and the Claude Code CLAUDE.md spec in the architecture.

## Acceptance Criteria Status
- [x] Decision recorded in `docs/architecture.md` on how `team-` prefixed skills are routed
- [x] `project-os.mdc` routing logic updated to reflect the decision
- [x] Approach handles the case where no expert session is active
- [x] Approach is extensible to future shared skills beyond `team-status`

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|
| ADR-010: Team-prefixed skills run roleless | Cross-expert skills should not adopt a single-expert persona. Loading any expert role adds ~70 lines of irrelevant context and wrong-persona principles. Each `team-*` SKILL.md is self-contained with its own context loading. The always-loaded project-os context provides sufficient shared principles. |
| No lightweight "team" role | Only one `team-*` skill exists (`team-status`). A team role would be premature — its content would be vague ("you are a cross-functional generalist") and add maintenance overhead for minimal value. Can be revisited if the `team-*` skill count grows significantly. |

## Downstream Impact
- **SWE (swe-feature-035):** `targets/ide/cursor/rules/project-os.mdc` already updated with the new routing line. SWE copies this file as-is during Cursor rules creation.
- **SWE (swe-feature-040/041):** Architecture's CLAUDE.md Configuration section now includes a `team-` routing bullet. SWE should include this when building the Claude Code `CLAUDE.md`.
- **No impact** on existing expert roles, skills, scripts, or the `team-status` canonical skill definition.

## Problems Encountered
None. Small, clean decision with a clear winner among the options.

## Files Created or Modified
- `docs/architecture.md` — ADR-010 added (decision table entry + body section), CLAUDE.md Configuration spec updated with `team-` routing bullet
- `targets/ide/cursor/rules/project-os.mdc` — Routing line updated from "use the current session context" to explicit roleless instruction

## What the Next Session Needs to Know
sa-feature-047 is resolved. The `team-` prefix routing is now explicitly defined for both platforms. The next task per the project brief is swe-feature-035 (Create Cursor Rules and Project Structure). When SWE creates the installed Cursor rules, the `project-os.mdc` in `targets/ide/cursor/rules/` is the source file — it already has the correct routing logic including the `team-` prefix handling.

## Open Questions
- None
