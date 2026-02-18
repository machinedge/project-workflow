---
name: machinedge-workflows
description: "Set up structured AI-assisted expert teams by MachinEdge. Available experts: Project Manager, Software Engineer, QA, DevOps, and Data Analyst. Use this skill when someone mentions: setting up an expert team, starting a new project, machinedge, structured development, project setup, or wants to add expert skills to an existing project."
---

# MachinEdge Expert Teams Setup

You are helping a user set up MachinEdge Expert Teams in a project directory. Your job is to
guide them through a few choices and then configure everything so they can immediately start working.
The user should not need to touch a terminal themselves. You handle all of it.

---

## Step 0: Resolve SKILL_DIR (do this FIRST, before anything else)

SKILL_DIR is the directory that contains this SKILL.md file. You know the path because you
just read this file. Strip the filename to get the directory.

Example: if you read `/home/user/.skills/skills/machinedge-workflows/SKILL.md`,
then `SKILL_DIR="/home/user/.skills/skills/machinedge-workflows"`

**Verify immediately** — run this before proceeding:

```bash
ls "$SKILL_DIR/framework/install/install.sh" "$SKILL_DIR/framework/install/install-team.sh"
```

If either file is missing, STOP. Tell the user the skill directory could not be resolved and
show them the path you tried. Do NOT continue.

---

## Step 1: Gather Information (two rounds)

Use the AskUserQuestion tool for both rounds. Do NOT ask open-ended questions in chat.

### Round 1 — Always ask these three questions together:

**Question 1: What style of setup?**
- **Command Based** — Skills get installed as slash commands into your editor (Claude Code or Cursor). You work with one expert role per session. This is the default for most users.
- **Team Mode** — Multiple experts run simultaneously in Docker containers and communicate via Matrix messaging. Requires Docker. Choose this only if you want parallel autonomous agents.

**Question 2: Which experts?**
- **All core experts (recommended)** — Project Manager, SWE, QA, DevOps
- **Pick specific experts** — Let the user choose from the list below

| Expert | Short Name | Slash Commands |
|--------|-----------|----------------|
| Project Manager | pm | `/pm-interview`, `/pm-vision`, `/pm-roadmap`, `/pm-decompose`, `/pm-postmortem` |
| Software Engineer | swe | `/swe-start`, `/swe-handoff` |
| Quality Assurance | qa | `/qa-review`, `/qa-test-plan`, `/qa-regression`, `/qa-bug-triage` |
| DevOps | devops | `/ops-env-discovery`, `/ops-pipeline`, `/ops-release-plan`, `/ops-deploy` |
| Data Analyst | data-analyst | `/da-intake`, `/da-brief`, `/da-scope`, `/da-start`, `/da-synthesize` |

To show the user which experts are available programmatically:
```bash
bash "$SKILL_DIR/tools/list-experts.sh"
```

**Question 3: New project or existing?**
- **Existing project** — Add expert team to a project that already has code. The expert files layer in without touching existing code.
- **New project** — Create a fresh directory with everything set up from scratch. Ask for the project/directory name.

### Round 2 — Conditional follow-ups (ask only what applies):

Ask these in a SECOND AskUserQuestion call. Skip any that don't apply.

- **IF Command Based** → Ask: Which editor(s)? Options: Claude Code / Cursor / Both (default) / None
- **IF New project** → Ask: Want to also create a GitHub repo? (Requires `git` and `gh` CLI)
- **IF New project + GitHub** → Ask: GitHub org or username? (Check `GITHUB_ORG` env var first; offer it as default if set)

**IF Team Mode** → Do NOT ask about editors. Team mode doesn't install editor configs.

---

## Step 2: Pre-flight Checks

Run these checks BEFORE executing any script. If ANY check fails, STOP and tell the user
what's missing. Do NOT proceed past a failed check.

```bash
# Always required — verify SKILL_DIR
ls "$SKILL_DIR/framework/install/install.sh"

# Always required — verify target directory is writable
# (for new projects, check the PARENT directory)
test -w "<target-or-parent>" && echo "OK: writable" || echo "FAIL: not writable"
```

**Additional checks by path:**

| Path | Additional Checks |
|------|-------------------|
| Team Mode | `command -v docker && docker compose version` |
| New + GitHub | `command -v git`, `command -v gh`, `gh auth status` |

If a prerequisite is missing, explain what needs to be installed. Offer to help, but note
that the user may need to handle authentication (e.g., `gh auth login`) themselves.

---

## Step 3: Execute Setup

Follow EXACTLY ONE path below based on the user's answers. Do NOT mix steps from different paths.

### Path A: Team Mode

Use `install-team.sh`. Do NOT use `install.sh`.

