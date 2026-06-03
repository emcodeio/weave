# Composite Drafting — Reference

Used by `/integrate-concept-cluster` Step 6 when the user selects "merge into composite" for an iteration pair. Read this file before invoking the merge.

## Contents
- When to invoke composite drafting
- The delegation pattern (content-drafter agent)
- Merge brief format
- Plan-validate-execute workflow
- Anti-patterns
- Fallback behavior

## When to invoke composite drafting

Composite drafting is invoked **only** when the user explicitly chooses "merge into composite" for an iteration pair in Step 5 of `/integrate-concept-cluster`. Default reconciliation strategies (graduate one + archive other; graduate both; delete one + keep other) do NOT invoke composite drafting.

Typical merge cases (from `iteration-pairs.md`):
- **Both-canonical**: long + compressed forms with overlapping content the user wants synthesized into a single canonical form
- **Working-and-final**: original analysis + user edits where some sections from the analysis weren't carried forward into the edits but the user wants to preserve them
- **Versions-of-same**: multiple iterations where each contributed unique value

When in doubt, prefer keeping both versions over merging — composite drafting is a non-trivial Partner-level operation; only invoke when the user has explicit reason for synthesis.

## The delegation pattern

**Delegate to the `content-drafter` agent via the Task tool.** The agent has persistent memory tracking the user's voice/style preferences across sessions — strongest fit for merging the user's own drafts in the user's voice.

Invocation:

```
Task tool with:
  subagent_type: content-drafter
  description: <short description, e.g., "Merge Habit Workshop Handout long+compressed">
  prompt: <full merge brief — see format below>
```

The agent runs in a forked context (separate conversation history). It reads the source files, synthesizes, and returns a composite draft as its tool result. The skill then surfaces the composite to the user for review.

## Merge brief format

The prompt to `content-drafter` should contain:

1. **Source file paths** — full absolute paths to both (or all) files to merge, so the agent can read them directly.
2. **Intended audience** — who is this composite for? (e.g., "the in-room workshop group"; "the take-home packet readers")
3. **Tone** — what voice/register should the composite adopt? (formal/internal; presentation-room; conversational)
4. **Canonical structure** — what shape should the output take? (slide deck; narrative essay; structured handout; bullet outline)
5. **What to preserve from each version** — explicit instructions about which sections, framings, or examples to keep from each input, and which to drop. If the user said "keep the compressed structure but pull the long version's examples," that goes here.
6. **Anti-instructions** — what NOT to do (e.g., "don't merge if conflicts can't be resolved without fabrication; flag for user instead").
7. **Output format** — return the composite as markdown with frontmatter scaffolded but not finalized. The skill will finalize frontmatter at placement.

Example merge brief:

```
Merge two iteration drafts of the Habit Workshop Handout into a single canonical version for an upcoming habit-formation workshop.

Source files:
- Workbench/Activation Threshold/Activation Threshold — Habit Workshop Handout.md (long form, 9.8k)
- Workbench/Activation Threshold/Activation Threshold — Habit Workshop Handout — Compressed.md (compressed form, 6.8k)

Audience: workshop participants — a mixed group new to the Activation Threshold framing
Tone: warm, practical, plain-language; no jargon beyond the four named concepts
Canonical structure: a one-page handout — a short framing paragraph, then four labeled blocks (Activation Threshold, Friction Stacking, On-Ramp, Threshold Debt), each with a one-line definition and a single concrete worked example

Preserve from long form: the worked examples (the inbox-clearing walkthrough; the two-minute-rule On-Ramp demo) and the framing paragraph.
Preserve from compressed: the pace and the four-block layout; the tight one-line definitions.

Do NOT fabricate facts not present in either source. If the two drafts conflict on a substantive claim, flag the conflict for user resolution rather than synthesizing.

Return: composite as markdown with placeholder frontmatter; no proactive linking yet (skill does that at placement).
```

## Plan-validate-execute workflow

1. **Plan**: Skill builds the merge brief from Step 5's user choice + the source files. Surface the brief to user for confirmation before invoking agent: "Merge brief looks like this — confirm or amend?"
2. **Validate** (agent): Agent reads sources, drafts composite, returns. Skill surfaces composite to user: "Here's the proposed composite. Review and confirm placement?"
3. **Execute**: On user confirmation, skill places composite at proposed destination via Write tool (new file) with frontmatter finalized at placement (categories, areas, status, tags, created — apply proactive linking checklist). Source files are then handled per Step 5's pair-reconciliation choice (typically: archive both originals, OR delete both — user decides).

User can:
- Reject the composite and ask agent to redo with different brief
- Edit the composite manually before placement
- Abandon the merge and fall back to keeping both versions

## Anti-patterns

- **Don't merge silently.** Composite always returns to user for review before placement.
- **Don't fabricate when sources disagree.** Flag conflicts for user resolution; do not synthesize confident merges of contradictory content.
- **Don't preserve attribution markers if absent in source.** If the source files don't have author attribution, don't invent one. If they do, preserve it (e.g., "Jointly drafted with a collaborator").
- **Don't lose source content silently.** If the merge drops a section, note it explicitly: "Section 'X' from the long form was dropped — keep, restore, or confirm drop?"
- **Don't apply final frontmatter inside the agent's draft.** Frontmatter is finalized at placement by the skill, not by the agent.

## Fallback behavior

If `content-drafter` agent invocation fails (agent unavailable, timeout, error in agent execution):

1. Surface the error to user with a clear message: "content-drafter agent failed: [reason]."
2. Offer two recovery options:
   - Retry the agent invocation (maybe transient)
   - Fall back to keeping both versions (skip the merge for this pair; the original Step 5 default — graduate both / archive one — applies instead)
3. Do NOT silently fall back to inline drafting in `/integrate-concept-cluster` itself. Composite drafting is a Partner-level operation that needs voice-tracking memory; inline drafting in this skill would lose that.

## Reference: content-drafter agent location

`.claude/agents/content-drafter.md` — verify it exists before invoking. If the file is missing, surface the error: "content-drafter agent not found at expected path. Cannot perform composite drafting."
