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
print_step() { printf "${BOLD}[%s/%s]${NC} %s\n" "$1" "$TOTAL_STEPS" "$2"; }
print_ok() { printf "  ${GREEN}OK${NC} %s\n" "$1"; }
print_warn() { printf "  ${YELLOW}!!${NC} %s\n" "$1"; }
print_err() { printf "  ${RED}**${NC} %s\n" "$1"; }

prompt_with_default() {
  local prompt="$1"
  local default="$2"
  local result
  printf "${prompt} ${DIM}[${default}]${NC}: "
  read -r result
  echo "${result:-$default}"
}

prompt_yes_no() {
  local prompt="$1"
  local default="${2:-y}"
  local result
  printf "${prompt} ${DIM}[${default}]${NC}: "
  read -r result
  result="${result:-$default}"
  [[ "${result,,}" == "y" || "${result,,}" == "yes" ]]
}

# Cross-platform sed -i
sed_inplace() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "$@"
  else
    sed -i "$@"
  fi
}

TOTAL_STEPS=10
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Verify we're in a Weave repo
if [[ ! -f "$SCRIPT_DIR/CLAUDE.md" ]] || [[ ! -d "$SCRIPT_DIR/.claude" ]]; then
  print_err "This doesn't look like a Weave repository."
  print_err "Run setup.sh from the root of your cloned Weave repo."
  exit 1
fi

cd "$SCRIPT_DIR"

# ============================================================================
# Step 1: Welcome
# ============================================================================
print_header "Weave Setup"

printf "Weave is a meta-rational productivity system built on Obsidian + Claude Code.\n"
printf "This script will configure your vault by:\n\n"
printf "  1. Checking prerequisites (Obsidian, Claude Code, Node.js)\n"
printf "  2. Setting your vault name and path\n"
printf "  3. Configuring git (optional)\n"
printf "  4. Setting up QMD semantic search\n"
printf "  5. Choosing Apple integrations (macOS)\n"
printf "  6. Customizing your life areas\n"
printf "  7. Creating vault structure and configuration\n\n"

if ! prompt_yes_no "Ready to begin?"; then
  printf "\nNo changes made. Run setup.sh when you're ready.\n"
  exit 0
fi

# ============================================================================
# Step 2: Check Prerequisites
# ============================================================================
print_step 2 "Checking prerequisites"

PREREQ_WARNINGS=0

# Obsidian
if command -v obsidian &>/dev/null; then
  print_ok "Obsidian CLI found"
elif [[ "$OSTYPE" == "darwin"* ]] && [[ -d "/Applications/Obsidian.app" ]]; then
  print_ok "Obsidian.app found (CLI available at /Applications/Obsidian.app/Contents/MacOS/obsidian)"
else
  print_warn "Obsidian not found. Install Obsidian 1.12+ from https://obsidian.md"
  PREREQ_WARNINGS=$((PREREQ_WARNINGS + 1))
fi

# Claude Code
if command -v claude &>/dev/null; then
  print_ok "Claude Code found"
else
  print_warn "Claude Code not found. Install from https://docs.anthropic.com/en/docs/claude-code"
  PREREQ_WARNINGS=$((PREREQ_WARNINGS + 1))
fi

# Node.js
if command -v node &>/dev/null; then
  NODE_VERSION=$(node --version | sed 's/v//' | cut -d. -f1)
  if [[ "$NODE_VERSION" -ge 18 ]]; then
    print_ok "Node.js $(node --version) found"
  else
    print_warn "Node.js $(node --version) found but 18+ required"
    PREREQ_WARNINGS=$((PREREQ_WARNINGS + 1))
  fi
else
  print_warn "Node.js not found. Install Node.js 18+ from https://nodejs.org"
  PREREQ_WARNINGS=$((PREREQ_WARNINGS + 1))
fi

if [[ $PREREQ_WARNINGS -gt 0 ]]; then
  printf "\n"
  print_warn "$PREREQ_WARNINGS prerequisite(s) missing. Setup will continue but some features may not work."
  printf "\n"
fi

# ============================================================================
# Step 3: Vault Name
# ============================================================================
print_step 3 "Vault name"

printf "This should match your Obsidian vault name.\n"
VAULT_NAME=$(prompt_with_default "Vault name" "$(basename "$PWD")")

# ============================================================================
# Step 4: Vault Path
# ============================================================================
print_step 4 "Vault path"

VAULT_PATH=$(prompt_with_default "Vault path" "$PWD")

