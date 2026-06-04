#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# Weave Setup
# A meta-rational productivity system. Obsidian + Claude Code. Options, not orders.
# ============================================================================

# --- Colors and formatting ---
BOLD='\033[1m'
DIM='\033[2m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() { printf "\n${BOLD}${CYAN}=== %s ===${NC}\n\n" "$1"; }
print_step()   { printf "\n${BOLD}[%s/%s]${NC} %s\n" "$1" "$TOTAL_STEPS" "$2"; }
print_ok()     { printf "  ${GREEN}OK${NC} %s\n" "$1"; }
print_warn()   { printf "  ${YELLOW}!!${NC} %s\n" "$1"; }
print_err()    { printf "  ${RED}**${NC} %s\n" "$1"; }
print_info()   { printf "  %s\n" "$1"; }

# Prompts: -e enables readline (backspace/arrow editing) when stdin is a terminal;
# bash silently skips readline on non-tty stdin, so piped input still works.
# The colored prompt stays on printf >&2 (not read -p: readline counts raw ANSI
# escapes toward column width and miscalculates wraps). The || guard makes EOF
# (Ctrl-D, or exhausted non-tty stdin) fall back to the default instead of
# aborting the script via set -e.
prompt_with_default() {
  local prompt="$1"
  local default="$2"
  local result
  printf "${prompt} ${DIM}[${default}]${NC}: " >&2
  read -e -r result || result=""
  echo "${result:-$default}"
}

prompt_yes_no() {
  local prompt="$1"
  local default="${2:-y}"
  local result
  printf "${prompt} ${DIM}[${default}]${NC}: " >&2
  read -e -r result || result=""
  result="${result:-$default}"
  result="$(printf '%s' "$result" | tr '[:upper:]' '[:lower:]')"
  [[ "$result" == "y" || "$result" == "yes" ]]
}

# Cross-platform sed -i
sed_inplace() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "$@"
  else
    sed -i "$@"
  fi
}

os_label() {
  case "$OSTYPE" in
    darwin*) echo "macOS" ;;
    linux*)  echo "Linux" ;;
    *)       echo "this platform" ;;
  esac
}

# Portable timeout (macOS ships no GNU `timeout`; /bin/bash is 3.2 — keep it 3.2-safe).
# Closes the child's stdin so a hidden interactive prompt (a shimmed npm, corepack's
# "ok to download? [Y/n]") can never block setup forever, runs the child in its own
# process group so the kill reaches grandchildren (npm's node subprocess), and
# returns 124 on timeout vs. the child's real exit code otherwise.
# Call sites MUST guard the return (if/|| rc=$?) — set -e is active.
run_with_timeout() {
  local timeout="$1"; shift
  local cmd_rc=0

  # set -m puts the background child in its own process group (pgid == pid),
  # so the watchdog's negative-pid kill takes out the whole tree (npm's node
  # subprocesses included). Toggled off right after.
  set -m
  "$@" </dev/null &
  local cmd_pid=$!
  set +m

  # Watchdog: polls for the child's death (1s) and exits on its own rather than
  # being signaled — signaling a just-forked subshell can orphan its sleep on
  # bash 3.2. Redirected to /dev/null so it never holds a $(...) capture pipe.
  ( set +m
    waited=0
    while [ "$waited" -lt "$timeout" ]; do
      sleep 1
      kill -0 "$cmd_pid" 2>/dev/null || exit 0
      waited=$((waited + 1))
    done
    kill -TERM -- "-${cmd_pid}" 2>/dev/null
    sleep 2
    kill -KILL -- "-${cmd_pid}" 2>/dev/null
  ) >/dev/null 2>&1 &
  local watch_pid=$!

  if wait "$cmd_pid" 2>/dev/null; then cmd_rc=0; else cmd_rc=$?; fi
  # Watchdog notices the child is gone within ~1s and exits; no strays remain.
  wait "$watch_pid" 2>/dev/null || true

  # 143/137 = the watchdog's TERM/KILL landed -> report as timeout.
  if [[ "$cmd_rc" -eq 143 || "$cmd_rc" -eq 137 ]]; then
    return 124
  fi
  return "$cmd_rc"
}

# Non-tty stdin (piped input, CI): readline is skipped automatically, EOF falls
# back to defaults, and network-install prompts default to "n" (see below) so an
# unattended run can't kick off multi-GB downloads.
STDIN_IS_TTY=true
[[ -t 0 ]] || STDIN_IS_TTY=false

