# Software Engineering (SWE) Project Workflow

MachinEdge's system for running big projects with AI coding assistants across multiple sessions. Works with both **Claude Code** and **Cursor**.

## How It Works

Both Claude Code and Cursor support two features that support this automated workflow:

| Feature | Claude Code | Cursor |
|---------|-------------|--------|
| Auto-loaded rules | `.claude/CLAUDE.md` | `.cursor/rules/project-os.mdc` |
| Slash commands | `.claude/commands/*.md` | `.cursor/commands/*.md` |

The rules file tells the AI where all project documents live and how to behave. The slash commands automate each phase of the workflow. Everything is maintained once — `editor.md` for the rules, `commands/` for the commands — and the setup script copies them to the right place for each editor (prepending Cursor's YAML frontmatter automatically).

## Quick Start

### Existing project

**macOS / Linux:**
```bash
./setup.sh ~/projects/my-existing-project                       # Both editors (default)
./setup.sh --editor claude ~/projects/my-existing-project       # Claude Code only
./setup.sh --editor cursor ~/projects/my-existing-project       # Cursor only
```

**Windows (PowerShell):**
```powershell
.\setup.ps1 -Target ~\projects\my-existing-project                            # Both editors (default)
.\setup.ps1 -Editor claude -Target ~\projects\my-existing-project             # Claude Code only
.\setup.ps1 -Editor cursor -Target ~\projects\my-existing-project             # Cursor only
```

### New repo (creates GitHub repo under your org/user)

First, set your GitHub org or username. You can either export it in your shell profile (set once, used everywhere):

```bash
# .bashrc / .zshrc
export GITHUB_ORG="your-org-or-username"
```

```powershell
# PowerShell profile
$env:GITHUB_ORG = "your-org-or-username"
```

Or pass it per-invocation with `--org` / `-Org`.

**macOS / Linux:**
```bash
./new_repo.sh my-new-project                        # Uses $GITHUB_ORG, both editors
./new_repo.sh --org mycompany my-new-project        # Explicit org
./new_repo.sh --editor cursor my-new-project        # Cursor only
./new_repo.sh --org mycompany --editor claude app   # All flags
```

**Windows (PowerShell):**
```powershell
.\new_repo.ps1 my-new-project                       # Uses $env:GITHUB_ORG, both editors
.\new_repo.ps1 -Org mycompany my-new-project        # Explicit org
.\new_repo.ps1 -Editor cursor my-new-project        # Cursor only
.\new_repo.ps1 -Org mycompany -Editor claude app    # All flags
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
| 7 | `/review TASK-01` | *(Optional)* Fresh-eyes code review in a new session |
| 8 | `/postmortem` | After a milestone: AI reviews everything, updates roadmap |

Repeat steps 5-6 for each task. Run step 7 occasionally — after a tricky task, or before a milestone review. Run step 8 after completing a milestone.

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

### What `/review` does (the fresh-eyes pass)

`/review` is designed to run in a **separate session** from the one that wrote the code. This gives you genuine fresh-eyes review — the AI has no memory of the implementation decisions, shortcuts, or context from the original session.

Run it one of two ways:
- **Single task:** `/review TASK-03` — focused review of one task's output
- **Cumulative:** `/review TASK-01 through TASK-04` — cross-task consistency check

It evaluates: correctness, test coverage, security, consistency with the rest of the codebase, technical debt, and architecture fit. Findings are categorized as Must Fix / Should Fix / Nits. It does not auto-fix — fixes go through a proper `/start` session.

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
│   ├── review.md                        ← Fresh-eyes code review (separate session)
│   ├── handoff.md
│   └── postmortem.md
├── setup.sh                             ← Set up an existing project (macOS/Linux)
├── setup.ps1                            ← Set up an existing project (Windows)
├── new_repo.sh                          ← Create a new GitHub repo with toolkit (macOS/Linux)
├── new_repo.ps1                         ← Create a new GitHub repo with toolkit (Windows)
└── README.md                            ← This file
```

`setup.sh` (or `setup.ps1` on Windows) copies `editor.md` as-is to `.claude/CLAUDE.md`, and prepends Cursor's YAML frontmatter to produce `.cursor/rules/project-os.mdc`. No duplication in the toolkit itself.

## Project Structure (after setup)

After running `setup.sh --editor both` (or `setup.ps1 -Editor both` on Windows) and a few sessions:

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
2. Tell them to run the setup script before starting a project:
   - **macOS / Linux:** `./setup.sh --editor [your-editor] [project-folder]`
   - **Windows:** `.\setup.ps1 -Editor [your-editor] -Target [project-folder]`
3. Share this README.

The `docs/` folder is the same regardless of editor, so mixed teams work fine.

## Prerequisites

- **Git** — installed and configured
- **GitHub CLI (`gh`)** — required for `new_repo` scripts ([install](https://cli.github.com/))
- **`GITHUB_ORG`** — set this environment variable to your GitHub org or username (required for `new_repo` scripts, or pass `--org` / `-Org` each time)
- **macOS / Linux:** Bash
- **Windows:** PowerShell 5.1+ (ships with Windows 10/11) or PowerShell 7+

## Tips

- **`/start` is the most important command.** It loads context and enforces plan → architect → test → implement → verify. Use it every execution session.
- **`/handoff` is the most important habit.** Always run it before closing. 2 minutes now saves 20 minutes next session.
- **`/review` works best in a fresh session.** Don't run it in the same session that wrote the code — the whole point is fresh eyes without implementation bias.
- **The project brief is the single source of truth.** If it's wrong, everything downstream is wrong. Review carefully after `/vision` and `/postmortem`.
- **Keep sessions short.** One task, one session. If you're tempted to squeeze in "one more thing," start a new session instead.
