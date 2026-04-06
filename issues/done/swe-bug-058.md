# Sync check command flags intentionally excluded files as MISSING

**Type:** bug
**Expert:** swe
**Milestone:** M11
**Status:** backlog
**Severity:** should-fix

## Description

`tools/sync.sh check` (and presumably `sync.ps1 check`) compares all files in the source directory against the installed directory. It flags `.gitkeep` files and `test-scripts.sh` as `[MISSING:install]` even though these are intentionally excluded by the install script.

The install script excludes:
- `test-*` and `*.test.*` files (line 172 in `copy_scripts`)
- `.gitkeep` files (line 174 in `copy_scripts`, and implicitly by `copy_commands` which only copies `*.md`)

But the sync check doesn't apply the same exclusions, reporting false positives:
```
[MISSING:install] commands/.gitkeep
[MISSING:install] scripts/test-scripts.sh
[MISSING:install] skills/.gitkeep
```

## Files Affected

- `tools/sync.sh` — check mode file comparison
- `tools/sync.ps1` — check mode file comparison

## Acceptance Criteria

- [ ] `sync.sh check` excludes `.gitkeep` files from comparison
- [ ] `sync.sh check` excludes `test-*` and `*.test.*` files from comparison
- [ ] `sync.ps1 check` applies the same exclusions
- [ ] Running `sync.sh check` against a freshly installed project reports 0 differences (excluding settings.json which is correctly flagged for manual check)
