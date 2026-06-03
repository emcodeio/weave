# QMD Semantic Search

QMD provides local on-device semantic search across vault markdown files. It combines BM25 keyword matching, vector embeddings, and LLM-based reranking — all running locally with no cloud dependencies.

## Tool Routing

All tools use the `mcp__qmd__` prefix (via `@tobilu/qmd` MCP server).

| Tool | Purpose |
|------|---------|
| `mcp__qmd__query` | Hybrid search via `searches` array of typed sub-queries (`lex`/`vec`/`hyde`). Always provide `intent` to steer ranking. See "Query Construction" below. |
| `mcp__qmd__get` | Retrieve a specific document by path or docid |
| `mcp__qmd__multi_get` | Batch retrieve documents by glob pattern |
| `mcp__qmd__status` | Check index health, document count, pending embeddings |

## Search Strategy Decision Tree

Use the right tool for the job:

1. **Conceptual/semantic queries** → `mcp__qmd__query` — when the user's language may differ from the note's wording (e.g., "feeling stuck" vs. "paralysis", "morning habits" vs. "startup routine")
2. **Known keyword search** → `obsidian search` — when looking for specific terms, note names, or exact phrases
3. **File pattern matching** → Glob — when looking for files by name or path pattern
4. **Content pattern matching** → Grep — when searching for regex patterns, code, or structured text

QMD is the **first choice** for open-ended "find me notes about X" queries. Fall back to `obsidian search` if QMD returns low-confidence results, or for exact-match needs.

## Safety Rules

- **Read-only** — All QMD tools are read operations. No confirmation needed.
- **No index mutation via MCP** — The MCP server only reads the index. Updates require CLI commands.

## Score Interpretation

QMD returns scores as 0-1 floats (matching the `minScore` parameter):
- **0.8+** — High confidence. Strongly relevant result.
- **0.5-0.8** — Moderate confidence. Likely relevant, worth reading.
- **Below 0.5** — Low confidence. May be tangentially related. Skip unless nothing better exists.

## Query Construction

### Sub-query types

| Type | Engine | Best for | Speed |
|------|--------|----------|-------|
| `lex` | BM25 keyword | Known terms, exact names, specific phrases | <1ms |
| `vec` | Semantic vector | Conceptual queries, vocabulary mismatch, paraphrases | 50-200ms |
| `hyde` | Hypothetical document | Nuanced topics — write what the *answer* would look like | 50-200ms |

### Parameters

- **`searches`** (required): Array of sub-queries. The **first** sub-query gets 2x weight in scoring. Combine types for best results.
- **`intent`** (recommended): Natural-language description of *why* you're searching. Steers all 5 pipeline stages (chunking, expansion, retrieval, reranking, snippet extraction). This is the single biggest quality lever.
- **`limit`**: Max results (default 10).
- **`minScore`**: Float 0-1. Use 0.5 to filter low-confidence noise.
- **`candidateLimit`**: How many raw candidates to fetch before reranking (default 50).
- **`collection`**: Target collection (use `{{VAULT_NAME}}`).

### Common patterns

| Scenario | Sub-queries | Intent example |
|----------|-------------|----------------|
| Quick keyword lookup | `[{type:'lex', query:'error handling'}]` | "finding notes about error handling" |
| Conceptual search | `[{type:'lex', query:'morning'}, {type:'vec', query:'daily startup habits'}]` | "finding morning routine notes" |
| Nuanced topic | `[{type:'lex', query:'productivity'}, {type:'vec', query:'getting unstuck'}, {type:'hyde', query:'A note about overcoming procrastination and finding motivation'}]` | "understanding approaches to procrastination" |
| Fuzzy action matching | `[{type:'vec', query:'kitchen remodel budget decisions'}]` | "finding the project this work belongs to" |
| Inbox routing | `[{type:'vec', query:'solar panel maintenance schedule'}]` | "finding the right project or area for this inbox item" |

## Index Maintenance

A git post-commit hook keeps the index current automatically (~600ms per commit). No manual re-indexing needed during normal operation.

For edge cases (vault synced without a commit, manual edits outside Claude):

```bash
qmd update && qmd embed
```

Run `qmd status` to check index health at any time.

## Search Escalation

Start with the tier that matches the query. Escalate only if results are insufficient.

1. **`lex` only** (<1ms) — Known terms, exact note names, specific phrases
2. **`lex` + `vec`** (50-200ms) — Standard discovery; lex anchors, vec expands reach
3. **`lex` + `vec` + `hyde`** (1-3s) — Nuanced/vague recall; write what the answer would look like

Always provide `intent` — it is the single biggest quality lever, steering all 5 pipeline stages.

## Collection

- **Name**: `{{VAULT_NAME}}`
- **Pattern**: `**/*.md`
- **Excludes**: `.obsidian/`, `.claude/`, `.trash/` are naturally excluded by the glob pattern
- **Index location**: `~/.cache/qmd/index.sqlite`
- **Models**: `~/.cache/qmd/models/` (embedding ~328MB, query expansion ~1.28GB, reranker ~639MB)

## Context Annotations

Folder-level context annotations help QMD understand vault structure and improve result relevance. These are set via `qmd context add` and persist in the index.

## Fallback When QMD Is Unavailable

If QMD is not installed or the MCP server is not running, `mcp__qmd__*` calls will fail. When this happens:

1. Fall back to `obsidian search` for keyword-based queries
2. Use Grep for pattern matching across vault files
3. Use Glob to find files by name patterns
4. Note to the user that semantic search is unavailable and results may be less precise

Skills should not block on QMD failure. Keyword search covers most use cases; semantic matching is an enhancement, not a requirement.
