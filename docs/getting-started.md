# Getting Started

This guide covers the two deployment modes: standalone (single expert in an editor) and team (coordinated experts on the MachinEdge platform). Most users will start with standalone mode to get familiar with the expert definitions, then move to team mode for real project work.

## Deployment Modes

### Standalone Mode (Single Expert, Single Editor)

Use a single expert directly in Claude Code, Cowork, or Cursor. This is the simplest way to get started — install the skill, set up a workflow, and use the slash commands interactively. You are the orchestrator, switching between experts manually as needed.

This is how the workflows have worked historically and remains a fully supported path.

### Team Mode (Coordinated Experts, MachinEdge Platform)

Spin up a full AI development team for a project. The PM leads, experts coordinate through Matrix, and you interact primarily with the PM. This is the target deployment model — see the [Overview](overview.md) for the full vision.

Team mode is under active development. The rest of this guide covers both modes.

---

## Standalone Mode Setup

### Option A: Install the Skill (recommended)

Install the `.skill` package in Claude Code or Cowork. Once installed, just ask Claude to set up a workflow — no terminal commands needed.

```
# In Claude Code
claude install-skill machinedge-workflows.skill

# In Cowork
# Just say: "Set up an SWE workflow for my project"
```

The skill walks you through choosing an expert (SWE, EDA, PM, QA, or DevOps), selecting your editor(s), and configuring the project.

### Option B: Run the Setup Scripts Directly

Setup scripts live in `framework/install/` and install expert definitions into your project:

**macOS / Linux:**
```bash
# Full team setup (all experts) for a new project
./framework/install/install.sh ~/projects/my-app

# Single expert setup
./framework/install/install.sh --expert swe ~/projects/my-app
./framework/install/install.sh --expert data-analyst ~/projects/my-analysis
```

**Windows (PowerShell):**
```powershell
.\framework\install\install.ps1 -Target ~\projects\my-app
.\framework\install\install.ps1 -Expert swe -Target ~\projects\my-app
```

Then open the project in your editor and run the first skill (`/pm-interview` for project-manager, `/swe-start` for SWE, `/da-intake` for data-analyst).

### What Setup Creates

After setup, your project will have this structure added (existing files are untouched):

```
my-app/
├── .claude/
│   ├── CLAUDE.md                    # Auto-loaded rules (from expert's role.md)
│   └── commands/*.md                # Skills as slash commands
├── .cursor/
│   ├── rules/expert-os.mdc         # Auto-loaded rules for Cursor
│   └── commands/*.md                # Skills as slash commands
├── docs/
│   ├── lessons-log.md               # Running gotchas (template)
│   └── handoff-notes/               # Session memory
│       ├── swe/
│       ├── qa/
│       ├── devops/
│       └── project-manager/
└── issues/                          # In-repo issue tracking (managed by PM)
```

### Prerequisites (Standalone Mode)

- Git (installed and configured)
- Claude Code, Cursor, or Cowork
- For data-analyst expert: Python 3.10+ with uv or pip

---

## Team Mode Setup

### Prerequisites (Team Mode)

