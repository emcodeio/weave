---
name: start-workday
description: "Start the workday. Calendar check, inbox overview, day planning, action menu. Use when: 'start workday', 'morning review', 'let's start the day' on a work day (Tue-Fri). For Mondays, use /start-work-week instead."
disable-model-invocation: true
---

# Start Workday (Tue-Fri morning, ~10 min)

You are running the user's workday startup. Follow these steps in order, presenting findings conversationally. Present options — never mandates.

The startup has four phases: **Ground** (capture current state), **Orient** (see everything), **Choose** (collaboratively select), **Commit** (write decisions).

---

## Phase 1: Ground (capture current state — no system data yet)

### Step 1: Daily note setup

Read today's daily note. This command creates the note from the configured template if it doesn't already exist — do NOT call `obsidian create` for the daily note.

```
obsidian daily:read vault="{{VAULT_NAME}}"
```

Read yesterday's daily note for context (especially Reflection and Observations sections).

---

### Step 2: Morning check-in

Guide through 3 prompts and write responses to `## Morning State` in today's daily note:
- "How are you feeling right now?"
- "What feels most alive for you right now?"
- "What would make today feel good?"

Update `energy` and `mood` frontmatter with natural-language values (e.g., "steady", "foggy", "optimistic").

These answers capture the user's current state. Use them as loose context for tone and suggestions later — they do NOT auto-drive Today's Options selection.

---

### Step 3: Calendar check

Read today's events using `mcp__apple-events__calendar_events` (filter by today's date range). Summarize obligations and note open time blocks for deep work.

Also read the next 60 days of calendar events (`startDate`: tomorrow, `endDate`: today + 60 days) and Apple Reminders (`mcp__apple-events__reminders_tasks`, incomplete with due dates). These feed the `## Upcoming` horizon overview in Step 9. Today's events inform action menu context but are NOT written to the daily note.

---

### Step 4: Day-specific routines

Read `[[Day-Specific Routines]]`. Filter for today's day of the week + the `## Daily` section. Present applicable items.

---

## Phase 2: Orient (full system awareness — read-only, no decisions)

### Step 5: Inbox overview (counts only — NOT processing)

Gather counts from all three inboxes:
- **Drafts inbox**: `mcp__drafts__drafts_inbox` — count items
- **Obsidian inbox**: `obsidian search query="path:Inbox/" vault="{{VAULT_NAME}}"` — count results
- **Unread email**: `mcp__mail__get_emails` (unread, limit 1) — get unread count

Report: "X Drafts, Y inbox notes, Z unread emails. Full processing happens during deep review."

**Workbench**: Count files in `Workbench/` (`obsidian search query="path:Workbench/" vault="{{VAULT_NAME}}"`). Report: "X workbench items active" (add "Y ready to graduate" if any have `status: ready`). Information-only — no processing.

Do NOT process inboxes here.

---

### Step 6: Full project landscape

Read ALL active project notes (search by `categories: ["[[Projects]]"]` and `status: active`) + `[[Action Pool]]`. Check Apple Reminders for approaching deadlines.

Present a high-level dashboard. For each active project:
- Project name + area
- Brief status snapshot (open action count, any waiting/blocked items)
- Approaching deadlines or time-sensitive items
- Last notable activity (from Completed section dates)

Group by area (work first, then personal). Include Action Pool standalone items as their own section.

**Carry-forward**: Read yesterday's daily note `## Today's Options` and note which items weren't completed (still `- [ ]`, not in `## Done Today`). If yesterday's note lacks a `## Today's Options` section (pre-dashboard notes), fall back to `[[Today Pool]]` `## Today's Options`. Present carry-forward items inline with their parent projects rather than as a separate list.

This is a read-only overview — no recommendations yet. End with: **"That's the full landscape. What stands out to you?"**

---

## Phase 3: Choose (collaborative — user drives)

### Step 7: Action menu

Present a work-biased menu of suggested actions drawn from the landscape. Weight by enjoyable usefulness. Consider energy/calendar loosely. Highlight:
- Critical/deadline items
- Personal items the user tends to deprioritize
- Friction patterns from prior reviews

