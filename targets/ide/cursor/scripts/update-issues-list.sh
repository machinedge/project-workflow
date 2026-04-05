#!/usr/bin/env bash
set -euo pipefail

if [ ! -d "issues" ]; then
  echo "Error: 'issues/' directory not found. Run this script from the project root." >&2
  exit 1
fi

output="issues/issues-list.md"

cat > "$output" << 'HEADER'
# Issues List

| File | Title | Expert | Type | Milestone | Prerequisites | Status |
|------|-------|--------|------|-----------|---------------|--------|
HEADER

# Collect rows: sort key | table row
{
  for dir in issues/backlog issues/planned issues/in-progress issues/done; do
    [ -d "$dir" ] || continue
    status=$(basename "$dir")
    for file in "$dir"/*.md; do
      [ -f "$file" ] || continue
      filename=$(basename "$file" .md)

      title=$(grep -m1 '^# ' "$file" | sed 's/^# //' || true)
      type=$(grep -m1 '^\*\*Type:\*\*' "$file" | sed 's/\*\*Type:\*\* *//' || true)
      expert=$(grep -m1 '^\*\*Expert:\*\*' "$file" | sed 's/\*\*Expert:\*\* *//' || true)
      milestone=$(grep -m1 '^\*\*Milestone:\*\*' "$file" | sed 's/\*\*Milestone:\*\* *//' || true)
      deps=$(grep -m1 '^\*\*Dependencies:\*\*' "$file" | sed 's/\*\*Dependencies:\*\* *//' || true)

      if [ -z "$deps" ] || [ "$deps" = "None" ] || [ "$deps" = "none" ]; then
        deps="—"
      else
        deps=$(echo "$deps" | sed 's/ ([^)]*)//g')
      fi

      num=$(echo "$filename" | grep -oE '[0-9]+$' || echo "0")

      echo "${num}|${filename}|${title}|${expert}|${type}|${milestone}|${deps}|${status}"
    done
  done
} | sort -t'|' -k1,1n | while IFS='|' read -r _num filename title expert type milestone deps status; do
  echo "| ${filename} | ${title} | ${expert} | ${type} | ${milestone} | ${deps} | ${status} |"
done >> "$output"

echo "Updated $output"
