---
name: process-inbox
description: "Process Obsidian and Drafts inboxes using scan-classify-confirm-execute. Claude pre-classifies all items, groups by action type, presents a numbered summary for user confirmation. Use when: 'process inbox', 'clear inbox', 'let's process', or during reviews."
disable-model-invocation: true
---

# Process Inbox

Three-pass workflow: Claude scans and classifies everything, user confirms with minimal effort, Claude executes in batch.

## Routing Context

### Active projects
!`obsidian search query="categories: Projects status: active" vault="{{VAULT_NAME}}" limit=30 2>/dev/null || echo "(Could not scan projects)"`

### Area notes
!`obsidian search query="tags: area" vault="{{VAULT_NAME}}" limit=20 2>/dev/null || echo "(Could not scan areas)"`

---

## Pass 1: Scan & Classify

Read ALL items from both inboxes. Assign each a sequential number (flat across both sources).

### 1.1 Gather items

**Drafts inbox**: `mcp__drafts__drafts_inbox` — read all items.

**Obsidian inbox**: `obsidian search query="path:Inbox/" vault="{{VAULT_NAME}}"` — then read each item.

**Token management**: For files over 5000 lines, read only the first 50-100 lines plus frontmatter. Enough to classify — specialized skills handle full content later.

### 1.2 Auto-classify each item

Apply heuristics in order (first match wins):

| Signal | Type | Routing |
|--------|------|---------|
| File >50k chars + book metadata (`author` + `title` + `publisher`/`contributor`) | Book | References/ with `categories: ["[[Books]]"]`; flag `/ingest-book` to process chapter-by-chapter |
| `type: capture` + LLM conversation markers (role alternation, claude.ai/chatgpt links, `## Prompt:`/`## Response:`) | LLM conversation | Rename descriptively, Notes/, flag `/process-llm-conversation` |
| Work meeting transcript — colleagues, workstreams, standup/1:1/cross-team/client/design-review | Work transcript | Flag `/process-transcript` (auto-detects the work frame) |
| Other transcript / meeting recording — class, group discussion, teaching handout, or generic recording | Transcript | Flag `/process-transcript` (generic frame) |
| `tags: [clippings]` + full body (>500 chars after frontmatter) | Article (full content) | Flag `/ingest-written-content` |
| `tags: [clippings]` + minimal body OR body is a single URL | URL stub | Fetch & classify, or file as reference |
| Filename matches `Name (@handle)` + minimal body | Person stub | References/ as Person note |
| `source-file:` in frontmatter or `![[non-markdown]]` embed | Wrapper note | Read attachment, summarize, file |
| Confluence URL or work-related technical content | Work reference | Notes/ with `areas: [[Work]]` |
| Working draft or in-progress reference material (WIP indicators, partial content, mentions active workbench cluster or project with workbench items) | In-progress work | Workbench/ with `status: drafting`, link to parent project |
| Short note (<500 chars) + action language (imperative verbs, "need to", "todo") | Action item | Extract to project/Action Pool |
| None of the above | Needs context | Ask user |

For items where routing destination is ambiguous, use `mcp__qmd__query` with `vec` sub-query + `intent` "finding the right project or area to route this inbox item to."

### 1.3 Group and present summary

Group items by **action type** (what happens to them). Present ALL items in a single output.

**Output format:**

```
## Inbox Summary: X Drafts + Y Obsidian items

### Quick File (move + enrich frontmatter)
  1. [Obsidian] **Note Name** — brief description
     → Destination/ | areas: [[Area]] | categories: [[Category]]

### Specialized Processing (flag for dedicated skills)
  2. [Obsidian] **Note Name** (size, type)
     → `/skill-name` — brief rationale

### Fetch & Classify (URL-only, need content to route)
  3. [Obsidian] **Note Name** — what the URL appears to be
     → Fetch to decide: likely options

### Action Extraction (pull actions into projects/pools)
  4. [Drafts] **"Draft text preview"** — context
     → Extract to [[Project Name]] or [[Action Pool]]

### Delete (no lasting value)
  5. [Source] **Note Name** — why it has no value

### Needs Context (can't confidently classify)
  6. [Source] **Note Name** — what's unclear
     → Question for user

---
Anything to adjust? Reference by number. "Looks good" to proceed.
```

