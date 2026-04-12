---
name: process-llm-conversation
description: "Analyze an exported LLM conversation (Claude, ChatGPT, Gemini, etc.) and produce an integration plan for the Weave system. Extracts knowledge, decisions, action items, content produced, research findings, and ideas — then presents a structured plan for user approval before making any vault changes. Use when the user says 'process llm conversation', 'process this chat', 'import conversation', 'extract from conversation', 'process chatgpt', 'process claude chat', or 'what came out of this conversation'."
argument-hint: "[conversation note name, file path, or export location]"
---

# Process LLM Conversation

Analyze the exported LLM conversation referenced in "$ARGUMENTS" and produce a structured integration plan. Never make vault changes without user approval.

**Key distinction from `/process-transcript`:** A meeting transcript is a record of what happened between people. An LLM conversation is a record of *thinking and producing* with an AI collaborator. The extraction taxonomy reflects this — prioritizing knowledge gained, content produced, and decision reasoning over multi-party dynamics and waiting-for items.

## Dynamic Context

### Active projects
!`obsidian search query="categories: Projects" vault="{{VAULT_NAME}}" limit=30 2>/dev/null || echo "(Could not scan projects)"`

### Action Pool
!`obsidian read file="Action Pool" vault="{{VAULT_NAME}}" 2>/dev/null || echo "(Could not read Action Pool)"`

### Someday Pool
!`obsidian read file="Someday Pool" vault="{{VAULT_NAME}}" 2>/dev/null || echo "(Could not read Someday Pool)"`

---

## Step 1: Locate and read the conversation

Parse "$ARGUMENTS" to find the source. Try in order:
1. `obsidian read file="$ARGUMENTS" vault="{{VAULT_NAME}}"` (note name)
2. `obsidian read path="$ARGUMENTS" vault="{{VAULT_NAME}}"` (path)
3. `obsidian search query="$ARGUMENTS" vault="{{VAULT_NAME}}"` (search)
4. If a raw file path outside the vault, read it directly with the Read tool

If not found, ask the user for clarification.

### Format detection

Handle the input format:
- **Markdown** (most common) — user copied conversation from web UI or exported via browser extension. Look for role markers (`#### You:` / `#### ChatGPT:`, `Human:` / `Assistant:`, `**User**:` / `**Claude**:`, etc.). Read directly.
- **JSON** (ChatGPT/Claude export) — single-conversation JSON. Parse the tree structure (`mapping` with message nodes, traverse from `current_node` following `parent` pointers) and reconstruct into readable form. **Single conversations only** — user pre-selects before invoking. No bulk export scanning.
- **Raw text** — conversation pasted directly. Heuristic parsing via role markers.

If the format is unrecognizable, ask the user rather than guessing.

Read the full conversation — context matters for proper extraction.

## Step 2: Establish the frame

Before extracting anything, identify:
- **Platform**: Claude, ChatGPT, Gemini, other
- **Model** (if identifiable): GPT-4, Claude 3.5 Sonnet, etc.
- **Primary purpose(s)**: research, drafting, problem-solving, brainstorming, learning, building, planning
- **Related projects/areas**: scan active projects list for keyword matches. If conversation language doesn't obviously match project names, also use `mcp__qmd__query` with a `vec` sub-query of the conversation's key topics + `intent` "finding related projects and areas for this conversation." See the `qmd` rule for query construction patterns.
- **Approximate date**: from metadata, content clues, or file dates
- **Conversation arc**: where it started, key turns, where it ended — the trajectory of thinking

Present this context summary briefly. Getting the frame right matters — a research conversation produces different output than a brainstorming session or a code debugging session.

## Step 3: Deep analysis

Analyze the full conversation. Extract everything with potential integration value using this conversation-specific taxonomy:

**1. Knowledge gained** — things the user learned or synthesized
- New understanding, frameworks, mental models
- Technical knowledge, how-tos, explanations
- Whether it merits an atomic note or appending to an existing note

**2. Content produced** — drafts, plans, code, templates, structured outputs
- What was created and its current state (rough draft, polished, partial)
- Whether it should be preserved as-is or refined
- Where it belongs in the vault

**3. Decisions made** — choices the user worked through
- What was decided, the reasoning, and any caveats
- Which project/area the decision affects

**4. Action items identified** — things to do that emerged from the conversation
- GTD-actionable phrasing (starts with a verb)
- Related project/area
- Whether the user *committed* to the action or was just *exploring* it
- Energy/time hints if apparent

**5. Research findings** — information the AI surfaced that has reference value
- Sources, data, comparisons
- Whether it warrants a standalone note

