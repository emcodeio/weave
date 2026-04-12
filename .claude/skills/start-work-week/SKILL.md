---
name: start-work-week
description: "Start the work week. Life check-in, week planning, and Monday daily startup. Usually Monday morning. Runs INSTEAD of /start-workday. Use when: 'start work week', 'Monday startup', 'let's start the week'."
disable-model-invocation: true
---

# Start Work Week (Monday morning, ~15 min)

You are running the user's Monday work-week startup. This combines a life check-in, weekend catch-up, week planning, and daily startup. Take it at a measured pace — Mondays set the tone.

---

## Step 1: Daily note setup

Read today's daily note. `daily:read` creates it from the configured template if it doesn't already exist — do NOT call `obsidian create` for the daily note.

```
obsidian daily:read vault="{{VAULT_NAME}}"
```

Read Friday's and weekend daily notes for continuity. Add a `## Week Ahead` section dynamically to today's note (Monday-only — not in the template).

---

## Step 2: Morning check-in

Same 3 prompts → `## Morning State`. Update `energy` and `mood` frontmatter.

- "How are you feeling right now?"
- "What feels most alive for you right now?"
- "What would make today feel good?"

---

## Step 3: Weekend catch-up

Ask: "What did you get done over the weekend?"

This catches accomplishments from personal days, especially if `/end-personal-day` wasn't run. Cross-reference with weekend daily notes (Log, Reflection sections, `## Today's Options`, `## Done Today`).

Advance the system:
- Mark completed project actions, move to `## Completed` sections.
- Update project context where relevant.
- Add any new follow-up actions surfaced.
- If nothing project-related happened, skip gracefully — weekends don't need to be productive.

---

## Step 4: Week Ahead check-in

4 Monday-specific life check-in questions. Write responses to `## Week Ahead` in today's note:

- "How am I feeling right now?" (deeper — about overall life state, not just this moment)
- "What feels most alive for me right now?"
- "Where am I feeling the most friction going into this week?"
- "What can I do to make it a good week?"

**Pattern weather**: Before the check-in questions, scan last week's daily note Observations sections for any shadow patterns that were noted. If a pattern appeared across multiple days, share briefly: "Last week I noticed [pattern] showing up around [domain] — worth keeping an eye on, or has something shifted?" This is conversational context, not excavation. If no patterns were noted, skip silently.

---

## Step 5: Calendar scan — full week

Read Mon-Fri events using `mcp__apple-events__calendar_events`. Identify:
- Meeting-heavy days vs. deep-work days
- Prep needs for upcoming events
- Personal commitments during work hours
- Schedule conflicts to flag

Summarize the week's shape.

Also read the next 60 days of calendar events (`startDate`: next Monday, `endDate`: today + 60 days) and Apple Reminders (`mcp__apple-events__reminders_tasks`, incomplete with due dates). These feed the `## Upcoming` horizon overview in Step 11. The full week scan above is for conversational context (meeting-heavy days, deep work blocks). `## Upcoming` captures only critical items across two months.

---

## Step 6: Rule of 3 recap

Surface the weekly outcomes from Friday's deep-review (if available — check Friday's daily note or recent notes for Rule of 3). Ask: "Still feel right, or want to adjust?"

---

## Step 7: Day-specific routines

Read `[[Day-Specific Routines]]`. Filter for Monday + `## Daily`. Present applicable items. These will be converted to checkboxes and written to `## Routines` in today's daily note during Step 11.

---

## Step 8: Inbox overview

Gather counts from all three inboxes:
- **Drafts inbox**: `mcp__drafts__drafts_inbox` — count items
- **Obsidian inbox**: `obsidian search query="path:Inbox/" vault="{{VAULT_NAME}}"` — count results
- **Unread email**: `mcp__mail__get_emails` (unread, limit 1) — get unread count

Report: "X Drafts, Y inbox notes, Z unread emails. Full processing happens during deep review."

**Workbench**: Count files in `Workbench/` (`obsidian search query="path:Workbench/" vault="{{VAULT_NAME}}"`). Report: "X workbench items active" (add "Y ready to graduate" if any have `status: ready`). Information-only — no processing.

Do NOT process inboxes here — the relevance pass happens in Step 11 after choices are confirmed.

