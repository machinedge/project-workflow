# Make spec consumers fail loudly when a spec is missing at the new .sdlc/ path

**Type:** feature
**Expert:** swe
**Milestone:** [SDLC Boundary]
**Status:** done
**Session:**
**Detail level:** implementation-ready

## User Story

As a developer debugging a half-migrated project, I want a consumer to surface a clear, loud error when a required expert spec is absent at its `.sdlc/` location, so that I catch a missed reference or an unmigrated project during testing instead of getting silently wrong output.

## Description

Today consumers degrade silently ("read X if it exists"). The SDLC boundary requires the opposite: when a *required* spec (e.g. `.sdlc/architecture.md`) is missing at the new path, the consumer must stop and say what is missing and how to create it (run the authoring skill, or run `migrate-sdlc` on an existing project). Update the consume instructions in skills/roles/runbooks/accelerators so a missing required spec is an explicit, named failure — not an "if it exists" soft skip. `architecture.md` has the widest consumer fan-out (SWE, QA, Sec, UX, TW, PM), so it is the highest-priority case. The fail-loud rule is **tiered** (ADR-M19-2): `architecture.md` is required for any implementation milestone; `security-requirements.md` / `ux-guidelines.md` / `documentation-plan.md` / `test-plan.md` are required only when the milestone has the corresponding surface — otherwise their absence is a documented no-op, not an error.

### Precondition: this task runs LAST in the SWE repoint chain, AFTER 088/089/090

**Declared starting state — do not re-do the repoint.** This task is the final SWE task in the dependency order before migration (093) and the QA audit (094). It runs strictly **after** swe-feature-088 (consuming skills), swe-feature-089 (role files + AGENTS.md conventions), and swe-feature-090 (runbooks + accelerators) have all landed. Those three tasks already changed every consume step from `docs/<spec>.md` to `.sdlc/<spec>.md`. **By the time you execute 091, the consume steps ALREADY say `.sdlc/<spec>.md`.** Many also still carry the old soft suffix `(if it exists)` — that suffix is what 091 removes.

Concretely, when you open each target file you will find lines that already read `.sdlc/<spec>.md (if it exists)` (or a bare `.sdlc/<spec>.md` in a numbered read list). **091 only ADDS the fail-loud directive on the required ones. 091 does NOT repoint `docs/ → .sdlc/`** — if you still see a `docs/<spec>.md` spec reference on a consume step, that means 088/089/090 have not landed yet: STOP and report the unmet dependency rather than repointing it yourself (repointing is out of scope here and owned by 088–090). Do not stall waiting for a path that is already correct; the correct path is the precondition, your job is the fail-loud directive on top of it.

## Files to Create or Modify

These are the consume steps repointed in 088–090 that now read `.sdlc/<spec>.md` (often still suffixed `(if it exists)`). Add fail-loud text to each that requires the spec, per the tiered rule. The "What changes" column cites the exact line numbers as they stand today in `docs/` form — after 088–090 land the spec text on those lines reads `.sdlc/...`, but the line locations and which-are-consume classification below hold. Only touch the enumerated consume lines; leave the incidental mentions (also enumerated) alone — see "Which occurrences are consume steps" below.

