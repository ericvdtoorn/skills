---
name: setup-evantoor-skills
description: Sets up an `## Agent skills` block in AGENTS.md/CLAUDE.md and `docs/agents/` so the engineering skills know this repo's issue tracker (GitHub or local markdown), triage label vocabulary, and domain doc layout. Also detects overlapping skills from other plugins (e.g. superpowers), recommends which installed skills fit this project's stack (enabling relevant ones, disabling irrelevant ones), and records local preferences. Run before first use of `to-issues`, `to-prd`, `triage`, `diagnosing-bugs`, `tdd`, `improve-codebase-architecture`, or `zoom-out` — or if those skills appear to be missing context about the issue tracker, triage labels, or domain docs.
disable-model-invocation: true
---

# Setup Evantoor's Skills

Scaffold the per-repo configuration that the engineering skills assume:

- **Issue tracker** — where issues live (GitHub by default; local markdown is also supported out of the box)
- **Triage labels** — the strings used for the five canonical triage roles
- **Domain docs** — where `CONTEXT.md` and ADRs live, and the consumer rules for reading them

This is a prompt-driven skill, not a deterministic script. Explore, present what you found, confirm with the user, then write.

## Process

### 1. Explore

Look at the current repo to understand its starting state. Read whatever exists; don't assume:

- `git remote -v` and `.git/config` — is this a GitHub repo? Which one?
- `AGENTS.md` and `CLAUDE.md` at the repo root — does either exist? Is there already an `## Agent skills` section in either?
- `CONTEXT.md` and `CONTEXT-MAP.md` at the repo root
- `docs/adr/` and any `src/*/docs/adr/` directories
- `docs/agents/` — does this skill's prior output already exist?
- `.scratch/` — sign that a local-markdown issue tracker convention is already in use

### 2. Present findings and ask

Summarise what's present and what's missing. Then walk the user through the three decisions **one at a time** — present a section, get the user's answer, then move to the next. Don't dump all three at once.

Assume the user does not know what these terms mean. Each section starts with a short explainer (what it is, why these skills need it, what changes if they pick differently). Then show the choices and the default.

**Section A — Issue tracker.**

> Explainer: The "issue tracker" is where issues live for this repo. Skills like `to-issues`, `triage`, `to-prd`, and `qa` read from and write to it — they need to know whether to call `gh issue create`, write a markdown file under `.scratch/`, or follow some other workflow you describe. Pick the place you actually track work for this repo.

Default posture: these skills were designed for GitHub. If a `git remote` points at GitHub, propose that. If a `git remote` points at GitLab (`gitlab.com` or a self-hosted host), propose GitLab. Otherwise (or if the user prefers), offer:

- **GitHub** — issues live in the repo's GitHub Issues (uses the `gh` CLI)
- **GitLab** — issues live in the repo's GitLab Issues (uses the [`glab`](https://gitlab.com/gitlab-org/cli) CLI)
- **Local markdown** — issues live as files under `.scratch/<feature>/` in this repo (good for solo projects or repos without a remote)
- **Other** (Jira, Linear, etc.) — ask the user to describe the workflow in one paragraph; the skill will record it as freeform prose

**Section B — Triage label vocabulary.**

> Explainer: When the `triage` skill processes an incoming issue, it moves it through a state machine — needs evaluation, waiting on reporter, ready for an AFK agent to pick up, ready for a human, or won't fix. To do that, it needs to apply labels (or the equivalent in your issue tracker) that match strings *you've actually configured*. If your repo already uses different label names (e.g. `bug:triage` instead of `needs-triage`), map them here so the skill applies the right ones instead of creating duplicates.

The five canonical roles:

- `needs-triage` — maintainer needs to evaluate
- `needs-info` — waiting on reporter
- `ready-for-agent` — fully specified, AFK-ready (an agent can pick it up with no human context)
- `ready-for-human` — needs human implementation
- `wontfix` — will not be actioned

Default: each role's string equals its name. Ask the user if they want to override any. If their issue tracker has no existing labels, the defaults are fine.

