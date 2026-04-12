# Partner Conventions

Guidelines for Partner-level work — when Claude collaborates with the user on substantive tasks (research, writing, exploration, building).

## When to Create Vault Notes vs Respond Conversationally

**Create a vault note** when the output has lasting reference value:
- Research findings and synthesized knowledge
- Drafted content (guides, plans, reports, summaries)
- Meeting notes and decision records
- Technical documentation or how-tos

**Respond conversationally** for ephemeral interactions:
- Quick factual answers or lookups
- Opinions or brainstorming that hasn't solidified
- Debugging help or troubleshooting
- Short clarifications

When in doubt, create a note — it's easy to delete later but hard to reconstruct lost knowledge.

## Research Standards

- **Vault first** — Always search the vault before going external. Use QMD (`mcp__qmd__query`) for conceptual queries, `obsidian search` for keywords. Existing knowledge should be built upon, not duplicated.
- **Cite sources** — Include URLs or clear references for all claims.
- **Confidence levels** — Note what's well-established vs. emerging vs. uncertain.
- **Atomic notes** — One topic per note in `Notes/` (or `References/` for external entities). Broad research can produce multiple linked notes.
- **Knowledge gaps** — Flag what we don't know yet for future research.

## Drafting Standards

- **Match the user's voice** — The content-drafter agent's memory tracks style preferences. Consult it.
- **Structure with headings** — Content should be scannable at a glance.
- **Wikilinks throughout** — Connect ideas to existing vault knowledge using `[[Note Name]]`.
- **Follow frontmatter schema** — Every note needs categories, areas, status, tags, created.
- **Concise but complete** — No padding, no filler, but don't skip substance.

## Work Product Placement

| Content type | Categories | Target |
|-------------|-----------|--------|
| Research findings | `[[Research]]` | `Notes/` |
| Project plans | `[[Projects]]` | `Notes/` |
| External references (books, people) | `[[Books]]`, `[[People]]` | `References/` |
| System docs | (system notes) | `Notes/` |
| Ideas for later | `[[Evergreen]]` | `Notes/` |

## Workbench Routing

Route Partner-level output to `Workbench/` (instead of `Notes/` or `References/`) when:
- The content is actively being iterated with no clear "done" state yet
- Multiple related files are being developed together (specs, drafts, reference docs)
- The user is collaborating with others and the document will go through review cycles
- The output is a working document that supports a project but isn't a standalone deliverable

Workbench items use lightweight frontmatter (`status`, `created`; `project` optional). No `categories` or proactive linking until integration. When in doubt: "Is this still being actively worked, or is it ready for a permanent home?"

## Skill and Agent Delegation

- `/research-topic` and `/draft-content` fork to dedicated agents with persistent memory
- For **quick, conversational** research or drafting that doesn't need a vault note, handle inline without invoking the skill
- After a forked skill returns results, read the created note and continue iterating in the main conversation if the user wants refinements
- The researcher and content-drafter agents can also be invoked directly ("Use the researcher agent") for tasks that don't fit the skill's workflow
