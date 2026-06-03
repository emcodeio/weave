---
name: process-transcript
description: "Single entry point for processing any transcript — work meetings or generic recordings. Detects the frame (generic/work), loads the matching domain profile, and produces an integration plan for approval before any vault changes. Use when the user mentions processing a transcript, meeting recording, work meeting, or extracting from a recording (e.g. 'process transcript', 'process this meeting', 'process work meeting', 'what came out of this meeting', 'extract from a recording')."
argument-hint: "[transcript note name or path]"
---

# Process Transcript

Analyze the transcript referenced in "$ARGUMENTS" and produce a structured integration plan. Never make vault changes without user approval.

This is the single transcript processor. It runs a shared spine and, after detecting the frame (Step 2), loads at most one domain profile:
- **Work** meetings → also read `references/work-profile.md`
- **Generic** → use the inline taxonomy below; load no profile

Run inline (interactive). Multi-participant transcripts require live attribution decisions, so this is never forked.

## Dynamic Context

### Active projects
!`obsidian search query="categories: Projects" vault="{{VAULT_NAME}}" limit=30 2>/dev/null || echo "(Could not scan projects)"`

### Action Pool
!`obsidian read file="Action Pool" vault="{{VAULT_NAME}}" 2>/dev/null || echo "(Could not read Action Pool)"`

### Someday Pool
!`obsidian read file="Someday Pool" vault="{{VAULT_NAME}}" 2>/dev/null || echo "(Could not read Someday Pool)"`

---

## Step 1: Locate and read the transcript

Parse "$ARGUMENTS" to find the transcript. Try in order:
1. `obsidian read file="$ARGUMENTS" vault="{{VAULT_NAME}}"` (note name)
2. `obsidian read path="$ARGUMENTS" vault="{{VAULT_NAME}}"` (path)
3. `obsidian search query="$ARGUMENTS" vault="{{VAULT_NAME}}"` (search)

If not found, ask the user for clarification. Read the full transcript — analysis requires complete context.

## Step 2: Detect the frame, then establish it

Identify common framing first, then classify and load the matching profile.

**Common framing (all transcripts):**
- **Participants**: who was present; note which statements are the user's.
- **Related projects/areas**: scan active projects for keyword matches. If meeting language doesn't obviously match project names (e.g., "kitchen remodel" vs. "Kitchen Renovation Plan"), use `mcp__qmd__query` with a `vec` sub-query of the key topics + `intent` "finding related projects and areas for this transcript." See the `qmd` rule.
- **Date and series**: is this part of an ongoing series? Check for prior notes in the series.

**Frame classification** — pick one:

| Signal | Frame | Then |
|--------|-------|------|
| Work meeting: colleagues, workstreams, standup/1:1/cross-team/client/design-review/handoff | **work** | Read `references/work-profile.md` and follow its Step-2/3/4/5/7 deltas |
| Anything else — generic meeting, recording with no domain specialization | **generic** | Use the inline taxonomy below; load no profile |

If the frame is genuinely ambiguous (e.g., a work conversation that drifts into personal content), name the ambiguity and ask the user which profile to load.

Present a brief context summary (frame, participants, related projects, date/series). Getting the frame right matters — the same words mean different things in a work standup vs. a casual conversation. Ask for corrections before extracting.

## Step 3: Deep analysis

Analyze the full transcript. Extract everything with potential integration value. Items can belong to multiple categories.

**If the frame is work, the loaded profile REPLACES the generic taxonomy below with its domain taxonomy.** Use the generic taxonomy only for the generic frame.

**Generic taxonomy:**

**Action items** — commitments or things that need doing
- Owner (user vs. someone else), related project/area, GTD-actionable phrasing (starts with a verb), energy/time hints and deadlines if apparent

**Decisions made** — what was decided, who was involved, which project/area, any caveats

**Reference information** — facts worth capturing; whether it merits an atomic note or appending to an existing one

**Project context updates** — status shifts, new constraints, timeline changes, completed work

**Insights and ideas** — realizations, brainstorms, cross-project connections

**Waiting-for items** — others' commitments the user should track (who, what, timeline)

