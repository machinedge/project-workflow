# UX Guidelines

## Scope

This document covers the user-facing surface of milestone **M19 [SDLC Boundary]**. Earlier milestones have no entry here.

M19 is mostly an internal relocation: expert-authored specs move from `docs/` to `.sdlc/`, and references across skills, role files, runbooks, and accelerators are repointed. None of that is user-facing — it is text inside agent instructions the toolkit reads, not a screen or command a human drives.

But M19 ships **three real human-facing surfaces**, all command-line:

1. The new **`migrate-sdlc` workflow** — a script a user invokes (bash + PowerShell) to relocate an existing project's specs and verify the result. This is the primary new UX surface.
2. The **fail-loud error messages** a consumer prints when a referenced spec is missing at the new `.sdlc/` path. These are content a user reads while debugging a half-migrated project — their whole purpose is to be read and acted on.
3. The **installer's console output** for the changed `docs/` / `.sdlc/` scaffolding (an existing surface, lightly extended).

The UX requirements below are scoped to these three surfaces and nothing else. Where M19 work is purely internal reference-repointing (swe-feature-088, -089, -090), there is no UX requirement — flagged as no-op below so the close-out review does not look for one.

| M19 task | User-facing? | UX coverage |
|----------|--------------|-------------|
| swe-feature-088 (repoint spec skills) | No | none — internal instruction text |
| swe-feature-089 (repoint roles + AGENTS.md + brief) | No | none — internal instruction text |
| swe-feature-090 (repoint runbooks + accelerators) | No | none — internal instruction text |
| swe-feature-091 (fail-loud consumers) | **Yes** | UX-001..UX-004 (error content) |
| swe-feature-092 (installer scaffolding) | **Yes** | UX-005..UX-006 (installer output) |
| swe-feature-093 (`migrate-sdlc` workflow) | **Yes** | UX-007..UX-013 (CLI ergonomics + report) |
| qa-feature-094 (verification) | No | verifies the above; no own surface |

## Users and Goals

Two personas touch this milestone's surface. Both are developers at a terminal — there is no GUI, no end-consumer.

- **The migrating maintainer.** Has an existing project whose specs still sit in `docs/`. Re-installs the toolkit, then runs `migrate-sdlc`. The job to be done: *relocate my specs into `.sdlc/` without losing or clobbering any of my work, and tell me plainly that it worked.* Success looks like a short report listing what moved and a clean-state confirmation. Failure looks like silent moves, an unexplained error, or — worst case — a clobbered hand-edited spec.

- **The debugging operator.** Is running an expert session or a workflow on a project that is only partly migrated (a reference was missed, or they have not run `migrate-sdlc` yet). A consumer hits a spec that is not at the `.sdlc/` path. The job to be done: *understand immediately what is missing and what to do about it.* Success looks like one clear line naming the file and the remedy. Failure looks like the old silent "if it exists" skip that produces quietly wrong output — the exact behavior M19 is removing.

## Key Flows

### Flow A — Migrate an existing project (`migrate-sdlc`)

1. **Entry.** User re-installs to get the new payload, then invokes the migration entry point (bash on macOS/Linux, PowerShell on Windows).
2. **Action.** The workflow scans `docs/` for the known spec artifacts and the `research/` / `security/` / `runbooks/` subfolders, and moves each into `.sdlc/`.
3. **Feedback.** For each artifact moved, it prints a `docs/X → .sdlc/X` line (the established installer convention). User-facing files (`guides/`, `README.md`, `project-brief.md`, `roadmap.md`) and any unknown file are left untouched and not reported as moved.
4. **Verify + result.** The workflow confirms no listed spec remains in `docs/`, then prints a clean-state summary and exits zero.

States along this path:

- **Nothing to migrate (already clean / fresh project).** Second run, or a project with no specs in `docs/`. The workflow must report "already clean — nothing to move" and exit zero. It must not error and must not re-move anything (idempotency).
- **Collision.** A spec already exists at the `.sdlc/` destination *and* a copy still sits in `docs/`. The workflow must **not** overwrite the destination. It reports the collision, names both paths, and exits non-zero so the user resolves it deliberately.
- **Partial / interrupted.** If the run is interrupted, re-running is safe: already-moved files are simply reported as already-in-place, remaining files move. This falls out of the idempotent `migrate_file`/`migrate_dir` pattern reused from M14.

### Flow B — Hit a missing spec during a session (fail-loud)

