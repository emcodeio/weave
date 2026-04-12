---
name: create-template
description: "Design and create a new template for the vault template library. Creates the template file, optional .base file, optional category note, and updates types.json and Note Schemas. Use when the user says 'new template', 'design a template', 'add a template for', or 'I need a template type for'."
argument-hint: "[template purpose and note type]"
context: fork
agent: system-architect
---

# Create Template

Design and create a new vault template for "$ARGUMENTS".

## Context

This skill creates a new template type in the vault's composable template library. The library was designed during the [[Vault Structure Optimized]] project. Design philosophy and composability rules are documented in [[Vault Reorganization - Template Library Design]] (completed research); property conventions in [[Vault Reorganization - Property Architecture]] (completed research). For the current authoritative schema, see [[Note Schemas]].

Every template type can have up to three components (the "Trinity"):
1. **Template file** in `Templates/` — defines frontmatter schema and body sections
2. **.base file** — defines Bases views for querying and displaying notes of this type
3. **Category note** — embeds the .base file as a browsable navigation hub

## Steps

### 1. Capture intent

Gather from the user:
- **What kind of notes will this template produce?** — what's the use case?
- **What properties are needed?** — suggest universal properties (created, status, areas, categories, tags) plus type-specific ones
- **What body sections?** — what structure should notes of this type follow?
- **Does it need a Bases view?** — most types do, but some (like Evergreen) are too freeform
- **Does it compose with existing templates?** — would notes of this type also belong to another category?

### 2. Research existing patterns

Before designing, read these files for conventions and context:
- [[Vault Reorganization - Template Library Design]] (completed research) — template inventory, composability rules, design philosophy
- [[Vault Reorganization - Property Architecture]] (completed research) — property naming conventions, types.json structure
- [[Note Schemas]] — current schema documentation
- Existing templates in `Templates/` — for structural patterns
- `.obsidian/types.json` — current property type registry

Check for conflicts:
- Does a similar template already exist?
- Do proposed property names conflict with existing properties?
- Does the `categories` value conflict with existing categories?

### 3. Design the template

Present the design to the user for approval before creating anything:

**Template design document:**
- Proposed template name
- `categories` value (plural, wikilink)
- Target directory for notes of this type
- Full frontmatter schema (YAML block)
- Body section headings and placeholder content
- Composability notes (which other templates it layers with)
- New properties introduced (if any) with proposed types
- Whether a .base file and category note are needed

**Wait for user approval before proceeding.**

### 4. Create the template file

Create `Templates/Template - {Type}.md`:

```bash
obsidian create path="Templates/Template - {Type}.md" vault="{{VAULT_NAME}}" silent content="..."
```

The template file contains:
- Full frontmatter with all properties for this type (universal + type-specific)
- `{{date}}` for the `created` field
- Body section headings matching the approved design
- No content in sections — just headings and brief placeholders

### 5. Create .base file (if needed)

If the template type benefits from a Bases view, create the .base file.

Use the obsidian-bases skill patterns. The .base file should:
- Filter by `categories.contains(link("TypeName"))`
- Exclude template files: `!file.name.contains("Template")`
- Define a default table view with relevant properties
- Sort by `created` DESC (or a more appropriate default)
- Include contextual views if the type has relational properties (e.g., `#Person` view filtered by `people.contains(this)`)

Place the .base file alongside templates: `Templates/{TypeName}.base` (or wherever the vault convention settles — check current .base file locations).

### 6. Create category note (if needed)

Create a category note — the navigation hub that embeds the .base file:

```bash
obsidian create path="Notes/{TypeName}.md" vault="{{VAULT_NAME}}" silent content="---\ntags:\n  - categories\ncreated: YYYY-MM-DD\n---\n\n# {Type Name}\n\n[one-line description]\n\n![[{TypeName}.base]]"
```

### 7. Update types.json

Read `.obsidian/types.json` and add any new property names with their types:

- Default to `multitext` for anything that could have multiple values
- Use `date` for date properties
- Use `text` for inherently single-value properties
- Use `number` for numeric properties

### 8. Update documentation

**Note Schemas** (`[[Note Schemas]]`):
- Add a new extension section documenting the template's properties

**Template Library Design** (`[[Vault Reorganization - Template Library Design]]`):
- Add the new template to the appropriate tier (this is a completed research note — only update if the new template establishes a significant pattern)

### 9. Commit

```bash
cd "{{VAULT_PATH}}"
git add "Templates/Template - {Type}.md" [.base file if created] [category note if created] ".obsidian/types.json" [Note Schemas path]
git commit -m "Add {Type} template to template library"
git push
```

### 10. Confirm

Tell the user:
- What was created (template file, .base file, category note)
- New properties introduced and their types
- How to create notes of this type: `/create-from-template {type} {name}`
- Composability notes — what other templates it layers with
