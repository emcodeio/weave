---
name: design-skill
description: "Design and create a new skill for the system. Captures intent, researches patterns, designs the SKILL.md, and creates it. Use when the user says 'design a skill', 'create a skill', 'new skill for', or 'add a slash command'."
argument-hint: "[skill purpose and requirements]"
context: fork
agent: system-architect
---

# Design Skill: $ARGUMENTS

## Existing skill patterns

!`head -8 .claude/skills/*/SKILL.md 2>/dev/null || echo "(Could not read existing skills)"`

## Available agents

!`ls -1 .claude/agents/ 2>/dev/null || echo "(Could not list agents)"`

## Your task

Design and create a new skill based on: **$ARGUMENTS**

Follow this workflow:

1. **Capture intent** — From the requirements above, determine:
   - What does this skill do?
   - What trigger words should match? (for the description field)
   - Does it need arguments? (argument-hint or not)
   - Which operating level? (Architect, Orchestrate, or Partner)

2. **Research patterns** — Read 2-3 existing skills that are most similar. Decide:
   - Forked (`context: fork`) or non-forked?
   - If forked, which existing agent fits? Or does a new agent need to be designed first?
   - What dynamic context (`!` commands) would help?

3. **Design** — Plan the SKILL.md:
   - Name (lowercase-with-hyphens, matches directory name)
   - Frontmatter fields (name, description, argument-hint, context, agent)
   - Dynamic context injection commands
   - Workflow steps (numbered, clear, actionable)
   - Quality standards specific to this skill's output
   - Output format (what to return to the main conversation)

4. **Create** — Write the SKILL.md file to `.claude/skills/{name}/SKILL.md`

5. **Verify** — Check:
   - YAML frontmatter is valid
   - Referenced agent exists in `.claude/agents/`
   - Directory name matches the `name` field
   - Workflow is clear and complete

6. **Commit** — Commit the new skill files to git

## Output

Return:
- **Skill created** — Name and path
- **Design decisions** — Why this pattern (forked/non-forked, agent choice, etc.)
- **Integration notes** — How it connects to existing system components
- **Test suggestion** — How the user could test the new skill
