---
name: machinedge-workflows
description: "Set up structured AI-assisted expert teams by MachinEdge. Available experts: Project Manager (PM) for orchestration and planning, Software Engineer (SWE) for implementation, QA for quality assurance, DevOps for deployment, and Data Analyst for time series analysis. Use this skill whenever someone mentions: setting up an expert team, starting a new project, machinedge, structured development, project setup, configuring Claude Code or Cursor for multi-session work, or wants to add expert skills to an existing project. Works in both Cowork and Claude Code."
---

# MachinEdge Expert Teams Setup

You are helping a user set up MachinEdge Expert Teams in a project directory. Your job is to
guide them through a few choices and then configure everything — creating directories, copying
editor rules, and installing skills — so they can immediately start working.

The user should not need to touch a terminal themselves. You handle all of it.

## What Gets Installed

MachinEdge Expert Teams gives a project:

1. **Editor rules** — role files that Claude Code or Cursor auto-loads every session,
   telling the AI how to behave as each expert (read docs first, stay in scope, produce handoff notes).
2. **Skills** — a set of skills that structure the project lifecycle
   (interview → plan → decompose → execute → review → handoff).
3. **A docs directory** — where project memory lives between sessions (briefs, handoff notes, lessons).
4. **An issues directory** — in-repo task tracking via files in `issues/`.
5. **Expert tools** — executable scripts specific to each expert role.

## Step 1: Gather Information

Ask the user three things. Use the AskUserQuestion tool to present these as clear choices rather
than open-ended questions. You can ask them all at once.

### Which experts?

| Expert | Best For | Key Skills |
|--------|----------|------------|
| **Project Manager** | Orchestration, planning, scoping | `/pm-interview` → `/pm-vision` → `/pm-roadmap` → `/pm-decompose` → `/pm-postmortem` |
| **SWE** (Software Engineering) | Building software — apps, APIs, libraries, tools | `/swe-start` → `/swe-handoff` |
| **QA** (Quality Assurance) | Testing, code review, regression | `/qa-review` → `/qa-test-plan` → `/qa-regression` → `/qa-bug-triage` |
| **DevOps** | Build, deploy, environments | `/ops-env-discovery` → `/ops-pipeline` → `/ops-release-plan` → `/ops-deploy` |
| **Data Analyst** | Time series analysis, data exploration | `/da-intake` → `/da-brief` → `/da-scope` → `/da-start` → `/da-synthesize` |

The default is all core experts: PM, SWE, QA, DevOps. Users can also pick a subset.

### New project or existing?

- **New project** — Create a fresh directory with everything set up from scratch.
  Ask for the project/directory name. The directory will be created inside the user's
  current working folder (or wherever they specify).
- **Existing project** — Add the expert team to a project that already has code in it.
  Ask where the project is. The expert files get layered in without touching existing code.

### Which editor(s)?

- **Claude Code** — installs `.claude/CLAUDE.md`, `.claude/roles/*.md`, and `.claude/commands/*.md`
- **Cursor** — installs `.cursor/rules/*.mdc` and `.cursor/commands/*.md`
- **Both** (default) — installs for both editors. This is the right choice when a team
  uses mixed editors, since the docs directory is shared and editor-agnostic.

### GitHub repo? (new projects only)

If the user is creating a new project, ask if they want to also create a GitHub repo.
This requires `git` and `gh` CLI to be installed. If they say yes, you'll need:
- A GitHub org or username (check for `GITHUB_ORG` env var first)
- The repo name (default to the project directory name)

### Listing available experts

To show the user which experts are available, run:

```bash
bash "$SKILL_DIR/tools/list-experts.sh"
```

Use this when a user asks "what experts are available?" or when presenting expert choices
during setup.

## Step 2: Execute Setup

Once you have the user's choices, run the appropriate setup script. Everything is bundled
inside this skill's directory.

### Locating the scripts

You already know the path to this SKILL.md because you read it. The skill directory is
the parent of this file. All expert definitions and the framework are bundled right here:

```
machinedge-workflows/       ← this skill (the distributable package)
├── SKILL.md                ← you are reading this
├── tools/                  ← repo creation and expert listing
│   ├── new_repo.sh / new_repo.ps1
│   └── list-experts.sh / list-experts.ps1
├── experts/                ← expert definitions organized by domain
│   └── technical/
│       ├── project-manager/  ← role.md, skills/, tools/
│       ├── swe/
│       ├── qa/
│       ├── devops/
│       ├── data-analyst/
│       └── shared/           ← cross-expert protocols and shared skills
└── framework/
    └── install/
        ├── install.sh / install.ps1  ← the main install scripts
        └── ...
```

Resolve the paths like this:

