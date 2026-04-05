# Create Cursor-Native DevOps and System Architect Expert Skills

**Type:** feature
**Expert:** swe
**Milestone:** M11
**Status:** backlog

## User Story

As a Cursor user running DevOps or System Architect sessions, I want autonomous skills (pipeline design, architecture research, reviews) to be discoverable without commands, while safety-critical operations (deployment) remain explicit.

## Description

Transform the DevOps (6 files) and System Architect (6 files) canonical skill files into Cursor-native formats per the design from sa-feature-033. DevOps has env-discovery (command), deploy (command), pipeline (skill), release-plan (skill), start (hybrid), handoff (hook). SA has design (skill), research (skill), review (skill), update (skill), start (hybrid), handoff (hook).

## Acceptance Criteria

- [ ] DevOps `start` → hybrid (auto context loading; approval gates remain)
- [ ] DevOps `handoff` → auto-trigger hook
- [ ] DevOps `env-discovery` → Cursor command (requires heavy human interaction)
- [ ] DevOps `pipeline` → discoverable skill (design from env-context, user reviews)
- [ ] DevOps `release-plan` → discoverable skill (produce plan, user reviews)
- [ ] DevOps `deploy` → Cursor command (safety-critical — multiple approval gates required)
- [ ] SA `start` → hybrid (auto context loading; approval gates remain)
- [ ] SA `handoff` → auto-trigger hook
- [ ] SA `design` → discoverable skill (analytical design with user trade-off decisions)
- [ ] SA `research` → discoverable skill (autonomous investigation, user decides on recommendation)
- [ ] SA `review` → discoverable skill (autonomous architectural review)
- [ ] SA `update` → discoverable skill (user must approve architectural changes)
- [ ] All skills reference shell scripts from `.cursor/scripts/` for mechanical operations
- [ ] Each skill has its own context loading steps

## Technical Notes

**Estimated effort:** Medium session
**Dependencies:** sa-feature-033 (design), swe-feature-034 (shell scripts), swe-feature-035 (Cursor rules structure)
**Inputs:** project brief, sa-feature-033 design, `experts/technical/devops/skills/*.md`, `experts/technical/system-architect/skills/*.md`
**Out of scope:** Other experts. Claude Code version.
