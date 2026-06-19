# Documentation Plan

The bottom line: this toolkit ships as markdown expert definitions plus a shell installer and two Claude Code workflow accelerators — there is no running service to deploy or monitor. So the documentation it needs is a short install-and-first-run path for the developer who adopts it, a task-oriented guide to driving the experts day to day, an accessible overview of how the pieces fit, and a contributor guide for extending the expert definitions. The README and architecture doc already exist and cover much of this for contributors; the gap is user-facing guides under `docs/guides/`.

## Scope

Whole project (the MachinEdge Expert Teams toolkit as it stands at M1–M18). This is the first documentation plan for the repo — there are no guides under `docs/guides/` yet.

The "product" here is a developer tool, not a deployed service:
- It is installed into a target project with `./install.sh [--no-claude] <project-dir>` (or `install.ps1` on Windows).
- It is then "run" by talking to an AI harness (Claude Code, Codex) that loads the installed expert definitions — there is no server, daemon, port, or hosted component.
- It is extended by editing the single source tree under `agents/` and re-installing.

Because there is no deployed runtime, there is **no operator-facing deployment/maintenance-of-a-service surface** in the usual sense. The closest equivalent — standing the toolkit up in a project — is covered by the getting-started guide. No separate `deployment.md` or `maintenance.md` for a running service is planned; if that ever changes (e.g. a hosted variant), revisit this plan.

## Audiences

| Audience | Who they are | What they are trying to do |
|----------|--------------|----------------------------|
| End user / adopter | A developer who uses an AI coding assistant and wants structured, repeatable workflows | Install the toolkit into their project and reach a productive first session quickly |
| End user (day-to-day) | The same developer, now using it | Drive the experts through a real piece of work — interview, brief, roadmap, decompose, execute, review, hand off — and know which command or skill does what |
| Contributor / maintainer | A developer extending the toolkit itself | Understand how roles, skills, commands, scripts, and workflows fit together, then add or change one safely and re-install |

The end user and the "operator" are the same person here: installing the toolkit *is* the operate step. There is no separate operations team.

## Guide Inventory

