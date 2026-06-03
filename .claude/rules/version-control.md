# Version Control

## Commit After Changes

After making any vault changes (creating, editing, moving, or archiving notes; updating CLAUDE.md; etc.), Claude must commit and push:

```bash
cd "{{VAULT_PATH}}"
git add <specific files changed>
git commit -m "Brief description of changes"
git push
```

- Use specific file adds (not `git add -A`) to avoid committing unintended files
- Commit messages should be concise and describe *what* changed (e.g., "Archive completed project: Kitchen Renovation")

## QMD Re-indexing

A git `post-commit` hook automatically runs `qmd update && qmd embed` after every commit (~600ms). New and modified notes become searchable immediately.

- No manual action needed — the hook runs transparently between `git commit` and `git push`
- Hook location: `.git/hooks/post-commit` (not tracked in git)
- Setup after fresh clone: `bash .claude/hooks/setup-git-hooks.sh`
- If the QMD binary is missing, the hook exits silently — commits are never blocked

## Repository Details

- **Repo**: `{{GIT_USER}}/{{VAULT_NAME}}` (private) on GitHub
- **Branch**: `main`
- **Remote URL**: `{{GIT_REMOTE}}`
- **Git identity** (local to this repo): `{{GIT_USER}}` / `{{GIT_EMAIL}}`
- **Credential helper** (local): Uses the system's configured git credential helper

## .gitignore

Excluded: `.obsidian/workspace.json`, `.obsidian/workspace-mobile.json`, `.obsidian/cache/`, `.trash/`, `.DS_Store`, `.claude/settings.local.json`, `.claude/plans/`, `.claude/memory/`, `.claude/agent-memory-local/`, `.claude/hooks/logs/`, sync-conflict files.

Tracked: All vault notes, `.obsidian/` config files (settings, plugins, appearance), `.claude/skills/`, `.claude/hooks/*.sh`, `.claude/rules/`, `.claude/settings.json`, `.claude-plugin/`, `CLAUDE.md`.
