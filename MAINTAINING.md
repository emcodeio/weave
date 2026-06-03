# Maintaining Weave

This document is for the maintainer keeping Weave in sync with its source. It is repo-meta, not a vault note — it ships in the public repo and explains how the project is produced and re-synced.

## What Weave is

Weave is a de-personalized public extraction of a private productivity vault. The maintainer runs the same architecture in a private "origin" vault; Weave is the same system — three operating levels, property-based organization, the skill/agent/rule/hook infrastructure — with all personal, work, and practice content removed.

Origin is where the system actually evolves. New skills, agents, rules, and hooks are designed and battle-tested there against real use. Weave is downstream: artifacts that are general enough to be useful to anyone are ported out, scrubbed, and generalized. This means most maintenance is a **re-sync** — bringing forward improvements that have already proven themselves in origin.

The split is deliberate. Origin can name people, employers, clients, and private practices freely. Weave must never expose any of that. The conventions below are the rules that keep the boundary clean.

## De-personalization conventions

These are the rules for porting an artifact from origin to Weave. Apply all of them to anything that crosses the boundary.

### Placeholder tokens

Identity and environment specifics are never hardcoded. `setup.sh` substitutes these placeholders at install time:

| Token | Replaced with |
|-------|---------------|
| `{{VAULT_NAME}}` | The user's Obsidian vault name |
| `{{VAULT_PATH}}` | Absolute path to the vault directory |
| `{{GIT_USER}}` | GitHub username (optional) |
| `{{GIT_EMAIL}}` | Git commit email (optional) |
| `{{GIT_REMOTE}}` | GitHub repo URL (optional) |

Never write a real path, username, email, vault name, or remote URL into a shipped file. If origin hardcodes one, replace it with the matching token during the port.

### What to strip

- **Personal names** — the maintainer's name, family, colleagues, clients, anyone. Replace with a role ("the user," "a colleague") or a neutral fixture.
- **Employer / client / work specifics** — company names, product names, project codenames, internal tooling, domain jargon tied to a specific workplace.
- **Contemplative-practice vocabulary** — any specialized practice terminology and the personal content built on it. Where a skill's general shape is worth keeping, generalize it (e.g. "facilitated session" rather than a named practice).
- **Links to private notes** — wikilinks that point at notes Weave doesn't ship. Either retarget to a shipped note or remove the link.
- **Sync-method assumptions** — keep phrasing sync-agnostic. Say "your preferred sync method," never name a specific service. The system must not assume how the user syncs their vault.

### Fork-target substitution

Where an origin skill forks a personal agent that Weave doesn't ship, repoint the fork to a shipped Weave agent. For example, origin's book and article ingest skills fork a personal research-and-practice agent; in Weave they fork the shipped `researcher` agent instead. Check every `agent:` reference in a ported skill against the agents Weave actually ships.

### Layout standard

Reference and companion files live in a `references/` subdirectory inside the skill, not as flat `reference-*.md` files beside `SKILL.md`. Normalize layout to this standard when porting.

### Citing influences

Cite public thinkers as influences by linking to the shipped framework note (e.g. `[[Weave - Chapman Framework]]`), never to a private person-note. Origin may link a private person-note for the same thinker; retarget it to the framework note on the way out.

## Re-sync workflow

When bringing origin improvements into Weave, work through these steps in order:

1. **Consult the disposition manifest.** Origin maintains a per-artifact manifest classifying every `.claude/` artifact class as portable, de-personalize, or do-not-port. Read it first — it tells you what is in scope and how each piece should be handled.

2. **Port or update the in-scope artifacts.** For each portable or de-personalize artifact that changed in origin, bring the new version across.

3. **De-personalize per the conventions above.** Apply placeholder tokens, strip personal/work/practice content, substitute fork targets, normalize to the `references/` layout, and retarget influence links. This is where most of the care goes.

4. **Re-sync the vendored kepano plugin skills.** The Obsidian format skills are vendored from `kepano/obsidian-skills` upstream, not hand-authored. Pull the current upstream content and verify with `.claude/hooks/check-protected-skills.sh` (it diffs the vendored skills against upstream `main`; the plugin version does not reliably bump on content changes, so a file-level diff is the real check).

5. **Run a leak grep over the diff.** Before committing, grep the full diff for personal names, real paths, sync-service names, and employer/client terms. Nothing private may land in the public repo. Treat any hit as a blocker.

6. **Reconcile the self-docs to the new counts.** Update `README.md`, `CHANGELOG.md`, the in-vault "System Components by Role" inventory, and the expected counts hardcoded in `scripts/validate.sh` so their skill / agent / rule / hook counts and descriptions match what now ships. These drift easily — check them every time. Run `bash scripts/validate.sh` afterward; it fails loudly on any count it didn't get updated for.

7. **Bump the CHANGELOG.** Add an entry describing what changed in this sync.

## Keeping it concise

Weave's value is that it stays close to a working system without exposing the person behind it. When in doubt, port less and generalize more — a missing skill is recoverable, a leaked detail is not.
