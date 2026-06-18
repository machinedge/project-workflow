---
name: sec-review
description: "Review implementation for security vulnerabilities and produce findings. Use at milestone close-out, or when the user wants to check whether built code satisfies the security requirements — authz/RBAC enforcement, input validation, secrets handling, and dependency risk."
---

Review implementation against the security requirements. Produce findings.

The user may specify what to review: $ARGUMENTS

## Step 1: Load Context

Read these files automatically:
1. `docs/security-requirements.md` — the requirements to evaluate against (your checklist)
2. `docs/project-brief.md` — constraints, compliance, what's sensitive
3. `docs/architecture.md` (if it exists) — trust boundaries
4. Recent SWE handoff notes in `.sdlc/handoff-notes/swe/` — what was built and changed

If `docs/security-requirements.md` doesn't exist, tell the user: "No security requirements exist yet. Ask for the `sec-requirements` skill first to establish the bar, or this review will have no baseline to evaluate against." You may still do a best-effort review from common categories, but say so.

If the user specified what to review (a component, a session's work), focus there. Otherwise review the milestone's changes broadly.

## Step 2: Identify Review Scope

State what you're reviewing:
- "Reviewing: [components / recent changes]"
- "Against: [security requirements SR-NNN … / common categories if no spec]"
- "Focus areas: [where the risk concentrates]"

## Step 3: Evaluate

Default to refuted — assume each control is missing until you find where it is enforced. For each requirement and each trust boundary in scope, check:

- **Authentication & Authorization (RBAC):** Is every protected action actually gated at the enforcement layer? Look for endpoints/handlers that skip the check, client-side-only checks, or role checks that can be bypassed.
- **Input validation:** Are inputs validated at the boundary before use/persistence? Look for injection (SQL/command/template), path traversal, unbounded input, missing type/range checks.
- **Secrets handling:** Are secrets kept out of code, logs, and error messages? Look for hardcoded credentials, secrets in committed files, tokens written to logs.
- **Dependencies:** Any newly added third-party packages? Unpinned, unmaintained, or from untrusted sources? Known-vulnerable versions?
- **Data protection:** Is sensitive data encrypted where required, and not leaked through responses or logs?

For each requirement, record: satisfied / violated / not-applicable, with the file:line evidence.

## Step 4: Produce Findings

Write this for a human scanning a terminal — follow the **Writing clearly** conventions in `AGENTS.md` (lead with the verdict, expand IDs/jargon on first mention, real bullet lists, short paragraphs). Stay critical.

Categorize findings:

- **Must-fix:** Exploitable or requirement-violating issues (missing authz, injection, leaked secret, vulnerable dependency).
- **Should-fix:** Weaknesses that increase risk but aren't directly exploitable yet (defense-in-depth gaps, weak validation).
- **Observations:** Things to watch (hardening opportunities, future concerns).

For each finding:
- What is it? (and which `SR-NNN`/`T-NNN` it relates to, if any)
- Where is it? (file:line, component)
- Why does it matter? (the concrete attack or impact)
- What's the recommendation?

## Step 5: File Issues

For must-fix and should-fix findings, create issue files in `.sdlc/issues/backlog/`. Run `.agents/scripts/next-issue-number.sh` for the next available number.

- Use the naming convention `[expert]-[type]-[number].md` with `swe-` as the executor (fixes are implemented by SWE) and `bug` or `techdebt` as the type — e.g. `swe-bug-014.md`.
- Reference the security requirement (`SR-NNN`) or threat (`T-NNN`) being violated, and include the file:line evidence so the fix is unambiguous.

Run `.agents/scripts/update-issues-list.sh` after creating issues.

## Step 6: Report

Present findings to the user, most severe first. Give an overall verdict: does the milestone meet its security requirements, or are there open must-fix issues that block release?

Do NOT auto-fix implementation. Fixes go through the SWE workflow so they get proper testing and verification. Your job is to find problems and state the bar, not to patch code.