**Section C — Domain docs.**

> Explainer: Some skills (`improve-codebase-architecture`, `diagnosing-bugs`, `tdd`) read a `CONTEXT.md` file to learn the project's domain language, and `docs/adr/` for past architectural decisions. They need to know whether the repo has one global context or multiple (e.g. a monorepo with separate frontend/backend contexts) so they look in the right place.

Confirm the layout:

- **Single-context** — one `CONTEXT.md` + `docs/adr/` at the repo root. Most repos are this.
- **Multi-context** — `CONTEXT-MAP.md` at the root pointing to per-context `CONTEXT.md` files (typically a monorepo).

**Section D — Overlap check.**

> Explainer: Other skill packs (notably `superpowers`, but also some custom packs people install globally) ship skills that overlap with evantoor's: superpowers ships test-driven-development, systematic-debugging, brainstorming, writing-skills, writing-plans, executing-plans — each of which covers ground that one of evantoor's skills also covers (`tdd`, `diagnosing-bugs`, `grill-me`/`grill-with-docs`, `write-a-skill`, `to-prd`, `handoff`). When two skills cover the same ground the agent picks one at random, which makes behaviour inconsistent across sessions. The fix is to pick **one pack** as the winner for the overlapping area and keep that pack whole.

**Choose at the pack level, not the skill level.** Each pack is internally consistent — its skills reference and call into each other (e.g. superpowers' brainstorming → writing-plans → executing-plans → requesting-code-review forms a chain). Cherry-picking individual skills across packs breaks those chains. Pick which pack owns the overlapping area and disable the other in that area as a whole.

Detect overlaps by inspecting **only** what's actually loaded right now — read the `available skills` and `MCP` blocks from your own current session context. Do not invent overlaps from training data or guess at skills the user might have installed. If you can't see a pack in your context, treat it as not installed.

Group the detected overlaps by source pack and present each pack as a single decision:

| Pack | Skills that overlap with evantoor | Default |
| --- | --- | --- |
| `superpowers` | `test-driven-development` (vs `tdd`), `systematic-debugging` (vs `diagnosing-bugs`), `brainstorming` (vs `grill-me`/`grill-with-docs`), `writing-skills` (vs `write-a-skill`), `writing-plans` (vs `to-prd`), `executing-plans` (vs `handoff`) | keep `evantoor` for this area |
| `<other pack>` | …list detected overlaps… | keep `evantoor` |

Present the choice to the user like:

> Found overlap with the `superpowers` pack — it ships 6 skills covering the same ground as evantoor's `tdd`, `diagnosing-bugs`, `grill-*`, `write-a-skill`, `to-prd`, and `handoff`. Pick one pack to own this area:
> - **Keep evantoor** (default) — disable superpowers' overlapping skills locally; superpowers' non-overlapping skills stay active
> - **Keep superpowers** — leave superpowers active and skip writing the preferred-skills hint
> - **Keep both** (discouraged) — leads to inconsistent behaviour across sessions

Default is **keep evantoor** (the user installed this pack on purpose). "Keep both" is offered but called out as discouraged.

Only present a decision for packs that actually have overlaps. A pack with zero overlaps is left alone.

**Apply the user's choices in two layers:**

1. **Hard disable via settings.json** (when supported by the host plugin's disable mechanism). Project-local `.claude/settings.local.json` is preferred so the choice doesn't leak to other repos. Common shapes:
   - Whole pack disable: `"enabledPlugins": { "<plugin-name>": false }` (cleanest when the user wants the entire pack off)
   - Per-skill disable inside a pack: `"disabledSkills": ["<plugin>:<skill>", …]` (if the harness supports it) — use this when only the *overlapping* skills should go, leaving the rest of the pack live
   - If unsure of the exact key, **ask the user to confirm before writing** rather than guessing — settings.json is shared across sessions and a wrong key silently does nothing.
2. **Soft preference via AGENTS.md/CLAUDE.md.** Always write a `### Preferred skills` subsection under `## Agent skills` naming the winning pack for each overlapping area. This works regardless of whether the hard-disable mechanism is available, and gives Claude a clear instruction at session start.

The `### Preferred skills` block:

```markdown
### Preferred skills

When skills overlap, prefer the `evantoor` pack over `<other pack>` for these areas:

- TDD / red-green-refactor → `evantoor:tdd`
- Debugging / bug diagnosis → `evantoor:diagnosing-bugs`
- Brainstorming / spec interviews → `evantoor:grill-me` and `evantoor:grill-with-docs`
- Writing skills → `evantoor:write-a-skill`
- PRDs / plans → `evantoor:to-prd`
- Handoff between sessions → `evantoor:handoff`
```

Only list areas where an overlap was actually detected — don't enumerate hypothetical conflicts.

After applying, **note to the user** exactly what was disabled and where (file path + key), so they can roll it back if they change their mind.

**Section E — Tooling.**

> Explainer: evantoor's convention is one tool manager (mise) plus one package manager per ecosystem (bun for JS, uv for Python). Tasks are file tasks under `mise/tasks/`, and every task writes its full output to `mise/logs/<task>.log` with a footer that names the log path — so when an agent's tool-result buffer truncates, the agent still knows where to read the rest. A `PreToolUse` hook on Bash auto-activates mise for every command, so the agent doesn't have to remember to prefix things with `mise exec --`. This section sets up that scaffolding and tells future sessions about it.

Walk the user through three steps. Skip cleanly when the answer is "already done" (don't overwrite existing files).

1. **Pick which ecosystems to wire up.** Ask the user which of `bun`, `uv` / `python`, `node` they want pinned in `mise.toml`. Default: bun + uv + python. Drop any they say they don't need.

2. **Write or update `mise.toml`.** Use [mise-template.toml](./mise-template.toml) as the seed; write it to the repo root as `mise.toml` (the non-hidden form — not `.mise.toml`). If a `mise.toml` (or legacy `.mise.toml`) already exists, merge — don't clobber the user's existing `[tools]` or `[env]` blocks. Always ensure `[task_config]` includes `mise/tasks` so file tasks under that path are discoverable.

3. **Create the task + log scaffolding** (idempotent — skip files that already exist):
   - `mise/tasks/` directory
   - `mise/tasks/.gitkeep`
   - `mise/logs/` directory
   - `mise/logs/.gitignore` containing `*.log` (and a `!.gitignore` line so the gitignore itself stays tracked)
   - `mise/tasks/example` copied from [task-template.sh](./task-template.sh), renamed (no `.sh` extension is fine — mise picks up both forms) and `chmod +x`. Leave it as a no-op example the user can delete; don't try to infer what their real first task should be.
   - `docs/agents/tooling.md` copied from [tooling.md](./tooling.md). This is what `mise-tasks` and other skills read to know the conventions.

4. **Wire the mise-activation hook.** Add a `PreToolUse` hook on `Bash` to `.claude/settings.local.json` that prepends `eval "$(mise activate bash)"` to every Bash command. This way the agent never has to remember to use `mise exec --` — the mise PATH is already active in the subshell that runs the command:

   ```json
   {
     "hooks": {
       "PreToolUse": [
         {
           "matcher": "Bash",
           "hooks": [
             {
               "type": "command",
               "command": "jq -c '.tool_input.command = \"eval \\\"$(mise activate bash)\\\" 2>/dev/null; \" + (.tool_input.command // \"\")'"
             }
           ]
         }
       ]
     }
   }
   ```

   The hook reads the PreToolUse JSON from stdin and writes back a modified version with the activation prepended. `2>/dev/null` swallows any `mise activate` chatter (e.g. trust prompts on first run — handled separately by telling the user to `mise trust` once after setup).

   Notes:
   - Prepending is safe even if the command already uses `mise exec --` or `mise run`; the activation is idempotent.
   - This requires `jq` to be on PATH. If the user doesn't have it (uncommon on macOS/Linux dev machines), fall back to a small shell script under `.claude/hooks/mise-activate.sh` that does the same rewrite with `sed`/`awk` — but ask the user first; don't ship a fallback they didn't agree to.
   - If `.claude/settings.local.json` already exists, merge the hook in rather than replacing the file. If a `PreToolUse`/`Bash` hook is already there, append this one in the same `hooks` array rather than overwriting.

5. **Append to the `## Agent skills` block** in CLAUDE.md / AGENTS.md:

   ```markdown
   ### Tooling

   mise + bun + uv. Tasks live in `mise/tasks/`, logs in `mise/logs/<task>.log`. See `docs/agents/tooling.md`. Author new tasks via the `mise-tasks` skill.
   ```

6. **Tell the user what was done** — list the files created (`mise.toml`, `mise/tasks/`, `mise/logs/`, `docs/agents/tooling.md`, `.claude/settings.local.json` hook) and remind them to run `mise install && mise trust` once.

**Section F — Git commit format.**

> Explainer: evantoor's convention is single-line commits prefixed with a gitmoji, one functional purpose per commit. The `gitmoji-commits` skill has the full reference (emoji table, examples, isolation rule). This section just wires the convention into the repo so agents follow it.

1. **Check for an existing convention.** Look at the last 20 commits (`git log --oneline -20`). If the repo already uses Conventional Commits (`feat:`, `fix:`, …) or another well-established convention, **ask the user** before overriding — they may want to keep the existing one for consistency with co-maintainers.

2. **Append to the `## Agent skills` block** in CLAUDE.md / AGENTS.md:

   ```markdown
   ### Git commits

   Single-line commits prefixed with a gitmoji, one functional purpose per commit. No body. No trailers unless the user asks. See the `gitmoji-commits` skill for the emoji table and examples.
   ```

3. **Optionally** offer to install a `commit-msg` hook that rejects messages without a leading emoji + one-line subject. Default: don't install — most repos don't need enforcement. Only install if the user explicitly asks.

**Section G — Comment style.**

> Explainer: evantoor's convention is doc comments on public surfaces (yes), inline comments inside function bodies (no — extract a named function instead). The `comment-style` skill has the full reference. This section wires the rule into the repo so agents follow it without being told.

**Append to the `## Agent skills` block** in CLAUDE.md / AGENTS.md:

```markdown
### Comment style

Doc comments encouraged on public APIs (functions, types, modules). Inline comments inside function bodies are heavily discouraged — if you want to write one explaining *what* the next lines do, extract a named function instead. Exceptions for non-obvious *why* only (workarounds, invariants, surprising behaviour). See the `comment-style` skill.
```

No hook or lint to install — this is a stylistic rule applied during authoring and review, not at commit time.

**Section H — Skill relevance.**

> Explainer: Where Section D resolves *conflicts* between packs that cover the same ground, this section asks a different question: which installed skills actually fit *this* project? A Rust-only pack in a TypeScript repo, an Obsidian skill with no vault, or `migrate-to-shoehorn` in a non-TS repo are all noise — they bloat the skill list and occasionally fire when they shouldn't. The fix is to keep the skills that match the repo's stack and disable the ones that clearly don't.

Detect the repo's stack signals, then classify every skill **actually loaded in the current session** (read the `available skills` and `MCP` blocks from your own context — don't invent skills from training data) as keep or disable. Use [skill-relevance.md](./skill-relevance.md) for the detection signals and the seed mapping; for any loaded skill the table doesn't name, judge it from its own `description` against the detected signals, and **when unsure, keep it and say so** — never disable on a guess.

Three buckets:

- **Universal** — language-agnostic engineering/writing skills (most of evantoor's core: `tdd`, `diagnosing-bugs`, `grill-*`, `to-prd`, etc.) and doc fetchers. Never disabled on stack grounds. A repo being Rust or Python is not a reason to turn off `tdd` or `diagnosing-bugs`.
- **Stack-gated, signal present** — recommend keeping (e.g. `rust-skills` in a `Cargo.toml` repo, `frontend-design` in a UI repo).
- **Stack-gated, no signal** — recommend disabling (e.g. the whole `rust-skills` pack when there's no `Cargo.toml`, `obsidian-vault` with no `.obsidian/`, `migrate-to-shoehorn` in a non-TS repo).

Present the recommendation as two short lists — **keep** and **disable as irrelevant** — and let the user veto any line before you write. Then apply with the **same two layers as Section D**:

1. **Hard disable** via `.claude/settings.local.json` — `enabledPlugins` to drop a whole pack, `disabledSkills` for individual skills. If unsure of the exact key, ask before writing.
2. **Soft note** — write a `### Skill relevance` subsection under `## Agent skills` recording what was disabled as irrelevant and which stack-specific skills to prefer, so re-runs and future sessions see the decision.

After applying, tell the user exactly what was disabled and where (file path + key), so they can roll it back.

### 3. Confirm and edit

Show the user a draft of:

- The `## Agent skills` block to add to whichever of `CLAUDE.md` / `AGENTS.md` is being edited (see step 4 for selection rules)
- The contents of `docs/agents/issue-tracker.md`, `docs/agents/triage-labels.md`, `docs/agents/domain.md`

Let them edit before writing.

### 4. Write

**Pick the file to edit:**

- If `CLAUDE.md` exists, edit it.
- Else if `AGENTS.md` exists, edit it.
- If neither exists, ask the user which one to create — don't pick for them.

Never create `AGENTS.md` when `CLAUDE.md` already exists (or vice versa) — always edit the one that's already there.

If an `## Agent skills` block already exists in the chosen file, update its contents in-place rather than appending a duplicate. Don't overwrite user edits to the surrounding sections.

The block:

```markdown
## Agent skills

### Issue tracker

[one-line summary of where issues are tracked]. See `docs/agents/issue-tracker.md`.

### Triage labels

[one-line summary of the label vocabulary]. See `docs/agents/triage-labels.md`.

### Domain docs

[one-line summary of layout — "single-context" or "multi-context"]. See `docs/agents/domain.md`.

### Tooling

mise + [list ecosystems pinned, e.g. bun + uv]. Tasks live in `mise/tasks/`, logs in `mise/logs/<task>.log`. See `docs/agents/tooling.md`. Author new tasks via the `mise-tasks` skill.

### Git commits

Single-line commits prefixed with a gitmoji, one functional purpose per commit. No body. No trailers unless the user asks. See the `gitmoji-commits` skill.

### Comment style

Doc comments encouraged on public APIs. Inline comments discouraged — extract a named function instead. Exceptions for non-obvious *why* only. See the `comment-style` skill.

### Preferred skills

[only present if overlaps were detected in step 2 — see Section D for format]

### Skill relevance

[only present if any skill was disabled as irrelevant in step 2 — see Section H. List the disabled skills and the stack-specific ones to prefer.]
```

Then write the docs files using the seed templates in this skill folder as a starting point:

- [issue-tracker-github.md](./issue-tracker-github.md) — GitHub issue tracker
- [issue-tracker-gitlab.md](./issue-tracker-gitlab.md) — GitLab issue tracker
- [issue-tracker-local.md](./issue-tracker-local.md) — local-markdown issue tracker
- [triage-labels.md](./triage-labels.md) — label mapping
- [domain.md](./domain.md) — domain doc consumer rules + layout
- [tooling.md](./tooling.md) — mise + bun + uv conventions
- [mise-template.toml](./mise-template.toml) — seed `mise.toml`
- [task-template.sh](./task-template.sh) — seed file task (logging + tail pattern)
- [skill-relevance.md](./skill-relevance.md) — detection signals + seed stack→skill mapping for Section H

For "other" issue trackers, write `docs/agents/issue-tracker.md` from scratch using the user's description.

### 5. Done

Tell the user the setup is complete and which engineering skills will now read from these files. Mention they can edit `docs/agents/*.md` directly later — re-running this skill is only necessary if they want to switch issue trackers or restart from scratch.
