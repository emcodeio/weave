# Weave Manual Testing Checklist

Run `bash scripts/validate.sh` first to confirm automated checks pass. Then work through this checklist manually.

---

## Fresh-Clone Test

```bash
cd /tmp
git clone /path/to/weave weave-test
cd weave-test
bash setup.sh
```

- [ ] `setup.sh` completes without errors (all defaults)
- [ ] `setup.sh` with git skipped -- no `{{GIT_*}}` literals remain in any `.md`/`.json`
- [ ] `.mcp.json` generated correctly (QMD always present, Apple integrations conditional)
- [ ] Area notes created in `Notes/` for each chosen area
- [ ] Category notes created in `Notes/` for all 13 categories
- [ ] Initial git commit created

---

## Obsidian Verification

Open the vault directory in Obsidian (File > Open vault > Open folder as vault).

- [ ] Vault opens without errors
- [ ] Daily Notes plugin configured (folder: `Daily/`, template: `Templates/Template - Daily Note.md`)
- [ ] Templates plugin configured (folder: `Templates/`)
- [ ] Bases plugin enabled
- [ ] Open `Notes/Work.md` -- embedded `.base` view renders
- [ ] Open `Notes/Projects.md` -- embedded `.base` view renders
- [ ] Spot-check 5+ additional `.base` views -- filters work correctly
- [ ] Open `Notes/Getting Started.md` -- wikilinks resolve

---

## Skill Smoke Tests

Start Claude Code in the vault directory: `claude`

- [ ] `/start-workday` -- creates daily note, handles empty vault gracefully, no errors
- [ ] `/create-project` -- prompts for details, creates note in `Notes/` with proper frontmatter
- [ ] `/process-inbox` -- scans inboxes, handles "all empty" case gracefully
- [ ] `/create-from-template` -- lists all 14 templates, creates note with correct frontmatter
- [ ] `/end-workday` -- handles a day with no activity gracefully
- [ ] `/system-review` -- audits system components, reports health

---

## Hooks

- [ ] Create a note in `Notes/` missing frontmatter -- `check-note-quality.sh` warns
- [ ] Attempt to edit `.obsidian/app.json` -- `protect-system-files.sh` blocks
- [ ] Edit any vault note -- `log-vault-change.sh` writes to `.claude/hooks/logs/changes.log`
- [ ] Make a git commit -- post-commit hook runs (or exits silently if QMD not installed)

---

## Templates

Create a note from each template via `/create-from-template` and verify:

- [ ] Template - Project
- [ ] Template - Article
- [ ] Template - Book
- [ ] Template - Essay
- [ ] Template - Research
- [ ] Template - Guide
- [ ] Template - Framework
- [ ] Template - Evergreen
- [ ] Template - Collection
- [ ] Template - Person
- [ ] Template - Category Note
- [ ] Template - Daily Note (via `/start-workday` or Obsidian daily note)
- [ ] Template - Transcript
- [ ] Template - Media Wrapper

Each should have: valid YAML frontmatter, correct `categories`/`areas`/`status`/`tags`/`created` fields.

---

## QMD Integration (if installed)

- [ ] `qmd status` shows the correct collection name and document count
- [ ] Semantic search returns results (ask Claude: "Search for notes about getting started")
- [ ] Post-commit hook indexes new notes (create note, commit, `qmd status` shows updated count)

---

## Edge Cases

- [ ] Non-macOS: Apple integration step in `setup.sh` skips cleanly
- [ ] No QMD installed: `setup.sh` warns but continues; skills fall back to keyword search
- [ ] Empty vault: all review skills handle "no projects, no inbox items" without errors
- [ ] Custom areas: `setup.sh` creates area notes + `.base` files for non-default areas
