#!/usr/bin/env bash
set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Usage: next-session-number.sh <expert-name>" >&2
  exit 1
fi

expert="$1"
dir="docs/handoff-notes/$expert"

max=0
if [ -d "$dir" ]; then
  for file in "$dir"/session-*.md; do
    [ -f "$file" ] || continue
    num=$(basename "$file" .md | grep -oE '[0-9]+' || true)
    if [ -n "$num" ] && [ "$((10#$num))" -gt "$max" ]; then
      max=$((10#$num))
    fi
  done
fi

printf "%02d\n" $((max + 1))
