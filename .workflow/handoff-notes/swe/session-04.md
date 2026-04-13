# Handoff Note: Update Install Scripts for System Architect Expert

**Session date:** 2026-03-12
**Issue:** swe-feature-006 — Update Install Scripts for System Architect Expert

## What Was Accomplished

Updated both install scripts (`install.sh` and `install.ps1`) to fully support the System Architect expert. The SA expert is now included in the default expert list and installs automatically alongside PM, SWE, QA, and DevOps. Both scripts were verified end-to-end on macOS (bash and PowerShell).

## Acceptance Criteria Status
- [x] `resolve_expert_name()` maps `sa` and `system-architect` to `system-architect`
- [x] `resolve_expert_prefix()` maps `system-architect` to `sa`
- [x] Skill prefix comment block at top of script updated to include `sa- → system-architect`
- [x] Clean previous installation loop includes `sa` prefix
- [x] `--experts` flag accepts `sa` or `system-architect` as valid values
- [x] Generated CLAUDE.md and project-os.mdc include System Architect in expert list and skill list when installed
- [x] Skill prefix inference line updated: `sa=System Architect` added
- [x] `install.ps1` updated with equivalent changes
- [x] Default `EXPERT_LIST` decision made: System Architect included in defaults
- [x] Running `./install.sh ~/testproj` produces correct directory structure and files (verified)
- [x] Running `install.ps1 -Target ~/testproj` produces correct directory structure and files (verified)

## Decisions Made This Session
| Decision | Reasoning |
|----------|-----------|
| System Architect included in default expert list | User decision — SA is a core expert, not optional |

## Problems Encountered
None.

## Scope Changes
None. Stayed within issue scope.

## Files Modified
- `framework/install/install.sh` — 8 edits: header comments, default expert list, resolve_expert_name, resolve_expert_prefix, both cleanup loops, both generated config templates
- `framework/install/install.ps1` — 8 edits: header comments, default param, Resolve-ExpertName, Resolve-ExpertPrefix, both cleanup loops, both generated config templates

## What the Next Session Needs to Know
The install scripts now fully support the System Architect expert. The M3 milestone (Expert Skill Restructure) remaining tasks are:
- **swe-feature-004:** Update SWE `/start`, docs-protocol, and role files for `architecture.md` (project brief says this is completed)
- **qa-feature-005:** QA review of the full expert skill restructure for consistency

## Open Questions
None.
