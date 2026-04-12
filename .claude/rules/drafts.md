# Drafts

Drafts is the primary text capture layer. Claude processes the Drafts inbox via MCP during daily and weekly reviews.

## Tool Routing

All tools use the `mcp__drafts__` prefix (via `@agiletortoise/drafts-mcp-server`).

| Tool | Purpose |
|------|---------|
| `mcp__drafts__drafts_get_drafts` | List drafts (filter by tag, folder, query) |
| `mcp__drafts__drafts_get_draft` | Read a single draft by UUID |
| `mcp__drafts__drafts_create_draft` | Create a new draft |
| `mcp__drafts__drafts_update_draft` | Update draft content or tags |
| `mcp__drafts__drafts_trash` | Move a draft to trash |
| `mcp__drafts__drafts_archive` | Archive a draft (processed, out of inbox) |
| `mcp__drafts__drafts_run_action` | Run a Drafts action on a draft |
| `mcp__drafts__drafts_list_workspaces` | List available workspaces |
| `mcp__drafts__drafts_list_actions` | List available actions |
| `mcp__drafts__drafts_add_tags` | Add tags to a draft |
| `mcp__drafts__drafts_flag` | Flag/unflag a draft |
| `mcp__drafts__drafts_get_current` | Get the currently active draft |
| `mcp__drafts__drafts_get_current_workspace` | Get the current workspace |
| `mcp__drafts__drafts_get_tag` | Get drafts with a specific tag |
| `mcp__drafts__drafts_get_workspace_drafts` | Get drafts in a workspace |
| `mcp__drafts__drafts_inbox` | Get inbox drafts |
| `mcp__drafts__drafts_list_tags` | List all tags |
| `mcp__drafts__drafts_open` | Open a draft in Drafts app |
| `mcp__drafts__drafts_search` | Search drafts by content |

## Safety Rules

- **Read freely** — No confirmation needed for listing or reading drafts.
- **Archive after processing** — Once a draft has been routed (action extracted, pushed to Obsidian, or deemed not needed), archive it so it leaves the Drafts inbox.
- **Confirm before bulk trash** — Always ask before trashing multiple drafts at once.
- **Create sparingly** — Drafts is a capture tool, not a note store. Only create drafts when the user explicitly asks or when routing content through a Drafts action (e.g., "Save in Obsidian Vault").

## Drafts Inbox Processing (During Reviews)

When invoked via `/process-inbox` (the standard path during reviews), Drafts items are included in the unified scan-classify-confirm workflow alongside Obsidian inbox items. Claude reads all Drafts, assigns them numbers in the same sequence, and presents them in the grouped summary for user confirmation. After confirmation, Drafts are archived or trashed in batch.

**Standalone processing** (outside `/process-inbox`): For each unprocessed draft:

1. **Read the draft** — Understand its content and intent.
2. **Smart-route** based on content:
   - **Actionable item** → Extract action to the relevant project note or `[[Action Pool]]`. Archive the draft.
   - **Reference/note worth keeping** → Run the "Save in Obsidian Vault" action to push it to `Inbox/`, then archive the draft. It will be fully processed when the Obsidian inbox is handled.
   - **Quick thought already captured elsewhere** → Archive directly.
   - **Junk or duplicate** → Trash (confirm with user if unsure).
3. **Archive** — Every processed draft should leave the inbox.

## Technical Notes

- **Server**: `@agiletortoise/drafts-mcp-server` (Node.js, npx)
- **Requires**: Drafts v50.0.3+ on macOS, Node.js 18+
- **First run** will trigger macOS Automation permission prompts — approve them
- **Drafts actions** (like "Save in Obsidian Vault") must be installed in Drafts before they can be invoked via MCP
- If the server fails to connect, check that Drafts is running on macOS
