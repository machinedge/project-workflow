# Pipeline Definition — M19 [SDLC Boundary] (DRAFT)

**Status:** DRAFT for the human gate. Scoped to milestone M19 only.
**Based on:** project brief (`docs/project-brief.md`), the M19 task set (`.sdlc/issues/backlog/swe-feature-088..093`, `qa-feature-094`), and `docs/test-plan.md`. No `docs/env-context.md` exists — see "Open Questions."

## Verdict

M19 ships **text and shell/PowerShell scripts**, not a compiled artifact. There is no app to build, no binary, no container, and no live CI system in the repo today (no `.github/workflows/`). So the pipeline is **verification-first**: lint the scripts, run the systematic grep audit that proves the `docs/ → .sdlc/` repoint is complete, then functionally exercise the installer and the new `migrate-sdlc` workflow in throwaway sandboxes — including cross-harness (bash vs. PowerShell) parity. "Deploy" here means a user re-installing the toolkit and running `migrate-sdlc` over their own project; there is no server or registry push.

This is a small-surface milestone (3-5 sessions). The pipeline should be **fast and local** — a few minutes end-to-end — and resist over-engineering. The milestone risk is analysis paralysis; this draft deliberately keeps stages minimal.

## Pipeline Overview

```
[1 Lint]──┬──>[2 Audit: grep]──>[3 Test: fresh install]──>[4 Test: migrate-sdlc]──>[5 Parity]──>[6 Deliver]
          └──>(fail-loud probe folded into stage 3/4)
```

All stages run on a single dev/CI host (macOS or Linux) with `bash`, `pwsh`, `shellcheck`, and `grep` available. No emulator, no hardware-in-the-loop, no on-target tier.

## Stages

### 1. Lint (static)
**Runs:** `shellcheck install.sh .agents/scripts/*.sh` and the new `migrate-sdlc` bash script; `pwsh -Command 'Invoke-ScriptAnalyzer'` (or at minimum `pwsh -NoProfile -Command "$null = [ScriptBlock]::Create((Get-Content -Raw install.ps1))"` to parse) on `install.ps1`, `.agents/scripts/*.ps1`, and the new `migrate-sdlc` PowerShell script.
**Needs:** `shellcheck` (present at `/opt/homebrew/bin/shellcheck`), `pwsh` (present at `/usr/local/bin/pwsh`).
**Duration:** ~30s.
**Pass criteria:** no shellcheck errors (warnings reviewed, not necessarily blocking); PowerShell scripts parse without syntax errors.
**Blocks:** stage 2.

### 2. Audit — grep completeness check (the core M19 gate)
**Runs:** the systematic grep audit from the task notes —
`grep -rn -E 'docs/(architecture|pipeline|components|documentation-plan|test-plan|security-requirements|ux-guidelines|task-detail-standard|env-context|release-plan)\.md|docs/(research|security|runbooks)/' agents/ install.sh install.ps1 docs/project-brief.md`
**Needs:** `grep`, the repo checkout.
**Duration:** ~5s.
**Pass criteria:** zero **authoring** references to `docs/<spec>.md` remain across `agents/`, `install.sh`, `install.ps1`. Any surviving hit is either (a) an intentional, documented user-facing reference (`docs/guides/`, `docs/project-brief.md`, `docs/roadmap.md`, `docs/README.md`) or (b) a deliberate consume reference that has been confirmed. This is the same playbook used in the M13/M14 path work and is the single most load-bearing check in M19 (roadmap risk: "Stale path references").
**Blocks:** stage 3.

### 3. Test — fresh install (functional, sandboxed)
**Runs:** `install.sh` into a clean temp directory; then assert the resulting `docs/` contains **only** the user-facing set (`guides/`, `README.md`, `project-brief.md`, `roadmap.md`) and that `.sdlc/` holds the spec locations. Re-run the installer over the same target and assert no user content is clobbered (idempotency). Repeat with `install.ps1` into a separate clean temp dir.
**Includes the fail-loud probe:** with `.sdlc/architecture.md` absent, invoke an architecture consumer and confirm it raises a clear, named error naming the file and the remedy (run the authoring skill, or `migrate-sdlc`) rather than degrading silently. `architecture.md` is the widest-fan-out consumer, so it is the canonical case.
**Needs:** `bash`, `pwsh`, a writable temp dir.
**Duration:** ~1-2 min.
**Pass criteria:** matches qa-feature-094 acceptance — `docs/` user-facing-only, `.sdlc/` spec locations present, re-run is a clean no-op, fail-loud error is clear and named.
**Blocks:** stage 4.

