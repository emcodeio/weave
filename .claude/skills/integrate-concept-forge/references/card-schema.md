# Chapman Concept Card Schema — Reference

Used by `/integrate-concept-forge` Steps 8-9 when drafting the spine concept note and satellite concept notes. Source: `.claude/rules/concept-craft.md`.

## Contents
- The schema (table form)
- Per-field guidance for satellite drafting
- Anti-sycophancy and "tool is not truth"
- Spine note structure (modifications from satellite shape)

## The schema

Every forged concept uses this schema. **Purpose-first, not definition-first** — definition-first form smuggles eternalism in.

| Section | Purpose |
|---|---|
| **Core Insight** | The central claim. May be precise, may be "sort-of true for X." Both valid. |
| **Purpose Served** | Singular. What this concept is FOR. One concept, one primary purpose. |
| **Anti-Scope** | What this concept does NOT claim. Prevents purpose creep and overreach. |
| **Nebulosity Type** | Linguistic / epistemic / ontological / mixed. Names the kind of fuzziness that remains. |
| **The Insight Unpacked** | 2-3 paragraphs of flowing prose. Honor the felt sense, not just the logical structure. |
| **Bounds & Edges** | Where it applies, where it doesn't, key assumptions. |
| **Analogies & Connections** | Parallels across domains; wikilinks to related vault notes. |
| **Prior Art** | Adjacent thinkers' framings — how this one differs. Distinguish carefully; no "you've brilliantly discovered X." |
| **Counterarguments & Responses** | Strongest objections steelmanned; responses noted. |
| **Revision Conditions** | What would make this concept want to change? Names it as explicitly provisional. |
| **Open Questions** | What remains unresolved. |

**Fields may be blank.** Blank ≠ failure — it signals where the work is still alive.

## Per-field guidance for satellite drafting

When drafting a satellite from a forge subsection, source content as follows:

### Core Insight
Take the central claim from the forge subsection. If the subsection has an explicit "Core Insight" or "The move" framing, use that verbatim. Otherwise: state the central claim in 2-3 sentences. Preserve the forge's voice.

### Purpose Served
What is this concept FOR? Pull from the forge subsection's purpose framing if present. Otherwise: ask "what conversation does this end?" or "what reductionism does this counter?". Singular: one concept, one primary purpose.

### Anti-Scope
What is this concept NOT? Often the most important section — prevents the concept from creeping into territory it doesn't earn. From the forge subsection, look for explicit "not" claims, "this isn't X" framings, or implicit boundary markers.

### Nebulosity Type
- **Linguistic** — the word is fuzzy. Fix by clearer language.
- **Epistemic** — you don't know enough yet. Fix by evidence.
- **Ontological** — the world itself is fuzzy. Honor and work with it.
- **Mixed** — multiple types co-occur. Common.

Pull from the forge artifact's existing Nebulosity Type if applicable to this satellite specifically.

### The Insight Unpacked
2-3 paragraphs of flowing prose. The longest field. Preserve verbatim content from the forge subsection where it expands the concept; tighten where the forge prose is rough or repetitive. Honor the felt sense, not just the logical structure.

### Bounds & Edges
Where does the concept apply? Where doesn't it? Key assumptions. From the forge subsection: look for "this only works when," "this fails when," "the bound is," or implicit edge cases.

### Analogies & Connections
Parallels across domains. Wikilinks to related vault notes (search via QMD with intent "concepts adjacent to [satellite name]"). Cross-link to spine and to sibling satellites.

### Prior Art
Adjacent thinkers' framings. From the forge artifact's `## Sources & References` — pull citations relevant to this satellite specifically. Note how this concept *differs* from prior art — anti-sycophancy guardrail: "you've brilliantly discovered X" is wrong; specify the difference.

### Counterarguments & Responses
Strongest objections, steelmanned. Pull from the forge's Counterarguments section if relevant; specifically the objections that bear on this satellite (not all of them). Responses note where the concept holds, where it cedes, where it accepts the objection's frame partially.

### Revision Conditions
What would make this concept want to change? Pull from the forge artifact if explicit; otherwise infer from "this depends on" or "this is true only if" claims in the forge.

### Open Questions
What remains unresolved? Often empty if the forge has matured the concept fully. Otherwise: pull genuinely-open threads from the forge's Open Questions section that bear on this satellite.

## Anti-sycophancy and "tool is not truth"

Cross-reference: `concept-craft` rule's anti-sycophancy and refinement-addiction guardrails apply at integration too.

- **Don't force fields to be filled.** Blank fields signal where the work is still alive. A satellite with blank Bounds & Edges is honest; a satellite with hallucinated Bounds & Edges is dishonest.
- **The schema is a tool.** When a satellite's content resists a field (e.g., it has no Counterarguments because it's a deployable principle, not a contested claim), leave the field out or rename it. Honor the concept over the template.
- **Don't refine past aliveness.** If integration is "tightening past the point of aliveness" — adding more to satellites than the forge produced — stop. The default exit is "true enough for this purpose."

## Spine note structure (modifications from satellite shape)

The spine note (Step 8) uses the same schema as satellites, with these modifications:

- **The Insight Unpacked** is the longest field; it carries the binding argument. Often includes the "Argument, Condensed" structure (numbered points binding the satellites together). This is what *makes* the spine survive aggressive extraction — without a binding argument here, the spine fragments into a list of pointers.
- **Analogies & Connections** lists the satellites as wikilinks — e.g., "This concept decomposes into: [[Satellite 1]], [[Satellite 2]] ..." — providing the navigation hub for the network.
- **Prior Art** carries the broader literature; satellites carry only their specific prior art. Sources & References (or pointer to the collection note from Step 6) lives at the bottom of this section.
- **Counterarguments & Responses** bears the load — objections to the whole concept; satellite-specific objections live in their own satellite's Counterarguments section.
- **Forge history footer**: `**Forge history**: [[Forge History — [name]]]`. Also link to the original forge artifact: `**Original forge**: [[Workbench/concept-forge/[slug]]]` (since the artifact stays in workbench per Step 12).

The spine note's frontmatter:

```yaml
---
categories: ["[[Concepts]]"]    # or ["[[Evergreen]]"] depending on user choice
areas: [<inherited from forge>]
status: active
tags: [<inherited from forge plus optional 'concept-spine'>]
created: <today>
forge-source: "[[Workbench/concept-forge/[slug]]]"
forge-history: "[[Forge History — [name]]]"
---
```

The `forge-source` and `forge-history` frontmatter fields are integration-specific provenance markers — they survive even if body wikilinks change.
