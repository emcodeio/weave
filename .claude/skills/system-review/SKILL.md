---
name: system-review
description: "Review system health: evaluate skills, agents, hooks, and rules for gaps, friction, or improvement opportunities. Use when the user says 'system review', 'how is the system', 'evaluate the system', or 'what needs improving'."
context: fork
agent: system-architect
---

# System Review

## Current system files

### Rules
!`ls -1 .claude/rules/ 2>/dev/null || echo "(Could not list rules)"`

### Agents
!`ls -1 .claude/agents/ 2>/dev/null || echo "(Could not list agents)"`

### Skills
!`ls .claude/skills/ 2>/dev/null || echo "(Could not list skills)"`

### Hooks configuration
!`cat .claude/settings.json 2>/dev/null || echo "(Could not read settings.json)"`

## Your task

Run a comprehensive system health review. $ARGUMENTS

Follow this workflow:

1. **Inventory check** — Read CLAUDE.md and all rules files. Verify:
   - Content accuracy (do descriptions match reality?)
   - Line counts (CLAUDE.md < 140, each rule < 100)
   - Rules table in CLAUDE.md matches actual files in `.claude/rules/`
   - No stale references to removed or renamed components

2. **Skill & agent audit** — Read each custom skill and agent definition. Check:
   - Frontmatter patterns are consistent
   - Forked skills reference existing agents
   - No stale references or broken assumptions
   - Skill descriptions match their actual behavior

3. **Hook verification** — Read each hook script. Verify:
   - `settings.json` hook entries match actual scripts in `.claude/hooks/`
   - Protect hook covers all paths that should be protected
   - No unused or orphaned hooks

4. **Friction & gap analysis** — Compare against your memory of past reviews:
   - What patterns keep causing friction?
   - What capabilities are missing?
   - Any duplication or conflicts between components?
   - Are there user workflows that lack system support?

5. **Integration health** — Verify MCP and tool references:
   - CLAUDE.md MCP priority list matches system-architecture rule
   - Tool references in skills/agents are current
   - No references to deprecated or removed integrations

## Output

Return a structured assessment:
- **Inventory** — Current counts of all system components
- **Issues** — Problems found, grouped by severity (critical / moderate / minor)
- **Improvements** — Prioritized suggestions for system enhancements
- **Comparison** — How this review compares to previous ones (from memory)
- **Next actions** — Specific follow-up items if any issues need fixing
