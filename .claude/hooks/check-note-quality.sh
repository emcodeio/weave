#!/usr/bin/env bash
# PostToolUse hook: verifies frontmatter on vault notes after Edit/Write
# Uses "decision":"warn" — PostToolUse feedback signal. The write has already
# completed; Claude receives the reason and corrects the issue.
# Checks notes in: Notes/, References/
# Skips: Inbox/, Daily/, Templates/, Attachments/, and non-vault files

set -euo pipefail

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

# Normalize path
FILE_PATH="${FILE_PATH#./}"
VAULT_DIR="${CLAUDE_PROJECT_DIR:-}"
if [[ -n "$VAULT_DIR" && "$FILE_PATH" == "$VAULT_DIR"/* ]]; then
  FILE_PATH="${FILE_PATH#$VAULT_DIR/}"
fi

# Only check .md files
if [[ "$FILE_PATH" != *.md ]]; then
  exit 0
fi

# Only check notes in structured directories
case "$FILE_PATH" in
  Notes/*|References/*)
    ;; # proceed with check
  *)
    exit 0 # skip everything else
    ;;
esac

# Resolve to absolute path for reading
if [[ -n "$VAULT_DIR" ]]; then
  ABS_PATH="$VAULT_DIR/$FILE_PATH"
else
  ABS_PATH="$FILE_PATH"
fi

if [[ ! -f "$ABS_PATH" ]]; then
  exit 0
fi

# Read file content
CONTENT=$(cat "$ABS_PATH")

# Check for YAML frontmatter delimiters
if [[ "$CONTENT" != ---* ]]; then
  echo '{"decision":"warn","reason":"Missing YAML frontmatter. Notes in structured directories must start with --- delimiters and include categories, areas, status, tags, and created fields."}'
  exit 0
fi

# Extract frontmatter (between first and second ---)
FRONTMATTER=$(echo "$CONTENT" | sed -n '1,/^---$/p' | sed '1d;$d')
if [[ -z "$FRONTMATTER" ]]; then
  # Check if there's a closing ---
  SECOND_DELIM=$(echo "$CONTENT" | sed -n '2,${/^---$/=;}'| head -1)
  if [[ -z "$SECOND_DELIM" ]]; then
    echo '{"decision":"warn","reason":"Malformed YAML frontmatter — missing closing --- delimiter."}'
    exit 0
  fi
fi

# Check required fields
MISSING=()
for FIELD in categories areas status tags created; do
  if ! echo "$CONTENT" | sed -n '2,/^---$/p' | grep -q "^${FIELD}:"; then
    MISSING+=("$FIELD")
  fi
done

if [[ ${#MISSING[@]} -gt 0 ]]; then
  MISSING_STR=$(IFS=', '; echo "${MISSING[*]}")
  echo "{\"decision\":\"warn\",\"reason\":\"Frontmatter missing required fields: ${MISSING_STR}. All structured vault notes need categories, areas, status, tags, and created.\"}"
  exit 0
fi

exit 0