#### Stance awareness
Watch for these patterns and respond concretely (grounded in `shadow-awareness` rule — Tier 1 only):
- *Lots of planning, little execution* → "What's the very next physical action?" (Shadow: preemption, systems-thinking from above)
- *Grinding through tasks, ignoring meaningful work* → Surface something important and enjoyable (Shadow: shallow-demands avoidance — fleeing into busywork)
- *Paralysis or "nothing matters"* → Offer one small, concrete, useful thing (Shadow: ambiguity + consequence trigger → freeze)
- *Refining options instead of choosing* → "These are good enough — which one first?" (Shadow: refinement addiction — "not yet elegant enough" as chronic threshold)

One observation max. If the user doesn't engage, drop it completely. Check off-switch criteria before surfacing (productive flow, low energy, already surfaced).

Frame as a discussion menu, not a final list. End with something like: **"These are some options that stand out. What would you like on today's plate? Anything to add, drop, or swap?"**

---

### Step 8: Collaborative selection

Wait for user input. The user picks, adjusts, discusses. Iterate as needed.

This step is conversational — no vault writes happen here. Only proceed to Phase 4 once the user confirms their choices.

---

## Phase 4: Commit (write based on user's choices)

### Step 9: Write daily note dashboard + Intentions

Write the following sections to today's daily note using `obsidian daily:read` + Edit tool (populate existing sections in place). Never use `daily:append` — it creates duplicate section headers.

If today's daily note was created before the dashboard template and lacks these sections, add them in the correct position (before `---` and `## Morning State`) before populating.

**`## Today's Options`** — The collaboratively chosen items from Phase 3, grouped by area:
```
### Work
- [ ] Action text — [[Source Project Name]]

### Personal
- [ ] Action text — [[Source]]

### Quick
- [ ] Action text — [[Source]]
```
Group items by their source project's area (Work, Home, Personal, Practice, etc.). Lightweight or standalone items go under **Quick**. Omit empty groups. Only items the user confirmed in Step 8. One checkbox per action.

**`## Routines`** — Convert today's items from `[[Day-Specific Routines]]` (read in Step 4) to checkboxes:
```
- [ ] Routine item
```
Include items from today's day-of-week section AND the `## Daily` section. If no routines apply, leave the section empty.

**`## Upcoming`** — Two-month horizon overview of critical items. Sources: calendar events (60-day scan from Step 3), Apple Reminders deadlines, and project milestones spotted during Step 6. Only critical items — deadlines, travel, social events, milestones, external commitments, time-sensitive decisions. Exclude recurring routine events (standups, regular 1:1s, daily blocks) unless this occurrence is unusual.

```
### This Week & Next
- Item description — [[Source Project]] (if project-linked)

### This Month
- Item description

### Next Month
- Item description
```

Omit empty groups. One concise line per item — no time-of-day prefixes, no emoji. If nothing critical: "Nothing critical on the horizon."

**`## Intentions`** — Qualitative intentions only. Task items live in Today's Options, not here. Intentions capture the user's stated priorities and desired feel for the day.

**Quick inbox relevance pass**: Based on the confirmed choices, scan all inboxes for items immediately relevant to today's chosen work:
- **Drafts**: `mcp__drafts__drafts_inbox` — read items, check relevance to chosen actions
- **Obsidian inbox**: `obsidian search query="path:Inbox/" vault="{{VAULT_NAME}}"` — scan notes for relevance
- **Unread email**: `mcp__mail__search` — keyword search based on chosen work topics (projects, people, subjects)

Process ONLY relevant items. Everything else waits for `/deep-review`.

---

### Step 10: Yesterday's observations + Summary + Commit

If yesterday's daily note exists and doesn't already have an `## Observations` section, append one with 2-3 sentences noting patterns Claude detected — energy trends, friction signals, mood patterns, or anything noteworthy from yesterday's data.

**Defense pattern tracking** (Tier 2 — appropriate in Observations): If yesterday's data shows a pattern from the `shadow-awareness` rule — repeated deferral of a specific action type, refinement without shipment, planning-heavy day with low completion — note it using the Wise Feedback Structure (observation + capacity evidence). Cross-reference with prior Observations sections when the pattern spans multiple days. If a documented pattern *didn't* activate when expected (e.g., high-ambiguity day handled with ease), note the contradiction — this is highest-value data for the Defense Pattern Living Record.

Present a brief summary:
- Two-month horizon snapshot (written to `## Upcoming`)
- Chosen actions by area (written to `## Today's Options`)
- Any follow-ups or waiting items
- Day-specific routine items (written to `## Routines`)

Commit all vault changes.