# Resolve to absolute path
VAULT_PATH="$(cd "$VAULT_PATH" 2>/dev/null && pwd || echo "$VAULT_PATH")"

# ============================================================================
# Step 5: Git Identity
# ============================================================================
print_step 5 "Git configuration"

GIT_USER=""
GIT_EMAIL=""
GIT_REMOTE=""

if prompt_yes_no "Configure git for this vault?"; then
  GIT_USER=$(prompt_with_default "  Git username" "$(git config user.name 2>/dev/null || echo "")")
  GIT_EMAIL=$(prompt_with_default "  Git email" "$(git config user.email 2>/dev/null || echo "")")
  printf "  ${DIM}Remote is optional. Enter a GitHub URL or press Enter to skip.${NC}\n"
  GIT_REMOTE=$(prompt_with_default "  Git remote URL" "")
fi

# ============================================================================
# Step 6: QMD Setup
# ============================================================================
print_step 6 "QMD semantic search"

printf "QMD provides local semantic search over your vault notes.\n"
printf "It powers inbox routing, context surfacing, and knowledge discovery.\n\n"

QMD_AVAILABLE=false

if command -v qmd &>/dev/null; then
  print_ok "QMD found at $(command -v qmd)"
  QMD_AVAILABLE=true
else
  print_warn "QMD not found."
  if command -v npm &>/dev/null; then
    if prompt_yes_no "  Install QMD now? (npm install -g @tobilu/qmd)"; then
      printf "  Installing QMD...\n"
      if npm install -g @tobilu/qmd 2>&1 | tail -3; then
        print_ok "QMD installed"
        QMD_AVAILABLE=true
      else
        print_err "QMD installation failed. You can install manually later: npm install -g @tobilu/qmd"
      fi
    fi
  else
    print_warn "npm not available. Install Node.js 18+ first, then: npm install -g @tobilu/qmd"
  fi
fi

QMD_INITIALIZED=false

if [[ "$QMD_AVAILABLE" == true ]]; then
  printf "\n  Initializing QMD index...\n"
  printf "  ${DIM}Note: First run downloads ~2GB of local models. This may take a few minutes.${NC}\n\n"

  if [[ ! -f "${HOME}/.config/qmd/index.yml" ]]; then
    qmd init 2>/dev/null || true
  fi

  # Configure collection
  if qmd collection add --name "$VAULT_NAME" --path "$VAULT_PATH" --pattern "**/*.md" 2>/dev/null; then
    print_ok "QMD collection '$VAULT_NAME' configured"
  else
    # Collection may already exist, try updating
    print_warn "Collection may already exist. Continuing..."
  fi

  printf "  Building search index (this downloads models on first run)...\n"
  if qmd update 2>&1 | tail -3 && qmd embed 2>&1 | tail -3; then
    print_ok "QMD index built"
    QMD_INITIALIZED=true
  else
    print_warn "QMD indexing had issues. You can run 'qmd update && qmd embed' manually later."
  fi
fi

# ============================================================================
# Step 7: Apple Integrations (macOS only)
# ============================================================================
print_step 7 "Apple integrations"

ENABLE_CALENDAR=false
ENABLE_MAIL=false
ENABLE_DRAFTS=false

if [[ "$OSTYPE" == "darwin"* ]]; then
  printf "These integrations connect Claude to macOS apps.\n"
  printf "All are optional and can be enabled later.\n\n"
  printf "  [1] Apple Calendar & Reminders — scheduling context in reviews\n"
  printf "  [2] Apple Mail — read/search email, draft replies\n"
  printf "  [3] Drafts — quick text capture from anywhere\n\n"

  INTEGRATION_CHOICES=$(prompt_with_default "Which integrations? (e.g., 1,2,3 or 'none')" "1,2,3")

  if [[ "$INTEGRATION_CHOICES" != "none" ]]; then
    [[ "$INTEGRATION_CHOICES" == *"1"* ]] && ENABLE_CALENDAR=true
    [[ "$INTEGRATION_CHOICES" == *"2"* ]] && ENABLE_MAIL=true
    [[ "$INTEGRATION_CHOICES" == *"3"* ]] && ENABLE_DRAFTS=true
  fi

  [[ "$ENABLE_CALENDAR" == true ]] && print_ok "Calendar & Reminders enabled"
  [[ "$ENABLE_MAIL" == true ]] && print_ok "Apple Mail enabled"
  [[ "$ENABLE_DRAFTS" == true ]] && print_ok "Drafts enabled"
  [[ "$ENABLE_CALENDAR" == false && "$ENABLE_MAIL" == false && "$ENABLE_DRAFTS" == false ]] && printf "  No Apple integrations selected.\n"
