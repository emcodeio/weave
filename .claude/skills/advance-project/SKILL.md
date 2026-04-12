---
name: advance-project
description: "Record what was accomplished and advance a project or Action Pool item. Takes a natural language description of the achievement, updates completions, project context, notes, and surfaces what's next. Use when the user says 'advance', 'done', 'I finished', 'I did', 'mark done', 'update the project', or describes completing work."
argument-hint: "[what was achieved]"
---

# Advance Project

Record the achievement described in "$ARGUMENTS" and update the system accordingly.

## Steps

### 1. Understand the achievement

Parse "$ARGUMENTS" for:
- **What was done** — the substance of the achievement
- **Which project** — explicit name, or infer from context
- **Scope** — does it map to a specific action, multiple actions, or something not on the menu?

If "$ARGUMENTS" is empty or vague (e.g., just a project name), ask: "What did you accomplish?"

### 2. Find the source

Search for the matching project by name or by `categories: ["[[Projects]]"]`, and check `[[Action Pool]]`. If the user's description doesn't obviously match a project name, also use `mcp__qmd__query` with a `vec` sub-query + `intent` "finding the project this completed work belongs to." Read the full note.

**If ambiguous** — multiple projects could match → present the matches and ask.
**If no match** — the achievement may be new work. Ask: "This doesn't seem to match an existing project. Should I add it to an existing project, create a new one, or log it to Action Pool?"

**Workbench check**: Search `Workbench/` for items with a `project` field linking to this project (Grep for the project name in Workbench frontmatter). If workbench items exist, note them — the achievement may relate to workbench content rather than (or in addition to) a project action.

### 3. Match to existing actions

Compare the achievement against unchecked actions in the note. Determine which scenario applies:

- **Clear single match** — the achievement maps to one checkbox. Confirm briefly: "Looks like this completes '[action text]' — sound right?"
- **Multiple matches** — the work spans several checkboxes. Present them: "This seems to cover these actions — which ones are done?" Let the user confirm.
- **Partial match** — the achievement relates to a checkbox but doesn't fully complete it. Note this: "This advances '[action text]' but it sounds like there's more to do. Want to keep it open, rephrase it, or split it?"
- **No match** — the achievement doesn't correspond to any existing action. That's fine — proceed to record it as a completion anyway. Suggest: "This wasn't on the action menu. I'll add it to Completed as work done. Want to also remove or update any existing actions this affects?"

### 4. Update the note

Apply all relevant updates to the project note (or Action Pool). Present the planned changes to the user before writing.

**Completed section** (always):
- Mark matched actions as `- [x] Action text — YYYY-MM-DD` and move to `## Completed` (newest first)
- For no-match achievements, add a new completed entry describing the work
- Preserve any existing sub-bullets on matched actions; add sub-detail from the user's description if it enriches the record

**Actions section** (if needed):
- Remove checked-off actions from the menu
- If the user identifies new actions that emerged from the work, add them
- If an existing action needs rephrasing (scope changed), update it

**Context section** (if the project has one and the achievement changes project context):
- Append a dated entry for significant context shifts (e.g., new decisions, changed circumstances)
- Don't rewrite existing context — add to it

**Notes section** (if the project has one):
- If there's a "Current focus" line that's now stale, update it to reflect the new state
- For significant milestones, append a brief dated entry

**Goal/Outcome** (rarely):
- Only flag if the achievement fundamentally changes the project's goal. Don't auto-edit — ask the user.

**Workbench status sync**: If the achievement relates to a workbench item (e.g., "finished the draft," "spec is ready for review"), offer to update the workbench item's `status`. "The workbench item [[name]] is `drafting` — should I change it to `ready`?"

### 5. Sync daily note

Read today's daily note (`obsidian daily:read vault="{{VAULT_NAME}}"`). If the completed action(s) appear in `## Today's Options`:
- Mark as `- [x]` in place in Today's Options
- Add to `## Done Today` as `- [x] Action text — [[Project Name]] — YYYY-MM-DD`

### 6. Surface what's next

Present the remaining action menu from the project — options the user *could* work on, not prescriptions. If the achievement shifted context, note how it changes what's available.

For Action Pool items, show the remaining Actions section.

**If no actions remain**: "All actions are done. Is the project complete? If so, I can run `/complete-project`."

If the project has workbench items with `status: ready`, mention: "[[item name]] is marked ready to integrate — want to run `/integrate-workbench`?"

### 7. Offer follow-ups

Based on context, offer (don't push) any that apply:
- Create an Apple Reminder if a remaining action has a hard deadline
- Update related project notes that cross-reference this one
- Capture reference material surfaced during the work as a vault note

### 8. Quick consistency check

Before committing, run three fast inline checks on the just-updated project:
- Any `- [x]` items still in `## Actions`? (Move them to `## Completed` now)
- All actions complete and none remaining? (Ask: "All actions are done — ready to mark complete?")
- Did the completed work relate to a capability described in system docs? (Note if system docs need updating)

This is a lightweight inline check. The full contradiction scan runs during weekly review.

### 9. Commit

Commit all changed files to git: "Advance [Project Name]: [brief achievement summary]"

## Edge Cases

- **Action Pool item**: Same flow, but source is `[[Action Pool]]`. No Context/Notes sections — just move action to Completed and sync daily note.
- **Multiple projects affected**: Handle the primary project first, then ask: "This also relates to [[Other Project]] — want to update that too?"
- **Someday project advanced**: If the project has `status: someday`, ask: "This project is marked someday — want to change it to active?"
- **Project not found**: Search broadly, then suggest `/create-project` if truly new.
- **Simple completion**: If the description clearly maps to one action with no context changes needed, keep it lightweight — confirm, check, move, show menu. Don't force a full context review on routine completions.
