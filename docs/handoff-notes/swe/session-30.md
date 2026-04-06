# Handoff Note: Commands vs Skills — Slash Prefix Cleanup

**Issue:** Ad-hoc — no issue file (user-initiated agent run)

## What Was Accomplished

Separated commands from skills across all role files, rules, SKILL.md files, command files, and READMEs. Previously, all 30 expert capabilities (9 commands + 21 skills) were listed with `/` slash prefix, making them all look like slash commands. Now only the 9 real commands keep the `/` prefix; the 21 agent-discoverable skills use plain names without `/`.

## Acceptance Criteria Status

No formal issue — this was ad-hoc. The intent was:
- [x] Rules files split "## Skills" into "## Commands" + "## Skills (agent-discoverable)"
- [x] Only real commands (9) keep `/` prefix
- [x] Skills (21) listed without `/`, with bold formatting and explicit "not slash commands" note
- [x] Cross-references in command files updated (handoff refs)
- [x] Cross-references in SKILL.md files updated (skill-to-skill refs)
- [x] READMEs updated to clarify distinction
- [x] "Using these commands by platform" subsections removed from source expert role files
- [x] Desktop-cli SKILL.md table split into Commands and Agent Skills columns

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|
| Skills listed as `**bold-name**` without `/` prefix | Visually distinct from commands; makes clear these aren't slash-invocable |
| Added "These are not slash commands" explainer under each Skills section | Explicit instruction to agent prevents confusion |
| Removed "Using these commands by platform" subsection from source roles | This subsection incorrectly implied all skills were slash commands |
| Historical docs (handoff notes, interview notes) left unchanged | These are records of past sessions, not active instructions |
| Workspace `.cursor/commands/` left unchanged | This dev repo has all 30 as commands intentionally for development |

## Problems Encountered

None. Changes were mechanical and systematic.

## Scope Changes

Scope expanded from initial ask (just rules files) to include:
- Command file cross-references (handoff prompts)
- SKILL.md cross-references (skill-to-skill chaining)
- Desktop-cli SKILL.md expert table
- Cursor README skill discovery description

## Files Created or Modified

### Rules / Role files (18 files)
- `.cursor/rules/project-os.mdc` — split Available Skills into Commands + Skills sections
- `.cursor/rules/{project-manager,swe,qa,devops,system-architect}-os.mdc` — split Skills into Commands + Skills, removed "Using these commands by platform"
- `targets/ide/cursor/rules/project-os.mdc` — updated Skills description
- `targets/ide/cursor/rules/{project-manager,swe,qa,devops,system-architect}-os.mdc` — same split
- `targets/ide/claude-code/CLAUDE.md` — updated Skills description
- `targets/ide/claude-code/roles/{project-manager,swe,qa,devops,system-architect}.md` — same split

### Source expert roles (5 files)
- `experts/technical/{project-manager,swe,qa,devops,system-architect}/role.md` — same split, removed platform instructions

### Command files (10 files)
- `targets/ide/cursor/commands/{pm,swe,qa,ops,sa}-start.md` — handoff refs changed from `/XX-handoff` to `XX-handoff` skill
- `targets/ide/claude-code/commands/{pm,swe,qa,ops,sa}-start.md` — same

### Command files with skill cross-refs (8 files)
- `targets/ide/{cursor,claude-code}/commands/{pm-interview,pm-add-feature,ops-env-discovery,ops-deploy,sa-start}.md` — skill refs updated

### SKILL.md files (16 files)
- `targets/ide/{cursor,claude-code}/skills/{pm-roadmap,pm-update-plan,qa-regression,qa-review,sa-research,sa-review,sa-update,team-status}/SKILL.md` — cross-refs updated

### Source expert skills (16 files)
- `experts/technical/*/skills/*.md` — cross-refs updated
- `experts/technical/shared/{docs-protocol.md,skills/status.md}` — cross-refs updated
- `experts/technical/data-analyst/{role.md,skills/*.md}` — cross-refs and headings updated

### READMEs (3 files)
- `README.md` — clarified skills don't appear in `/` menu; changed `/team-status` to natural language
- `targets/ide/cursor/README.md` — fixed skill invocation claim
- `targets/desktop-cli/claude/SKILL.md` — expert table split into Commands + Agent Skills columns

**Total: 79 files changed, 257 insertions, 202 deletions**

## What the Next Session Needs to Know

1. The workspace `.cursor/commands/` directory still has all 30 capabilities as commands (including skills). This is intentional for development of the toolkit itself — when working ON this repo, you want all skills accessible as commands. Target projects installed via `install.sh` will get the correct 9 commands + 21 skills split.
2. Historical docs (`docs/handoff-notes/`, `docs/interview-notes-*`, `docs/architecture.md`) still have old `/skill-name` references. These were deliberately left unchanged as historical records.
3. The data-analyst expert (under development) had some inconsistent handling — `decompose`, `review`, `handoff` lost their `/` but `intake`, `brief`, `scope`, `start`, `synthesize` still have `/` in some places. QA should verify consistency.
4. This work needs QA review before merging — see `issues/backlog/qa-feature-059.md`.

## Open Questions

- [ ] Should the workspace `.cursor/commands/` files also be updated to match the new cross-reference style? (Currently they're separate copies used for dev)
- [ ] Should the data-analyst expert have its own commands vs skills classification? (It's under development and has no command/skill files in targets yet)
