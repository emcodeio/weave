# System Architecture

This vault is the center of a personal productivity system:

- **This Obsidian vault**: All task management (action menus in project notes, Action Pool, Someday Pool), planning, reference material, routines, and contextual notes. The single source of truth for what could be done.
- **Claude**: The organizational abstraction layer. Manages vault structure, curates action menus filtered by enjoyable usefulness, surfaces relevant context during reviews and task work, and guides routines conversationally. Asks "what does this situation need?" before every interaction.
- **Apple Calendar** (via MCP server `mcp-server-apple-events`): Read freely for surfacing scheduling context during reviews and planning. Time commitments and obligations live here.
- **Apple Reminders** (via MCP server `mcp-server-apple-events`): Hard-deadline alerts only — things that must happen by a specific date/time (e.g., "return item by March 5"). Not for general task management.
- **Apple Mail** (via MCP servers `apple-mail-mcp`): Two servers — `mail` for fast read/search (imdinu, FTS5-indexed), `apple-mail` for write operations (sweetrb, full CRUD). Read freely during reviews; write operations use draft-only (never send directly). See `apple-mail` rule.
- **Drafts app + MCP** (capture layer, via `@agiletortoise/drafts-mcp-server`): Quick text capture on all Apple platforms — desktop (`Control+Spacebar`), mobile, iOS share sheet (via Shortcuts). Pushes to `Inbox/` via "Save in Obsidian Vault" action. Claude reads and processes the Drafts inbox via MCP during reviews. See `drafts` rule.
- **Keyboard Maestro** (desktop contextual capture): Three app-scoped macros sharing one hotkey (`Control+Option+Command+Spacebar`) — browser URL/title capture (Safari/Chrome), Apple Mail email reference, Finder file capture. Text captures go to `Inbox/`; Finder file capture copies non-markdown files to `Attachments/` with a wrapper note in `Inbox/`. See `[[Capture System Setup Guide]]`.
- **QMD** (local semantic search, via `@tobilu/qmd` MCP server): On-device hybrid search (BM25 + vector + LLM reranking) across vault markdown files. Returns relevant chunks ranked by semantic relevance. Index at `~/.cache/qmd/`. See `qmd` rule.

This vault is synced via the user's preferred method and version-controlled with git, hosted at `{{GIT_USER}}/{{VAULT_NAME}}` on GitHub. Do not modify `.obsidian/` config files directly.
