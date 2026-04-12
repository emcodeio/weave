---
name: design-agent
description: "Design and create a new agent for the system. Captures requirements, selects model and tools, writes the system prompt, and configures memory scope. Use when the user says 'design an agent', 'create an agent', 'new agent for', or 'I need an agent that'."
argument-hint: "[agent purpose and requirements]"
context: fork
agent: system-architect
---

# Design Agent: $ARGUMENTS

## Existing agent patterns

!`head -8 .claude/agents/*.md 2>/dev/null || echo "(Could not read existing agents)"`

## Your task

Design and create a new agent based on: **$ARGUMENTS**

Follow this workflow:

1. **Capture requirements** — From the description above, determine:
   - What is this agent's primary responsibility?
   - What tools does it need? (Read, Grep, Glob, Write, Edit, Bash, WebSearch, WebFetch)
   - Will it delegate to other agents or be delegated to?
   - Does it interact with external systems (Calendar, Reminders, web)?

2. **Select model & memory** — Choose:
   - **Model**: `opus` (deep reasoning, creative work, complex decisions) or `sonnet` (mechanical tasks, straightforward processing)
   - **Memory**: `user` (personal knowledge that transfers across projects) or `project` (codebase-specific knowledge)

3. **Design system prompt** — Write a clear, structured prompt covering:
   - Role declaration — what the agent is and does
   - System context — vault name, file locations, git workflow
   - Workflow steps — how the agent approaches its work
   - Quality standards — what good output looks like
   - Output format — structured return to the main conversation
   - Memory tracking — what to remember across sessions

4. **Create** — Write the agent file to `.claude/agents/{name}.md` with valid frontmatter + system prompt

5. **Verify** — Check:
   - YAML frontmatter parses correctly
   - Tool list contains only valid tool names
   - Model is `opus` or `sonnet`
   - Memory is `user` or `project`
   - System prompt is under ~100 lines

6. **Connect to skills** — Identify which skills should fork to this agent:
   - Note existing skills that could use it
   - Suggest new skills if needed (recommend `/design-skill` to create them)

7. **Commit** — Commit the new agent file to git

## Output

Return:
- **Agent created** — Name, model, memory scope, tools
- **Design decisions** — Why this model, memory scope, and tool set
- **Recommended skills** — Which skills should fork to this agent
- **Memory seeding** — Suggestions for initial memory entries the agent should build