1. **Entry.** A consumer (an expert role or a workflow phase) reaches a step that needs a required spec, e.g. `.sdlc/architecture.md`.
2. **Fork — present vs. absent.** If present, proceed normally. If absent, **stop** — do not degrade silently, do not invent the spec's contents.
3. **Feedback.** Print one clear message that names the missing file and the remedy: run the authoring skill that produces it, or run `migrate-sdlc` if this is an existing project whose spec is still in `docs/`.
4. **Result.** The consumer halts at that step rather than producing output built on a guessed spec.

The one exception: an artifact a milestone *legitimately may not have* (e.g. a no-op UX guidelines note for a milestone with no user-facing surface) is **not** a failure. The message and the logic must distinguish "this required spec is missing" from "this milestone produced no such spec."

### Flow C — Fresh install scaffolding

A fresh install produces a `docs/` containing only the user-facing set and creates the `.sdlc/` spec locations. The installer's console output must not claim it is putting specs (architecture, etc.) under `docs/` — the existing comment to that effect is now wrong and must be corrected.

## UX Requirements

| ID | Requirement (verifiable control) | Area | Heuristic | How to Verify |
|----|----------------------------------|------|-----------|---------------|
| UX-001 | When a required spec is absent at its `.sdlc/` path, the consumer halts and prints an error rather than continuing — no silent "if it exists" skip remains in any repointed consume step. | content / error | Nielsen #1 (visibility of status), #5 (error prevention) | Run a consumer (e.g. an `architecture.md`-reading role) on a project with the spec absent; confirm it stops with a message and does not emit spec-derived output. |
| UX-002 | The fail-loud message names the exact missing file by its full `.sdlc/` path. | content / error | Nielsen #9 (clear error messages) | Inspect the message text; it contains the literal path (e.g. `.sdlc/architecture.md`), not a generic "spec missing". |
| UX-003 | The fail-loud message states the remedy: which authoring skill produces the spec, or to run `migrate-sdlc` for an existing project. | content / error | Nielsen #9 (recovery), #10 (help) | Inspect the message; it names at least one concrete next action a user can take. |
| UX-004 | A milestone that legitimately has no such spec (e.g. a no-op UX note) does NOT trigger the fail-loud error — "required-but-missing" is distinguished from "not produced this milestone." | content / error | Nielsen #5 (error prevention — no false alarms) | Run a UX consumer against a no-user-facing-surface milestone; confirm it proceeds without raising the missing-spec error. |
| UX-005 | A fresh install prints no message implying specs live under `docs/`; any comment/echo about `docs/` describes only the user-facing set. | content | Nielsen #2 (match system & real world) | Grep installer output/comments for "architecture" or "specs" under a `docs/` claim; confirm none remain. |
| UX-006 | Installer output for the changed scaffolding is consistent across bash and PowerShell (same messages, same created layout). | CLI / consistency | Nielsen #4 (consistency) | Run both installers on a clean target; diff the created `docs/` and `.sdlc/` trees and the console summary. |
| UX-007 | `migrate-sdlc` reports each relocation as a `docs/X → .sdlc/X` line, matching the existing installer migration convention. | CLI / feedback | Nielsen #1 (visibility), #4 (consistency) | Run on a seeded project; confirm one move-line per relocated artifact in the established format. |
| UX-008 | `migrate-sdlc` exits `0` on success and a clean no-op; it exits non-zero only on a real problem (e.g. a collision). | CLI / exit codes | CLI ergonomics | Run success, re-run (no-op), and a seeded-collision case; check `$?` / `$LASTEXITCODE` is 0, 0, non-zero respectively. |
| UX-009 | A second run of `migrate-sdlc` is a clean no-op: it reports an already-clean state, moves nothing, and exits zero. | CLI / feedback | Nielsen #1 (visibility of status) | Run twice; confirm the second run's output states "already clean / nothing to move" and the tree is unchanged. |
| UX-010 | On a destination collision, `migrate-sdlc` does not overwrite the `.sdlc/` copy; it names both the `docs/` and `.sdlc/` paths and reports the collision instead of silently picking one. | CLI / error | Nielsen #5 (error prevention), #9 (clear errors) | Seed the same spec in both `docs/` and `.sdlc/` with different contents; run; confirm the `.sdlc/` content is unchanged and both paths are named in the output. |
| UX-011 | `migrate-sdlc` ends with an explicit verification summary: it states no listed spec remains in `docs/` and lists the relocated set (or states none were found). | CLI / feedback | Nielsen #1 (visibility), #9 | Inspect end-of-run output; confirm a closing summary line distinct from the per-file move lines. |
| UX-012 | `migrate-sdlc` touches only the known spec artifacts; user-facing files and any unknown file in `docs/` are left in place and are not reported as moved. | CLI / safety | Nielsen #3 (user control), #5 | Seed `docs/` with a user-created file alongside specs; run; confirm the user file is untouched and absent from the move report. |
| UX-013 | The `migrate-sdlc` entry point is documented so a user knows the exact command to run after re-installing (both bash and PowerShell). | content / discoverability | Nielsen #10 (help & documentation) | Confirm a guide or README names the invocation for each harness; a fresh reader can run it without reading the script. |

