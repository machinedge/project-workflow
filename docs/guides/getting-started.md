# Getting Started

This guide takes you from a fresh clone of this repository to a working expert toolkit installed inside one of your own projects, then points you at your first command. The clone-and-install itself is a sub-minute mechanical step — you will be installed and ready to run your first command in about five minutes. (Running that first command is a separate matter: the recommended starting command, `/pm-interview`, is an open-ended interview that takes as long as you want to spend on it.) This guide is for a developer adopting the toolkit for the first time; no prior knowledge of the project is assumed.

The toolkit is a set of AI "expert" definitions (Project Manager, Software Engineer, QA, and so on) plus a one-command installer. There is no server to run and no account to create. You install the files into a target project, then drive the experts by talking to an AI coding assistant that reads those files.

## Prerequisites

You need two things in place before the first command. Check each one now.

- **An AGENTS.md-aware harness, already installed and signed in.** This is the AI coding assistant you will talk to. It must read an `AGENTS.md` file at the project root. Claude Code and Codex both do. ("Harness" just means the AI tool you run — the thing that loads the expert definitions and acts on them.)
  - Check Claude Code: run `claude --version`. Any version that supports project `AGENTS.md`/`CLAUDE.md` works.
  - Codex or another harness works too, as long as it reads a root `AGENTS.md`.
  - Installing and authenticating the harness itself is out of scope for this guide and is not part of the five-minute toolkit install. If `claude --version` fails or you have not signed in yet, follow your harness's own setup docs first — Claude Code's are at <https://docs.claude.com/en/docs/claude-code>. The five-minute clock here covers only the toolkit install, assuming a working harness is already in place.
- **A shell to run the installer.** Bash on macOS or Linux, or PowerShell on Windows.
  - Check Bash: run `bash --version` (expect `GNU bash, version 3.2` or newer).
  - Check PowerShell: run `pwsh --version` or, in Windows PowerShell, `$PSVersionTable.PSVersion`.

You do not need Node.js, Python, or any package manager for a basic install. (Python 3 is used only to merge an existing `.claude/settings.json`; on a fresh project there is nothing to merge, so it is not required.)

## Steps

### 1. Clone this repository

Get a copy of the toolkit source onto your machine. You install *from* this clone *into* a separate target project.

```bash
git clone https://github.com/machinedge/project-workflow.git
cd project-workflow
```

Confirm the installer and source tree are present:

```bash
ls install.sh install.ps1 agents/
```

You should see `install.sh`, `install.ps1`, and the `agents/` directory listed. The `agents/` directory is the single source of truth the installer copies from.

### 2. Run the installer against your target project

Point the installer at the project you want the toolkit in. The target can be an existing project or a new empty directory — the installer creates it if it does not exist.

On macOS or Linux (Bash):

```bash
./install.sh ~/projects/my-app
```

On Windows (PowerShell):

```powershell
.\install.ps1 -Target ~\projects\my-app
```

Partway through, the installer prints a count block confirming the payload — `Roles: 8 files`, `Commands: 6 files`, `Skills: 33 folders`, and `Scripts: N files` (the exact script count varies). Those count lines are your proof the payload landed; they appear during the install, not at the very end. The installer then finishes with a final `Done! Installed to: <path>` line.

**Flags and variants:**

- `--no-claude` (Bash) or `-NoClaude` (PowerShell) — installs only the harness-neutral files (`AGENTS.md` and `.agents/`) and skips the Claude Code wiring in `.claude/`. Use this for Codex or any other AGENTS.md-only harness:
  ```bash
  ./install.sh --no-claude ~/projects/my-app
  ```
  ```powershell
  .\install.ps1 -NoClaude -Target ~\projects\my-app
  ```
- `-h` / `--help` (Bash) prints the usage summary and exits without installing.
- Target `.` installs into the current directory: `./install.sh .`

Run the installer again any time to update an existing install — it replaces the managed files and leaves your own work in `docs/` and `.sdlc/` untouched.

### 3. Confirm what landed in the target

Change into your target project and look at what the installer created:

```bash
cd ~/projects/my-app
ls -la
```

You should see these at the project root and below:

