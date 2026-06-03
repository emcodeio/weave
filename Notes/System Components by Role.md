---
categories: ["[[Guides]]"]
status: active
areas: ["[[Self-Management]]"]
tags: [guide, reference]
created: 2026-04-13
---

# System Components by Role

Weave is a [[Weave - Chapman Framework|meta-rational]] productivity system where Claude Code acts as the organizational layer on top of an Obsidian vault. Claude operates at one of three levels depending on the task:

- **Architect** — redesigning the system itself (rules, skills, templates, agents, settings)
- **Orchestrate** — managing what gets done (reviews, inbox processing, project advancement)
- **Partner** — collaborative substantive work (research, drafting, content ingestion)

Everything below is scoped to the project-level installation at `.claude/` in the `weave` repo. This is the shipped template — user-invoked, user-installed skills/hooks that live elsewhere are not included.

**Counts:** 35 skills · 5 agents · 15 rules · 6 hooks.

This document groups each component under the role it most naturally serves, plus a **Cross-cutting** section for utility/format pieces that every role relies on. Each entry notes *what it is* and *how it fits the role's purpose in the system*.

---

## 1. Architect — Redesigning the System

The Architect level handles structural changes to the productivity system itself. Protected scope (`.claude/`, `CLAUDE.md`, `Templates/`, system notes), minimal edits, verify-and-commit discipline. These components let the system evolve without breaking itself.

### Skills

- **`/create-from-template`** — Instantiates a new vault note from the template library, handling required properties and proactive linking. *Role fit:* Extends the note corpus using the Architect-defined template catalog, so Partner and Orchestrate levels can rely on consistent note shapes.
- **`/create-template`** — Designs and creates a new template (with optional `.base` file, category note, and updates to `types.json`/`Note Schemas`). *Role fit:* Grows the template library itself — pure system design.
- **`/design-skill`** — Captures intent for a new skill, researches patterns, designs and writes the `SKILL.md`. *Role fit:* The self-extension mechanism for the slash-command surface.
- **`/design-agent`** — Scaffolds a new agent: frontmatter, model selection, tools, system prompt, and memory scope. *Role fit:* The self-extension mechanism for the agent surface.
- **`/evaluate-tool`** — Researches and benchmarks a candidate tool or integration against alternatives, producing an evaluation note. *Role fit:* Gatekeeper for what gets added to the system's external surface area (MCP servers, CLIs, libraries).
- **`/resolve-contradictions`** — Scans for six types of semantic drift across projects, pools, and system docs, reporting with evidence (never auto-resolves). *Role fit:* Consistency enforcement — keeps the system's self-description aligned with its actual state.
- **`/system-review`** — Comprehensive audit of `CLAUDE.md`, rules, skills, agents, and hooks for gaps, friction, and improvement opportunities. *Role fit:* The periodic structural checkup that feeds into future `/design-*` and `/evaluate-*` work.

### Agents

- **`system-architect`** (sonnet, `memory: user`) — Evolves `.claude/` infrastructure: reviews health, designs skills/agents, evaluates integrations, tracks design decisions over time. *Role fit:* The persistent expert the Architect skills fork into for heavy design work; memory lets it remember *why* each decision was made.
- **`contradictions-resolver`** (sonnet, `memory: project`) — Scans the vault for status drift, misplaced completions, malformed projects, pool drift, and orphaned system references. Never auto-fixes. *Role fit:* Protects the integrity of the system by surfacing places where docs and reality disagree; paired with `/resolve-contradictions`.

### Rules

- **`architect-operations.md`** — Defines protected files (`.obsidian/`, `settings.local.json`, plugin skills, `.claude-plugin/`), modifiable files, and the read→change→verify→commit→push protocol. *Role fit:* The Hippocratic oath of system editing — what must not be touched and how to safely touch everything else.
- **`system-architecture.md`** — Describes the shape of the productivity system: vault, Claude, Calendar, Reminders, Mail, Drafts, Keyboard Maestro, QMD. *Role fit:* The architectural map the Architect level operates against; consulted when deciding where a new capability belongs.

