---
name: ingest-written-content
description: "Analyze external written content (articles, Substacks, blog posts, essays) and integrate into the vault's knowledge network. Creates richly linked article notes, concept notes, and framework notes. Use when the user says 'ingest article', 'process article', 'add this article', 'ingest substack', 'process blog post', or 'ingest essay'."
argument-hint: "[URL, note name, or file path]"
context: fork
agent: researcher
---

# Ingest Written Content: $ARGUMENTS

## Dynamic Context

### Existing article notes
!`obsidian search query="categories: Articles" vault="{{VAULT_NAME}}" limit=20 2>/dev/null || echo "(Could not search articles)"`

---

## Your task

Analyze the content at **$ARGUMENTS**. Create an article note plus any warranted concept or framework notes. Present an integration plan before making any vault changes.

## Step 1: Acquire the content

Parse `$ARGUMENTS` to determine input type and acquire the content:

**URL** (starts with `http://` or `https://`):
1. Run `defuddle parse "$ARGUMENTS" --md` to extract clean markdown content
2. Run `defuddle parse "$ARGUMENTS" -p title` and `defuddle parse "$ARGUMENTS" -p domain` for metadata
3. If defuddle fails, fall back to `WebFetch`

**Vault note** (no URL prefix):
1. `obsidian read file="$ARGUMENTS" vault="{{VAULT_NAME}}"`
2. If not found: `obsidian read path="$ARGUMENTS" vault="{{VAULT_NAME}}"`
3. If still not found: `obsidian search query="$ARGUMENTS" vault="{{VAULT_NAME}}"`

**File path** (contains `/` but not `http`):
1. Read the file directly with the Read tool

Extract metadata from the content: **title**, **author**, **source URL** (if applicable), and **source-type**. Infer source-type from context:
- Substack URLs or content -> `substack`
- Medium URLs -> `article`
- Personal blog domains -> `blog-post`
- Substack Notes -> `substack-note`
- Default -> `article`

## Step 2: Analyze content

Read the full content and extract everything with potential integration value:

**1. Core concepts** — key ideas, frameworks, mental models presented
- What's novel vs. what's already in the vault?
- How does each concept connect to existing vault knowledge?

**2. Practical insights** — actionable takeaways, techniques, methods
- Whether they merit standalone notes or enrich existing ones

**3. Frameworks** — structured models for thinking about a topic
- Whether they extend or complement existing vault frameworks

**4. Author context** — who wrote this and why it matters
- Author's perspective, credentials, body of work

**5. Cross-references** — connections to existing vault notes
- Use `mcp__qmd__query` with `vec` sub-queries to find semantic connections
- Check for existing concept notes that this content extends

**6. Developmental observations** — how this content relates to the user's current projects or interests

Not every category will yield results. Flag empty categories without making it feel like a failure.

## Step 3: Present integration plan

Structure the plan with checkbox items for user approval:

```
## Integration Plan: [Article Title]

### Context
Author: [name] | Source: [URL] | Type: [source-type]
Relevance: [1-2 sentence summary of why this matters]

### Article Note
- [ ] **[Title]** -> References/ | categories: [[Articles]] | areas: [appropriate] | author: "[name]" | source-url: "[url]" | source-type: "[type]"

### Concept Notes (X items)
- [ ] **[Concept]** -> Notes/ | categories: [[Evergreen]] | [New or update [[existing note]]]
  [Brief description of the concept and its relevance]

### Framework Updates (X items)
- [ ] **[Framework]** -> Update [[existing note]] or new note in Notes/

### Cross-Links (X items)
- [ ] **[[Note A]]** <-> **[[Note B]]** | [Rationale for connection]

### Author Note
- [ ] **[Author name]** -> References/ | categories: [[People]] | [New or update existing]
```

**Pause here.** Ask the user which items to execute, modify, or skip. Wait for their input before proceeding.

## Step 4: Execute approved changes

For each approved item:
- **Article note**: Create in `References/` with full Article template frontmatter (`categories: ["[[Articles]]"]`, `author`, `source-url`, `source-type`, `areas`, `tags`, `created`). Fill Summary, Key Concepts, Quotes, and Related Notes sections.
- **Concept notes**: Create in `Notes/` with `categories: ["[[Evergreen]]"]`. Minimum 3 outgoing wikilinks.
- **Author note**: Create in `References/` with `categories: ["[[People]]"]` — check for existing author note first to avoid duplicates.
- **Cross-links**: Add bidirectional wikilinks between connected notes.

Follow the proactive linking checklist throughout: frontmatter, areas, project links, related notes, category verification.

## Step 5: Commit

Commit all changes:
```bash
cd "{{VAULT_PATH}}"
git add <specific files>
git commit -m "Ingest article: [Article Title]"
git push
```

## Quality Standards

- **Plan first, execute on approval** — never modify vault notes until the user confirms
- **Preserve author's original language** for key formulations — paraphrase context, quote precision
- **Source attribution**: Always set `author`, `source-url`, `source-type` in article frontmatter
- **Linking density**: Minimum 3 outgoing wikilinks per created note (excluding area/category)
- **Deduplicate against vault** — check if concepts already exist before proposing new notes. Use QMD to search semantically.
- **Respect nebulosity** — when content is ambiguous, flag it for user decision

## Output

Return to the main conversation:
1. **Analysis summary** — Key concepts identified, relevance assessment
2. **Created/modified notes** — Paths to all vault changes
3. **Integration report** — New vs. existing concepts linked, author note status, cross-references established
4. **Suggestions** — Further reading, related vault topics to explore