## Accessibility Bar

This surface is entirely command-line text output; there is no GUI, color-dependent signal, or focus order to manage, so most WCAG criteria do not apply. The accessibility-relevant rules that **do** apply to terminal output:

- **No information by color or formatting alone.** Status (success, no-op, collision) must be conveyed in the words of the message, not by color or symbols a screen reader or a no-color terminal would drop. A user piping output to a log or reading it via assistive tech must get the full meaning from the text. (Covers UX-007, UX-009, UX-010, UX-011.)
- **Plain, decodable language.** Messages avoid jargon-only phrasing; the file path and the action are spelled out. (Covers UX-002, UX-003.)
- **Exit codes are machine-readable status.** Non-visual / scripted consumers rely on the exit code, not the printed text, to know success from failure — hence UX-008. This is the CLI equivalent of a programmatically-determinable status.

There is no formal WCAG conformance level to claim here because there is no web/GUI surface; the bar is "the full status is recoverable from text and exit code alone."

## Content & CLI Standards

**Voice and tone for messages.** Direct, second-person where an action is needed, no filler. State the fact, then the next step. "Specs already relocated — nothing to move." not "It looks like everything might already be in the right place!"

**Fail-loud error format.** A missing required spec prints, at minimum:
- the missing file's full path (`.sdlc/<spec>.md`),
- one sentence on why it is needed (the consumer cannot proceed without it),
- the remedy — the authoring skill that produces it, or `run migrate-sdlc` for an existing project.

Example shape (not literal copy): `Required spec not found: .sdlc/architecture.md. This step reads the system architecture and cannot proceed without it. Create it with the sa-design skill, or run migrate-sdlc if this project's specs are still under docs/.`

**Migration move format.** One line per relocated artifact, `docs/X → .sdlc/X`, reusing the exact arrow convention already in `install.sh` (lines 117-137) so the two surfaces read identically.

**Closing summary.** `migrate-sdlc` ends with one summary line: either the count/list of relocated specs and a "no specs remain in docs/" confirmation, or "already clean — nothing to move."

**Exit-code rule.** `0` for success and for a clean no-op (an already-migrated project is a success, not an error). Non-zero only for a genuine problem the user must resolve — chiefly a destination collision. This lets scripts and CI gate on the result.

**Idempotency as a UX contract, not just a safety one.** Re-running must be boring: same end state, no errors, no duplicate work. A user who is unsure whether they already ran it should be able to run it again with zero risk and get a clear "nothing to do."

**No destructive overwrite without report.** The workflow never silently overwrites a `.sdlc/` spec with a stale `docs/` copy. Collisions are surfaced and the user decides.

## Open Questions (for the human gate)

- **Workflow name.** The task leaves `migrate-sdlc` vs. `sync-sdlc` as a user choice at execution. The requirements above use `migrate-sdlc`; confirm the final name so UX-013's documented command and the error-message remedy text (UX-003) match what actually ships.
- **Collision exit behavior.** UX-010/UX-008 assume a collision is a non-zero exit the user must resolve. An alternative is to skip the colliding file, keep going on the rest, and exit zero with the collision listed as a warning. Both are defensible; confirm which the user prefers before QA writes the exit-code test.
- **Backlog feature (pm-feature-087) interaction.** The separately-filed "let readers dig deeper than the user-facing docs" request is explicitly out of M19, but it is the natural home for any "where did the specs go?" signposting. No UX requirement here assumes it; flagging only so the gate knows the discoverability gap is known and deferred, not missed.

---

*Linkage: these UX-NNN requirements feed the M19 task synthesis (so swe-feature-091, -092, -093 carry their UX constraints inline) and become the checklist for the `ux-review` close-out gate. The review should verify them against the shipped `migrate-sdlc` scripts, the fail-loud message text, and the installer output — not against any GUI, of which this milestone has none.*
