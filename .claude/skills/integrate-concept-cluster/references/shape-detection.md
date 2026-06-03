# Cluster Shape Detection — Reference

Used by `/integrate-concept-cluster` Step 3 to classify each file in a workbench cluster into one of four shape-types. Read this file before scoring.

## Contents
- The four shape-types (table form)
- Detection signals (filename + content + frontmatter)
- Default fates per shape with override paths
- Worked-example calibration from the Activation Threshold cluster
- "Unknown" handling and reclassification

## The four shape-types

| Shape | What it is | Typical examples |
|---|---|---|
| **Audience-targeted** | Briefings, slide decks, presentations, proposals, handouts — content shaped for a specific reader or session moment | "Talk Outline v2", "Habit Workshop Handout", "Team Briefing Slides", "Conference Proposal" |
| **Conceptual exploration** | Taxonomies, distinctions, framings being developed — work that may feed into a forge spine or graduate as a standalone concept | "Friction Stacking — Distinction", "Warm vs Cold Start Polarity", "Distinction — X vs Y" |
| **Standalone report** | Analyses, audits, field notes, replies, gap reports — self-contained arguments deployable independently | "On-Ramp Field Test Notes", "Deferral-Cost Analysis", "Audit Report" |
| **Cluster nav** | README, INDEX, TOC files — the cluster's own navigation/organization | "README.md", "INDEX.md", "[Cluster Name] — README.md" |

## Detection signals

### Filename signals (primary)

| Shape | Filename patterns |
|---|---|
| Audience-targeted | Contains an audience or venue name (team, workshop, conference, reader name, etc.) AND/OR words: "Briefing", "Presentation", "Slide Deck", "Proposal", "Handout", "Outline", "Pitch". Often has date marker (YYYY-MM-DD) or version marker (v1, v2). |
| Conceptual exploration | Contains "— [Concept Name]" suffix; OR words: "Taxonomy", "Distinction", "Framing", "Polarity", "Mapping", "Decomposition". Often no audience name. |
| Standalone report | Contains words: "Report", "Analysis", "Audit", "Reply", "Investigation", "Field Test", "Gap", "Assessment", "Evaluation", "Notes". Often has date marker. May have audience target (e.g., "Reply to a reviewer") but content is self-contained reasoning, not presentation. |
| Cluster nav | `README.md`, `INDEX.md`, `TOC.md`; or filename ending in "— README" / "— Index". |

### Content signals (secondary, when filename ambiguous)

Read first 50 lines of the file:

- **Audience-targeted**: opens with a stated audience or recipient ("For the workshop group", "Audience: new-habit cohort"); slide-deck structure (`# Slide N` markers, `---` separators); presentation tone (second person; "Today we'll cover...").
- **Conceptual exploration**: heavy table use; explicit "framing," "distinction," "taxonomy" headers; known-unknowns markers (`?` cells, "TBD", "to confirm"); not directed at a specific recipient.
- **Standalone report**: opens with summary/findings; has clear sections like "Findings," "Analysis," "Recommendations"; conclusion is internal-facing or external-facing but not delivered-to-audience-now.
- **Cluster nav**: lists other files in the cluster; may have a graduation matrix; minimal original content (mostly pointers).

### Frontmatter signals (tertiary)

- `project` set + `status: drafting`/`ready` → likely audience-targeted or report
- `categories` already populated (rare in workbench but possible) → use the existing category as a hint
- `tags` containing "briefing", "presentation", "report", "analysis" → strong shape signal

## Default fates per shape

| Shape | Default fate | Destination | Override paths |
|---|---|---|---|
| **Audience-targeted** | Graduate to `References/` as artifact-of-record | `References/[Title].md`, `categories: ["[[Briefings]]"]` or audience-specific | (a) Keep in workbench as living artifact (still being iterated), (b) Delete if superseded, (c) Merge with iteration pair via composite drafting (see `composite-drafting.md`) |
| **Conceptual exploration** | If chained: check absorption against satellite-decision manifest → if absorbed, propose **delete**; if unique content, propose graduate | `Notes/[Concept].md`, `categories: ["[[Concepts]]"]` if graduating | (a) If standalone: check absorption via QMD against existing concept notes; (b) Graduate to satellite; (c) Absorb into existing note |
| **Standalone report** | Graduate to `References/` (external-facing) or `Notes/` (internal-facing) | `References/[Report].md` with `categories: ["[[Reports]]"]`, OR `Notes/[Report].md` with project link | (a) Archive after use (status: completed; stays in References), (b) Delete if redundant |
| **Cluster nav** | Delete (purpose ends with cluster) | `rm` after all other files handled | (a) Archive as project history if user wants to preserve; (b) Keep if cluster will continue to live (rare) |

## Worked-example calibration: Activation Threshold cluster

A sibling workbench cluster that grew alongside the Activation Threshold concept forge — talk-prep, workshop materials, field notes, and concept-exploration docs for the cluster around **Activation Threshold** (the minimum effort to overcome starting-friction and begin a task) and its members **Warm Start**, **Friction Stacking**, **On-Ramp**, and **Threshold Debt**.

| File | Shape | Default fate |
|---|---|---|
| `Activation Threshold — README.md` | Cluster nav | Delete after handling other files (preserves graduation criteria during processing then ends) |
| `Activation Threshold — Talk Outline v1.md` | Audience-targeted (paired with v2) | (See pair handling: superseded by v2, archive or delete) |
| `Activation Threshold — Talk Outline v2.md` | Audience-targeted (paired with v1) | Graduate to `References/Talk Outline — Activation Threshold (2026-04-27).md` |
| `Activation Threshold — Habit Workshop Handout.md` | Audience-targeted (paired with compressed) | (Both-canonical: graduate both OR merge) |
| `Activation Threshold — Habit Workshop Handout — Compressed.md` | Audience-targeted (paired with long) | (Both-canonical: see pair) |
| `Activation Threshold — Conference Proposal (2026-04-30).md` | Audience-targeted (singleton) | Graduate to `References/Conference Proposal — Activation Threshold (2026-04-30).md` |
| `Friction Stacking — Distinction.md` | Conceptual exploration | If chained: likely absorbed into spine/satellite; propose delete. If standalone: graduate as concept note. |
| `Warm vs Cold Start Polarity.md` | Conceptual exploration | If chained: the absorption check finds **Warm Start** was graded a *merge-candidate* in the forge (folds into Activation Threshold's Bounds & Edges, per `card-grade-heuristic.md`) → propose **delete** this doc, not graduate. If standalone (no forge ran): check QMD; likely absorb into the Activation Threshold note. |
| `On-Ramp Field Test Notes (2026-04-28).md` | Standalone report | Graduate to `References/On-Ramp Field Test Notes (2026-04-28).md` with `categories: ["[[Reports]]"]` |

## "Unknown" handling

If a file matches no shape signals strongly, classify as **unknown** and prompt the user:

> Unknown shape for `[filename]`. First 10 lines:
> ```
> [content preview]
> ```
> Classify as: (a) audience-targeted, (b) conceptual exploration, (c) standalone report, (d) cluster nav, (e) other (specify), (f) skip this file.

User reclassifies; continue with their choice.

## Heuristic-vs-judgment guardrail

Per `concept-craft`, when the file's content resists the schema, the schema is wrong, not the file. The heuristic surfaces *classifications*; the user *decides*. Honor user reclassification absolutely. The default fates are starting points, not mandates.
