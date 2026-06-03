# Work Profile (process-transcript)

Loaded by `/process-transcript` when Step 2 detects the **work** frame. Adds work-domain context, meeting-type emphasis, participant→wikilink resolution, blocker and cross-team categories, and the dual frontmatter schema. Read alongside the generalist spine — this profile supplies the deltas for Steps 2–7, not a parallel workflow.

## Additional Dynamic Context to Load (Step 2)

When the work frame is confirmed, also read:
- **Work area note** (key people, organizational landscape, active workstreams): `obsidian read file="Work" vault="{{VAULT_NAME}}"`

## Step 2 deltas — establish the work frame

In addition to the common framing (participants, related projects, date/series):

- **Meeting type** — detect from content and participants:
  - *Status/standup* — regular team updates, progress reports
  - *1:1 technical* — deep technical discussion between two people
  - *Cross-team coordination* — multiple teams/workstreams aligning
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

- **Participant resolution** — list all speakers. Resolve names against the key-people list in the Work area note; produce wikilinks for people with vault notes (e.g., "Jordan" → `[[Jordan Reeves]]`). Unknown participants stay plain text. Note which speaker is the user.
- **Organizational context** — note which workstream(s) this touches (from the Work area note's current landscape).
- **Series** — for recurring meetings (weekly status, recurring 1:1), check prior notes in the series via `obsidian search`.

Ask for corrections before extracting — frame quality determines extraction quality.

## Step 3 deltas — work extraction taxonomy

Replaces the generic taxonomy. Weight categories by the detected meeting type — primary thoroughly, secondary when clearly present.

**Action items** — things the user needs to do. GTD phrasing; related project/area; energy/time hints, deadlines; priority signal if discussed ("this is the critical piece", "most urgent").

**Decisions made** — what was decided, who was involved; **decision type: technical / product / organizational**; which project/area; caveats/conditions. Routing: technical → project Context or dedicated note; product/org → project Context.

**Blockers and dependencies** *(first-class — work-specific)* — what's blocked and by whom/what; project(s) affected; criticality (passing mention vs. "blocking everything"); resolution path if discussed. A blocker owned by someone else is also a waiting-for.

**Project context updates** — status shifts, new constraints, timeline changes, completed work, scope/priority shifts, leadership directives that change direction.

**Technical reference** — key details, explanations, specifications; atomic note vs. append; cross-reference existing technical notes (e.g., an existing framework or spec note) via QMD before creating.

**Waiting-for items** — who, what, timeline; related project; `~Waiting` format.

**Cross-team coordination items** *(work-specific)* — agreements spanning teams/workstreams; shared timelines, handoff points, deliverable dependencies; who needs to know what by when.

**Ideas and future work** — brainstorms, improvements, research questions → Someday Pool, relevant project, or new project by scope.

Valid for a transcript to yield nothing in a category — flag without making it feel like failure.

## Step 4 delta — work integration-plan template

```
## Integration Plan: [Transcript Name]

### Context
[Meeting type, participants (wikilinked), related projects, date, organizational context]

### Actions (X items)
- [ ] **[GTD-phrased action]** → [[Destination]] | Priority: [if flagged] | Deadline: [if any]

### Decisions (X items)
- [ ] **[Decision]** → [[Project]] > Context | Type: [tech/product/org] | [Date]

### Blockers & Dependencies (X items)
- [ ] **[Blocker]** → [[Project]] > Context | Blocked by: [who/what] | Criticality: [high/medium/low]

### Project Updates (X items)
- [ ] **[What to update]** → [[Project]] > [Section] | [Proposed content]

### Technical Reference (X items)
- [ ] **[Title or append target]** → Notes/ or append to [[existing note]] | Links: [[...]]

### Waiting-For (X items)
- [ ] **[Person] to [action]** → [[Destination]] | Timeline: [if mentioned]

### Cross-Team Items (X items)
- [ ] **[Agreement/handoff]** → [[Destination]] | Parties: [who] | By: [when]

### Ideas & Future Work (X items)
- [ ] **[Idea]** → [[Someday Pool]] or [[project]] or new project
```

## Step 5 deltas — execution conventions

- **Decisions**: dated entry in project Context with decision type noted
- **Blockers**: dated entry in project Context with `**Blocker:**` prefix and resolution path if known
- **Technical reference**: cross-reference existing technical notes via QMD before creating; prefer appending when the content fits
- **Cross-team items**: add to **all** affected project notes, not just the primary one
- (Actions, project updates, waiting-for, ideas follow the spine's generic conventions)

## Step 6 delta — dual frontmatter schema

Apply by meeting type:
- *One-off meetings* → meeting-note schema: `meeting-type`, `participants` (wikilinked where possible), `meeting-date`
- *Recurring series* → transcript schema: `course` (series name), `session` (number), `session-date`
- *Both always get*: `categories: ["[[Transcripts]]"]`, `areas: ["[[Work]]"]`, `tags: [transcript, work, ...]`, `people: [...]` (wikilinked participants)

Offer a `## Summary` (session type, participants wikilinked, date, primary project, key bullets) if missing.

## Work-frame Quality Standards (additive)

- **Blocker awareness** — blockers are first-class, not buried in insights/updates; connect each to the projects it affects and note criticality
- **Priority signals** — capture meeting language signaling priority ("critical", "most urgent", "blocking everything")
- **Cross-team visibility** — route multi-project/multi-team items to all affected destinations
- **Participant resolution** — always resolve known colleagues to wikilinks via the Work area note's key-people list

Suggested commit message: `"Process work transcript: [Meeting Name]"`.
