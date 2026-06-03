# Iteration-Pair Detection — Reference

Used by `/integrate-concept-cluster` Step 4 to identify version pairs/groups within shape-classified files. Read this file before scoring.

## Contents
- Pair-detection heuristics
- Pair relationship types
- Reconciliation strategies per relationship type
- When to propose merge vs keep both vs delete-and-keep
- Worked-example calibration

## Pair-detection heuristics

Apply within each shape group (typically pairs form within audience-targeted artifacts; less common in conceptual exploration; rare in standalone reports).

### Filename similarity

Two files are pair candidates if:
- They share a base name (e.g., "Talk Outline" with different version markers)
- One filename is a substring of the other plus a version marker
- They differ by a single descriptive suffix ("— Compressed", "— My Edits", "— Final", "— Draft")

### Version markers (filename-level)

| Marker | Meaning |
|---|---|
| ` v1` / ` v2` / ` v3` | Sequential versions |
| ` — Compressed` / ` — Long` | Companion forms (different lengths, same content) |
| ` — My Edits` / ` — Edits` | User edits to a base draft |
| ` — Final` | Marked final (often paired with earlier draft) |
| ` (rev)` / ` (revised)` | Revision marker |
| Date suffix variations (`(2026-04-27)` vs `(2026-04-30)`) | Different deliveries; may be same content for different audiences |

### Date proximity

Files modified or named within 3-5 days of each other are stronger pair candidates than files separated by weeks. Check both filename dates and `created`/modification times.

### Content similarity (optional, expensive)

When filenames are ambiguous, do a quick first-50-lines comparison. High overlap (similar headings, similar opening) → likely a pair. Use only when filename signals are insufficient.

## Pair relationship types

Once pairs are detected, classify the relationship to drive reconciliation strategy.

### Supersedes (v1 → v2)

The newer version supersedes the older. Older is a development draft; newer is the canonical form.

- **Signals**: explicit v1/v2 markers; date progression; v2 is larger or more polished; user has typically marked v2 with `status: ready` while v1 stays `drafting`
- **Default reconciliation**: graduate v2; archive or delete v1
- **Override**: user may want to preserve v1 as a development record (rare)

### Both-canonical (long + compressed)

Both versions were intentionally produced and may have both been delivered or used. Different forms serving different purposes.

- **Signals**: companion suffixes ("— Compressed" / "— Long"); both have similar status; both may have been delivered (mention in session log or daily notes)
- **Default reconciliation**: graduate both — OR — merge into composite (user choice; composite drafting via `content-drafter` agent)
- **Override**: archive one if redundant after delivery

### Working-and-final (analysis + my edits)

A working draft followed by a user-edited refinement. Edits supersede the analysis but preserve original structure.

- **Signals**: "— My Edits", "— Edits" suffix; the edits version is shorter or differs structurally; user explicitly marked one as edits
- **Default reconciliation**: graduate the edits version as canonical; archive the analysis (or delete if no longer needed)
- **Override**: composite if user wants to preserve sections from analysis that weren't carried into edits

### Versions-of-same (intermediate iteration)

Multiple iterations of the same artifact, none clearly superseding (e.g., multiple drafts during back-and-forth feedback).

- **Signals**: similar filenames; close date proximity; no clear v1/v2/edits markers
- **Default reconciliation**: graduate the latest; archive the rest (or delete)
- **Override**: merge composite if multiple drafts have unique value

## Reconciliation strategies per relationship type

| Relationship | Default | Alternative 1 | Alternative 2 |
|---|---|---|---|
| Supersedes | Graduate newer; archive older | Delete older | Merge composite (rare) |
| Both-canonical | Graduate both | Merge composite | Archive one if redundant |
| Working-and-final | Graduate final; archive working | Merge composite | Delete working |
| Versions-of-same | Graduate latest; archive rest | Merge composite | Delete all-but-latest |

## When to propose merge vs keep both vs delete-and-keep

The user's choice depends on what each version contributes:

- **Both versions have unique value, both delivered or both reusable** → merge into composite (delegates to `content-drafter` agent — see `composite-drafting.md`)
- **One version supersedes the other completely** → delete-and-keep (or archive-and-keep if there's preservation value)
- **Both versions reflect intentionally different forms** (long for one audience, compressed for another) → keep both
- **One version has historical value but is no longer canonical** → archive (move to References/ with `status: completed`)

The skill proposes the default per relationship type; the user's per-pair override drives the actual choice.

## Worked-example calibration: Activation Threshold cluster

| Pair | Relationship | Default | Notes |
|---|---|---|---|
| Talk Outline v1 + v2 | Supersedes | Graduate v2; archive v1 | v2 is larger; date progression visible; v2 absorbed feedback from a v1 run-through |
| Habit Workshop Handout long + Compressed | Both-canonical | Graduate both — OR — merge into composite | Long for the take-home packet, compressed for the in-room one-pager |

Note: The `Conference Proposal` is a singleton — no companion version in iteration with the other audience-targeted files. Treat as singleton, not part of any pair.

## Heuristic-vs-judgment guardrail

Per `concept-craft`, when pair detection is wrong or relationship classification doesn't fit, the heuristic is wrong, not the file. The user can:
- Break a detected pair (treat as singletons)
- Group additional files into an existing pair (e.g., "v1 + v2 + v3 — treat as a triple")
- Reclassify the relationship type ("this isn't supersedes, it's both-canonical")
- Override the default reconciliation per pair

Heuristic surfaces; user disposes.
