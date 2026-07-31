# evantoor-skills

## 1.1.0

### Minor Changes

- [`e3767ab`](https://github.com/ericvdtoorn/skills/commit/e3767abb495c945e735e6ae682e7786abfb0364a) Thanks [@Pluriscient](https://github.com/Pluriscient)! - **`mise-tasks`** now covers `#USAGE` arg declarations. Tasks with a defined interface declare their flags and positional args in the header — mise validates input, generates `--help`, and injects each value as a `usage_<name>` env var — instead of hand-parsing `"$@"`. Raw `"$@"` stays right for pure passthrough wrappers (`bun test "$@"`), where the wrapped tool owns arg parsing.

- [`031f3cf`](https://github.com/ericvdtoorn/skills/commit/031f3cf769e838f22662f883f7acfd07989e0454) Thanks [@Pluriscient](https://github.com/Pluriscient)! - Sync with upstream `mattpocock/skills`, selectively.

  **Renamed skills.** The old names no longer exist — update any muscle memory, aliases, or docs that reference them:

  - `/diagnose` → `/diagnosing-bugs`
  - `/to-prd` → `/to-spec`
  - `/to-issues` → `/to-tickets`
  - `/write-a-skill` → `/writing-great-skills`
  - `/review` → `/code-review` (also promoted from `in-progress/` to `engineering/`)

  **New skills.**

  - **`wayfinder`** — plan work too big for one agent session as a shared map issue with child decision tickets on your tracker, resolved one at a time until the way to the destination is clear. The per-tracker "Wayfinding operations" it needs are now in `setup-evantoor-skills`' GitHub, GitLab, and local-markdown tracker docs.
  - **`codebase-design`** — the deep-module vocabulary (module, interface, seam, depth, adapter, leverage, locality) plus the deepening and design-it-twice practices, extracted so other skills share one source of truth.
  - **`domain-modeling`** — building and sharpening the domain model (`CONTEXT.md`, ADRs) as its own skill, extracted from `grill-with-docs`.
  - **`research`** — background agent that investigates a question against primary sources and writes the findings into the repo.
  - **`resolving-merge-conflicts`** — resolve an in-progress merge or rebase by finding the primary source behind each hunk and preserving both intents.
  - **`teach`** — promoted from `in-progress/` with the upstream rewrite: shared components in `./assets/`, and lessons designed for storage strength over fluency.

  **Reworked skills.**

  - **`code-review`** now carries an always-on Fowler smell baseline on the Standards axis, on top of whatever the repo documents.
  - **`diagnosing-bugs`** gates Phase 1 on a _tight, red-capable_ loop — one command you have already run — and folds minimising into Phase 2.
  - **`tdd`** is reference-only: red → green with no refactor stage (that belongs to `/code-review`), tests written only at pre-agreed seams, and a tautological-test anti-pattern.
  - **`to-tickets`** adds prefactoring, single-context slice sizing, expand–contract sequencing for wide refactors, and a per-ticket file template for the local tracker.
  - **`triage`** treats external PRs as a request surface — a PR is an issue with attached code — with a redundancy check against the codebase and an already-implemented `wontfix` that does not poison `.out-of-scope/`.
  - **`grill-with-docs`** collapses to `/grill-me` plus `/domain-modeling`, and **`improve-codebase-architecture`** scopes its scan to where change is actually landing (YAGNI) and leans on `/codebase-design` for vocabulary.
  - **`prototype`** captures the prototype itself as a primary source on a throwaway branch rather than deleting it.

  **Tracker convention change.** On the local-markdown tracker the spec now lives at `.scratch/<feature-slug>/spec.md` (was `PRD.md`), and tickets are always one file per ticket.

  **New in-progress drafts.** `claude-handoff` (hand off to a background `claude --bg` agent) and `to-questionnaire` (turn a decision you can't answer alone into a doc for someone else to fill in).

  **Repo plumbing.** Every skill now ships an `agents/openai.yaml` so the set works in Codex, and releases run on changesets.

  Skills kept model-invoked throughout, against upstream's move to user-invoked, because this set chains skills together and a user-invoked skill can't be reached by another skill.

- [`d1ce738`](https://github.com/ericvdtoorn/skills/commit/d1ce7381adc74f969e10f8f9e8e1df6fdf44704d) Thanks [@Pluriscient](https://github.com/Pluriscient)! - Sync with upstream `mattpocock/skills` again.

  **Installable as a Claude Code plugin.** The repo now carries a `.claude-plugin/marketplace.json`, so the set installs as a managed, always-current bundle:

  ```bash
  claude plugin marketplace add ericvdtoorn/skills
  claude plugin install evantoor-skills@evantoor
  ```

  The README's install section is split by audience — Claude Code, Codex and other agents, and tinkerers who want editable files via `npx skills@latest add ericvdtoorn/skills` — with `/setup-evantoor-skills` promoted to a shared step 2. Pick one path; installing both leaves you with every skill twice.

  **New in-progress draft.** `batch-grill-me` — a grilling session that asks the whole _frontier_ (every decision whose prerequisites are settled) in one numbered round, rather than one question at a time. Each round's answers push the frontier outward. Facts still come from sub-agents, not from you, and a running exploration only blocks the questions downstream of it. Kept model-invocable, as with the rest of the set.
