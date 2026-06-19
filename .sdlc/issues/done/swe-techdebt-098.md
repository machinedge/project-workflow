# TECHDEBT: Claimed verification artifact test-sdlc-boundary.sh does not exist in the repo

**Type:** techdebt
**Expert:** swe
**Status:** done
**Severity:** should-fix

## Description

`swe-bug-095` (the must-fix bug the QA audit found and resolved in-session) states "test-sdlc-boundary.sh now passes all 41 tests." That script is neither in the working tree nor git-tracked (`git ls-files` finds nothing matching). Either the test harness was deleted before commit or the claim is aspirational. Without the script, the "all 41 tests pass" assertion is unverifiable.

## Location

`.sdlc/issues/done/swe-bug-095.md:28` (claims "41 tests" pass)

## Acceptance Criteria

- [ ] Either the test script is recovered and committed (so the 41-test regression gate is reproducible), or the issue note is corrected to describe what was actually run
- [ ] If recovered, the script lives in a tracked path and `git ls-files` finds it

## Notes

**Found by:** SWE review of M19 SDLC boundary.
**Recommendation:** Recover and commit the harness, or correct the unverifiable claim in the done issue.
