# Update Install Scripts for System Architect Expert

**Type:** feature
**Expert:** swe
**Milestone:** [Expert Skill Restructure] System Architect expert with full skill set (M3)
**Status:** backlog

## User Story

As a toolkit user, I want the install script to recognize and install the System Architect expert so that when I set up a project, the System Architect role, skills, and commands are available alongside the other experts.

## Description

Update `framework/install/install.sh` and `framework/install/install.ps1` to support the new System Architect expert. This includes name resolution, prefix mapping, clean-up patterns, and deciding whether System Architect is included in the default expert list or opt-in.

## Acceptance Criteria

- [ ] `resolve_expert_name()` maps `sa` and `system-architect` to `system-architect`
- [ ] `resolve_expert_prefix()` maps `system-architect` to `sa`
- [ ] Skill prefix comment block at top of script updated to include `sa- → system-architect`
- [ ] Clean previous installation loop includes `sa` prefix
- [ ] `--experts` flag accepts `sa` or `system-architect` as valid values
- [ ] Generated CLAUDE.md and project-os.mdc include System Architect in expert list and skill list when installed
- [ ] Skill prefix inference line updated: `sa=System Architect` added to "If the user jumps straight into a skill" instruction
- [ ] `install.ps1` updated with equivalent changes
- [ ] Default `EXPERT_LIST` decision made and documented: System Architect included in defaults or opt-in (flag for user decision)
- [ ] Running `./install.sh ~/testproj` with System Architect included produces correct directory structure and files

## Technical Notes

**Estimated effort:** Small session
**Dependencies:** swe-feature-001 (System Architect expert must exist to install)
**Inputs:** `framework/install/install.sh`, `framework/install/install.ps1`, project brief
**Out of scope:** Team mode install scripts (`install-team.sh`, `install-team.ps1`). Those are a separate concern if they need updates.
