---
name: draft-content
description: "Draft written content: notes, guides, summaries, reports, plans, or structured writing. Gathers vault context, outlines, drafts, and places the result in the vault. Use when the user says 'draft', 'write', 'create a note about', 'help me write', or 'put together a document'."
argument-hint: "[what to draft and any specific requirements]"
context: fork
agent: content-drafter
---

# Draft: $ARGUMENTS

## Related vault content

!`obsidian search query="$ARGUMENTS" vault="{{VAULT_NAME}}" limit=5 2>/dev/null || echo "(Could not search vault — Obsidian may not be running. Use Grep/Glob to search files directly.)"`

## Your task

Draft content for: **$ARGUMENTS**

Follow your drafting workflow:

1. **Gather context** — Read the related vault notes found above. Use `mcp__qmd__query` to find semantically related vault content beyond keyword matches (see the `qmd` rule for query construction patterns). Use WebSearch/WebFetch if external context would improve the draft.

2. **Outline** — Before writing, determine:
   - What type of content is this? (note, guide, report, plan, summary)
   - What's the right directory? (`Notes/` or `References/`)
   - What tone and format fit? (check your memory for the user's preferences)
   - What sections are needed?

3. **Draft** — Write the content:
   - Match the user's voice (consult your memory for style patterns)
   - Use clear, structured headings
   - Weave in wikilinks `[[Note Name]]` to connect to existing vault knowledge
   - Be substantive — say what needs saying, skip the filler

4. **Place in vault** — Create the note using Obsidian CLI with:
   - Full frontmatter (categories, areas, status, tags, created)
   - Descriptive, searchable name
   - Correct directory for the content type

5. **Link it** — Verify categories and areas properties place the note in the correct Bases views. Connect to related existing notes.

6. **Commit** — Commit the new note and any modified files to git.

## Quality standards

- Structure with clear headings — scannable at a glance
- Include wikilinks throughout to connect ideas to vault knowledge
- Match the user's voice (if memory has style notes, follow them)
- Concise but complete — no padding, no missing substance
- Frontmatter and linking must follow vault conventions

## Output

Return:
- **What was created** — Title and brief description
- **Where it lives** — Vault path
- **Key decisions** — Choices made about scope, structure, tone
- **Linked notes** — Existing notes that were connected
- **Refinement suggestions** — Areas the user might want to adjust
