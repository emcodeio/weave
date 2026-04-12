---
categories: ["[[Research]]"]
status: active
areas: ["[[Self-Management]]"]
tags: [framework, self-management]
created: 2026-03-02
---

# Weave - System Design Notes

Maps David Chapman's concepts to specific system design decisions. Companion to [[Weave - Chapman Framework]].

## Why action menus over sequences

Chapman's nebulosity insight: purposes and energy shift without announcement. A prescribed sequence assumes tomorrow's context matches today's planning. **Action menus** let the user pick based on current reality — what's useful *and* enjoyable right now. Genuine dependencies (step B requires step A's output) are honored, but most project actions can be done in any order.

## Why no external task manager

Things3 created a philosophical mismatch: the system was built around "options, not orders" but wired into a single-next-action-per-project model. Even self-imposed sequences felt prescriptive. Moving all task management into Obsidian eliminates the translation layer and makes action menus the native format. Claude handles the curation that Things3's lists used to provide.

## Why Drafts for capture

Chapman's circumrationality requires low-friction bridges between intention and the formal system. Drafts provides instant capture on any Apple device with a single tap, pushing to `Inbox/` via iCloud folder bookmark. The capture point should have near-zero activation energy.

## Why Apple Reminders for hard deadlines only

Hard deadlines ("return item by March 5") need time-triggered alerts that interrupt regardless of context. Apple Reminders provides this with native OS integration. But general task management in a separate app creates the same mismatch that Things3 did — tasks should live where their context lives (Obsidian project notes), not in a separate app's data model.

## Concept → Implementation table

| Chapman concept | System implementation |
|----------------|----------------------|
| Nebulosity of tasks | Checkbox menus, not numbered sequences |
| Enjoyable usefulness | Claude weights options by usefulness + enjoyability |
| Circumrational friction | Friction detection — actions deferred across reviews |
| Ontological remodeling | Weekly review step: "Are categories still working?" |
| Confused stance oscillation | Stance-aware responses (grandiose → next action, grinding → meaning, paralysis → one small thing) |
| Meta-rational background monitoring | Claude tracks patterns across reviews, surfaces observations when dysfunction signals appear |
| Trading zone | Claude translates between Obsidian (notes/links), Calendar (time blocks), Reminders (alerts) using natural language |
| Complete stance on purpose | "What could you do that would be useful and enjoyable?" — not "what should you do?" |

## Links

- [[Weave - Chapman Framework]]
- [[Self-Management]]
