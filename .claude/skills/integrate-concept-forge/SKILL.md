---
name: integrate-concept-forge
description: "Graduate a concept-forge artifact into the vault as a network of notes — spine concept + card-grade satellites + person-note updates + sources propagation + provenance split + sibling-cluster auto-offer. Use when the user says to integrate a concept-forge artifact, graduate a forge, or close out a forging session."
argument-hint: "[forge-slug or path to Workbench/concept-forge/[slug].md]"
---

# Integrate Concept-Forge: $ARGUMENTS

Graduate a concept-forge artifact at `Workbench/concept-forge/[slug].md` into a network of permanent vault notes — spine concept + card-grade satellites + person-note touches + sources propagation + provenance split + auto-offered chain to `/integrate-concept-cluster` if a sibling workbench cluster exists.

This is the **forge-specific** integration skill. For non-forge workbench items use `/integrate-workbench` (lightweight default). For workbench clusters use `/integrate-concept-cluster` (this skill auto-offers the chain at Step 11).

## Reference rules and global constraints

Load: `concept-craft` (concept card schema, anti-sycophancy/refinement-addiction guardrails, "tool is not truth"), `concept-forge-artifact-format` (specification of the workbench file format being parsed — frontmatter, body sections, templates), `workbench` (graduation conventions), `operating-principles` (proactive linking checklist), `vault-conventions` (atomic-note discipline + collection-note exception, frontmatter conventions, 7-folder structure).

**Global constraints:**
- **Plan-before-execute** — Never modify vault state until user confirms each phase. Show the plan, wait for approval, then execute.
- **Per-item user gating** — Heuristics propose; user disposes. Always.
- **Tool is not truth** — When the schema or heuristic doesn't fit, the schema is wrong, not the content. Honor user override always.
- **Self-similarity check** — The heuristics introduce structure. Don't let structure force decomposition where coherence wants preservation.

## Dynamic Context

### Forge artifact preview
!`obsidian read path="Workbench/concept-forge/$ARGUMENTS.md" vault="{{VAULT_NAME}}" 2>/dev/null | head -60 || echo "(forge artifact not at Workbench/concept-forge/$ARGUMENTS.md — try resolving slug in Step 1)"`

### Sibling cluster preview
!`ls -la "Workbench/$ARGUMENTS/" 2>/dev/null || echo "(no direct sibling cluster at Workbench/$ARGUMENTS/)"`

---

## Step 1: Locate and validate the forge artifact

Parse `$ARGUMENTS`:
- If a path: read directly via `obsidian read path=...`.
- If a slug: resolve to `Workbench/concept-forge/[slug].md`.
- If ambiguous or empty: search via `obsidian search query="path:Workbench/concept-forge/ $ARGUMENTS"` and ask which to integrate.

Read the full file. Verify frontmatter `status: ready`. If `status: drafting` or `paused`, confirm: "This forge is `[status]` — proceed with integration?"

## Step 2: Detect binding-argument scaffold

Aggressive decomposition requires a binding summary in the spine that holds structure together after extraction. Scan `## Concept` for a section named like:
- "The Argument, Condensed"
- "The Core Argument"
- "Summary"
- "The Move(s)"
- Or content that functions as a numbered binding-summary at the start of `## Concept`

**If absent**, warn:

> No binding-argument scaffold detected. Aggressive extraction risks fragmenting the concept into a list of pointers without binding structure. Options:
> (a) Pause; write a binding summary first (recommended) — exit skill, user edits forge, re-runs.
> (b) Conservative extraction — only the 1-2 strongest satellites.
> (c) Proceed aggressive anyway (not recommended).

Wait for user choice. If (a): exit. If (b): note conservative mode for Step 3. If (c): proceed.

## Step 3: Decomposition proposal — PLAN, do not execute

Apply the card-grade heuristic from `references/card-grade-heuristic.md` to each subsection of `## Concept`. **Read that reference file before scoring.** It contains the 4-criterion rubric, the threshold rule (2+ checks → satellite candidate), the destination-hint logic (evergreen vs scoped), and worked-example calibration.

For each candidate: compute the score, classify destination (evergreen / scoped / mixed), and group by kind:
- Vocabulary moves
- Strategic frames
- Thought experiments / lenses
- Deployable principles

Present grouped proposal with per-candidate score visible:

