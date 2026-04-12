---
name: process-work-transcript
description: "Analyze a work meeting transcript and produce an integration plan for the Weave system. Extracts action items, decisions, blockers, technical reference, project updates, and cross-team coordination items — with work-domain context (key people, active workstreams, meeting type detection). Use when the user says 'process work transcript', 'process work meeting', 'process this meeting' (when work context is clear), or 'what came out of this work meeting'."
argument-hint: "[transcript note name or path]"
---

# Process Work Transcript

Analyze the work meeting transcript referenced in "$ARGUMENTS" and produce a structured integration plan. Never make vault changes without user approval.

This is a work-domain specialization of `/process-transcript`. It loads work context (key people, active workstreams, organizational landscape), detects meeting type, resolves participants to wikilinks, and extracts blockers and cross-team coordination items as first-class categories.

## Dynamic Context

### Work area note (key people, landscape, workstreams)
!`obsidian read file="Work" vault="{{VAULT_NAME}}" 2>/dev/null || echo "(Could not read Work area note)"`

### Active work projects
!`obsidian search query="categories: Projects" vault="{{VAULT_NAME}}" limit=30 2>/dev/null || echo "(Could not scan projects)"`

### Action Pool
!`obsidian read file="Action Pool" vault="{{VAULT_NAME}}" 2>/dev/null || echo "(Could not read Action Pool)"`

---

## Step 1: Locate and read the transcript

Parse "$ARGUMENTS" to find the transcript. Try in order:
1. `obsidian read file="$ARGUMENTS" vault="{{VAULT_NAME}}"` (note name)
2. `obsidian read path="$ARGUMENTS" vault="{{VAULT_NAME}}"` (path)
3. `obsidian search query="$ARGUMENTS" vault="{{VAULT_NAME}}"` (search)

If not found, ask the user for clarification. Read the full transcript — analysis requires complete context.

## Step 2: Establish the work frame

Before extracting anything, identify:

- **Meeting type**: Detect from content and participants. Categories:
  - *Status/standup* — regular team updates, progress reports
  - *1:1 technical* — deep technical discussion between two people
  - *Cross-team coordination* — multiple teams or workstreams aligning
  - *Client meeting* — external stakeholder involvement
  - *Design review* — reviewing specs, designs, or technical artifacts
  - *PM/handoff* — role transitions, responsibility transfers
  - *Other* — describe what makes it distinct

  Meeting type sets extraction emphasis (primary vs. secondary categories):

  | Meeting Type | Primary | Secondary |
  |-------------|---------|-----------|
  | Status/standup | Project updates, Blockers | Actions, Waiting-for |
  | 1:1 technical | Technical reference, Decisions | Actions, Ideas |
  | Cross-team coordination | Actions, Decisions, Waiting-for | Blockers, Cross-team |
  | Client meeting | Decisions, Waiting-for, Actions | Project updates |
  | Design review | Technical reference, Decisions | Actions, Ideas |
  | PM/handoff | Decisions, Actions, Waiting-for | Project updates, Cross-team |

- **Participants**: List all speakers. Resolve names against the key people list from the Work area note. Produce wikilinks for people who have vault notes (e.g., "Jordan" → `[[Jordan Reeves]]`). Unknown participants stay as plain text strings. Note which speaker is the vault owner.

- **Related projects**: Match meeting topics to active work projects loaded in dynamic context. Use keyword matching first; fall back to `mcp__qmd__query` with a `vec` sub-query of the meeting's key topics + `intent` "finding related work projects for this meeting" if needed. Flag the primary project and any secondary projects touched.

- **Date and series**: Is this part of a recurring series (weekly status, recurring 1:1)? Check for previous notes in the same series via `obsidian search`.

