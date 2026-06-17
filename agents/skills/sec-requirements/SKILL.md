---
name: sec-requirements
description: "Produce the threat model and security requirements spec for a milestone. Use at milestone kickoff when the user needs to establish trust boundaries, authn/authz (RBAC) rules, input-validation and secrets-handling requirements, and dependency constraints before implementation begins."
---

Produce the threat model and security requirements spec for a milestone. Produces or extends `docs/security-requirements.md`.

The user may specify a milestone or scope: $ARGUMENTS

## Step 1: Load Context

Read these files automatically:
1. `docs/project-brief.md` — constraints, compliance needs, what the system handles (secrets, PII, money, etc.)
2. `docs/architecture.md` (if it exists) — components and the trust boundaries between them
3. `docs/roadmap.md` (if it exists) — the milestone being scoped
4. `.sdlc/interview-notes*.md` (if any exist — raw requirements context)
5. `docs/security-requirements.md` (if it exists — you may be extending, not starting fresh)

If `docs/architecture.md` doesn't exist, you can still proceed from the brief, but tell the user: "No architecture document exists yet — trust boundaries will be inferred from the brief. Ask for the `sa-design` skill if you want boundaries pinned down first."

Confirm your understanding:
- "Milestone: [name / scope]"
- "What this milestone touches that matters for security: [auth, user input, external calls, secrets, PII, money, …]"
- "Compliance / constraints I see: [from project brief]"

Wait for user confirmation before proceeding.

## Step 2: Map Trust Boundaries and Assets

- What are the assets worth protecting in this milestone? (credentials, user data, money, integrity of a workflow, …)
- Where are the trust boundaries? (network edge, authn check, authz check, process boundary, external dependency)
- Who are the actors — including the abuser personas? (anonymous user, authenticated user, insider, compromised dependency)

Keep it concrete and scoped to this milestone. Do not threat-model the whole universe.

## Step 3: Enumerate Threats

For each boundary/asset, walk the relevant threat categories (spoofing, tampering, info disclosure, denial of service, elevation of privilege). For each credible threat:

- What is the threat? (1 line)
- Which asset/boundary does it hit?
- What is the impact if unmitigated?
- Likelihood given the project's actual exposure.

Drop threats that don't apply. Proportionate, not paranoid.

## Step 4: Derive Security Requirements

Turn each credible threat into one or more **verifiable controls**. A requirement names what is enforced, where, and how it can be checked. Cover at least:

- **Authentication** — who must prove identity, and how.
- **Authorization (RBAC)** — which roles may perform which actions, enforced at which layer.
- **Input validation** — which inputs are validated, the rules, and where (reject at the boundary).
- **Secrets handling** — what secrets exist, how they're stored/passed, what must never be logged.
- **Dependencies** — constraints on third-party packages (pinning, audit, disallowed licenses/sources).
- **Data protection** — encryption at rest/in transit where the brief or compliance requires it.

Each requirement must be phrased so QA can write a test and `sec-review` can check it. Bad: "validate input." Good: "the API rejects `amount <= 0` with HTTP 400 before any persistence."

## Step 5: Draft `docs/security-requirements.md`

Create or extend the document using this structure:

```markdown
# Security Requirements

## Scope
[Which milestone(s) this covers. Updated additively as milestones are scoped.]

## Trust Boundaries and Assets
[Boundaries, the assets each protects, and the actors — including abuser personas.]

## Threat Model
| ID | Threat | Boundary/Asset | Impact | Likelihood | Mitigated By |
|----|--------|----------------|--------|------------|--------------|
| T-001 | [threat] | [boundary] | [impact] | [low/med/high] | SR-001 |

## Security Requirements
| ID | Requirement (verifiable control) | Layer | Verifies Threat | How to Verify |
|----|----------------------------------|-------|-----------------|---------------|
| SR-001 | [what is enforced, where] | [API/data/CI/…] | T-001 | [test or check] |

## Secrets and Data
[What secrets/sensitive data exist, how they're handled, what must never be logged or committed.]

## Dependency Constraints
[Pinning, audit, disallowed sources/licenses — whatever applies.]
```

Scale detail to the project's real exposure. A low-risk tool gets a short spec; anything touching secrets, money, or PII gets rigor.

## Step 6: Review with User

Present the draft. Walk through the top threats and the requirements that mitigate them. Wait for approval before saving.

Save `docs/security-requirements.md` only after the user approves.

These requirements become inputs to `pm-decompose` (so tasks carry their security constraints inline) and the checklist for the `sec-review` close-out gate. Note that linkage in your closing summary.
