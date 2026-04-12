---
name: research-topic
description: "Research a topic deeply. Searches the vault for existing knowledge, then the web, synthesizes findings into a resource note in Notes/. Use when the user says 'research', 'look into', 'find out about', 'what do we know about', or 'investigate'."
argument-hint: "[topic or question]"
context: fork
agent: researcher
---

# Research: $ARGUMENTS

## Existing vault knowledge

!`obsidian search query="$ARGUMENTS" vault="{{VAULT_NAME}}" limit=5 2>/dev/null || echo "(Could not search vault — Obsidian may not be running. Use Grep/Glob to search files directly.)"`

## Your task

Research **$ARGUMENTS** thoroughly following your research workflow:

1. **Vault first** — Read any existing notes found above. Also use `mcp__qmd__query` to find semantically related content beyond keyword matches (see the `qmd` rule for query construction patterns). Understand what we already know before going external.

2. **Web research** — Use WebSearch to find current, authoritative information. Search from multiple angles:
   - Core facts and definitions
   - Recent developments
   - Expert perspectives
   - Practical applications
   Use WebFetch to deep-read the 2-3 most valuable sources.

3. **Synthesize** — Combine vault knowledge with new findings. Identify what's new, where sources agree/disagree, and what gaps remain.

4. **Create resource note** — Write a well-structured note in `Notes/` with:
   - Full frontmatter (categories: ["[[Research]]"], areas, status: active, tags, created)
   - Clear headings and sections
   - Source citations
   - Wikilinks to related vault notes throughout
   - Confidence levels where appropriate

5. **Link it** — Verify categories and areas properties place the note in the correct Bases views. Connect to related existing notes.

6. **Commit** — Commit the new note and any modified files to git.

## Quality standards

- Cite your sources — include URLs or clear references
- Distinguish established facts from opinions or speculation
- Note confidence levels (well-established vs. emerging vs. uncertain)
- Flag knowledge gaps that merit future research
- Be thorough but concise — depth where it matters, brevity where it doesn't

## Output

Return:
- **Key takeaways** (3-5 bullets)
- **Created note path** in the vault
- **Related notes** that were linked
- **Suggestions** for further exploration
