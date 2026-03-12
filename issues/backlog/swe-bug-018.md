# BUG: README.md Quick Start references non-existent `./workflows/setup.sh`

**Type:** bug
**Expert:** swe
**Milestone:** M7
**Status:** backlog
**Severity:** must-fix

## Description

The Quick Start section of `README.md` (lines 28-33) references `./workflows/setup.sh`, which does not exist and has never existed in the repo. The correct path after the deployment restructure is `./targets/ide/install.sh`.

Also uses `--expert` (singular) instead of `--experts` (plural), which is the actual flag name in the script.

## Current (broken)

```bash
./workflows/setup.sh ~/projects/my-app
./workflows/setup.sh --expert swe ~/projects/my-app
```

## Expected (fixed)

```bash
./targets/ide/install.sh ~/projects/my-app
./targets/ide/install.sh --experts swe ~/projects/my-app
```

## Acceptance Criteria

- [ ] Quick Start commands in README.md use the correct path (`./targets/ide/install.sh`)
- [ ] Flag name is `--experts` (plural), matching the install script

## Notes

**Found by:** qa-feature-017
**File:** `README.md`, lines 28-33
