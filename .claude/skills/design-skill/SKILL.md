---
name: design-skill
description: "Design and create a new skill for the system, applying the three-level operating model and fork/agent conventions on top of current skill-authoring standards (description-as-trigger, progressive disclosure). Use when the user says 'design a skill', 'create a skill', 'new skill for', or 'add a slash command'."
argument-hint: "[skill purpose and requirements]"
context: fork
agent: system-architect
---

# Design Skill: $ARGUMENTS

## Existing skill patterns

!`head -8 .claude/skills/*/SKILL.md 2>/dev/null || echo "(Could not read existing skills)"`

## Available agents

!`ls -1 .claude/agents/ 2>/dev/null || echo "(Could not list agents)"`

## Skill standards (current)

These are the standards a new skill must meet — and the yardstick the system's own skills are held to. Build on the `skill-creator` and `plugin-dev:skill-development` skills for general mechanics; this skill adds the vault-specific layer.

- **Description is the trigger.** The `description` frontmatter is the primary invocation mechanism — it must carry BOTH what the skill does AND *when* to use it (concrete trigger phrases/contexts). All "when to use" lives here, not in the body. Specific enough to fire reliably without colliding with sibling skills.
- **Lean body + progressive disclosure.** Keep SKILL.md focused (well under ~500 lines). Offload stable, heavy content (schemas, rubrics, worked examples, per-variant detail) into a `references/` subdirectory (the upstream standard — the kepano skills like `obsidian-bases` use it), each file pointed to with an explicit "read X when Y." Prefer `references/` for new skills. (The `concept-forge` / `integrate-concept-forge` / `integrate-concept-cluster` cluster uses this `references/` layout and is a good content exemplar.)
- **Don't restate the rules layer.** Conventions already in CLAUDE.md and `.claude/rules/*.md` (frontmatter schema, proactive linking, obsidian-cli safety, MCP routing) are already loaded — reference the rule, don't re-paste it. Re-stating creates drift.
- **Explain why, not just what.** Prefer reasoning over rigid dictates; the model applies intent.
- **Vault conventions**: name = lowercase-with-hyphens matching the directory; `context: fork` + `agent:` only when the task benefits from isolation or persistent memory; `disable-model-invocation: true` only for procedural, argumentless skills.

## Your task

Design and create a new skill based on: **$ARGUMENTS**

Follow this workflow:

1. **Capture intent** — From the requirements above, determine:
   - What does this skill do?
   - What trigger words should match? (for the description field)
   - Does it need arguments? (argument-hint or not)
   - Which operating level? (Architect, Orchestrate, or Partner)

2. **Ground in the standards** — Apply the Skill standards above. If you read existing skills for shape, prefer recent standards-compliant ones (the concept-forge cluster for progressive disclosure; `open-workbench` / `evaluate-tool` for right-sized non-forked skills) — the older corpus may carry legacy patterns, so don't copy uncritically. Decide:
   - Forked (`context: fork`) or non-forked?
   - If forked, which existing agent fits? Or does a new agent need designing first (`/design-agent`)?
   - What dynamic context (`!` commands) would help?

3. **Design** — Plan the SKILL.md per the standards:
   - Name (lowercase-with-hyphens, matches directory name)
   - `description` carrying what + concrete when-triggers (the invocation surface)
   - Frontmatter (description, argument-hint, context, agent as needed)
   - Dynamic context injection commands
   - Lean workflow steps; push heavy/stable detail to `references/` with explicit pointers
   - Reference rules rather than restating them
   - Output format (what to return to the main conversation)

4. **Create** — Write the SKILL.md file to `.claude/skills/{name}/SKILL.md`

5. **Verify** — Check:
   - `description` carries what + concrete when-triggers; no collision with a sibling skill
   - SKILL.md is lean; heavy/stable content lives in `references/` with clear pointers
   - No re-statement of rules-layer content
   - YAML frontmatter valid; referenced agent exists in `.claude/agents/`; directory name matches `name`
   - Workflow is clear and complete

6. **Commit** — Commit the new skill files to git

## Output

Return:
- **Skill created** — Name and path
- **Design decisions** — Why this pattern (forked/non-forked, agent choice, etc.)
- **Integration notes** — How it connects to existing system components
- **Test suggestion** — How the user could test the new skill