### 4. Test — `migrate-sdlc` workflow (functional, sandboxed)
**Runs:** seed a temp project in the "existing" shape (specs still in `docs/`: `architecture.md`, `pipeline.md`, `components.md`, `documentation-plan.md`, `test-plan.md`, `security-requirements.md`, `ux-guidelines.md`, `task-detail-standard.md`, plus `research/`, `security/`, `runbooks/` subfolders, and a user-created decoy file in `docs/`). Run `migrate-sdlc` (bash). Assert: every listed spec moved to `.sdlc/`, user-facing files and the decoy untouched, no listed spec remains in `docs/`. Run a **second** time and assert a clean no-op (idempotency). Seed a collision (spec already at `.sdlc/` destination) and assert it is reported, not silently overwritten.
**Needs:** `bash` (and `pwsh` for the parity run in stage 5), temp dirs.
**Duration:** ~1 min.
**Pass criteria:** matches swe-feature-093 and qa-feature-094 — full relocation, user files preserved, idempotent re-run, collision reported.
**Blocks:** stage 5.

### 5. Parity — bash vs. PowerShell
**Runs:** repeat stages 3 and 4 against the PowerShell entry points (`install.ps1`, the PowerShell `migrate-sdlc`) and diff the resulting `docs/` and `.sdlc/` trees against the bash runs.
**Needs:** `pwsh`.
**Duration:** ~1-2 min.
**Pass criteria:** identical end-state layout from both harnesses (per the M14 parity discipline).
**Blocks:** stage 6.

### 6. Deliver (no automated deploy)
**Runs:** commit/merge to `main`; the toolkit is "delivered" by users running the updated `install.sh`/`install.ps1` and then `migrate-sdlc` on their own projects.
**Needs:** git push access (human-gated, per CLAUDE.md commit/push policy).
**Verification:** the documented `migrate-sdlc` entry point exists and is reachable from the user's re-installed project (swe-feature-093 AC: "Documented entry point").

## Pipeline Requirements

- **CI system:** none exists today. Two viable implementations — (a) a single local verification script (`.agents/scripts/verify-sdlc-boundary.sh`, mirrored in `.ps1`) that runs stages 1-5, or (b) a GitHub Actions workflow that runs the same stages on a Linux + macOS matrix with `pwsh` installed. Recommend starting with the local script (cheap, matches the toolkit's "scripts express behavior" convention) and deferring CI YAML unless the team wants gating on every PR.
- **Infrastructure:** one POSIX/macOS host with `bash`, `pwsh`, `shellcheck`, `grep`, and writable temp space. No emulator, no hardware, no external services.
- **Credentials/secrets:** none. M19 touches no network resource, no registry, no signing. Git push is the only privileged action and stays human-gated.
- **Estimated total duration:** ~5 minutes end-to-end, dominated by the sandboxed install/migrate runs.

## Not Included (and Why)

- **Build / compile / package / signing stages** — M19 produces no compiled artifact; the deliverable is the script and text payload installed verbatim. Nothing to compile or sign.
- **Emulator (Tier 2), hardware-in-the-loop (Tier 3), on-target (Tier 4) test stages** — no such infrastructure exists or is needed; verification is host-local shell execution in temp sandboxes.
- **A registry/server deploy stage** — there is no runtime service; "deploy" is a user re-installing and migrating. Covered as stage 6 (Deliver) rather than an automated push.
- **Coverage thresholds** — not meaningful for shell glue and instruction text; the grep audit + functional assertions are the coverage proxy.

## Implementation Approach (proposal for the gate)

This pipeline is **document-led**. The verification logic (stages 1-5) is naturally a small bash + PowerShell script pair, which fits the toolkit convention that "mechanical operations use scripts in `.agents/scripts/`." If the team wants this codified, it is an SWE task — note that the existing **qa-feature-094** already owns running the grep audit + end-to-end install/migration/fail-loud/parity verification for M19, so the pipeline's stages map directly onto that QA task rather than needing a separate CI-config issue. Recommend **not** filing a new `devops-feature` issue yet; fold pipeline execution into qa-feature-094 unless the human gate wants a standing CI workflow, in which case file one then.
