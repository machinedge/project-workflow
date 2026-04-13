# Handoff Note: Cursor README alwaysApply Fix

**Issue:** swe-bug-062 — Cursor README incorrectly describes expert rules as alwaysApply: true

## What Was Accomplished

Fixed line 88 of `targets/ide/cursor/README.md` to correctly describe expert role rules as `alwaysApply: false` (agent-decided), and updated the explanation to reflect that only the matching role is loaded — not all of them.

## Acceptance Criteria Status
- [x] Line 88 of `targets/ide/cursor/README.md` correctly describes expert role rules as `alwaysApply: false` (agent-decided)
- [x] The explanation matches the actual discovery mechanism (Cursor loads them when the agent identifies the relevant expert from the command prefix or user request)

## Decisions Made This Session

None. Mechanical fix matching existing `.mdc` frontmatter.

## Problems Encountered

None.

## Scope Changes

None. Single-line documentation fix as scoped.

## Files Created or Modified

| File | Change |
|------|--------|
| `targets/ide/cursor/README.md` | Line 88: `alwaysApply: true` → `alwaysApply: false` (agent-decided); updated explanation of discovery mechanism |

**Total: 1 file changed**

## What the Next Session Needs to Know

1. swe-bug-062 is complete. No remaining backlog issues.
2. All planned milestones (M1-M11) are delivered. No next milestone is planned.
3. Open items from pm-session-02: Data Analyst and UX expert completion (no milestone), Claude Code `Stop` hook (deferred), PowerShell testing on Windows (no mitigation planned).

## Open Questions

None.
