#!/usr/bin/env bash
# PostToolUse hook: logs changed file paths with timestamps to
# .claude/hooks/logs/changes.log (gitignored) for git commit batching + compaction context.
# Self-truncates so the log stays bounded.

set -euo pipefail

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

# Normalize path (quote VAULT_DIR so the prefix strip is literal even with spaces in the path)
FILE_PATH="${FILE_PATH#./}"
VAULT_DIR="${CLAUDE_PROJECT_DIR:-}"
if [[ -n "$VAULT_DIR" && "$FILE_PATH" == "$VAULT_DIR"/* ]]; then
  FILE_PATH="${FILE_PATH#"$VAULT_DIR"/}"
fi

LOG_DIR="${VAULT_DIR:-.}/.claude/hooks/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/changes.log"

echo "$(date '+%Y-%m-%d %H:%M:%S') $FILE_PATH" >> "$LOG_FILE"

# Keep the log bounded: if it grows past 1000 lines, retain only the most recent 500.
LINE_COUNT=$(wc -l < "$LOG_FILE" 2>/dev/null || echo 0)
if [[ "${LINE_COUNT:-0}" -gt 1000 ]]; then
  tail -n 500 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
fi

exit 0
