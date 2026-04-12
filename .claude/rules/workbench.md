# Workbench

The `Workbench/` folder is the active working space for content being iterated — specs, drafts, collaborative documents, reference material under development. Content lives here while being developed and moves to a permanent location when ready.

**Not a capture point** (that's `Inbox/`). **Not permanent storage** (that's `Notes/` or `References/`). Workbench is where you spread out an active project and work on it.

## Frontmatter Schema

Lighter than permanent notes, heavier than Inbox captures.

**Required:**

| Field | Values | Description |
|-------|--------|-------------|
| `status` | `drafting`, `paused`, `ready` | Lifecycle state |
| `created` | YYYY-MM-DD | Creation date |

**Optional:**

| Field | Description |
|-------|-------------|
| `project` | Wikilink to parent project note |
| `areas` | Area context (optional until graduation) |
| `tags` | Free-form |

**Not required:** `categories` — assigned at graduation. Folder location identifies notes as workbench content.

## Status Values

- **`drafting`** — Being actively worked on
- **`paused`** — Intentionally on hold (not stale, just parked)
- **`ready`** — Finished iterating, awaiting graduation to permanent location

## Subdirectories

Optional, project-scoped, one level deep (e.g., `Workbench/LEAP/`). No deeper nesting. Files at the root level are fine for standalone items.

## Working Sessions

Use `/open-workbench [item name]` to load context for focused work on a workbench item. This surfaces the item cluster, parent project state, and recent activity, then transitions to Partner-level collaborative work.

## Proactive Linking

**Exempt while in Workbench.** No `categories` property, no related-note linking, no category-note verification, no orphan checking. Full proactive linking happens at graduation.

## Graduation

Graduation moves a workbench file to its permanent location (`Notes/` or `References/`).

**Triggers:**
1. User explicitly says "integrate this" or "this is ready"
2. During review, Claude surfaces `status: ready` files and offers to process
3. During deep review, Claude flags stale files (unchanged 30+ days, `status: drafting`)

Run `/integrate-workbench [item name]` for the full integration workflow.

**Procedure:**
1. Apply full proactive linking checklist (categories, areas, status, related notes, etc.)
2. Move to `Notes/` or `References/` per standard routing
3. Update any notes that reference the file by path
4. Clean up empty subdirectories

**Non-graduation exits:**
- **Delete** — No longer needed (git history preserves it)
- **Absorb** — Content folded into an existing permanent note; workbench file deleted

## Review Integration

- **Daily startups**: Report workbench count alongside inbox counts. Information-only.
- **Deep review**: Check for `status: ready` (offer `/integrate-workbench`), stale items (30+ days unchanged), and items with no parent project link. Present as options, not mandates.

## Git

Workbench files are tracked in git — iteration history is valuable. Not gitignored.
