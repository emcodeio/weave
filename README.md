# Weave

> A meta-rational productivity system. Obsidian + Claude Code. Options, not orders.

## What is Weave?

Weave is a productivity system where Claude Code acts as your organizational layer inside an Obsidian vault. Instead of rigid task queues and prescribed workflows, it presents action menus weighted by usefulness and enjoyability. You make every decision.

In practice, this means Claude reads your vault, creates and links notes, runs review conversations, handles frontmatter and filing, and surfaces relevant context when you need it. You never manually maintain vault structure, categories, or linking — Claude does that automatically whenever notes are created or modified.

Built on David Chapman's [meta-rationality](https://metarationality.com/introduction) framework: use formal systems (categories, routines, reviews) without being captured by them. Claude manages structure, surfaces context, detects friction patterns, and holds categories lightly — you choose what to do and when.

There is no external task manager. Projects, actions, reference material, routines, and reviews all live in the vault as plain Markdown, version-controlled with git.

## Who is this for?

- People who find rigid task managers constraining
- Comfortable with CLI tools and terminal workflows
- Want an AI that understands their work, not just organizes it
- Interested in a system that adapts rather than prescribes

## What you get

- **32 slash commands** for daily reviews, project management, research, writing, and system design
- **7 review sessions** — from 5-minute shutdowns to 30-minute deep reviews
- **Semantic search** over your entire vault via QMD (local, on-device)
- **Apple integrations** (optional, macOS): Calendar, Reminders, Mail, Drafts
- **Property-based organization** — areas + categories, not folder hierarchies
- **5 specialized agents** — researcher, content drafter, vault organizer, contradiction resolver, system architect
- **Pattern recognition** — friction detection across reviews, stance awareness, optional shadow pattern tracking
- **In-vault documentation** — guide notes that are the docs

## How it works

### Three operating levels

Claude detects the level needed from your language and adapts its behavior accordingly. You don't select a mode — Claude reads the situation and shifts how it operates.

#### Architect — "Am I redesigning the system?"

When you're working on the productivity system itself — modifying rules, designing new skills, restructuring templates, evolving the review process. Claude reads the current state of system files, makes minimal targeted changes, verifies nothing broke, and commits. The scope is `.claude/`, `CLAUDE.md`, `Templates/`, and system notes.

> "Let's redesign the review process" / "Update the project template" / "Create a new skill for..."

Key skills: `/design-skill`, `/design-agent`, `/system-review`, `/create-template`

#### Orchestrate — "Am I managing what gets done?"

When you're deciding what to work on, processing inboxes, advancing projects, or running reviews. Claude surfaces action menus from your project notes, pulls in calendar context, checks for friction patterns, and presents options. It never mandates — it shows you what's available and you choose.

> "What could I work on?" / "Let's do a morning review" / "Mark that done and advance the project"

Key skills: `/start-workday`, `/deep-review`, `/advance-project`, `/process-inbox`, `/end-workday`

#### Partner — "Am I working on a task together?"

When you're collaborating on substantive work — research, writing, exploration, building. Claude brings relevant vault context into the conversation proactively, creates well-linked notes as work products, and handles all structural conventions automatically. You lead direction; Claude handles structure.

> "Help me research solar options" / "Let's draft the handoff guide" / "Open the spec and let's work on it"

Key skills: `/research-topic`, `/draft-content`, `/open-workbench`, `/create-project`

### Vault structure

```
Notes/          — Projects, areas, categories, system notes, research, frameworks
References/     — External entities (books, people, places)
Attachments/    — Binary files (images, PDFs, audio)
Workbench/      — Active work-in-progress (specs, drafts, collaborative docs)
Inbox/          — Capture target, processed during reviews
Daily/          — Daily notes (dashboard + journal)
Templates/      — Note templates and Bases views
```

Notes are organized by frontmatter properties — `categories`, `areas`, and `status` — not by folder hierarchy. Obsidian Bases views create dynamic filtered dashboards from these properties, so you can reorganize your entire system by changing properties rather than moving files.

### Review rhythm

Seven sessions span the week, each a conversational workflow where Claude presents options and you choose:

| Session | Skill | When | Duration | Character |
|---------|-------|------|----------|-----------|
| Workday startup | `/start-workday` | Tue-Fri morning | ~10 min | Calendar, inbox overview, action menu. Work-biased. |
| Personal day startup | `/start-personal-day` | Weekends, vacation | ~5 min | Relaxed. Only critical items. Leisure-weighted. |
| Work week startup | `/start-work-week` | Monday morning | ~15 min | Life check-in + weekend catch-up + week planning + daily startup. |
| End workday | `/end-workday` | Mon-Fri evening | ~5-10 min | Capture accomplishments, advance projects, reflect. |
| End personal day | `/end-personal-day` | Weekend evenings | ~5-10 min | Capture accomplishments, gentle reflection. |
| Deep review | `/deep-review` | Usually Friday EOD | ~30 min | Full GTD: inboxes to zero, audit all projects, get creative. |
| End weekend | `/end-weekend` | Sunday evening | ~5 min | Gentle appreciation. No processing. |

Daily startups give you an overview — inbox counts, calendar, active projects — and build an action menu for the day. Full inbox-to-zero processing happens exclusively during `/deep-review`, so daily reviews stay fast.

Workday shutdowns close with "Good enough for today." — a deliberate ritual for psychological closure. It embodies the system's anti-perfectionism stance: done reviewing means done, not "done until I remember one more thing."