| Path | Action | What changes |
|------|--------|--------------|
| `agents/roles/swe.md` | modify | Consume steps at lines 9, 12, 33, 35, 40 (the "Architect the solution"/"Write tests first" reads of architecture + test-plan). `architecture.md` → fail loud if absent (required-always). `test-plan.md` → required-by-surface (proceed if the milestone has no test surface). Lines 58, 61 are **incidental** (general "escalate architectural decisions" guidance) — do NOT touch. |
| `agents/roles/qa.md` | modify | Consume steps at lines 9, 13, 18, 39, 41, 46 (read architecture + test-plan to evaluate against them). `architecture.md` → fail loud (required). `test-plan.md` → required-by-surface. Line 71 ("Escalate architectural questions") is **incidental** — do NOT touch. |
| `agents/roles/security-engineer.md` | modify | Consume steps at lines 8, 14, 35, 36 (read security-requirements + architecture). `architecture.md` → fail loud (required). `security-requirements.md` → required-by-surface (the security surface). Line 42 names the authoring skill in prose — incidental, do NOT touch. |
| `agents/roles/ux-designer.md` | modify | Consume steps at lines 8, 14, 36, 37 (read ux-guidelines + architecture). `architecture.md` → fail loud (required). `ux-guidelines.md` → required-by-surface (proceed if no UX surface — the canonical no-op). Lines 43, 66 are **incidental** prose — do NOT touch. |
| `agents/roles/technical-writer.md` | modify | Consume steps at lines 8, 15, 16, 17, 18, 37, 38 (read documentation-plan + architecture + ux/env/release/security specs). `architecture.md` → fail loud (required). `documentation-plan.md`, `ux-guidelines.md`, `release-plan.md`, `security-requirements.md` → required-by-surface. Lines 43, 72 are **incidental** — do NOT touch. |
| `agents/roles/project-manager.md` | modify | Consume steps at lines 16, 36 (read architecture for task context). `architecture.md` → fail loud (required). |
| `agents/roles/devops.md` | modify | Consume steps at lines 9, 11, 12, 39, 40, 42 (read architecture + release-plan + test-plan). `architecture.md` → fail loud (required). `release-plan.md`, `test-plan.md` → required-by-surface. Lines 48 (author release-plan/env-context), 72 (incidental "escalate") — do NOT touch. |
| `agents/roles/system-architect.md` | modify | SA **owns/authors** architecture.md (lines 8, 14, 26, 41, 62, 66 are author/own/ADR steps, not consume) — do NOT add fail-loud here. No change unless a genuine consume-of-another-spec step exists (none today). Listed so the implementer confirms and skips it deliberately. |
| `agents/skills/pm-decompose/SKILL.md` | modify | Consume reads at lines 27, 28, 29 (architecture / security-requirements / test-plan in the read list). `architecture.md` → fail loud (required). `security-requirements.md`, `test-plan.md` → required-by-surface. Line 17 ("you're in implementation-ready mode … when security-requirements.md exists") is a **mode-detection** check, NOT a consume-to-use-content step — do NOT convert it to a hard fail. |
| `agents/skills/sec-review/SKILL.md` | modify | Consume reads at lines 13, 15. `security-requirements.md` (line 13) → fail loud (the review baseline; this surface exists by definition when sec-review runs). `architecture.md` (line 15) → fail loud (required). Replace the existing soft "If … doesn't exist, tell the user … You may still do a best-effort review" block at line 18 with the named fail-loud stop. |
| `agents/skills/qa-review/SKILL.md` | modify | Consume reads at lines 26, 28, 49, 79. `architecture.md` → fail loud (required). `test-plan.md` → required-by-surface. |
| `agents/skills/ux-review/SKILL.md` | modify | Consume reads at lines 13, 15. `architecture.md` (line 15) → fail loud (required). `ux-guidelines.md` (line 13) is the review baseline — keep its line-18 soft-skip *as the documented no-op for a no-UX-surface milestone*, but reword so it distinguishes "no UX surface (proceed)" from "UX surface exists but guidelines missing (fail loud)". |
| `agents/skills/doc-review/SKILL.md` | modify | Consume reads at lines 13, 16. `documentation-plan.md` (line 13) → fail loud when a docs surface exists; line-18 soft-skip becomes the documented no-op for a no-docs-surface milestone. `architecture.md` (line 16) → fail loud (required). |
| `agents/skills/sa-review/SKILL.md` | modify | Consume read at lines 13, 17. `architecture.md` → fail loud (required); replace the existing line-17 soft "tell the user … Ask for sa-design" with the canonical named fail-loud stop. |
| `agents/skills/team-status/SKILL.md` | modify | Status reads at lines 39, 40, 41. These are **status-overview** reads (report which specs exist), not consume-to-use-content steps — keep them soft (a status report legitimately lists "architecture: absent"). Add a one-line note that absent-spec is *reported*, not failed-on, here. No hard fail in team-status. |
| `agents/skills/team-milestone/SKILL.md` | modify | Lines 34–38 are **author** steps (`→ docs/<spec>.md`, owned by the enrich experts) — NOT consume. Do NOT add fail-loud. Listed so the implementer confirms there is no consume-read step here to convert. |
| `agents/skills/team-docs/SKILL.md` | modify | Lines 14, 25 read specs "whichever exist" to plan docs. These are **gather-what-exists** reads feeding doc-plan, not required-spec consumes — keep soft. The required-spec fail-loud lives in the doc-plan/doc-review skills they delegate to. No hard fail added here; add a one-line pointer that fail-loud is enforced by the delegated skills. |
| `agents/workflows/implement.js` | modify | Lines 200–204 are `out:` **author** targets (owned by 090) — NOT consume. The review-phase consume prompt at line 338 ("conformance to docs/architecture.md") IS a consume step → make its prompt string fail loud if `.sdlc/architecture.md` is absent (required). The pm-postmortem prompt at line 387 reads `test-plan.md`/`release-plan.md` "if they exist" — keep soft (postmortem tolerates their absence; required-by-surface, no surface ⇒ no-op). |
| `agents/workflows/document.js` | modify | Plan/author/review prompt strings at lines 131, 155, 185 read `architecture.md`/`documentation-plan.md`/`ux/env/release` "whichever exist". The `documentation-plan.md` read in the author (155) and completeness-review (185) prompts IS a required consume once a docs plan exists → fail loud if absent there. The "whichever exist" expert-spec enumeration in plan (131) and author (155) stays soft (gather-what-exists). `architecture.md` here is read for doc context, not as an implementation gate — keep soft (doc generation is not an implementation milestone consume). |
| `agents/AGENTS.md` | modify | "Workflow contracts" convention (line 30): replace the generic "don't fail silently or invent data" with the specific rule — a missing *required* spec at `.sdlc/` is a hard failure that names the file + remedy; genuinely optional/no-surface specs are an exempt documented no-op. |

