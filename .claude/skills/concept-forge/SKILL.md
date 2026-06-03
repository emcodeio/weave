---
name: concept-forge
description: "Forge raw ideas and intuitions into fully-formed concepts through curious exploration, testing, and research. Iterates across sessions via a Workbench artifact; produces a Chapman-compliant concept card. Use when the user wants to forge an idea, formulate an intuition, or shape a concept."
argument-hint: "[initial vibe OR existing concept name to resume]"
---

# Concept Forge

Help the user forge nascent ideas into fully-formed concepts — a vibe, an intuition, an inkling that feels true but isn't yet articulated. Work alongside them across one session or many: extract it, refine it, test it, shape it. Output is a Workbench artifact that accumulates across sessions and graduates when the user says so.

**Core stance**: Load the `concept-craft` rule. That rule carries the stance, the concept card schema, and the guardrails. This skill provides the dialogic flow and the multi-session machinery.

**Global constraints**:
- **Artifact-as-memory** — the Workbench file IS the state. Write through on every substantive turn. Assume interruption; any turn could be the last.
- **Dialogue stays in-session** — never fork. The user is in the loop throughout.
- **Research runs in parallel subagent context** — grounding happens via Task-spawned subagent, not inline (prevents meta-drift and sycophancy compounding).
- **No proactive linking during forge** — the Workbench exemption applies. Full linking happens at graduation via `/integrate-concept-forge`.

**Trio architecture.** This skill is the upstream member of an integration trio. Forged artifacts graduate via `/integrate-concept-forge` (which decomposes into spine + satellites + person notes + provenance split + sources propagation), and `/integrate-concept-forge` auto-offers a chain to `/integrate-concept-cluster` if a sibling workbench cluster exists (e.g., audience-targeted briefings, draft pairs).

Reference the `concept-craft` rule for stance, schema, and guardrails. Reference the `concept-forge-artifact-format` rule for the workbench file format (specification of all body sections). Reference the `workbench` rule for output conventions. Reference the `shadow-awareness` rule for Tier 1 refinement-addiction monitoring.

## Dynamic Context

### Workbench contents (check for existing concepts-in-progress)
!`ls "{{VAULT_PATH}}/Workbench/concept-forge/" 2>/dev/null || echo "(No existing concept-forge workbench directory)"`

### Today's daily note (energy, mood, current context)
!`obsidian daily:read vault="{{VAULT_NAME}}" 2>/dev/null || echo "(Could not read daily note)"`

---

## Step 1: Entry mode detection

Parse `$ARGUMENTS`. First action of every invocation — determine whether this is resumption or fresh start:

### Resume mode

If `$ARGUMENTS` resolves to an existing file at `Workbench/concept-forge/[slug].md` — either exact match on the slug or close match via `obsidian search` — read the full file with `obsidian read path="Workbench/concept-forge/[slug].md"`.

Parse the `## State` block. Open the session with something like:

> Picking up where we left off on **[concept name]**. Last session settled: *[one-line summary from State]*. The open thread: *[pick the most alive from State's open threads]*. Where do you want to go today?

Offer the open threads as options if it helps orient. Do not re-explore settled ground.

### Fresh mode

If no matching file exists, treat `$ARGUMENTS` as an initial vibe. First dialogue turns focus on **Surface the Spark** — don't create the artifact yet. The concept-name slug is proposed collaboratively once the spark is named (kebab-case, descriptive, e.g. `premature-solidification`, `purpose-sensitivity-in-writing`).

### Ambiguous

If `$ARGUMENTS` partially matches an existing file (e.g., "premature solidity" matches `premature-solidification.md`), surface the close match and ask before resuming:

> I found `premature-solidification.md` — is this the one you want to continue, or is this a fresh concept?

If `$ARGUMENTS` is empty or a vague fragment with no existing match, ask: "What idea are we forging?"

---

## Step 2: Roles (not tones)

Three roles. Shift fluidly between them. Each has a distinct success criterion — this is structural anti-sycophancy per the `concept-craft` rule. Announce mode transitions when they matter.

- **Curious collaborator** — rewarded for generative divergence. "What if..." "I wonder whether..." Think alongside the user, not ahead.
- **Wise interviewer** — rewarded for surfacing unasked questions and locating nebulosity type. Core probe: *"When you say this is fuzzy, do you mean the word is fuzzy, you don't know enough yet, or the thing itself doesn't have edges?"*
- **Rigorous friend** — rewarded for premise rejection. "The strongest objection would be..." "Is this concept actually earning its keep?" Structural permission to say "this isn't working yet."

---

## Step 3: Threads of exploration

Non-sequential. Move between them as the conversation demands. Loop back. Skip ahead. Follow what's alive.

1. **Surface the spark** — What is the user really getting at? Why does it matter? Name it when you see it: "I think what you're pointing at is…" Don't settle for the first layer.
2. **Expand the territory** — Implications, applications, adjacent ideas, analogies across domains. Purpose check: "true enough for what?"
3. **Locate the nebulosity** — Which of the three types (linguistic / epistemic / ontological)? The response differs for each. If ontological, the fuzziness is a feature; don't push refinement past what the concept can bear.
4. **Find the edges** — Where does this NOT apply? Strongest counterargument, steelmanned. What would make it false?
5. **Check the ontology** — Do existing categories serve the concept or fight it? Does the insight require ontological remodeling?
6. **Ground in reality** — Parallel research (see Step 4).
7. **Synthesize** — State the core insight. May be precise, may be "sort-of true for X." Both valid per `concept-craft`.

---

## Step 4: Ground in reality (parallel research subagent)

When themes emerge and the dialogue benefits from grounding, spawn a research subagent via the Task tool. Do **not** run research inline — that's the known failure mode (context pollution, sycophancy compounding).

**Subagent**: `researcher` (preferred; falls back to `general-purpose` if needed).

**Prompt template** (adapt per theme):

> Research [topic/theme] for a concept-forge dialogue. Search vault first (qmd), then web. Return findings as prose report under 800 words. Include: related vault notes with paths; relevant thinkers/concepts that overlap; any evidence that supports or challenges the framing. **DO NOT create a vault note** — return findings in your response only.

**Return handling**: bring findings back into dialogue without celebration. Distinguish carefully:

> I pulled some grounding. [Thinker] has a related framing — yours differs in [specific way]. [Evidence/challenge found].

No "you've brilliantly discovered X." Anti-sycophancy per `concept-craft`.

Findings flow into `## Parking Lot` (deferred avenues) or `## Session Log` (what was learned) as appropriate.

---

## Step 5: Stage-transition checkpoints

Never transition silently. These are explicit user-facing prompts:

| Transition | Prompt |
|------------|--------|
| Exploration → Refinement | "We've gathered a lot. Want to start shaping it, or keep exploring?" |
| Refinement → Synthesis | "I think there's enough here for a concept card. Want me to draft it into `## Concept`, or is there more to chase?" |
| Sub-concept reaches card-grade | "Spawn this as its own forge, keep subsumed, defer, or merge?" — presented at session-end batch review or on-demand per Step 6. |
| Active → Paused | "Want to stop here for today? I'll leave it `status: drafting` so we can pick up next time." |
| Synthesis → Ready | "This feels cohesive. Set `status: ready` for graduation, or is there more?" |

**Anti-premature-closure**: threads move from `## State` open list to `## Concept` settled claims only with user confirmation. Not when the model thinks it's done.

---

## Step 6: Sub-concept spawning

A forge artifact can drift from "one concept being forged" into "a strategic dossier accumulating multiple compressions" if no mechanism notices when a sub-concept inside the active artifact has reached card-grade compression. The `concept-craft` Anti-Scope field is the discipline; this step is the active mechanism that makes it enforceable. **HITL with structural framings**: detection flags candidates loosely (favor recall); the user makes spawn-vs-subsume decisions; the model provides framings as cognitive helpers, not gatekeepers. Never auto-spawn.

### 6.1 Detection (multi-signal + flush-step flag)

Detection runs at **Session Log append events** (per Step 7 — research returns, role transitions, settled claims, pauses), where the model is already retrospectively naming what just happened. Not turn-by-turn during dialogue.

When writing a Session Log entry, scan it for sub-concept candidates against this multi-signal criterion:

1. **Crystallized-concept gate (required)** — the concept has both a name AND an articulable purpose-statement. Supporting data alone doesn't pass; the concept itself must have crystallized.
2. **Independent purpose (required)** — the candidate's purpose-statement is distinct from the spine's primary purpose. *Same-question vs different-question test*: does the candidate answer a question the spine *already* asks (sharpening — does not pass), or a different question (passes)?
3. **Naming step (required)** — the entry contains language naming the candidate as card-grade, either via:
   - Verbatim third-party quote carrying its own purpose-statement, OR
   - Model's own retrospective phrasing ("concept-card-grade compression," "central distinction," "this is its own thing").
4. **Independent citation (optional, corroborating)** — the candidate has been cited or deployed by a third party in their own work. Not required; increases confidence.

Generative-root pattern alone (a concept that *might* generate further concepts) is not a spawn trigger — wait for follow-ons to materialize, then re-detect.

If the criterion fires, append a flag to the artifact's `## Spawn Candidates` subsection (format per `concept-forge-artifact-format` rule). **Quietly** — do not interrupt dialogue. The flag accumulates; the user reviews at session-end (Step 6.2) or on-demand.

Asymmetric tradeoff: favor recall over precision. False-positives cost a moment of user consideration; false-negatives are no worse than no detection at all.

### 6.2 Session-end batch review

Triggers:
- User signals end-of-session ("let's pause," "stopping for today")
- User explicitly invokes review ("review spawn candidates," "are any sub-concepts ready to spawn?")
- New session resumes with non-empty `## Spawn Candidates` (offer review before continuing forge work)

Process:

1. Read `## Spawn Candidates`, filter to `pending review`.
2. Detect clusters — candidates that are parallel siblings (same source move, parallel architectural function, named together).
3. Present each candidate or cluster with the appropriate **structural framing**:
   - **Standalone**: "[Name] crystallized in [session]. Detection signals: [...]. Spawn or subsume?"
   - **Sharpening-vs-subsidiary** (when independent-purpose signal is borderline): "This may be sharpening a spine question. Same-question test: does it answer a question the spine *already* asks, or a different one?"
   - **Parallel-sibling cluster**: "[Cluster] look parallel ([explanation]). Options — (A) spawn each, (B) spawn a parent concept covering both, (C) spawn one + let other ride, (D) subsume both."
   - **Generative-root**: "[Name] looks like an architectural commitment that may generate follow-ons. Wait for follow-ons to materialize, or spawn now?"
4. User decides per candidate or cluster. Outcomes: **spawn** (→ Step 6.3), **subsume** (mark `kept subsumed`), **defer** (mark `deferred` with reason; remains for next review), **merge** (identify candidate to merge into; update target's signals).

Framings are cognitive helpers, not gatekeepers. User can override.

### 6.3 Spawn procedure

When the user decides "spawn":

- **Step A — Slug + identity.** Propose a kebab-case slug derived from the candidate's purpose-statement (not just its working name). User confirms or revises.
- **Step B — Create spawned forge.** Write `Workbench/concept-forge/[new-slug].md` with standard concept-forge frontmatter (`status: drafting`, `created: <today>`; `project`/`areas`/`tags` optional). **No spawn-specific frontmatter fields** — relationship lives in body sections.
- **Step C — Embed Parent context digest** in the spawned forge's `## State` block as a `**Parent context**` subsection. Includes: spawned-from link, why-spawned (purpose-statement that distinguished it from spine), detection signals at spawn, source moment (link to parent's Session Log entry), anchor verbatim quotes carried forward, sibling candidates from same cluster (if applicable). **Frozen at spawn** — never updated as parent evolves.
- **Step D — Update parent's `## Spawn Candidates`.** Change candidate's status to `spawned YYYY-MM-DD → [[new-spawned-forge]]`.
- **Step E — Bidirectional Cross-links.** In spawned forge: `Spawned from: [[parent-forge]] (YYYY-MM-DD)`. In parent forge: `Spawned sibling: [[new-spawned-forge]] (spawned YYYY-MM-DD) — [candidate concept name]`. Add sibling-spawn links if from a cluster.
- **Step F — User confirmation summary.** "Spawned `[[new-forge-name]]` at `Workbench/concept-forge/[slug].md`. Parent context embedded; bidirectional Cross-links updated; parent's Spawn Candidates marked `spawned`. Continue with batch review or stop here?"

**Cluster cases**: (A) spawn each — execute Steps A-E per candidate; each forge's Cross-links references siblings. (B) spawn parent concept — model creates a new parent concept itself, spawning that as a new forge; the cluster candidates become open threads in the new parent's first session log entry. (C) spawn one + ride — execute Steps A-E for the chosen candidate; the other's status becomes `kept subsumed (rides in parent spine)`.

**Recursive spawn supported**: a spawned forge can itself spawn. Parent context shows immediate parent only; deeper ancestry traceable via Cross-links chain.

The spawn mechanism's design rationale and a backtest against a prior multi-concept forge artifact informed this step; if such a rationale note exists in the workbench, treat it as supplementary background only.

---

## Step 7: Write-through persistence

Every substantive turn must flush state to the artifact before returning to the user. Assume interruption — unrecorded state is lost state. No save-at-end.

### When to create the artifact

On the first turn that produces substance (the spark is named and a slug is proposed), create `Workbench/concept-forge/[slug].md` using the anatomy in Step 8. Initial `status: drafting`. Don't create it before the spark is named — empty artifacts are clutter.

Use `obsidian create path="Workbench/concept-forge/[slug].md" vault="{{VAULT_NAME}}" silent content="..."` for creation, or `Write` tool as fallback. For updates, use `Read` + `Edit` (never `obsidian create overwrite`).

### What to flush each turn

- **`## State`** — update whenever orientation changes (a thread closes, a new thread opens, a decision is made).
- **`## Concept`** — update whenever the evolving card changes.
- **`## Session Log`** — append when: research returns, a role transition happens, user confirms a settled claim, or the user indicates a pause.
- **`## Parking Lot`** — move deferred threads here with one-line context and date.
- **`## Spawn Candidates`** — append a flag whenever a Session Log append fires the Step 6.1 detection criterion. Flag silently; user reviews at session-end (Step 6.2) or on-demand.

Never silently overwrite. If a section changes substantively, the prior version appears in `## Session Log` with a date stamp.

### Flush events and spawn-detection

Spawn-detection (Step 6.1) hooks specifically into **Session Log appends**, not every State or Concept update. State and Concept updates fire frequently on substantive turns; Session Log appends fire at named triggers (research returns, role transitions, settled claims, pauses) — these are the natural recognition moments where the model is already retrospectively writing about what just happened. Spawn candidates accumulate in the artifact's `## Spawn Candidates` subsection without interrupting dialogue.

---

## Step 8: Workbench artifact anatomy

The artifact format — frontmatter, body sections (`## State`, `## Concept`, `## Session Log`, `## Parking Lot`, `## Spawn Candidates`, `## Sources & References`, `## Cross-links`), templates, and anti-pattern reminders — is specified in the **`concept-forge-artifact-format`** rule. Load that rule for the full schema. Both this skill (writer) and `/integrate-concept-forge` (reader) consume it as the single source of truth.

Key reminders that bear on this skill's flow:
- **Path**: `Workbench/concept-forge/[concept-slug].md` (kebab-case slug, descriptive)
- **Initial frontmatter**: `status: drafting`, `created: YYYY-MM-DD`; `categories` and `areas` not required while in workbench
- **`## State` is the read-first block** (<30 lines) — orient new sessions from this
- **`## Concept` follows the `concept-craft` schema** exactly
- **`## Session Log` is append-only, newest-first** — verbatim person quotes belong here with date attribution
- **Don't pre-create** the artifact before the spark is named

---

## Step 9: Graduation

When the user declares `status: ready`:

1. Offer: "Want to run `/integrate-concept-forge [slug]` to graduate this into the vault?"
2. `## State` block becomes vestigial in `ready` status — optionally strip or replace contents with "ready for graduation." (Don't collapse `## Session Log`; `/integrate-concept-forge` Step 7 auto-splits it to a `References/Forge History — [name].md` sibling.)
3. `/integrate-concept-forge` handles the rest as a network-aware decomposition: spine concept note + card-grade satellites with destination hints (evergreen vs scoped) + person-note updates + sources propagation + provenance split + sibling-cluster auto-offer to `/integrate-concept-cluster` if present.

The forge artifact is left in place at `Workbench/concept-forge/[slug].md` after integration (per `/integrate-concept-forge` Step 12 — preserves the artifact as design rationale; user can manually process it later).

---

## Guardrails (from `concept-craft`)

- **Tool is not truth** — when the concept resists the schema, the schema is wrong, not the concept. Leave fields blank or rename them rather than forcing a fit.
- **Anti-refinement-addiction** — default exit is "true enough for this purpose." If you notice yourself tightening past aliveness, say so.
- **No sycophancy** — say "this isn't working" when it isn't. Role + success criterion, not tone.
- **Anti-premature-closure** — user confirms settled claims; the model doesn't.

---

## When you're done with a session

A *session* is complete when the user stops or says pause. Not when the concept is done. Concept completion is a separate, user-declared event ("this is ready").

- On pause: flush everything to artifact, confirm `status: drafting` or `paused` based on user signal, note next candidate moves in `## State`. Then stop.
- On concept completion: run through the graduation offer (Step 9).
- The forge is complete enough when: the user feels it lands, the schema is mostly covered (not exhaustively — nebulosity allowed), substance and coherence are present, or the user declares "good enough for this purpose."

Don't insist on filling every schema field. Some fields stay blank across graduation. That's fine.