**Formatting rules:**
- Sequential numbers across all groups (not per-group)
- Source tagged: `[Drafts]` or `[Obsidian]`
- Bold filename for scanning
- One-line description with key metadata
- Arrow `→` for routing recommendation
- Omit empty groups

---

## Pass 2: User Review

This is the ONLY decision point. Wait for user input.

**Accepted response patterns:**
- `looks good` / `go` / `confirmed` — execute all as recommended
- `3 → delete` — override item 3's routing
- `7 → project X` — redirect to specific project
- `5 is a book I want → add to Wishlist` — add context that changes routing
- `skip 1, 4` — leave items in inbox for later (don't process this session)
- `tell me more about 6` — re-read item 6 and present more detail
- Any combination of the above

After receiving input:
1. Acknowledge overrides/context briefly
2. If the user asked for more detail on an item, provide it and wait for their decision
3. Otherwise proceed directly to execution — no further confirmation needed

---

## Pass 3: Execute

Process in this order (simplest first — maximizes value if interrupted):

### 3.1 Delete items
- Obsidian items: delete the inbox note
- Drafts items: `mcp__drafts__drafts_trash`

### 3.2 Quick-file items
For each item:
- Enrich frontmatter: `categories`, `areas`, `status`, `tags`, `created`
- Move to appropriate directory (Notes/ or References/)
- Proactive linking: related notes, category verification, backlinks
- **Person stubs**: Check References/ for existing person note — merge if found
- **Work docs**: Set `areas: ["[[Work]]"]` and appropriate categories

### 3.3 Fetch & classify URL stubs
For URL-only items confirmed for fetching:
- Use `defuddle parse "$URL" --md` to extract content
- Re-classify based on fetched content:
  - Full article worth ingesting → flag for `/ingest-written-content`
  - Product page, course announcement, simple reference → quick-file
  - No lasting value → delete (confirm with user)

### 3.4 Action extraction
For items containing action items:
- Extract action with GTD phrasing (starts with verb). Suggest energy/time hints: `~focused`, `~quick`, `~2h`, `~errand`
- Use QMD to find right project/area if not obvious
- Add as checkbox to target project's Actions section or `[[Action Pool]]`
- Offer Apple Reminder if there's a deadline
- File or delete the source inbox note

### 3.5 Wrapper notes
For wrapper notes (non-markdown file references):
- Read the attachment (PDFs up to 20 pages via Read tool; images are multimodal)
- Write a `## Summary` section into the wrapper note
- File wrapper to permanent location (Notes/ or References/)

### 3.5a Workbench routing
For items classified as in-progress work:
- Set lightweight frontmatter: `status: drafting`, `created`, `project` (if identifiable), `tags`
- Move to `Workbench/` (or appropriate subdirectory if a cluster exists)
- No proactive linking (workbench exemption applies)

### 3.6 Specialized processing items
These get moved out of Inbox/ but NOT deeply processed inline. Filing and deep processing are separate operations.

For each item:
- Add minimal frontmatter (`categories`, `areas`, `status: active`, `created`, `tags`)
- Rename if needed (e.g., cryptic filenames → descriptive titles based on content)
- Move to permanent location (Notes/ for transcripts/conversations, References/ for books/articles)
- **Do NOT invoke the specialized skill** — just note it in the summary

### 3.7 Drafts cleanup
For Drafts items routed to Obsidian:
- If item needs to become a vault note: run "Save in Obsidian Vault" Drafts action, then process the resulting Inbox/ note
- Archive all processed drafts: `mcp__drafts__drafts_archive`
- Trash discarded drafts: `mcp__drafts__drafts_trash`

---

## After Processing

Commit vault changes, then present summary:

```
## Processing Complete

### Executed
- X items quick-filed
- X URLs fetched and filed
- X actions extracted → [[destinations]]
- X items deleted
- X drafts archived

### Ready for Specialized Processing
- [[Note Name]] → `/skill-name`
- [[Note Name]] → `/skill-name`

### Skipped (still in inbox)
- Item X — reason

Inbox: N → M | Committed: "Process inbox: N items routed"
```

Omit empty sections. If specialized items exist, remind the user they can process them at leisure with the listed skill commands.
