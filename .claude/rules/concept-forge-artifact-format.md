---
paths: ["Workbench/concept-forge/**"]
---

# Concept-Forge Artifact Format

Specification for the workbench file format that `/concept-forge` writes and `/integrate-concept-forge` reads. The artifact is the memory of the forge — fixed section names so every session and every consumer skill can locate state deterministically.

**Consumer skills:**
- `/concept-forge` — writer. Creates the artifact when the spark is named; flushes state on every substantive turn.
- `/integrate-concept-forge` — reader. Parses the artifact at graduation to decompose into spine + satellites + person notes + provenance split.
- `/integrate-concept-cluster` — indirect consumer. Reads the satellite-decision manifest produced by `/integrate-concept-forge` (which is derived from this format).

## Path

`Workbench/concept-forge/[concept-slug].md`

The slug is kebab-case, descriptive — collaboratively chosen with the user once the spark is named. Examples: `premature-solidification`, `purpose-sensitivity-in-writing`, `activation-threshold`.

## Frontmatter

```yaml
---
status: drafting   # or: paused, ready
created: YYYY-MM-DD
project: "[[Optional Project Link]]"
areas: ["[[Optional Area Link]]"]
tags: []
---
```

No `categories` while in Workbench (workbench exemption per `workbench` rule). `areas` is optional during forging — required at graduation.

## Body sections (fixed order)

The artifact contains seven body sections in this order. Skipping or renaming any breaks consumer skills. `## Spawn Candidates` and the trailing two (`## Sources & References`, `## Cross-links`) are optional — present only when applicable.

### `## State` (read-first block, <30 lines)

The orientation block. First section after the title; consumer skills read this first.

```markdown
## State

**Status**: drafting — [one-sentence current orientation]

**Last session**: YYYY-MM-DD — [2-line summary of what advanced]

**Settled** (do not relitigate without revision-condition trigger):
- [Settled claim 1, one line]
- [Settled claim 2, one line]

**Open threads**:
- [Thread 1, one line]
- [Thread 2, one line]
- [Thread 3, one line]

**Next candidate moves**:
- [Move 1]
- [Move 2]

**Blocker** (if any): [brief]
```

The **Settled** subsection is added when threads close — captures "do not relitigate" decisions so future sessions don't re-explore them.

### `## Concept` — the evolving Chapman-compliant card

The settled / partially-settled concept content. Schema follows `concept-craft` rule exactly:

Core Insight → Purpose Served → Anti-Scope → Nebulosity Type → The Insight Unpacked → Bounds & Edges → Analogies & Connections → Prior Art → Counterarguments & Responses → Revision Conditions → Open Questions.

Fields are blank until forged. Blank ≠ failure — signals where the work is still alive.

A **binding-argument scaffold** (a section like "The Argument, Condensed" or "Summary" or "Core Argument") inside `## Concept` is what makes the spine survive aggressive decomposition at integration time. Without one, `/integrate-concept-forge` falls back to conservative extraction. Add a binding scaffold once the concept has multiple sub-concepts that benefit from a unifying summary.

### `## Session Log` — append-only, newest first

Forge history. Append after each substantive turn or session.

```markdown
## Session Log

### YYYY-MM-DD (session N — short title for the session's arc)
- What advanced
- What was settled
- What was deferred
- Research findings brought in (if any)
- Verbatim quotes / attributions captured (with date and context)
```

Verbatim person quotes belong here with attribution and date — they are the primary input for `/integrate-concept-forge`'s Step 5 (person-note phase). At graduation, the entire `## Session Log` auto-splits into `References/Forge History — [name].md` to preserve the history without polluting active concept retrieval.

### `## Parking Lot` — deferred threads

Threads intentionally paused (distinct from `## State` open threads, which are active).

```markdown
## Parking Lot

- **[One-line thread]** — deferred YYYY-MM-DD. [Brief context on why deferred.]
```

Revisit Parking Lot items when adjacent threads come up. They're not dead; they're parked.

### `## Spawn Candidates` (optional, when sub-concept candidates have been flagged)

Process metadata for the spawn-detection mechanism in `/concept-forge` Step 6. Audit trail of detection decisions, not active concept content. Present only when one or more candidates have been flagged during the forge.

```markdown
## Spawn Candidates

### [Candidate name]
- **Detected**: YYYY-MM-DD (session N — context)
- **Source move**: [pointer to Session Log entry where it was named]
- **Detected signals**:
  - Independent purpose: [purpose statement that distinguishes from spine]
  - Naming step: [verbatim third-party quote OR model phrase from Session Log]
  - Independent citation: [if applicable]
- **Structural pattern**: [sharpening / generative-root / parallel-sibling / standalone — if recognizable]
- **Status**: pending review
```

**Status values**: `pending review`, `spawned`, `kept subsumed`, `deferred`, `merged`. When status changes to `spawned`, append the spawn target: `spawned YYYY-MM-DD → [[new-spawned-forge]]`.

**Position**: after `## Parking Lot`, before `## Sources & References` — process-metadata sections cluster.

**At graduation**: `/integrate-concept-forge` Step 7 includes this section in the Forge History split, same provenance shape as `## Session Log`. Spawn decisions are forge-design rationale, not active concept content.

### `## Sources & References` (optional, when applicable)

External sources / citations brought into the forge during exploration. Group by thematic clusters (subsection headers) when 3+ clusters emerge.

```markdown
## Sources & References

### [Thematic cluster 1]
- [Source 1 with citation / URL]
- [Source 2]

### [Thematic cluster 2]
- [Source 3]
```

`/integrate-concept-forge` Step 6 (sources phase) propagates this section — when 8+ sources OR 3+ thematic clusters, proposes a collection note in `Notes/`; otherwise inline in the spine.

### `## Cross-links` (optional, when applicable)

Wikilinks to sibling forges, worked examples, related concept notes, source skills/rules. One level deep — these are pointers, not embedded content.

```markdown
## Cross-links

- Sibling forge: `[[other-forge-name]]` — relationship description
- Worked example: `[[example-artifact]]` — primary test fixture
- Source skill: `/skill-name` (system file at `.claude/skills/[name]/SKILL.md`)
- Related concept: `[[Existing Concept Note]]` — relationship description
```

## Workbench exemption

The standard workbench proactive-linking exemption applies (see `workbench` rule). Forge-specific: graduation runs through `/integrate-concept-forge` rather than the generic `/integrate-workbench`.

## Anti-pattern reminders

- **Never silently overwrite** — when a section changes substantively, the prior version appears in `## Session Log` with a date stamp.
- **Never modify historical session log entries** beyond renaming references for canonical naming consistency. Append-only is the discipline.
- **Never skip section names** to "save space" — consumer skills locate sections by exact name.
- **Don't pre-create** the artifact before the spark is named. Empty artifacts are clutter.
- **Never silently spawn** — `## Spawn Candidates` accumulates flags during forge, but spawn-decisions belong to the user (per `/concept-forge` Step 6.2). The model proposes; the user decides.
- **Don't update `**Parent context**` in spawned forges** — it's a snapshot at spawn time, not a live mirror. Future evolution of either forge happens independently. Cross-links provide live navigability.
- **No spawn-specific frontmatter fields** — the parent-child relationship lives in body sections (`## State` Parent context subsection + `## Cross-links`), not in YAML frontmatter. Standard concept-forge frontmatter applies to spawned forges unchanged.
