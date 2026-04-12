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
- `.claude/settings.local.json` — User permission rules (162 allow entries)
- `.claude/skills/obsidian-cli|obsidian-markdown|obsidian-bases|json-canvas|defuddle/` — Plugin skills (PROTECTED by hook)
- `.claude-plugin/` — Plugin manifest (marketplace.json, plugin.json)

## Modifiable System Files

- `CLAUDE.md` — Root system instructions (keep under 140 lines)
- `.claude/settings.json` — Hooks configuration
- `.claude/rules/*.md` — Modular instruction files (one topic per file, under 100 lines)
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
- Keep each file under 100 lines where possible
- No duplicate content across rules files — each concept lives in exactly one place

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
  hooks/              # Hook scripts
    logs/             # Ephemeral hook logs (gitignored)
```