> **Group 1: Deployable principles (3 candidates)**
> — Activation Threshold (4/4, evergreen)
> — Friction Stacking (3/4, evergreen)
> — On-Ramp (3/4, evergreen)
> Accept all? Some? Skip?
>
> **Group 2: Strategic frames (1 candidate)** ...

User accepts/skips by group with granular per-item override. **Do not proceed until user confirms.** If conservative mode (Step 2 fallback), propose only the top 1-2 highest-scoring candidates.

## Step 4: Spine-preservation check

Build the post-extraction spine outline from accepted satellites in Step 3. Show the user the spine as it will look after extraction:

> Spine after extraction:
> # [Forge Title]
> ## Core Insight — preserved
> ## The Argument, Condensed — preserved with cross-refs to [[Satellite 1]], [[Satellite 2]] ...
> ## Purpose Served / Anti-Scope / Nebulosity Type — preserved
> ## Counterarguments & Responses — preserved
> ## Satellites — list of wikilinks
>
> Concur, or pull anything back into the spine?

User can pull items back into the spine (extraction skipped for those items; content stays inline). **Do not proceed until user confirms.**

## Step 5: Person-note phase

Aggregate verbatim quotes + contributions per person across `## Concept` and `## Session Log`. Use grep / obsidian search across the forge artifact to find every quote attribution and ratification marker.

For each person, present a per-person gate:

> **[Person Name]** has N contributions to this forge:
> 1. [contribution one] (date / context)
> 2. [contribution two] (date / context)
> ...
>
> Add all N to `References/[Person Name].md`? Some? Skip?

If person note doesn't exist, propose creation using the person template (search `Templates/` for the canonical person template). User accepts/amends per person. **Do not proceed until user confirms each person.**

## Step 6: Sources phase

Count sources in `## Sources & References`. Group by thematic clusters (subsection headers in that section).

**Heuristic**: 8+ total sources OR sources span 3+ thematic clusters → propose collection note at `Notes/[Topic] Reading List.md` (intentional anti-atomic exception per `vault-conventions`). Else inline in spine's Sources section.

For collection-note proposal, draft a one-line description and propose category note. User confirms/amends. **Do not proceed until user confirms.**

## Step 7: Auto-split provenance (no user gate)

Move `## Session Log` content from forge artifact to a new `References/Forge History — [forge-name].md`. If `## Spawn Candidates` exists in the forge artifact (any status), include it in the same Forge History split — same provenance shape. Spawn decisions are part of the forge's design rationale and belong in the historical record, not in active retrieval. Active spawned forges retain their links via `## Cross-links` (which propagate to the spine concept note via Step 10).

```yaml
---
categories: ["[[Forge History]]"]
areas: [<inherited from forge>]
status: completed
tags: [forge-history]
created: <today>
source: "[[Workbench/concept-forge/[forge-name]]]"
---

# Forge History: [forge-name]

## Session Log

[Session log content verbatim, newest first]

## Spawn Candidates

[Spawn candidates content verbatim — only if the section existed in the source]
```

The spine note (built in Step 8) keeps a footer pointer: `**Forge history**: [[Forge History — [name]]]`. This step has no user gate — it's a settled default per design.

## Step 8: Build the spine concept note

From the (now-thinner) `## Concept` block — the spine after Step 4 confirmation — draft the spine note. Reference `references/card-schema.md` for the Chapman card schema and per-field guidance, especially the **Spine note structure** section at the end.

Use Edit tool for safe placement (never `obsidian create overwrite`). Apply the full proactive linking checklist from `operating-principles.md`:
1. Set `categories` (typically `[[Concepts]]` or `[[Evergreen]]`; ask user if ambiguous).
2. Set `areas` (inherit from forge frontmatter).
3. Set `status: active`.
4. Verify `tags`; ensure `created` is set.
5. Search vault for related notes (QMD `vec` query with intent + obsidian search for keywords); add wikilinks where meaningful.
6. Verify category note exists; offer to create if missing.

Place at `Notes/[Forge Title].md`. Add the forge-history footer pointer.

## Step 9: Build satellite notes

For each accepted satellite from Step 3, draft a Chapman card note. **Read `references/card-schema.md` first** for per-field guidance; that file documents how to source each field from the forge subsection.

