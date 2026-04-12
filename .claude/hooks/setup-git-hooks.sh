#!/usr/bin/env bash
# Installs git hooks for the vault.
# Run after a fresh clone: bash .claude/hooks/setup-git-hooks.sh

set -euo pipefail

VAULT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
HOOKS_DIR="$VAULT_DIR/.git/hooks"

# --- post-commit: QMD re-indexing ---
HOOK_FILE="$HOOKS_DIR/post-commit"

cat > "$HOOK_FILE" << 'HOOK'
#!/usr/bin/env bash
# post-commit: refresh QMD semantic search index after every commit
# Takes ~600ms for this vault — safe to run synchronously

QMD_BIN="$(command -v qmd 2>/dev/null || true)"

if [[ -n "$QMD_BIN" && -x "$QMD_BIN" ]]; then
  "$QMD_BIN" update 2>/dev/null
  "$QMD_BIN" embed 2>/dev/null
fi

exit 0
HOOK

chmod +x "$HOOK_FILE"
echo "Installed post-commit hook: $HOOK_FILE"
