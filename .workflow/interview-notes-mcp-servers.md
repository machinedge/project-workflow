# Interview Notes: Expert MCP Servers

**Date:** 2026-05-09
**Interviewer:** PM
**Interviewee:** Shyam (shyam@machinedge.io)
**Mode:** Extended
**Calibration:** User is technically adept; summary produced as-is with gaps flagged, not filled in.

## Working Title

**Expert MCP Servers** — wrap each non-PM expert (SWE, QA, DevOps, System Architect) as MCP server(s) so Claude Code can orchestrate milestone-level work driven by local LLMs.

---

## 1. Problem

- Current platform-native skills require step-by-step human invocation (`/swe-start`, `/qa-review`, etc.) — milestone execution is manually driven.
- Token costs are high because Claude does all generative work itself.
- **Goal:** make Claude the orchestrator and push the implementation work out to MCP servers running on local models, dramatically cutting token spend and enabling milestone-level autonomy.

## 2. Audience

- **Primary:** Shyam and the MachinEdge team, running on dev laptops.
- Local model inference is a hard requirement, not a nice-to-have.
- PM interview stays cloud-based for now; eventually goes local too — **out of scope for this project**.
- External users / community adoption: not a driver right now.

## 3. Success

- Milestone-level autonomy: PM scopes a milestone, orchestrator drives the SWE/QA/DevOps/SA MCP servers through it without per-step human prompts.
- Human steps in only on hard blockers / failures, then orchestration resumes.
- Implicit: meaningful reduction in Claude token spend by shifting heavy generation to local models.
- **Gap:** no specific quantitative bar (e.g., "M15 ships entirely through MCPs" or "spend cut by X%") — left open.

## 4. Scope

**In scope:**
- MCP servers for SWE, QA, DevOps, System Architect.
- Granularity is **per-skill, possibly broken down further into smaller microtasks** to suit local-model context and capability limits.
- MCP servers may encode internal multi-step pipelines — multiple small-LLM calls sequenced deterministically inside the server (this is a key reason to choose MCP-style servers over a single LLM call: the workflow itself is regimented).
- Claude Code remains the orchestrator.
- Bare-minimum set of skills remain in Claude Code — just enough to invoke MCPs and handle interactive moments.

**Out of scope:**
- Running existing skills and MCPs in parallel — this is a replacement, not coexistence.
- PM interview migration to MCP / local model.
- Packaging for external users.

**Research item added to scope:**
- Whether to introduce a **database** (SQL, graph, or both) to capture tasks, outputs, handoffs, and related state instead of (or in addition to) the current markdown-based artifacts in `docs/` and `.workflow/`. Motivation: a more automated, machine-driven system may benefit from queryable structured state rather than file-based memory. Decide via research before implementation.

## 5. Constraints

- **Deployment:** Docker / Docker Compose stack on dev laptops, `git clone` + `docker compose up` with minimal `.env`-style config.
- **Filesystem context:** MCP servers must operate against the host's current project directory — exact mechanism is an **open research question**.
- **Language:** Python (user preference: readable, matches LLM tooling). TypeScript acceptable but not preferred.
- **Inference backend:** OpenAI-compatible HTTP endpoint, configurable **per MCP server** so different MCPs can use different models (vLLM, Ollama, LM Studio, etc.).
- **Frameworks under consideration:** LangChain, LangGraph — research needed on fit.
- **Sequencing:** Build a Python library / framework first that makes spinning up a new MCP server trivial (a few lines of code, plug in a set of skills) — *then* build the actual expert MCPs on top of it.
- No hard timeline. No team-skill or budget constraints called out.

## 6. Prior Art

- **Skipped at user's request.** "We're just gonna do this because it's fun to do."

## 7. Risks

- **Skipped at user's request.** Will be discovered through dogfooding iteration.

## 8. Environment & Delivery

- Delivered as a repo: `git clone` + `docker compose up`, minimal config.
- Stack runs against whatever project directory you're working in (mechanism TBD).
- Per-project usage; not a global laptop install model.
- **Gap:** Recovery semantics when an MCP crashes or a local model produces garbage mid-milestone — not yet defined; deferred to implementation.

## 9. Operations & Compliance

- Observability: deferred. Possible future integration with **Argus** (MachinEdge product).
- Compliance: deferred. No data-leaves-laptop hard rule called out.
- **Open research item — important:** Whether MCP is actually the right transport, or whether plain REST or JSON-RPC would be more flexible. Project framing currently says "MCP servers" but this is up for revisit before significant implementation.
- Posture: MVP v1, get it working, iterate via dogfooding.

## 10. You (Background)

- Technically adept; founder/builder at MachinEdge.
- Strong Python preference (readability).
- Has local LLM tooling installed already; just needs an endpoint to point at.
- Calibrated as **experienced** — synthesis presented as-is with explicit gaps, no plausible-assumption fill-ins.

---

## Open Research Items (Pre-Implementation)

These should be resolved by `sa-research` before SA designs the architecture:

1. **Transport/protocol choice** — MCP vs REST vs JSON-RPC for the expert servers. Trade-offs around flexibility, Claude Code integration, and pipeline-encoded workflows.
2. **Filesystem context mechanism** — how a Dockerized MCP server gets reliable, scoped access to the host's current project directory.
3. **Framework selection** — does LangChain / LangGraph earn its weight for the internal multi-step pipelines, or is something lighter (or hand-rolled) better?
4. **Skill decomposition strategy** — how finely to split each expert's existing skills into microtask-sized server tools.
5. **State storage model** — whether tasks, outputs, and handoffs should live in a database (SQL, graph, or both) instead of markdown files. Trade-offs around queryability, automation-friendliness, and the "documents are memory" principle currently baked into the toolkit.

## Explicit Gaps (User to Confirm or Defer)

- No quantitative success bar for token cost or autonomy.
- Recovery semantics on mid-milestone failure undefined.
- No timeline / milestone-shape commitment.

---

## Next Step

Ask for the `pm-vision` skill to transform these notes into the project brief.
