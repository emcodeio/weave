---
name: ingest-book
description: "Process a book chapter-by-chapter into the vault's knowledge network. Creates a book MOC as a reading tracker, processes chapters into linked article and concept notes, and builds progressive synthesis across chapters; designed for incremental use across sessions. Use when the user says 'ingest book', 'process a chapter', 'process this book', or wants to work through a book."
argument-hint: "[book name, file path, inbox note name, or existing book MOC name]"
context: fork
agent: researcher
---

# Ingest Book: $ARGUMENTS

## Dynamic Context

### Existing article notes
!`obsidian search query="categories: Articles" vault="{{VAULT_NAME}}" limit=20 2>/dev/null || echo "(Could not search articles)"`

### Existing book MOCs and reference notes
!`obsidian search query="categories: Books" vault="{{VAULT_NAME}}" limit=20 2>/dev/null || echo "(Could not search books)"`

---

## Your task

Process book content at **$ARGUMENTS** into linked vault notes. Create or update a book MOC that serves as a reading tracker, then process chapter(s) into article notes with concept extraction. This skill is designed for **incremental use** — each invocation processes one or a few chapters, building up the book MOC over multiple sessions.

## Step 1: Identify the book and locate or create MOC

Parse `$ARGUMENTS` to determine whether this is a new book or a continuation:

**Search for existing book MOC first:**
1. `obsidian search query="$ARGUMENTS" vault="{{VAULT_NAME}}"` — look for an existing MOC
2. `mcp__qmd__query` with `searches=[{type:'lex', query:'$ARGUMENTS'}]`, `intent='finding book MOC or reading tracker'`
3. Check `References/` for an existing book reference note

**If existing MOC found** (continuation mode):
1. Read the MOC — identify which chapters are already processed (status column)
2. Determine the next unprocessed chapter(s)
3. Tell the user where we left off and suggest the next chapter to process
4. Proceed to Step 2 with the next chapter

