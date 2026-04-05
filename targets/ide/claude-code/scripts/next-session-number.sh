#!/usr/bin/env bash
set -euo pipefail

# Atomically claims the next session number by creating a placeholder file.
# Prevents concurrent sessions from claiming the same number.
#
# Usage: next-session-number.sh <expert-name>
# Output: two-digit session number (e.g., "07")
# Side effect: creates docs/handoff-notes/<expert>/session-NN.md placeholder

if [ -z "${1:-}" ]; then
  echo "Usage: next-session-number.sh <expert-name>" >&2
  exit 1
fi

expert="$1"
dir="docs/handoff-notes/$expert"

mkdir -p "$dir"

max=0
for file in "$dir"/session-*.md; do
  [ -f "$file" ] || continue
  num=$(basename "$file" .md | grep -oE '[0-9]+' || true)
  if [ -n "$num" ] && [ "$((10#$num))" -gt "$max" ]; then
    max=$((10#$num))
  fi
done

next=$((max + 1))
max_attempts=10

while [ "$next" -le "$((max + max_attempts))" ]; do
  candidate="$dir/session-$(printf '%02d' "$next").md"
  if (set -C; echo "<!-- session claimed -->" > "$candidate") 2>/dev/null; then
    printf "%02d\n" "$next"
    exit 0
  fi
  next=$((next + 1))
done

echo "Error: failed to claim a session number after $max_attempts attempts" >&2
exit 1