- **`AGENTS.md`** — the operating-system file. It defines the experts, the routing rules, and the project conventions. Every AGENTS.md-aware harness reads this.
- **`CLAUDE.md`** — a symlink pointing to `AGENTS.md`, so Claude Code reads the same file. (On Windows without Developer Mode, the installer writes this as a copy instead and prints a note.) This symlink is created in both the full and `--no-claude` installs.
- **`.agents/`** — the toolkit payload, one generic copy: `roles/` (8 expert role files), `commands/` (6 command files), `skills/` (33 skill folders), `scripts/` (shell helpers), and `workflows/` (the multi-agent workflow scripts).
- **`.claude/`** — Claude Code wiring: symlinks (`commands`, `skills`, `roles`, `scripts`, `workflows`) pointing into `.agents/`, plus a `settings.json` with a session-start hook. **This directory is skipped if you used `--no-claude`.**
- **`docs/`** — an empty directory where planning documents (the project brief, roadmap, architecture) will be written.
- **`.sdlc/`** — the managed work tracking area: `issues/` (with `backlog/`, `planned/`, `in-progress/`, `done/` subfolders), `handoff-notes/` (one folder per expert), and a starter `lessons-log.md`.

To verify the symlink resolved correctly:

```bash
ls -l CLAUDE.md
```

You should see `CLAUDE.md -> AGENTS.md`.

### 4. Run your first command

Open the target project in your harness (for Claude Code, run `claude` from inside `~/projects/my-app`). Then pick the entry point that matches your situation.

**Starting a brand-new project — run `/pm-interview`.**

This puts you in the Project Manager role and interviews you about the project one topic at a time (problem, audience, scope, constraints, and so on). When the interview finishes, it saves your answers as interview notes under `.sdlc/` and tells you to ask for the `pm-vision` skill next.

From there the planning chain produces the core documents:

- `pm-vision` writes the project brief to `docs/project-brief.md` — the source of truth for goals, constraints, and status.
- `pm-roadmap` writes the milestone plan to `docs/roadmap.md`.
- `pm-decompose` breaks a milestone into task issues under `.sdlc/issues/backlog/`.

**Picking up already-planned work — run `/start-task`.**

If the project already has tasks approved for execution, `/start-task` selects one from `.sdlc/issues/planned/`, moves it to `.sdlc/issues/in-progress/`, infers the right expert from the issue's `**Expert:**` field, loads that role, and walks you through executing it. (If `planned/` is empty, it tells you so and stops — there is nothing to start yet. A new install starts empty, so on a brand-new project begin with `/pm-interview`.)

Either way, the toolkit's output lands in files you can read and version-control: planning documents in `docs/`, and work tracking in `.sdlc/`. Those files are the experts' only memory between sessions.

### Next steps

You now have the toolkit installed and have run your first command. To go further:

- **Driving the experts day to day** — see `docs/guides/usage.md`, which walks through the full planning-to-execution loop (interview, brief, roadmap, decompose, start-task, handoff).
- **The big-picture orientation** — see `docs/guides/overview.md` for how the experts, issues, and handoff notes fit together.

## Troubleshooting

- **`Error: toolkit source directory not found`** — you ran the installer from outside the cloned repo, so it cannot find `agents/`. `cd` into the `project-workflow` clone and run `./install.sh` from there.
- **`permission denied` running `./install.sh`** — the script is not marked executable. Run `bash install.sh ~/projects/my-app`, or make it executable with `chmod +x install.sh` first.
- **`WARNING: existing AGENTS.md backed up to AGENTS.md.pre-install.bak`** — the target already had its own `AGENTS.md` with different content. The installer saved your original alongside the new one as `AGENTS.md.pre-install.bak`; nothing was lost. Reconcile the two by hand if you had custom rules in the original.
- **Windows: `NOTE: symlinks unavailable — CLAUDE.md written as a copy`** — Windows blocks symlink creation unless Developer Mode is on or the shell is elevated. The install still completes; `CLAUDE.md` is a real copy of `AGENTS.md` rather than a link. Enable Developer Mode and re-run if you want true symlinks.
- **`/pm-interview` or `/start-task` is not recognized** — your harness has not loaded the installed commands. Confirm you opened the harness from inside the target project (where `AGENTS.md` and `.claude/` live), not from the toolkit clone. For Codex or other non-Claude harnesses installed with `--no-claude`, there is no `.claude/` slash-command menu; invoke the experts by asking in plain language (for example, "act as the PM and interview me about a new project").
- **`Skills: 0 folders` or a much lower count than expected** — the copy did not complete. Re-run the installer; it cleans the managed files and reinstalls. If it persists, confirm `agents/skills/` in the clone is intact with `find agents/skills -name SKILL.md | wc -l` (expect `33`).
