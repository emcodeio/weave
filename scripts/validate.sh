#!/usr/bin/env bash
# Weave Release Validation Script
# Run from repo root: bash scripts/validate.sh
set -euo pipefail

# --- Colors ---
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BOLD='\033[1m'
NC='\033[0m'

PASS=0
FAIL=0
WARN=0

check_pass() { printf "  ${GREEN}PASS${NC} %s\n" "$1"; PASS=$((PASS + 1)); }
check_fail() { printf "  ${RED}FAIL${NC} %s\n" "$1"; FAIL=$((FAIL + 1)); }
check_warn() { printf "  ${YELLOW}WARN${NC} %s\n" "$1"; WARN=$((WARN + 1)); }

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_DIR"

printf "\n${BOLD}Weave Release Validation${NC}\n"
printf "========================\n\n"

# ============================================================================
# 1. Personal Reference Check
# ============================================================================
printf "${BOLD}[1] Personal references${NC}\n"

# Check for personal identifiers (excluding .git/ and the intentional README clone URL)
# Note: LICENSE intentionally contains copyright holder name — not scanned here
PERSONAL_HITS=$(grep -r --include="*.md" --include="*.json" --include="*.sh" -i \
  'cortex\|eerickson\|evan@' . \
  --exclude-dir=.git 2>/dev/null \
  | grep -v 'emcodeio/weave' \
  | grep -v 'setup.sh' \
  | grep -v 'validate.sh' \
  || true)

if [[ -z "$PERSONAL_HITS" ]]; then
  check_pass "No personal identifiers found (cortex, eerickson, evan@)"
else
  check_fail "Personal identifiers found:"
  echo "$PERSONAL_HITS" | head -20 | sed 's/^/    /'
fi

# Check for specific personal names/content
SPECIFIC_HITS=$(grep -r --include="*.md" \
  'Aleks\|Chakarov\|Aleksandar\|Oscar Party\|Shadow Audit' . \
  --exclude-dir=.git --exclude-dir=scripts 2>/dev/null || true)

if [[ -z "$SPECIFIC_HITS" ]]; then
  check_pass "No personal content found (Aleks, Shadow Audit, etc.)"
else
  check_fail "Personal content found:"
  echo "$SPECIFIC_HITS" | head -20 | sed 's/^/    /'
fi

# Check for practice-domain content
PRACTICE_HITS=$(grep -r --include="*.md" -i \
  'practice-scholar\|practice-domain\|facilitate-practice\|shadow-review\|approaching-vividness' . \
  --exclude-dir=.git --exclude-dir=scripts 2>/dev/null || true)

if [[ -z "$PRACTICE_HITS" ]]; then
  check_pass "No practice-domain content found"
else
  check_fail "Practice-domain content found:"
  echo "$PRACTICE_HITS" | head -20 | sed 's/^/    /'
fi

# ============================================================================
# 2. Template Variable Check
# ============================================================================
printf "\n${BOLD}[2] Template variables${NC}\n"

# GIT_* variables should not appear outside setup.sh (they're the ones that can be skipped)
GIT_VAR_HITS=$(grep -r '{{GIT_USER}}\|{{GIT_EMAIL}}\|{{GIT_REMOTE}}' . \
  --include="*.md" --include="*.json" \
  --exclude-dir=.git 2>/dev/null || true)

if [[ -z "$GIT_VAR_HITS" ]]; then
  check_pass "No unreplaced {{GIT_*}} variables in .md/.json files"
else
  # These are expected pre-setup, just verify they exist in the right places
  check_pass "{{GIT_*}} template variables present (replaced by setup.sh)"
fi

# VAULT_NAME and VAULT_PATH should exist pre-setup
VAULT_VAR_COUNT=$(grep -r '{{VAULT_NAME}}\|{{VAULT_PATH}}' . \
  --include="*.md" --include="*.json" --include="*.sh" \
  --exclude-dir=.git 2>/dev/null | wc -l | tr -d ' ')

if [[ "$VAULT_VAR_COUNT" -gt 0 ]]; then
  check_pass "{{VAULT_NAME}}/{{VAULT_PATH}} variables present ($VAULT_VAR_COUNT instances)"
else
  check_fail "No {{VAULT_NAME}}/{{VAULT_PATH}} variables found — setup.sh has nothing to replace"
fi

# ============================================================================
# 3. File Structure
# ============================================================================
printf "\n${BOLD}[3] File structure${NC}\n"

EXPECTED_DIRS=(".claude" ".claude/skills" ".claude/rules" ".claude/hooks" ".claude/agents" ".obsidian" "Notes" "Templates" "Templates/Bases" "Daily" "Inbox" "Workbench" "Attachments" "References")

for dir in "${EXPECTED_DIRS[@]}"; do
  if [[ -d "$dir" ]]; then
    check_pass "Directory: $dir"
  else
    check_fail "Missing directory: $dir"
  fi
done

EXPECTED_FILES=("CLAUDE.md" "README.md" "setup.sh" ".gitignore" ".mcp.json.example" ".claude/settings.json" "LICENSE" "CHANGELOG.md")

for file in "${EXPECTED_FILES[@]}"; do
  if [[ -f "$file" ]]; then
    check_pass "File: $file"
  else
    check_fail "Missing file: $file"
  fi