**6. Ideas and explorations** — creative threads, "what if" thinking, possibilities opened
- Ideas for later, possible future projects
- Connections to existing vault knowledge

**7. Project context updates** — information that changes project state
- Progress made, new constraints, scope changes, timeline shifts

**8. Preferences and patterns** (meta) — what the conversation reveals about how the user thinks
- Only surface if genuinely useful for system calibration
- Always present as observations, never judgments

It is entirely valid for a conversation to yield nothing in some or all categories. Flag that clearly without making it feel like a failure.

## Step 4: Present the integration plan

Structure the plan clearly. For each proposed change, include destination, content, and rationale:

```
## Integration Plan: [Conversation Topic]

### Context
[Frame from Step 2]

### Knowledge Notes (X items)
- [ ] **[Topic]** -> Notes/ | Categories: [[Research]] | Links: [[...]]

### Content to Preserve (X items)
- [ ] **[What was produced]** -> [destination] | State: [draft/polished/partial]

### Decisions (X items)
- [ ] **[Decision]** -> [[Project/Area]] > Context | Reasoning: [brief]

### Actions (X items)
- [ ] **[GTD-phrased action]** -> [[Destination]] | Commitment: [committed/exploring]

### Research Findings (X items)
- [ ] **[Finding]** -> Notes/ or append to [[existing note]]

### Ideas (X items)
- [ ] **[Idea]** -> [[Someday Pool]] or new project

### Project Updates (X items)
- [ ] **[What to update]** -> [[Project]] > [Section]

### Observations (if any)
[Meta-observations about patterns, preferences, or system implications]

```

**Pause here.** Ask the user which items to execute, modify, or skip. The user might approve all, cherry-pick, rephrase items, or redirect destinations. Wait for their input before proceeding.

## Step 5: Execute approved changes

For each approved item, apply using proper conventions:

- **Knowledge notes**: Create via `obsidian create` in `Notes/` with full frontmatter (categories: ["[[Research]]"], areas, status, tags, created) and wikilinks
- **Content produced**: Appropriate location based on type (project note, Notes/, new note)
- **Actions**: `- [ ] Verb phrase ~hints` in target note's Actions section. Mark commitment level for exploring items: `~exploring`
- **Decisions**: Dated entry in project Context section with reasoning
- **Research findings**: Atomic note in `Notes/` or append to existing note
- **Ideas**: Add to Someday Pool or create someday project via `/create-project`
- **Project updates**: Dated entry in project Context or Notes section
Follow the proactive linking checklist: frontmatter, areas links, project links, related notes, verify categories/areas properties.

## Step 6: Handle the source conversation note

If the conversation was saved as a vault note:
- **Frontmatter**: Ensure conversation schema fields are present:
  - `categories: ["[[Transcripts]]"]`
  - `tags: [llm-conversation, {platform}]` (e.g., `llm-conversation`, `chatgpt`, `claude`, `gemini`)
  - `source-platform`: "Claude" / "ChatGPT" / "Gemini" / etc.
  - `conversation-date`: YYYY-MM-DD
  - `conversation-type`: primary purpose from Step 2

- **Links**: Add bidirectional links to all projects/areas touched during processing.
- **Location**: If in `Inbox/`, suggest moving to `Notes/`.
- **Retention**: Offer the user the choice:
  - Keep the raw conversation as-is
  - Set `status: completed` (processed, no longer actively referenced)
  - Summarize/compress it (replace verbose content with a summary, preserving key excerpts)

## Step 7: Summary and commit

Report:
- Items integrated by category (with counts)
- Notes created (with paths)
- Notes modified (with paths)
- Items skipped
- Observations — patterns noticed if this isn't the first conversation processed

Commit all changes: "Process LLM conversation: [Conversation Topic]"

---

## Quality Standards

- **Plan first, execute on approval** — never modify vault notes until the user confirms
- **Distinguish commitment levels** — "I should do X" is different from "one option would be X". Mark actions as committed vs. exploring.
- **Respect nebulosity** — when content is ambiguous, flag it: "This could be an action or an idea — which feels right?"
- **Match existing style** — mirror the GTD-actionable phrasing and formatting in existing project notes
- **Don't over-extract** — casual back-and-forth, prompt iteration, debugging cycles, and AI pleasantries are not integration material
- **Deduplicate against vault** — check if knowledge/findings already exist before proposing new notes. Use QMD to search semantically.
- **Preserve provenance** — note which conversation produced each extracted item
- **Adapt to conversation type** — a research conversation produces different output than a drafting session or a brainstorming session. Let the content determine which categories matter.
- **Handle format diversity** — gracefully parse markdown, JSON, or raw text exports. Ask if unclear.
