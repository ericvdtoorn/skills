Skills are organized into bucket folders under `skills/`:

- `engineering/` — daily code work
- `productivity/` — daily non-code workflow tools
- `misc/` — kept around but rarely used
- `personal/` — tied to my own setup, not promoted
- `in-progress/` — drafts not yet ready to ship
- `deprecated/` — no longer used

Every skill in `engineering/`, `productivity/`, or `misc/` must have a reference in the top-level `README.md`. Skills in `personal/`, `in-progress/`, and `deprecated/` must not appear there.

`.claude-plugin/plugin.json`'s `skills` array ships exactly the **promoted** buckets — `engineering/` and `productivity/`. `misc/` skills are documented but not shipped.

`.claude-plugin/marketplace.json` makes this repo its own single-plugin Claude Code marketplace, so users install with `/plugin marketplace add ericvdtoorn/skills` then `/plugin install evantoor-skills@evantoor`. The marketplace `name` (`evantoor`) is the `@`-suffix in that install command, and its plugin entry's `name` must match `plugin.json`'s `name`.

Each skill entry in the top-level `README.md` must link the skill name to its `SKILL.md`.

Each bucket folder has a `README.md` that lists every skill in the bucket with a one-line description, with the skill name linked to its `SKILL.md`.

Every skill folder also carries an `agents/openai.yaml` giving Codex its display name and short description, plus `policy.allow_implicit_invocation: false` whenever the `SKILL.md` sets `disable-model-invocation: true`.

## Releases

Versioning runs on [changesets](https://github.com/changesets/changesets). Add a changeset (`npx changeset`) for any user-visible skill change; the release workflow opens a version PR from whatever has accumulated. Keep `.claude-plugin/plugin.json`'s `version` in sync with `package.json`'s — Claude uses the plugin `version` to decide when installed users see an update.

## Git commits

Single-line commits prefixed with a gitmoji, one functional purpose per commit. No body. No `Co-Authored-By:` trailer unless explicitly asked. See `skills/engineering/gitmoji-commits/SKILL.md` for the emoji table, examples, and the isolation rule.

## Comment style

Doc comments encouraged on public APIs (functions, types, modules). Inline comments inside function bodies are heavily discouraged — if you want to write one explaining *what* the next lines do, extract a named function instead. Exceptions only for non-obvious *why* (workarounds linked to a bug, subtle invariants, surprising behaviour). See `skills/engineering/comment-style/SKILL.md`.
