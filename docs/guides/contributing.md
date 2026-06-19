# Contributing: Change an Expert and Test It

This guide takes you from "I want to change one of the experts" to a tested change, by editing the single source, re-installing into a real project, and running the workflow your change touched. It is for a developer extending the toolkit itself who has never worked in this repo before.

For the exhaustive contracts — the full file-type table, the document-contracts table, the skill-description rules, and the PR checklist — this guide does not restate them. It points you to the two reference files that already cover them:

- `CONTRIBUTING.md` (repo root) — repository layout, what to modify, and the PR checklist.
- `docs/agent-reference.md` — the detailed contracts: file types, how to write a role / skill / command / script, the document-contracts table, and the common mistakes.

This guide is the walk-me-through-it on-ramp those two files assume you already understand. Read it first, then reach for them when you need the full detail.

## The two rules that govern every change

Both rules come from `docs/agent-reference.md`, in different sections: the single-source rule from "Modifying an Existing Expert" (step 3, "Make the change once in `agents/`"), and the path-reference rule from "Common Mistakes" (the "Hardcoding a harness path" entry). Everything below depends on them.

- **Single-source rule: edit `agents/` only.** The repo has exactly one implementation of the toolkit, the `agents/` directory at the repo root. The installer copies it into a target project as `.agents/`. Never hand-edit a `.agents/` copy in a project — your change would be overwritten on the next install and would never make it back to the source. Make the change once, in `agents/`, then re-install.

- **Path-reference rule: cite `.agents/...`, never `.claude/...`.** When a role, skill, or command refers to another file in the toolkit, it must use the `.agents/...` path (for example `.agents/scripts/move-issue.sh`). The `.agents/` path exists for every harness. The `.claude/` path exists only when the optional Claude Code wiring is installed, so a `.claude/...` reference breaks on Codex and other AGENTS.md-only harnesses.

## Prerequisites

Have these in place before you start. Each line says how to check it.

- **A clone of this repo.** You are reading a file inside it. Confirm you are at the repo root: `ls install.sh agents/ docs/` should list all three without error.
- **Bash (macOS/Linux) or PowerShell (Windows)** to run the installer. Check Bash with `bash --version`. On Windows the equivalent installer is `install.ps1`.
- **A scratch target project to install into.** Any empty directory works. This guide creates one in the steps below, so you do not need one ready in advance.
- **Node.js (only if your change touches a workflow script).** The two cross-expert workflow accelerators under `agents/workflows/` are JavaScript. Check with `node --version`. You do not need Node for a role or skill change.

## Steps

This walkthrough changes the Software Engineer role as a concrete example. The same three steps — edit in `agents/`, re-install, run the affected workflow — apply to any role, skill, command, or script.

### 1. Find the source file under `agents/`

The single source lives under `agents/` at the repo root, organized by file type:

- Roles: `agents/roles/<expert>.md` — for example `agents/roles/swe.md`.
- Commands (user-invoked, `/name`): `agents/commands/<name>.md` — for example `agents/commands/pm-interview.md`.
- Skills (agent-discovered): `agents/skills/<prefix>-<name>/SKILL.md` — for example `agents/skills/swe-handoff/SKILL.md`.
- Scripts: `agents/scripts/<name>.sh`. Most ship with a paired `.ps1` companion for the Windows path; keep paired scripts in step. (One exception: `session-primer.sh` has no `.ps1` companion.)
- Workflow accelerators: `agents/workflows/*.js`.

Open the Software Engineer role to see what you are editing:

```bash
cat agents/roles/swe.md
```

You should see a markdown file that opens with `# SWE Operating System`.

### 2. Make the change in `agents/` (and only there)

Edit the source file. For this walkthrough, add a one-line principle to the SWE role. Open `agents/roles/swe.md` in your editor and, under the `## Principles` section, add a new bullet such as:

```markdown
- **Leave a trail.** Record any non-obvious decision in the handoff note so the next session inherits the reasoning, not just the result.
```

Save the file. Confirm you edited the source, not an installed copy — the path must start with `agents/`, not `.agents/`:

```bash
git status --short agents/roles/swe.md
```

Expected output (the leading `M` means the source file is modified):

```
 M agents/roles/swe.md
```

If a script touches behavior and has a `.ps1` companion, edit that companion in the same change so the Windows path stays in step (see "Forgetting script companions" in `docs/agent-reference.md`). Most scripts are paired; the lone exception today is `session-primer.sh`, which ships without one.

### 3. Re-install into a real project

Install the toolkit into a scratch directory so you can exercise the change exactly as a user would. From the repo root:

```bash
./install.sh /tmp/contrib-test
```

The installer prints a summary. On a current checkout it reports eight roles, six commands, 33 skills, and the files it wired. The full block looks like this:

