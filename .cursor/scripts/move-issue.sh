#!/usr/bin/env bash
set -euo pipefail

if [ -z "${1:-}" ] || [ -z "${2:-}" ]; then
  echo "Usage: move-issue.sh <filename> <target-status>" >&2
  echo "  status: backlog | planned | in-progress | done" >&2
  exit 1
fi

filename="$1"
target="$2"

case "$target" in
  backlog|planned|in-progress|done) ;;
  *) echo "Error: Invalid status '$target'. Must be one of: backlog, planned, in-progress, done" >&2; exit 1 ;;
esac

[[ "$filename" == *.md ]] || filename="${filename}.md"

source_file=""
for dir in issues/backlog issues/planned issues/in-progress issues/done; do
  if [ -f "$dir/$filename" ]; then
    source_file="$dir/$filename"
    break
  fi
done

if [ -z "$source_file" ]; then
  echo "Error: '$filename' not found in any issues directory" >&2
  exit 1
fi

target_dir="issues/$target"
target_file="$target_dir/$filename"

if [ "$source_file" = "$target_file" ]; then
  echo "'$filename' is already in '$target'"
  exit 0
fi

mkdir -p "$target_dir"
mv "$source_file" "$target_file"
echo "Moved '$filename' from '$(dirname "$source_file")' to '$target_dir'"
