#!/usr/bin/env bash
# Diff the protected (vendored) kepano plugin skills against their upstream source.
#
# Why this exists: the upstream maintainer (kepano/obsidian-skills) ships content
# changes to SKILL.md / references without bumping the plugin version (it has sat at
# 1.0.1 across multiple content commits). So a `/plugin` marketplace update check
# reports "current" even when files have drifted. The reliable check is a file-level
# diff against the upstream `main` branch — which is what this script does.
#
# Usage:
#   .claude/hooks/check-protected-skills.sh           # summary table
#   .claude/hooks/check-protected-skills.sh --diff     # also print the diffs
#
# Exit codes: 0 = all current, 2 = drift found, 3 = network/fetch failure.
# Applying any update is a manual, user-authorized step: these files are guarded by
# protect-system-files.sh (Edit/Write are blocked), so a sync is a deliberate Bash
# copy of the verified upstream content after the user confirms.

set -uo pipefail

SKILLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../skills" && pwd)"
UPSTREAM="https://raw.githubusercontent.com/kepano/obsidian-skills/main/skills"
PROTECTED=(obsidian-cli obsidian-markdown obsidian-bases json-canvas defuddle)

SHOW_DIFF=0
[[ "${1:-}" == "--diff" ]] && SHOW_DIFF=1

drift=0
fetch_fail=0
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "Protected-skill currency check vs kepano/obsidian-skills@main"
echo "-------------------------------------------------------------"

for skill in "${PROTECTED[@]}"; do
  dir="$SKILLS_DIR/$skill"
  if [[ ! -d "$dir" ]]; then
    echo "MISSING-LOCAL   $skill/ (protected skill directory not found)"
    drift=1
    continue
  fi
  # Walk every local file under the skill dir so new reference files are covered automatically.
  while IFS= read -r local; do
    rel="${local#"$SKILLS_DIR"/}"            # e.g. defuddle/SKILL.md
    up="$tmp/${rel//\//_}"
    code=$(curl -fsS -w '%{http_code}' "$UPSTREAM/$rel" -o "$up" 2>/dev/null) || code="000"
    if [[ "$code" == "404" ]]; then
      echo "LOCAL-ONLY      $rel (no upstream equivalent — local addition?)"
      drift=1
    elif [[ "$code" != "200" ]]; then
      echo "FETCH-FAIL      $rel (HTTP $code)"
      fetch_fail=1
    elif diff -q "$local" "$up" >/dev/null 2>&1; then
      echo "SAME            $rel"
    else
      n=$(diff "$local" "$up" | grep -cE '^[<>]')
      echo "DIFFERENT       $rel  ($n changed lines)"
      drift=1
      if [[ "$SHOW_DIFF" == "1" ]]; then
        echo "--- diff (local <  |  upstream >) ---"
        diff "$local" "$up" | sed 's/^/    /'
        echo "-------------------------------------"
      fi
    fi
  done < <(find "$dir" -type f | sort)
done

echo "-------------------------------------------------------------"
if [[ "$fetch_fail" == "1" ]]; then
  echo "RESULT: could not reach upstream for one or more files — rerun when online."
  exit 3
elif [[ "$drift" == "1" ]]; then
  echo "RESULT: drift found. Review with --diff; sync is a user-authorized Bash copy of upstream."
  exit 2
else
  echo "RESULT: all protected skills current with upstream."
  exit 0
fi
