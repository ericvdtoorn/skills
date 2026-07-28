# Engineering

Skills I use daily for code work.

- **[comment-style](./comment-style/SKILL.md)** — Doc comments encouraged, inline comments heavily discouraged; extract a named function instead of writing one.
- **[diagnose](./diagnose/SKILL.md)** — Disciplined diagnosis loop for hard bugs and performance regressions: reproduce → minimise → hypothesise → instrument → fix → regression-test.
- **[gitmoji-commits](./gitmoji-commits/SKILL.md)** — Single-line commits prefixed with a gitmoji, one functional purpose per commit. Emoji table, examples, isolation rule.
- **[grill-with-docs](./grill-with-docs/SKILL.md)** — Grilling session that challenges your plan against the existing domain model, sharpens terminology, and updates `CONTEXT.md` and ADRs inline.
- **[triage](./triage/SKILL.md)** — Triage issues through a state machine of triage roles.
- **[improve-codebase-architecture](./improve-codebase-architecture/SKILL.md)** — Find deepening opportunities in a codebase, informed by the domain language in `CONTEXT.md` and the decisions in `docs/adr/`.
- **[mise-tasks](./mise-tasks/SKILL.md)** — Reference for authoring and running mise file tasks. File-task template with `mise/logs/<task>.log` output and a tail pattern that names the log path so agents don't re-run for context.
- **[setup-evantoor-skills](./setup-evantoor-skills/SKILL.md)** — Scaffold the per-repo config (issue tracker, triage label vocabulary, domain doc layout, mise/bun/uv tooling) that the other engineering skills consume, and disable overlapping skills from other plugins.
- **[tdd](./tdd/SKILL.md)** — Test-driven development with a red-green-refactor loop. Builds features or fixes bugs one vertical slice at a time.
- **[to-issues](./to-issues/SKILL.md)** — Break any plan, spec, or PRD into independently-grabbable GitHub issues using vertical slices.
- **[to-prd](./to-prd/SKILL.md)** — Turn the current conversation context into a PRD and submit it as a GitHub issue.
- **[zoom-out](./zoom-out/SKILL.md)** — Tell the agent to zoom out and give broader context or a higher-level perspective on an unfamiliar section of code.
- **[prototype](./prototype/SKILL.md)** — Build a throwaway prototype to flesh out a design — either a runnable terminal app for state/business-logic questions, or several radically different UI variations toggleable from one route.
- **[implement](./implement/SKILL.md)** — Turn an agreed plan into committed code, routing by size: subagent-driven development for big/architectural changes, direct main-agent implementation for small touches. Auto-commits with gitmoji.
- **[spec](./spec/SKILL.md)** — Front door for a new feature: `/spec <feature>` does discovery, sizes the change, decides whether grilling is needed, runs it if so, then routes to `implement` — all in one auto-driven flow.
- **[codebase-design](./codebase-design/SKILL.md)** — Shared vocabulary for deep modules — module, interface, seam, depth, leverage, locality — plus the deepening and design-it-twice practices other skills lean on.
- **[domain-modeling](./domain-modeling/SKILL.md)** — Actively build and sharpen the project's domain model: challenge fuzzy terms, write `CONTEXT.md`, and record ADRs as decisions crystallise.
- **[research](./research/SKILL.md)** — Spin up a background agent to investigate a question against primary sources and capture the findings as a markdown file in the repo.
- **[resolving-merge-conflicts](./resolving-merge-conflicts/SKILL.md)** — Resolve an in-progress merge or rebase by finding the primary source behind each hunk and preserving both intents.
- **[wayfinder](./wayfinder/SKILL.md)** — Plan work too big for one agent session as a shared map of decision tickets on your issue tracker, resolved one at a time until the way is clear.
- **[code-review](./code-review/SKILL.md)** — Review the diff since a fixed point along two parallel axes — **Standards** (does it follow the repo's documented standards, plus a Fowler smell baseline?) and **Spec** (does it faithfully implement the originating issue/spec?) — run as parallel sub-agents.
