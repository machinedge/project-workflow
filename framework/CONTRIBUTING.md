# Contributing a Workflow

This guide walks through creating a new workflow for this toolkit. Whether you're building a DevOps pipeline workflow, a research methodology, or something else entirely, the process is the same.

## Quick Start

```bash
# 1. Scaffold a new workflow
./framework/create-workflow.sh my-workflow

# 2. Customize the generated files
#    (see "What to Customize" below)

# 3. Validate your workflow
./framework/validate.sh my-workflow
```

On Windows:
```powershell
.\framework\create-workflow.ps1 my-workflow
.\framework\validate.sh my-workflow   # validation is bash-only for now
```

## What the Scaffold Creates

Running `create-workflow.sh my-workflow` generates:

```
my-workflow/
├── editor.md                  # Operating rules for the AI
├── README.md                  # Workflow documentation
├── setup.sh / setup.ps1       # Install scripts
├── new_repo.sh / new_repo.ps1 # New repo scripts
└── commands/
    ├── interview.md           # Structured interview
    ├── brief.md               # Synthesize into source-of-truth
    ├── plan.md                # Define work structure
    ├── decompose.md           # Break into GitHub Issues
    ├── start.md               # 7-phase execution
    ├── review.md              # Fresh-eyes review
    ├── handoff.md             # Session close + handoff note
    └── synthesis.md           # Milestone/phase capstone
```

Every file is pre-populated with structural patterns and `<!-- GUIDE: ... -->` comments explaining what to put where. Delete the guide comments as you fill in real content.

## What to Customize

### 1. Rename Commands (optional)

The scaffold uses generic names (`interview`, `brief`, `plan`, `synthesis`). Rename them to match your domain:

| Generic | SWE Equivalent | EDA Equivalent | Your Workflow |
|---------|----------------|----------------|---------------|
| `interview` | `brainstorm` | `intake` | ? |
| `brief` | `vision` | `brief` | ? |
| `plan` | `roadmap` | `scope` | ? |
| `synthesis` | `postmortem` | `synthesize` | ? |

If you rename a command file, update the command list in `editor.md` to match.

### 2. Customize `editor.md`

This is the operating rules file that the AI reads every session. Focus on:

**Document Locations** — What documents does your workflow need? Every workflow needs a brief, lessons log, and handoff notes. Add domain-specific documents (data profiles, domain context, technical specs, etc.).

**Session Protocol** — What should the AI read at the start of every session? What should it do during? What should it produce at the end?

**Slash Commands** — List every command with a 1-line description.

**Principles** — What are the non-negotiable behavioral rules? Keep the universal ones (no memory, brief is source of truth, verification required) and add domain-specific ones.

**Opinionated Stack** (optional) — Does your workflow prescribe specific tools? List them.

### 3. Customize the Commands

Each command file has `<!-- GUIDE: ... -->` comments explaining what to customize. The key decisions for each:

**Interview command** — What categories do you interview about? SWE asks about Problem, Audience, Scope. EDA asks about Application Domain, Data, Questions. What does your domain need?

**Brief command** — What sections should the source-of-truth document have? What's the right structure for your domain?

**Plan command** — What do you call a chunk of work? (Milestone, phase, sprint, cycle?) How many is typical? What risks matter in your domain?

**Start command** — This is the most important one. The 7-phase structure should stay, but rename and customize the phases:

| Phase | Purpose | Customize |
|-------|---------|-----------|
| 1. Load Context | Read all documents | Add domain-specific docs to read |
| 2. Plan/Hypothesize | State approach before working | Rename; adjust what the AI presents |
| 3. Design/Architect | Design the solution | Rename; adjust level of detail |
| 4. Prepare/Validate | Pre-work validation | What does "validate inputs" mean in your domain? |
| 5. Execute | Do the main work | What instructions does the AI need? |
| 6. Verify | Check the work | What does verification look like? |
| 7. Report | Summarize and prompt handoff | Mostly stays the same |

**Review command** — What categories does the reviewer evaluate? SWE checks correctness, tests, security. EDA checks statistics, methodology, data handling. What matters in your domain?

**Handoff command** — This is mostly universal. The handoff note format rarely needs changing.

**Synthesis command** — What's the capstone for your domain? A retrospective? A deliverable report? A status briefing?

### 4. Customize `setup.sh`

If your workflow needs domain-specific directories or files created at setup time, add them. Look at how the EDA setup creates `notebooks/`, `data/`, `reports/`, and a `pyproject.toml`.

### 5. Write the README

Replace the template content with actual documentation for your workflow. Follow the pattern of the [SWE README](../workflows/swe/README.md) or [EDA README](../workflows/eda/README.md).

## Validation

Run `./framework/validate.sh my-workflow` to check your workflow. It verifies:

- All required files exist (`editor.md`, `setup.sh`, commands)
- Commands referenced in `editor.md` have matching files
- `editor.md` has the required sections (Document Locations, Session Protocol, Slash Commands, Principles)
- `/start` has the 7-phase structure with approval gates
- `/handoff` produces handoff notes with the standard format
- `/decompose` uses GitHub Issues with user stories
- `/review` mentions separate session / fresh eyes
- No leftover `{{PLACEHOLDER}}` markers or `<!-- GUIDE: -->` comments

Passing validation doesn't mean the workflow is good — it means the structure is complete. The content quality is up to you.

## PR Checklist

Before submitting a pull request for a new workflow:

- [ ] `./framework/validate.sh my-workflow` passes with no failures
- [ ] All `<!-- GUIDE: ... -->` comments removed
- [ ] All `{{PLACEHOLDER}}` markers replaced
- [ ] `editor.md` has at least 5 principles (including the universal ones)
- [ ] `/start` has 7 phases with approval gates at phases 2 and 3
- [ ] `/handoff` produces handoff notes with "What the Next Session Needs to Know"
- [ ] `README.md` has setup instructions, workflow table, and project structure
- [ ] `setup.sh` and `setup.ps1` both work
- [ ] Tested the workflow end-to-end: scaffold a project, run through at least the interview and brief commands

## Reference

For a deep-dive into the structural patterns, conventions, and the reasoning behind them, see [docs/workflow-anatomy.md](../docs/workflow-anatomy.md).

For examples of completed workflows, look at:
- [swe/](../workflows/swe/) — Software engineering workflow
- [eda/](../workflows/eda/) — Time series analysis workflow
