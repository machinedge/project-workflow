# AI Project Workflow

MachinEdge's system for running big projects with AI coding assistants across multiple sessions. Works with both **Claude Code** and **Cursor**.

## How It Works

Both Claude Code and Cursor support two features that support this automated workflow:

| Feature | Claude Code | Cursor |
|---------|-------------|--------|
| Auto-loaded rules | `.claude/CLAUDE.md` | `.cursor/rules/project-os.mdc` |
| Slash commands | `.claude/commands/*.md` | `.cursor/commands/*.md` |

The rules file tells the AI where all project documents live and how to behave. The slash commands automate each phase of the workflow. Everything is maintained once — `editor.md` for the rules, `commands/` for the commands — and `setup.sh` copies them to the right place for each editor (prepending Cursor's YAML frontmatter automatically).

## Quick Start

### Existing project
```bash
# Both editors (default)
./setup.sh ~/projects/my-existing-project

# Single editor
./setup.sh --editor claude ~/projects/my-existing-project
./setup.sh --editor cursor ~/projects/my-existing-project
```

### New repo (creates GitHub repo under machinedge/)
```bash
./new_repo.sh my-new-project            # Both editors
./new_repo.sh my-new-project cursor     # Cursor only
```

Then open the project in your editor and run `/brainstorm`.

## The Workflow

| Step | Command | What Happens |
|------|---------|--------------|
| 1 | `/brainstorm` | AI interviews you, saves notes to `docs/brainstorm-notes.md` |
| 2 | `/vision` | AI reads the notes, creates `docs/project-brief.md` |
| 3 | `/roadmap` | AI reads the brief, creates `docs/roadmap.md` with milestones |
| 4 | `/decompose` | AI breaks a milestone into tasks in `docs/tasks/` |
| 5 | `/start TASK-01` | AI loads context, plans, architects, tests, implements, verifies |
| 6 | `/handoff` | AI writes handoff note, updates brief and lessons log |
| 7 | `/postmortem` | After a milestone: AI reviews everything, updates roadmap |

Repeat steps 5-6 for each task. Run step 7 after completing a milestone.

### What `/start` does (the execution loop)

`/start` isn't just "load context and go." It enforces a structured development process:

1. **Load Context** — Reads project brief, lessons log, task brief, last handoff (automatically)
2. **Plan** — Presents approach, waits for approval
3. **Architect** — Designs the solution, waits for approval
4. **Test First** — Writes unit + integration tests (expected to fail)
5. **Implement** — Writes code to make the tests pass
6. **Verify** — Runs tests, checks regressions, self-reviews
7. **Report** — Summarizes what was done, prompts for `/handoff`

Phases 2 and 3 have approval gates. Phases 4-6 flow continuously.

## What You No Longer Have to Do

- Copy-paste the project brief into every session — **auto-loaded by rules**
- Copy-paste handoff notes — **`/start` finds and reads the latest one**
- Remember which task is next — **`/start` checks the project brief's status**
- Manually update the project brief — **`/handoff` does it**
- Remember to log lessons — **`/handoff` prompts for them**

## What You Still Have to Do

- Review the AI's output (always)
- Make decisions when the AI flags uncertainties
- Run `/handoff` before closing a session (this is the one habit that matters)

## Toolkit Structure

This is what the toolkit itself looks like. You clone/download this once and use it to set up projects:

```
ai-project-toolkit/
├── editor.md                            ← Single source: AI rules (both editors)
├── commands/                            ← Single source: all slash commands
│   ├── brainstorm.md
│   ├── vision.md
│   ├── roadmap.md
│   ├── decompose.md
│   ├── start.md                         ← The key one (7-phase execution loop)
│   ├── handoff.md
│   └── postmortem.md
├── setup.sh                             ← Set up an existing project
├── new_repo.sh                          ← Create a new GitHub repo with toolkit
└── README.md                            ← This file
```

`setup.sh` copies `editor.md` as-is to `.claude/CLAUDE.md`, and prepends Cursor's YAML frontmatter to produce `.cursor/rules/project-os.mdc`. No duplication in the toolkit itself.

## Project Structure (after setup)

After running `setup.sh --editor both` and a few sessions:

```
my-project/
├── .claude/                             ← Claude Code config
│   ├── CLAUDE.md                        ← Auto-loaded rules
│   └── commands/*.md                    ← Copied from toolkit
├── .cursor/                             ← Cursor config
│   ├── rules/project-os.mdc            ← Auto-loaded rules
│   └── commands/*.md                    ← Copied from toolkit (identical files)
├── docs/                                ← Shared — works with either editor
│   ├── project-brief.md                 ← Source of truth (auto-updated)
│   ├── roadmap.md                       ← Milestones and risks
│   ├── lessons-log.md                   ← Running gotchas
│   ├── brainstorm-notes.md              ← Raw brainstorm output
│   ├── tasks/
│   │   ├── task-01.md
│   │   └── task-02.md
│   └── handoff-notes/
│       ├── session-01.md
│       └── session-02.md
└── src/                                 ← Your actual project files
```

The `docs/` folder is editor-agnostic. Team members can use different editors on the same project.

## Editor-Specific Notes

### Claude Code
- `CLAUDE.md` is auto-loaded every session — no configuration needed
- Commands appear when you type `/` in the CLI

### Cursor
- Rules use `.mdc` files with frontmatter for scoping (`alwaysApply: true`)
- Commands appear in the `/` menu in chat
- Use in **Agent mode** (not Ask or Edit mode) for the commands to work properly

## Sharing With Your Team

1. Put this toolkit somewhere everyone can access (shared drive, internal repo, etc.)
2. Tell them: run `./setup.sh --editor [your-editor] [project-folder]` before starting a project.
3. Share this README.

The `docs/` folder is the same regardless of editor, so mixed teams work fine.

## Tips

- **`/start` is the most important command.** It loads context and enforces plan → architect → test → implement → verify. Use it every execution session.
- **`/handoff` is the most important habit.** Always run it before closing. 2 minutes now saves 20 minutes next session.
- **The project brief is the single source of truth.** If it's wrong, everything downstream is wrong. Review carefully after `/vision` and `/postmortem`.
- **Keep sessions short.** One task, one session. If you're tempted to squeeze in "one more thing," start a new session instead.