```bash
SKILL_DIR="<directory containing this SKILL.md>"
# e.g. /home/user/.skills/skills/machinedge-workflows
```

### For existing projects

Run the setup script:

```bash
bash "$SKILL_DIR/framework/install/install.sh" --editor <claude|cursor|both> --experts <pm,swe,qa,devops> "<target-directory>"
```

### For new projects (local only)

Create the directory first, then run setup:

```bash
mkdir -p "<target-directory>"
bash "$SKILL_DIR/framework/install/install.sh" --editor <claude|cursor|both> --experts <pm,swe,qa,devops> "<target-directory>"
```

Then initialize git if appropriate:

```bash
cd "<target-directory>" && git init && git add . && git commit -m "Initial commit: project scaffold with MachinEdge Expert Teams"
```

### For new projects with GitHub repo

First, create the repo:

```bash
bash "$SKILL_DIR/tools/new_repo.sh" --org "<github-org>" "<repo-name>"
```

Before running this, verify prerequisites:
- `git` is installed: `command -v git`
- `gh` CLI is installed: `command -v gh`
- `gh` is authenticated: `gh auth status`

Then install the expert team into the new repo:

```bash
bash "$SKILL_DIR/framework/install/install.sh" --editor <claude|cursor|both> --experts <pm,swe,qa,devops> "$HOME/work/<repo-name>"
```

Then commit and push the expert team files:

```bash
cd "$HOME/work/<repo-name>" && git add . && git commit -m "Add MachinEdge Expert Teams" && git push
```

If any prerequisite is missing, explain what needs to be installed and offer to help
(but note that the user may need to handle authentication themselves).

### Platform handling

The setup scripts have both `.sh` (macOS/Linux) and `.ps1` (Windows/PowerShell) versions.
Detect the platform and use the right one:

```bash
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    pwsh "$SKILL_DIR/framework/install/install.ps1" ...
else
    bash "$SKILL_DIR/framework/install/install.sh" ...
fi
```

In practice, Claude Code and Cowork run in bash-compatible environments. The PowerShell
scripts exist for users who run setup manually on Windows.

## Step 3: Confirm and Orient

After setup completes, give the user a clear summary of what was created and what to do next.

Tell them:
> Your project is set up with MachinEdge Expert Teams. Here's what to do next:
>
> 1. Open the project in Claude Code or Cursor
> 2. The AI will ask which expert role you want for this session
> 3. Start with the **Project Manager** role and run `/pm-interview` to capture your project idea
> 4. Then follow the lifecycle: `/pm-vision` → `/pm-roadmap` → `/pm-decompose`
> 5. Switch to the **SWE** role for implementation: `/swe-start` → `/swe-handoff`
> 6. Use **QA** for reviews: `/qa-review` → `/qa-test-plan`
>
> Each expert builds on shared project documents in `docs/`. The handoff notes carry
> context across sessions so you never have to re-explain your project.

### Key concept to communicate

The most important thing for the user to understand: **these expert teams give AI memory across sessions**.
Every session reads project documents at startup and writes handoff notes at the end. The user
doesn't need to re-explain their project every time they open a new chat. This is the core value
proposition — explain it in plain language, not jargon.

## Edge Cases

### User wants an expert that doesn't exist yet

The toolkit includes a framework for creating custom experts. If someone asks for an expert
type that isn't available, let them know:

1. The available experts are Project Manager, SWE, QA, DevOps, and Data Analyst
2. Custom experts can be created using `./framework/scaffold/create-expert.sh`
3. They can start by picking whichever existing expert is closest to their needs
   and customizing the role and skills after setup

### User already has expert files in their project

If the target directory already has `.claude/CLAUDE.md` or `.cursor/rules/`, warn the user
that setup will overwrite those files. Ask for confirmation before proceeding.

### User is in Cowork without a folder selected

If the user hasn't selected a folder in Cowork, you won't have a target directory to work with.
Guide them to select a folder first (they can do this from the Cowork interface), then re-run
the setup.

### User is in Cowork with a folder already selected

The selected folder is mounted and accessible. For "existing project" setups, this mounted
folder is the natural target — you don't need to ask where the project is. For "new project"
setups, create the new directory inside the mounted folder.

### User is in Claude Code

The current working directory is the project. For "existing project" setups, use `.` as the
target. For "new project" setups, ask where they want the new directory (default: current
working directory or `$HOME/work/`).

### User just wants to explore

If the user is just asking about the experts (not ready to set one up), read the relevant
`role.md` file from this skill's `experts/technical/` directory (e.g. `experts/technical/swe/role.md`)
and explain what the expert does, what skills it includes, and what kind of project
it's designed for. Don't push setup until they're ready.
