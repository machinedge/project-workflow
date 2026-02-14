# Test Workflow Workflow

<!-- GUIDE: Write a 1-2 sentence description of what this workflow is for. -->
A structured workflow for running test-workflow projects with AI coding assistants. Works with **Claude Code** and **Cursor**.

## Why This Exists

<!-- GUIDE: Explain the problem this workflow solves. What goes wrong without structure?
     What makes this type of work multi-session? Why does the AI need a protocol? -->

## How It Works

Both editors use the same underlying system:

- **`editor.md`** contains the operating rules (copied to `.claude/CLAUDE.md` and `.cursor/rules/test-workflow-os.mdc`)
- **`commands/*.md`** define the slash commands (copied to both editors)
- **`setup.sh`** / **`setup.ps1`** handles the copying

Maintain files once in this toolkit, deploy to both editors automatically.

## Workflow

### Planning Phase

| Step | Command | What It Does | Output |
|------|---------|-------------|--------|
| 1 | `/interview` | Structured interview to understand goals, context, and constraints | `docs/interview-notes.md` |
| 2 | `/brief` | Generate the project brief from interview notes | `docs/project-brief.md` |
| 3 | `/plan` | Create the milestone plan with dependencies and risks | `docs/plan.md` |
| 4 | `/decompose` | Break milestone into GitHub Issues | GitHub Issues |

### Execution Phase

| Step | Command | What It Does | Output |
|------|---------|-------------|--------|
| 5 | `/start #N` | Run a 7-phase execution session | Work products + updated docs |
| 6 | `/handoff` | Close session, document what was done | Handoff note + issue updates |

### Review & Synthesis

| Step | Command | What It Does | Output |
|------|---------|-------------|--------|
| 7 | `/review #N` | Fresh-eyes review (separate session) | Must-fix / should-fix issues |
| 8 | `/synthesis` | Review completed milestone and synthesize results | Final output |

## Setup

### Add to an existing project

```bash
# Both editors (default)
./setup.sh ~/my-project

# Claude Code only
./setup.sh --editor claude ~/my-project

# Cursor only
./setup.sh --editor cursor ~/my-project
```

Windows:
```powershell
.\setup.ps1 -Target ~\my-project
.\setup.ps1 -Editor claude -Target ~\my-project
```

### Create a new repo

```bash
# Requires: git, gh CLI, GITHUB_ORG env var (or --org flag)
./new_repo.sh my-project
./new_repo.sh --org mycompany --editor claude my-project
```

Windows:
```powershell
.\new_repo.ps1 my-project
.\new_repo.ps1 -Org mycompany -Editor claude my-project
```

## Project Structure (After Setup)

```
my-project/
├── .claude/
│   ├── CLAUDE.md                    # Auto-loaded rules for Claude Code
│   └── commands/*.md                # Slash commands
├── .cursor/
│   ├── rules/test-workflow-os.mdc # Auto-loaded rules for Cursor
│   └── commands/*.md                # Slash commands
├── docs/
│   ├── project-brief.md               # Source of truth
│   ├── plan.md                # Milestones and risks
│   ├── lessons-log.md               # Running gotchas
│   ├── interview-notes.md               # Interview notes
│   └── handoff-notes/
│       ├── session-01.md
│       └── session-02.md
└── (GitHub Issues)                  # Tasks + review findings
```

## Prerequisites

- Git (installed and configured)
- GitHub CLI (`gh`) — required for issue tracking ([install](https://cli.github.com/))
- `GITHUB_ORG` environment variable set (or pass `--org` each time)
<!-- GUIDE: Add domain-specific prerequisites here (Python, Node, etc.) -->

## License

Apache 2.0 — see [LICENSE](../../LICENSE).
