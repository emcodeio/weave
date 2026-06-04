# Changelog

## Unreleased

- **Setup hardening** (from first clean-machine field test): prompts support line editing (backspace/arrows via readline) and EOF-safe defaults (Ctrl-D no longer aborts setup); all package-manager and QMD subprocesses run with stdin closed and a portable timeout backstop, so a shimmed or hung toolchain (e.g. an alternative package manager intercepting npm) can't stall setup indefinitely; `qmd update`/`qmd embed` stream live progress instead of running silently (the ~2GB first-run model download no longer looks like a hang); non-interactive stdin defaults network installs to "no" (making `bash setup.sh </dev/null` a safe smoke test); npm-install failures now name pnpm/bun/yarn/alt-toolchain global-install equivalents; prerequisite version probes time out at 15s instead of hanging.
- **Note Schemas is now the per-type source of truth**: added a Template Type Map (type → category → target directory → type-specific properties, matching the shipped templates exactly) and reconciled the Transcript extension (`people`, `topics`) and Wrapper extension (both capture-pipeline and template-created wrapper fields documented). `/create-from-template` now reads the live template library + the Type Map instead of carrying a static table.
- **System Overview** lists all skills per operating level, mirroring System Components by Role (Architect 7 / Orchestrate 14 / Partner 8) — the v0.2.0 additions are now visible in the overview.
- Doc polish: removed origin-vault vestiges (a `practice-session` example, a private project-name example, an undocumented `topics` field), removed dangling research-note references in `/create-template`, and clarified that default categories are created during setup.

## v0.2.0 — 2026-06-03

System modernization and content expansion. The template now ships with 29 slash commands + 6 format/helper skills (35 skills total), 5 agents, 15 rules, 6 hooks, 14 note templates + 25 Bases views.

### Authoring standards
- Modernized the authoring contract (`/design-skill`, `/design-agent`) and all 5 agents to current standards: `model: inherit`, a required `color`, a "When to invoke" section, and explicit MCP tool grants (a body reference no longer implies a grant).
- Brought the hooks up to standard: `additionalContext` fix, a path-traversal guard, and a new `check-protected-skills.sh` hook (6 hooks total).

### Skills and content
- Added skills: `/ingest-book`, and the concept-forge cluster (`/concept-forge`, `/integrate-concept-forge`, `/integrate-concept-cluster`).
- Consolidated transcript processing: `/process-transcript` is now a frame-detecting generalist (generic + work, via `references/work-profile.md`). The separate `/process-work-transcript` skill was removed.
- DRY'd the startup skills: the daily-note dashboard spec is single-sourced at `.claude/shared/daily-startup-dashboard.md`, and the three startup skills delegate to it.
- Content and voice pass on `/system-review` and `/create-from-template`.

### Rules
- Added rules: `concept-craft` (Chapman-aligned stance for conceptual work) and `concept-forge-artifact-format` (Workbench artifact spec, path-scoped). 15 rules total.

### Format skills
- Re-synced the vendored kepano plugin skills to upstream — added `references/` companion files and a Defuddle fix.

## v0.1.0 — 2026-04-11

Initial public release.

### Included
- 26 slash commands + 6 format helper skills
- 5 specialized agents (researcher, content drafter, vault organizer, contradictions resolver, system architect)
- 13 system rules
- 5 hooks (note quality, system protection, change logging, context compaction, git hooks)
- 14 note templates + 25 Bases views
- 12 system guide notes (Getting Started through Setting Up Integrations)
- Automated setup script with QMD + Apple integration support
- In-vault documentation -- the guide IS the vault
