---
name: open-workbench
description: "Open a workbench item for focused work. Loads working context, surfaces related vault knowledge, shows recent activity, and orients for a work session. Use when: 'let's work on', 'open the spec', 'pick up where we left off', 'work on [item]', or names a workbench item."
argument-hint: "[workbench-item-name or topic]"
---

# Open Workbench: $ARGUMENTS

Load context for focused work on a workbench item, then transition to Partner-level collaborative work. This skill orients — the user drives the actual work.

## Dynamic Context

### Workbench items
!`obsidian search query="path:Workbench/" vault="{{VAULT_NAME}}" 2>/dev/null || echo "(Could not scan workbench)"`

---

## Steps

### 1. Find the item

Parse "$ARGUMENTS" and search `Workbench/` by name from the dynamic context above. If the name is vague or partial, use `mcp__qmd__query` with a `vec` sub-query and `intent` "finding the workbench item the user wants to work on."

If "$ARGUMENTS" is empty, list all workbench items grouped by status and recency (most recently modified first). Ask which to open.

### 2. Identify the cluster

A workbench "item" may be a single file or a cluster of related files. Check:

- **`project` field** — If the item has a `project` frontmatter field, read the parent project note.
- **Shared project** — Search `Workbench/` for other items with the same `project` value or matching tags.
- **Subdirectory siblings** — If the item is in a subdirectory (e.g., `Workbench/LEAP/`), note sibling files.
- **Working Context file** — Check for a "Working Context" or index file in the cluster. If one exists, it's the primary orientation document.

### 3. Load context

Read (in parallel where possible):

- **Primary item** — The workbench file itself (or Working Context index if one exists)
- **Parent project** — Read the project note, especially: `## Actions` (unchecked items), `## Context` (recent entries), `## Completed` (last 5-10 entries for momentum)
- **Recent activity** — Use QMD `lex` search for the item or project name across `Daily/` notes from the last 5 days. Surface any relevant Log entries, Done Today items, or Observations.
- **Ready items** — If any cluster members have `status: ready`, note them (may need `/integrate-workbench` before more work).

### 4. Present orientation

A concise briefing — not exhaustive, just enough to orient:

**What this is** — One-line description of the workbench item/cluster and its purpose.

**Current state** — Status, last modified dates, and recent accomplishments from the project's Completed section.

**Cluster contents** (if multi-file) — List related workbench files with their status and last-modified date.

**Open threads** — Unchecked actions from the parent project that relate to this workbench work. These are options, not a prescription.

**Recent context** — Anything relevant from the last few daily notes: decisions, observations, reviewer feedback, energy patterns around this work.

End with: **"That's the current state. What would you like to work on?"**

### 5. Transition to Partner mode

The skill's job is done. Claude is now in Partner mode with full context loaded. The user drives the work session — Claude brings relevant vault knowledge, handles structure, and maintains conventions.

## Notes

- This skill is a **context loader**, not a multi-phase interview. It should take under a minute to run, then get out of the way.
- If the workbench item has no parent project and no cluster, the orientation is simpler: just the file's content, status, and any vault notes that reference it.
- Don't load the entire content of large workbench files (1000+ lines) during orientation. Read the first 50-100 lines for context, then read specific sections as the work session progresses.
