# Cursor README incorrectly describes expert rules as alwaysApply: true

**Type:** bug
**Expert:** swe
**Severity:** nit
**Milestone:** —
**Dependencies:** None

## Problem

`targets/ide/cursor/README.md` line 88 states:

> Expert role rules (e.g., `swe-os.mdc`) are also set to `alwaysApply: true`.

The actual `.mdc` files have `alwaysApply: false` — they are agent-decided rules, not always-applied. This was an intentional change during M11 (per M10 Rec 1 and the architecture design). The README text was not updated to match.

## Acceptance Criteria

- [ ] Line 88 of `targets/ide/cursor/README.md` correctly describes expert role rules as `alwaysApply: false` (agent-decided)
- [ ] The explanation matches the actual discovery mechanism (Cursor loads them when the agent identifies the relevant expert from the command prefix or user request)

## Affected Files

- `targets/ide/cursor/README.md` — line 88

## Found By

qa-session-06 observation (not filed as a formal issue at that time).
