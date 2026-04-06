# QA Review: Commands vs Skills Slash Prefix Cleanup

**Expert:** QA
**Type:** feature (review)
**Priority:** should-fix
**Milestone:** Platform-Native Refactor (M11)

## Context

An ad-hoc agent session modified 79 files to separate commands (slash-invocable) from skills (agent-discoverable) across all role files, rules, SKILL.md files, command files, and READMEs. The change removes `/` prefix from skill references and adds explicit "not slash commands" messaging.

See `docs/handoff-notes/swe/session-30.md` for full details.

## What to Review

### 1. Consistency across platforms
- Cursor target rules (`targets/ide/cursor/rules/*.mdc`) and Claude Code target roles (`targets/ide/claude-code/roles/*.md`) should have identical Commands/Skills splits
- Both platforms' command files should use same wording for skill cross-references
- Both platforms' SKILL.md files should use same wording for skill cross-references

### 2. Correct classification
Verify these 9 are listed as **commands** (with `/` prefix):
- `pm-start`, `pm-interview`, `pm-add-feature`
- `swe-start`
- `qa-start`
- `ops-start`, `ops-env-discovery`, `ops-deploy`
- `sa-start`

Verify these 21 are listed as **skills** (without `/` prefix):
- All handoffs (pm, swe, qa, ops, sa)
- pm-vision, pm-roadmap, pm-decompose, pm-update-plan, pm-postmortem
- qa-review, qa-test-plan, qa-regression, qa-bug-triage
- ops-pipeline, ops-release-plan
- sa-design, sa-research, sa-review, sa-update
- team-status

### 3. Cross-reference accuracy
- Command files that reference skills should NOT use `/` for skill names
- Command files that reference other commands SHOULD keep `/`
- SKILL.md files that reference skills should NOT use `/`
- SKILL.md files that reference commands SHOULD keep `/`

### 4. Source expert consistency
- `experts/technical/*/role.md` — same Commands/Skills split
- `experts/technical/*/skills/*.md` — cross-refs updated
- Data-analyst expert — check for inconsistent treatment (some skills may still have `/`)

### 5. No regressions
- README quick start examples still reference real commands
- Desktop-cli SKILL.md table is accurate
- Cursor README skill discovery section is accurate
- No broken markdown formatting from edits

## Acceptance Criteria

- [ ] All 9 commands correctly listed with `/` prefix across all role/rules files (both platforms + source)
- [ ] All 21 skills correctly listed without `/` prefix across all role/rules files (both platforms + source)
- [ ] Cross-references in command files correctly distinguish commands (keep `/`) from skills (no `/`)
- [ ] Cross-references in SKILL.md files correctly distinguish commands from skills
- [ ] Cursor and Claude Code implementations are consistent with each other
- [ ] Data-analyst source files are consistent (no mixed treatment)
- [ ] No broken markdown formatting
- [ ] READMEs accurately describe the commands vs skills distinction
