---
name: system-review
description: "Audit the .claude/ system — skills, agents, hooks, rules — for drift, staleness, duplication, gaps, and friction. Use when the user wants a system review or health check, asks 'how is the system / what needs improving', after a batch of system changes that should be sanity-checked, or when something feels stale, duplicated, or out of sync."
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
   - Line counts: CLAUDE.md < 140. For rules, flag a file only if it is *both* long *and* duplicative/unfocused — a long but single-purpose spec (e.g., `concept-forge-artifact-format`) is not a defect. The test is duplication and scope-creep, not raw length.
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

4. **Protected-skill currency** — Run `.claude/hooks/check-protected-skills.sh` to diff
   the vendored kepano plugin skills (obsidian-cli/markdown/bases/canvas, defuddle) against
   `kepano/obsidian-skills@main`. Do NOT trust the plugin version field — upstream ships
   content changes without bumping it (it has sat at 1.0.1 across multiple commits), so a
   marketplace update check misses drift; the file-level diff is authoritative. If the script
   reports `DIFFERENT` or `LOCAL-ONLY`, rerun with `--diff` for specifics and report it as a
   finding. Syncing is a user-authorized step, not automatic: these files are guarded by the
   protect hook (Edit/Write blocked), so a sync is a deliberate Bash copy of the verified
   upstream content after the user confirms — and includes any matching tooling change (e.g.
   the npm package an install line names).

5. **Friction & gap analysis** — Compare against your memory of past reviews:
   - What patterns keep causing friction?
   - What capabilities are missing?
   - Any duplication or conflicts between components?
   - Are there user workflows that lack system support?

6. **Integration health** — Verify MCP and tool references:
   - CLAUDE.md MCP priority list matches system-architecture rule
   - Tool references in skills/agents are current
   - No references to deprecated or removed integrations

## Output

Return a structured assessment — findings surfaced as options for the user to choose from, never as a mandate to fix:
- **Inventory** — current counts of all system components
- **Issues** — problems found, grouped by severity (critical / moderate / minor)
- **Improvements** — enhancement suggestions, framed as options the user can pick up or set aside
- **Comparison** — how this review compares to previous ones (from memory)
- **Next actions** — concrete follow-ups the user *could* take, ordered by leverage; the user decides what, if anything, to act on
