#!/usr/bin/env bash
# SessionStart hook (compact matcher): surfaces dynamic context after compaction
# CLAUDE.md is automatically re-read, so this only injects dynamic state

set -euo pipefail

VAULT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
cd "$VAULT_DIR"

CONTEXT=""

# Check for uncommitted changes
CHANGES=$(git status --porcelain 2>/dev/null || true)
if [[ -n "$CHANGES" ]]; then
  CONTEXT="Uncommitted vault changes:\n${CHANGES}"
fi

# Check for recent change log entries (last 10)
LOG_FILE="$VAULT_DIR/.claude/hooks/logs/changes.log"
if [[ -f "$LOG_FILE" ]]; then
  RECENT=$(tail -10 "$LOG_FILE")
  if [[ -n "$RECENT" ]]; then
    if [[ -n "$CONTEXT" ]]; then
      CONTEXT="${CONTEXT}\n\n"
    fi
    CONTEXT="${CONTEXT}Recent file changes (from hook log):\n${RECENT}"
  fi
fi

# Check for QMD post-commit hook
HOOK_FILE="$VAULT_DIR/.git/hooks/post-commit"
if [[ ! -x "$HOOK_FILE" ]]; then
  if [[ -n "$CONTEXT" ]]; then
    CONTEXT="${CONTEXT}\n\n"
  fi
  CONTEXT="${CONTEXT}WARNING: QMD post-commit hook is missing. Run: bash .claude/hooks/setup-git-hooks.sh"
fi

if [[ -n "$CONTEXT" ]]; then
  # Output as hookSpecificOutput with additionalContext
  ESCAPED=$(printf '%s\n' "$CONTEXT" | jq -Rs '.')
  printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":%s}}' "$ESCAPED"
fi

exit 0