It is entirely valid for a transcript to yield nothing in some or all categories. Flag that clearly without making it feel like a failure.

## Step 4: Present the integration plan

Structure the plan clearly. For each proposed change, include destination, content, and rationale. **Use the plan template from the loaded profile when work; use the generic template below otherwise.**

```
## Integration Plan: [Transcript Name]

### Context
[Frame from Step 2]

### Proposed Actions (X items)
- [ ] **[GTD-phrased action]** -> [[Destination]] | Owner: [user/other] | Deadline: [if any]

### Project Updates (X items)
- [ ] **[What to update]** -> [[Project]] > [Section] | [Proposed content]

### Reference Notes (X items)
- [ ] **[Proposed title]** -> Notes/ | Links: [[...]]

### Decisions (X items)
- [ ] **[Decision]** -> [[Project]] > Context | [Date]

### Waiting-For (X items)
- [ ] **[Person] to [action]** -> [[Destination]]

### Ideas (X items)
- [ ] **[Idea]** -> [[Someday Pool]] or new project

### Insights (X items)
- [ ] **[Insight]** -> [Suggested capture method]
```

**Pause here.** Ask the user which items to execute, modify, or skip. The user might approve all, cherry-pick, rephrase items, or redirect destinations. Wait for input before proceeding.

## Step 5: Execute approved changes

Apply each approved item using proper conventions. **Profiles add domain-specific destinations and formatting — follow the loaded profile's Step-5 list when work.** Generic baseline:

- **Actions**: `- [ ] Verb phrase ~hints` in target note's Actions section
- **Project updates**: dated entry in the Context or Notes section
- **Reference notes**: `obsidian create` in `Notes/` with full frontmatter (categories, areas, status, tags, created) and wikilinks
- **Decisions**: dated entry in project Context section
- **Waiting-for**: add with `~Waiting` annotation
- **Ideas**: add to Someday Pool or create a someday project via `/create-project`
- **Insights**: atomic note in `Notes/` or append to an existing note

Follow the proactive linking checklist: frontmatter, areas links, project links, related notes, verify categories/areas properties.

> When the frame touched any project, also update each touched project: add items to its action menu/context/notes, update status/constraints if changed, and add a bidirectional link to the transcript note. (The work profile specifies domain-specific project updates — cross-team multi-project routing.)

## Step 6: Handle the transcript note

Check the transcript note's current state and enrich:
- **Frontmatter**: ensure transcript schema fields are present (`categories: ["[[Transcripts]]"]`, `areas`, `tags`, `people`, `date`/`session-date`, `topics`). The loaded profile specifies the exact schema (work: one-off vs. recurring). Add or fix missing fields.
- **Summary**: if the note lacks a `## Summary`, offer to add one based on the analysis.
- **Links**: add bidirectional links to all projects/areas/notes touched during processing.
- **Location**: if in `Inbox/`, suggest moving to `Notes/`. If already organized, leave it.

## Step 7: Summary and commit

Report:
- Items integrated by category (with counts)
- Notes created (with paths)
- Notes modified (with paths)
- Items skipped
- Observations — patterns across transcripts (recurring topics without action, friction signals, emerging/deepening themes, blocker trends)

Commit: `"Process transcript: [Transcript Name]"`. (The work profile may suggest a frame-specific message, e.g., `"Process work transcript: …"` — fine to use.)

---

## Quality Standards

- **Plan first, execute on approval** — never modify vault notes until the user confirms
- **Distinguish ownership** — only add user-owned actions; others' actions become waiting-for items
- **Respect nebulosity** — when content is ambiguous, flag it: "This could be an action or context — which feels right?"
- **Match existing style** — mirror GTD-actionable phrasing and formatting in existing project notes
- **Don't over-extract** — pleasantries, filler, logistics, and tangents are not integration material
- **Preserve provenance** — note which transcript produced each extracted item
- **Handle series** — for recurring sessions, check previous transcripts for continuity and evolving themes
- **Adapt to type** — let the content (and the loaded profile) determine the categories, not the other way around
- **Profile-specific standards** (blocker awareness, priority signals, participant resolution, etc.) live in the loaded profile — honor them whenever that frame is active
