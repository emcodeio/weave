---
name: integrate-concept-cluster
description: "Triage and integrate a workbench cluster of related working documents — shape detection (audience-targeted / conceptual exploration / standalone reports / cluster nav), iteration-pair reconciliation, optional composite drafting, per-shape fate proposals. Use when the user says to integrate a cluster, graduate working documents, close out a workbench cluster, or process a sibling cluster from a concept forge."
argument-hint: "[cluster-path or cluster-name; optional satellite-decision-manifest if chained]"
---

# Integrate Concept-Cluster: $ARGUMENTS

Triage a workbench cluster of related working documents and integrate them into the vault. Detect shape-types, reconcile iteration pairs, optionally merge into composite documents, and apply graduations / absorptions / deletions per a user-confirmed plan.

This is the **cluster-specific** integration skill. For non-forge single items use `/integrate-workbench` (lightweight default). For concept-forge artifacts use `/integrate-concept-forge` (which auto-offers a chain to this skill at its Step 11). This skill works **standalone** for any workbench cluster (forge-spawned or otherwise — project clusters, research clusters, presentation-prep clusters) AND **chained** from `/integrate-concept-forge` with a satellite-decision manifest passed through.

## Reference rules and global constraints

Load: `concept-craft` (anti-sycophancy guardrails, "tool is not truth"), `workbench` (graduation conventions, frontmatter schema), `operating-principles` (proactive linking checklist), `vault-conventions` (atomic-note discipline + collection-note exception).

**Global constraints:**
- **Plan-before-execute** — Never modify vault state until user confirms each phase. Show the plan, wait for approval, then execute.
- **Per-item user gating** — Heuristics propose; user disposes. Always.
- **Tool is not truth** — When detection or fate logic doesn't fit, the logic is wrong, not the file. Honor user override always.
- **Don't merge silently** — Composite drafting always returns a draft for user review before placement.

## Dynamic Context

### Cluster preview
!`ls -la "Workbench/$ARGUMENTS/" 2>/dev/null || echo "(no cluster at Workbench/$ARGUMENTS/ — try resolving cluster name in Step 1)"`

### Cluster README (if present)
!`obsidian read path="Workbench/$ARGUMENTS/$ARGUMENTS — README.md" vault="{{VAULT_NAME}}" 2>/dev/null | head -60 || echo "(no README — apply default detection)"`

---

## Step 1: Locate cluster and detect invocation mode

Parse `$ARGUMENTS`:
- If a path: read directory directly.
- If a cluster name: resolve to `Workbench/[name]/`.
- If ambiguous or empty: list candidate workbench subdirectories with file counts; ask which to integrate.

**Detect invocation mode:**
- **Standalone**: arguments contain just the cluster name/path. No manifest.
- **Chained**: arguments contain a satellite-decision manifest from `/integrate-concept-forge` (structured as: list of satellites with names, scores, destinations, and absorption pointers indicating which forge sub-concepts mapped to which satellites). When chained, the manifest is the authoritative input for absorption decisions in Step 5.

If chained without a recognizable manifest (caller error), treat as standalone and warn the user.

## Step 2: Cluster inventory

List all files in cluster. Read frontmatter of each (`project`, `status`, `tags`, `areas`). Identify cluster nav (typically `README.md` or named `[Cluster Name] — README.md`).

**If a cluster README exists**, read it carefully. The README often documents graduation criteria per file (the user maintains this as the cluster develops). Use those criteria as authoritative defaults — they override the heuristic defaults in `references/shape-detection.md`.

Surface a one-line summary: "Cluster has N files in K shape-categories; M iteration pairs detected (preview)."

## Step 3: Shape detection

**Read `references/shape-detection.md` before scoring.** Apply the heuristics to classify each file into one of four shape-types:

1. **Audience-targeted** — briefings, slide decks, presentations, proposals
2. **Conceptual exploration** — taxonomies, distinctions, framings being developed
3. **Standalone report** — analyses, audits, replies, gap reports
4. **Cluster nav** — README, INDEX, TOC

