# Engineering

Skills I use daily for code work.

- **[comment-style](./comment-style/SKILL.md)** — Doc comments encouraged, inline comments heavily discouraged; extract a named function instead of writing one.
- **[diagnosing-bugs](./diagnosing-bugs/SKILL.md)** — Diagnosis loop for hard bugs and performance regressions: build a tight red-capable feedback loop first, then reproduce → minimise → hypothesise → instrument → fix → regression-test.
- **[gitmoji-commits](./gitmoji-commits/SKILL.md)** — Single-line commits prefixed with a gitmoji, one functional purpose per commit. Emoji table, examples, isolation rule.
- **[grill-with-docs](./grill-with-docs/SKILL.md)** — Grilling session that challenges your plan against the existing domain model, sharpens terminology, and updates `CONTEXT.md` and ADRs inline — `/grill-me` plus `/domain-modeling`.
- **[triage](./triage/SKILL.md)** — Move issues and external PRs through a state machine of triage roles — categorise, verify the claim, grill if needed, and write agent-ready briefs.
- **[improve-codebase-architecture](./improve-codebase-architecture/SKILL.md)** — Scan a codebase for deepening opportunities — scoped to where change is landing — present them as a visual HTML report, then grill through whichever one you pick.
- **[mise-tasks](./mise-tasks/SKILL.md)** — Reference for authoring and running mise file tasks. File-task template with `mise/logs/<task>.log` output and a tail pattern that names the log path so agents don't re-run for context.
- **[setup-evantoor-skills](./setup-evantoor-skills/SKILL.md)** — Scaffold the per-repo config (issue tracker, triage label vocabulary, domain doc layout, mise/bun/uv tooling) that the other engineering skills consume, and disable overlapping skills from other plugins.
- **[tdd](./tdd/SKILL.md)** — Test-driven development as a red → green loop, plus the reference that makes it produce tests worth keeping: what a good test is, pre-agreed seams, and the anti-patterns (implementation-coupled, tautological, horizontally sliced).
- **[to-tickets](./to-tickets/SKILL.md)** — Break a plan, spec, or the current conversation into tracer-bullet tickets, each declaring its blocking edges — including expand–contract sequencing for wide refactors.
- **[to-spec](./to-spec/SKILL.md)** — Turn the current conversation into a spec (you may know it as a PRD) and publish it to the project issue tracker. No interview — just synthesises what you have already discussed.
- **[zoom-out](./zoom-out/SKILL.md)** — Tell the agent to zoom out and give broader context or a higher-level perspective on an unfamiliar section of code.
- **[prototype](./prototype/SKILL.md)** — Build a throwaway prototype to answer a design question — a runnable terminal app for state/business-logic questions, or several radically different UI variations toggleable from one route. Captured on a throwaway branch as a primary source when done.
- **[implement](./implement/SKILL.md)** — Turn an agreed plan into committed code, routing by size: subagent-driven development for big/architectural changes, direct main-agent implementation for small touches. Auto-commits with gitmoji.
- **[spec](./spec/SKILL.md)** — Front door for a new feature: `/spec <feature>` does discovery, sizes the change, decides whether grilling is needed, runs it if so, then routes to `implement` — all in one auto-driven flow.
- **[codebase-design](./codebase-design/SKILL.md)** — Shared vocabulary for deep modules — module, interface, seam, depth, leverage, locality — plus the deepening and design-it-twice practices other skills lean on.
- **[domain-modeling](./domain-modeling/SKILL.md)** — Actively build and sharpen the project's domain model: challenge fuzzy terms, write `CONTEXT.md`, and record ADRs as decisions crystallise.
- **[research](./research/SKILL.md)** — Spin up a background agent to investigate a question against primary sources and capture the findings as a markdown file in the repo.
- **[resolving-merge-conflicts](./resolving-merge-conflicts/SKILL.md)** — Resolve an in-progress merge or rebase by finding the primary source behind each hunk and preserving both intents.
- **[wayfinder](./wayfinder/SKILL.md)** — Plan work too big for one agent session as a shared map of decision tickets on your issue tracker, resolved one at a time until the way is clear.
- **[code-review](./code-review/SKILL.md)** — Review the diff since a fixed point along two parallel axes — **Standards** (does it follow the repo's documented standards, plus a Fowler smell baseline?) and **Spec** (does it faithfully implement the originating issue/spec?) — run as parallel sub-agents.
