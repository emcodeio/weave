---
paths:
  - ".claude/**"
  - "CLAUDE.md"
  - "Notes/**"
  - "Templates/**"
---

# Architect Operations

Guidelines for modifying the productivity system itself. Active when working on system files.

## Protected Files (never modify)

- `.obsidian/` — Obsidian app configuration (managed by Obsidian)
- `.claude/settings.local.json` — User permission rules (gitignored, user-local)
- `.claude/skills/obsidian-cli|obsidian-markdown|obsidian-bases|json-canvas|defuddle/` — Plugin skills (PROTECTED by hook)
- `.claude-plugin/` — Plugin manifest (marketplace.json, plugin.json)

## Modifiable System Files

- `CLAUDE.md` — Root system instructions (keep under 140 lines)
- `.claude/settings.json` — Hooks configuration
- `.claude/rules/*.md` — Modular instruction files (one topic per file; keep focused — length is fine if single-purpose)
- `.claude/shared/*.md` — Cross-skill shared reference files (e.g., `daily-startup-dashboard.md`)
- `.claude/hooks/*.sh` — Hook scripts (must remain executable)
- `Notes/` — System notes (Action Pool, Note Schemas, etc.) live alongside all other notes
- `Templates/` — Note templates and .base files

## Change Protocol

1. **Read** the current state of the file(s) being modified
2. **Change** with minimal edits — avoid rewriting files unnecessarily
3. **Verify** the change works (test hooks, validate JSON, check line counts)
4. **Commit** with a descriptive message explaining the system change
5. **Push** to remote

## Rules File Conventions

- One topic per file — named descriptively (e.g., `weave-principles.md`, not `rules-02.md`)
- Use YAML `paths:` frontmatter to scope rules to specific directories when appropriate
- Keep each file focused on one topic; flag for trimming when a file is long *and* duplicative/unfocused, not on length alone
- No duplicate content across rules files — each concept lives in exactly one place

## Agent Tool Grants

Forked agents (`.claude/agents/*.md`) run with **only** the tools listed in their `tools:` frontmatter — an explicit allowlist. When authoring or editing an agent:

- **MCP tools (`mcp__*`) must be listed explicitly.** A reference in the agent body, or in a skill that forks into the agent, does NOT grant access — the agent reports the tool as unavailable at runtime.
- **`Bash` is a single grant** covering all shell/CLI invocations (`obsidian`, `defuddle`, `python`, etc.); these never need separate tool entries.
- **Reconcile `tools:` against everything the agent body and its forking skills reference** before shipping. `/design-agent`'s verify step enforces this; do it by hand for manual edits.

Precedent: every agent that calls `mcp__qmd__query` in its body (researcher, content-drafter, contradictions-resolver, vault-organizer, system-architect) lists it explicitly in `tools:` — a body reference alone would fail at runtime.

## System Structure Reference

```
.claude/
  settings.json       # Hooks configuration
  settings.local.json # User permissions (PROTECTED)
  skills/             # Plugin skills (PROTECTED) + custom skills
  agents/             # Agent definitions
  agent-memory/       # Project-scope agent memory (committed)
  agent-memory-local/ # Local-only agent memory (gitignored)
  rules/              # Modular instruction files
  shared/             # Cross-skill shared reference files (e.g., daily-startup-dashboard)
  hooks/              # Hook scripts
    logs/             # Ephemeral hook logs (gitignored)
```
