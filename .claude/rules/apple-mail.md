# Apple Mail

Two MCP servers provide complementary Apple Mail access. Use the correct server for each operation type.

## Tool Routing

### Read/Search → `mail` server (imdinu)

Fast reads and FTS5-indexed search. Use for all read operations.

| Tool | Purpose |
|------|---------|
| `mcp__mail__search` | Full-text search across emails |
| `mcp__mail__get_emails` | List emails from a mailbox |
| `mcp__mail__get_email` | Read a single email by ID |
| `mcp__mail__list_mailboxes` | List all mailboxes/folders |
| `mcp__mail__list_accounts` | List configured mail accounts |
| `mcp__mail__get_attachment` | Download an email attachment |

### Write → `apple-mail` server (sweetrb)

Full CRUD operations. Use for all write/action operations.

| Tool | Purpose |
|------|---------|
| `mcp__apple-mail__create-draft` | Create a draft email (preferred over send) |
| `mcp__apple-mail__reply-to-message` | Reply to an email |
| `mcp__apple-mail__forward-message` | Forward an email |
| `mcp__apple-mail__mark-as-read` | Mark email as read/unread |
| `mcp__apple-mail__flag-message` | Flag/unflag an email |
| `mcp__apple-mail__delete-message` | Delete an email |
| `mcp__apple-mail__move-message` | Move email to another mailbox |
| `mcp__apple-mail__send-email` | Send an email directly (DO NOT USE — see safety rules) |
| `mcp__apple-mail__batch-*` | Batch versions of the above operations |

## Safety Rules

- **Always use `create-draft`, never `send-email`** — The user reviews and sends manually from Mail.app. Creating drafts lets the user verify content before sending.
- **Confirm before destructive operations** — Always ask before delete, batch delete, or batch move operations.
- **Read freely** — No confirmation needed for search, listing, or reading emails.
- **Flag and mark-as-read freely** — Low-risk operations that don't need confirmation.

## Email During Reviews

During daily and weekly reviews, check for actionable unread emails and surface them as options alongside project actions:

1. Search for unread emails: `mcp__mail__get_emails` with unread filter
2. Summarize actionable items (requires response, has deadline, contains decision needed)
3. Present as part of the action menu — never as obligations
4. For emails requiring action, suggest: reply (draft), flag for follow-up, capture to vault, or defer

## Vault Integration

When email content has lasting reference value, capture it as a vault note:

- **Meeting notes or decisions** → Create note in appropriate folder with email content quoted
- **Reference information** → Create atomic note in `Notes/` (or `References/` for external entities)
- **Action items from email** → Add to relevant project note or `[[Action Pool]]`
- **Include source** — Note the sender, date, and subject line for traceability

## Technical Notes

- The `mail` server (imdinu) runs a background watcher (`--watch` flag) that keeps the FTS5 index updated in real time
- Index location: `~/.apple-mail-mcp/index.db`
- Both servers require Mail.app to be running
- First use will trigger macOS Automation permission prompts — approve them
- If a server fails to connect, check that Mail.app is open and permissions are granted
