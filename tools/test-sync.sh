#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SYNC="$SCRIPT_DIR/sync.sh"
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

assert_not_contains() {
  local label="$1" unexpected="$2" actual="$3"
  TESTS=$((TESTS + 1))
  if ! echo "$actual" | grep -qF "$unexpected"; then
    PASS=$((PASS + 1))
    echo "  PASS: $label"
  else
    FAIL=$((FAIL + 1))
    echo "  FAIL: $label"
    echo "    should NOT contain: '$unexpected'"
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

setup_fixture() {
  local root="$1"
  rm -rf "$root"

  mkdir -p "$root/targets/ide/cursor"/{commands,scripts,rules}
  mkdir -p "$root/targets/ide/cursor/skills"/{pm-vision,swe-handoff}
  mkdir -p "$root/targets/ide/claude-code"/{commands,scripts,roles}
  mkdir -p "$root/targets/ide/claude-code/skills"/{pm-vision,swe-handoff}

  # Identical commands
  echo "pm start content" > "$root/targets/ide/cursor/commands/pm-start.md"
  echo "pm start content" > "$root/targets/ide/claude-code/commands/pm-start.md"
  echo "swe start content" > "$root/targets/ide/cursor/commands/swe-start.md"
  echo "swe start content" > "$root/targets/ide/claude-code/commands/swe-start.md"

  # Identical skills
  echo "pm vision skill" > "$root/targets/ide/cursor/skills/pm-vision/SKILL.md"
  echo "pm vision skill" > "$root/targets/ide/claude-code/skills/pm-vision/SKILL.md"
  echo "swe handoff skill" > "$root/targets/ide/cursor/skills/swe-handoff/SKILL.md"
  echo "swe handoff skill" > "$root/targets/ide/claude-code/skills/swe-handoff/SKILL.md"

  # Identical shared scripts
  echo "#!/bin/bash" > "$root/targets/ide/cursor/scripts/move-issue.sh"
  echo "#!/bin/bash" > "$root/targets/ide/claude-code/scripts/move-issue.sh"
  echo "#!/bin/bash" > "$root/targets/ide/cursor/scripts/next-issue-number.sh"
  echo "#!/bin/bash" > "$root/targets/ide/claude-code/scripts/next-issue-number.sh"

  # Platform-specific scripts (expected — not compared)
  echo "#!/bin/bash" > "$root/targets/ide/cursor/scripts/test-scripts.sh"
  echo "#!/bin/bash" > "$root/targets/ide/claude-code/scripts/session-primer.sh"

  # Platform-specific config files
  echo "project os rule" > "$root/targets/ide/cursor/rules/project-os.mdc"
  echo "CLAUDE content" > "$root/targets/ide/claude-code/CLAUDE.md"
  echo "swe role" > "$root/targets/ide/claude-code/roles/swe.md"

  # READMEs (expected to differ, excluded from comparison)
  echo "Cursor README" > "$root/targets/ide/cursor/README.md"
  echo "Claude Code README" > "$root/targets/ide/claude-code/README.md"
}

setup_project() {
  local root="$1" project="$2"
  rm -rf "$project"

  mkdir -p "$project/.cursor"/{rules,commands,scripts}
  mkdir -p "$project/.cursor/skills"/{pm-vision,swe-handoff}

  cp "$root/targets/ide/cursor/rules/project-os.mdc" "$project/.cursor/rules/"
  cp "$root/targets/ide/cursor/commands/pm-start.md" "$project/.cursor/commands/"
  cp "$root/targets/ide/cursor/commands/swe-start.md" "$project/.cursor/commands/"
  cp "$root/targets/ide/cursor/skills/pm-vision/SKILL.md" "$project/.cursor/skills/pm-vision/"
  cp "$root/targets/ide/cursor/skills/swe-handoff/SKILL.md" "$project/.cursor/skills/swe-handoff/"
  cp "$root/targets/ide/cursor/scripts/move-issue.sh" "$project/.cursor/scripts/"
  cp "$root/targets/ide/cursor/scripts/next-issue-number.sh" "$project/.cursor/scripts/"
  cp "$root/targets/ide/cursor/scripts/test-scripts.sh" "$project/.cursor/scripts/"
}

# ============================================================
echo "=== diff mode: all in sync ==="
# ============================================================
setup_fixture "$TMPDIR/repo1"
set +e
output=$(SYNC_REPO_ROOT="$TMPDIR/repo1" "$SYNC" diff 2>&1)
exit_code=$?
set -e
assert_exit_code "exit 0 when in sync" "0" "$exit_code"
assert_contains "reports IN SYNC" "IN SYNC" "$output"
assert_not_contains "no DIFFERS markers" "[DIFFERS]" "$output"
assert_not_contains "no MISSING markers" "[MISSING" "$output"

# ============================================================
echo ""
echo "=== diff mode: command content differs ==="
# ============================================================
setup_fixture "$TMPDIR/repo2"
echo "MODIFIED pm start" > "$TMPDIR/repo2/targets/ide/claude-code/commands/pm-start.md"
set +e
output=$(SYNC_REPO_ROOT="$TMPDIR/repo2" "$SYNC" diff 2>&1)
exit_code=$?
set -e
assert_exit_code "exit 1 when command differs" "1" "$exit_code"
assert_contains "flags pm-start.md" "pm-start.md" "$output"
assert_contains "reports DIFFERS" "[DIFFERS]" "$output"
assert_contains "reports DRIFT" "DRIFT DETECTED" "$output"

# ============================================================
echo ""
echo "=== diff mode: skill missing from one platform ==="
# ============================================================
setup_fixture "$TMPDIR/repo3"
mkdir -p "$TMPDIR/repo3/targets/ide/cursor/skills/new-skill"
echo "new skill" > "$TMPDIR/repo3/targets/ide/cursor/skills/new-skill/SKILL.md"
set +e
output=$(SYNC_REPO_ROOT="$TMPDIR/repo3" "$SYNC" diff 2>&1)
exit_code=$?
set -e
assert_exit_code "exit 1 when skill missing" "1" "$exit_code"
assert_contains "reports MISSING for claude-code" "[MISSING:claude-code]" "$output"
assert_contains "mentions new-skill" "new-skill" "$output"

# ============================================================
echo ""
echo "=== diff mode: shared script differs ==="
# ============================================================
setup_fixture "$TMPDIR/repo4"
echo "MODIFIED" > "$TMPDIR/repo4/targets/ide/claude-code/scripts/move-issue.sh"
set +e
output=$(SYNC_REPO_ROOT="$TMPDIR/repo4" "$SYNC" diff 2>&1)
exit_code=$?
set -e
assert_exit_code "exit 1 when script differs" "1" "$exit_code"
assert_contains "flags move-issue.sh" "move-issue.sh" "$output"
assert_contains "reports DIFFERS for script" "[DIFFERS]" "$output"

# ============================================================
echo ""
echo "=== diff mode: platform-specific scripts not flagged ==="
# ============================================================
setup_fixture "$TMPDIR/repo5"
set +e
output=$(SYNC_REPO_ROOT="$TMPDIR/repo5" "$SYNC" diff 2>&1)
exit_code=$?
set -e
assert_exit_code "exit 0 with platform-specific scripts" "0" "$exit_code"
assert_not_contains "test-scripts.sh not flagged" "test-scripts.sh" "$output"
assert_not_contains "session-primer.sh not flagged" "session-primer.sh" "$output"

# ============================================================
echo ""
echo "=== check mode: all in sync ==="
# ============================================================
setup_fixture "$TMPDIR/repo6"
setup_project "$TMPDIR/repo6" "$TMPDIR/project6"
set +e
output=$(SYNC_REPO_ROOT="$TMPDIR/repo6" "$SYNC" check "$TMPDIR/project6" 2>&1)
exit_code=$?
set -e
assert_exit_code "check exit 0 when in sync" "0" "$exit_code"
assert_contains "check reports IN SYNC" "IN SYNC" "$output"
assert_contains "detects cursor platform" "cursor" "$output"

# ============================================================
echo ""
echo "=== check mode: installed file differs ==="
# ============================================================
echo "MODIFIED" > "$TMPDIR/project6/.cursor/commands/pm-start.md"
set +e
output=$(SYNC_REPO_ROOT="$TMPDIR/repo6" "$SYNC" check "$TMPDIR/project6" 2>&1)
exit_code=$?
set -e
assert_exit_code "check exit 1 when file differs" "1" "$exit_code"
assert_contains "check reports DIFFERS" "[DIFFERS]" "$output"
assert_contains "reports OUT OF DATE" "OUT OF DATE" "$output"

# ============================================================
echo ""
echo "=== check mode: new source file not installed ==="
# ============================================================
setup_fixture "$TMPDIR/repo7"
setup_project "$TMPDIR/repo7" "$TMPDIR/project7"
mkdir -p "$TMPDIR/repo7/targets/ide/cursor/commands"
echo "new command" > "$TMPDIR/repo7/targets/ide/cursor/commands/new-cmd.md"
set +e
output=$(SYNC_REPO_ROOT="$TMPDIR/repo7" "$SYNC" check "$TMPDIR/project7" 2>&1)
exit_code=$?
set -e
assert_exit_code "check exit 1 when source file missing from install" "1" "$exit_code"
assert_contains "reports MISSING" "[MISSING:install]" "$output"

# ============================================================
echo ""
echo "=== check mode: no toolkit detected ==="
# ============================================================
mkdir -p "$TMPDIR/empty-project"
set +e
output=$(SYNC_REPO_ROOT="$TMPDIR/repo7" "$SYNC" check "$TMPDIR/empty-project" 2>&1)
exit_code=$?
set -e
assert_exit_code "check exit 2 when no toolkit" "2" "$exit_code"

# ============================================================
echo ""
echo "=== apply mode: updates files ==="
# ============================================================
setup_fixture "$TMPDIR/repo8"
setup_project "$TMPDIR/repo8" "$TMPDIR/project8"
echo "MODIFIED" > "$TMPDIR/project8/.cursor/commands/pm-start.md"
set +e
output=$(SYNC_REPO_ROOT="$TMPDIR/repo8" "$SYNC" -y apply "$TMPDIR/project8" 2>&1)
exit_code=$?
set -e
assert_exit_code "apply exit 0" "0" "$exit_code"
assert_contains "reports UPDATED" "[UPDATED]" "$output"
updated=$(cat "$TMPDIR/project8/.cursor/commands/pm-start.md")
assert_eq "file content restored" "pm start content" "$updated"

# ============================================================
echo ""
echo "=== apply mode: installs new files ==="
# ============================================================
setup_fixture "$TMPDIR/repo9"
setup_project "$TMPDIR/repo9" "$TMPDIR/project9"
mkdir -p "$TMPDIR/repo9/targets/ide/cursor/skills/brand-new"
echo "brand new skill" > "$TMPDIR/repo9/targets/ide/cursor/skills/brand-new/SKILL.md"
set +e
output=$(SYNC_REPO_ROOT="$TMPDIR/repo9" "$SYNC" -y apply "$TMPDIR/project9" 2>&1)
exit_code=$?
set -e
assert_exit_code "apply exit 0 for new file" "0" "$exit_code"
assert_contains "reports UPDATED for new file" "[UPDATED]" "$output"
new_content=$(cat "$TMPDIR/project9/.cursor/skills/brand-new/SKILL.md")
assert_eq "new file installed" "brand new skill" "$new_content"

# ============================================================
echo ""
echo "=== apply mode: nothing to update ==="
# ============================================================
setup_fixture "$TMPDIR/repo10"
setup_project "$TMPDIR/repo10" "$TMPDIR/project10"
set +e
output=$(SYNC_REPO_ROOT="$TMPDIR/repo10" "$SYNC" -y apply "$TMPDIR/project10" 2>&1)
exit_code=$?
set -e
assert_exit_code "apply exit 0 when nothing to do" "0" "$exit_code"
assert_contains "reports up to date" "up to date" "$output"

# ============================================================
echo ""
echo "=== error: no arguments ==="
# ============================================================
set +e
output=$("$SYNC" 2>&1)
exit_code=$?
set -e
assert_exit_code "no args exit 2" "2" "$exit_code"

# ============================================================
echo ""
echo "=== error: unknown mode ==="
# ============================================================
set +e
output=$("$SYNC" invalid 2>&1)
exit_code=$?
set -e
assert_exit_code "unknown mode exit 2" "2" "$exit_code"

# ============================================================
echo ""
echo "=== Results ==="
echo "$PASS passed, $FAIL failed, $TESTS total"

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