else
  printf "Apple integrations are macOS-only. Skipping.\n"
  printf "Core system (Obsidian + Claude Code + QMD) works on any platform.\n"
fi

# ============================================================================
# Step 8: Life Areas
# ============================================================================
print_step 8 "Life areas"

printf "Areas are the major domains of your life. Notes are organized by area.\n"
printf "Defaults: Work, Home, Personal, Health, Relationships, Finances\n\n"
printf "You can customize: enter a comma-separated list, or press Enter for defaults.\n"
printf "${DIM}Examples: 'Work,Home,Personal,Health,Creativity' or just press Enter${NC}\n"

AREA_INPUT=$(prompt_with_default "Life areas" "Work,Home,Personal,Health,Relationships,Finances")

# Parse areas into array
IFS=',' read -ra AREAS <<< "$AREA_INPUT"
# Trim whitespace from each area
for i in "${!AREAS[@]}"; do
  AREAS[$i]="$(echo "${AREAS[$i]}" | xargs)"
done

printf "  Areas: "
printf "%s" "${AREAS[0]}"
for area in "${AREAS[@]:1}"; do
  printf ", %s" "$area"
done
printf "\n"
printf "  ${DIM}(Self-Management area is always created for system notes)${NC}\n"

# ============================================================================
# Step 9: Execute
# ============================================================================
print_step 9 "Configuring vault"

printf "\n"

# --- 9A: Template variable replacement ---
printf "  Replacing template variables...\n"

# Build file list (all .md, .json, .sh files, excluding .git/)
while IFS= read -r -d '' file; do
  sed_inplace "s|{{VAULT_NAME}}|${VAULT_NAME}|g" "$file"
  sed_inplace "s|{{VAULT_PATH}}|${VAULT_PATH}|g" "$file"

  if [[ -n "$GIT_USER" ]]; then
    sed_inplace "s|{{GIT_USER}}|${GIT_USER}|g" "$file"
  fi
  if [[ -n "$GIT_EMAIL" ]]; then
    sed_inplace "s|{{GIT_EMAIL}}|${GIT_EMAIL}|g" "$file"
  fi
  if [[ -n "$GIT_REMOTE" ]]; then
    sed_inplace "s|{{GIT_REMOTE}}|${GIT_REMOTE}|g" "$file"
  fi
done < <(find . -type f \( -name "*.md" -o -name "*.json" -o -name "*.sh" \) -not -path "./.git/*" -print0)

print_ok "Template variables replaced"

# Clean up git template variables if git was skipped
if [[ -z "$GIT_USER" ]]; then
  printf "  Replacing skipped git variables with defaults...\n"
  while IFS= read -r -d '' file; do
    sed_inplace 's|{{GIT_USER}}|your-username|g' "$file"
    sed_inplace 's|{{GIT_EMAIL}}|your-email@example.com|g' "$file"
    sed_inplace 's|{{GIT_REMOTE}}|(not configured)|g' "$file"
  done < <(find . -type f \( -name "*.md" -o -name "*.json" \) -not -path "./.git/*" -print0)
  print_ok "Git placeholder defaults applied"
fi

# --- 9B: Generate .mcp.json ---
printf "  Generating MCP configuration...\n"

