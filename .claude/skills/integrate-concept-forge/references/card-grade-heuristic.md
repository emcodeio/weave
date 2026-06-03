# Card-Grade Heuristic — Reference

Used by `/integrate-concept-forge` Step 3 to identify satellite candidates from the forge artifact's `## Concept` block. Read this file before scoring.

## Contents
- The 4-criterion scoring rubric
- Threshold rule (2+ checks → satellite candidate)
- Destination-hint logic (evergreen vs scoped)
- Worked-example calibration
- Edge cases
- Heuristic-vs-judgment guardrail

## The 4-criterion scoring rubric

For each subsection of `## Concept`, score against four criteria:

| # | Criterion | What to check |
|---|---|---|
| 1 | **Own purpose** | Does this section have its own clear purpose statement (not "an example of the larger argument" or "an application of X")? Look for explicit *Purpose* statements, deployable forms, or clear "this is for X" framing. |
| 2 | **Own structural element** | Does it have its own table, thought experiment, pull-quote, definition, or other distinct structural form? Plain prose subsections do NOT score here; structural artifacts that anchor the concept do. |
| 3 | **Independently deployed** | Has the user already used this independently (e.g., in a meeting, conversation, or other artifact)? Look for "deployed by [person]", "used at [meeting]", "verbatim deployment in [conversation]" markers in the section or session log. |
| 4 | **Cross-domain reuse** | Could this be used in conversations beyond this artifact's project? Apply the test: would someone in a different domain (different team, different problem) find this useful? |

**Threshold**: 2 or more checks → **satellite candidate**.

## Destination hint logic

For each satellite candidate, classify destination based on criterion 4 (cross-domain reuse):

- **Strong cross-domain reuse** (criterion 4 firmly true) → **evergreen satellite**
  - Destination: `Notes/[Satellite Title].md`
  - Categories: `["[[Concepts]]"]` or `["[[Evergreen]]"]`
  - Linked from category notes
- **Weak / artifact-bound cross-domain reuse** (criterion 4 partially true or false; primarily applies in this artifact's project) → **scoped satellite**
  - Destination: `Notes/[Satellite Title].md`
  - Categories: project's category (e.g., `["[[Research]]"]`)
  - Project wikilink in body
  - Linked from project notes

When mixed (some content evergreen, some scoped), present both options to the user via Step 3's per-item override.

## Worked-example calibration

Pressure-test against a forge artifact for **Activation Threshold** — the minimum effort needed to overcome starting-friction and begin a task (productivity / habit-formation domain). The forge's `## Concept` accumulated several sub-concepts. Scoring them produced these calibrations:

| Subsection | C1 | C2 | C3 | C4 | Score | Verdict |
|---|---|---|---|---|---|---|
| Activation Threshold (the spine concept itself) | ✓ | ✓ (definition) | ✓ (used in a planning session) | ✓ (any task / habit domain) | **4/4** | Spine — but a clean enough card that it could also seed an evergreen note |
| Friction Stacking | ✓ | ✓ (table of compounding frictions) | partial | ✓ (any onset-of-action problem) | **3/4** | Evergreen satellite |
| On-Ramp (the deliberately tiny first action) | ✓ | ✓ (the two-minute-rule pull-quote) | ✓ (deployed in a workshop handout) | ✓ (any behavior-change context) | **4/4** | Evergreen satellite |
| Threshold Debt | ✓ | ✓ (definition) | partial | ✓ (any deferral / procrastination conversation) | **3/4** | Evergreen satellite |
| Warm Start (resuming mid-flow vs cold start) | ✓ | partial | partial | partial (mostly sharpens Activation Threshold) | **2/4** | Merge-candidate — folds into Activation Threshold's Bounds & Edges rather than standing alone |
| "Worked walkthrough: clearing the inbox" | ✗ (it's an *application*) | ✗ | ✗ | ✗ | **0/4** | Stays in spine as a spine example |
| "How to lower a threshold (deployment notes)" | ✗ | partial | partial | partial | **1/4** | Stays in spine (deployment notes belong with the spine) |

Total from this forge: ~3 evergreen satellites (Friction Stacking, On-Ramp, Threshold Debt); 1 merge-candidate (Warm Start → folds into the spine); the spine concept and its walkthroughs stay inline.

## Edge cases

### Subsection vs sub-concept

A subsection that's "an example of X" or "an application of X" is NOT a satellite — it's a spine example. Look for *self-standing concepts*, not illustrations. Test: would the section make sense as a note title on its own? "Friction Stacking" yes. "Worked walkthrough: clearing the inbox" no (it's an example of a concept).

### Cross-domain reuse signal

Strong signals: vocabulary that applies broadly (any onset-of-action problem; any behavior-change context; any deferral conversation), decision frameworks, philosophy-of-X claims.

Weak signals: applications tied to one project or one tool (a specific app's onboarding flow; a single team's ritual). May still be card-grade but as scoped, not evergreen.

### Merge-candidates (sharpening, not standing alone)

Some sub-concepts mostly *sharpen* the spine rather than answering a different question. **Warm Start** is the example: "resuming mid-flow has a lower threshold than a cold start" is a refinement of Activation Threshold, not an independent concept. It scores 2/4 but its independent purpose is weak — the same-question test (does it answer a question the spine already asks?) comes back "yes, it sharpens the threshold idea." Default: fold it into the spine's *Bounds & Edges* rather than extracting a thin satellite. The user can override and extract it if they want a standalone note.

### Mixed cases

Some sub-concepts have evergreen *vocabulary or move* with scoped *application*. For these, the user picks at Step 3 — usually splitting into an evergreen note + a project-scoped follow-up note, or accepting one form.

### What's NOT a satellite candidate

These sections stay in the spine regardless of score, because they're part of the spine's binding structure:
- Counterarguments & Responses (binding argument's central rebuttal)
- Anti-Scope clauses
- Open Questions
- Revision Conditions
- Bounds & Edges
- Spine examples / concrete walk-throughs of the concept
- "How to deploy" sections (deployment notes belong with the spine, not as satellites)
- The "Argument, Condensed" itself (this IS the binding scaffold; never extract)

## Heuristic-vs-judgment guardrail

**This heuristic is a tool, not the truth.** Per `concept-craft`, when a candidate's content resists the schema, the schema is wrong, not the content. The heuristic surfaces *candidates*; the user *decides*. Always honor user override:

- "Score this 4/4, but I want to leave it in spine" → leave in spine, no extraction.
- "Score this 1/4, but I want to extract it" → extract anyway, ignore the threshold.
- "These two should merge into one satellite" → merge, ignore the per-section count.
- "This is mixed — extract the evergreen part as a satellite, leave the scoped application in the spine" → split, even though the heuristic doesn't natively support it.

The heuristic exists to make the user's decision easier, not to replace it.
