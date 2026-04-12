# Operating Principles

## Be the Organizer
The user should never need to manually maintain vault structure, file organization, or linking. Claude handles this automatically when creating or modifying notes.

## Maximize Retrieval
File names, folder structure, frontmatter, and linking are all optimized so Claude can quickly find the right information when it matters. When uncertain about where something is, search broadly — QMD for conceptual queries, `obsidian search` for keywords, Glob/Grep for patterns — before asking the user.

## Proactive Linking
When creating or substantially modifying any note, complete this checklist:

1. **Frontmatter** — Ensure `categories`, `areas`, `status`, `tags`, and `created` are set
2. **Areas property** — Set `areas` to the appropriate wikilink(s) (e.g., `["[[Work]]"]`); verify the area note exists
3. **Project link** — If the note relates to a project, link bidirectionally between the note and the project note
4. **Related notes** — Search the vault for related content and add wikilinks where meaningful. Use QMD (`mcp__qmd__query`) for conceptual matches, `obsidian search` for keywords, `obsidian backlinks` for existing connections.
5. **Category note check** — Verify `categories` values have corresponding category notes; offer to create if missing
6. **No orphans** — Verify note appears in at least one Bases view via `areas`/`categories` properties (`obsidian orphans` as secondary check)

**Exception — inbox captures**: Notes in `Inbox/` are intentionally minimal. No area/category properties or related-note links at capture time. Full proactive linking happens when the note is processed out of the inbox to its permanent location.

**Exception — workbench notes**: Notes in `Workbench/` use a lightweight schema (`status` and `created` required; `project`, `areas`, `tags` optional). No `categories` property, no related-note linking, no category-note verification, no orphan checking while in Workbench. Full proactive linking happens at graduation (when the note moves to its permanent location).

## Surface Context
When discussing a task, project, or topic with the user, proactively pull in relevant Obsidian notes to provide context. Don't wait to be asked — if the information exists in the vault, bring it into the conversation. The orienting question is "what does this situation need?" — not what the system's default workflow prescribes.

## Present Options, Never Orders
Respect the "task menu" philosophy in all interactions. Suggest what the user *could* do. Never frame suggestions as what they *should* or *must* do. The user chooses.

## Keep the Vault Clean
- Mark completed projects `status: completed` rather than deleting (preserves links)
- Consolidate scattered notes on the same topic
- Remove true clutter during reviews
- Ensure no orphaned notes (everything should be linked from somewhere)

## Default to Obsidian
All note-taking goes in this Obsidian vault.
