---
name: deep-review
description: "Deep review — the full weekly review. Process all inboxes to zero, audit projects and areas, get creative. ~30 min. Use when: 'deep review', 'weekly review', 'full review'."
disable-model-invocation: true
---

# Deep Review (~30 min)

You are running the user's deep review — the full weekly review. This has three phases. Take each phase conversationally — present findings and options, don't rush. The user drives decisions.

This is the ONLY session that processes inboxes to zero.

---

## Phase 1: Get Clear

Process ALL inboxes to zero.

### 1. Process capture inboxes (Drafts + Obsidian)

Run `/process-inbox` — unified scan-classify-confirm-execute workflow for both Drafts inbox and Obsidian `Inbox/`. Claude scans all items, auto-classifies, groups by action type, presents a numbered summary, user confirms/overrides, then Claude executes in batch. See that skill for the full three-pass workflow.

### 2. Process email inbox

Scan unread emails using `mcp__mail__get_emails` (unread, limit 25). Group by actionability:
- **Needs response** → Offer to draft a reply via `mcp__apple-mail__create-draft`
- **Contains action item** → Capture to project or `[[Action Pool]]`
- **Reference worth keeping** → Capture to vault
- **Newsletter/FYI** → Mark as read or defer

### 3. Scan daily notes

```
obsidian search query="path:Daily/" vault="{{VAULT_NAME}}" limit=7
```

Check this week's daily notes for uncaptured items, friction patterns, energy/mood trends.

### 4. Physical inbox prompt

Ask: "Anything in your physical space that needs capturing?"

---

## Phase 2: Get Current

### 6. Audit active projects

Search for all notes with `categories: ["[[Projects]]"]` and `status: active`. For each project:
- Are there unchecked actions that still make sense?
- Has the project stalled? (No completions + not modified in 30+ days)
- **Friction detection**: Actions appearing across multiple reviews without progress? Surface the pattern.
- Should any projects be completed or moved to `status: someday`?

### 7. Audit Action Pool

Read `[[Action Pool]]`. Friction detection on standalone actions — items sitting across multiple reviews without progress.

### 8. Daily note retrospective

Read this week's daily notes (from Phase 1's daily note scan, or re-read via `obsidian search query="path:Daily/" vault="{{VAULT_NAME}}" limit=7`). For each day, compare `## Today's Options` against `## Done Today`:

- **Carried but never done**: Items that appeared in Today's Options across multiple days but never made it to Done Today. These are friction signals — misalignment between intention and energy/context.
- **Energy/mood correlation**: Cross-reference `energy` and `mood` frontmatter with completion patterns. Do certain action types only get done on high-energy days?
- **Emerging patterns**: Actions from the same project or area repeatedly deferred suggest systemic friction, not individual laziness.

Surface findings conversationally: "I noticed X appeared three times this week but never got done — is something blocking it, or has the purpose shifted?"

### 9. Audit areas

Read area notes in `Notes/`. Check each area for neglected responsibilities. Surface leisure collection notes gently as options.

### 9a. Defense pattern review (Tier 2)

Weekly scan of shadow pattern activity. Read this week's daily note `## Observations` sections and gather any pattern-related notes. Present a brief summary:
- Patterns that appeared this week (with frequency and domain)
- Contradictions detected (pattern didn't fire when expected) — celebrate these
- Any new patterns not yet documented
- Friction patterns from Step 8's daily note retrospective that map to documented defense triggers

If contradictions were detected, append them to the user's defense pattern document `### Contradictions` section. If a new undocumented pattern emerged, flag it: "This pattern isn't documented yet — worth adding?"

### 10. Calendar review

Read **past week** and **upcoming week** from Apple Calendar using `mcp__apple-events__calendar_events`. Note:
- Follow-ups needed from past events
- Upcoming commitments that need preparation
- Schedule conflicts to flag

### 11. Day-specific routine review

Read full `[[Day-Specific Routines]]`. Ask: "Are these still working? Anything to add, remove, or adjust?"

### 12. Day-specific actions

Surface today's items from `[[Day-Specific Routines]]` (e.g., "Balance finances" on Friday).

### 13. Vault health

Run vault health checks:
```bash
obsidian orphans vault="{{VAULT_NAME}}"
obsidian deadends vault="{{VAULT_NAME}}"
obsidian unresolved vault="{{VAULT_NAME}}"
```

Optionally dispatch the **vault-organizer** agent for structural health and the **contradictions-resolver** agent for semantic consistency.

Review orphans for any that should be connected to existing areas or categories.

### 14. Workbench check

Search for all notes in `Workbench/` (`obsidian search query="path:Workbench/" vault="{{VAULT_NAME}}"`):
- **Ready to integrate** (`status: ready`): Present list, offer `/integrate-workbench` for each
- **Stale** (unchanged 30+ days, `status: drafting`): "These workbench items haven't been touched in 30+ days: [list]. Still active work, ready to integrate, or safe to delete?"
- **Paused** (`status: paused`): Mention count only — intentionally on hold
- Report total workbench count

This is a review checkpoint — the user decides what to do with each item.

---

## Phase 3: Get Creative

### 15. Someday review

Read `[[Someday Pool]]` and any projects with `status: someday`. Use `mcp__qmd__query` to find connections between someday items and active projects — a `vec` search may surface relevant context. Also check leisure collection notes.

### 16. Rule of 3

Help the user pick **three desired outcomes** for the coming week — what would make the week feel successful?

### 17. Celebrate wins

Ask about this week's accomplishments. Acknowledge progress and completed projects.

### 18. Ontological remodeling

Ask: "Are your current project and area categories working well? Anything that should be merged, split, or reframed?" Use `mcp__qmd__query` to check for conceptual overlaps.

---

## After the review

Summarize:
- Inbox status (should be zero)
- Project health overview (active count, stalled, completed)
- Rule of 3 outcomes for the week
- Items that need attention

Commit all vault changes.
