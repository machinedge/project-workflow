# Handoff Note: Design Platform-Native Architecture

**Issue:** sa-feature-033 — Design Platform-Native Architecture for Cursor and Claude Code

## What Was Accomplished
Designed the complete platform-native architecture for both Cursor and Claude Code. Mapped all 45 canonical expert files to platform-native concepts, defined directory structures for both platforms, specified auto-triggering and context loading mechanisms, extracted shell script specifications, and absorbed all 4 M10 context optimization recommendations. Produced 4 new ADRs (005-008).

## Acceptance Criteria Status
- [x] Every canonical file in `experts/technical/` has a defined mapping to a Cursor-native concept (rule, skill, command, hook, or tool)
- [x] Every canonical file has a defined mapping to a Claude Code-native concept
- [x] Directory structure defined for `targets/ide/cursor/` (what goes where, naming conventions)
- [x] Directory structure defined for `targets/ide/claude-code/` (what goes where, naming conventions)
- [x] Cursor skill discovery mechanism validated — how does the agent find and invoke discoverable skills?
- [x] Claude Code skill/hook mechanism validated — what events can trigger behavior?
- [x] Shell script integration points defined (where scripts live in repo vs. installed project)
- [x] Handoff auto-trigger mechanism defined for both platforms (what triggers it, how it works)
- [x] Context auto-loading mechanism defined for both platforms (how `/start` Phase 1 becomes automatic)
- [x] M10 recommendations (1-4) mapped to specific implementation steps
- [x] Design saved to `docs/architecture.md` (updated, not replaced)

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|
| ADR-005: Handoffs + autonomous skills as discoverable skills (not commands) | Skills support both agent discovery AND explicit `/skill-name` invocation — best of both worlds. 21 skills + 9 commands. |
| ADR-006: Soft auto-trigger for handoff on both platforms | Cursor lacks session-end hook; Claude Code's SessionEnd can't run complex workflows. Consistent soft-trigger (role instruction + skill discovery) preferred over platform divergence. |
| ADR-007: Shell scripts in `.cursor/scripts/` and `.claude/scripts/` | Scripts are implementation details, not user-facing. Hidden in platform config dirs, accessible to agent via Shell tool. |
| ADR-008: Direct-copy install replaces translation pipeline | Platform-native implementations are pre-built. Translation adds complexity without value. Install becomes a file copy operation. |
| Renamed `.cursor/tools/` → `.cursor/scripts/` (and `.claude/tools/` → `.claude/scripts/`) | User feedback — "scripts" is more explicit and descriptive than "tools" for shell script directories. |

## Downstream Impact
- **SWE (swe-feature-034 through swe-feature-038, swe-feature-040/041):** The canonical file mapping table (36 rows) and SKILL.md format spec are the execution blueprint. Each SWE task should reference the relevant rows. The "Skill Content Adaptation Rules" (5 rules) define exactly how to convert canonical files.
- **QA (qa-feature-039, qa-feature-042):** Verify skill discovery triggers correctly, handoff auto-trigger reliability, and that all 21 skills + 9 commands install correctly for each platform.
- **DevOps/SWE (swe-feature-044):** Install script rewrite follows the "Install Script Changes" spec — direct copy, no translation, with settings.json merge for Claude Code.

## Problems Encountered
None. The design was straightforward given the thorough inputs (M10 research, interview notes, existing architecture). The main complexity was resolving Cursor's unreliable agent-decided loading (~50% reliability for auto-discovery) — resolved by using dual-path (always-loaded routing rule + agent-decided expert rules).

## Files Created or Modified
- `docs/architecture.md` — Added Platform-Native Architecture section (~300 lines), ADR-005 through ADR-008, updated Directory Layout (targets internal structure), updated Data Flow (direct-copy model for IDE targets)

## What the Next Session Needs to Know
The architecture design is complete and approved. The next step is SWE execution, starting with swe-feature-034 (shell scripts) and swe-feature-035 (Cursor rules and project structure). SWE should read the "Platform-Native Architecture" section of `docs/architecture.md` — it contains the complete file mapping, directory structures, SKILL.md format spec, script specifications, and content adaptation rules needed to implement.

Key implementation detail: each SKILL.md needs a carefully crafted `description` field (max 1024 chars) that triggers agent discovery correctly. The description should answer "what does this skill do?" and "when should the agent use it?"

## Open Questions
- [ ] Claude Code `Stop` prompt hook as handoff safety net — deferred to post-M11 enhancement (noted in ADR-006)
