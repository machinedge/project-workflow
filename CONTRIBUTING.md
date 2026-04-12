# Contributing

The best way to contribute is to install the workflow into a real project, use it, and improve what doesn't work.

## Getting Started

1. Clone this repo
2. Install into a project:
   ```bash
   ./targets/ide/install.sh ~/projects/my-app
   ```
3. Use it — run `/pm-interview` to start a new project, `/swe-start` to pick up a task, etc.
4. When something is wrong or missing, fix it in the source files under `targets/ide/cursor/` or `targets/ide/claude-code/` and re-install.

## Repository Layout

```
targets/ide/
  install.sh / install.ps1       # Installs into a project
  cursor/                        # Cursor platform-native implementation
    rules/                       # Expert role rules (.mdc)
    commands/                    # Explicit command files
    skills/                      # Discoverable skill folders (SKILL.md)
    scripts/                     # Mechanical shell scripts
  claude-code/                   # Claude Code platform-native implementation
    CLAUDE.md                    # Shared principles + expert routing
    settings.json                # Hook definitions
    roles/                       # Expert role files
    commands/                    # Explicit command files
    skills/                      # Discoverable skill folders (SKILL.md)
    scripts/                     # Mechanical shell scripts
docs/                            # Project documentation and architecture
issues/                          # Issue tracking (file-based)
```

## What to Modify

Each platform has its own first-class implementation. Changes go directly into the platform files:

- **Rules/Roles** define expert identity, session protocols, and principles. Cursor uses `.mdc` rules with YAML frontmatter; Claude Code uses plain markdown role files.
- **Commands** are explicit workflows invoked by the user via `/command-name`. Used for `/start` sessions and interactive workflows (interviews, deployments).
- **Skills** are `SKILL.md` files with YAML frontmatter that the agent discovers and invokes autonomously. Used for handoffs, reviews, roadmaps, and other operations that don't need explicit invocation.
- **Scripts** are hidden shell utilities (`.sh` + `.ps1` companions) for mechanical operations — issue numbering, file movement, session claiming.

When modifying an expert, update both platforms to keep them aligned. Use existing experts as reference — the PM is the most complete, the SWE is the simplest.

## PR Checklist

- [ ] Changes made in both `targets/ide/cursor/` and `targets/ide/claude-code/`
- [ ] Tested by installing into a real project and running through the affected workflow
- [ ] No stale references to removed files or directories
- [ ] Skills have clear `description` fields that answer "what does this do?" and "when should the agent use it?"

## Reference

- [Cursor README](targets/ide/cursor/README.md) — what gets installed, how rules/skills/commands/scripts work
- [Claude Code README](targets/ide/claude-code/README.md) — what gets installed, hooks, settings.json
- [Agent Reference](docs/agent-reference.md) — for AI assistants working on this repo
- [Architecture](docs/architecture.md) — system architecture and key decisions