### Hooks

- **`protect-system-files.sh`** (PreToolUse on Edit/Write) — Hard-blocks writes to `.obsidian/`, `settings.local.json`, kepano plugin skills, and `.claude-plugin/`. *Role fit:* Mechanically enforces the "protected files" boundary that `architect-operations` describes in prose, so an errant instruction can't corrupt the system.
- **`setup-git-hooks.sh`** — Installs the `post-commit` hook that runs `qmd update && qmd embed` after each commit. *Role fit:* One-time infrastructure step that keeps semantic search fresh without requiring ongoing discipline.
- **`check-protected-skills.sh`** (manually run) — Diffs the vendored kepano plugin skills against their upstream `main` branch, file by file, and reports drift (the upstream ships content changes without bumping the plugin version, so the marketplace update check is unreliable). *Role fit:* The companion to `protect-system-files.sh` — that hook blocks edits to the kepano skills; this one tells you when upstream has moved so a user-authorized re-sync is warranted.

---

## 2. Orchestrate — Managing What Gets Done

The Orchestrate level is the day-to-day operating surface: reviews, inbox processing, project advancement, routine execution. These components turn the Weave philosophy (action menus, not queues; options, never orders; enjoyable usefulness) into lived practice.

### Skills

#### Review sessions
- **`/start-workday`** (Tue–Fri, ~10 min) — Morning ground → orient → choose → commit flow with calendar, inbox overview, and curated action menu. *Role fit:* The workday's main curation pass; writes `## Today's Options` into the daily note.
- **`/start-personal-day`** (weekends/vacation, ~5 min) — Lighter relaxed startup weighted toward leisure and critical-only items. *Role fit:* Prevents work-mode defaults from bleeding into personal days.
- **`/start-work-week`** (Monday, ~15 min) — Life check-in + weekend catch-up + week planning + daily startup. *Role fit:* The one-bigger startup that sets the week's center of gravity before descending to daily cadence.
- **`/end-workday`** (Mon–Fri, ~5–10 min) — Five-step closure: review, capture accomplishments, advance projects, run routines, reflect, then "Good enough for today." *Role fit:* Embodies the anti-perfectionism Zeigarnik-closing ritual central to Weave.
- **`/end-personal-day`** (weekend/vacation evening) — Gentler shutdown: capture, advance, reflect. *Role fit:* Personal-time equivalent of `/end-workday`, without the work framing.
- **`/end-weekend`** (Sunday, ~5 min) — Gentle appreciation, no processing. *Role fit:* Transition ritual; enforces "no processing" so Sunday stays rest.
- **`/deep-review`** (usually Friday EOD, ~30 min) — Full three-phase GTD: Get Clear (inboxes to zero), Get Current (audit projects/areas), Get Creative (plan). *Role fit:* The only session that fully processes inboxes — keeps daily reviews fast by concentrating the heavy lift here.

#### Project lifecycle & inbox
- **`/create-project`** — Scaffolds a new project note with action menu, Bases views, outcome, and proactive linking. *Role fit:* The entry point when something crosses the "clear outcome + 2 actions" threshold that defines a project in Weave.
- **`/advance-project`** — Takes a natural-language "I did X" and matches it to existing actions, updates completions, surfaces what's next. *Role fit:* The canonical way to record progress without manually editing checkboxes.
- **`/complete-project`** — Sets `status: completed`, resolves stragglers, cleans daily note, and offers retrospective. *Role fit:* Provides clean closure that preserves links (Weave keeps completed notes rather than deleting them).
- **`/integrate-workbench`** — Graduates a `status: ready` workbench note to its permanent home with full proactive linking. *Role fit:* The bridge between Partner-level iteration space and the permanent knowledge graph; the lightweight default for single, non-forge items.
- **`/integrate-concept-forge`** — Graduates a concept-forge artifact into a note network: spine concept + card-grade satellites, person-note updates, sources propagation, and an auto-offered chain to `/integrate-concept-cluster` when a sibling cluster exists. *Role fit:* The forge-specific graduation path — turns the multi-session conceptual work product into permanent, fully-linked notes.
- **`/integrate-concept-cluster`** — Triages a workbench cluster of related working documents (shape detection, iteration-pair reconciliation, optional composite drafting) and applies per-item graduations, absorptions, and deletions on a confirmed plan. *Role fit:* The cluster-level counterpart to `/integrate-workbench`; runs standalone for any cluster or chained from `/integrate-concept-forge`.
- **`/process-inbox`** — Scan → classify → confirm → execute across Obsidian `Inbox/` and Drafts inbox in a single batch. *Role fit:* The workflow the `/deep-review` skill orchestrates; the batch model prevents per-item context thrash.

### Agents

- **`vault-organizer`** (sonnet, `memory: project`) — Audits vault health: orphans, missing frontmatter, broken links, dead-ends, stale projects, Bases coverage. *Role fit:* The structural maintenance pass that happens during reviews; project-scope memory lets it track health trends over time.

### Rules

- **`weave-principles.md`** — The philosophical core: action menus, enjoyable usefulness, friction detection, stance awareness, action format, completion tracking, tag strategy, seven review sessions. *Role fit:* The constitution for every Orchestrate-level decision — when to mandate vs. suggest, when to surface vs. stay quiet, how options get weighted.
- **`workbench.md`** — Defines `Workbench/` as active working space (not capture, not permanent), with lightweight frontmatter and graduation triggers. *Role fit:* Gives reviews a defined place to surface `status: ready` items and stale drafts.
- **`drafts.md`** — Drafts MCP tool routing, safety rules, and review-integration workflow. *Role fit:* Makes the Drafts inbox first-class in `/deep-review` and daily overviews.
- **`apple-mail.md`** — Two-server Mail tool routing (read vs. write), draft-only send policy, review integration. *Role fit:* Brings email into action menus without making Claude a liability (no direct sends).
- **`shadow-awareness.md`** — Three-tier feedback protocol (notice → connect → interpret), off-switch criteria, and the Living Document protocol for defense patterns. *Role fit:* The calibration layer that lets Orchestrate touch meaning without turning every review into therapy.

### Hooks

- **`check-note-quality.sh`** (PostToolUse on Edit/Write) — Verifies YAML frontmatter on `Notes/**` and `References/**` writes; warns on missing delimiters or required fields (`categories`, `areas`, `status`, `tags`, `created`). *Role fit:* Enforces the proactive-linking frontmatter schema mechanically, so the "be the organizer" principle doesn't rely on memory.
- **`log-vault-change.sh`** (PostToolUse on Edit/Write) — Appends changed paths with timestamps to `.claude/hooks/logs/changes.log`. *Role fit:* Feeds the compaction hook so reviews and resumed sessions can see what moved recently.

---

## 3. Partner — Collaborative Substantive Work

The Partner level is where Claude and the user work on a specific thing together — research, writing, processing a conversation, working on a spec. Partner skills bring vault context in proactively and produce well-linked work products.

### Skills

- **`/research-topic`** — Vault-first research: QMD + Obsidian search, then web, synthesized into a `Notes/` resource note with citations. *Role fit:* Forks to the `researcher` agent for memory-backed depth; captures findings inside the vault so they're reusable.
- **`/draft-content`** — Gather context → outline → draft → place in vault with full frontmatter and linking. *Role fit:* Forks to the `content-drafter` agent so voice/style preferences accumulate over time.
- **`/open-workbench`** — Orients for focused work on a workbench item: loads the item, parent project state, recent activity, related vault knowledge. *Role fit:* The session primer for iterative partner work; pairs with `/integrate-workbench` at the other end.
- **`/ingest-written-content`** — Parses an external article/essay into linked article + concept + framework notes. *Role fit:* Converts outside-world reading into first-class citizens of the knowledge graph.
- **`/ingest-book`** — Captures a book into a structured `References/` note — themes, key ideas, and quotes — with linked concept and framework notes for ideas worth promoting. *Role fit:* The book-length counterpart to `/ingest-written-content`; turns reading into reusable, well-linked vault knowledge.
- **`/process-transcript`** — Single transcript processor: detects the frame (generic vs. work) and extracts actions, reference material, project context, decisions, and insights — adding blocker and cross-team coordination categories plus meeting-type detection when the work frame is active (via `references/work-profile.md`). Proposes an integration plan before acting. *Role fit:* The "plan → confirm → execute" shape that keeps Partner work transparent and reversible.
- **`/process-llm-conversation`** — Analyzes exported LLM conversations (Claude/ChatGPT/Gemini), extracting knowledge, decisions, actions, and content produced. *Role fit:* Treats AI conversations as a legitimate knowledge source, preserving what was learned before the chat gets lost.
- **`/concept-forge`** — Forges a nascent idea or intuition into a Chapman-compliant concept card across one session or many, iterating in a Workbench artifact (loads the `concept-craft` rule for stance and schema). *Role fit:* The dialogic engine for conceptual work — Partner-level thinking-with, where the work product is a refined concept rather than a research finding or a draft.

### Agents

- **`researcher`** (**opus**, `memory: user`) — Deep research specialist: vault search → web → synthesis → well-linked resource note. *Role fit:* The upgraded model plus user-scope memory means research quality compounds; memory tracks topics, useful sources, and the user's depth/format preferences.
- **`content-drafter`** (sonnet, `memory: user`) — Writing partner that learns the user's voice over time: gathers context, outlines, drafts, places in vault. *Role fit:* The voice-matching and style-tracking memory is the moat — it makes Claude's drafts feel progressively more like the user's own writing.

### Rules

- **`partner-conventions.md`** — When to create a vault note vs. respond conversationally, research standards (vault-first, cite sources, confidence levels), drafting standards (voice, headings, wikilinks), Workbench routing criteria, skill/agent delegation patterns. *Role fit:* The quality bar for Partner-level work products; the guidance that makes "help me with X" produce something worth keeping.
- **`concept-craft.md`** — Chapman-aligned stance for conceptual work: reasonableness before rationality, the three nebulosity types, the purpose-first concept card schema, and anti-sycophancy / anti-refinement-addiction guardrails. Globally available; applies when the work is conceptual. *Role fit:* The thinking-with stance `/concept-forge` runs on (and `/research-topic`, `/ingest-written-content` borrow when the question is conceptual) — keeps concept work honest rather than agreeable.
- **`concept-forge-artifact-format.md`** — Specifies the Workbench artifact that `/concept-forge` writes and `/integrate-concept-forge` reads (path-scoped to `Workbench/concept-forge/`). *Role fit:* The shared contract that lets forging span sessions and graduate cleanly — the artifact is the memory.

---

## 4. Cross-cutting / Utility

These components serve every role. They're the substrate the three operating levels all rely on.

### Format / Interface Skills

- **`obsidian-markdown`** — Obsidian Flavored Markdown reference: wikilinks, embeds, callouts, properties. *Role fit:* Every note-producing action depends on this being correct.
- **`obsidian-bases`** — Bases (`.base`) files: views, filters, formulas, summaries. *Role fit:* Powers the property-based organization that replaces folder hierarchy.
- **`obsidian-cli`** — Obsidian CLI command reference (read/create/search/property/backlinks/orphans/daily). *Role fit:* The preferred vault interface — uses Obsidian's index and graph, not raw files.
- **`json-canvas`** — JSON Canvas `.canvas` files: nodes, edges, groups. *Role fit:* Visual layer for mind maps and flowcharts.
- **`defuddle`** — Clean markdown extraction from web pages via Defuddle CLI. *Role fit:* Cost-efficient replacement for `WebFetch` on structured pages; used by research and ingest skills.
- **`pdf-reader`** — Structured markdown extraction from PDFs via pymupdf4llm. *Role fit:* Inbox PDF wrappers, slide decks, attachments.

### Rules

- **`operating-principles.md`** — The universal Claude-behavior principles: be the organizer, maximize retrieval, proactive linking checklist, surface context, present options, keep vault clean, default to Obsidian. *Role fit:* These apply at every level; they're why all three roles feel like the same assistant.
- **`vault-conventions.md`** — Seven-folder structure (`Notes/`, `References/`, `Attachments/`, `Workbench/`, `Inbox/`, `Daily/`, `Templates/`), frontmatter schema, linking conventions, naming, note types. *Role fit:* The shared language every component uses when placing a note.
- **`obsidian-cli.md`** — CLI safety rules (`create` defaults to vault root; no stdin; `content=` size limit), preferred CLI vs. direct-file operations, review-time health checks. *Role fit:* Any skill or agent that touches the vault goes through this.
- **`qmd.md`** — QMD MCP tool routing, search strategy decision tree, query construction (lex/vec/hyde), score interpretation, fallback behavior. *Role fit:* Semantic search is the retrieval backbone across all three roles (friction detection in Orchestrate, vault-first research in Partner, system-ref checks in Architect).
- **`version-control.md`** — Commit workflow (specific file adds, push), QMD re-indexing via post-commit hook, repo details, gitignore policy. *Role fit:* Every mutation ends here; the hook chain starts here.

### Hooks

- **`compact-context.sh`** (SessionStart `compact` matcher) — After context compaction, surfaces uncommitted changes, recent vault changes (last 10 log lines), and warns if the QMD post-commit hook is missing. *Role fit:* Keeps long-running sessions oriented after compaction by re-injecting state that can't be reconstructed from re-reading `CLAUDE.md` alone.

---

## How the Pieces Reinforce the System

A few structural observations worth calling out, since they're easier to see in this grouped view than in the source tree:

1. **Skills define workflows; agents provide expertise and memory.** Partner skills (`/research-topic`, `/draft-content`) fork to agents (`researcher`, `content-drafter`) with persistent `memory: user`, so style and source preferences compound. Architect does the same with `system-architect`. Orchestrate mostly runs in the main conversation, with `vault-organizer` reserved for structural audits.
2. **Hooks mechanically enforce the rules prose.** `protect-system-files.sh` makes `architect-operations.md`'s protected-files list real. `check-note-quality.sh` makes the proactive-linking frontmatter schema real. The rules describe the policy; the hooks make it mandatory.
3. **QMD + git + the post-commit hook form the retrieval loop.** Every commit triggers a re-index; semantic search stays fresh without manual action. `qmd.md` and `version-control.md` together describe this loop; `setup-git-hooks.sh` installs it.
4. **The rule split mirrors the role split.** `architect-operations` is paths-scoped frontmatter-gated to system files; `weave-principles` and `workbench` govern Orchestrate; `partner-conventions` governs Partner. The cross-cutting rules (`operating-principles`, `vault-conventions`, `obsidian-cli`, `qmd`, `version-control`) apply universally and are unscoped.
5. **Review skills are the Orchestrate heartbeat.** Seven of the fourteen Orchestrate skills are review sessions (daily + weekly startups and shutdowns + deep review + weekend close); the rest cover project lifecycle, inbox, and workbench graduation. Inbox processing is deliberately concentrated in `/deep-review` so daily reviews stay fast — a structural expression of the "options, not orders" stance.
6. **The Workbench bridges Partner and Orchestrate.** Partner-level drafting happens in `Workbench/` with lightweight frontmatter; `/integrate-workbench` at the Orchestrate level graduates finished items into the permanent graph. This keeps in-progress work out of the "everything must be fully linked" regime without losing it.

---

## Related Notes

- [[System Overview]] — Architecture, vault structure, and review rhythm
- [[Customizing Your System]] — Making the system yours
- [[Weave - Chapman Framework]] — Philosophical foundation
- [[Weave - System Design Notes]] — Design rationale behind each decision
- [[Note Schemas]] — Frontmatter reference for all note types