| Guide (path) | Audience | New / Update | Draws on |
|--------------|----------|--------------|----------|
| docs/guides/getting-started.md | end user / adopter | new | README.md, install.sh, install.ps1, project-brief.md |
| docs/guides/usage.md | end user (day-to-day) | new | README.md, agents/roles/*.md, agents/skills/*/SKILL.md, agents/commands/*.md, project-brief.md |
| docs/guides/overview.md | end user + contributor (newcomer) | new | project-brief.md, architecture.md, README.md |
| docs/guides/contributing.md | contributor / maintainer | new | CONTRIBUTING.md, agent-reference.md, architecture.md, agents/ layout |

Notes:
- `docs/guides/contributing.md` overlaps with the existing root `CONTRIBUTING.md` and `docs/agent-reference.md`. The guide should be the readable, walk-me-through-it on-ramp for someone unfamiliar with the repo; it must not contradict or duplicate the reference material — link to `agent-reference.md` for the exhaustive contracts. If the author concludes the existing two files already suffice, record that decision instead of producing a thin restatement.
- No `deployment.md` / `maintenance.md`: there is no deployed service. Standing the toolkit up is the getting-started path.

## Documentation Requirements

| ID | Requirement (verifiable) | Guide | Area | How to Verify |
|----|--------------------------|-------|------|---------------|
| DOC-001 | The getting-started guide gets a reader from a clone of this repo to an installed toolkit in a target project using only `./install.sh <dir>`, and names what lands in the target (`AGENTS.md`, `CLAUDE.md` symlink, `.agents/`, `.claude/` wiring, `docs/`, `.sdlc/`). | getting-started.md | completeness | On a clean checkout, run the documented command against an empty scratch directory and confirm every file/dir the guide names actually appears. |
| DOC-002 | The getting-started guide states the prerequisites before the first command: an AGENTS.md-aware harness (Claude Code or Codex) and Bash (macOS/Linux) or PowerShell (Windows). | getting-started.md | completeness | A reader who has none of these knows from the guide alone what to obtain first; cross-check against README "Prerequisites". |
| DOC-003 | The getting-started guide documents the `--no-claude` option and the Windows `install.ps1 -Target` invocation, matching the installer's real usage strings. | getting-started.md | accuracy | Compare the guide's commands and flags against `install.sh` usage() and `install.ps1`; every flag shown must exist in the script. |
| DOC-004 | The getting-started guide ends with a concrete first action that works post-install — e.g. running `/pm-interview` to start a new project, or `/start-task` to pick up a planned task — and says where output (brief, roadmap, issues) lands. | getting-started.md | runnability | Follow the guide's final step in an installed scratch project; the named command exists as a command/skill and the named output paths match `docs/` + `.sdlc/`. |
| DOC-005 | The usage guide lists the eight experts with their prefixes and one plain-language sentence each on what that expert does, matching the roles that actually ship in `agents/roles/`. | usage.md | accuracy | Diff the guide's expert list against `agents/roles/*.md` (8 files: pm, swe, qa, devops, system-architect, security-engineer, ux-designer, technical-writer); names, prefixes, and responsibilities must match. |
| DOC-006 | The usage guide explains the difference between a command (user-invoked, `/name`) and a skill (agent-discovered), and lists the 6 commands by name, matching `agents/commands/`. | usage.md | accuracy | Compare against `agents/commands/` (start-task, resume-task, pm-interview, pm-add-feature, ops-deploy, ops-env-discovery); the guide must show exactly these as commands and not mislabel skills as commands. |
| DOC-007 | The usage guide walks one end-to-end path (interview → brief → roadmap → decompose → execute → review → handoff) so a first-time user knows the order of operations and which artifact each step produces. | usage.md | completeness | A reader unfamiliar with the toolkit can name, after reading, which step comes next and what file it writes; cross-check the artifact paths against the document-contracts table in `agent-reference.md`. |
| DOC-008 | The usage guide explains the issue lifecycle (`backlog → planned → in-progress → done`) and that `/start-task` pulls only from `planned/` while `/resume-task` resumes only `in-progress/`, matching the conventions in `AGENTS.md`. | usage.md | accuracy | Compare against the Status lifecycle section of `AGENTS.md`; the buckets, the promotion rule, and which command reads which bucket must match. |
| DOC-009 | The usage guide describes the two cross-expert workflows — the full milestone lifecycle (`team-milestone`) and the full documentation lifecycle (`team-docs`) — including that under Claude Code they run as parallel multi-agent accelerators, and references the real workflow script filenames as they exist on disk. | usage.md | accuracy | The named script files exist under `agents/workflows/` (currently `implement.js` and `document.js`); the guide must use the on-disk names, not stale names. Flag any mismatch with README/architecture if the prose there still says `milestone.js`/`documentation.js`. |
| DOC-010 | The overview guide gives a newcomer the big picture in plain language — what the toolkit is, the "documents are memory" model, the `agents/` single-source-plus-installer shape, and where state lives (`docs/` vs `.sdlc/`) — without requiring them to read the architecture doc first. | overview.md | readability | A reader who has never seen the project can, after one pass, state what the toolkit is and why experts have no memory between sessions; no undefined identifier (issue ID, filename, acronym) is used without a plain-language gloss. |
| DOC-011 | The overview guide is consistent with `docs/architecture.md` and the project brief — no claimed component, expert, or count that those sources contradict — and links to `architecture.md` for the decision-level detail rather than restating it. | overview.md | accuracy | Cross-check expert count (8), command count (6), skill count (33), and the two workflow accelerators against the project brief's Current Status and architecture.md; any number stated must match its source. |
| DOC-012 | The contributing guide gets a newcomer from "I want to change an expert" to a tested change: edit the source in `agents/`, re-install into a real project, run the affected workflow. It states the single-source rule (`agents/` only) and the `.agents/` path-reference rule. | contributing.md | runnability | Follow the guide to make a trivial edit to one role/skill and re-install; the change appears in the installed project. The two rules match `agent-reference.md` "Common Mistakes". |
| DOC-013 | The contributing guide does not duplicate or contradict `CONTRIBUTING.md` / `docs/agent-reference.md`; where the exhaustive contracts live (document-contracts table, file-type table, skill-description rules), it links to them rather than restating. If the author judges the existing files sufficient, the guide records that and points readers there. | contributing.md | accuracy | Diff the guide against `CONTRIBUTING.md` and `agent-reference.md`; no conflicting instruction; overlapping reference material is linked, not copied. |
| DOC-014 | Every guide follows the Writing-clearly conventions: each opens with a one-sentence verdict/what-it-covers line; identifiers are introduced in plain words before being cited; lists are real bullet lists; paragraphs stay short. | all guides | readability | A reviewer reading each guide cold confirms the lead sentence, the plain-word-first rule, and no telegraphic fragments or buried inline lists. |
| DOC-015 | Every command, skill, path, flag, and filename printed in any guide exists in the repo as written. | all guides | accuracy | For each guide, extract every code-formatted token (commands, flags, paths) and confirm it resolves against `agents/`, `install.sh`/`install.ps1`, `docs/`, or `.sdlc/`. No invented or stale references. |

These DOC-NNN requirements feed `pm-decompose` (each authoring task carries its DOC ids inline) and become the checklist for the `doc-review` close-out gate.