**Note on accelerator location:** the accelerators live only at `agents/workflows/implement.js` and `agents/workflows/document.js` (single copy each — there are no duplicates under `agents/skills/team-milestone/`; that directory holds only `SKILL.md`). The `team-milestone` and `team-docs` runbooks invoke these workflow files, so editing the two `agents/workflows/*.js` files is sufficient.

## Interfaces and Data Models

The fail-loud message is a fixed-shape instruction string the consumer emits when a required spec is absent. It must name (a) the missing file and (b) the remedy. Canonical form (from the M19 draft "Consume flow"):

```
<spec>.md not found at .sdlc/<spec>.md. Produce it with <authoring-skill>,
or run migrate-sdlc if this is an existing project whose specs are still in docs/.
```

### Spec → authoring-skill remedy mapping (type the `<authoring-skill>` token verbatim — never infer)

Every fail-loud message names the skill that authors the missing spec. Use this exact table; do not derive the skill name from the spec name.

| Spec file | `.sdlc/` path | Authoring skill (`<authoring-skill>` token) | Tier |
|-----------|---------------|---------------------------------------------|------|
| `architecture.md` | `.sdlc/architecture.md` | `sa-design` | required-always |
| `security-requirements.md` | `.sdlc/security-requirements.md` | `sec-requirements` | required-by-surface (security) |
| `ux-guidelines.md` | `.sdlc/ux-guidelines.md` | `ux-guidelines` | required-by-surface (UX) |
| `documentation-plan.md` | `.sdlc/documentation-plan.md` | `doc-plan` | required-by-surface (docs) |
| `test-plan.md` | `.sdlc/test-plan.md` | `qa-test-plan` | required-by-surface (test) |
| `pipeline.md` | `.sdlc/pipeline.md` | `ops-pipeline` | required-by-surface (pipeline) |
| `release-plan.md` | `.sdlc/release-plan.md` | `ops-release-plan` | required-by-surface (release) |

