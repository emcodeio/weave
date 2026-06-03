---
categories: ["[[Guides]]"]
status: active
areas: ["[[Self-Management]]"]
tags: [guide]
created: 2026-04-11
---

# Setting Up Integrations

Weave connects to external tools through MCP (Model Context Protocol) servers. QMD is strongly recommended; everything else is optional. The `setup.sh` script offers to install QMD (and the Apple Mail read server) and writes your `.mcp.json` automatically — this guide covers manual setup and troubleshooting.

Configuration lives in `.mcp.json` at the vault root. See `.mcp.json.example` for a documented reference of all available servers.

---

## QMD Semantic Search — Strongly Recommended

### Why

QMD provides local on-device semantic search across your vault. Unlike keyword search, it finds notes by meaning — "feeling stuck" matches a note about "paralysis and motivation" even without shared words. It powers:

- **Inbox routing** — Matching captures to the right project or area
- **Context surfacing** — Pulling relevant notes into conversations proactively
- **Friction detection** — Finding semantically similar deferred actions across projects
- **Knowledge discovery** — "Find notes about X" queries based on conceptual similarity

### Install

```bash
npm install -g @tobilu/qmd
```

### Initialize

Run these commands from your vault directory:

```bash
qmd init
qmd update
qmd embed
```

The first `qmd embed` run downloads ~2GB of local models for embeddings and reranking. Subsequent runs are fast (~600ms per commit).

### Configure MCP

Add to `.mcp.json`:
```json
"qmd": {
  "type": "stdio",
  "command": "qmd",
  "args": ["mcp"],
  "env": {}
}
```

### Verify

In Claude Code, ask: "Search for notes about [topic]." Claude should return results with confidence scores. You can also run `qmd status` in the terminal to check index health and document count.

### Automatic re-indexing

The git post-commit hook (installed by `setup.sh`) runs `qmd update && qmd embed` after every commit. Your search index stays current automatically.

---

## Apple Calendar & Reminders — Recommended (macOS)

### Why

Calendar provides scheduling context during morning reviews — Claude sees your day at a glance, notes open time blocks, and scans the next 60 days for the upcoming horizon overview.

Reminders is used strictly for hard-deadline alerts — things that must happen by a specific date (return an item, renew a license, buy tickets). Not for general task management, which lives entirely in the vault.

### Install

The MCP server uses the `mcp-server-apple-events` package:

```json
"apple-events": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "mcp-server-apple-events"],
  "env": {}
}
```

### Permissions

The first time Claude accesses Calendar or Reminders, macOS will prompt for Automation permissions. Approve them. If the prompt doesn't appear or access is denied, go to System Settings > Privacy & Security > Automation and grant access.

### Verify

Ask Claude: "What's on my calendar today?" Calendar events should appear in the response.

---

## Apple Mail — Optional (macOS)

### Why

During reviews, Claude can scan unread email for actionable items and surface them as options alongside project actions. Claude creates draft replies — it never sends email directly.

### Install

Two MCP servers work together — note these are two *different* packages that happen to share the name `apple-mail-mcp`: the read server is a Python tool installed with `pipx`, the write server a Node tool run with `npx`.

**Read server** (fast, FTS5-indexed):
```bash
pipx install apple-mail-mcp
```

```json
"mail": {
  "type": "stdio",
  "command": "apple-mail-mcp",
  "args": ["--watch"],
  "env": {}
}
```

**Write server** (draft, reply, forward, flag, move):
```json
"apple-mail": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "apple-mail-mcp"],
  "env": {}
}
```

### Safety

Claude always creates drafts — never sends directly. You review and send from Mail.app. Destructive operations (delete, batch move) require your confirmation.

### Permissions

Mail.app must be running. First use triggers Automation permission prompts — approve them.

### Verify

Ask Claude: "Check my unread email." It should list recent messages.

---

## Drafts — Optional (macOS/iOS)

### Why

Drafts is the fastest way to capture text from anywhere. On macOS, press `Control+Spacebar` to capture instantly. On iOS, use the share sheet or the app directly. Claude processes the Drafts inbox during reviews.

### Install

Install [Drafts](https://getdrafts.com) on macOS (and optionally iOS). Then add the MCP server:

```json
"drafts": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "@agiletortoise/drafts-mcp-server"],
  "env": {}
}
```

Requires Drafts v50.0.3+ and Node.js 18+.

### Permissions

Drafts must be running on macOS. First use triggers Automation permission prompts — approve them.

### Full capture system

Drafts is one piece of a larger capture system that can include Keyboard Maestro macros for browser URLs, email references, and file captures. See [[Capture System Setup Guide]] for the complete setup.

### Verify

Create a test draft in the Drafts app. Ask Claude: "Check my Drafts inbox." It should find the test item.

---

## Cross-Platform Notes

The core system works on any platform:
- **Obsidian** — macOS, Windows, Linux
- **Claude Code** — macOS, Windows, Linux
- **QMD** — macOS, Windows, Linux (Node.js)

Apple integrations (Calendar, Reminders, Mail, Drafts) are macOS-only enhancements. The system is fully functional without them — reviews just won't include calendar context or email scanning.

---

## Troubleshooting

**MCP server won't connect:** Restart Claude Code. MCP servers are started when Claude Code launches.

**Calendar/Reminders access denied:** Run an `osascript` command that accesses Calendar from the terminal session to trigger the permission prompt, then approve it.

**QMD returns no results:** Run `qmd status` to check the index. If the document count is 0, run `qmd update && qmd embed`.

**Drafts MCP can't find drafts:** Ensure Drafts is running on macOS (not just iOS).

---

## Related Notes

- [[Getting Started]] — Overview and first three skills
- [[System Overview]] — Full architecture and integrations table
- [[Capture System Setup Guide]] — Detailed capture system setup (Drafts + Keyboard Maestro)
- [[Customizing Your System]] — Adding and configuring integrations
