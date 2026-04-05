# SWE: Update outdated README files in both IDE target directories

**Type:** techdebt
**Expert:** swe
**Milestone:** M11
**Severity:** nit

## Description

Both `targets/ide/cursor/README.md` and `targets/ide/claude-code/README.md` describe the pre-M11 translation pipeline, not the current platform-native implementation. The content is factually incorrect following the platform-native refactor (ADR-008).

## Specific Issues

1. Opening line says "Translation rules for generating [platform] configurations from platform-agnostic expert definitions" — these are now platform-native implementations, not translations
2. "the [platform] translation logic lives inline in `install.sh`" — install is now direct copy, not translation
3. Output paths don't mention `skills/`, `scripts/`, or `settings.json` (Claude Code)
4. "The prefix is applied by the install script during translation" — prefixes are baked into the files
5. Skill Namespacing table references Data Analyst and User Experience experts which are out of scope for M11

## Acceptance Criteria

- [ ] Both READMEs accurately describe the platform-native implementation model
- [ ] Output paths include all file categories (rules/roles, commands, skills, scripts, and platform-specific files)
- [ ] No references to translation pipeline or `experts/` as source
- [ ] Skill table reflects only in-scope experts (PM, SWE, QA, DevOps, SA, team)

## Notes

**Found by:** qa-feature-042 (Claude Code QA review)
**Affects:** Both `targets/ide/cursor/README.md` and `targets/ide/claude-code/README.md`
