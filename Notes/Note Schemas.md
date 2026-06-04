---
status: active
areas: ["[[Self-Management]]"]
tags: [self-management]
created: 2026-02-27
---

# Note Schemas

Documents the frontmatter schemas used across the vault. Standard fields apply to all notes; extensions add fields for specific categories.

## Standard Frontmatter

All notes include these fields:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `categories` | list of wikilinks | Yes | What kind of note — links to category notes (e.g., `["[[Projects]]"]`, `["[[Research]]"]`) |
| `status` | string | Yes | `active`, `someday`, `waiting`, `completed` |
| `areas` | list of wikilinks | Yes | Whose responsibility — links to area notes (e.g., `["[[Work]]"]`, `["[[Home]]"]`) |
| `tags` | list | Yes | Tag list (see weave-principles rule) |
| `created` | date | Yes | Creation date (YYYY-MM-DD) |

**Notes:**
- `categories` and `areas` are lists of wikilinks — notes can belong to multiple
- Area notes themselves do NOT get `categories` or `areas` — they ARE the organizational structure
- Category notes only have `tags: [categories]` and `created`
- No separate "archived" status — completed notes stay in `Notes/`, filtered from active Bases views
- Pool notes, routine notes, and system notes (e.g., Note Schemas) are infrastructure — they have `areas` but no `categories`, similar to area and category notes

## Template Type Map

One row per template type — the per-type contract `/create-from-template` reads. Each type's template file is `Templates/Template - <Name>.md`; detailed field definitions for the richer types live in the extension sections below.

| Type | `categories` | Target | Type-specific properties |
|------|--------------|--------|--------------------------|
| article | `["[[Articles]]"]` | `References/` | `author` (string), `source-url`, `source-type` |
| book | `["[[Books]]"]` | `References/` | `author` (list), `topics`, `via` |
| category | (meta) | `Notes/` | `tags: [categories]` + `created` only |
| collection | `["[[Collections]]"]` | `Notes/` | `last`; `tags: [collection]` |
| daily | `["[[Journal]]"]` | `Daily/` | `energy`, `mood` (no `areas`) |
| essay | `["[[Essays]]"]` | `Notes/` | `topics` |
| evergreen | `["[[Evergreen]]"]` | `Notes/` | `topics` |
| framework | `["[[Frameworks]]"]` | `Notes/` | `topics`; `tags: [framework]` |
| guide | `["[[Guides]]"]` | `Notes/` | `related-project` |
| person | `["[[People]]"]` | `References/` | `org` (list) |
| project | `["[[Projects]]"]` | `Notes/` | standard only — create via `/create-project` |
| research | `["[[Research]]"]` | `Notes/` | `related-project`, `topics` |
| transcript | `["[[Transcripts]]"]` | `Notes/` | `people`, `course`, `organization`, `session`, `session-date`, `topics`; `tags: [transcript]` |
| wrapper | `["[[Attachments]]"]` | `Notes/` or `References/` | `source`, `related-project` |

**Common optional properties** used across several types: `topics` — topic-cluster membership (list); `related-project` — wikilink(s) to a parent project; `last` — timestamp set when a collection is used. Note the deliberate asymmetry: Book's `author` is a list (multi-author books), Article's is a string.

## Transcript Extension

Used for session transcripts (meetings, presentations, etc.). Category: `["[[Transcripts]]"]`

| Field | Type | Description |
|-------|------|-------------|
| `people` | list of wikilinks | Participants |
| `course` | string | Course or series name |
| `organization` | string | Organization or group |
| `session` | number | Session number within the series |
| `session-date` | date | Date of the session (YYYY-MM-DD) |
| `topics` | list | Concepts covered |

## Meeting Note Extension

Used for meeting notes and check-ins:

| Field | Type | Description |
|-------|------|-------------|
| `meeting-type` | string | Type of meeting (e.g., "check-in", "planning", "review") |
| `participants` | list | Names of participants |
| `meeting-date` | date | Date of the meeting (YYYY-MM-DD) |

## Wrapper Note Extension

Used for non-markdown files captured to the vault (PDFs, images, audio, etc.):

| Field | Type | Description |
|-------|------|-------------|
| `source-type` | string | File type category: `pdf`, `image`, `audio`, `video`, `document`, `other` |
| `source-file` | string | Wikilink to the attachment file in `Attachments/` |
| `source` | string | The attachment file (template-created wrappers) |
| `related-project` | list of wikilinks | Parent project, when the file supports one |

Wrappers arrive two ways: capture-pipeline wrappers (created by the capture macros, processed by `/process-inbox`) carry `source-type` + `source-file`; template-created wrappers (via `/create-from-template`) carry `source` + `related-project`.

## Daily Note Extension

Used for daily notes in `Daily/`:

| Field | Type | Description |
|-------|------|-------------|
| `energy` | string | Natural-language energy level (e.g., "steady", "foggy", "high") |
| `mood` | string | Natural-language mood (e.g., "calm", "anxious", "optimistic") |

Dashboard sections (filled by Claude during morning startup):
- `## Today's Options` — Curated action checkboxes (`- [ ] Action — [[Project]]`), collaboratively selected
- `## Routines` — Day-specific routine checkboxes (from Day-Specific Routines)
- `## Upcoming` — Two-month horizon overview: critical deadlines, travel, milestones, events (grouped by This Week & Next / This Month / Next Month)
- `## Active Projects` — Embedded `![[Projects.base#Active]]` (always live, no manual fill)

Journal sections:
- `## Morning State` — 2-3 sentences during morning startup
- `## Intentions` — Qualitative intention for the day (no task items — those live in Today's Options)
- `## Log` — Freeform throughout the day
- `## Done Today` — Completed actions (`- [x] Action — [[Project]] — YYYY-MM-DD`), filled during end-of-day and mid-day advance
- `## Reflection` — 2-4 sentences during shutdown

Dynamic sections (not in template, added by Claude):
- `## Week Ahead` — Monday only, inserted after Routines by `/start-work-week`
- `## Observations` — Written in previous day's note during next morning's startup

## Article Extension

Used for articles, blog posts, and other written content analyzed and integrated into the vault. Category: `["[[Articles]]"]`

| Field | Type | Description |
|-------|------|-------------|
| `author` | string | Author name |
| `source-url` | string | URL of original content |
| `source-type` | string | article, substack, substack-note, blog-post, book-chapter, essay-by-other |

Placement: `References/` — articles are external content regardless of integration depth. Concept notes extracted during ingestion go in `Notes/`.

## Conversation Extension

Used for exported LLM conversations (Claude, ChatGPT, Gemini, etc.) processed via `/process-llm-conversation`:

| Field | Type | Description |
|-------|------|-------------|
| `source-platform` | string | LLM platform: "Claude", "ChatGPT", "Gemini", etc. |
| `conversation-date` | date | Date of the conversation (YYYY-MM-DD) |
| `conversation-type` | string | Primary purpose: "research", "drafting", "problem-solving", "brainstorming", "learning", "building", "planning", "practice-session" |

## Workbench Extension

Used for notes in `Workbench/` — active working documents being iterated before graduation to a permanent location. Lighter than standard frontmatter.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `status` | string | Yes | `drafting`, `paused`, or `ready` |
| `created` | date | Yes | Creation date (YYYY-MM-DD) |
| `project` | wikilink | No | Parent project note (e.g., `"[[Module Function Spec Defined]]"`) |
| `areas` | list of wikilinks | No | Area context (optional until graduation) |
| `tags` | list | No | Free-form |

No `categories` — assigned at graduation. Folder location identifies the note as workbench content. See `workbench` rule.

## Links

- [[Self-Management]]
