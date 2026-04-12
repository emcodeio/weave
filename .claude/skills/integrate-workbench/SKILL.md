---
name: integrate-workbench
description: "Integrate a workbench item into its permanent vault location. Applies full proactive linking, moves to Notes/ or References/, updates references. Use when: 'integrate', 'this is ready', 'move out of workbench', or during deep review when status: ready items surface."
argument-hint: "[workbench-item-name]"
---

# Integrate Workbench: $ARGUMENTS

Integrate a workbench item into the permanent vault — apply full proactive linking, move to its permanent location, and update all references.

## Steps

### 1. Find the item

Parse "$ARGUMENTS" and search `Workbench/` by name (`obsidian search query="path:Workbench/ $ARGUMENTS" vault="{{VAULT_NAME}}"`). If "$ARGUMENTS" is empty, list all workbench items grouped by status (`ready` first, then `drafting`, then `paused`) and ask which to integrate. Read the full file.

If the item has `status: drafting`, confirm: "This item is still marked `drafting` — are you sure it's ready to integrate?"

### 2. Determine destination

Based on content type, propose `Notes/` or `References/`:

| Content type | Destination |
|-------------|-------------|
| Research, specs, project artifacts | `Notes/` |
| External references (authored by others) | `References/` |
| System documentation | `Notes/` |

If the item has a `project` frontmatter field, read the parent project note for context about where this fits.

Present the recommendation: "This looks like [content type] — I'd move it to `[destination]` with `categories: ["[[Category]]"]`. Sound right?"

### 3. Apply proactive linking

This is the key transformation — workbench items are linking-exempt, so integration is when they get the full treatment. Complete the standard proactive linking checklist:

1. **Set `categories`** — Infer from content type. If ambiguous, present options and ask.
2. **Set/verify `areas`** — If already set, verify. If missing, infer from parent project or ask.
3. **Set `status`** — `active` for living documents, `completed` for finished reference material. Ask if unclear.
4. **Remove workbench-only patterns** — Remove `status: drafting`/`paused`/`ready`. Remove `project` field (the project link moves to body wikilinks or is implicit via `areas`/`categories`).
5. **Verify `tags` and `created`** — Keep existing tags. Ensure `created` is set.
6. **Search for related notes** — Use QMD (`vec` sub-query with intent describing the content) + `obsidian search` for keywords. Add wikilinks where meaningful.
7. **Verify category note** — Ensure `categories` values have corresponding category notes.

### 4. Move the file

Move from `Workbench/` to the target directory. Use Bash `mv` and update the vault index:

```bash
mv "Workbench/filename.md" "Notes/filename.md"  # or References/
```

If the file should be renamed for its permanent home (e.g., removing "Draft" from the name), do so during the move.

### 5. Update references

Search the vault for any notes that reference the old `Workbench/` path:
- The parent project note (if `project` was set)
- Any Working Context or index file in the same workbench cluster
- Sibling workbench items that linked to this file
- Other vault notes mentioning the path

Update all references to the new location. Replace path-based references with wikilinks where appropriate.

### 6. Clean up

If the integrated file was the last in a workbench subdirectory (e.g., `Workbench/LEAP/`), remove the empty directory.

### 7. Non-integration exits

If the user decides during steps 1-2 that integration isn't right:
- **Delete**: Confirm, delete the file. Note that git history preserves it.
- **Absorb**: Read the target note the user names, read the workbench item, present a merge plan showing what content moves where. Execute on confirmation, then delete the workbench file.

### 8. Commit

```bash
git add <moved file> <updated references>
git commit -m "Integrate [name] from Workbench to [destination]"
git push
```

## Edge Cases

- **Batch integration**: If the user wants to integrate an entire subdirectory (e.g., all LEAP docs), process each file but group the confirmation: "25 LEAP docs ready for Notes/ with areas: [[Work]], categories: [[Research]]. Proceed?"
- **Item still actively referenced by siblings**: If other workbench items link to this one, warn: "This file is still referenced by [sibling names] in Workbench. Integrating will update those references to point to the new location."
- **No obvious category**: Some workbench items are unique. Present 2-3 category options and let the user choose.
