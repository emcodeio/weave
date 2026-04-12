---
name: pdf-reader
description: "Read and extract content from PDF files using pymupdf4llm. Use when reading PDFs, processing PDF wrapper notes from inbox, summarizing slide decks, or extracting content from PDF attachments. Use instead of the Read tool for PDFs when you need structured text."
---

# PDF Reader

Extract structured markdown from PDF files using pymupdf4llm. Two approaches depending on content type.

## Primary: pymupdf4llm (structured markdown)

Best for text-heavy documents, articles, and slide decks where you need parseable content.

```bash
# Full document
~/.claude/skills/pdf-env/bin/python3 -c "import pymupdf4llm, sys; print(pymupdf4llm.to_markdown(sys.argv[1]))" "/path/to/file.pdf"

# Specific pages (0-based)
~/.claude/skills/pdf-env/bin/python3 -c "import pymupdf4llm, sys; print(pymupdf4llm.to_markdown(sys.argv[1], pages=[int(p) for p in sys.argv[2].split(',')]))" "/path/to/file.pdf" "0,1,2"
```

Output is clean markdown with headers detected by font size, tables preserved where possible, and text flow maintained.

## Fallback: Read tool multimodal (visual layout)

Best for PDFs where visual layout matters (diagrams, charts, infographics, heavily visual slide decks).

```
Read(file_path="/path/to/file.pdf", pages="1-5")
```

- Renders pages as images (multimodal reading) — preserves visual layout
- Requires poppler (`brew install poppler`)
- Max 20 pages per request
- Uses more tokens but captures what text extraction misses

## When to use which

| Content type | Best approach |
|-------------|---------------|
| Text-heavy documents | pymupdf4llm |
| Slide decks with text | pymupdf4llm first, Read fallback if diagrams lost |
| Visual/diagram-heavy | Read tool (multimodal) |
| Large PDFs (100+ pages) | pymupdf4llm with page ranges |

## Known limitations of pymupdf4llm

- Nested lists lose hierarchy
- Tables without borders may parse as plain text
- No slide-awareness (treats each page as a text page)
- Links can produce unexpected results (entire line becomes hyperlink)

## Wrapper note processing

When processing PDF wrapper notes from `Inbox/`:
1. Extract content using pymupdf4llm
2. Write a concise summary into the wrapper note's `## Summary` section
3. Update frontmatter (categories, areas, tags)
4. Move wrapper note to its permanent location (`Notes/` or `References/`)