- **Organizational context**: Note which workstream(s) this touches (from the Work area note's current landscape).

Present this context summary. Ask the user for corrections before proceeding — getting the frame right determines extraction quality.

## Step 3: Deep analysis

Analyze the full transcript. Extract everything with potential integration value using this work-specific taxonomy. Items can belong to multiple categories. Weight categories by the detected meeting type — primary categories should be thoroughly extracted; secondary categories captured when clearly present.

**Action items** — commitments or things the user needs to do
- GTD-actionable phrasing (starts with a verb)
- Related project/area
- Energy/time hints, deadlines if apparent
- Priority signal if discussed ("this is the critical piece", "most urgent")

**Decisions made** — things decided or agreed upon
- What was decided, who was involved
- Decision type: technical / product / organizational
- Which project/area
- Caveats, conditions, or constraints
- Routing: technical decisions → project Context or dedicated note; product/org → project Context

**Blockers and dependencies** — what's stuck or waiting
- What's blocked and by whom/what
- Which project(s) affected
- Criticality level (mentioned in passing vs. "this is blocking everything")
- Resolution path if discussed
- Related to waiting-for items (blocker owned by someone else → also a waiting-for)

**Project context updates** — information that changes project state
- Status shifts, new constraints, timeline changes
- Completed work worth recording
- Scope changes or priority shifts
- Leadership directives that change project direction

**Technical reference** — facts and technical details worth capturing
- Key technical details, explanations, specifications
- Whether it merits an atomic note or appending to an existing note
- Cross-reference with existing technical notes (e.g., `[[Bridging Work Framework]]`, specs, formal analysis docs) via QMD search

**Waiting-for items** — others' commitments the user should track
- Who, what, timeline if mentioned
- Related project
- `~Waiting` annotation format

**Cross-team coordination items** — agreements that span teams or workstreams
- Agreements between teams or individuals
- Shared timelines, handoff points, deliverable dependencies
- Who needs to know what, and by when

**Ideas and future work** — brainstorms and seeds
- Brainstorms, potential improvements, research questions
- Route to Someday Pool, relevant project, or new project depending on scope

It is entirely valid for a transcript to yield nothing in some or all categories. Flag that clearly without making it feel like a failure.

## Step 4: Present the integration plan

Structure the plan clearly. For each proposed change, include destination, content, and rationale:

```
## Integration Plan: [Transcript Name]

### Context
[Frame from Step 2 — meeting type, participants (wikilinked), related projects, date, organizational context]

### Actions (X items)
- [ ] **[GTD-phrased action]** → [[Destination]] | Priority: [if flagged] | Deadline: [if any]

### Decisions (X items)
- [ ] **[Decision]** → [[Project]] > Context | Type: [tech/product/org] | [Date]

### Blockers & Dependencies (X items)
- [ ] **[Blocker description]** → [[Project]] > Context | Blocked by: [who/what] | Criticality: [high/medium/low]

### Project Updates (X items)
- [ ] **[What to update]** → [[Project]] > [Section] | [Proposed content]

### Technical Reference (X items)
- [ ] **[Proposed title or append target]** → Notes/ or append to [[existing note]] | Links: [[...]]

### Waiting-For (X items)
- [ ] **[Person] to [action]** → [[Destination]] | Timeline: [if mentioned]

### Cross-Team Items (X items)
- [ ] **[Agreement/handoff]** → [[Destination]] | Parties: [who] | By: [when]

### Ideas & Future Work (X items)
- [ ] **[Idea]** → [[Someday Pool]] or [[project]] or new project
```

**Pause here.** Ask the user which items to execute, modify, or skip. The user might approve all, cherry-pick, rephrase items, or redirect destinations. Wait for their input before proceeding.

## Step 5: Execute approved changes

For each approved item, apply using proper conventions:

- **Actions**: `- [ ] Verb phrase ~hints` in target note's Actions section
- **Decisions**: Dated entry in project Context section with decision type noted
- **Blockers**: Dated entry in project Context with `**Blocker:**` prefix and resolution path if known
- **Project updates**: Dated entry in the Context or Notes section
- **Technical reference**: Create via `obsidian create` in `Notes/` with full frontmatter (categories, areas, status, tags, created) and wikilinks. Cross-reference with existing technical notes via QMD search before creating new notes — prefer appending to existing notes when the content fits.
- **Waiting-for**: Add with `~Waiting` annotation in target note's Actions section
- **Cross-team items**: Add to all affected project notes, not just the primary one
- **Ideas**: Add to Someday Pool or create someday project via `/create-project`

Follow the proactive linking checklist: frontmatter, areas links, project links, related notes, verify categories/areas properties.

## Step 6: Update related projects

For each project touched during processing:
- Add relevant items to the project's action menu, context, or notes sections
- Update project status/constraints if the meeting revealed changes
- Add a link to the transcript note from the project note (bidirectional)

## Step 7: Handle the transcript note

Check the transcript note's current state and enrich:

- **Frontmatter**: Apply the correct schema based on meeting type:
  - *One-off meetings* → meeting note schema: `meeting-type`, `participants` (wikilinked where possible), `meeting-date`
  - *Recurring series* → transcript schema: `course` (series name), `session` (number), `session-date`
  - *Both always get*: `categories: ["[[Transcripts]]"]`, `areas: ["[[Work]]"]`, `tags: [transcript, work, ...]`, `people: [...]` (wikilinked participants)
  Add or fix any missing fields.

- **Summary section**: If the transcript lacks a `## Summary`, offer to add one with: session type, participants (wikilinked), date, primary project, and key content bullet points.

- **Links**: Add bidirectional links to all projects/areas touched during processing.

- **Location**: If in `Inbox/`, suggest moving to `Notes/`. If already organized, leave it.

## Step 8: Summary and commit

Report:
- Items integrated by category (with counts)
- Notes created (with paths)
- Notes modified (with paths)
- Items skipped
- Observations — recurring themes across meetings, friction signals, cross-meeting continuity, blocker trends

Commit all changes: "Process work transcript: [Meeting Name]"

---

## Quality Standards

- **Plan first, execute on approval** — never modify vault notes until the user confirms
- **Distinguish ownership** — only add user-owned actions to the system; others' actions become waiting-for items
- **Respect nebulosity** — when content is ambiguous, flag it: "This could be a decision or just discussion — which feels right?"
- **Match existing style** — mirror the GTD-actionable phrasing and formatting in existing project notes
- **Don't over-extract** — work meetings have filler, social chat, technical tangents, and logistics that aren't integration material
- **Preserve provenance** — note which transcript produced each extracted item
- **Handle series** — for recurring meetings, check previous transcripts for continuity and evolving themes
- **Blocker awareness** — blockers are first-class items, not hidden in insights or project updates. Explicitly connect blockers to the projects they affect and note criticality.
- **Priority signals** — when language in the meeting signals priority ("this is critical", "most urgent", "blocking everything"), capture that signal in the integration plan
- **Cross-team visibility** — items that affect multiple projects or teams get routed to all affected destinations, not just the primary project
- **Participant resolution** — always resolve known colleagues to wikilinks using the Work area note's key people list
