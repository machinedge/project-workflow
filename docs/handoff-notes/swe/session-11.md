# Handoff Note: Remove Broken Documentation Links

**Session date:** 2026-03-12
**Issue:** swe-bug-019

## What Was Accomplished

Removed all references to three non-existent documentation files (`docs/overview.md`, `docs/getting-started.md`, `docs/workflow-anatomy.md`) across 7 files, following the PM decision from pm-feature-022.

## Files Modified

| File | Change |
|------|--------|
| `README.md` | Removed 3 rows from Documentation table (overview.md, getting-started.md, workflow-anatomy.md) |
| `docs/agent-reference.md` | Rewrote 6 sentences: replaced broken links with inline content or references to existing docs |
| `CONTRIBUTING.md` | Removed workflow-anatomy.md link from skill lifecycle sentence; redirected reference section to agent-reference.md |
| `targets/autonomous/openclaw/README.md` | Replaced `docs/overview.md` reference with link to project README |
| `targets/autonomous/openclaw/install-team.sh` | Replaced `docs/getting-started.md` runtime message with inline `export GIT_TOKEN` guidance |
| `targets/autonomous/openclaw/install-team.ps1` | Replaced `docs/getting-started.md` runtime message with inline `$env:GIT_TOKEN` guidance |
| `targets/autonomous/openclaw/templates/env.template` | Removed/replaced two `docs/getting-started.md` comments |

## Acceptance Criteria Status

- [x] All references to `docs/overview.md`, `docs/getting-started.md`, and `docs/workflow-anatomy.md` removed or replaced in non-historical files
- [x] No broken doc links remain
- [x] Runtime messages in OpenClaw scripts redirected to inline guidance

## Decisions Made This Session

- OpenClaw runtime messages (install-team.sh, install-team.ps1, env.template) use inline guidance rather than redirecting to another doc, since users running those scripts shouldn't need to navigate back to the repo docs.
- In agent-reference.md, broken links were replaced with references to concrete existing resources: docs-protocol, project-manager as example, SWE start.md as reference implementation, and openclaw/README.md for translation details.

## Problems Encountered

None.

## Scope Changes

None.

## What the Next Session Needs to Know

1. swe-bug-019 is resolved. All M7 QA-found bugs (swe-bug-018 through swe-bug-021) are now complete.

2. Remaining backlog: swe-bug-023 (PM decompose skill missing Prerequisites column), qa-feature-005 (QA consistency review).

## Open Questions

None.