TOTAL_STEPS=11
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Verify we're in a Weave repo
if [[ ! -f "$SCRIPT_DIR/CLAUDE.md" ]] || [[ ! -d "$SCRIPT_DIR/.claude" ]]; then
  printf "${RED}**${NC} This doesn't look like a Weave repository.\n"
  printf "${RED}**${NC} Run setup.sh from the root of your cloned Weave repo.\n"
  exit 1
fi

cd "$SCRIPT_DIR"

# ============================================================================
# Welcome
# ============================================================================
print_header "Weave Setup"

printf "Weave is a meta-rational productivity system built on Obsidian + Claude Code.\n"
printf "This script configures your vault. It will:\n\n"
printf "  - Check that the tools it needs are installed\n"
printf "  - Set your vault name, path, and (optionally) git\n"
printf "  - Set up QMD semantic search and any Apple integrations you choose\n"
printf "  - Create your vault structure and make the first commit\n\n"
printf "${DIM}You can re-run this safely — it backs up your .mcp.json before regenerating and won't\nre-commit when there's nothing new.${NC}\n\n"

if ! prompt_yes_no "Ready to begin?"; then
  printf "\nNo changes made. Run setup.sh when you're ready.\n"
  exit 0
fi

if [[ "$STDIN_IS_TTY" == false ]]; then
  print_info "Non-interactive stdin detected — using defaults; network installs (QMD, pipx) will be skipped."
fi

# ============================================================================
# Step 1: Check prerequisites
# ============================================================================
print_step 1 "Checking prerequisites"

MISSING_CRITICAL=()

# --- Critical: setup.sh itself uses these ---

# Node.js 18+ (required for QMD and every npx-based integration).
# Version probes run under a timeout: a shimmed/broken toolchain that hangs on
# `--version` would otherwise stall setup before it even starts.
NODE_VERSION=""
if ! command -v node &>/dev/null; then
  print_err "Node.js not found (needed for semantic search and integrations)."
  MISSING_CRITICAL+=("Node.js 18+ — from https://nodejs.org (or: brew install node)")
elif NODE_VERSION=$(run_with_timeout 15 node --version 2>/dev/null); then
  NODE_MAJOR=$(printf '%s' "$NODE_VERSION" | sed 's/v//' | cut -d. -f1)
  if [[ "$NODE_MAJOR" -ge 18 ]]; then
    print_ok "Node.js $NODE_VERSION"
  else
    print_err "Node.js $NODE_VERSION found, but 18+ is required."
    MISSING_CRITICAL+=("Node.js 18+ — from https://nodejs.org (or: brew install node)")
  fi
else
  print_err "Node.js found, but 'node --version' didn't respond within 15s."
  MISSING_CRITICAL+=("Node.js 18+ — 'node --version' must return promptly (a shimmed toolchain may be intercepting it)")
fi

# npm (ships with Node, but some distros split it out)
NPM_VERSION=""
if ! command -v npm &>/dev/null; then
  print_err "npm not found (ships with Node.js)."
  MISSING_CRITICAL+=("npm — comes with Node.js 18+ (reinstall Node, or your distro's nodejs-npm package)")
elif NPM_VERSION=$(run_with_timeout 15 npm --version 2>/dev/null); then
  print_ok "npm $NPM_VERSION"
else
  print_err "npm found, but 'npm --version' didn't respond within 15s."
  MISSING_CRITICAL+=("npm — 'npm --version' must return promptly; if an alternative toolchain (pnpm/bun/Vite Plus) shims npm, put real npm on PATH")
fi

# git (required for version control + the search-index hook)
if command -v git &>/dev/null; then
  print_ok "git $(git --version | awk '{print $3}')"
else
  print_err "git not found (needed to version-control your vault)."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    MISSING_CRITICAL+=("git — install with: xcode-select --install")
  else
    MISSING_CRITICAL+=("git — install via your package manager (e.g. apt install git)")
  fi
fi

# --- Needed later (at use time, not by this script) — warn, don't block ---
if command -v claude &>/dev/null; then
  print_ok "Claude Code"
else
  print_warn "Claude Code not found — you'll need it to use the vault (install later)."
fi

if command -v obsidian &>/dev/null || { [[ "$OSTYPE" == "darwin"* ]] && [[ -d "/Applications/Obsidian.app" ]]; }; then
  print_ok "Obsidian"
