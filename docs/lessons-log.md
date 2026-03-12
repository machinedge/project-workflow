# Lessons Log

Record project-specific gotchas, patterns, and knowledge here. Future sessions will read this to avoid repeating mistakes.

| Date | Lesson | Context |
|------|--------|---------|
| 2026-03-12 | When updating role files to reference a new artifact, also update the corresponding `/start` skill's context loading phase. Role files and start skills must stay in sync. | QA review found PM, QA, DevOps role.md updated to consume architecture.md but their /start skills weren't. |
| 2026-03-12 | When creating a new expert, update CLAUDE.md repo guide in the same task — not as a follow-up. | System Architect was created but CLAUDE.md repo structure wasn't updated. |
| 2026-03-12 | When a script's directory depth changes during a restructure, use a walk-up approach (search for a known marker directory like `experts/`) instead of hardcoding `../..` levels. This makes the script work regardless of where it's placed — in the repo or in a built package. | `install-team.sh` moved from 2 to 3 levels deep but needs to work at both depths since package.sh copies it to a different location. |