- Docker and Docker Compose
- OpenAI-compatible API key (or any LLM provider)
- A git repository URL and access token for the project
- OpenClaw ([openclaw.ai](https://openclaw.ai/))

### Setting Up a Git Access Token

Expert containers clone your project repository over HTTPS and authenticate using a personal access token. Each expert gets its own git clone for true parallel work — the token is shared across all experts.

For security, the token is **not stored in the `.env` file**. Instead, set it as an environment variable in your shell before starting the team:

```bash
# macOS / Linux — using GitHub CLI (easiest)
export GIT_TOKEN=$(gh auth token)

# macOS / Linux — using a token directly
export GIT_TOKEN=ghp_your-token-here
```

```powershell
# Windows PowerShell
$env:GIT_TOKEN = $(gh auth token)
# or
$env:GIT_TOKEN = "ghp_your-token-here"
```

Docker Compose picks up `GIT_TOKEN` from your shell environment and passes it to the expert containers. To make this persistent, add the export to your shell profile (`.bashrc`, `.zshrc`, or PowerShell `$PROFILE`).

**Creating a token — GitHub (recommended: fine-grained PAT)**

1. Go to [github.com/settings/tokens?type=beta](https://github.com/settings/tokens?type=beta)
2. Click **Generate new token**
3. Set a name (e.g., "machinedge-team") and expiration
4. Under **Repository access**, select **Only select repositories** and choose your project repo
5. Under **Permissions → Repository permissions**, set **Contents** to **Read and write**
6. Copy the token and export it as `GIT_TOKEN` (see above)

**GitLab**

1. Go to **Settings → Access Tokens**
2. Create a token with `read_repository` and `write_repository` scopes

**Bitbucket**

1. Go to **Personal settings → App passwords**
2. Create a password with **Repositories: Read** and **Repositories: Write**

> **Why read+write?** Experts need write access because they commit work (code, docs, handoff notes) back to the repository. If your workflow is review-only, read access is sufficient.

### Step 1: Generate Team Infrastructure

The `install-team.sh` script generates a `.octeam/` directory inside your project with everything needed to run the team in Docker:

**macOS / Linux:**
```bash
# Full team (PM, SWE, QA, DevOps)
./framework/install/install-team.sh ~/projects/my-app

# Specific experts only
./framework/install/install-team.sh --experts pm,swe ~/projects/my-app

# Custom project name (used for Docker namespacing)
./framework/install/install-team.sh --project-name acme-app ~/projects/my-app
```

### Step 2: Configure

Edit the generated `.env` file with your credentials:

```bash
vi ~/projects/my-app/.octeam/.env
```

If you ran the install from inside a git repository, the git fields (`GIT_REPO_URL`, `GIT_USER_NAME`, `GIT_USER_EMAIL`) are pre-populated automatically.

At minimum, verify or set these values in `.env`:
- `OPENAI_API_KEY` — your LLM API key
- `GIT_REPO_URL` — HTTPS URL of your project repository (auto-detected)

And set `GIT_TOKEN` in your shell environment (see [Setting Up a Git Access Token](#setting-up-a-git-access-token) above).

Optional per-expert overrides live in `configs/<expert>/env` (e.g., use a different model for the PM than for SWE).

### Step 3: Start the Team

```bash
cd ~/projects/my-app/.octeam
docker compose up -d
```

This starts:
- **Conduit** — lightweight Matrix homeserver for inter-expert communication
- **Element Web** — browser UI for you to interact with the team
- **OpenClaw Gateway** — agent routing and coordination
- **One container per expert** — each with its own git clone and workspace

### Step 4: Interact with Your Team

1. **Open Element Web** at [http://localhost:8009](http://localhost:8009)
2. **Login as `admin`** with the password from `.env` (`MATRIX_ADMIN_PASSWORD`)
3. **Join the `#project` room** — all experts are already there
4. **Talk to the PM** — describe what you want built, report a bug, or request a feature
5. **The PM handles the rest** — it breaks down work, delegates to experts, and pulls you in for reviews

You can monitor all expert activity in the room, interject at any point, or step back and let the team work autonomously.

### What Team Mode Creates

```
my-app/
├── .octeam/                              # Team infrastructure (generated)
│   ├── docker-compose.yml                # All services defined here
│   ├── .env                              # API keys, git URL, ports (gitignored)
│   ├── .gitignore
│   ├── configs/
│   │   ├── conduit/conduit.toml          # Matrix homeserver config
│   │   ├── element/config.json           # Element Web config
│   │   ├── project-manager/
│   │   │   ├── AGENTS.md                 # Translated from role.md
│   │   │   ├── skills/*/SKILL.md         # Skills with YAML frontmatter
│   │   │   ├── tools/                    # Expert tools
│   │   │   └── env                       # Per-expert overrides
│   │   ├── swe/
│   │   ├── qa/
│   │   └── devops/
│   ├── scripts/
│   │   ├── expert-entrypoint.sh          # Container startup script
│   │   └── setup-matrix.sh              # One-shot Matrix user/room setup
│   └── data/                             # Runtime data (gitignored)
├── docs/                                 # Shared project documents
│   ├── lessons-log.md
│   └── handoff-notes/
│       ├── project-manager/
│       ├── swe/
│       ├── qa/
│       └── devops/
└── issues/                               # In-repo issue tracking
```

### Useful Commands

```bash
docker compose ps                        # Show running containers
docker compose logs -f                   # Watch all logs
docker compose logs -f project-manager   # Watch PM logs
docker compose run --rm matrix-setup     # Re-run Matrix user/room setup
docker compose down                      # Stop the team
docker compose down -v                   # Stop and remove all data
```

### Re-running Setup

You can re-run `install-team.sh` at any time to regenerate the Docker infrastructure (e.g., after adding experts). Your `.env` and per-expert `env` files are preserved — only the generated files (`docker-compose.yml`, configs, scripts) are overwritten.

---

## Your First Session (Standalone Mode)

### With the PM Expert

1. **`/pm-interview`** — The PM conducts a structured interview to pull your project ideas out. Asks about goals, users, constraints, and scope. Output: `docs/interview-notes.md`.
2. **`/pm-vision`** — Reads interview notes and drafts a concise project brief. Review carefully — this becomes the source of truth. Output: `docs/project-brief.md`.
3. **`/pm-roadmap`** — Creates a milestone plan with dependencies and risks. Output: `docs/roadmap.md`.
4. **`/pm-decompose`** — Pick a milestone. Breaks it into session-sized issues (tracked in `issues/`) with user stories and acceptance criteria.

### With the SWE Expert

5. **`/swe-start #N`** — Pick an issue number. Loads all context, presents a plan (approval gate), designs architecture (approval gate), writes tests, implements, verifies, and reports.
6. **`/swe-handoff`** — Run before closing the session. Documents what was done, updates the brief, closes the issue.

Repeat steps 5-6 for each task.

### With the QA Expert

- **`/qa-review #N`** — Fresh-eyes evaluation in a separate session.
- **`/qa-test-plan`** — Creates a test plan based on the project brief and roadmap.
- **`/qa-regression`** — Runs regression analysis against existing test coverage.

### With the DevOps Expert

- **`/ops-env-discovery`** — Discovers and documents the deployment environment.
- **`/ops-pipeline`** — Sets up CI/CD pipeline configuration.
- **`/ops-deploy`** — Executes deployment following the release plan.

## Your First Session (Team Mode)

In team mode, your interaction is simpler — you talk to the PM through Element Web:

1. **Open Element Web** at [http://localhost:8009](http://localhost:8009) and login as `admin`
2. **Join the `#project` room** — all experts are already there
3. **Tell the PM what you want:** "I need a web app that tracks inventory for a small warehouse"
4. **The PM interviews you** — same structured interview, but through chat
5. **The PM spins up the work** — creates the brief, roadmap, decomposes tasks, and delegates
6. **You review when asked** — the PM pulls you in for approval gates and decisions
7. **Monitor progress** — watch the team work in the Matrix room, or check back later

---

## Tips

**Always run the handoff skill (e.g. `/swe-handoff`) before closing a session (standalone mode).** This is the single most important habit. The handoff note is how the next session knows what happened.

**Keep sessions focused.** One task per session. If you're tempted to squeeze in "one more thing," start a new session instead.

**Review the brief after `/vision` or `/brief`.** The project brief becomes the source of truth for every downstream action. If it's wrong, everything built on it will be wrong.

**Use `/qa-review` in a fresh session (standalone mode).** The whole point of fresh-eyes review is the absence of implementation memory. Running it in the same session that wrote the code defeats the purpose.

**`docs/` and `issues/` are your team's shared context.** They're editor-agnostic and expert-agnostic. All experts read from the same document and issue pool. The PM manages the issue lifecycle — creating, assigning, and closing issues as work progresses.