**If new book** (first invocation):
1. Acquire the source content to identify chapter structure:
   - **PDF in Attachments/**: Extract the table of contents or first few pages using the `pdf-reader` skill's pymupdf4llm approach (page range covering front matter and TOC).
   - **Markdown file in Inbox/ or vault**: Read directly, identify chapter structure via headers
   - **Existing reference note in References/**: Read it for context (author, summary)
   - **If content cannot be located**: Ask the user for the file path or source

2. Identify all chapters — titles, and page ranges (for PDFs) or header boundaries (for markdown)

3. Check for an existing book reference note in `References/` — use it for author info and context

4. Create the book MOC in `Notes/` using `obsidian create`:
   ```
   categories: ["[[Books]]"]
   status: active
   areas: [appropriate area wikilinks]
   author: "[author name]"
   tags: []
   created: YYYY-MM-DD
   ```

   Sections:
   - `## Overview` — Brief description of the book, author, and why it's being processed
   - `## Chapters` — Table with columns: `#` | `Title` | `Article Note` | `Status` | `Key Themes`
     - Populate all chapter rows with titles; set Status to `—` (unprocessed) and Article Note to `—`
   - `## Key Concepts` — Empty initially; built incrementally as chapters are processed
   - `## Progressive Synthesis` — Empty initially; cross-chapter themes added over time
   - `## Related Notes` — Links to author note, existing vault connections, reference note if it exists

5. Present the MOC and chapter list to the user. Ask which chapter(s) to process first.

## Step 2: Extract chapter content

Acquire the full text for the target chapter:

- **PDF**: Use the `pdf-reader` skill's pymupdf4llm approach with the specific page range for this chapter.
- **Markdown**: Extract content between chapter headers
- **HTML artifacts** (common in EPUB conversions): Clean up HTML fragments during extraction — convert to clean markdown

If the chapter is very long, work through it systematically section by section. Do not skip content.

## Step 3: Analyze chapter content

Read the full chapter and extract everything with potential integration value:

**1. Core concepts** — key ideas, frameworks, mental models presented
- What's novel vs. what's already in the vault?
- How does each concept connect to existing vault knowledge?

**2. Practical insights** — actionable takeaways, techniques, methods
- Whether they merit standalone notes or enrich existing ones

**3. Frameworks** — structured models for thinking about a topic
- Whether they extend or complement existing vault frameworks

**4. Vocabulary / key terms** — the author's distinctive terminology
- Note where the author's terms differ from terms already used in the vault

**5. Author context** — who wrote this and why it matters
- Author's perspective, credentials, body of work

**6. Cross-references** — connections to existing vault notes
- Use `mcp__qmd__query` with `vec` sub-queries to find semantic connections
- Check for existing concept notes that this content extends

**7. Developmental observations** — how this content relates to the user's current projects or interests

Not every category will yield results. Flag empty categories without making it feel like a failure.

For each extracted concept:
1. Search via `mcp__qmd__query` before proposing a new note — the concept may already exist under a different name
2. **Check if a concept note was already created from a previous chapter of this book** — if so, plan to update that note rather than creating a duplicate

Be aware of **concept evolution across chapters** — the same term may deepen in meaning as the book progresses. Plan updates rather than duplicates.

## Step 4: Present integration plan for this chapter

Structure with checkbox items for user approval:

```
## Integration Plan: [Book Title] — Chapter [N]: [Chapter Title]

### Context
Book: [title] | Author: [name] | Chapter: [N] of [total]
Relevance: [1-2 sentence summary]

### Chapter Article Note
- [ ] **[Chapter Title]** -> References/ | categories: [[Articles]] | source-type: "book-chapter" | author: "[name]" | areas: [appropriate]

### Concept Notes (X items)
- [ ] **[Concept]** -> Notes/ | categories: [[Evergreen]] | [New / update existing / extends chapter N concept]
  [Brief description and relevance]

### Framework Updates (X items)
- [ ] **[Framework]** -> Update [[existing]] or new note

### Cross-Links (X items)
- [ ] **[[Note A]]** <-> **[[Note B]]** | [rationale]

### Author Note
- [ ] **[Author name]** -> References/ | categories: [[People]] | [New or update existing] (first chapter only)

### Book MOC Updates
- [ ] Update chapters table: mark chapter [N] processed, add key themes
- [ ] Update Key Concepts section with cross-chapter themes (if applicable)
- [ ] Update Progressive Synthesis (if cross-chapter patterns emerging)
```

**Pause here.** Ask the user which items to execute, modify, or skip. Wait for their input before proceeding.

## Step 5: Execute approved changes

For each approved item:

- **Chapter article note**: Create in `References/` with Article template frontmatter. Set `source-type: "book-chapter"`. Add `source-book` property linking to the book MOC. Link to previous/next chapter article notes when they exist. Fill Summary, Key Concepts, Quotes, and Related Notes sections.
- **Concept notes**: Create in `Notes/` with `categories: ["[[Evergreen]]"]`. If updating an existing concept note from a previous chapter, append the new material under a section referencing this chapter. Minimum 3 outgoing wikilinks.
- **Framework updates**: Extend an existing framework note or create a new one in `Notes/`.
- **Author note**: Create in `References/` with `categories: ["[[People]]"]` — only on first chapter. Check for existing author note first.
- **Cross-links**: Add bidirectional wikilinks between connected notes.
- **Book MOC**: Update the chapters table — set this chapter's Status to `processed`, fill Article Note with wikilink, add Key Themes. Update Key Concepts if cross-chapter concepts are emerging. Update Progressive Synthesis if patterns span multiple chapters.

Follow the proactive linking checklist: frontmatter, areas, project links, related notes, category verification.

## Step 6: Progressive synthesis

After executing changes:
1. Check for concepts that span multiple processed chapters — consolidate into single concept notes if not already done
2. Update the book MOC's Key Concepts section with cumulative cross-chapter themes
3. Update Progressive Synthesis with emerging patterns, threads, and connections to existing vault knowledge
4. Surface connections between this chapter and previously processed chapters

This section grows more valuable with each chapter processed.

## Step 7: Update memory and commit

Update your memory with: book progress (which chapters processed), concepts added to the concept map, cross-chapter patterns, author familiarity.

Commit all changes:
```bash
cd "{{VAULT_PATH}}"
git add <specific files>
git commit -m "Ingest book chapter: [Book Title] — Ch. [N]: [Chapter Title]"
git push
```

## Quality Standards

- **Plan first, execute on approval** — never modify vault notes until the user confirms
- **Preserve author's original language** for key formulations — paraphrase context, quote precision
- **Source attribution**: Always set `author`, `source-type: "book-chapter"`, and `source-book` in chapter article frontmatter
- **Linking density**: Minimum 3 outgoing wikilinks per created note (excluding area/category)
- **Deduplicate against vault** — check if concepts already exist before proposing new notes. Use QMD to search semantically.
- **Concept evolution**: Track how terms deepen across chapters — update existing concept notes rather than creating duplicates
- **Chapter-to-chapter links**: Each chapter article note links to previous/next chapters (when they exist) and to the book MOC
- **Respect nebulosity** — when content is ambiguous, flag it for user decision

## Output

Return to the main conversation:
1. **Book MOC status** — Created or updated; chapters processed vs. remaining
2. **Chapter analysis summary** — Key concepts identified, relevance assessment
3. **Created/modified notes** — Paths to all vault changes
4. **Progressive synthesis** — Cross-chapter themes emerging, concepts spanning chapters
5. **Next steps** — Which chapter to process next, any open questions
