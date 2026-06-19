# Test Plan

**Scope/Verdict:** M19 [SDLC Boundary] — verify that expert-authored specs now live in `.sdlc/` (not `docs/`), that `docs/` holds only user-facing material, that consumers fail loudly on a missing *required* spec, and that the new `migrate-sdlc` workflow relocates an existing project's specs idempotently and collision-safely. The milestone is verifiable almost entirely by a **deterministic grep audit** plus a handful of **temp-dir install/migration drives**; the one named project risk is analysis-paralysis, so this plan stays proportionate — it tests the file-integrity boundary hard and treats the instruction-text edits as grep-and-read checks, not behavioral simulations.
**Created:** 2026-06-19
**Last updated:** 2026-06-19

## What this milestone is (for a reader new to it)

The toolkit used to dump everything into `docs/` — both the specs experts write for each other (architecture, test plan, security requirements, …) and the docs a human reads to understand the project (guides, README, project brief, roadmap). M19 draws one line: `docs/` is **user-facing only**; every expert-authored spec/plan/draft moves to `.sdlc/`. Three behaviors protect that line:

1. **Repoint** — every skill, role, runbook, accelerator, and both installers now read/write specs at `.sdlc/<spec>.md`. (swe-feature-088/089/090/092)
2. **Fail loud** — a consumer that *requires* a spec stops with a named error and a remedy when it is absent at `.sdlc/`, instead of degrading silently. (swe-feature-091)
3. **Migrate** — a new `migrate-sdlc` workflow (bash + PowerShell) relocates an existing project's specs `docs/ → .sdlc/`, idempotently and without clobbering. (swe-feature-093)

There is **no runtime service, no network, no auth, no executable that throws** in this milestone. Behavior is expressed as agent *instruction text* plus two shell scripts that do `mv`. The only credible risk is the shell scripts mishandling a user's files — so that is where the testing weight goes.

### In scope
- The boundary audit grep: zero stale `docs/<spec>.md` authoring/consume references across `agents/`, both installers, and the project brief (swe-feature-088/089/090, qa-feature-094, SR-007).
- Fresh-install layout: `docs/` seeds no specs; `.sdlc/{research,security,runbooks}` and the existing scaffolding are created; bash/PowerShell parity (swe-feature-092).
- Fail-loud on a missing *required* spec, with the tiered rule (architecture always; surface-scoped specs only when the milestone has that surface) (swe-feature-091, SR-008, ADR-M19-2).
- `migrate-sdlc` relocation, idempotency, collision no-clobber (report + non-zero exit, source untouched), the canonical draft-glob filter, and target-path validation (swe-feature-093, SR-001..SR-006).
- Cross-harness bash/PowerShell parity for installer and migration (SR-006).

### Out of scope
- Spec **content** correctness — M19 relocates files; it does not change what any spec says.
- The whole-system architecture and any milestone other than M19.
- `docs/project-brief.md`, `docs/roadmap.md`, `docs/agent-reference.md` — these stay in `docs/` by audience rule (ADR-M19-1) and must be proven *untouched*, not moved.
- Backlog item pm-feature-087 (signposting guides into `.sdlc/` reasoning) — explicitly deferred.

## Test instruments

This milestone has **no unit-test harness**. There are exactly three instruments, in priority order:

1. **Boundary audit grep (primary).** A single deterministic regex over the source tree. Pass = zero authoring/consume hits. This is the milestone's CI gate.
2. **Temp-dir drives.** Run `install.sh`/`install.ps1` and `migrate-sdlc.sh`/`.ps1` into throwaway directories and assert on the resulting file tree, exit codes, and printed report. Objective and repeatable.
3. **Read-trace.** For fail-loud (instruction text, not code), read the consume step and confirm the named error + remedy string is present and correctly tiered. This is the honest ceiling — see Coverage Gaps.

## Test Matrix

Five acceptance areas. Priority key: **P1** must test (core / high-risk / blocking); **P2** should test.