```bash
bash "$SKILL_DIR/framework/install/install-team.sh" \
  --experts <comma-separated-short-names> \
  --project-name "<name>" \
  "<target-directory>"
```

Options:
- `--experts` — Comma-separated short names: `pm,swe,qa,devops,data-analyst` (default: `project-manager,swe,qa,devops`)
- `--project-name` — Override project name for container naming (default: derived from directory)
- `--domain` — Expert domain (default: `technical`)

For new projects, create the directory first:
```bash
mkdir -p "<target-directory>"
```

---

### Path B: Command Based — Existing Project

Use `install.sh`. Do NOT use `install-team.sh`.

```bash
bash "$SKILL_DIR/framework/install/install.sh" \
  --editor <claude|cursor|both> \
  --experts <comma-separated-short-names> \
  "<target-directory>"
```

---

### Path C: Command Based — New Project (local only, no GitHub)

Create the directory, THEN run `install.sh`:

```bash
mkdir -p "<target-directory>"
bash "$SKILL_DIR/framework/install/install.sh" \
  --editor <claude|cursor|both> \
  --experts <comma-separated-short-names> \
  "<target-directory>"
```

Optionally initialize git:
```bash
cd "<target-directory>" && git init && git add . && git commit -m "Initial commit: project scaffold with MachinEdge Expert Teams"
```

---

### Path D: Command Based — New Project + GitHub Repo

First, create the repo:
```bash
bash "$SKILL_DIR/tools/new_repo.sh" --org "<github-org>" "<repo-name>"
```

Then install the expert team:
```bash
bash "$SKILL_DIR/framework/install/install.sh" \
  --editor <claude|cursor|both> \
  --experts <comma-separated-short-names> \
  "$HOME/work/<repo-name>"
```

Then commit and push:
```bash
cd "$HOME/work/<repo-name>" && git add . && git commit -m "Add MachinEdge Expert Teams" && git push
```

---

### Platform Note

The scripts have both `.sh` (macOS/Linux) and `.ps1` (Windows) versions. In Claude Code and
Cowork, always use the `.sh` versions. The `.ps1` scripts exist for users running setup
manually on Windows.

---

## Step 4: Error Handling

If any script exits with a non-zero status:
1. Show the user the FULL error output — do not summarize or paraphrase it
2. Do NOT retry automatically — ask the user how they want to proceed
3. Check these common causes:

| Error | Likely Cause | Fix |
|-------|-------------|-----|
| "directory not found" | Target path doesn't exist | Verify the path; create parent dirs |
| "permission denied" | Target is read-only | Check permissions on target directory |
| "expert not found" | Misspelled expert name | Run `list-experts.sh` and compare |
| "Could not find experts/" | SKILL_DIR resolved wrong | Re-check the path to this SKILL.md |
| Docker errors (team mode) | Docker not running | Ask user to start Docker Desktop |

---

## Step 5: Confirm and Orient

After setup completes successfully, tell the user THREE things. Keep it brief.

**1. What was created** — List the specific directories and files that were generated.
Be concrete (e.g., "Created `.claude/commands/` with 6 PM commands and 2 SWE commands"),
not generic.

**2. What to do first:**
- For Command Based: "Open the project in [their editor]. Start with the Project Manager role and run `/pm-interview` to capture your project idea."
- For Team Mode: "Run `docker compose up` from the `.octeam/` directory, then open Element Web to interact with your team."

**3. The key insight** — Expert teams give AI memory across sessions. Every session reads
project documents at startup and writes handoff notes at the end. You never have to
re-explain your project when you open a new chat.

Do NOT recite the full lifecycle unless the user asks for it.

---

## Edge Cases

### User wants an expert that doesn't exist
Available experts: Project Manager, SWE, QA, DevOps, Data Analyst. Custom experts can be
created with `./framework/scaffold/create-expert.sh`. Suggest starting with the closest
existing expert and customizing after setup.

### Target directory already has expert files
If `.claude/CLAUDE.md` or `.cursor/rules/` already exists, WARN the user that setup will
overwrite managed files (user content in `docs/` is preserved). Get confirmation before proceeding.

### User is in Cowork without a folder selected
Guide them to select a folder first from the Cowork interface, then re-run setup.

### User is in Cowork with a folder selected
The mounted folder is the natural target for "existing project" setups. For "new project,"
create the new directory inside the mounted folder.

### User is in Claude Code
Current working directory is the project. For "existing project," use `.` as the target.
For "new project," ask where to create the directory (default: `.` or `$HOME/work/`).

### User just wants to explore
If the user isn't ready to set up — they just want to learn about an expert — read the
relevant `role.md` from `$SKILL_DIR/experts/technical/<expert>/role.md` and explain what it
does. Don't push setup until they're ready.
