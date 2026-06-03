# Vault Conventions

## Vault Organization

Property-based structure with 7 clean folders:

```
Notes/              — Everything I created or about my world (projects, area notes, category notes, system notes)
References/         — External entities (books, people, places, companies)
Attachments/        — Binary files (images, PDFs, audio, video) — gitignored, synced outside git
Workbench/          — Active working space for content being iterated (specs, drafts, collaborative docs)
Inbox/              — Capture pipeline target
Daily/              — Daily notes (ephemeral)
Templates/          — Note templates and .base files
```

### Directory Purpose

- **Notes**: Home for all personal notes — projects, areas, categories, system notes, research, frameworks, collections. The organizing question: "Did I create this, or does it relate to my world?"
- **References**: Things that exist outside your world — books, people, places, companies. The organizing question: "Am I cataloging something external?"
- **Attachments**: Flat folder for non-markdown files (PDFs, images, audio, etc.). Wrapper notes live in `Notes/` or `References/` and reference these files via embeds. Gitignored — synced outside git by your vault's sync method.
- **Workbench**: Active working space for content being iterated — specs, drafts, collaborative documents. Lighter frontmatter than permanent notes (`status` + `created` required; `categories` not required). Content graduates to `Notes/` or `References/` when ready. See `workbench` rule.
- **Inbox**: Quick capture target. Notes here should be brief. During reviews, process into `Notes/` or `References/` (or delete).
- **Daily**: Daily notes created by Obsidian's Daily Notes plugin. Ephemeral scratch capture — processed during reviews, no backlinks needed.
- **Templates**: Note templates and Bases (.base) files for consistent note creation and navigation.

## Note Conventions

### Frontmatter

All notes should include YAML frontmatter:

```yaml
---
categories: ["[[CategoryName]]"]   # What kind of note — wikilinks to category notes (e.g., Projects, Research, Books)
status: active | someday | waiting | completed
areas: ["[[AreaName]]"]            # Whose responsibility — wikilinks to area notes (e.g., Work, Home, Personal)
tags: []
created: YYYY-MM-DD
---
```

- `categories` and `areas` are lists of wikilinks — notes can belong to multiple
- `status` describes the state of the work. No separate "archived" status — completed notes stay in `Notes/`, filtered from active Bases views
- Additional template-specific properties (e.g., `people`, `author`, `source-platform`) are defined in `[[Note Schemas]]`

### Linking

- Always use Obsidian wikilinks: `[[Note Name]]`
- **Every new note must link to relevant existing notes.** This is critical for discovery and retrieval.
- When creating a note, search the vault for related content and add links bidirectionally where meaningful.
- Verify the note's `categories` and `areas` properties ensure it appears in the correct Bases views.

### Naming

- Use descriptive, human-readable names (not date-codes or IDs)
- Project notes: descriptive outcome-oriented names
- Category notes: simple singular or plural noun matching the category (e.g., `Projects`, `Books`, `Research`)
- Keep names searchable — optimize for Claude's ability to find relevant notes via `obsidian search`, Glob, or Grep

### Note Types

- **Project notes** (`Notes/`): `categories: ["[[Projects]]"]`. Longer and structured — goal, context, action menu (checkboxes), completed section, links to resources and reference material.
- **Pool notes** (`Notes/`): `[[Action Pool]]` for standalone non-project actions, `[[Someday Pool]]` for standalone someday ideas. Living documents with Actions/Ideas, Waiting, and Completed sections.
- **Routine notes** (`Notes/`): Canonical numbered step lists (not checkboxes). Tagged `routine`. Claude reads during relevant sessions and guides conversationally.
- **Area notes** (`Notes/`): Living documents for ongoing life areas with embedded Bases views. Updated as circumstances change.
- **Category notes** (`Notes/`): Navigation hubs tagged `categories` with embedded Base views. One per category (e.g., `Projects.md`, `Books.md`).
- **Reference notes** (`References/`): External entities — books, people, places, companies. Categorized via `categories` (e.g., `["[[Books]]"]`, `["[[People]]"]`).
- **Session notes** (`Notes/`): Records of facilitated sessions (coaching, meditation, workshops, etc.). Created via `/create-from-template`.
- **Wrapper notes**: Markdown companion for a non-markdown file in `Attachments/`. Contains frontmatter (including `source` property), an embed (`![[filename]]`), and a `## Summary` section Claude fills during inbox processing. Lives in `Notes/` or `References/` depending on origin.
