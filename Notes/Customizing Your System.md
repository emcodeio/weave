---
categories: ["[[Guides]]"]
status: active
areas: ["[[Self-Management]]"]
tags: [guide]
created: 2026-04-11
---

# Customizing Your System

Weave ships with sensible defaults, but it's designed to adapt to your life. All customization happens through conversation with Claude — you describe what you want, Claude makes the structural changes.

---

## Areas

Areas represent the major domains of your life. Every note belongs to one or more areas via the `areas` frontmatter property.

**Defaults:** Work, Home, Personal, Health, Relationships, Finances

**To add an area:** Tell Claude: "Create a new area called [name]." Claude will create the area note in `Notes/` and a corresponding Base view in `Templates/Bases/`.

**To rename or remove:** Tell Claude. It will update the area note, Base file, and any notes referencing the old name.

Areas are deliberately broad. A note about a home renovation project has `areas: ["[[Home]]"]`. A note about a work presentation has `areas: ["[[Work]]"]`. If a note spans areas, it can belong to multiple: `areas: ["[[Work]]", "[[Personal]]"]`.

---

## Categories

Categories describe what kind of note something is. They drive the Base views that let you browse your vault.

**Shipped categories:** Projects, Research, Articles, Books, People, Evergreen, Frameworks, Guides, Essays, Collections, Transcripts, Journal, Attachments

**To add a category:** Use `/create-template` to design a new note type, which creates the template, category note, and Base view together. Or tell Claude to create a category note manually.

Categories emerge organically. If you start accumulating a new type of note (e.g., Recipes, Course Notes, Meeting Records), create a category for it.

---

## Reviews

### Adjusting the rhythm

The seven review sessions match a typical work week. If your schedule differs:

- **No traditional work week?** Use `/start-personal-day` as your default morning review.
- **Want reviews less often?** Skip daily shutdowns — they're optional. The `/deep-review` on Friday catches everything.
- **Different deep review day?** Just run `/deep-review` whenever works for you. The skill adapts.

### Day-specific routines

`[[Day-Specific Routines]]` contains recurring items organized by day of week (Monday through Sunday) plus a Daily section. Claude reads this during startups and surfaces relevant items.

To modify: tell Claude "add [item] to my Monday routines" or "remove [item] from Thursday." Claude edits the note directly.

### Morning check-in

The three startup questions ("How are you feeling?", "What feels most alive?", "What would make today feel good?") are built into the startup skills. To change them, ask Claude to modify the skill at the Architect level.

### Shutdown phrase

Workday shutdowns end with "Good enough for today." — a deliberate anti-perfectionism signal. You can change this by asking Claude to update the end-workday skill.

---

## Templates

Templates live in `Templates/` and define the structure for new notes. Each template includes frontmatter defaults, section headings, and placeholder content.

**To create a new template:** Use `/create-template`. Claude will walk you through defining the note type, frontmatter schema, sections, and create the template file, category note, and Base view.

**To modify an existing template:** Ask Claude to read and edit it. Changes apply to all future notes created from that template (existing notes are unaffected).

**Available templates:** Article, Book, Category Note, Collection, Daily Note, Essay, Evergreen, Framework, Guide, Media Wrapper, Person, Project, Research, Transcript

---

## Shadow Awareness

Weave includes a pattern recognition system that notices recurring avoidance patterns and defense mechanisms. This is entirely optional and deeply personal.

### Populating your patterns

The shadow awareness rule (`.claude/rules/shadow-awareness.md`) ships as a template with placeholders. To use it:

1. Tell Claude you'd like to set up shadow awareness
2. Describe patterns you've noticed (e.g., "I tend to over-plan instead of acting," "I avoid hard conversations by staying busy")
3. Claude will help you formulate these into the structured format

### Three feedback tiers

- **Tier 1 (Notice):** Observable behavior, no interpretation. "This action has appeared three reviews running." Safe in any context.
- **Tier 2 (Connect):** Cross-references across time. "This friction pattern has appeared in three recent reflections." Used during reviews and daily note observations.
- **Tier 3 (Interpret):** Connects to documented patterns. Only during dedicated sessions or when you explicitly invite it.

### Turning it off

If shadow awareness isn't useful for you, tell Claude: "Don't surface shadow patterns." Or delete the content from `.claude/rules/shadow-awareness.md` and leave only the template structure.

---

## System Files

Weave's configuration lives in `.claude/`:

| Location | What it contains | How to modify |
|----------|-----------------|---------------|
| `CLAUDE.md` | Root system prompt — operating model, principles, tool priority | Ask Claude (Architect level) |
| `.claude/rules/` | Modular instruction files — principles, conventions, integrations | Ask Claude (Architect level) |
| `.claude/skills/` | Slash command definitions | `/design-skill` or ask Claude |
| `.claude/agents/` | Agent definitions (researcher, content-drafter, etc.) | Ask Claude (Architect level) |
| `.claude/hooks/` | Automation scripts (file protection, quality checks) | Ask Claude (Architect level) |
| `.claude/settings.json` | Hook configuration | Ask Claude (Architect level) |

The Architect operating level handles all system changes. Claude reads current state, makes targeted changes, verifies nothing breaks, and commits. You describe what you want; Claude handles the implementation.

Use `/system-review` to evaluate overall system health and identify gaps or friction.

---

## Related Notes

- [[Getting Started]] — First three skills to try
- [[System Overview]] — Architecture and components
- [[Setting Up Integrations]] — Adding or configuring integrations
- [[Note Schemas]] — Frontmatter reference for all note types
- [[Day-Specific Routines]] — Recurring items by day of week
