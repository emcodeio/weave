#!/usr/bin/env bash
# PreToolUse hook: blocks Edit/Write to protected system files
# Protected: .obsidian/, .claude/settings.local.json, kepano plugin skills, .claude-plugin/

set -euo pipefail

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# No file path means nothing to protect
if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

# Normalize: strip leading ./ if present
FILE_PATH="${FILE_PATH#./}"

# Also handle absolute paths by stripping the vault prefix
VAULT_DIR="${CLAUDE_PROJECT_DIR:-}"
if [[ -n "$VAULT_DIR" && "$FILE_PATH" == "$VAULT_DIR"/* ]]; then
  FILE_PATH="${FILE_PATH#$VAULT_DIR/}"
fi

case "$FILE_PATH" in
  .obsidian/*)
    echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Protected path: .obsidian/ — Obsidian app config must not be modified by Claude."}}'
    exit 0
    ;;
  .claude/settings.local.json)
    echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Protected path: .claude/settings.local.json — user permissions file must not be modified."}}'
    exit 0
    ;;
  .claude/skills/obsidian-cli/*|.claude/skills/obsidian-markdown/*|.claude/skills/obsidian-bases/*|.claude/skills/json-canvas/*|.claude/skills/defuddle/*)
    echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Protected path: installed plugin skill — must not be modified by Claude."}}'
    exit 0
    ;;
  .claude-plugin/*)
    echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Protected path: .claude-plugin/ — plugin manifest must not be modified."}}'
    exit 0
    ;;
esac

exit 0
