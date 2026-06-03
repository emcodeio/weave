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

## Agent standards (current)

Standards a new agent must meet — and the yardstick the system's own agents are held to. Build on `plugin-dev:agent-development` for general mechanics; this skill adds the vault layer.

- **Frontmatter**: `name` (lowercase-hyphens) · `description` · `model` · `color` (required) · `tools` (least-privilege) · plus the vault-local `memory:` extension.
- **Description is the trigger.** Form: "Use this agent when… Typical triggers include [2-4 prose scenarios]. See 'When to invoke' in the agent body." Cover proactive + reactive triggering and when NOT to use.
- **"When to invoke" body section** — 2-4 worked scenarios as prose bullets, including which skills fork into the agent (if any).
- **`model: inherit` by default** — let the agent ride the session model; hard-pin a tier only with a specific, justified need (not a reflexive `opus`/`sonnet`).
- **Least-privilege `tools`** — grant only what's needed (a read-only analysis agent gets `Read, Grep, Glob`, no `Write`/`Edit`). MCP tools (`mcp__*`, e.g. `mcp__qmd__query`) must be listed explicitly — a reference in the agent body or a forking skill does NOT grant access. `Bash` is a single grant covering all shell/CLI invocations (obsidian, defuddle, python).
- **System prompt** — second person; role → process → output format → edge cases; explain *why*; focused. `memory:` (`user`|`project`) is a vault-local extension backed by `.claude/agent-memory/`, not part of the upstream schema.

## Your task

Design and create a new agent based on: **$ARGUMENTS**

Follow this workflow:

1. **Capture requirements** — From the description above, determine:
   - What is this agent's primary responsibility?
   - What tools does it need? (built-ins: Read, Grep, Glob, Write, Edit, Bash, WebSearch, WebFetch — plus any MCP tools like `mcp__qmd__query`, which must be granted explicitly)
   - Will it delegate to other agents or be delegated to?
   - Does it interact with external systems (Calendar, Reminders, web)?

2. **Select model, color & memory** — Choose:
   - **Model**: default `inherit` (ride the session model). Hard-pin a tier (`opus`/`sonnet`/`haiku`) only with a specific, justified need — and state why.
   - **Color**: a distinct UI color, required (blue/cyan analysis, green success, yellow validation, red critical, magenta generation).
   - **Memory**: `user` (transfers across projects) or `project` (codebase-specific) — vault-local extension backed by `.claude/agent-memory/`; omit if no persistent memory is needed.

3. **Write frontmatter + system prompt**:
   - `description` in the form "Use this agent when… Typical triggers include [2-4 prose scenarios]. See 'When to invoke' in the agent body." — cover proactive + reactive triggering and when NOT to use
   - A "## When to invoke" body section: 2-4 worked scenarios as prose bullets (note which skills fork into the agent, if any)
   - System prompt (second person): role → system context (vault name, file locations, git workflow) → process → quality standards → output format → edge cases → memory tracking. Explain *why*, not just what.

4. **Create** — Write the agent file to `.claude/agents/{name}.md` with valid frontmatter + system prompt

5. **Verify** — Check:
   - `description` carries triggers + a "When to invoke" pointer; a "## When to invoke" section exists (2-4 scenarios)
   - `color` present and valid; `model` is `inherit` (or a justified pin); `tools` is least-privilege
   - `memory` is `user`/`project` (or omitted); `name` is lowercase-with-hyphens
   - System prompt is second-person, structured (role/process/output/edge-cases), and focused (agent-development suggests under ~10k characters)
   - YAML frontmatter parses; tool names are valid
   - `tools:` grant covers every tool the agent body AND any skill that forks into it references; every `mcp__*` is listed explicitly (Bash covers shell/CLI like obsidian/defuddle/python)

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
