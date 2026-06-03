---
name: create-from-template
description: "Create a new vault note from a template. Lists available templates, gathers required properties, creates the note with full frontmatter and sections, and handles proactive linking. Use when the user says 'new note', 'create a note', 'new transcript', 'new research note', 'new person note', 'new book note', or names any template type."
argument-hint: "[template-type] [note-name]"
---

# Create From Template

Create a new vault note of type "$ARGUMENTS" using the template library.

## Available Templates

| Template | Categories Value | Target Directory | Key Properties |
|----------|-----------------|-----------------|----------------|
| project | `[[Projects]]` | `Notes/` | status, areas |
| transcript | `[[Transcripts]]` | `Notes/` | people, date, topics |
| research | `[[Research]]` | `Notes/` | topics |
| framework | `[[Frameworks]]` | `Notes/` | topics |
| book | `[[Books]]` | `References/` | author, topics, via |
| collection | `[[Collections]]` | `Notes/` | last |
| wrapper | `[[Attachments]]` | `Notes/` or `References/` | source |
| person | `[[People]]` | `References/` | org |
| essay | `[[Essays]]` | `Notes/` | topics |
| guide | `[[Guides]]` | `Notes/` | — |
| evergreen | `[[Evergreen]]` | `Notes/` | topics |
| daily | `[[Journal]]` | `Daily/` | energy, mood |
| category | (meta) | `Notes/` | tags: [categories] |

Three pieces work together per note type: the **template file** (in `Templates/`), a **`.base`** (the saved Obsidian view that lists notes of that type), and a **category note** (the hub that embeds that base). `/create-template` defines this "Trinity" in full; this skill consumes it — the terms recur in Steps 2b and 4.

Routing exceptions (project / daily / category) are handled in Step 1.

## Steps

### 1. Identify template and note name

Parse `$ARGUMENTS` for template type and note name:
- If both provided: proceed to Step 2
- If only template type: ask for a note name
- If only note name: infer template type from context, or list available templates and ask
- If neither: list available templates and ask

**Special cases:**
- `project` → delegate to `/create-project` skill (it has specialized logic for deadlines, Apple Reminders, etc.)
- `daily` → use `obsidian daily:read vault="{{VAULT_NAME}}"` (creates from daily note template if it doesn't exist)
- `category` → see Step 2b

### 2. Gather required properties

Ask the user for properties not already known from context:

**Universal (always gather):**
- `areas` — which area(s) of responsibility? Suggest based on context.
- `status` — active or someday? (default: active)

**Type-specific (gather based on template):**
- Transcript: `people` (participants), `date` (event date), `topics` (concepts covered)
- Research: `topics`
- Framework: `topics`
- Book: `author`, `via` (how discovered)
- Collection: (no additional required — `last` set when collection is used)
- Wrapper: `source` (the attachment file)
- Person: `org` (organization affiliation)
- Essay: `topics`
- Guide: (no additional required)
- Evergreen: `topics`

Skip gathering for properties the user has already mentioned in context. Suggest values where Claude can infer them.

### 2b. Category Note (special workflow)

Category notes are minimal and follow a fixed pattern:

1. Ask for category name (e.g., "Transcripts", "Books")
2. Create the category note:
   ```bash
   obsidian create path="Notes/CategoryName.md" vault="{{VAULT_NAME}}" silent content="---\ntags:\n  - categories\ncreated: YYYY-MM-DD\n---\n\n# Category Name\n\n[one-line description]\n\n![[CategoryName.base]]"
   ```
3. Check if the corresponding `.base` file exists. If not, create it using the obsidian-bases skill patterns:
   - Filter: `categories.contains(link("CategoryName"))`
   - Default table view with relevant properties
   - Sort by `created` DESC
4. Commit and done — category notes don't need additional proactive linking.

### 3. Create the note

Read [[Note Schemas]] for the current frontmatter schema. Construct the note content.

Use Obsidian CLI to create:
```bash
obsidian create path="[directory]/[note-name].md" vault="{{VAULT_NAME}}" silent content="..."
```

**Content must include:**
- Full frontmatter with all universal properties + type-specific properties
- `areas` values as wikilinks: `areas: ["[[Work]]"]`
- `categories` values as wikilinks: `categories: ["[[Transcripts]]"]`
- All body sections from the template with placeholder content where appropriate
- A `## Related Notes` section at the bottom

**Remember:**
- Always specify `path=` for correct folder placement
- Use `silent` to prevent Obsidian from opening the note
- Pass content via `content="..."` parameter, never stdin
- Use `\n` for newlines and `\t` for tabs

### 4. Proactive linking

Follow the linking checklist from the operating-principles rule:

1. **Areas link** — the `areas` property handles this; verify the area note exists
2. **Related notes** — search the vault using QMD (`mcp__qmd__query`) for semantically related content. Add wikilinks to the `## Related Notes` section and to the body where meaningful.
3. **Category note check** — verify the category note for this template type exists. If not, offer to create it (Step 2b workflow).

### 5. Commit

```bash
cd "{{VAULT_PATH}}"
git add "[new note path]" "[any updated files]"
git commit -m "Create [template-type] note: [note-name]"
git push
```

### 6. Confirm

Tell the user:
- What was created and where
- Key links established
- Any category notes or .base files created as part of the process
- Suggest next steps if applicable (e.g., "You might want to add some initial content to the Context section")
