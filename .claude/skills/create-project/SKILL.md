---
name: create-project
description: "Create a new project with an Obsidian note. Sets up action menu, Bases views and proactive linking. Use when the user says 'new project', 'start a project', 'create a project for', or when processing inbox items that need a multi-step project."
argument-hint: "[project-name]"
---

# Create Project

Create a new project named "$ARGUMENTS" with an Obsidian project note.

## Steps

### 1. Clarify project details
Gather from the user (skip what's already known from context):
- **Project name** (use $ARGUMENTS if provided)
- **Areas** — which area(s) of responsibility it belongs to
- **Outcome** — what does "done" look like?
- **Status** — active or someday? (default: active)
- **Initial actions** — at least 2 (a project needs 2+ actions; single actions go to Action Pool). For someday projects, rough action ideas are fine.
- **Deadline** — if any

### 2. Create Obsidian project note
Use Obsidian CLI to create the note in `Notes/`:

```bash
obsidian create path="Notes/$PROJECT_NAME.md" vault="{{VAULT_NAME}}" silent content="..."
```

The note must include:

**Frontmatter:**
```yaml
---
categories: ["[[Projects]]"]
status: active | someday
areas: []
tags: []
created: YYYY-MM-DD
---
```

Set `status` to the choice from Step 1.

**Body:**
```markdown
**Deadline:** YYYY-MM-DD (if applicable)

## Outcome
[What does "done" look like?]

## Context
[Why does this project matter? What prompted it?]

## Actions
- [ ] First action
- [ ] Second action
- [ ] ...

## Completed

## Reference
- [[]]

## Notes
```

Actions are an unordered menu — the user picks based on energy, context, and interest. Only enforce ordering for genuine dependencies. Optionally suggest energy/time hints: `~focused`, `~quick`, `~2h`.

### 3. Offer deadline reminder
If the project has a hard deadline, offer to create an Apple Reminder for it. Skip for someday projects.

### 4. Proactive linking
Follow the linking checklist:
1. `areas` property handles area link; verify area note exists
2. Search the vault for related notes and add wikilinks
3. Verify `categories` value has corresponding category note

### 5. Commit
Commit the new project note and any modified files to git.
