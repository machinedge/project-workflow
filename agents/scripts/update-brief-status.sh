#!/usr/bin/env bash
set -euo pipefail

# Atomically updates the "Last updated" line in docs/project-brief.md under a lock.
# Prevents concurrent sessions from silently overwriting each other's status.
#
# Usage: update-brief-status.sh <issue-id> <status-description>
# Example: update-brief-status.sh swe-feature-049 "built concurrent handoff scripts"
# Output: "OK" on success
# Side effect: modifies docs/project-brief.md

if [ "$#" -lt 2 ]; then
  echo "Usage: update-brief-status.sh <issue-id> <status-description>" >&2
  exit 1
fi

issue_id="$1"
shift
status_desc="$*"

brief="docs/project-brief.md"
lockfile="docs/.update-brief.lock"

if [ ! -f "$brief" ]; then
  echo "Error: $brief not found" >&2
  exit 1
fi

cleanup() {
  rm -f "$lockfile"
}

acquire_lock() {
  local max_wait=10
  local waited=0

  while ! (set -C; echo $$ > "$lockfile") 2>/dev/null; do
    if [ "$waited" -ge "$max_wait" ]; then
      if [ -f "$lockfile" ]; then
        local lock_age
        lock_age=$(( $(date +%s) - $(stat -f %m "$lockfile" 2>/dev/null || stat -c %Y "$lockfile" 2>/dev/null || echo 0) ))
        if [ "$lock_age" -gt 5 ]; then
          rm -f "$lockfile"
          if (set -C; echo $$ > "$lockfile") 2>/dev/null; then
            return 0
          fi
        fi
      fi
      echo "Error: could not acquire lock after ${max_wait}s" >&2
      exit 1
    fi
    sleep 1
    waited=$((waited + 1))
  done
}

acquire_lock
trap cleanup EXIT

new_line="- **Last updated:** ${issue_id} complete; ${status_desc}"
tmpfile="${brief}.tmp"
found=0

while IFS= read -r line || [ -n "$line" ]; do
  if [[ "$line" == "- **Last updated:"* ]]; then
    echo "$new_line"
    found=1
  else
    echo "$line"
  fi
done < "$brief" > "$tmpfile"

if [ "$found" -eq 0 ]; then
  rm -f "$tmpfile"
  echo "Error: could not find '- **Last updated:**' line in $brief" >&2
  exit 1
fi

mv "$tmpfile" "$brief"
echo "OK"
