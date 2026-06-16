#!/usr/bin/env bash
set -euo pipefail

if [ ! -d ".workflow/issues" ]; then
  echo "Error: '.workflow/issues/' directory not found. Run this script from the project root." >&2
  exit 1
fi

max=0
for dir in .workflow/issues/backlog .workflow/issues/planned .workflow/issues/in-progress .workflow/issues/done; do
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
