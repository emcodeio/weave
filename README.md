# Weave

> A meta-rational productivity system. Obsidian + Claude Code. Options, not orders.

## What is Weave?

Weave is a productivity system where Claude Code acts as your organizational layer inside an Obsidian vault. Instead of rigid task queues and prescribed workflows, it presents action menus weighted by usefulness and enjoyability. You make every decision.

Built on David Chapman's [meta-rationality](https://meaningness.com) framework: use formal systems (categories, routines, reviews) without being captured by them. Claude manages structure, surfaces context, detects friction patterns, and holds categories lightly — you choose what to do and when.

There is no external task manager. Projects, actions, reference material, routines, and reviews all live in the vault.

## Who is this for?

- People who find rigid task managers constraining
- Comfortable with CLI tools and terminal workflows
- Want an AI that understands their work, not just organizes it
- Interested in a system that adapts rather than prescribes

## What you get

- **26 slash commands** for daily reviews, project management, research, writing, and system design (plus 6 format helper skills)
- **7 review sessions** — from 5-minute shutdowns to 30-minute deep reviews
- **Semantic search** over your entire vault via QMD (local, on-device)
- **Apple integrations** (optional, macOS): Calendar, Reminders, Mail, Drafts
- **Property-based organization** — areas + categories, not folder hierarchies
- **4 specialized agents** — researcher, content drafter, vault organizer, contradiction resolver
- **Pattern recognition** — friction detection across reviews, stance awareness, optional shadow pattern tracking
- **In-vault documentation** — guide notes that are the docs

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

## How it works

### Three operating levels

Claude detects the level needed and adapts:

| Level | When | Examples |
|-------|------|---------|
| **Architect** | Redesigning the system | `/design-skill`, `/system-review`, modifying rules |
| **Orchestrate** | Managing what gets done | `/start-workday`, `/process-inbox`, `/advance-project` |
| **Partner** | Working on a task together | `/research-topic`, `/draft-content`, `/open-workbench` |

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

### Review rhythm

Seven sessions from daily startups to weekly deep reviews. Each is a conversational workflow — Claude presents options, you choose. Morning startups build a daily note dashboard; evening shutdowns capture accomplishments and provide closure.

## Philosophy

The central insight: tasks and purposes are inherently nebulous. Rigid systems fight this; Weave works with it.

- **Action menus, not queues** — Projects contain unordered options. Pick based on energy, context, and interest.
- **Enjoyable usefulness** — "What could you do that would be useful and enjoyable?"
- **Friction detection** — Actions deferred across reviews are a signal, not a failure.
- **Stance awareness** — Concrete responses to observable patterns (over-planning, grinding, paralysis).

Based on David Chapman's work on [meta-rationality](https://meaningness.com) and [nebulosity](https://meaningness.com/nebulosity).

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

Built on [David Chapman's](https://meaningness.com) meta-rationality framework.
Powered by [Claude Code](https://docs.anthropic.com/en/docs/claude-code) and [Obsidian](https://obsidian.md).
Obsidian format skills adapted from [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills).