Files that don't match any → "unknown" — surface for user reclassification.

Present classification with reasoning visible:

> Shape detection (N files):
> - **Audience-targeted (4)**: Activation Threshold — Talk Outline v1, Activation Threshold — Talk Outline v2, Habit Workshop Handout long, Habit Workshop Handout compressed
> - **Conceptual exploration (2)**: Friction Stacking — Distinction, Warm vs Cold Start Polarity
> - **Standalone report (1)**: On-Ramp Field Test Notes
> - **Cluster nav (1)**: README
> - **Unknown (0)**
>
> Reclassify any?

## Step 4: Iteration-pair detection

**Read `references/iteration-pairs.md` before scoring.** Apply pair-detection heuristics within each shape group:
- Filename similarity (shared base name + version marker)
- Version markers (" v2", " — Compressed", " — My Edits", " — Final", date suffixes)
- Date proximity (typically within 3-5 days)

Present detected pairs with proposed relationship type (supersedes / both-canonical / working-and-final / versions-of-same):

> Iteration pairs detected:
> - **Talk Outline v1 → v2** (supersedes; v2 supersedes v1)
> - **Habit Workshop Handout long + compressed** (both-canonical; both delivered?)
>
> Confirm pairs / break / regroup?

User can confirm, break a pair, or regroup files. **Do not proceed until user confirms.**

## Step 5: Triage proposal — PLAN, do not execute

For each shape group, present default fate from `references/shape-detection.md` plus iteration-pair handling from `references/iteration-pairs.md`. If chained from `/integrate-concept-forge`, apply absorption mapping for conceptual-exploration items.