Fully-rendered messages (copy these exact strings; substitute only the spec/skill from the row):
- `architecture.md not found at .sdlc/architecture.md. Produce it with sa-design, or run migrate-sdlc for an existing project.`
- `security-requirements.md not found at .sdlc/security-requirements.md. Produce it with sec-requirements, or run migrate-sdlc for an existing project.`
- `ux-guidelines.md not found at .sdlc/ux-guidelines.md. Produce it with ux-guidelines, or run migrate-sdlc for an existing project.`
- `documentation-plan.md not found at .sdlc/documentation-plan.md. Produce it with doc-plan, or run migrate-sdlc for an existing project.`
- `test-plan.md not found at .sdlc/test-plan.md. Produce it with qa-test-plan, or run migrate-sdlc for an existing project.`
- `pipeline.md not found at .sdlc/pipeline.md. Produce it with ops-pipeline, or run migrate-sdlc for an existing project.`
- `release-plan.md not found at .sdlc/release-plan.md. Produce it with ops-release-plan, or run migrate-sdlc for an existing project.`

### Operationalizing "required-by-surface" — the exact conditional to insert (gap: no surface-detection guesswork)

This is instruction text, not executable code, so the rule must be a concrete directive the consuming step gives the agent — no inferred surface detection. Insert the wording below verbatim at each consume step, choosing the architecture variant or the surface-scoped variant.

**For `architecture.md` (required-always — hard fail):**

> Read `.sdlc/architecture.md`. If it is absent, STOP and report: "architecture.md not found at .sdlc/architecture.md. Produce it with sa-design, or run migrate-sdlc for an existing project." Do not proceed with the task — architecture is required for any implementation milestone.

**For a surface-scoped spec (`security-requirements.md` / `ux-guidelines.md` / `documentation-plan.md` / `test-plan.md` / `pipeline.md` / `release-plan.md`) — conditional, documented no-op when the surface is absent:**

> Read `.sdlc/<spec>.md`. If this milestone produced a `<spec>.md` (the milestone has a `<surface>` surface) but it is absent at `.sdlc/`, STOP and report: "<spec>.md not found at .sdlc/<spec>.md. Produce it with <authoring-skill>, or run migrate-sdlc for an existing project." If this milestone has no `<surface>` surface and therefore produced no `<spec>.md`, proceed without it — this is a documented no-op, not an error.

The "did this milestone have the surface?" judgment is the consuming agent's, made from the task/milestone context it already holds (the same context that decides whether to run, e.g., `ux-review` at all) — the instruction does not ask the implementer to add surface-detection logic; it tells the agent which of the two outcomes applies. The distinguishing signal is concrete: if a sibling enrichment artifact for this milestone references the surface (or the milestone's task set includes that expert's work), the spec is required; if the milestone legitimately has no such surface, its absence is the no-op.

Tiering summary (ADR-M19-2 / Gate 2 decision 2):
- **Required (always):** `architecture.md` for any milestone with implementation — absent ⇒ hard fail.
- **Required-by-surface:** `security-requirements.md`, `ux-guidelines.md`, `documentation-plan.md`, `test-plan.md`, `pipeline.md`, `release-plan.md` — absent ⇒ hard fail **only** if the milestone has that surface; absent-and-no-surface ⇒ documented no-op (proceed, do not error).

## Implementation Outline

### The consume-vs-incidental rule (apply this to every candidate line before editing)

The target files mention `architecture.md` / `test-plan.md` / etc. in two kinds of places. Only ONE kind gets fail-loud. Decide line-by-line with this rule:

- **CONSUME step (DO add fail-loud):** a step in a Session Protocol, a numbered "read this context" list, or a phase outline that *reads the spec to use its content* — its data feeds the work. The spec is an input the step depends on.
  - *Example — consume:* `agents/skills/sa-review/SKILL.md:13` — "`docs/architecture.md` — the architectural intent to evaluate against" (the review reads it to evaluate against; absent ⇒ no baseline ⇒ fail loud).
  - *Example — consume:* `agents/roles/qa.md:46` — "Assess test coverage against `docs/test-plan.md` (if it exists)" (reads the plan to assess coverage; required-by-surface fail-loud).