---

## Step 9: Build action menu

Same as start-workday but with week-level awareness. Consider:
- Which Rule of 3 outcomes need action today?
- Front-load important work early in the week
- Monday energy (may be lower — adjust accordingly)
- ~5-8 options grouped by area, weighted by enjoyable usefulness

Include stance awareness checks (grounded in `shadow-awareness` rule — Tier 1 only):
- *Lots of planning, little execution* → "What's the very next physical action?" (Shadow: preemption, systems-thinking from above)
- *Grinding through tasks, ignoring meaningful work* → Surface something important and enjoyable (Shadow: shallow-demands avoidance)
- *Paralysis or "nothing matters"* → Offer one small, concrete, useful thing (Shadow: ambiguity + consequence trigger)
- *Refining options instead of choosing* → "These are good enough — which one first?" (Shadow: refinement addiction)

One observation max. Check off-switch criteria before surfacing.

---

## Step 10: Carried forward from Friday

Check Friday's daily note `## Today's Options` for undone items (still `- [ ]`, not in `## Done Today`). If Friday's note lacks a `## Today's Options` section (pre-dashboard), fall back to `[[Today Pool]]` `## Today's Options`. Ask: "Still relevant?"

---

## Step 11: Write daily note dashboard + Intentions

Write the following sections to today's daily note using `obsidian daily:read` + Edit tool (populate existing sections in place). Never use `daily:append` — it creates duplicate section headers.

If today's daily note was created before the dashboard template and lacks these sections, add them in the correct position (before `---` and `## Morning State`) before populating.

**`## Today's Options`** — The collaboratively chosen items from Step 9, grouped by area:
```
### Work
- [ ] Action text — [[Source Project Name]]

### Personal
- [ ] Action text — [[Source]]

### Quick
- [ ] Action text — [[Source]]
```
Group items by their source project's area (Work, Home, Personal, Health, etc.). Lightweight or standalone items go under **Quick**. Omit empty groups. Only items the user confirmed. One checkbox per action. 5-8 options weighted by enjoyable usefulness and week-level awareness (Rule of 3 outcomes, front-loaded priorities).

**`## Routines`** — Convert Monday + Daily items from `[[Day-Specific Routines]]` (read in Step 7) to checkboxes:
```
- [ ] Routine item
```

**`## Upcoming`** — Two-month horizon overview of critical items. Sources: calendar events (60-day scan from Step 5), Apple Reminders deadlines, and project milestones spotted during Step 9. Only critical items — deadlines, travel, social events, milestones, external commitments, time-sensitive decisions. Exclude recurring routine events unless this occurrence is unusual.

```
### This Week & Next
- Item description — [[Source Project]] (if project-linked)

### This Month
- Item description

### Next Month
- Item description
```

Omit empty groups. One concise line per item — no time-of-day prefixes, no emoji. If nothing critical: "Nothing critical on the horizon." Full week shape was presented conversationally in Step 5. This section is a two-month critical-items overview, not today's schedule.

**`## Intentions`** — Qualitative intentions for the day. Informed by Week Ahead responses (Step 4) and Rule of 3 (Step 6). Task items live in Today's Options, not here.

**Quick inbox relevance pass**: Based on the confirmed choices, scan all inboxes for items immediately relevant to today's chosen work:
- **Drafts**: `mcp__drafts__drafts_inbox` — read items, check relevance to chosen actions
- **Obsidian inbox**: `obsidian search query="path:Inbox/" vault="{{VAULT_NAME}}"` — scan notes for relevance
- **Unread email**: `mcp__mail__search` — keyword search based on chosen work topics
Process ONLY relevant items. Everything else waits for `/deep-review`.

---

## Step 12: Yesterday's observations

Write to Sunday's (or Friday's) daily note if it exists without `## Observations`. Include defense pattern tracking at Tier 2 if applicable — same protocol as start-workday Step 10 (observation + capacity evidence; note contradictions for the Defense Pattern Living Record).

---

## Step 13: Summary

Present:
- Week overview (calendar shape, Rule of 3 outcomes)
- Today's plan (action menu, calendar)
- Any follow-ups or attention items

Commit all vault changes.
