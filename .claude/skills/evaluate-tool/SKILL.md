---
name: evaluate-tool
description: "Evaluate a tool or integration for the productivity system. Researches the tool, compares alternatives, assesses fit, and creates an evaluation note in Notes/. Use when the user says 'evaluate', 'should we use', 'compare tools', 'assess this integration', or 'what about adding'."
argument-hint: "[tool or integration to evaluate]"
context: fork
agent: system-architect
---

# Evaluate: $ARGUMENTS

## Current integrations

!`cat .claude/rules/system-architecture.md 2>/dev/null || echo "(Could not read system-architecture rule)"`

## Previous evaluations

!`obsidian search query="tool-evaluation" vault="{{VAULT_NAME}}" limit=5 2>/dev/null || echo "(Could not search vault — Obsidian may not be running. Use Grep/Glob to search files directly.)"`

## Your task

Evaluate **$ARGUMENTS** for potential integration into the productivity system.

Follow this workflow:

1. **Understand the candidate** — What is it, what problem does it solve, how does it connect (MCP server, CLI, API, plugin)? Does it overlap with existing tools?

2. **Research** — Use WebSearch for:
   - Official documentation and capabilities
   - Adoption signals (community size, maintenance activity)
   - Claude Code / MCP compatibility
   - Known limitations and gotchas
   Use WebFetch to deep-read the 2-3 most relevant sources.

3. **Check vault knowledge** — Search the vault for:
   - Existing notes about this tool or similar tools — use `mcp__qmd__query` with `lex` (tool name) + `vec` (problem it solves) and `intent` describing the evaluation context. See the `qmd` rule for query construction patterns.
   - Previous evaluations in `Notes/`
   - Check your memory for past evaluation context

4. **Compare alternatives** — Assess against current tools:
   - Feature coverage overlap and gaps
   - Integration complexity (how much system change is needed?)
   - Maintenance burden (who updates it? how often?)
   - UX impact (does it simplify or complicate the user's workflow?)

5. **Assess system impact** — If adopted, what changes?
   - Which rules, skills, or hooks need updates?
   - New protected paths needed?
   - New agent or skill required?
   - Risk if the tool is abandoned or breaks?

6. **Create evaluation note** — In `Notes/` with:
   ```yaml
   ---
   categories: ["[[Research]]"]
   status: active
   areas: []
   tags: [tool-evaluation]
   created: YYYY-MM-DD
   ---
   ```
   Body: overview, comparison matrix, integration plan, recommendation, revisit triggers.

7. **Link and commit** — Verify categories and areas properties. Commit the evaluation note.

## Output

Return:
- **Recommendation** — Adopt / Defer / Reject (with clear rationale)
- **Key findings** — 3-5 bullets of the most important discoveries
- **Evaluation note** — Path to the created vault note
- **Integration effort** — Low / Medium / High
- **Revisit triggers** — Conditions that should prompt re-evaluation