- **INCIDENTAL mention (do NOT touch):** prose that *names* the spec without reading it for this step — escalation guidance, "don't re-litigate" notes, mode-detection checks, ownership/author declarations, or status-overview listings.
  - *Example — incidental:* `agents/roles/swe.md:61` — "Escalate architectural decisions … not covered by `docs/architecture.md`" (names the file as a boundary marker; does not read it to do work — leave it).
  - *Example — incidental:* `agents/roles/qa.md:71` — "Escalate architectural questions … not covered by `docs/architecture.md`" (escalation guidance — leave it).
  - *Example — incidental:* `agents/skills/pm-decompose/SKILL.md:17` — "you're in implementation-ready mode … when `docs/security-requirements.md` … exist" (a mode test, not a content consume — do NOT make it a hard fail).
  - *Example — incidental:* `agents/skills/team-status/SKILL.md:39-41` — status listing of which specs exist (reporting presence/absence IS the job — keep soft).

The per-file "What changes" column in the Files-to-Modify table above already enumerates the exact consume lines vs. the incidental lines for each target — follow it; it is the authoritative line-by-line classification.

### Steps

1. For each file, locate only the **consume-step** lines per the rule above and the table's enumeration. Ignore incidental mentions.
2. For each consume step, decide tier from the remedy/tier table: required-always (`architecture.md`), required-by-surface (the six surface specs), or genuinely status/no-op (team-status, team-docs gather-reads).
3. On each *required* consume step, replace the soft "(if it exists)" wording with the verbatim conditional from "Operationalizing required-by-surface" above — the architecture variant for `architecture.md`, the surface-scoped variant (with the documented no-op branch) for the six surface specs. Use the exact rendered message string from the remedy table.
4. For required-by-surface specs, the inserted wording already carries the documented no-op path ("if this milestone has no `<surface>` surface … proceed; this is not an error") — confirm it is present so the rule stays conditional, not blanket.
5. Leave team-status status-reads and team-docs gather-reads soft; add the one-line note (per the table) that absent specs are *reported/gathered*, not failed on, and that required-spec fail-loud is enforced in the delegated authoring/review skills.
6. Update the `AGENTS.md` "Workflow contracts" convention (line 30): replace the generic "don't fail silently or invent data" with the specific rule — a missing *required* spec at `.sdlc/` is a hard failure that names the file and remedy; genuinely optional/no-surface specs are an exempt documented no-op.
7. Verify: read-trace the `architecture.md` consume path (e.g. `sa-review`) with the file absent; confirm the named error and remedy, not a silent skip. Confirm a no-UX-surface milestone with `.sdlc/ux-guidelines.md` absent still proceeds. Grep that no *required* consume step still carries a bare "(if it exists)" soft-skip.

## Acceptance Criteria

- [ ] Consume steps that previously said "read `docs/<spec>.md` if it exists" now read `.sdlc/<spec>.md` and fail loudly with a named, actionable message when the spec is required and absent
- [ ] The error message names the missing file and the remedy (which authoring skill produces it, or run `migrate-sdlc` for an existing project)
- [ ] `architecture.md` consumers (swe, qa, sec, ux, doc, pm roles + relevant review skills) all fail loudly on its absence
- [ ] The AGENTS.md "Workflow contracts" convention states that a missing *required* spec at `.sdlc/` is a hard failure (the existing "don't fail silently or invent data" line is made specific to the new path + remedy)
- [ ] The fail-loud rule does NOT apply to genuinely optional artifacts a milestone may legitimately not have (e.g. a no-op UX guideline) — "required spec missing" is distinguished from "this milestone produced no such spec"
- [ ] Every fail-loud message uses the verbatim spec→authoring-skill remedy from the mapping table (architecture→`sa-design`, security-requirements→`sec-requirements`, ux-guidelines→`ux-guidelines`, documentation-plan→`doc-plan`, test-plan→`qa-test-plan`, pipeline→`ops-pipeline`, release-plan→`ops-release-plan`) — no inferred skill names
- [ ] Only consume/read steps (Session Protocol / read-lists / phase outlines) carry fail-loud; incidental mentions (escalation guidance, mode-detection, ownership/author declarations, status listings) are left unchanged
- [ ] The two `agents/workflows/*.js` accelerators are in scope: `implement.js` review-phase architecture consume (line 338) fails loud; `document.js` documentation-plan consume in author/review prompts fails loud; their `out:` author targets and "whichever exist" gather-reads stay soft. The `team-milestone`/`team-docs` runbook `SKILL.md` files carry author/gather steps only (no consume-read to convert) and get only the clarifying soft-read note

