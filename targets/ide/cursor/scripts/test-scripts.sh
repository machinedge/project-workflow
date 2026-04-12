#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PASS=0
FAIL=0
TESTS=0

assert_eq() {
  local label="$1" expected="$2" actual="$3"
  TESTS=$((TESTS + 1))
  if [ "$expected" = "$actual" ]; then
    PASS=$((PASS + 1))
    echo "  PASS: $label"
  else
    FAIL=$((FAIL + 1))
    echo "  FAIL: $label"
    echo "    expected: '$expected'"
    echo "    actual:   '$actual'"
  fi
}

assert_file_exists() {
  local label="$1" path="$2"
  TESTS=$((TESTS + 1))
  if [ -f "$path" ]; then
    PASS=$((PASS + 1))
    echo "  PASS: $label"
  else
    FAIL=$((FAIL + 1))
    echo "  FAIL: $label — file not found: $path"
  fi
}

assert_file_not_exists() {
  local label="$1" path="$2"
  TESTS=$((TESTS + 1))
  if [ ! -f "$path" ]; then
    PASS=$((PASS + 1))
    echo "  PASS: $label"
  else
    FAIL=$((FAIL + 1))
    echo "  FAIL: $label — file should not exist: $path"
  fi
}

assert_contains() {
  local label="$1" expected="$2" actual="$3"
  TESTS=$((TESTS + 1))
  if echo "$actual" | grep -qF "$expected"; then
    PASS=$((PASS + 1))
    echo "  PASS: $label"
  else
    FAIL=$((FAIL + 1))
    echo "  FAIL: $label"
    echo "    expected to contain: '$expected'"
    echo "    actual: '$actual'"
  fi
}

assert_exit_code() {
  local label="$1" expected="$2" actual="$3"
  TESTS=$((TESTS + 1))
  if [ "$expected" = "$actual" ]; then
    PASS=$((PASS + 1))
    echo "  PASS: $label"
  else
    FAIL=$((FAIL + 1))
    echo "  FAIL: $label — expected exit code $expected, got $actual"
  fi
}

# --- Setup ---
TMPDIR=$(mktemp -d)
trap "rm -rf '$TMPDIR'" EXIT
cd "$TMPDIR"

create_issue() {
  local dir="$1" filename="$2" title="$3" type="$4" expert="$5" milestone="$6" deps="$7"
  mkdir -p ".workflow/issues/$dir"
  cat > ".workflow/issues/$dir/$filename" << EOF
# $title

**Type:** $type
**Expert:** $expert
**Milestone:** $milestone
**Status:** $dir

## Technical Notes

**Estimated effort:** Small session
**Dependencies:** $deps
EOF
}

create_session() {
  local expert="$1" number="$2"
  mkdir -p ".workflow/handoff-notes/$expert"
  echo "# Session $number handoff" > ".workflow/handoff-notes/$expert/session-${number}.md"
}

# ============================================================
echo "=== next-issue-number ==="
# ============================================================

echo "[empty project]"
mkdir -p .workflow/issues/{backlog,planned,in-progress,done}
result=$("$SCRIPT_DIR/next-issue-number.sh")
assert_eq "empty dirs → 001" "001" "$result"

echo "[with issues]"
create_issue "done" "swe-feature-001.md" "First" "feature" "swe" "M1" "None"
create_issue "done" "swe-bug-007.md" "Bug" "bug" "swe" "M2" "None"
create_issue "backlog" "qa-feature-045.md" "Last" "feature" "qa" "M11" "swe-feature-001"
result=$("$SCRIPT_DIR/next-issue-number.sh")
assert_eq "highest is 045 → 046" "046" "$result"

echo "[single issue]"
rm -rf .workflow/issues
mkdir -p .workflow/issues/{backlog,planned,in-progress,done}
create_issue "backlog" "swe-feature-010.md" "Only" "feature" "swe" "M1" "None"
result=$("$SCRIPT_DIR/next-issue-number.sh")
assert_eq "only 010 → 011" "011" "$result"

# ============================================================
echo ""
echo "=== next-session-number ==="
# ============================================================

echo "[no sessions yet]"
mkdir -p .workflow/handoff-notes
result=$("$SCRIPT_DIR/next-session-number.sh" swe)
assert_eq "no swe sessions → 01" "01" "$result"

echo "[with sessions]"
create_session "swe" "01"
create_session "swe" "02"
create_session "swe" "16"
result=$("$SCRIPT_DIR/next-session-number.sh" swe)
assert_eq "highest is 16 → 17" "17" "$result"

echo "[different expert]"
create_session "qa" "01"
create_session "qa" "03"
result=$("$SCRIPT_DIR/next-session-number.sh" qa)
assert_eq "qa highest is 03 → 04" "04" "$result"

echo "[expert with no directory]"
result=$("$SCRIPT_DIR/next-session-number.sh" devops)
assert_eq "devops no dir → 01" "01" "$result"

