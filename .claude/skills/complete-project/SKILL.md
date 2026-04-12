---
name: complete-project
description: "Complete a finished project. Sets status to completed, cleans daily note, and offers retrospective. Use when the user says 'complete project', 'project is done', 'close out this project', or when all actions are complete."
argument-hint: "[project-name]"
---

# Complete Project

Complete the project "$ARGUMENTS".

## Steps

### 1. Confirm completion
Search for the project note by name or by `categories: ["[[Projects]]"]` matching "$ARGUMENTS". Review the action list with the user — confirm the project is truly complete. Check for any uncaptured follow-ups or reference material worth preserving.

If "$ARGUMENTS" is empty, list active projects and ask which to complete.

### 2. Resolve outstanding actions
Review any remaining unchecked actions in the project. For each one, determine its disposition with the user:

- **No longer needed** — the project outcome was achieved without it. Strike through and move to `## Completed`:
  `- [x] ~~Action text~~ — not needed for completion — YYYY-MM-DD`
- **Still wanted but separate from this project** — move to `[[Action Pool]]` or another project
- **Deferred / someday** — move to `[[Someday Pool]]`

Present the remaining actions as a batch: "These actions are still unchecked. For each, should I mark as not needed, move to Action Pool, or move elsewhere?"

The goal: when a project is `status: completed`, its Actions section should be empty — everything resolved to Completed, Action Pool, or Someday Pool.

### 3. Audit parent references

Search for notes that link to this project: `obsidian backlinks file="$PROJECT_NAME" vault="{{VAULT_NAME}}"`. For each backlink result:
- Read the linking note's Reference section (if it has one)
- If the reference annotation contains stale status info (e.g., "active", a phase number, or other state that contradicts the now-completed status), flag it
- Present proposed updates to the user: "These notes reference this project with outdated annotations. Update them?"
- Apply approved changes

This prevents parent/sibling project notes from accumulating stale sub-project descriptions.

### 4. Clean daily note
Read today's daily note (`obsidian daily:read vault="{{VAULT_NAME}}"`). Remove any items referencing this project from `## Today's Options`. Mention what was removed (if anything).

### 5. Update status
```bash
obsidian property:set name="status" value="completed" file="$PROJECT_NAME" vault="{{VAULT_NAME}}"
```

### 6. Offer retrospective
Ask: "Any lessons learned or reference worth preserving from this project?" If yes, append to the project's Notes section, or create a standalone note in `Notes/` with appropriate `categories`. If no, move on.

### 7. Commit
Commit all changes (updated project note, daily note) to git.

## Notes
- Completion is a property change (`status: completed`), not a file move — notes stay in `Notes/`
- The note remains in the vault and is still searchable
- Backlinks from other notes continue to work
- Bases views automatically filter completed projects from active views
- Daily note cleanup prevents stale references from surfacing in future reviews
