# Handoff Note: Fix README Quick Start Broken Path

**Session date:** 2026-03-12
**Issue:** swe-bug-018 — README.md Quick Start references non-existent `./workflows/setup.sh`

## What Was Accomplished

Fixed the Quick Start section of `README.md` (lines 29-33). Changed the path from `./workflows/setup.sh` to `./targets/ide/install.sh` and the flag from `--expert` (singular) to `--experts` (plural), matching the actual install script.

## Acceptance Criteria Status

- [x] Quick Start commands in README.md use the correct path (`./targets/ide/install.sh`)
- [x] Flag name is `--experts` (plural), matching the install script

## Decisions Made This Session

None. Straightforward bug fix with no design decisions.

## Problems Encountered

None.

## Scope Changes

None.

## Files Modified

- `README.md` — Quick Start section: `./workflows/setup.sh` → `./targets/ide/install.sh`, `--expert` → `--experts`

## What the Next Session Needs to Know

1. swe-bug-018 is done. Three documentation bugs remain from qa-feature-017: swe-bug-019 (broken doc links, blocked by pm-feature-022), swe-bug-020 (IDE target READMEs missing SA prefix), swe-bug-021 (test plan references deleted CLAUDE.md).

2. swe-bug-020 and swe-bug-021 are independent and can be tackled in any order. swe-bug-019 is blocked on pm-feature-022 (PM needs to decide whether to create or remove the missing doc references).

## Open Questions

None.