## Test Specification

**Test instrument:** read-trace + the ATP-2 manual drive from `docs/test-plan.md` (no unit harness).

| Case | Input | Expected result |
|------|-------|-----------------|
| Required spec absent (architecture) | drive a SWE/QA/Sec consume step with `.sdlc/architecture.md` absent | named error: missing file `.sdlc/architecture.md` + remedy (`sa-design` / `migrate-sdlc`); no silent skip |
| Required spec present | `.sdlc/architecture.md` exists | consumer proceeds normally |
| Optional/no-op spec absent | milestone with no UX surface, `.sdlc/ux-guidelines.md` absent | consumer proceeds; NOT a hard failure |
| Message shape | inspect emitted error text | contains both the file path and the remedy verb (`Produce it with …` / `run migrate-sdlc`) |
| AGENTS convention | read `agents/AGENTS.md` Workflow contracts | states missing required `.sdlc/` spec is a hard failure with remedy |

## Security Constraints

- [SR-008] A consumer that requires a spec fails loudly when that spec is absent at the `.sdlc/` path — naming the missing file and the remedy — rather than degrading silently. Genuinely optional artifacts are exempt and must not be made hard failures — from `docs/security-requirements.md`.

## Architecture Contracts

- Honor the **Fail-loud contract** — a missing *required* spec at `.sdlc/` is a hard stop with a message naming the missing file and the remedy (authoring skill, or `migrate-sdlc`); replaces today's silent "read X if it exists" — from `docs/architecture.m19-draft.md`.
- **Tiered scope (ADR-M19-2):** `architecture.md` always required; `security-requirements.md` / `ux-guidelines.md` / `documentation-plan.md` / `test-plan.md` required only when the milestone has the corresponding surface; otherwise documented no-op.
- This is instruction-text in skills/roles/runbooks — do NOT introduce new error-handling scripts (technology choice: behavior is expressed as agent instructions).

## Build / CI Notes

- No compiled artifact. Verification is the read-trace / ATP-2 drive plus a grep confirming no remaining "(if it exists)" soft-skip wording on a *required* spec consume step (architecture-always, plus the six surface specs on a milestone that has the surface). Surface-scoped no-op branches and team-status/team-docs gather-reads may legitimately still read soft — exclude those from the grep failure set.

## Technical Notes

**Estimated effort:** Medium session
**Dependencies:** swe-feature-088, swe-feature-089, swe-feature-090 — **HARD blocker, this task is last in the SWE repoint chain.** The paths must already be repointed to `.sdlc/` before the fail-loud behavior is layered on the same consume steps. By the time 091 runs, the consume steps already say `.sdlc/<spec>.md` (often still suffixed `(if it exists)`); 091 only adds the fail-loud directive and removes that soft suffix on required specs — it does **not** repoint `docs/ → .sdlc/`. If a consume step still shows `docs/<spec>.md`, an upstream task has not landed: report it, do not repoint it here. Downstream of 091: swe-feature-093 (`migrate-sdlc`) and qa-feature-094 (audit + end-to-end verify).
**Out of scope:** Installer (swe-feature-092), `migrate-sdlc` workflow (swe-feature-093). Do not invent new error-handling scripts — this is instruction-text in skills/roles, consistent with how the toolkit expresses behavior. Do not make optional/no-op specs hard failures.
