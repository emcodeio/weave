#!/usr/bin/env bash
# PostToolUse hook (async): logs changed file paths with timestamps
# Output goes to .claude/hooks/logs/changes.log for git commit batching

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

LOG_DIR="${VAULT_DIR:-.}/.claude/hooks/logs"
mkdir -p "$LOG_DIR"

echo "$(date '+%Y-%m-%d %H:%M:%S') $FILE_PATH" >> "$LOG_DIR/changes.log"

exit 0
