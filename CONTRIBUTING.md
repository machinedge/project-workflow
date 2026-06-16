# Contributing

The best way to contribute is to install the workflow into a real project, use it, and improve what doesn't work.

## Getting Started

1. Clone this repo
2. Install into a project:
   ```bash
   ./install.sh ~/projects/my-app
   ```
3. Use it — run `/pm-interview` to start a new project, `/swe-start` to pick up a task, etc.
4. When something is wrong or missing, fix it in the source files under `agents/` and re-install.

## Repository Layout

```
install.sh / install.ps1         # Installs agents/ into a project
agents/                          # Single source of truth (harness-neutral)
  AGENTS.md                      # Operating-system file — expert routing + conventions
  settings.json                  # Claude Code SessionStart hook definition
  roles/                         # Expert role files (.md)
  commands/                      # Explicit command files (.md)
  skills/                        # Discoverable skill folders (SKILL.md)
  scripts/                       # Mechanical shell scripts (.sh + .ps1)
docs/                            # Project documentation and architecture
.workflow/                       # Managed artifacts (issues, handoff notes, lessons log)
```

The installer copies `agents/` to `.agents/` in the target project, writes a top-level `AGENTS.md`, symlinks `CLAUDE.md → AGENTS.md`, and (unless `--no-claude`) symlinks `.claude/{commands,skills,roles,scripts}` into `.agents/` for native Claude Code discovery.

## What to Modify

There is one implementation. Changes go directly into `agents/`:

- **AGENTS.md** is the operating-system file — expert routing table and shared conventions. Reference `.agents/...` paths so they resolve for every harness.
- **Roles** define expert identity, session protocols, and principles (plain markdown).
- **Commands** are explicit workflows invoked by the user via `/command-name`. Used for `/start` sessions and interactive workflows (interviews, deployments).
- **Skills** are `SKILL.md` files with YAML frontmatter that the agent discovers and invokes autonomously. Used for handoffs, reviews, roadmaps, and other operations that don't need explicit invocation.
- **Scripts** are hidden shell utilities (`.sh` + `.ps1` companions) for mechanical operations — issue numbering, file movement, session claiming.

Use existing experts as reference — the PM is the most complete, the SWE is the simplest.

## PR Checklist

- [ ] Changes made in `agents/` (the single source of truth)
- [ ] Path references use `.agents/` (not `.claude/` or `.cursor/`) so they resolve across harnesses
- [ ] Tested by installing into a real project and running through the affected workflow
- [ ] No stale references to removed files or directories
- [ ] Skills have clear `description` fields that answer "what does this do?" and "when should the agent use it?"

## Reference

- [Agent Reference](docs/agent-reference.md) — for AI assistants working on this repo
- [Architecture](docs/architecture.md) — system architecture and key decisions
