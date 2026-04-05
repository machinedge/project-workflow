# Create Cursor-Native PM Expert Skills

**Type:** feature
**Expert:** swe
**Milestone:** M11
**Status:** backlog

## User Story

As a Cursor user running a PM session, I want planning skills to be discoverable by the AI without me typing slash commands so that I can focus on the work instead of memorizing commands.

## Description

Transform the 10 PM canonical skill files into Cursor-native formats per the design from sa-feature-033. Skills that are autonomous become discoverable skills. Interview-style files stay as explicit commands. Handoff becomes an auto-triggered hook. `/start` becomes a hybrid with auto context loading and explicit approval gates.

## Acceptance Criteria

- [ ] `interview` → Cursor command (requires heavy human interaction)
- [ ] `add_feature` → Cursor command (requires human interaction for medium/large features)
- [ ] `vision` → discoverable skill (autonomous with light review)
- [ ] `roadmap` → discoverable skill (autonomous with light review)
- [ ] `decompose` → discoverable skill (autonomous with light review)
- [ ] `update_plan` → discoverable skill (autonomous with light review)
- [ ] `postmortem` → discoverable skill (autonomous with light review)
- [ ] `start` → hybrid (context loads automatically via rule/skill; approval gates at Phase 1 and 2 remain explicit)
- [ ] `handoff` → auto-trigger hook (fires when user signals session end; no `/handoff` command needed)
- [ ] `status` → discoverable skill (fully autonomous, no human interaction)
- [ ] All skills reference shell scripts from `.cursor/scripts/` for mechanical operations (issue numbering, file movement, etc.)
- [ ] Each skill has its own context loading steps (not relying on session protocol preamble)

## Technical Notes

**Estimated effort:** Medium session
**Dependencies:** sa-feature-033 (design), swe-feature-034 (shell scripts), swe-feature-035 (Cursor rules structure)
**Inputs:** project brief, sa-feature-033 design, `experts/technical/project-manager/skills/*.md` (canonical reference), `experts/technical/project-manager/role.md`
**Out of scope:** Other experts. Claude Code version. Testing (QA task).