{
  printf '{\n  "mcpServers": {\n'

  # QMD — always included
  printf '    "qmd": {\n'
  printf '      "type": "stdio",\n'
  printf '      "command": "qmd",\n'
  printf '      "args": ["mcp"],\n'
  printf '      "env": {}\n'
  printf '    }'

  # Apple Calendar & Reminders
  if [[ "$ENABLE_CALENDAR" == true ]]; then
    printf ',\n    "apple-events": {\n'
    printf '      "type": "stdio",\n'
    printf '      "command": "npx",\n'
    printf '      "args": ["-y", "mcp-server-apple-events"],\n'
    printf '      "env": {}\n'
    printf '    }'
  fi

  # Apple Mail — read server
  if [[ "$ENABLE_MAIL" == true ]]; then
    printf ',\n    "mail": {\n'
    printf '      "type": "stdio",\n'
    printf '      "command": "apple-mail-mcp",\n'
    printf '      "args": ["--watch"],\n'
    printf '      "env": {}\n'
    printf '    }'

    # Apple Mail — write server (always paired with read)
    printf ',\n    "apple-mail": {\n'
    printf '      "type": "stdio",\n'
    printf '      "command": "npx",\n'
    printf '      "args": ["-y", "apple-mail-mcp"],\n'
    printf '      "env": {}\n'
    printf '    }'
  fi

  # Drafts
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

print_ok "MCP configuration generated (.mcp.json)"

# --- 9C: Create area notes ---
printf "  Creating area notes...\n"

TODAY=$(date +%Y-%m-%d)

create_area_note() {
  local name="$1"
  local file="Notes/${name}.md"

  if [[ -f "$file" ]]; then
    return 0
  fi

  cat > "$file" << EOF
---
tags: [area]
created: ${TODAY}
---

# ${name}

![[${name}.base]]
EOF
}

# Default areas that have shipped .base files
SHIPPED_AREA_BASES=("Work" "Home" "Personal" "Health" "Relationships" "Finances" "Self-Management" "Community" "Creating" "Curiosity")

# Create notes for user-chosen areas
for area in "${AREAS[@]}"; do
  create_area_note "$area"

  # Check if this area needs a custom .base file
  local_match=false
  for shipped in "${SHIPPED_AREA_BASES[@]}"; do
    if [[ "$area" == "$shipped" ]]; then
      local_match=true
      break
    fi
  done

  if [[ "$local_match" == false ]]; then
    # Generate a base file for custom areas
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

# Always create Self-Management (system infrastructure)
create_area_note "Self-Management"

print_ok "Area notes created"

# --- 9D: Create category notes ---
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

print_ok "Category notes created"

# --- 9E: Git setup ---
printf "  Configuring git...\n"

if [[ ! -d .git ]]; then
  git init -q
  print_ok "Git repository initialized"
else
  printf "    ${DIM}Existing git repo found${NC}\n"
fi

if [[ -n "$GIT_USER" ]]; then
  git config user.name "$GIT_USER"
  git config user.email "$GIT_EMAIL"
  print_ok "Git identity set: $GIT_USER <$GIT_EMAIL>"
fi

if [[ -n "$GIT_REMOTE" ]]; then
  if git remote get-url origin &>/dev/null; then
    git remote set-url origin "$GIT_REMOTE"
  else
    git remote add origin "$GIT_REMOTE"
  fi
  print_ok "Git remote set: $GIT_REMOTE"
fi

# Configure credential helper for GitHub
if command -v gh &>/dev/null; then
  git config credential.helper "!gh auth git-credential"
fi

git add -A
git commit -q -m "Initialize Weave vault: ${VAULT_NAME}"
print_ok "Initial commit created"

# --- 9F: Install hooks ---
if [[ -f .claude/hooks/setup-git-hooks.sh ]]; then
  bash .claude/hooks/setup-git-hooks.sh 2>/dev/null || true
  print_ok "Git hooks installed"
fi

# ============================================================================
# Step 10: Done
# ============================================================================
print_header "Setup Complete"

printf "Your Weave vault ${BOLD}${VAULT_NAME}${NC} is ready.\n\n"
printf "Next steps:\n\n"
printf "  ${BOLD}1.${NC} Open this folder as a vault in Obsidian\n"
printf "     ${DIM}File > Open vault > Open folder as vault > select this directory${NC}\n\n"
printf "  ${BOLD}2.${NC} Start Claude Code in this directory:\n"
printf "     ${CYAN}cd \"${VAULT_PATH}\" && claude${NC}\n\n"
printf "  ${BOLD}3.${NC} Try your first review:\n"
printf "     ${CYAN}/start-workday${NC}\n\n"
printf "Read ${BOLD}Notes/Getting Started.md${NC} in your vault for a guided introduction.\n\n"

if [[ "$QMD_AVAILABLE" == false ]]; then
  print_warn "QMD was not installed. Semantic search will be unavailable."
  printf "  Install later: npm install -g @tobilu/qmd && qmd init && qmd update && qmd embed\n\n"
fi

if [[ "$ENABLE_CALENDAR" == false && "$ENABLE_MAIL" == false && "$ENABLE_DRAFTS" == false ]] && [[ "$OSTYPE" == "darwin"* ]]; then
  printf "${DIM}Tip: You can enable Apple integrations later by editing .mcp.json${NC}\n"
  printf "${DIM}See .mcp.json.example for available servers.${NC}\n\n"
fi
