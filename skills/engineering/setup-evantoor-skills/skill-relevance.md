# Skill Relevance

A seed mapping from project signals to the skills that fit them, used by `setup-evantoor-skills` to recommend which installed skills to keep active and which to disable as irrelevant.

This table is **not exhaustive**. It covers the skills evantoor ships plus the common third-party packs. For any installed skill the table doesn't name, judge it from its own `description` against the detected signals (see "Reasoning for skills not in the table" below).

## How to use this file

1. **Detect signals** — gather what the repo actually uses (see "Detection signals").
2. **Classify each installed skill** — universal (always keep), stack-gated (keep iff its signal is present), or irrelevant (no signal → recommend disable).
3. **Recommend, don't impose** — present an enable/disable list and let the user confirm before writing anything.

Only assess skills that are **actually loaded in the current session** — read the `available skills` and `MCP` blocks from your own context. Don't invent skills from training data.

## Detection signals

Cheap, deterministic checks. Run the ones that are fast; don't over-engineer.

| Signal | How to detect |
| --- | --- |
| Node / JS / TS | `package.json` at root or in workspaces |
| TypeScript | `tsconfig.json`, or `.ts`/`.tsx` files |
| `as`-heavy tests | `package.json` has a test runner **and** test files use `as` casts (grep `\bas\b` in `*.test.ts`/`*.spec.ts`) |
| Frontend / UI | React/Vue/Svelte/Angular/Next in `package.json` deps, or a `components/`/`app/`/`pages/` tree |
| Rust | `Cargo.toml` |
| Python | `pyproject.toml`, `requirements.txt`, `setup.py` |
| Go | `go.mod` |
| mise tooling | `mise.toml` / `.mise.toml`, or a `mise/tasks/` dir |
| Obsidian vault | `.obsidian/` directory |
| Writing / article repo | repo is mostly prose (`.md`/`.mdx` content, little or no source), or a `content/`/`posts/`/`articles/` tree |
| Course / exercise repo | numbered section dirs with problem/solution/explainer stubs |
| Issue tracker | already decided in Section A — reuse that answer, don't re-detect |

## Mapping

### Universal — never disable on stack grounds

These apply to almost any repo. Leave them active regardless of language. (They may still be turned off by **Section D** if another pack wins the same area — that's a separate decision.)

- evantoor core workflow: `grill-me`, `grill-with-docs`, `to-prd`, `to-issues`, `triage`, `tdd`, `diagnosing-bugs`, `improve-codebase-architecture`, `zoom-out`, `prototype`, `handoff`, `writing-great-skills`, `caveman`, `gitmoji-commits`, `comment-style`
- doc fetchers / general tooling: `context7` (MCP), and similar library-docs lookups

`tdd`, `diagnosing-bugs`, `to-issues`, `triage` are language-agnostic by design — a repo being Rust or Python is **not** a reason to disable them.

### Stack-gated — keep only when the signal is present

| Skill (pack) | Keep when | Disable when |
| --- | --- | --- |
| `migrate-to-shoehorn` (evantoor) | TypeScript **and** `as`-heavy tests | not a TS repo, or tests don't use `as` |
| `setup-pre-commit` (evantoor) | Node / JS / TS repo (Husky + lint-staged + Prettier) | no `package.json` anywhere |
| `scaffold-exercises` (evantoor) | course / exercise repo | ordinary application repo |
| `mise-tasks` (evantoor) | mise tooling present, or the user opted into mise in Section E | repo uses a different task runner and the user declined mise |
| `git-guardrails-claude-code` (evantoor) | any git repo where the user wants destructive-command guards | user declines; offer, don't force |
| `rust-skills` (pack) | Rust repo (`Cargo.toml`) | no Rust — disable the **whole pack** |
| `obsidian-vault` (pack) | `.obsidian/` vault present | no vault |
| `frontend-design` (pack) | frontend / UI repo | backend-only, CLI, or library repo |
| writing skills — `edit-article`, `writing-beats`, `writing-fragments`, `writing-shape` (pack) | writing / article repo | code repo with no prose-authoring workflow |

`rust-skills` is large and noisy in a non-Rust repo (it injects routing prompts on every turn). Disabling the whole pack when there's no `Cargo.toml` is the single highest-value relevance call.

## Reasoning for skills not in the table

For any loaded skill this file doesn't name:

1. Read its one-line `description`.
2. Ask: *does this skill's purpose match a signal the repo actually shows?*
   - Names a language/framework/tool the repo doesn't use → **recommend disable**.
   - Describes a general engineering or writing practice with no stack tie → **treat as universal**, keep.
   - Unsure → **keep it and say so** ("kept `<skill>` — couldn't tell if it's relevant; disable it yourself if not"). Never disable on a guess.

## Applying

Use the **same two layers as Section D**:

1. **Hard disable** via `.claude/settings.local.json` (`enabledPlugins` for a whole pack, `disabledSkills` for individual skills). If unsure of the exact key, ask before writing.
2. **Soft note** in the `### Skill relevance` subsection under `## Agent skills`, recording which skills were disabled as irrelevant and which stack-specific ones to prefer — so a re-run and future sessions see the decision and the user can roll it back.

Always tell the user exactly what was disabled and where (file path + key).
