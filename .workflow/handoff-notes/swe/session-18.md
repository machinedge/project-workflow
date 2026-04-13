# Handoff Note: Create Cursor Rules and Project Structure

**Issue:** swe-feature-035 — Create Cursor Rules and Project Structure

## What Was Accomplished

Created 6 Cursor-native rule files in `targets/ide/cursor/rules/` implementing the platform-native architecture from sa-feature-033. Applied all four M10 context optimization recommendations: conditional expert rules, simplified session protocols, scoped handoff loading, and QA bug fix. Absorbed `docs-protocol.md` content into the rules. Set up the full `targets/ide/cursor/` directory structure with placeholder directories for commands and skills.

## Acceptance Criteria Status

- [x] `project-os.mdc` is `alwaysApply: true` — routes to correct expert, references skill discovery
- [x] 5 expert rule files are conditional (`alwaysApply: false`) with description-based agent discovery
- [x] QA rule file includes own handoff notes in session protocol (M10 Rec 4 fix)
- [x] PM and SA rules scope handoff loading to own subdirectory only (M10 Rec 3)
- [x] Session protocol document-loading instructions removed from rules — defers to `/prefix-start` and individual skills (M10 Rec 2)
- [x] `targets/ide/cursor/` directory structure matches sa-feature-033 design (rules/, commands/, skills/, scripts/)
- [x] `docs-protocol` content integrated — conventions absorbed into `project-os.mdc`, no references to `experts/technical/shared/docs-protocol.md`
- [x] Existing functionality preserved — live `.cursor/rules/` files untouched

## Decisions Made This Session

| Decision | Reasoning |
|----------|-----------|
| Absorbed docs-protocol into `project-os.mdc` rather than creating a separate rule | Handoff note conventions, issues conventions, workflow contracts, and shared principles fit naturally into the always-applied router. Avoids an extra file. |
| PM Document Locations no longer lists cross-expert handoffs as consumed | Rec 3 scoping — cross-expert handoffs are consumed by specific skills (`/pm-postmortem`) not at startup. Document Locations should reflect key startup artifacts. |
| SA Document Locations no longer lists cross-expert handoffs as consumed | Same reasoning as PM. SA-specific skills like `/sa-review` load cross-expert handoffs on demand. |
| DevOps Document Locations retains cross-expert handoffs (SWE, QA) | DevOps commonly needs to know what was built and what quality gates passed. M10 didn't recommend scoping DevOps handoff loading. |

## Problems Encountered

None. The architecture doc (sa-feature-033) was detailed enough that implementation was straightforward.

## Files Created or Modified

- `targets/ide/cursor/rules/project-os.mdc` — Always-applied router (44 lines)
- `targets/ide/cursor/rules/project-manager-os.mdc` — Agent-decided PM role (53 lines)
- `targets/ide/cursor/rules/swe-os.mdc` — Agent-decided SWE role (47 lines)
- `targets/ide/cursor/rules/qa-os.mdc` — Agent-decided QA role (55 lines)
- `targets/ide/cursor/rules/devops-os.mdc` — Agent-decided DevOps role (56 lines)
- `targets/ide/cursor/rules/system-architect-os.mdc` — Agent-decided SA role (51 lines)
- `targets/ide/cursor/commands/.gitkeep` — Empty directory for downstream tasks
- `targets/ide/cursor/skills/.gitkeep` — Empty directory for downstream tasks
- `issues/backlog/sa-feature-047.md` — New SA issue for `team-` prefix routing

## What the Next Session Needs to Know

1. **Context reduction:** Always-loaded context dropped from ~422 lines (6 rules, all `alwaysApply: true`) to ~44 lines (1 rule). Expert roles load on demand. ~90% reduction.
2. **Downstream tasks ready:** `commands/` and `skills/` directories exist with `.gitkeep` placeholders. swe-feature-036 (commands) and swe-feature-037/038 (skills) can populate them.
3. **Live `.cursor/rules/` untouched.** The new rules are in `targets/ide/cursor/rules/` only. The install script update (swe-feature-044) will handle copying these to user projects.
4. **sa-feature-047 filed** for `team-` prefix routing — the System Architect should decide how cross-expert skills are routed when no expert session is active.
5. **All expert rules use platform prefixes** (`/pm-start`, `/swe-handoff`, `/ops-deploy`, etc.) — consistent with the platform-native convention. Downstream command and skill files should match these names.

## Open Questions

- [ ] sa-feature-047: How should `team-` prefixed skills be routed when no expert session is active?
