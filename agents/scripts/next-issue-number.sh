#!/usr/bin/env bash
set -euo pipefail

if [ ! -d ".sdlc/issues" ]; then
  echo "Error: '.sdlc/issues/' directory not found. Run this script from the project root." >&2
  exit 1
fi

max=0
for dir in .sdlc/issues/backlog .sdlc/issues/planned .sdlc/issues/in-progress .sdlc/issues/done; do
  [ -d "$dir" ] || continue
  for file in "$dir"/*.md; do
    [ -f "$file" ] || continue
    num=$(basename "$file" .md | grep -oE '[0-9]+$' || true)
    if [ -n "$num" ] && [ "$((10#$num))" -gt "$max" ]; then
      max=$((10#$num))
    fi
  done
done

printf "%03d\n" $((max + 1))