| # | Acceptance area | Source | Level / approach | SR / ADR | Priority |
|---|-----------------|--------|------------------|----------|----------|
| 1 | **Boundary audit grep** — zero stale `docs/<spec>.md` authoring/consume refs across `agents/`, `install.sh`, `install.ps1`, `docs/project-brief.md` | qa-feature-094; swe-088/089/090 | Static / deterministic grep (ATP-0) | SR-007 | P1 |
| 1a | User-facing refs (`docs/guides/`, `project-brief.md`, `roadmap.md`, `README.md`, `agent-reference.md`) left in place — no false-positive repoint | swe-089 AC; ADR-M19-1 | Static / grep diff | SR-007 | P1 |
| 2 | **Fresh-install layout** — `docs/` created but seeds **no** spec file (and nothing else); `.sdlc/{research,security,runbooks}` + `issues/*` + per-expert `handoff-notes/` + seeded `lessons-log.md` created | swe-092 AC | Integration / temp-dir drive (ATP-1) | SR-004 | P1 |
| 2a | Installer re-run idempotent — a seeded user file in `docs/` and in `.sdlc/` survives a second `install.sh` byte-identical | swe-092 AC | Integration (ATP-1) | SR-004 | P1 |
| 2b | Installer comment no longer claims specs belong in `docs/` ("architecture, etc." text gone) | swe-092 AC | Static / grep | — | P2 |
| 3 | **Fail-loud, required-always** — a consumer of `architecture.md` (widest fan-out) stops with the named error + remedy when `.sdlc/architecture.md` is absent | swe-091 AC; sec-review/qa-review/swe.md | Read-trace (ATP-2) | SR-008 | P1 |
| 3a | **Fail-loud, surface-scoped** — a surface spec (e.g. `ux-guidelines.md`) hard-fails only when the milestone has that surface; on a no-UX milestone its absence is a documented no-op (proceed) | swe-091 AC; ADR-M19-2 | Read-trace (ATP-2) | SR-008 | P1 |
| 3b | Message shape — every fail-loud string names the file *and* the verbatim remedy (`Produce it with <skill>` / `run migrate-sdlc`); AGENTS.md "Workflow contracts" states the hard-fail rule | swe-091 AC | Read-trace / grep | SR-008 | P2 |
| 4 | **Migrate relocation** — every canonical file + canonical `*-draft.md` + `research/`/`security/`/`runbooks/` moves `docs/ → .sdlc/`; exit 0; report lists the relocated set | swe-093 AC | Integration / temp-dir drive (ATP-3) | SR-002, SR-003 | P1 |
| 4a | **Idempotency** — second run moves nothing, prints "Already clean", exits 0; `.sdlc/` content byte-identical to after run 1 | swe-093 AC | Integration (ATP-3) | SR-004 | P1 |
| 4b | **Collision no-clobber** — with both `docs/architecture.md` and a *different* `.sdlc/architecture.md` present, neither file's content is lost, the collision is reported by name, and the run exits **non-zero**; the `docs/` source is left in place | swe-093 AC; sec-requirements gate finding | Integration (ATP-3) | SR-001, SR-002 | P1 |
| 4c | **Draft-glob filter** — only canonical-spec drafts (`<spec>.*-draft.md`) move; a user file like `docs/my-blog-post-draft.md` is left in `docs/` untouched (this was a real divergence — see ATP-3 step 5 and Coverage Gaps) | swe-093 interface; migrate-sdlc.sh `is_canonical_draft` | Integration (ATP-3) | SR-003 | P1 |
| 4d | **User files untouched** — `docs/guides/`, `README.md`, `project-brief.md`, `roadmap.md`, `agent-reference.md`, and an unknown `docs/notes.md` are byte-identical and still in `docs/` after migration | swe-093 AC | Integration (ATP-3) | SR-003 | P1 |
| 4e | **Target validation** — invoke with an empty `""` target and a path containing a space; empty aborts non-zero with no move/delete, spaced path is handled correctly | swe-093 AC | Integration (ATP-3) | SR-005 | P1 |
| 4f | No file *contents* echoed to stdout/stderr — only paths | swe-093 AC; SR secrets note | Integration (ATP-3) | — | P2 |
| 5 | **Cross-harness parity** — `install.ps1` and `migrate-sdlc.ps1` (under `pwsh`) produce a tree + report identical to their bash counterparts on the same fixture | swe-092/093 AC | Integration / pwsh drive + diff (ATP-4) | SR-006 | P1 |

## Acceptance Test Procedures

All procedures run from the repo root on a local dev machine with throwaway temp dirs. `pwsh` on macOS is required for ATP-4. Each step has an objective pass condition (exit code, empty diff, or a named grep match).

### ATP-0: Boundary audit grep (Test 1, 1a) — the primary gate
**Prerequisites:** none. Run from repo root.

