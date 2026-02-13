# AI Project Toolkit

A zero-copy-paste system for running big projects with AI coding assistants across multiple sessions. Works with both **Claude Code** and **Cursor**.

## How It Works

Both Claude Code and Cursor support two features that eliminate manual copy-paste:

| Feature | Claude Code | Cursor |
|---------|-------------|--------|
| Auto-loaded rules | `.claude/CLAUDE.md` | `.cursor/rules/project-os.mdc` |
| Slash commands | `.claude/commands/*.md` | `.cursor/commands/*.md` |

The rules file tells the AI where all project documents live and how to behave. The slash commands automate each phase of the workflow. The command format is identical for both editors.

## Quick Start

```bash
# Both editors (default)
./setup.sh ~/projects/my-new-project

# Claude Code only
./setup.sh --editor claude ~/projects/my-new-project

# Cursor only
./setup.sh --editor cursor ~/projects/my-new-project
```

## Creating a new repo
The following extends `setup.sh` to help automate the creation of a new repo, where the workflow is already setup

this does require that `gh` and `git` be installed in your environment. For more info see:

```bash
# Both Editors

```


Then open the project in your editor and run `/brainstorm`.

## The Workflow

| Step | Command | What Happens |
|------|---------|--------------|
| 1 | `/brainstorm` | AI interviews you, saves notes to `docs/brainstorm-notes.md` |
| 2 | `/vision` | AI reads the notes, creates `docs/project-brief.md` |
| 3 | `/roadmap` | AI reads the brief, creates `docs/roadmap.md` with milestones |
| 4 | `/decompose` | AI breaks a milestone into tasks in `docs/tasks/` |
| 5 | `/start TASK-01` | AI reads brief + task + last handoff, begins working |
| 6 | `/handoff` | AI writes handoff note, updates brief and lessons log |
| 7 | `/postmortem` | After a milestone: AI reviews everything, updates roadmap |

Repeat steps 5-6 for each task. Run step 7 after completing a milestone.

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

## File Structure

After setup with `--editor both` and a few sessions:

```
my-project/
├── .claude/                             ← Claude Code config
│   ├── CLAUDE.md                        ← Auto-loaded rules
│   └── commands/
│       ├── brainstorm.md
│       ├── vision.md
│       ├── roadmap.md
│       ├── decompose.md
│       ├── start.md                     ← The key one
│       ├── handoff.md
│       └── postmortem.md
├── .cursor/                             ← Cursor config
│   ├── rules/
│   │   └── project-os.mdc              ← Auto-loaded rules (alwaysApply: true)
│   └── commands/
│       ├── brainstorm.md
│       ├── vision.md
│       ├── roadmap.md
│       ├── decompose.md
│       ├── start.md
│       ├── handoff.md
│       └── postmortem.md
├── docs/                                ← Shared — works with either editor
│   ├── project-brief.md                 ← Source of truth (auto-updated)
│   ├── roadmap.md                       ← Milestones and risks
│   ├── lessons-log.md                   ← Running gotchas
│   ├── brainstorm-notes.md              ← Raw brainstorm output
│   ├── tasks/
│   │   ├── task-01.md
│   │   ├── task-02.md
│   │   └── task-03.md
│   └── handoff-notes/
│       ├── session-01.md
│       ├── session-02.md
│       └── session-03.md
└── src/                                 ← Your actual project files
```

The `docs/` folder is editor-agnostic. Team members can use different editors on the same project.

## Editor-Specific Notes

### Claude Code
- `CLAUDE.md` is auto-loaded every session — no configuration needed
- Commands appear when you type `/` in the CLI
- Use in Agent mode for best results

### Cursor
- Rules use `.mdc` files with frontmatter for scoping (`alwaysApply: true`)
- Commands appear in the `/` menu in chat
- Use in **Agent mode** (not Ask or Edit mode) for the commands to work properly
- Cursor also supports `Agent Requested` scoping if you want the rules to only load when relevant — but `alwaysApply` is simpler to start

## Sharing With Your Team

1. Put `setup.sh` somewhere everyone can access (shared drive, internal repo, etc.)
2. Tell them: "Before starting a project, run `./setup.sh --editor [your-editor] [project-folder]`."
3. Share this README.

The `docs/` folder is the same regardless of editor, so mixed teams work fine. Everyone reads and writes the same project brief, roadmap, task briefs, and handoff notes.

## Tips

- **`/start` is the most important command.** It handles all the context-loading that used to be manual. Use it at the start of every execution session.
- **`/handoff` is the most important habit.** Always run it before closing. The 2 minutes it takes saves 20 minutes next session.
- **The project brief is the single source of truth.** If it's wrong, everything downstream is wrong. Review it carefully after `/vision` and after each `/postmortem`.
- **Keep sessions short.** One task, one session. If you're tempted to squeeze in "one more thing," start a new session instead.
