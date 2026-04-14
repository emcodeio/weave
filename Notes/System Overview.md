---
categories: ["[[Guides]]"]
status: active
areas: ["[[Self-Management]]"]
tags: [guide]
created: 2026-04-11
---

# System Overview

Weave organizes your work through three operating levels, a 7-folder vault structure, and a rhythm of review sessions. Claude detects which level is needed and adapts its behavior accordingly.

---

## Three Operating Levels

### Architect — "Am I redesigning the system?"

Structural changes to the productivity system itself. Modifying rules, skills, hooks, templates, or CLAUDE.md.

**Key skills:** `/design-skill`, `/design-agent`, `/create-template`, `/system-review`

### Orchestrate — "Am I managing what gets done?"

Task operations. Processing inboxes, advancing projects, running reviews, surfacing context and options.

**Key skills:** `/start-workday`, `/start-work-week`, `/start-personal-day`, `/end-workday`, `/end-personal-day`, `/end-weekend`, `/deep-review`, `/process-inbox`, `/create-project`, `/advance-project`, `/complete-project`

### Partner — "Am I working on a task with the user?"

Collaborative execution. Research, writing, drafting, exploration. Claude brings vault context and handles structure while you lead direction.

**Key skills:** `/research-topic`, `/draft-content`, `/open-workbench`, `/integrate-workbench`, `/ingest-written-content`, `/process-transcript`

---

## Vault Structure

Seven folders, organized by purpose:

| Folder | Purpose |
|--------|---------|
| `Notes/` | Everything you created or about your world — projects, areas, categories, system notes, research, frameworks |
| `References/` | External entities — books, people, places, companies |
| `Attachments/` | Binary files (images, PDFs, audio) — gitignored, synced separately |
| `Workbench/` | Active working space for content being iterated — specs, drafts, collaborative docs |
| `Inbox/` | Capture target — items processed during reviews |
| `Daily/` | Daily notes — ephemeral dashboard + journal |
| `Templates/` | Note templates and Bases (.base) views |

Notes are organized by **properties**, not folder hierarchy:
- **`categories`** — What kind of note (Projects, Research, Books, etc.)
- **`areas`** — Whose responsibility (Work, Home, Personal, Health, etc.)
- **`status`** — Current state (active, someday, waiting, completed)

Bases views in `Templates/Bases/` filter notes by these properties, creating dynamic dashboards.

---

## Review Rhythm

Seven review sessions, each a separate skill:

| Session | Skill | When | Duration | Character |
|---------|-------|------|----------|-----------|
| Workday startup | `/start-workday` | Tue-Fri morning | ~10 min | Calendar, inbox overview, action menu. Work-biased. |
| Work week startup | `/start-work-week` | Monday morning | ~15 min | Weekend catch-up + week planning + daily startup. |
| Personal day startup | `/start-personal-day` | Weekends, vacation | ~5 min | Relaxed. Only critical items. Leisure-weighted. |
| End workday | `/end-workday` | Mon-Fri evening | ~5-10 min | Capture accomplishments, advance projects, closure. |
| End personal day | `/end-personal-day` | Weekend/vacation evening | ~5-10 min | Capture accomplishments, gentle reflection. |
| Deep review | `/deep-review` | Usually Friday | ~30 min | Full processing: inboxes to zero, audit all projects, get creative. |
| End weekend | `/end-weekend` | Sunday evening | ~5 min | Gentle appreciation. No processing. |

**Inbox processing:** Daily startups give counts only. Full inbox-to-zero processing happens exclusively during `/deep-review`.

---

## The Daily Note

A hybrid dashboard + journal created during reviews. Two zones:

**Dashboard zone** (populated by Claude during startup):
- `## Today's Options` — Curated action checkboxes, grouped by area
- `## Routines` — Day-specific recurring items
- `## Upcoming` — Two-month horizon of critical items
- `## Active Projects` — Embedded Base view

**Journal zone** (your space):
- `## Morning State` — How you're feeling (captured during startup check-in)
- `## Intentions` — Qualitative priorities, not tasks
- `## Log` — Running notes throughout the day
- `## Done Today` — Accomplishments
- `## Reflection` — Evening thoughts

Monday notes also get `## Week Ahead`. Claude writes `## Observations` in yesterday's note during each morning startup — 2-3 sentences noting patterns.

---

## MCP Integrations

| Integration | Purpose | Required? |
|-------------|---------|-----------|
| **QMD** | Local semantic search — finds notes by meaning, not just keywords | Yes |
| **Apple Calendar** | Scheduling context during reviews | Recommended (macOS) |
| **Apple Reminders** | Hard-deadline alerts only (not task management) | Optional (macOS) |
| **Apple Mail** | Read/search email during reviews, draft replies | Optional (macOS) |
| **Drafts** | Quick text capture from anywhere | Optional (macOS) |

See [[Setting Up Integrations]] for setup details.

---

## Proactive Linking

Every note stays connected through a linking checklist that Claude runs automatically:

1. **Frontmatter** — `categories`, `areas`, `status`, `tags`, `created` set
2. **Area verification** — Area notes exist for all referenced areas
3. **Project links** — Bidirectional links between notes and related projects
4. **Related notes** — Vault search for conceptually related content
5. **Category note check** — Category notes exist with Base views
6. **No orphans** — Every note reachable from at least one Base view

Inbox captures and Workbench notes are exempt until they reach their permanent location.

---

## Philosophy

Weave is built on David Chapman's meta-rationality — using formal systems (categories, routines, reviews) while recognizing that reality is always more complex than any system can capture. The system holds structure lightly:

- **Action menus, not queues** — Projects contain unordered options. You pick based on energy, context, and interest.
- **Enjoyable usefulness** — The orienting question: "What could you do that would be useful and enjoyable?"
- **Friction detection** — Actions deferred across multiple reviews are a signal, not a failure.

For the full framework, see [[Weave - Chapman Framework]] and [[Weave - System Design Notes]].

---

## Related Notes

- [[Getting Started]] — First three skills to try
- [[Your First Review]] — Annotated `/start-workday` walkthrough
- [[Customizing Your System]] — Making Weave yours
- [[Setting Up Integrations]] — Per-integration setup
- [[Weave - Chapman Framework]] — Philosophical foundation
- [[Weave - System Design Notes]] — Concept-to-implementation mapping
- [[System Components by Role]] — Full inventory of skills, agents, rules, and hooks
- [[Note Schemas]] — Frontmatter reference