1. Run the canonical audit grep (the milestone's CI gate, from qa-feature-094 / architecture path contract):
   ```
   grep -rn -E 'docs/(architecture|pipeline|components|documentation-plan|test-plan|security-requirements|ux-guidelines|task-detail-standard|env-context|release-plan)\.md|docs/(research|security|runbooks)/' agents/ install.sh install.ps1 docs/project-brief.md
   ```
2. Triage every hit. A hit is allowed **only** if it is a deliberate, documented reference to a file that stays in `docs/` by audience rule (none of the canonical spec names should appear). No *authoring* or *consume* hit on a canonical spec may remain.
3. Confirm user-facing references survive (no false-positive repoint):
   ```
   grep -rn -E 'docs/(guides/|project-brief\.md|roadmap\.md|README\.md|agent-reference\.md)' agents/ docs/project-brief.md
   ```
   These must still resolve to `docs/`.

**Pass condition:** Step 1 returns **zero** lines (or only documented, non-spec exceptions). Step 3 shows the user-facing references unchanged. Verifies SR-007.

### ATP-1: Fresh install layout + idempotency (Tests 2, 2a, 2b)
**Prerequisites:** clean temp dir. `A=$(mktemp -d)`.

1. `./install.sh "$A"`.
2. `test -d "$A/docs"` — `docs/` exists.
3. `[ -z "$(ls -A "$A/docs" 2>/dev/null)" ]` — `docs/` is empty: no spec file, no `guides/`, nothing seeded.
4. `test -d "$A/.sdlc/research" && test -d "$A/.sdlc/security" && test -d "$A/.sdlc/runbooks"` — the three spec subfolders exist.
5. `test -d "$A/.sdlc/issues/backlog" && test -d "$A/.sdlc/issues/planned" && test -d "$A/.sdlc/issues/in-progress" && test -d "$A/.sdlc/issues/done" && test -d "$A/.sdlc/handoff-notes/pm" && test -f "$A/.sdlc/lessons-log.md"` — existing scaffolding intact.
6. `! ls "$A/.sdlc"/*.md 2>/dev/null | grep -E '(architecture|test-plan|security-requirements|ux-guidelines|pipeline|release-plan)\.md'` — only `lessons-log.md` seeded; no spec file.
7. Idempotency: `echo user > "$A/docs/myfile.md"; echo spec > "$A/.sdlc/myspec.md"; ./install.sh "$A"; grep -qx user "$A/docs/myfile.md" && grep -qx spec "$A/.sdlc/myspec.md"` — both survive byte-identical.
8. Comment fix (against the repo, not the target): `! grep -q 'architecture, etc.' install.sh`.
9. Cleanup: `rm -rf "$A"`.

**Pass condition:** every check exits 0. `docs/` seeds nothing; `.sdlc/` has the spec subfolders and existing scaffolding; re-run clobbers nothing. Verifies SR-004.

### ATP-2: Fail-loud on a missing required spec (Tests 3, 3a, 3b)
This is instruction text, not an executable, so the procedure is a **read-trace**: confirm the consume step carries the correct directive, message, and tier. (See Coverage Gaps for why this is the honest ceiling.)

**Prerequisites:** none — read the source files.

1. **Required-always (architecture).** Open the widest-fan-out architecture consumers — `agents/skills/sa-review/SKILL.md`, `agents/skills/qa-review/SKILL.md`, `agents/roles/swe.md`. Confirm each architecture consume step says: read `.sdlc/architecture.md`; if absent, STOP and report the named error — `architecture.md not found at .sdlc/architecture.md. Produce it with sa-design, or run migrate-sdlc for an existing project.` — and does **not** carry a bare "(if it exists)" soft-skip.
2. **Surface-scoped (UX).** Open `agents/skills/ux-review/SKILL.md`. Confirm the `ux-guidelines.md` consume distinguishes two branches: UX surface exists but guideline absent ⇒ hard fail with the `ux-guidelines` remedy; no UX surface ⇒ proceed (documented no-op, not an error).
3. **Message shape + convention.** Grep the fail-loud strings carry both the file path and a remedy verb:
   ```
   grep -rn 'not found at .sdlc/' agents/ | grep -E 'Produce it with|run migrate-sdlc'
   ```
   Read `agents/AGENTS.md` "Workflow contracts" and confirm it states a missing *required* `.sdlc/` spec is a hard failure that names the file + remedy, with optional/no-surface specs exempt.
4. **Soft-skip residue check (negative).** Confirm no *required* consume step still says "(if it exists)" on `architecture.md`:
   ```
   grep -rn 'architecture.md (if it exists)' agents/
   ```
   Expect zero hits on a required consume step (surface-scoped no-op branches and team-status/team-docs gather-reads may legitimately remain soft and are excluded).

**Pass condition:** architecture consumers fail loud with the verbatim named message; the UX surface-scoped consumer keeps the no-op branch; AGENTS.md codifies the rule; no required architecture consume retains a soft skip. Verifies SR-008 / ADR-M19-2.

### ATP-3: migrate-sdlc relocation, idempotency, collision, user-file safety (Tests 4–4f)
**Prerequisites:** a seeded fixture mimicking an existing project with specs still in `docs/`.

**Build fixture `F`:**
```
F=$(mktemp -d)
mkdir -p "$F/docs/guides" "$F/docs/research" "$F/docs/security" "$F/docs/runbooks" "$F/.sdlc"
# canonical spec files
for f in architecture pipeline components documentation-plan test-plan \
         security-requirements ux-guidelines task-detail-standard env-context release-plan; do
  echo "$f-content" > "$F/docs/$f.md"; done
# a canonical-spec draft (must move) and a user draft (must NOT move)
echo draft        > "$F/docs/architecture.m1-draft.md"
echo userdraft    > "$F/docs/my-blog-post-draft.md"
# user-facing files (must stay)
echo guide   > "$F/docs/guides/intro.md"
echo readme  > "$F/docs/README.md"
echo brief   > "$F/docs/project-brief.md"
echo road    > "$F/docs/roadmap.md"
echo ref     > "$F/docs/agent-reference.md"
echo notes   > "$F/docs/notes.md"   # unknown user file
```

1. **Full relocation (Test 4, 4d).** Run `bash agents/scripts/migrate-sdlc.sh "$F"`; capture exit code and stdout.
   - Pass: exit 0; every canonical `.md` and `architecture.m1-draft.md` and the three subfolders now under `.sdlc/`, none under `docs/`; report prints a "Relocated:" set.
   - Pass: `docs/guides/intro.md`, `README.md`, `project-brief.md`, `roadmap.md`, `agent-reference.md`, `notes.md` are byte-identical and still under `docs/`.
2. **Draft-glob filter (Test 4c).** Assert `test -f "$F/docs/my-blog-post-draft.md"` (the user draft stayed) **and** `test -f "$F/.sdlc/architecture.m1-draft.md"` (the canonical draft moved). This is an explicit, load-bearing case — see Coverage Gaps for the bash/PS divergence it guards.
3. **Idempotent re-run (Test 4a).** Snapshot `.sdlc/` (e.g. `find "$F/.sdlc" -type f | sort` + checksums), run `migrate-sdlc.sh "$F"` again.
   - Pass: exit 0; stdout contains `Already clean`; `.sdlc/` snapshot byte-identical to after run 1.
4. **Collision no-clobber (Test 4b).** New fixture `C=$(mktemp -d)`; `mkdir -p "$C/docs" "$C/.sdlc"`; `echo OLD > "$C/docs/architecture.md"`; `echo NEW > "$C/.sdlc/architecture.md"`; run `migrate-sdlc.sh "$C"`.
   - Pass: exit code **non-zero**; stderr names the collision (`COLLISION: …architecture.md…`); `grep -qx OLD "$C/docs/architecture.md"` and `grep -qx NEW "$C/.sdlc/architecture.md"` both hold — neither file lost, source left in place. (This is the explicit deviation from the M14 `rm "$src"` data-loss prior art.)
5. **Report completeness (Test 4 / SR-002).** In a fixture with a mix of movable and colliding specs, confirm the report names both the relocated set and the collision — no silent skip.
6. **Target validation (Test 4e).** `bash agents/scripts/migrate-sdlc.sh ""` exits non-zero with a clear message and performs no move/delete; a target path containing a space is resolved and handled (no word-split breakage).
7. **No content echoed (Test 4f).** Inspect captured stdout/stderr from step 1: only paths appear, never spec file contents.
8. Cleanup: `rm -rf "$F" "$C"`.

**Pass condition:** all steps pass as stated. Verifies SR-001, SR-002, SR-003, SR-004, SR-005.

### ATP-4: Cross-harness parity (Test 5)
**Prerequisites:** `pwsh` available (macOS pwsh acceptable — see Coverage Gaps).

1. **Installer parity.** `A=$(mktemp -d); B=$(mktemp -d); ./install.sh "$A"; pwsh ./install.ps1 -Target "$B"`; then
   `diff <(cd "$A" && find docs .sdlc -print | sort) <(cd "$B" && find docs .sdlc -print | sort)`.
   - Pass: empty diff — identical `docs/` and `.sdlc/` trees including `research/`, `security/`, `runbooks/`.
2. **Migration parity.** Build two identical fixtures `Fa`, `Fb` (per ATP-3, including both the canonical draft and the user `my-blog-post-draft.md`). Run `bash agents/scripts/migrate-sdlc.sh "$Fa"` and `pwsh agents/scripts/migrate-sdlc.ps1 "$Fb"`; then diff the resulting `docs/` + `.sdlc/` trees and compare the printed reports.
   - Pass: identical end-state tree and equivalent report (same files moved, same files left, same collisions).
   - **Watch item (known divergence):** the bash script filters drafts to canonical specs (`is_canonical_draft`), but `migrate-sdlc.ps1` moves *every* `docs/*-draft.md` via `Get-ChildItem -Filter '*-draft.md'` with no canonical filter. On the shared fixture the bash run leaves `my-blog-post-draft.md` in `docs/` while the PowerShell run moves it to `.sdlc/`, so this diff is expected to be **non-empty**. Treat a non-empty diff here as a **parity defect to file** (SR-003/SR-006 violation), not a test-environment artifact.
3. Cleanup the temp dirs.

**Pass condition:** installer trees match exactly; migration trees match *except* for the documented draft-filter divergence, which must be filed as a defect. Verifies SR-005, SR-006.

## SR control coverage map

| SR | Control | Covered by |
|----|---------|-----------|
| SR-001 | Collision: report, never overwrite/`rm` source | ATP-3 step 4 (Test 4b) |
| SR-002 | Report lists relocated + skipped, no silent skips | ATP-3 steps 1, 5 (Test 4) |
| SR-003 | Move only named artifacts; user/unlisted files untouched; only `<spec>.*-draft.md` glob | ATP-3 steps 1, 2, 6 (Tests 4c, 4d) |
| SR-004 | Idempotent re-run; installer re-run no-clobber | ATP-1 step 7; ATP-3 step 3 (Tests 2a, 4a) |
| SR-005 | Quote/validate target; abort on empty/relative; no `rm -rf` unvalidated | ATP-3 step 6 (Test 4e) |
| SR-006 | bash/PowerShell identical end state | ATP-4 (Test 5) |
| SR-007 | Zero stale `docs/<spec>.md` authoring/consume refs | ATP-0 (Tests 1, 1a) |
| SR-008 | Required spec missing ⇒ named fail-loud; optional exempt | ATP-2 (Tests 3, 3a, 3b) |

## Coverage gaps / not tested

Honest limits of this plan. None is a blocker for M19, but each should be stated so the gate sees it.

- **Fail-loud is verified as instruction text, not runtime behavior.** The toolkit has no executable that throws on a missing spec — fail-loud is a *directive the agent is told to follow*. ATP-2 verifies the directive is present, correctly worded, and correctly tiered; it does **not** prove an LLM will always obey it. Actual compliance is non-deterministic and is best confirmed through real session usage, not a formal test. This is the ceiling of what can be tested without an LLM-in-the-loop rig.
- **Windows-native PowerShell is not tested.** ATP-4 runs `install.ps1` / `migrate-sdlc.ps1` under `pwsh` on macOS. Windows path separators (`\`), case-insensitive filesystems, and native `Move-Item` semantics could differ. The macOS pwsh run is a strong proxy but not a substitute for a Windows host.
- **Known parity defect surfaced, not yet resolved.** The bash and PowerShell migration scripts diverge on the draft glob: bash filters to canonical-spec drafts (`is_canonical_draft`), PowerShell moves all `*-draft.md`. ATP-3 step 2 and ATP-4 step 2 are written to *catch* this; the divergence violates SR-003 (move only named artifacts — no broad glob that matches user files) and SR-006 (parity). It must be filed to `.sdlc/issues/backlog/` and fixed in PowerShell (add a canonical-draft filter) before cross-harness use is claimed safe.
- **Spec content is not validated.** M19 moves files; it does not check that a moved `architecture.md` is correct or complete. Content correctness is the authoring skills' concern, out of scope here.
- **Multi-session continuity is not formally tested.** Whether a fail-loud error raised in one session leads a later session to the right remedy depends on real sequential usage, not a single drive.
