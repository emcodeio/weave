# Weave

Task management lives entirely in Obsidian. No external task manager.

## Task Philosophy

- **Action menus, not queues**: Projects contain unordered action menus (checkboxes). The user picks what to do based on current energy, context, and interest — not a prescribed sequence. Only enforce ordering when genuine dependency exists.
- **Enjoyable usefulness**: When presenting options, weight by both usefulness and likely enjoyability. The orienting question: "What could you do now that would be both useful and enjoyable?"
- **Friction detection**: Actions repeatedly deferred across reviews are a signal, not a failure. Surface the pattern: "This has come up three reviews in a row — is something blocking it, or has the purpose shifted?" Use QMD to find semantically similar deferred actions — patterns across projects reveal systemic friction (e.g., all communication tasks, all admin tasks). When friction patterns emerge, cross-reference with `shadow-awareness` rule — systemic avoidance often maps to documented defense patterns.
- **Stance awareness**: Watch for three observable patterns and respond concretely:
  - *Grandiose planning, no execution* → "What's the very next physical action?"
  - *Grinding through tasks, ignoring meaningful work* → Surface something important and enjoyable
  - *Paralysis or "nothing matters"* → Offer one small, concrete, useful thing
  Ground stance observations in the user's documented defense patterns when the connection is clear. Use the `shadow-awareness` rule's tiered protocol — Tier 1 only during task work.
- **Inbox = single capture point**: Two inboxes feed the system — the Drafts app inbox (primary text capture via desktop `Control+Spacebar`, mobile, iOS share sheet) and Obsidian `Inbox/` (receives notes pushed from Drafts via "Save in Obsidian Vault" action, plus Keyboard Maestro contextual captures: browser URL, Apple Mail reference, Finder file — all sharing `Control+Option+Command+Spacebar` scoped by active app). Non-markdown files go to `Attachments/` with a wrapper note in `Inbox/`. Full inbox processing happens during `/deep-review`; daily startups give a counts overview and process only immediately relevant items. See `[[Capture System Setup Guide]]` for implementation details.

## Action Format

Natural-language checkboxes with optional energy/time hints. Use GTD-actionable phrasing (starts with a verb).

```markdown
- [ ] Call plumber for annual maintenance quote
- [ ] Research desk setup options ~focused ~2h
- [ ] Order replacement hardware ~quick
```

## Completion Tracking

Mark completed actions inline, then move to `## Completed` section (newest first):

```markdown
- [x] Call plumber for annual maintenance quote — 2026-03-01
```

## Project Rules

- Clear outcome + 2 actions = project. Actions are menus (not sequences) unless genuine dependency exists.
- Standalone actions that don't belong to a project → `[[Action Pool]]`
- Standalone someday ideas → `[[Someday Pool]]`
- Today's curated options → daily note `## Today's Options` — Claude populates during morning startup, persists in each day's note

## Routines

Day-specific routines live in `[[Day-Specific Routines]]`, organized by day of week. Claude reads this during reviews and surfaces relevant items. Review session steps are embedded in the skills themselves. Changes to routines go through Claude.

## Leisure & Hobby Tracking

Leisure activities (gaming, reading, watching, exploring) are tracked **in Obsidian only** unless a specific real-world action is needed.

- **Collection notes** live in `Notes/` (e.g., `Reading.md`). Living documents tracking active, backlog, and completed items. Intentional exception to the atomic-note rule.
- **Individual notes** for specific items go in `Notes/` when there are thoughts worth capturing. Link back to the collection note.
- **Apple Reminders involvement**: Only for hard-deadline actions (buy tickets before they sell out, return item by date). Never for the leisure activity itself.
- **During reviews**: Collection notes surface through area note links. Mention in-progress leisure items as options — gently, never as obligations.

## Tag Strategy

Use tags sparingly. Documented categories:

| Category | Examples | Rule |
|----------|----------|------|
| **Type** (per note) | `transcript`, `collection`, `routine`, `framework`, `email`, `capture` | Describes content type |
| **Topic** (per note) | `home-renovation`, `career-change`, `health-journey` | Marks topic cluster membership |
| **Action** (optional) | `Quick`, `Focused`, `Waiting`, `Errand`, `Call` | Available when useful, not enforced |

## Review Sessions

Seven review sessions, each a separate skill:

| Session | Skill | When | Duration | Character |
|---------|-------|------|----------|-----------|
| Workday startup | `/start-workday` | Tue-Fri morning | ~10 min | Calendar, inbox overview, action menu. Work-biased. |
| Personal day startup | `/start-personal-day` | Weekends, vacation | ~5 min | Relaxed. Only critical items. Leisure-weighted. |
| Work week startup | `/start-work-week` | Monday morning | ~15 min | Life check-in + weekend catch-up + week planning + daily startup. |
| End workday | `/end-workday` | Mon-Fri evening | ~5-10 min | Capture accomplishments, advance projects, reflect, closure phrase. |
| End personal day | `/end-personal-day` | Weekend/vacation evening | ~5-10 min | Capture accomplishments, advance projects, gentle reflection. |
| Deep review | `/deep-review` | Usually Friday EOD | ~30 min | Full GTD: inboxes to zero, audit all, get creative. |
| End weekend | `/end-weekend` | Sunday evening | ~5 min | Gentle appreciation. No processing. |

**Inbox processing**: Daily startups give an overview (counts + summary) and only process items immediately relevant to the day's priorities. Full inbox-to-zero processing happens exclusively during `/deep-review`.

**Day-specific routines**: Managed in `[[Day-Specific Routines]]`. Claude reads and filters by day of week during reviews. Changes go through Claude.

**Daily notes**: Template in `Templates/`. Hybrid dashboard + journal. Dashboard zone: `## Today's Options` (curated action checkboxes), `## Routines` (day-specific), `## Upcoming` (two-month horizon: critical items this/next week, this month, next month), `## Active Projects` (embedded Base). Journal zone: `## Morning State`, `## Intentions` (qualitative, no task items), `## Log`, `## Done Today`, `## Reflection`. Natural-language frontmatter (`energy`, `mood`). Claude writes `## Observations` in yesterday's note during each morning startup. Monday notes get `## Week Ahead`.

**Shutdown phrase**: "Good enough for today." closes workday shutdowns for psychological closure (Zeigarnik effect). Embodies the Weave anti-perfectionism stance.
