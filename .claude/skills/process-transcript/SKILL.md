---
name: process-transcript
description: "Analyze a transcript and produce an integration plan for the Weave system. Extracts action items, reference material, project context, decisions, and insights -- then presents a structured plan for user approval before making any vault changes. Use when the user says 'process transcript', 'analyze transcript', 'process this meeting', 'what came out of this meeting', or 'extract from transcript'."
argument-hint: "[transcript note name or path]"
---

# Process Transcript

Analyze the transcript referenced in "$ARGUMENTS" and produce a structured integration plan. Never make vault changes without user approval.

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

If not found, ask the user for clarification. Read the full transcript -- analysis requires complete context.

## Step 2: Establish the frame

Before extracting anything, identify:
- **Meeting type**: work meeting, coaching, practice session, class, 1:1, group discussion
- **Participants**: who was present (note which statements are the user's)
- **Related projects/areas**: scan active projects list for keyword matches. If meeting language doesn't obviously match project names (e.g., "kitchen remodel" vs. "Kitchen Renovation Plan"), also use `mcp__qmd__query` with a `vec` sub-query of the meeting's key topics + `intent` "finding related projects and areas for this meeting." See the `qmd` rule for query construction patterns.
- **Date and series**: is this part of an ongoing series?

Present this context summary briefly. Getting the frame right matters -- the same words mean different things in a work standup vs. a meditation session.

## Step 3: Deep analysis

Analyze the full transcript. Extract everything with potential integration value using this fluid taxonomy (items can belong to multiple categories):

**Action items** -- commitments or things that need doing
- Owner (user vs. someone else)
- Related project/area
- GTD-actionable phrasing (starts with a verb)
- Energy/time hints and deadlines if apparent

**Decisions made** -- things decided or agreed upon
- What, who was involved, which project/area, any caveats

**Reference information** -- facts worth capturing
- Key data, technical details, explanations
- Whether it merits an atomic note or appending to an existing note

**Project context updates** -- information that changes project state
- Status shifts, new constraints, timeline changes, completed work

**Insights and ideas** -- realizations, brainstorms, connections
- Personal insights, ideas for later, cross-project connections

**Waiting-for items** -- others' commitments the user should track
- Who, what, timeline if mentioned

It is entirely valid for a transcript to yield nothing in some or all categories. Flag that clearly without making it feel like a failure.

## Step 4: Present the integration plan

Structure the plan clearly. For each proposed change, include destination, content, and rationale:

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

**Pause here.** Ask the user which items to execute, modify, or skip. The user might approve all, cherry-pick, rephrase items, or redirect destinations. Wait for their input before proceeding.

## Step 5: Execute approved changes

For each approved item, apply using proper conventions:

- **Actions**: `- [ ] Verb phrase ~hints` in target note's Actions section
- **Project updates**: Dated entry in the Context or Notes section
- **Reference notes**: Create via `obsidian create` in `Notes/` with full frontmatter (categories, areas, status, tags, created) and wikilinks
- **Decisions**: Dated entry in project Context section
- **Waiting-for**: Add with `~Waiting` annotation
- **Ideas**: Add to Someday Pool or create someday project via `/create-project`
- **Insights**: Create atomic note in `Notes/` or append to existing note

Follow the proactive linking checklist: frontmatter, areas links, project links, related notes, verify categories/areas properties.

## Step 6: Handle the transcript note

Check the transcript note's current state and offer options:
- **Frontmatter**: Ensure transcript schema fields are present (categories, areas, tags, people, date, topics). Add or fix if missing.
- **Links**: Add bidirectional links to all projects/areas touched during processing.
- **Location**: If in `Inbox/`, suggest moving to `Notes/`. If already organized, leave it.

## Step 7: Summary and commit

Report:
- Items integrated by category (with counts)
- Notes created (with paths)
- Notes modified (with paths)
- Items skipped
- Observations -- patterns noticed across transcripts (e.g., recurring topics without action, friction signals, emerging themes)

Commit all changes: "Process transcript: [Transcript Name]"

---

## Quality Standards

- **Plan first, execute on approval** -- never modify vault notes until the user confirms
- **Distinguish ownership** -- only add user-owned actions to the system; others' actions become waiting-for items
- **Respect nebulosity** -- when content is ambiguous, flag it: "This could be an action or context -- which feels right?"
- **Match existing style** -- mirror the GTD-actionable phrasing and formatting in existing project notes
- **Don't over-extract** -- casual conversation, social pleasantries, and filler are not integration material
- **Preserve provenance** -- note which transcript produced each extracted item
- **Handle series** -- for recurring sessions, check previous transcripts for continuity and evolving themes
- **Adapt to type** -- a work meeting transcript produces different output than a meditation session transcript. Let the content determine the categories, not the other way around.
