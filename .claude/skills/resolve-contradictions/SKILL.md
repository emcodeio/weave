---
name: resolve-contradictions
description: "Scan the vault for semantic contradictions: status drift, misplaced completions, malformed projects, pool drift, and orphaned system references. Reports findings with evidence and resolution options. Use when the user says 'contradictions', 'consistency check', 'find inconsistencies', or 'vault contradictions'."
argument-hint: "[optional: project name for targeted scan]"
context: fork
agent: contradictions-resolver
---

# Contradiction Scan

## Current vault state

### Active projects
!`obsidian search query="categories: Projects" vault="{{VAULT_NAME}}" format=json 2>/dev/null || echo "(Could not search vault — Obsidian may not be running. Use Glob to list Notes/*.md and filter by categories instead.)"`

### System rules inventory
!`ls .claude/rules/`

### Skills inventory
!`ls .claude/skills/`

### Agents inventory
!`ls .claude/agents/`

## Your task

Scan the vault for semantic contradictions and report findings with evidence and resolution options.

**Mode**:
- If `$ARGUMENTS` is provided → **targeted scan** on that project. Run detection types 1-4 on the named project, plus type 5 cross-reference against Action Pool and Someday Pool. Only run type 6 (orphaned system references) if the project relates to system design.
- If `$ARGUMENTS` is empty → **full vault scan**. Run all 6 detection types across the entire vault.

## Quality standards

- **Never auto-resolve** — report findings and offer options. The user decides.
- **Evidence from both sides** — always quote the conflicting sources so the user can judge.
- **Group related findings** — multiple issues in the same file should be presented together.
- **Skip noise** — don't report things that are clearly fine. False positives waste attention.
- **Severity matters** — lead with critical findings. Minor issues go at the end.

## Output

Return a structured contradiction report with:
- Summary counts by severity (critical / moderate / minor)
- Each finding with type, evidence quotes, and resolution options
- Detection types that found nothing explicitly noted (confirms they ran)
