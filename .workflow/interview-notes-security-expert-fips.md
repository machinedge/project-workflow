# Interview Notes: Security Expert (FIPS)

## 1. What

Add a new **Security expert** (`sec-` prefix) to the MachinEdge Expert Teams toolkit, focused specifically on **FIPS 140-2 / 140-3 compliance** (approved crypto modules, key handling, RNG, cryptographic boundaries).

The expert performs two activities across the workflow:

1. **Review architecture and plan** for security concerns and gaps (design-time, upstream).
2. **Review code** for compliance (review-time, downstream).

## 2. Why

**Credibility play.** Adding a FIPS-focused Security expert signals that the toolkit is viable for regulated environments (government, healthcare, finance) — not driven by a specific customer or deadline.

Implications:
- **Breadth over depth:** the expert should feel complete and first-class, not a bolt-on.
- **Quality bar is high:** shipping a shallow or formulaic Security expert is worse than not shipping one — regulated buyers will see through it.
- **No urgent deadline:** persona quality matters more than ship date.

## 3. Scope

### Workflow Placement — Bookend Model

Security does **not** engage per-task. It engages at two natural review gates, piggybacking on SA and QA cadence:

- **Design-time (with SA):** Security runs in parallel with System Architect work and produces **FIPS constraints + rules** as an input artifact. These become implementation requirements consumed by SWE (alongside `architecture.md`).
- **Review-time (with QA):** Security runs alongside QA review and **validates** that the design-time constraints were upheld. Output is **advisory findings** filed as issues in `.workflow/issues/`; PM triages.

### In Scope

- New `sec-` expert with role file and full skill set across both platforms (`targets/ide/cursor/` and `targets/ide/claude-code/`).
- Design-time skill: produce FIPS constraints/rules artifact (equivalent to SA's `architecture.md` deliverable).
- Review-time skill: validate FIPS compliance; file advisory issues.
- `/sec-start` and `/sec-handoff` skills (consistent with other experts).
- **Change to `pm-decompose`:** when a milestone contains SA design tasks, decompose emits paired `sec-` constraint tasks; when QA review tasks exist, decompose emits paired `sec-` validation tasks.
- **New PM reconciliation skill:** merges/aligns parallel SA + Security design outputs (and potentially QA + Security review outputs) so downstream experts consume a coherent single picture.
- **SWE `/swe-start` consumes Security constraints** alongside architecture.
- Updates to `CONTRIBUTING.md`, `README.md`, and `docs/agent-reference.md` so Security is presented as a first-class expert.
- Demonstration: a worked example exercising both gates on this repo or a small staged scenario.

### Out of Scope

- Non-FIPS security concerns (OWASP, supply chain, secrets scanning, SAST/DAST) — may be added later, not now.
- Per-task Security triage (i.e. SA deciding per-task whether Security is needed).
- Gating behavior — Security findings do **not** block releases; no changes to DevOps `/ops-deploy`.
- Certified compliance officer-level FIPS depth; iteration is expected.

### Engagement Output Types (important nuance from interview)

- **Design-time output:** **constraints / rules** — inputs for SWE to follow. Not findings.
- **Review-time output:** **advisory findings** — issues filed, PM triages priority.

## 4. Success

- **Functional bar:** end-to-end works on both Cursor and Claude Code. Flow: PM scopes → (SA + Security in parallel produce design + constraints) → PM reconciles → SWE implements consuming both → (QA + Security in parallel review) → issues triaged.
- **Demonstration bar:** worked example walking Security through both gates on real or staged content, producing visible artifacts (constraints file + review findings).
- **Decompose integration:** `pm-decompose` successfully emits paired `sec-` tasks without requiring manual addition.

**Not** a success criterion: strict skill-count parity with PM/SWE/QA/DevOps/SA. Skills should be as complete as needed to meet the functional and demonstration bars.

## 5. Risks

| Risk | Mitigation |
|------|------------|
| FIPS depth: model has general FIPS knowledge but isn't a certified compliance officer; constraints/findings could be plausible-but-wrong | Accept and iterate. Start with what good skill prompts + model capability deliver; tighten when real users surface gaps. |
| Decompose change is invasive — modifying a core PM skill could cause noise (auto-emitting `sec-` tasks for milestones with no FIPS surface) | Named as in-scope and necessary. Worth thinking about a signal for "no FIPS surface" to keep output low-noise (e.g. Security's constraint doc can be empty/short when nothing applies). |
| Two parallel reviews (QA + Security) on the same artifact produce contradictory or overlapping findings | **New PM reconciliation skill** — added to scope. Merges/aligns parallel outputs so downstream experts see a coherent single picture. |
| Credibility backfire: shallow or formulaic Security output is worse than no Security expert for regulated audiences | Quality bar is high. Demonstration example must produce substantive, non-generic output. README/CONTRIBUTING/agent-reference positioning reinforces first-class status. |

## Gaps / Open Questions (flagged for pm-update-plan)

- **Skill inventory:** exact list of skills for the new expert (at minimum: `/sec-start`, `/sec-handoff`, design-time constraints skill, review-time validation skill). Full inventory lands at decomposition.
- **PM reconciliation skill design:** reconciliation at design-time only, or also at review-time? Likely both, but scope should be confirmed when the skill is decomposed.
- **Artifact location and naming:** where does the Security constraints file live? `docs/security-constraints.md` (parallel to `docs/architecture.md`) is the obvious choice but should be confirmed.
- **Demonstration target:** which milestone or scenario serves as the worked example? Likely a small staged scenario, since historical milestones weren't FIPS-relevant.

## Contradictions / Tensions

- None material. The main tension — "expensive" per-task engagement vs. credibility — was resolved cleanly by the bookend model (engage at SA + QA cadence, not per-task).

---

**Next step:** invoke the `pm-update-plan` skill to integrate this feature into `docs/project-brief.md` and `docs/roadmap.md`.
