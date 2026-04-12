---
categories: ["[[Guides]]"]
status: active
areas: ["[[Self-Management]]"]
tags: [guide]
created: 2026-04-11
---

# Your First Review

This is an annotated walkthrough of what happens when you run `/start-workday`. The whole process takes about 10 minutes and results in a daily note that serves as your dashboard for the day.

---

## Before You Begin

- **Obsidian is open** with your vault loaded
- **Claude Code is running** in the vault directory (`claude` in terminal)
- **Calendar is populated** (if you're using Apple Calendar integration)

If this is Monday, use `/start-work-week` instead — it includes everything below plus a weekend catch-up and week-ahead planning.

---

## Phase 1: Ground

The first phase captures your current state before any system data enters the conversation.

### Daily note creation

Claude reads (or creates) today's daily note from the template. You'll see a structured note with empty sections waiting to be filled.

### Morning check-in

Claude asks three questions:

1. *"How are you feeling right now?"*
2. *"What feels most alive for you right now?"*
3. *"What would make today feel good?"*

Answer honestly and briefly. These go to `## Morning State` in your daily note. Claude uses them as loose context for tone and suggestions — they don't auto-drive what ends up on your plate.

### Calendar scan

Claude reads today's calendar events and summarizes obligations and open time blocks. It also scans the next 60 days for the upcoming horizon overview.

### Day-specific routines

Items from [[Day-Specific Routines]] for today's day of the week are surfaced. These become checkboxes in your daily note later.

---

## Phase 2: Orient

The second phase builds full awareness of everything going on. This is read-only — no decisions yet.

### Inbox overview

Claude counts items across all inboxes:
- Drafts inbox items
- Obsidian `Inbox/` notes
- Unread emails
- Workbench items

Just counts — no processing. Full inbox processing happens during `/deep-review`.

### Full project landscape

Claude reads every active project, the [[Action Pool]], and approaching deadlines. It presents a dashboard grouped by area:

- Project name and area
- Open action count
- Any waiting or blocked items
- Approaching deadlines
- Last notable activity

Items from yesterday's `## Today's Options` that weren't completed are noted alongside their parent projects.

This phase ends with: **"That's the full landscape. What stands out to you?"**

---

## Phase 3: Choose

The third phase is where you make decisions. Claude suggests; you choose.

### Action menu

Claude presents 5-8 suggested actions drawn from the landscape, weighted by:

- **Usefulness** — What would actually move things forward?
- **Enjoyability** — What would feel good to work on?
- **Calendar** — What fits the time you have?
- **Energy** — What matches how you're feeling?

This is a discussion menu, not a final list. Claude ends with something like: **"These are some options that stand out. What would you like on today's plate? Anything to add, drop, or swap?"**

### Your turn

You pick, adjust, discuss. Add things Claude didn't suggest. Drop things that don't feel right. Rearrange priorities. Claude doesn't decide — you do.

---

## Phase 4: Commit

The final phase writes your decisions to the daily note.

### Dashboard sections

Claude populates four sections in your daily note:

- **`## Today's Options`** — Your chosen actions as checkboxes, grouped by area
- **`## Routines`** — Today's recurring items as checkboxes
- **`## Upcoming`** — Two-month horizon of critical items (deadlines, events, milestones)
- **`## Intentions`** — Your qualitative priorities for the day

### Quick inbox relevance pass

Based on your chosen work, Claude quickly scans inboxes for anything immediately relevant. Only relevant items get processed — everything else waits for `/deep-review`.

### Yesterday's observations

Claude writes 2-3 observational sentences to yesterday's daily note — patterns noticed, energy trends, friction signals. This builds a record of how your days actually go.

---

## What Just Happened

Your daily note is now a working dashboard:

- **Top half** — What you're doing today (options, routines, upcoming)
- **Bottom half** — How you're experiencing it (morning state, intentions, log, reflection)

Throughout the day, check things off in `## Today's Options`, jot notes in `## Log`, and capture accomplishments in `## Done Today`.

---

## Closing the Loop

Run `/end-workday` in the evening to:
- Capture what you accomplished
- Advance projects with completed actions
- Write a brief reflection
- Get psychological closure with "Good enough for today."

---

## The Other Reviews

| Session | When | What it does |
|---------|------|-------------|
| `/start-work-week` | Monday morning | Weekend catch-up + week planning + everything above |
| `/start-personal-day` | Weekends, vacation | Relaxed version — only critical items, leisure-weighted |
| `/end-personal-day` | Weekend evenings | Gentle accomplishment capture and reflection |
| `/deep-review` | Weekly (usually Friday) | Full processing — inboxes to zero, audit all projects, creative thinking |
| `/end-weekend` | Sunday evening | Brief appreciation, no processing |

---

## Related Notes

- [[Getting Started]] — Overview and first three skills
- [[System Overview]] — Full architecture and component map
- [[Day-Specific Routines]] — Recurring items by day of week
- [[Action Pool]] — Standalone actions outside projects
