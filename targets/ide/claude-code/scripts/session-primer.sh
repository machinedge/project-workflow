#!/usr/bin/env bash
# SessionStart hook — extract raw project context for agent priming.
# Outputs project identity, current status, and most recent handoff note.
# This is a mechanical extractor, not a summarizer (ADR-009).

set -euo pipefail

MAX_OUTPUT_LINES=120

output=""
line_count=0

append() {
  while IFS= read -r line || [[ -n "$line" ]]; do
    if (( line_count >= MAX_OUTPUT_LINES )); then
      output+="[output capped at ${MAX_OUTPUT_LINES} lines]"$'\n'
      return 1
    fi
    output+="$line"$'\n'
    (( line_count++ ))
  done
  return 0
}

# --- Project identity: first 20 lines of project brief ---
if [[ -f "docs/project-brief.md" ]]; then
  append <<< "=== Project Brief (top) ===" || { printf '%s' "$output"; exit 0; }
  append < <(head -n 20 "docs/project-brief.md") || { printf '%s' "$output"; exit 0; }
  append <<< "" || { printf '%s' "$output"; exit 0; }

  # --- Current Status section ---
  status_section=$(sed -n '/^## Current Status$/,/^## [^C]/{/^## [^C]/!p;}' "docs/project-brief.md" 2>/dev/null | head -n 15)
  if [[ -n "$status_section" ]]; then
    append <<< "=== Current Status ===" || { printf '%s' "$output"; exit 0; }
    append <<< "$status_section" || { printf '%s' "$output"; exit 0; }
    append <<< "" || { printf '%s' "$output"; exit 0; }
  fi
else
  append <<< "No project brief found at docs/project-brief.md" || { printf '%s' "$output"; exit 0; }
  append <<< "" || { printf '%s' "$output"; exit 0; }
fi

# --- Most recent handoff note across all experts ---
if [[ -d "docs/handoff-notes" ]]; then
  latest=""
  latest_mtime=0
  while IFS= read -r -d '' f; do
    mtime=$(stat -f '%m' "$f" 2>/dev/null || stat -c '%Y' "$f" 2>/dev/null || echo 0)
    if (( mtime > latest_mtime )); then
      latest_mtime=$mtime
      latest="$f"
    fi
  done < <(find "docs/handoff-notes" -name 'session-*.md' -print0 2>/dev/null)

  if [[ -n "$latest" ]]; then
    append <<< "=== Most Recent Handoff: ${latest} ===" || { printf '%s' "$output"; exit 0; }
    append < <(head -n 60 "$latest") || { printf '%s' "$output"; exit 0; }
  fi
fi

printf '%s' "$output"