### The daily note

Each day's note is a hybrid dashboard and journal with two zones:

**Dashboard** (populated by Claude during startup): Today's Options (curated action checkboxes), Routines (day-specific), Upcoming (two-month horizon), Active Projects (embedded Base view).

**Journal** (your space): Morning State, Intentions, Log, Done Today, Reflection.

During each morning startup, Claude writes an `## Observations` section in yesterday's note — cross-referencing patterns, noting what got done or deferred, connecting themes across days.

### The Workbench

`Workbench/` is a staging area for content being actively iterated — specs, drafts, collaborative documents, reference material under development. Not a capture point (that's `Inbox/`) and not permanent storage (that's `Notes/` or `References/`). It's where you spread out an active project and work on it.

Workbench notes use lighter frontmatter (just `status` and `created`) and are exempt from the system's linking and categorization requirements. When a workbench item is finished, it "graduates" to its permanent location via `/integrate-workbench`, and full proactive linking is applied at that point.

## Philosophy

The central insight: tasks and purposes are inherently nebulous. They resist crisp definition — energy shifts, context changes, priorities drift. Rigid systems fight this; Weave works with it.

[Meta-rationality](https://metarationality.com/introduction) means using formal systems (categories, reviews, action menus) while recognizing they're always approximations. The system holds structure lightly — categories are provisional, routines adapt, and the orienting question is always "What does this situation need?" rather than "What does the system prescribe?"

### Action menus, not queues

Projects contain unordered action options, not sequenced task lists. You pick based on current energy, context, and interest — not a prescribed order. Ordering is only enforced when genuine dependency exists. This honors the reality that tomorrow's context rarely matches today's planning.

### Enjoyable usefulness

The orienting question: "What could you do now that would be both useful and enjoyable?" This replaces "what should I do?" as the decision calculus. When Claude builds your daily action menu, it weights options by both usefulness and likely enjoyability.

### Present options, never orders

Claude suggests what you *could* do, never what you *should* or *must* do. This isn't politeness — it's structural. Every review conversation presents a menu; you choose. The system respects that you know your situation better than any algorithm.

### Friction detection

Actions deferred across multiple reviews are a signal, not a failure. Claude tracks these patterns and surfaces them: "This has come up three reviews in a row — is something blocking it, or has the purpose shifted?" Semantic search finds similar deferred actions across projects, revealing systemic friction patterns — all communication tasks, all admin tasks — rather than treating each deferral as isolated.

### Stance awareness

Three observable patterns get concrete responses rather than analysis:

- **Grandiose planning, no execution** — "What's the very next physical action?"
- **Grinding through tasks, ignoring meaningful work** — Surface something important and enjoyable
- **Paralysis or "nothing matters"** — Offer one small, concrete, useful thing

### Shadow awareness

An optional layer for recognizing recurring defense patterns — the ways you habitually protect yourself when things feel uncertain or exposing. Uses a three-tier protocol: Tier 1 (always safe) notices observable behavior without interpretation. Tier 2 (during reviews) connects patterns across time. Tier 3 (only by explicit invitation) engages with the underlying formulation. Entirely opt-in; the system works fully without it.

Based on David Chapman's work on [meta-rationality](https://metarationality.com/introduction). For the full philosophical foundation, see the in-vault Chapman Framework note after installation.

## Prerequisites

| Requirement | Version | Notes |
|------------|---------|-------|
| [Obsidian](https://obsidian.md) | 1.12+ | Bases support required |
| [Claude Code](https://docs.anthropic.com/en/docs/claude-code) | Latest | Pro plan or API key |
| [Node.js](https://nodejs.org) | 18+ | For MCP servers and QMD |
| [QMD](https://github.com/tobilu/qmd) | Latest | Local semantic search (~2GB models) |

**Recommended:** macOS for Apple integrations (Calendar, Reminders, Mail, Drafts). Core system works cross-platform.

## Installation

```bash
git clone https://github.com/emcodeio/weave.git my-vault
cd my-vault
bash setup.sh
```

The setup script will:
1. Check prerequisites
2. Configure vault name and path
3. Set up git identity (optional)
4. Install and initialize QMD semantic search
5. Choose Apple integrations (macOS)
6. Customize life areas
7. Create vault structure and initial commit

Then open the folder as a vault in Obsidian and start Claude Code in the same directory.

## Quick start

```
claude                    # Start Claude Code in your vault
/start-workday           # Morning review (Tue-Fri)
/start-work-week         # Monday morning review
/create-project          # Start a new project
/process-inbox           # Process captured items
/deep-review             # Full weekly review (inboxes to zero)
/end-workday             # Evening shutdown
```

## Documentation

All documentation lives inside the vault as notes:

| Guide | What it covers |
|-------|---------------|
| **Getting Started** | Philosophy, first three skills, what to expect |
| **System Overview** | Three levels, vault structure, review rhythm, integrations |
| **Customizing Your System** | Areas, categories, reviews, templates, shadow awareness |
| **Your First Review** | Annotated walkthrough of `/start-workday` |
| **Setting Up Integrations** | QMD, Calendar, Mail, Drafts setup and troubleshooting |

## License

[MIT](LICENSE)

## Acknowledgments

Built on [David Chapman's](https://metarationality.com/introduction) meta-rationality framework.
Powered by [Claude Code](https://docs.anthropic.com/en/docs/claude-code) and [Obsidian](https://obsidian.md).
Obsidian format skills adapted from [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills).