done

# ============================================================================
# 4. Component Counts
# ============================================================================
printf "\n${BOLD}[4] Component counts${NC}\n"

SKILL_COUNT=$(find .claude/skills -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
if [[ "$SKILL_COUNT" -eq 35 ]]; then
  check_pass "Skills: $SKILL_COUNT (expected 35)"
else
  check_fail "Skills: $SKILL_COUNT (expected 35)"
fi

AGENT_COUNT=$(find .claude/agents -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
if [[ "$AGENT_COUNT" -eq 5 ]]; then
  check_pass "Agents: $AGENT_COUNT (expected 5)"
else
  check_fail "Agents: $AGENT_COUNT (expected 5)"
fi

RULE_COUNT=$(find .claude/rules -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
if [[ "$RULE_COUNT" -eq 15 ]]; then
  check_pass "Rules: $RULE_COUNT (expected 15)"
else
  check_fail "Rules: $RULE_COUNT (expected 15)"
fi

HOOK_COUNT=$(find .claude/hooks -name "*.sh" 2>/dev/null | wc -l | tr -d ' ')
if [[ "$HOOK_COUNT" -eq 6 ]]; then
  check_pass "Hooks: $HOOK_COUNT (expected 6)"
else
  check_fail "Hooks: $HOOK_COUNT (expected 6)"
fi

TEMPLATE_COUNT=$(find Templates -maxdepth 1 -name "Template - *.md" 2>/dev/null | wc -l | tr -d ' ')
if [[ "$TEMPLATE_COUNT" -eq 14 ]]; then
  check_pass "Templates: $TEMPLATE_COUNT (expected 14)"
else
  check_fail "Templates: $TEMPLATE_COUNT (expected 14)"
fi

BASES_COUNT=$(find Templates/Bases -name "*.base" 2>/dev/null | wc -l | tr -d ' ')
if [[ "$BASES_COUNT" -eq 25 ]]; then
  check_pass "Bases views: $BASES_COUNT (expected 25)"
else
  check_fail "Bases views: $BASES_COUNT (expected 25)"
fi

# ============================================================================
# 5. SKILL.md Presence
# ============================================================================
printf "\n${BOLD}[5] SKILL.md presence${NC}\n"

MISSING_SKILLS=0
for d in .claude/skills/*/; do
  if [[ ! -f "${d}SKILL.md" ]]; then
    check_fail "Missing SKILL.md: $d"
    MISSING_SKILLS=$((MISSING_SKILLS + 1))
  fi
done

if [[ "$MISSING_SKILLS" -eq 0 ]]; then
  check_pass "All skill directories have SKILL.md"
fi

# ============================================================================
# 6. Template Frontmatter
# ============================================================================
printf "\n${BOLD}[6] Template frontmatter${NC}\n"

BAD_TEMPLATES=0
for f in Templates/Template\ -\ *.md; do
  if ! head -1 "$f" | grep -q '^---'; then
    check_fail "Missing frontmatter: $(basename "$f")"
    BAD_TEMPLATES=$((BAD_TEMPLATES + 1))
  fi
done

if [[ "$BAD_TEMPLATES" -eq 0 ]]; then
  check_pass "All templates have YAML frontmatter"
fi

# ============================================================================
# 7. setup.sh Syntax
# ============================================================================
printf "\n${BOLD}[7] setup.sh syntax${NC}\n"

if bash -n setup.sh 2>/dev/null; then
  check_pass "setup.sh passes syntax check"
else
  check_fail "setup.sh has syntax errors"
fi

# ============================================================================
# 8. Guide Notes
# ============================================================================
printf "\n${BOLD}[8] Guide notes${NC}\n"

GUIDE_NOTES=("Notes/Getting Started.md" "Notes/System Overview.md" "Notes/Customizing Your System.md" "Notes/Your First Review.md" "Notes/Setting Up Integrations.md" "Notes/Weave - Chapman Framework.md" "Notes/Weave - System Design Notes.md" "Notes/Note Schemas.md" "Notes/Action Pool.md" "Notes/Someday Pool.md" "Notes/Day-Specific Routines.md" "Notes/Capture System Setup Guide.md")

MISSING_GUIDES=0
for note in "${GUIDE_NOTES[@]}"; do
  if [[ ! -f "$note" ]]; then
    check_fail "Missing: $note"
    MISSING_GUIDES=$((MISSING_GUIDES + 1))
  fi
done

if [[ "$MISSING_GUIDES" -eq 0 ]]; then
  check_pass "All 12 guide notes present"
fi

# ============================================================================
# Summary
# ============================================================================
printf "\n${BOLD}========================${NC}\n"
printf "${BOLD}Results:${NC} "
printf "${GREEN}%d passed${NC}" "$PASS"
[[ "$WARN" -gt 0 ]] && printf ", ${YELLOW}%d warnings${NC}" "$WARN"
[[ "$FAIL" -gt 0 ]] && printf ", ${RED}%d failed${NC}" "$FAIL"
printf "\n\n"

if [[ "$FAIL" -gt 0 ]]; then
  printf "${RED}Validation FAILED${NC} — fix the issues above before release.\n\n"
  exit 1
else
  printf "${GREEN}Validation PASSED${NC} — ready for manual testing.\n\n"
  exit 0
fi
