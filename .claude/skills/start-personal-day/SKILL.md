---
name: start-personal-day
description: "Start a personal day (weekend, vacation, day off). Relaxed overview, no full inbox processing. Use when: 'start personal day', 'weekend startup', 'day off'."
disable-model-invocation: true
---

# Start Personal Day (weekends/vacation, ~5 min)

You are running the user's personal day startup. This should feel relaxed and unhurried — no work pressure. Present options gently.

The startup has four phases: **Ground** (settle in), **Orient** (see what's around), **Choose** (pick what appeals), **Commit** (write it down).

---

## Phase 1: Ground (settle in)

### Step 1: Daily note setup

Read today's daily note. This command creates the note from the configured template if it doesn't already exist — do NOT call `obsidian create` for the daily note.

```
obsidian daily:read vault="{{VAULT_NAME}}"
```

Read yesterday's daily note for context (especially Reflection and Observations sections).

---

### Step 2: Morning check-in

Guide through 3 prompts, lighter tone. Write responses to `## Morning State` in today's daily note:
- "How are you feeling right now?"
- "What feels most alive for you right now?"
- "What would make today feel good?"

Update `energy` and `mood` frontmatter with natural-language values.

These answers capture the user's current state. Use them as loose context for tone and suggestions later — they do NOT auto-drive Today's Options selection.

---

### Step 3: Calendar check

Read today's events using `mcp__apple-events__calendar_events` (filter by today's date range). Focus on social plans, errands, family commitments.

Also read the next 60 days of calendar events (`startDate`: tomorrow, `endDate`: today + 60 days) and Apple Reminders (`mcp__apple-events__reminders_tasks`, incomplete with due dates). Focus on social plans, trips, family commitments, and personal deadlines. These feed the `## Upcoming` horizon overview in Step 8. Today's events inform suggestions but are NOT written to the daily note.

---

### Step 4: Day-specific routines

Read `[[Day-Specific Routines]]`. Filter for today's day of the week + the `## Daily` section. Present applicable items. These will be converted to checkboxes and written to `## Routines` in today's daily note during Step 8.

---

## Phase 2: Orient (see what's around — read-only)

### Step 5: What's around

Gather a casual overview — no decisions yet, just awareness.

**Inbox counts** (report but do NOT process):
- **Drafts inbox**: `mcp__drafts__drafts_inbox` — count items
- **Obsidian inbox**: `obsidian search query="path:Inbox/" vault="{{VAULT_NAME}}"` — count results
- **Unread email**: `mcp__mail__get_emails` (unread, limit 1) — get unread count. Skip work email entirely.

Report: "X Drafts, Y inbox notes, Z unread emails."

**Light scan** — read through these casually, no structured dashboard:
- Leisure collection notes from `Notes/` (search for notes tagged `collection`)
- Personal project actions (search by `categories: ["[[Projects]]"]` and `status: active`)
- `[[Action Pool]]`
- `[[Someday Pool]]` — personal days are when someday items naturally surface
**Carry-forward**: Read yesterday's daily note `## Today's Options` and note which items weren't completed (still `- [ ]`, not in `## Done Today`). Frame casually: "A couple things from yesterday that didn't happen — still interesting?"

**Deadlines**: Check Apple Reminders (`mcp__apple-events__reminders_tasks`) for anything time-sensitive.

End with: **"Anything catch your eye?"**

---

## Phase 3: Choose (pick what appeals)

### Step 6: Gentle suggestions

Instead of a formal action menu: "Here are some things you might enjoy today..."

Present a leisure-weighted menu drawn from the Orient overview. Include:
- In-progress leisure (games, books, shows)
- Personal project actions
- Errands or quick wins
- Someday items that fit today's energy

No work items unless the user asks.

#### Personal-day stance awareness
Watch for these patterns and respond concretely — light touch only (see `shadow-awareness` rule, Tier 1):
- *Over-scheduling the day off* → "This is supposed to be restorative. What one thing would feel best?"
- *Guilt about resting* → "Rest is productive. What sounds enjoyable?"
- *Can't decide / nothing appeals* → Offer one small, enjoyable thing

Personal days are for ease. One gentle observation at most. If energy or mood suggest a day for rest, skip shadow observations entirely.

---

### Step 7: Collaborative selection

Wait for user input. The user picks, adjusts, discusses. Can be very brief — "yeah, those look good" is fine.

This step is conversational — no vault writes happen here. Only proceed to Phase 4 once the user confirms their choices.

---

## Phase 4: Commit (write it down)

### Step 8: Write daily note dashboard + Intentions

Write the following sections to today's daily note using `obsidian daily:read` + Edit tool (populate existing sections in place). Never use `daily:append` — it creates duplicate section headers.

If today's daily note was created before the dashboard template and lacks these sections, add them in the correct position (before `---` and `## Morning State`) before populating.

**`## Today's Options`** — The collaboratively chosen items from Phase 3, grouped by area:
```
### Personal
- [ ] Action text — [[Source]]

### Quick
- [ ] Action text — [[Source]]
```
Group items by their source project's area (Home, Personal, Relationships, Health, etc.). Lightweight or standalone items go under **Quick**. Omit empty groups. Only items the user confirmed in Step 7. One checkbox per action. 3-5 items including leisure options.

**`## Routines`** — Convert today's items from `[[Day-Specific Routines]]` (read in Step 4) to checkboxes:
```
- [ ] Routine item
```
Include items from today's day-of-week section AND the `## Daily` section. If no routines apply, leave the section empty.

**`## Upcoming`** — Two-month horizon overview of critical items. Sources: calendar events (60-day scan from Step 3), Apple Reminders deadlines, and project milestones spotted during Step 5. Focus on personal deadlines, social events, trips, and family commitments. Skip routine work meetings unless they're major milestones.

```
### This Week & Next
- Item description — [[Source Project]] (if project-linked)

### This Month
- Item description

### Next Month
- Item description
```

Omit empty groups. One concise line per item — no time-of-day prefixes, no emoji. If nothing critical: "Nothing critical on the horizon."

**`## Intentions`** — Gentle intentions for a personal day. Task items live in Today's Options, not here.

**Simplified inbox relevance pass**: Based on the confirmed choices, scan Drafts (`mcp__drafts__drafts_inbox`) and Obsidian inbox (`obsidian search query="path:Inbox/" vault="{{VAULT_NAME}}"`) for items immediately relevant to today's choices. Skip email on personal days. Process ONLY relevant items. Everything else waits for `/deep-review`.

---

### Step 9: Yesterday's observations + Summary + Commit

If yesterday's daily note exists and doesn't already have an `## Observations` section, append one with 2-3 sentences noting patterns Claude detected — energy trends, mood patterns, or anything noteworthy from yesterday's data. Shadow pattern tracking at Tier 2 if applicable — same protocol as start-workday (observation + capacity evidence). On personal days, lean toward noting contradictions (pattern *didn't* fire) over noting activations. Keep it warm.

Present a warm summary: "Your day is open except [calendar items]. Some things that might be nice: [2-3 highlights]." Include the two-month horizon overview written to `## Upcoming`.

Commit all vault changes.
