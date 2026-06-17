# Data-analyst role.md has mixed command/skill treatment

**Expert:** SWE
**Type:** bug
**Priority:** should-fix
**Milestone:** Platform-Native Refactor (M11) — data-analyst cleanup

## Context

The ad-hoc session-30 cleanup (commands vs skills slash prefix) partially updated the data-analyst expert source files but left them in an inconsistent state. Three skills still have `/` prefix when they shouldn't, and the section header wasn't split into Commands/Skills like all other experts.

## Description

`experts/technical/data-analyst/role.md` has these problems:

### 1. Section not split into Commands / Skills

The section is titled "## Skills" with the intro line "The following custom commands are available:" — this needs to be split into "## Commands" and "## Skills (agent-discoverable)" with the "These are not slash commands" explainer, matching all other experts.

### 2. Three skills still have `/` prefix

Based on the classification pattern established for other experts (interactive = command, autonomous = skill):

| Name | Current | Should Be | Reason |
|------|---------|-----------|--------|
| `brief` | `/brief` | `brief` (skill) | Autonomous — generates the analysis brief from notes (like `pm-vision`) |
| `scope` | `/scope` | `scope` (skill) | Autonomous — creates the scope document (like `pm-roadmap`) |
| `synthesize` | `/synthesize` | `synthesize` (skill) | Autonomous — produces synthesis report (no user interaction needed) |

Correctly classified already:
- `/intake` — command (interactive interview)
- `/start` — command (approval-gated session)
- `decompose` — skill (autonomous) ✅
- `review` — skill (autonomous) ✅
- `handoff` — skill (autonomous) ✅

### 3. Skill file titles still have `/`

- `skills/brief.md` line 1: `# /brief — ...` → should be `# brief — ...`
- `skills/scope.md` line 1: `# /scope — ...` → should be `# scope — ...`
- `skills/synthesize.md` line 1: `# /synthesize — ...` → should be `# /synthesize — ...`

### 4. Cross-references within skill files are inconsistent

- `skills/intake.md` line 9 references `review` (correct, no `/`) alongside `/synthesize` (incorrect, should be `synthesize`)
- `skills/scope.md` line 8 references `/brief` (incorrect if brief is a skill, should be `brief`)

## Files to Fix

- `experts/technical/data-analyst/role.md` — split section, fix prefixes
- `experts/technical/data-analyst/skills/brief.md` — remove `/` from title
- `experts/technical/data-analyst/skills/scope.md` — remove `/` from title, fix `/brief` cross-ref
- `experts/technical/data-analyst/skills/synthesize.md` — remove `/` from title
- `experts/technical/data-analyst/skills/intake.md` — fix `/synthesize` cross-ref

## Acceptance Criteria

- [ ] `role.md` has separate "## Commands" and "## Skills (agent-discoverable)" sections
- [ ] Only `/intake` and `/start` have `/` prefix (commands)
- [ ] `brief`, `scope`, `decompose`, `review`, `handoff`, `synthesize` listed without `/` (skills)
- [ ] Skill file titles (`# /brief`, `# /scope`, `# /synthesize`) have `/` removed
- [ ] Cross-references in all data-analyst skill files are consistent (commands keep `/`, skills don't)