> **Audience-targeted (4 files, 2 iteration pairs):**
> Default fate: graduate to `References/` as artifact-of-record (categories: `[[Briefings]]` or audience-specific).
> Iteration pairs:
> - Talk Outline v1 → v2 (supersedes): graduate v2; archive v1 (or delete; user chooses)
> - Habit Workshop Handout long + compressed (both-canonical): graduate both — OR — merge into composite via `content-drafter`
> Walk through pairs?
>
> **Conceptual exploration (2 files):**
> [If chained]: matched against satellite-decision manifest:
> - Friction Stacking — Distinction → content absorbed into [[Friction Stacking]] satellite in forge → propose **delete** (content already in vault)
> - Warm vs Cold Start Polarity → no clear absorption → propose **graduate to Notes/** as standalone concept note
> [If standalone]: check absorption against existing `Notes/` via QMD; propose graduate / absorb / delete per item.
>
> **Standalone report (1 file):**
> - On-Ramp Field Test Notes → graduate to `References/` (categories: `[[Reports]]`)
>
> **Cluster nav (1 file):**
> - README → propose **delete** (purpose ends with cluster)

User accepts/skips by group with per-item override. **Do not proceed until user confirms.**

## Step 6: Composite drafting (conditional)

For each iteration pair the user selected "merge into composite" in Step 5, invoke the composite-drafting workflow.

**Read `references/composite-drafting.md` for the full pattern.** Summary: spawn `content-drafter` agent via Task tool with source file paths + merge brief (intended audience, tone, canonical structure). Agent returns a composite draft. Surface to user for review before placement. **Do not place until user confirms each composite.**

If `content-drafter` invocation fails, surface the error to user — do NOT fall back to inline drafting silently.

## Step 7: Execution phase 1 — Graduations

For accepted graduates from Step 5 (audience-targeted → `References/`; standalone reports → `References/` or `Notes/`; conceptual-exploration items selected for graduation):

1. Apply full proactive linking checklist from `operating-principles.md`:
   - Set `categories` (per shape-type default: `[[Briefings]]`, `[[Reports]]`, `[[Concepts]]`, etc. — confirm with user if ambiguous)
   - Set `areas` (inherit from cluster items' frontmatter or from parent project)
   - Set `status: completed` for delivered artifacts; `active` for living references
   - Verify `tags`; ensure `created` is set
   - Search vault for related notes (QMD `vec` query + obsidian search); add wikilinks
   - Verify category note exists; offer to create if missing
2. Move file from `Workbench/[cluster]/` to destination via Bash `mv`
3. Search for and update any references to the old path in other vault notes (use grep/QMD)
4. Update workbench-only frontmatter fields (remove `status: drafting/paused/ready`; remove `project` workbench-link; preserve everything else)

## Step 8: Execution phase 2 — Absorptions

For accepted absorbs from Step 5 (typically conceptual-exploration content folded into a satellite per the manifest, or into existing concept notes):

1. Read the absorption target (the satellite or existing concept note)
2. Read the source artifact
3. Present a merge plan: what content moves where (typically as additions to target's *Bounds & Edges*, *The Insight Unpacked*, or as a sub-section)
4. User confirms merge plan per item
5. Execute: edit target via Edit tool, then delete source via Bash `rm`

**Do not proceed until user confirms each merge.**

## Step 9: Execution phase 3 — Deletions and archives

For accepted deletions from Step 5 (cluster nav README; superseded versions like Talk Outline v1; redundant drafts):

1. List all proposed deletions/archives in one batch
2. Confirm explicitly: "Delete these N files? Git history preserves them."
3. Execute: `rm` for deletions; `mv` to a `.archive/` location if user prefers archive over delete (for living artifacts that might be referenced later)

## Step 10: Cleanup

- If all files in `Workbench/[cluster]/` have been handled and the directory is empty: remove the empty directory.
- Search the vault for any remaining references to old `Workbench/[cluster]/...` paths; report any found (do not auto-fix; surface for user confirmation).
- Verify no broken wikilinks introduced.

## Step 11: Commit and push

```bash
cd "{{VAULT_PATH}}"
git add <graduates> <absorbed-target updates> <composite drafts> <reference updates>
git rm <deletions>
git commit -m "Integrate concept-cluster: [cluster-name]"
git push
```

Use specific file adds/removes, not `git add -A`. The commit message should name the cluster.

## Edge Cases

- **Empty cluster** (only README, no other files) — Skip Steps 3-9; just delete README and remove directory.
- **No iteration pairs detected** — Skip Step 4 confirmation prompt; proceed directly to Step 5 with all files as singletons.
- **No README** — Skip cluster-nav handling; default detection applies to remaining files.
- **Cluster not chained but contains forge-related files** — Run as standalone; absorption pointers won't be available; user does manual mapping in Step 5.
- **content-drafter agent not available or fails** — Surface error to user; offer to retry or to keep both versions instead of merging. Do NOT silently inline.
- **User aborts mid-flow** — No commits made; partial state may exist (some graduations already executed in Step 7 if abort happened in Step 8 or later). On abort, list what executed vs what didn't; offer to commit partial OR rollback (`git restore` for unstaged + `mv` reversal for moved files).
- **Cluster file already exists at destination** — Prompt: "`References/[Name].md` already exists. Merge into existing, rename, or skip?"
- **README references files by old path after their graduation** — Update README references before deleting it, or delete README first (its purpose ends with cluster).

## Anti-pattern reminders

- **Never silently mutate vault state.** Every phase shows the plan; user confirms; then execute.
- **Never collapse user gating into batch-of-one.** Group items, but always allow granular per-item override.
- **Never merge drafts silently.** Composite drafting always returns to user for review before placement.
- **Never fabricate when sources disagree.** If two drafts conflict on a fact, flag for user — don't synthesize a confident merger.
- **Never silently delete files.** Confirm each deletion (or batch with explicit list).
- **Honor "tool is not truth"** (`concept-craft`). When detection or fate logic doesn't fit, the logic is wrong, not the file.
- **Don't break the auto-offered chain.** When invoked from `/integrate-concept-forge`, the manifest is the source of truth for absorption decisions — don't ignore it.