```
MachinEdge Expert Teams — Install
  Target: /tmp/contrib-test
  Mode:   AGENTS.md flow + Claude Code wiring

  Installing .agents/ ...
    AGENTS.md + CLAUDE.md symlink
    Roles: 8 files
    Commands: 6 files
    Skills: 33 folders
    Scripts: 13 files
  Wiring .claude/ for Claude Code ...
    Symlinks: .claude/{commands,skills,roles,scripts,workflows} → ../.agents/*
    Settings: created .claude/settings.json

Done! Installed to: /tmp/contrib-test
```

(The installer also prints `Next steps` and `Uninstall` blocks after `Done!`; those are omitted here.)

Confirm your edit actually landed in the installed copy:

```bash
grep "Leave a trail" /tmp/contrib-test/.agents/roles/swe.md
```

This should print the line you added. The installer copied `agents/` to `.agents/` in the target, wrote a top-level `AGENTS.md`, symlinked `CLAUDE.md → AGENTS.md`, and (unless you pass `--no-claude`) symlinked `.claude/{commands,skills,roles,scripts,workflows}` into `.agents/`. Because `.claude/roles` points at `.agents/roles`, the same edit also resolves there:

```bash
grep "Leave a trail" /tmp/contrib-test/.claude/roles/swe.md
```

To install for a Codex or other AGENTS.md-only harness, skip the Claude wiring:

```bash
./install.sh --no-claude /tmp/contrib-test
```

On Windows, run the PowerShell installer instead — the flag and target are named options:

```powershell
.\install.ps1 -Target C:\path\to\contrib-test
.\install.ps1 -NoClaude -Target C:\path\to\contrib-test
```

### 4. Run the affected workflow

Open the scratch project (`/tmp/contrib-test`) in your harness — Claude Code, Codex, or any AGENTS.md harness — and exercise the path your change touched. Match the run to what you edited:

- **A role.** Confirm the role loads with your change. The simplest sufficient check needs no completed task: open a session in the scratch project as that expert, let the role file load, and confirm your new text is present in the loaded role — for the SWE edit above, that the "Leave a trail" principle now appears under `## Principles`. To go further and watch the role drive real work, pick up a planned task with `/start-task` (it infers the expert from the issue's `**Expert:**` field). A fresh scratch install has no planned issues, though — producing one requires the full interview → brief → roadmap → decompose → promote-to-planned chain. That end-to-end path is documented in `docs/guides/usage.md`; follow it there if you want a runnable `/start-task`, rather than reconstructing the intermediate steps from this guide.
- **A command** (one of the six: `start-task`, `resume-task`, `pm-interview`, `pm-add-feature`, `ops-deploy`, `ops-env-discovery`): invoke it by name, for example `/pm-interview`, and walk the flow.
- **A skill** (agent-discovered, not a slash command): trigger the situation its `description` names and confirm the agent picks it up. For example, signal that you are wrapping up a session and confirm the matching `*-handoff` skill runs.
- **A workflow accelerator** under `agents/workflows/`: the two cross-expert workflows are the full milestone lifecycle and the full documentation lifecycle. Their on-disk script files are `agents/workflows/implement.js` and `agents/workflows/document.js`. Drive them through their `team-` skills (`team-milestone`, `team-docs`); under Claude Code these run as parallel multi-agent accelerators.

A change is tested only when you have run the path it touches in an installed project and seen the new behavior — not when the install merely succeeded.

### 5. Clean up the scratch install

The scratch directory was only for testing. Remove it, and revert the example edit if you were only following along:

```bash
rm -rf /tmp/contrib-test
git checkout agents/roles/swe.md
```

Before opening a pull request, walk the PR checklist in `CONTRIBUTING.md` — it is the authoritative list (changes in `agents/`, `.agents/` path references, tested by re-install, no stale references, clear skill descriptions).

## Troubleshooting

- **Your edit does not show up after install.** You almost certainly edited a `.agents/` copy in a project instead of the `agents/` source at the repo root. Re-check the single-source rule: the path you edit must start with `agents/`. The installer overwrites the managed parts of `.agents/` on every run, so edits there are lost.
- **`./install.sh: Permission denied`.** The script is not executable on your checkout. Run it through Bash explicitly: `bash install.sh /tmp/contrib-test`.
- **`Error: toolkit source directory not found`.** You are not at the repo root, so the installer cannot find `agents/`. `cd` to the directory that contains `install.sh` and `agents/`, then re-run.
- **A reference you added breaks on Codex but works in Claude Code.** You used a `.claude/...` path. Apply the path-reference rule and change it to `.agents/...`, which resolves on every harness.
- **You expected a workflow file named `milestone.js` or `documentation.js`.** Some prose in `README.md` and `docs/architecture.md` still uses those older names. The files that actually ship are `agents/workflows/implement.js` and `agents/workflows/document.js` — use the on-disk names, and treat the stale prose as a docs bug to fix, not a missing file.
- **A skill you wrote is never invoked.** Its `description` is the discovery mechanism. Make sure it answers both "what does this do?" and "when should the agent use it?" — see "Weak skill descriptions" in `docs/agent-reference.md`.
</content>
</invoke>
