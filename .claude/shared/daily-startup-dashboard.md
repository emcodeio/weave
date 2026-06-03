# Daily-Note Dashboard Write-Spec (shared)

Canonical procedure for writing the daily-note dashboard at the **Commit** phase of a startup skill (`/start-workday`, `/start-work-week`, `/start-personal-day`). Each calling skill supplies the **parameters** noted in **bold** below; everything else is identical across startups. This is the single source — change the dashboard format here, once.

Write these sections to today's daily note using `obsidian daily:read` + the Edit tool (populate existing sections in place). Never use `daily:append` — it creates duplicate section headers. If today's note predates the dashboard template and lacks these sections, add them in the correct position (before `---` and `## Morning State`) before populating.

## `## Today's Options`

The collaboratively chosen items from the Choose phase, grouped by area:

```
### [Area]
- [ ] Action text — [[Source Project Name]]

### Quick
- [ ] Action text — [[Source]]
```

Group items by their source project's area. Lightweight or standalone items go under **Quick**. Omit empty groups. Only items the user confirmed in the selection step. One checkbox per action.

- **Param — groups + count/weighting**: the calling skill specifies which area groups to use and how many options at what weighting.

## `## Routines`

Convert the day-specific items from `[[Day-Specific Routines]]` (read earlier in the startup) to checkboxes:

```
- [ ] Routine item
```

Include items from today's day-of-week section AND the `## Daily` section. If no routines apply, leave the section empty.

## `## Upcoming`

Two-month horizon overview of critical items. Sources: the 60-day calendar scan, Apple Reminders deadlines, and project milestones spotted during the landscape/orient step. Only critical items — deadlines, travel, social events, milestones, external commitments, time-sensitive decisions. Exclude recurring routine events (standups, regular 1:1s, daily blocks) unless an occurrence is unusual.

```
### This Week & Next
- Item description — [[Source Project]] (if project-linked)

### This Month
- Item description

### Next Month
- Item description
```

Omit empty groups. One concise line per item — no time-of-day prefixes, no emoji. If nothing critical: "Nothing critical on the horizon."

- **Param — focus**: the calling skill specifies which item types to emphasize (e.g., work + personal vs. personal-only).

## `## Intentions`

Qualitative intentions only — task items live in Today's Options, not here.

- **Param — tone/source**: the calling skill specifies what informs the intentions and the day's intended feel.

## Inbox relevance pass

Based on the confirmed choices, scan inboxes for items immediately relevant to today's chosen work; process ONLY relevant items — everything else waits for `/deep-review`.

- **Drafts**: `mcp__drafts__drafts_inbox`
- **Obsidian inbox**: `obsidian search query="path:Inbox/" vault="{{VAULT_NAME}}"`
- **Unread email**: `mcp__mail__search` — keyword search on chosen work topics. **Param — include email?**: work startups include this; `/start-personal-day` skips email.
