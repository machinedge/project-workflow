# Design .workflow Directory Structure and Path Mapping

**Type:** feature
**Expert:** sa
**Milestone:** [Workflow Directory] Update structure and references (M13)
**Status:** backlog

## User Story

As a system architect, I need a precise specification of the new `.sdlc/` directory layout and a complete mapping of old paths to new paths, so that downstream SWE tasks can execute mechanical find-and-replace without ambiguity.

## Description

Design the `.sdlc/` directory structure and produce a path mapping document. This is the reference that all subsequent implementation tasks will follow. The mapping must cover every path that currently references `docs/handoff-notes/`, `docs/interview-notes*`, `docs/lessons-log.md`, `docs/research-*`, and `issues/`.

## Acceptance Criteria

- [x] Path mapping table documents every old path and its new `.sdlc/` equivalent
- [x] Directory tree diagram shows the complete `.sdlc/` layout
- [x] `docs/` retention list explicitly names which files stay (`project-brief.md`, `roadmap.md`, `test-plan.md`, `architecture.md`, `agent-reference.md`)
- [x] Naming conventions for scripts that reference paths are documented (e.g. does `next-session-number.sh` change its output path?)
- [x] Edge cases documented: what happens when a skill references both a `docs/` file that stays and a `docs/` file that moves?
- [x] Design saved to `docs/architecture.md` as an addendum or ADR

## Technical Notes

**Estimated effort:** Small session
**Dependencies:** None
**Inputs:** `docs/project-brief.md`, `docs/roadmap.md`, `docs/interview-notes-workflow-directory.md`, `docs/architecture.md`
**Out of scope:** Implementation — this is design only

## Session 08 Summary

**What was done:** Designed `.sdlc/` directory structure as ADR-011 with complete path mapping (12 path pairs), docs retention list (7 entries), script path changes (7 scripts), conventions update, 6 edge cases, and implementation order for downstream SWE tasks.
**Handoff note:** `docs/handoff-notes/system-architect/session-08.md`
**All acceptance criteria met:** Yes