For each satellite:
1. Draft using the Chapman card schema (Core Insight; Purpose Served; Anti-Scope; Nebulosity Type; The Insight Unpacked; Bounds & Edges; Analogies & Connections; Prior Art; Counterarguments & Responses; Revision Conditions; Open Questions). Fields may be blank where the forge content didn't develop them.
2. Source content from the corresponding subsection of the forge's `## Concept`. Pull verbatim quotes; cite sources from `## Sources & References` where they're cited there.
3. Apply proactive linking checklist (categories per Step 3 destination; areas inherited; related notes searched).
4. Route to destination — evergreen → `Notes/[Satellite Title].md` with `categories: ["[[Concepts]]"]` or `["[[Evergreen]]"]`; scoped → `Notes/[Satellite Title].md` with project link in body.
5. Cross-link: each satellite links back to the spine; relevant sibling satellites link to each other.

## Step 10: Cross-link propagation

Search the vault for related concept notes that should reference the new vocabulary.

Use QMD: `mcp__qmd__query` with:
- `searches`: `[{type:'vec', query:'[satellite name] OR [spine concept name]'}]`
- `intent`: "finding existing concept notes that should reference [new vocabulary] from this forge"

Present matches:

> Related notes that may benefit from updating:
> - `[[Existing Concept Note]]` — score 0.85 — likely needs reference to [[Activation Threshold]]
> - `[[Other Note]]` — score 0.72 — likely needs reference to [[Friction Stacking]]
>
> Update these? Per-note gates.

For accepted updates, propose the specific edit (typically a wikilink + one-sentence context). User accepts/skips per note. **Do not proceed until user confirms each.**

## Step 11: Sibling-cluster auto-offer

Check for adjacent workbench cluster:
- `Workbench/[Forge Title]/` — direct subdirectory
- `Workbench/[adjacent name]/` — semantically related workbench subdirectory referenced in the forge body

If detected:

> Cluster detected at `[path]` (N files). Run `/integrate-concept-cluster` now? It will receive the satellite-decision manifest from this run as context.
> (a) Yes, run now — chain in same session.
> (b) Later — I'll run `/integrate-concept-cluster` standalone.

If (a): invoke `/integrate-concept-cluster` with satellite-decision manifest passed through (which content was absorbed into which satellite, so cluster triage can reference it). If (b) or no cluster detected: skip.

## Step 12: Leave the forge artifact in place

**Do NOT** move, archive, or delete the forge artifact. The artifact remains at `Workbench/concept-forge/[slug].md` after integration.

User direction: artifact still serves as design rationale during sibling skill development; user may process it later (potentially via this skill on itself as a self-test once both integration skills are stable).

Surface a one-line note: "Forge artifact left in place at `Workbench/concept-forge/[slug].md` — process later when ready."

## Step 13: Commit and push

```bash
cd "{{VAULT_PATH}}"
git add <new spine note> <satellite notes> <person-note updates> <forge-history sibling> <collection note if any> <related-concept updates>
git commit -m "Integrate concept-forge: [forge-name]"
git push
```

Use specific file adds, not `git add -A`. Forge artifact stays in workbench (untouched), so it's not in the commit.

## Edge Cases

- **Forge `status: drafting` or `paused`** — Confirm before proceeding; the artifact may not be ready.
- **No satellite candidates** (all subsections score <2/4) — Skip Steps 3-4. Single-concept integration: just the spine note. Run Steps 5-13.
- **No binding-argument scaffold + user picks (b)** — Conservative extraction: top 1-2 strongest candidates only.
- **Cluster-only graduation needed** — User wants to integrate cluster but not concept yet. Direct them to `/integrate-concept-cluster` standalone; exit this skill.
- **User aborts mid-flow** — No commits made; nothing on disk has changed. Confirm: "Aborting. Forge artifact and vault unchanged. Re-run when ready."
- **Person already has a note + new contributions** — Read existing note; append new contributions section dated by forge graduation; preserve existing content.
- **Satellite name collides with existing note** — Prompt: "Existing `[[Note Name]]` found. Merge into existing, rename satellite, or skip?"

## Anti-pattern reminders

- **Never silently mutate vault state.** Every phase shows the plan; user confirms; then execute.
- **Never collapse user gating into batch-of-one.** Group items, but always allow granular per-item override.
- **Never force decomposition where coherence wants preservation.** If the user says "leave it in spine," honor it absolutely.
- **Never invent verbatim quotes.** Person-note contributions cite the artifact's actual quotes — copy verbatim, attribute by date.
- **Honor "tool is not truth"** (`concept-craft`). When the heuristic or schema doesn't fit, the heuristic is wrong, not the content.