else
  print_warn "Obsidian not found — you'll open your vault in it (install Obsidian 1.12+ later)."
fi

if [[ ${#MISSING_CRITICAL[@]} -gt 0 ]]; then
  printf "\n"
  print_err "Setup can't continue until these are installed:"
  for item in "${MISSING_CRITICAL[@]}"; do
    printf "      - %s\n" "$item"
  done
  printf "\nInstall the above, then re-run: ${CYAN}bash setup.sh${NC}\n\n"
  exit 1
fi

# ============================================================================
# Step 2: Vault name
# ============================================================================
print_step 2 "Vault name"

printf "This should match the name you'll give your Obsidian vault.\n"
VAULT_NAME=$(prompt_with_default "Vault name" "$(basename "$PWD")")

# ============================================================================
# Step 3: Vault path
# ============================================================================
print_step 3 "Vault path"

VAULT_PATH=$(prompt_with_default "Vault path" "$PWD")
VAULT_PATH="$(cd "$VAULT_PATH" 2>/dev/null && pwd || echo "$VAULT_PATH")"

# ============================================================================
# Step 4: Git configuration
# ============================================================================
print_step 4 "Git configuration"

GIT_USER=""
GIT_EMAIL=""
GIT_REMOTE=""

if prompt_yes_no "Configure git for this vault?"; then
  GIT_USER=$(prompt_with_default "  Git username" "$(git config user.name 2>/dev/null || echo "")")
  GIT_EMAIL=$(prompt_with_default "  Git email" "$(git config user.email 2>/dev/null || echo "")")
  printf "  ${DIM}Remote is optional — e.g. https://github.com/you/your-vault — or press Enter to skip.${NC}\n"
  GIT_REMOTE=$(prompt_with_default "  Git remote URL" "")
fi

# ============================================================================
# Step 5: QMD semantic search
# ============================================================================
print_step 5 "QMD semantic search"

printf "QMD finds notes by meaning, not just keywords — searching \"feeling stuck\" can\n"
printf "surface a note titled \"Overcoming Paralysis.\" It powers inbox routing, context\n"
printf "surfacing, and friction detection, so the review system leans on it.\n"
printf "${DIM}Strongly recommended. First run downloads ~2GB of local models (~5 min). The system still works without it, with weaker search.${NC}\n\n"

QMD_AVAILABLE=false

# Network installs default to "n" when stdin isn't a terminal, so an unattended
# run can't silently answer "y" and start a multi-GB download.
NET_INSTALL_DEFAULT="y"
[[ "$STDIN_IS_TTY" == false ]] && NET_INSTALL_DEFAULT="n"

if command -v qmd &>/dev/null; then
  print_ok "QMD already installed ($(command -v qmd))"
  QMD_AVAILABLE=true
elif prompt_yes_no "  Install QMD now? (npm install -g @tobilu/qmd)" "$NET_INSTALL_DEFAULT"; then
  printf "  Installing QMD — usually a minute or two. Progress log: /tmp/weave-qmd-install.log\n"
  rc=0
  run_with_timeout 600 npm install -g @tobilu/qmd >/tmp/weave-qmd-install.log 2>&1 || rc=$?
  if [[ "$rc" -eq 0 ]]; then
    print_ok "QMD installed"
    QMD_AVAILABLE=true
  else
    if [[ "$rc" -eq 124 ]]; then
      print_warn "QMD install timed out after 10 minutes and was stopped."
    else
      print_warn "QMD install failed (exit $rc). Common causes: permissions (consider a Node version manager, or 'sudo npm install -g @tobilu/qmd'), or network."
    fi
    print_warn "Full log at /tmp/weave-qmd-install.log — install later and re-run, or run it by hand."
    print_info "If you use a different toolchain, install QMD globally with its own command instead — e.g."
    print_info "  pnpm add -g @tobilu/qmd  |  bun add -g @tobilu/qmd  |  yarn global add @tobilu/qmd"
    print_info "(Vite Plus or others: use their global-install equivalent.) Note: .mcp.json runs MCP servers"
    print_info "via npx, so npm/npx must stay on your PATH regardless. Then re-run setup, or run by hand:"
    print_info "  qmd init && qmd update && qmd embed"
  fi
else
  print_info "Skipping QMD. Install later: npm install -g @tobilu/qmd"
fi

if [[ "$QMD_AVAILABLE" == true ]]; then
  printf "\n  Setting up the search index...\n"
  if [[ ! -f "${HOME}/.config/qmd/index.yml" ]]; then
    rc=0
    run_with_timeout 120 qmd init >/dev/null 2>&1 || rc=$?
    if [[ "$rc" -ne 0 ]]; then
      print_warn "qmd init reported an issue (or timed out); continuing."
    fi
  fi
  if run_with_timeout 60 qmd collection add --name "$VAULT_NAME" --path "$VAULT_PATH" --pattern "**/*.md" >/dev/null 2>&1; then
    print_ok "QMD collection '$VAULT_NAME' registered"
  else
    print_info "QMD collection already exists or couldn't be added; continuing."
  fi
  # update/embed stream live — first run downloads ~2GB of models and a large
  # vault can legitimately index for a while; silence here looks like a hang
  # (and a timeout would kill healthy work). Ctrl-C is safe: re-run later.
  printf "  Indexing notes (live output below; Ctrl-C is safe — resume later with: qmd update && qmd embed)\n\n"
  if qmd update </dev/null; then
    printf "\n  Building embeddings — first run downloads ~2GB of models (~5 min)...\n\n"
    if qmd embed </dev/null; then
      print_ok "QMD index built"
    else
      print_warn "QMD embedding didn't finish. Run it later: qmd embed"
    fi
  else
    print_warn "QMD indexing didn't finish. Run it later: qmd update && qmd embed"
  fi
fi

# ============================================================================
# Step 6: Apple integrations (macOS only)
# ============================================================================
print_step 6 "Apple integrations"

ENABLE_CALENDAR=false
ENABLE_MAIL=false
ENABLE_DRAFTS=false
MAIL_READ_READY=false

if [[ "$OSTYPE" == "darwin"* ]]; then
  printf "Optional macOS integrations (change them anytime by editing .mcp.json):\n\n"
  printf "  [1] Apple Calendar & Reminders — scheduling context in reviews\n"
  printf "  [2] Apple Mail — read/search email and draft replies\n"
  printf "  [3] Drafts — quick text capture from any device\n\n"

  INTEGRATION_CHOICES=$(prompt_with_default "Enter numbers (e.g. 1,2,3), press Enter for all, or 'none'" "1,2,3")

  if [[ "$INTEGRATION_CHOICES" != "none" ]]; then
    [[ "$INTEGRATION_CHOICES" == *"1"* ]] && ENABLE_CALENDAR=true
    [[ "$INTEGRATION_CHOICES" == *"2"* ]] && ENABLE_MAIL=true
    [[ "$INTEGRATION_CHOICES" == *"3"* ]] && ENABLE_DRAFTS=true
  fi

  [[ "$ENABLE_CALENDAR" == true ]] && print_ok "Calendar & Reminders"
  [[ "$ENABLE_DRAFTS" == true ]] && print_ok "Drafts"

  # Apple Mail's fast read/search server is a separate binary (apple-mail-mcp via pipx).
  # The write/draft server runs via npx and needs no install. Handle the read server here.
  if [[ "$ENABLE_MAIL" == true ]]; then
    print_ok "Apple Mail"
    if command -v apple-mail-mcp &>/dev/null; then
      print_ok "apple-mail-mcp (read server) already installed"
      MAIL_READ_READY=true
    elif command -v pipx &>/dev/null; then
      if prompt_yes_no "  Mail's read server needs apple-mail-mcp. Install it now? (pipx install apple-mail-mcp)" "$NET_INSTALL_DEFAULT"; then
        printf "  Installing apple-mail-mcp — progress log: /tmp/weave-mail-install.log\n"
        rc=0
        run_with_timeout 300 pipx install apple-mail-mcp >/tmp/weave-mail-install.log 2>&1 || rc=$?
        if [[ "$rc" -eq 0 ]]; then
          print_ok "apple-mail-mcp installed"
          MAIL_READ_READY=true
        elif [[ "$rc" -eq 124 ]]; then
          print_warn "apple-mail-mcp install timed out after 5 minutes (log: /tmp/weave-mail-install.log). Install later: pipx install apple-mail-mcp"
        else
          print_warn "apple-mail-mcp install failed (log: /tmp/weave-mail-install.log). Install later: pipx install apple-mail-mcp"
        fi
      else
        print_info "Skipping. Install later: pipx install apple-mail-mcp"
      fi
    else
      print_warn "Mail's read server needs pipx, which isn't installed. To enable it:"
      print_info "    python3 -m pip install --user pipx && pipx ensurepath"
      print_info "    pipx install apple-mail-mcp"
      print_info "  (Mail's write/draft server works via npx without this.)"
    fi
  fi

  if [[ "$ENABLE_CALENDAR" == false && "$ENABLE_MAIL" == false && "$ENABLE_DRAFTS" == false ]]; then
    print_info "No Apple integrations selected."
  fi
else
  printf "Apple integrations are macOS-only — skipping on $(os_label).\n"
  printf "${DIM}The core system (Obsidian + Claude Code + QMD) works on any platform.${NC}\n"
fi

# ============================================================================
# Step 7: Life areas
# ============================================================================
print_step 7 "Life areas"

printf "Areas are the major domains of your life — notes are organized by area.\n"
printf "You can change them anytime later.\n\n"
printf "${DIM}Enter a comma-separated list, or press Enter for the defaults.${NC}\n"

AREA_INPUT=$(prompt_with_default "Life areas" "Work,Home,Personal,Health,Relationships,Finances")

IFS=',' read -ra AREAS <<< "$AREA_INPUT"
for i in "${!AREAS[@]}"; do
  AREAS[$i]="$(echo "${AREAS[$i]}" | xargs)"
done

printf "  Areas: %s" "${AREAS[0]}"
for area in "${AREAS[@]:1}"; do
  printf ", %s" "$area"
done
printf "\n  ${DIM}(A Self-Management area is also created, for the system's own notes.)${NC}\n"

# ============================================================================
# Step 8: Replace template variables
# ============================================================================
print_step 8 "Personalizing template variables"

# Strip install-time scaffolding: CLAUDE.md's "Template Variables" section documents the
# placeholder tokens themselves, so it's vestigial (and would be corrupted) once substituted.
sed_inplace '/^## Template Variables$/,/^---$/d' CLAUDE.md

# Resolve git placeholders to their value or a readable default, so none are ever left
# behind — including when git IS configured but the remote (or another field) is skipped.
GIT_USER_SUB="${GIT_USER:-your-username}"
GIT_EMAIL_SUB="${GIT_EMAIL:-your-email@example.com}"
GIT_REMOTE_SUB="${GIT_REMOTE:-(not configured)}"

# Substitute across all .md/.json/.sh files (incl. .obsidian/ config), excluding .git/,
# this running script, and MAINTAINING.md (which documents the {{...}} tokens themselves).
# Obsidian template tokens such as {{date}} / {{title}} are deliberately left untouched.
while IFS= read -r -d '' file; do
  sed_inplace "s|{{VAULT_NAME}}|${VAULT_NAME}|g" "$file"
  sed_inplace "s|{{VAULT_PATH}}|${VAULT_PATH}|g" "$file"
  sed_inplace "s|{{GIT_USER}}|${GIT_USER_SUB}|g" "$file"
  sed_inplace "s|{{GIT_EMAIL}}|${GIT_EMAIL_SUB}|g" "$file"
  sed_inplace "s|{{GIT_REMOTE}}|${GIT_REMOTE_SUB}|g" "$file"
done < <(find . -type f \( -name "*.md" -o -name "*.json" -o -name "*.sh" \) -not -path "./.git/*" -not -name "setup.sh" -not -name "MAINTAINING.md" -print0)

print_ok "Template variables applied"

# ============================================================================
# Step 9: Generate MCP configuration
# ============================================================================
print_step 9 "Generating MCP configuration"

if [[ -f .mcp.json ]]; then
  backup=".mcp.json.bak.$(date +%Y%m%d%H%M%S)"
  cp .mcp.json "$backup"
  print_warn "Existing .mcp.json backed up to $backup before regenerating."
fi

{
  printf '{\n  "mcpServers": {\n'

  # QMD — always included
  printf '    "qmd": {\n'
  printf '      "type": "stdio",\n'
  printf '      "command": "qmd",\n'
  printf '      "args": ["mcp"],\n'
  printf '      "env": {}\n'
  printf '    }'

  if [[ "$ENABLE_CALENDAR" == true ]]; then
    printf ',\n    "apple-events": {\n'
    printf '      "type": "stdio",\n'
    printf '      "command": "npx",\n'
    printf '      "args": ["-y", "mcp-server-apple-events"],\n'
    printf '      "env": {}\n'
    printf '    }'
  fi

  if [[ "$ENABLE_MAIL" == true ]]; then
    printf ',\n    "mail": {\n'
    printf '      "type": "stdio",\n'
    printf '      "command": "apple-mail-mcp",\n'
    printf '      "args": ["--watch"],\n'
    printf '      "env": {}\n'
    printf '    }'
    printf ',\n    "apple-mail": {\n'
    printf '      "type": "stdio",\n'
    printf '      "command": "npx",\n'
    printf '      "args": ["-y", "apple-mail-mcp"],\n'
    printf '      "env": {}\n'
    printf '    }'
  fi

  if [[ "$ENABLE_DRAFTS" == true ]]; then
    printf ',\n    "drafts": {\n'
    printf '      "type": "stdio",\n'
    printf '      "command": "npx",\n'
    printf '      "args": ["-y", "@agiletortoise/drafts-mcp-server"],\n'
    printf '      "env": {}\n'
    printf '    }'
  fi

  printf '\n  }\n}\n'
} > .mcp.json

print_ok "MCP configuration written (.mcp.json)"
if [[ "$ENABLE_CALENDAR" == true || "$ENABLE_DRAFTS" == true || "$ENABLE_MAIL" == true ]]; then
  print_info "npx-based servers (Calendar/Reminders, Mail drafts, Drafts) download on first use — needs network and the relevant app open."
fi

# ============================================================================
# Step 10: Creating vault structure
# ============================================================================
print_step 10 "Creating vault structure"

TODAY=$(date +%Y-%m-%d)

create_area_note() {
  local name="$1"
  local file="Notes/${name}.md"
  [[ -f "$file" ]] && return 0
  cat > "$file" << EOF
---
tags: [area]
created: ${TODAY}
---

# ${name}

![[${name}.base]]
EOF
}

# Areas that ship with a .base file
SHIPPED_AREA_BASES=("Work" "Home" "Personal" "Health" "Relationships" "Finances" "Self-Management" "Community" "Creating" "Curiosity")

printf "  Creating area notes...\n"
for area in "${AREAS[@]}"; do
  create_area_note "$area"

  local_match=false
  for shipped in "${SHIPPED_AREA_BASES[@]}"; do
    [[ "$area" == "$shipped" ]] && { local_match=true; break; }
  done

  if [[ "$local_match" == false ]]; then
    base_file="Templates/Bases/${area}.base"
    if [[ ! -f "$base_file" ]]; then
      cat > "$base_file" << EOF
filters:
  and:
    - list(areas).contains(link("${area}"))
    - '!file.name.contains("Template")'
views:
  - type: table
    name: Projects
    filters:
      and:
        - list(categories).contains(link("Projects"))
    order:
      - file.name
      - status
      - created
    sort:
      - property: file.mtime
        direction: DESC
  - type: table
    name: All Notes
    order:
      - file.name
      - categories
      - status
      - created
    sort:
      - property: file.mtime
        direction: DESC
EOF
      printf "    Created custom base: %s\n" "$base_file"
    fi
  fi
done

# Always create Self-Management (system infrastructure) unless the user already chose it
sm_already=false
for area in "${AREAS[@]}"; do
  [[ "$area" == "Self-Management" ]] && { sm_already=true; break; }
done
[[ "$sm_already" == false ]] && create_area_note "Self-Management"

printf "  Creating category notes...\n"
CATEGORIES=("Projects" "Research" "Articles" "Books" "People" "Evergreen" "Frameworks" "Guides" "Essays" "Collections" "Transcripts" "Journal" "Attachments")
for cat in "${CATEGORIES[@]}"; do
  file="Notes/${cat}.md"
  if [[ ! -f "$file" ]]; then
    cat > "$file" << EOF
---
tags: [categories]
created: ${TODAY}
---

# ${cat}

![[${cat}.base]]
EOF
  fi
done

print_ok "Area and category notes created"

# ============================================================================
# Step 11: Initializing git and hooks
# ============================================================================
print_step 11 "Initializing git and hooks"

if [[ ! -d .git ]]; then
  git init -q
  print_ok "Git repository initialized"
else
  print_info "Existing git repository found."
fi

if [[ -n "$GIT_USER" ]]; then
  git config user.name "$GIT_USER"
  git config user.email "$GIT_EMAIL"
  print_ok "Git identity set: $GIT_USER <$GIT_EMAIL>"

  # Credential helper only when git was configured AND the GitHub CLI is present.
  if command -v gh &>/dev/null; then
    git config credential.helper "!gh auth git-credential"
    print_ok "Git credential helper set (GitHub CLI)"
  fi
fi

if [[ -n "$GIT_REMOTE" ]]; then
  if git remote get-url origin &>/dev/null; then
    git remote set-url origin "$GIT_REMOTE"
  else
    git remote add origin "$GIT_REMOTE"
  fi
  print_ok "Git remote set: $GIT_REMOTE"
fi

# Install the post-commit hook that keeps the QMD index fresh
if [[ -f .claude/hooks/setup-git-hooks.sh ]]; then
  if bash .claude/hooks/setup-git-hooks.sh >/dev/null 2>&1; then
    print_ok "Git hooks installed (search index auto-updates after each commit)"
  else
    print_warn "Git hooks install had an issue. Run later: bash .claude/hooks/setup-git-hooks.sh"
  fi
fi

# Initial commit — only if there's something staged (safe to re-run)
git add -A
if git diff --cached --quiet; then
  print_info "Nothing new to commit."
else
  git commit -q -m "Initialize Weave vault: ${VAULT_NAME}"
  print_ok "Initial commit created"
fi

# ============================================================================
# Done
# ============================================================================
print_header "Setup Complete"

printf "Your Weave vault ${BOLD}${VAULT_NAME}${NC} is ready.\n\n"
printf "${BOLD}Next steps${NC}\n\n"
printf "  ${BOLD}1.${NC} Open this folder as a vault in Obsidian\n"
printf "     ${DIM}Obsidian > \"Open folder as vault\" > choose this folder.${NC}\n"
printf "     ${DIM}Plugins, daily notes, templates, and attachments are already configured — nothing to change.${NC}\n\n"
printf "  ${BOLD}2.${NC} Start Claude Code here:  ${CYAN}cd \"${VAULT_PATH}\" && claude${NC}\n\n"
printf "  ${BOLD}3.${NC} Run your first review:   ${CYAN}/start-workday${NC}\n\n"

# --- Tailored "still to do" list (only what applies) ---
TODO_HEADER_SHOWN=false
note_todo() {
  if [[ "$TODO_HEADER_SHOWN" == false ]]; then
    printf "${BOLD}A few things to finish${NC}\n\n"
    TODO_HEADER_SHOWN=true
  fi
  printf "  ${YELLOW}-${NC} %s\n" "$1"
}

if ! command -v claude &>/dev/null; then
  note_todo "Install Claude Code: https://docs.anthropic.com/en/docs/claude-code"
fi
if ! command -v obsidian &>/dev/null && ! { [[ "$OSTYPE" == "darwin"* ]] && [[ -d "/Applications/Obsidian.app" ]]; }; then
  note_todo "Install Obsidian 1.12+: https://obsidian.md"
fi
if [[ "$QMD_AVAILABLE" == false ]]; then
  note_todo "Set up semantic search: npm install -g @tobilu/qmd  — or your package manager's global-install equivalent  (then re-run setup, or: qmd init && qmd update && qmd embed)"
fi
if [[ "$ENABLE_MAIL" == true && "$MAIL_READ_READY" == false ]]; then
  note_todo "Finish Apple Mail's read server: pipx install apple-mail-mcp"
fi
if [[ "$ENABLE_DRAFTS" == true ]]; then
  note_todo "Launch the Drafts app before Claude Code sessions (its capture server needs it running)."
fi
if [[ "$ENABLE_CALENDAR" == true || "$ENABLE_MAIL" == true || "$ENABLE_DRAFTS" == true ]]; then
  note_todo "First use of each Apple integration triggers a macOS permission prompt — approve it."
fi
if [[ -n "$GIT_REMOTE" ]] && ! command -v gh &>/dev/null; then
  note_todo "To push to GitHub, install and sign in: brew install gh && gh auth login"
fi

if [[ "$TODO_HEADER_SHOWN" == true ]]; then
  printf "\n"
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  printf "${DIM}Optional/advanced: contextual capture (browser, Mail, Finder) via Keyboard Maestro —\nsee Notes/Capture System Setup Guide.md. Drafts text capture alone is plenty to start.${NC}\n\n"
fi

printf "New here? Read ${BOLD}Notes/Getting Started.md${NC}, and ${BOLD}Notes/Setting Up Integrations.md${NC} if you enabled integrations.\n\n"