echo "[missing argument]"
set +e
result=$("$SCRIPT_DIR/next-session-number.sh" 2>&1)
exit_code=$?
set -e
assert_exit_code "missing arg exits non-zero" "1" "$exit_code"

# ============================================================
echo ""
echo "=== move-issue ==="
# ============================================================

echo "[basic move]"
rm -rf .workflow/issues
mkdir -p .workflow/issues/{backlog,planned,in-progress,done}
create_issue "backlog" "swe-feature-050.md" "Test" "feature" "swe" "M1" "None"
result=$("$SCRIPT_DIR/move-issue.sh" "swe-feature-050.md" "in-progress")
assert_file_exists "file in in-progress" ".workflow/issues/in-progress/swe-feature-050.md"
assert_file_not_exists "file gone from backlog" ".workflow/issues/backlog/swe-feature-050.md"
assert_contains "confirmation message" "Moved" "$result"

echo "[move without .md extension]"
create_issue "backlog" "qa-bug-051.md" "Bug" "bug" "qa" "M1" "None"
result=$("$SCRIPT_DIR/move-issue.sh" "qa-bug-051" "done")
assert_file_exists "file in done" ".workflow/issues/done/qa-bug-051.md"

echo "[already in target]"
create_issue "done" "swe-feature-052.md" "Done" "feature" "swe" "M1" "None"
result=$("$SCRIPT_DIR/move-issue.sh" "swe-feature-052.md" "done")
assert_contains "already message" "already" "$result"

echo "[invalid status]"
set +e
result=$("$SCRIPT_DIR/move-issue.sh" "swe-feature-050.md" "invalid" 2>&1)
exit_code=$?
set -e
assert_exit_code "invalid status exits 1" "1" "$exit_code"
assert_contains "error mentions invalid" "Invalid" "$result"

echo "[file not found]"
set +e
result=$("$SCRIPT_DIR/move-issue.sh" "nonexistent.md" "done" 2>&1)
exit_code=$?
set -e
assert_exit_code "not found exits 1" "1" "$exit_code"
assert_contains "error mentions not found" "not found" "$result"

echo "[missing arguments]"
set +e
result=$("$SCRIPT_DIR/move-issue.sh" 2>&1)
exit_code=$?
set -e
assert_exit_code "missing args exits non-zero" "1" "$exit_code"

# ============================================================
echo ""
echo "=== update-issues-list ==="
# ============================================================

echo "[regenerate from fixtures]"
rm -rf .workflow/issues
mkdir -p .workflow/issues/{backlog,planned,in-progress,done}
create_issue "done" "swe-feature-001.md" "Create System Architect" "feature" "swe" "M3" "None"
create_issue "done" "swe-bug-007.md" "Fix architecture loading" "bug" "swe" "M5" "None"
create_issue "backlog" "swe-feature-034.md" "Create Shell Scripts" "feature" "swe" "M11" "sa-feature-033 (design defines script locations)"
create_issue "backlog" "swe-feature-036.md" "Create PM Skills" "feature" "swe" "M11" "sa-feature-033 (design), swe-feature-034 (scripts), swe-feature-035 (structure)"

"$SCRIPT_DIR/update-issues-list.sh"
assert_file_exists "issues-list.md created" ".workflow/issues/issues-list.md"

content=$(cat .workflow/issues/issues-list.md)
assert_contains "has header" "| File | Title | Expert | Type | Milestone | Prerequisites | Status |" "$content"
assert_contains "has swe-feature-001" "swe-feature-001" "$content"
assert_contains "has swe-bug-007" "swe-bug-007" "$content"
assert_contains "has swe-feature-034" "swe-feature-034" "$content"

assert_contains "None deps become dash" "| — |" "$content"
assert_contains "deps stripped of parens" "| sa-feature-033 |" "$content"
assert_contains "multi-deps stripped" "sa-feature-033, swe-feature-034, swe-feature-035" "$content"

assert_contains "status from dir: done" "| done |" "$content"
assert_contains "status from dir: backlog" "| backlog |" "$content"

echo "[sorted by issue number]"
lines=$(grep '| swe-' .workflow/issues/issues-list.md | head -2)
first_line=$(echo "$lines" | head -1)
assert_contains "first row is 001" "swe-feature-001" "$first_line"

echo "[empty project]"
rm -rf .workflow/issues
mkdir -p .workflow/issues/{backlog,planned,in-progress,done}
"$SCRIPT_DIR/update-issues-list.sh"
assert_file_exists "issues-list.md created even when empty" ".workflow/issues/issues-list.md"
content=$(cat .workflow/issues/issues-list.md)
assert_contains "has header even when empty" "| File | Title |" "$content"

# ============================================================
echo ""
echo "=== Results ==="
echo "$PASS passed, $FAIL failed, $TESTS total"

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
