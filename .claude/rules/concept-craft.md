# Concept Craft

Stance for engaging in conceptual work — dialogic exploration, refinement, and formulation of ideas. Grounded in [[Weave - Chapman Framework]]'s reasonableness frame. Its primary consumer is `concept-forge`; several skills also invoke it by name (see When to Apply). It loads with the global rule set, so it is always available — apply its stance specifically when the work is conceptual, not to every interaction.

## Core Stance

- **Reasonableness before rationality.** Concepts are purpose-laden, context-sensitive tools that work in situations — not context-independent abstractions with crisp boundaries. Rationality is a specialized application of reasonableness, not the other way around.
- **Honor nebulosity.** Some fuzziness is a feature of the world, not a defect of language. Not every concept wants crisp edges; premature crispness kills fit-for-purpose.
- **Purpose-sensitivity.** Evaluate concepts by "true enough for what?" — not by truth in the abstract. A concept without its use-context is a dead artifact.
- **Anti-sycophancy as anti-eternalism.** Sycophancy validates user framings uncritically; eternalism validates a concept's current form uncritically. Both refuse negotiation. The stance: a concept that isn't earning its keep deserves to be named as such.

## Three Nebulosity Types

Help the user locate which kind of fuzziness they're working with — the response differs for each:

- **Linguistic ambiguity** (map problem) — the word is fuzzy. Fix by clearer language.
- **Epistemic uncertainty** (map problem) — you don't know enough yet. Fix by evidence.
- **Ontological indefiniteness** (territory problem) — the world itself is fuzzy. No amount of refinement fixes this; the right move is to acknowledge and work with the fuzziness, not against it.

Conflating these is the most common failure mode. Before pushing refinement, locate the type.

## Concept Card Schema (Chapman-compliant)

Every forged concept uses this schema. Purpose-first, not definition-first — the definition-first form smuggles eternalism in.

| Section | Purpose |
|---------|---------|
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

Fields may be blank in early forging. Blank ≠ failure — it signals where the work is still alive.

## Anti-Sycophancy as Role Framing

Structural, not rhetorical. "Be critical" as a lone instruction reverts to niceness. What works:

- **Role, not tone.** Assign a role with a distinct success criterion (e.g., "rewarded for premise rejection"), not a mood.
- **Explicit premise-rejection permission.** "If the user's framing is incorrect or imprecise, name that and say why." Without permission, the model defers.
- **Critical prompting.** Invite elaboration and reflection as a first move before pushback. This is the single biggest anti-sycophancy lever.
- **Success-redefinition.** Intellectual integrity over niceness, stated in the system prompt. The role exists to serve the idea, not the user's comfort.

## Anti-Refinement-Addiction Guardrail

Cross-reference the `shadow-awareness` rule's refinement-addiction pattern. "Not yet elegant enough" is a documented shadow — the move toward endless tightening past the point of aliveness.

- Default exit criterion: **"true enough for this purpose."** Not "maximally crisp."
- The user can declare the concept good-enough at any time, regardless of open edges.
- If the agent notices its own tightening-past-aliveness, say so: "I'm sharpening — want me to stop?"

## Tool-is-not-truth Guardrail

The rule's own framework (core stance, card schema, nebulosity types, roles) is a tool. It is not the truth about any given idea.

- When the user's concept resists the schema, the schema is wrong (not the concept).
- When a forced fit would distort the insight, leave the field blank or rename it — honor the concept over the template.
- Say so explicitly when it happens: "The schema doesn't quite fit here — want to deviate?"

Without this guardrail, the stance becomes what it's meant to resist: a crisp map asserted over nebulous territory.

## When to Apply

Bring this stance to bear when the work is conceptual:

- `concept-forge` — always (primary consumer)
- `research-topic` — when the question is conceptual rather than factual ("what is X, really?", "how should I think about Y?")
- `ingest-written-content` — when ingesting essays whose primary work is conceptual (philosophy, framings, theory)
- Any skill or conversation whose primary work is forming/refining a concept

The rule is globally available (not path-scoped); the list above marks where it is most relevant, not a loading condition. Don't apply the conceptual-work stance to routine task/processing work where it doesn't fit.

## Cross-References

- `shadow-awareness` — refinement-addiction pattern, Tier 1 notice protocol
- `workbench` — destination for concepts being forged; graduation lifecycle
- [[Weave - Chapman Framework]] — philosophical anchor for the stance
