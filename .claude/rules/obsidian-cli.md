# Obsidian CLI

Obsidian 1.12+ ships with an official CLI (`obsidian`) that talks to a running Obsidian instance. **Prefer CLI commands over direct file tools (Read/Edit/Glob/Grep) for vault operations** — the CLI uses Obsidian's search index, backlink graph, and property engine, which is faster and more accurate than raw file access.

## Safety: Content and File Location

- **No stdin** — The CLI ignores piped input. Never use `cat ... | obsidian create` or heredocs piped to the CLI. Content is ONLY passed via the `content="..."` parameter.
- **`create` defaults to vault root** — Without `path=`, new files land in the vault root, not the intended folder. Always specify `path=` for correct placement.
- **`create overwrite` is destructive** — It replaces the entire file. Never use it to update an existing note. Use `obsidian read` + Edit tool instead.
- **`content=` size limit** — The `content="..."` parameter chokes on large strings (200+ lines). For large files (transcripts, long captures), copy the source file to the target location with `cp`, then use the Edit tool to add/modify the top sections. Never try to pass an entire transcript as a CLI content parameter.
- **`file=` vs `path=`** — `file="Name"` resolves like a wikilink (searches whole vault). `path="folder/note.md"` uses exact path from vault root.

## When to use CLI vs direct file access

| Operation | Tool | Notes |
|-----------|------|-------|
| Search notes (keyword) | `obsidian search query="term" limit=10` | |
| Search notes (semantic) | `mcp__qmd__query` | See `qmd` rule |
| Read a note | `obsidian read file="Name"` or `path="folder/note.md"` | Use Read tool only for system files (CLAUDE.md, configs) |
| Create a new note | `obsidian create path="Notes/note.md" content="..." silent` | Always include `path=` for correct placement |
| Update an existing note | `obsidian read` → Edit tool | Never use `create overwrite` — Edit is safe |
| Append to a note | `obsidian append file="Note" content="..."` | For adding content to the end only |
| Set frontmatter property | `obsidian property:set name="key" value="val" file="Note"` | Safer than editing YAML manually |
| Find backlinks | `obsidian backlinks file="Note"` | |
| Find orphans | `obsidian orphans` | |
| Find dead-end notes | `obsidian deadends` | |
| List/count tags | `obsidian tags counts sort=count` | |
| Unresolved links | `obsidian unresolved counts` | |
| Daily note ops | `obsidian daily:read` / `daily:append` | `daily:read` creates the note from template if it doesn't exist — never use `obsidian create` for daily notes |
| List vault tasks | `obsidian tasks todo` | |
| Move/rename a note | `obsidian move file="Note" to="Notes"` | |

## Key patterns

- **Always specify vault**: `vault="{{VAULT_NAME}}"` — prevents targeting the wrong vault if multiple are open.
- **Use `silent` flag** when creating notes — prevents Obsidian from opening/focusing the new note.
- **Use `format=json`** when you need parseable output for programmatic use.
- **Use `total` flag** on list commands to get a count instead of full output.
- **Multiline content**: Use `\n` for newlines and `\t` for tabs in content strings.
- **Content via parameter only**: Pass content inline — `content="---\ncategories: [\"[[Research]]\"]\nstatus: active\n---\n\n# Title\n\nBody text."` — never via stdin or pipe.

## CLI in reviews

During daily and weekly reviews, use these commands for vault health checks:

```bash
obsidian orphans vault="{{VAULT_NAME}}"       # Notes with no backlinks
obsidian deadends vault="{{VAULT_NAME}}"      # Notes with no outgoing links
obsidian unresolved vault="{{VAULT_NAME}}"    # Broken wikilinks
obsidian tasks todo vault="{{VAULT_NAME}}"    # Open tasks across the vault
obsidian tags counts sort=count vault="{{VAULT_NAME}}"  # Tag usage overview
```

## Fallback behavior

The CLI requires Obsidian to be running. If a command fails with a connection error, fall back to direct file tools (Read, Edit, Write, Glob, Grep) and prompt the user to open Obsidian.
