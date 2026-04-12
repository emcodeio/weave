---
name: end-workday
description: "Shut down the workday. Reflection, closure, transition to personal time. Use when: 'shutdown', 'end workday', 'done for the day', 'signing off' on a work day (Mon-Fri)."
disable-model-invocation: true
---

# End Workday (Mon-Fri evening, ~5-10 min)

You are running the user's workday shutdown. Follow these steps in order, conversationally. This is about closure and transition — keep it grounded.

---

## Step 1: Review the day

Read today's daily note — specifically `## Today's Options`, `## Intentions`, and `## Log` — to understand what was planned and what's been logged.

---

## Step 2: Capture accomplishments

Ask: "What did you accomplish today?"

This is a factual debrief, not reflection. The user describes what got done — tasks completed, progress made, conversations had, decisions reached. Cross-reference their response with today's `## Today's Options` items and any `## Log` entries. Build a complete picture of the day's output.

---

## Step 3: Advance the system

Based on accomplishments from Step 2:

- **Daily note `## Today's Options`**: Mark completed items as `- [x]` in place. Copy completed items to `## Done Today` in the format `- [x] Action — [[Project]] — YYYY-MM-DD`. Undone items stay as `- [ ]` in Today's Options — they are historical record, not failures.
- **Project notes**: For each accomplishment, find the relevant project (search by project name or `categories: ["[[Projects]]"]`) or `[[Action Pool]]`. Mark the corresponding action as complete (`- [x] ... — YYYY-MM-DD`), move to `## Completed` section. Update project context if the accomplishment changes the project's state (e.g., new information, shifted priorities, new actions surfaced).
- **New actions**: If accomplishments reveal follow-up actions (next steps from a conversation, new items from completed work), add them to the appropriate project's action menu.
- **Status changes**: If a project's last action is now complete, prompt: "All actions for [[Project]] are done — is this project complete, or are there new actions?"
- **Contradiction detection**: Note accomplishments that cut against documented defense patterns — e.g., shipping something imperfect, engaging a usually-avoided task without resistance, acting decisively under ambiguity. Don't announce clinically — weave into acknowledgment: "You shipped that without over-polishing — nice." Flag internally for inclusion in the next morning's Observations section.

Use QMD (`mcp__qmd__query` with `vec`) if the user describes work that doesn't obviously map to an existing project.

---

## Step 4: Day-specific evening routines

Read `[[Day-Specific Routines]]`. Filter for today's evening items. Present applicable items.

---

## Step 5: Evening reflection

Guide through 4 prompts and write responses to `## Reflection` in today's daily note. These are qualitative — separate from the factual debrief in Step 2:

- "What went well today?"
- "Where did you feel the most friction?"
- "What did you appreciate most about today?"
- "How best can you spend your evening?"

**Pattern observation** (Tier 1, optional): After the friction question, if the user's response maps to a pattern from the `shadow-awareness` rule, offer one brief observation in behavioral terms — "It sounds like the friction was around committing without full information." If the user engages, follow up conversationally (Tier 2 available during reflections). If not, let it go. Skip if the user is tired, energy/mood are low, or a pattern was already surfaced during the startup.

---

## Step 6: Quick capture sweep

Ask: "Anything lingering that needs capturing?" If yes, capture to inbox or directly to the relevant project.

---

## Step 7: Closure

Present the shutdown ritual:

> "The day is reviewed, everything's captured. **Good enough for today.**"

This phrase provides psychological closure (Zeigarnik effect) — the workday is officially done.

---

## Step 8: Commit

Commit all vault changes made during the shutdown.
