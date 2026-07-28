# Subagent-driven development (BIG branch)

The change is large enough that doing it inline would produce an unreviewable blob. Instead, **you are the orchestrator**: you slice the work, dispatch a subagent per slice, integrate, and commit as each slice lands.

## 1. Decompose into vertical slices

Break the plan into **thin, dependency-ordered vertical slices** — each one a small end-to-end change that leaves the codebase working, not a horizontal layer (no "all the types", then "all the logic"). This is the same tracer-bullet thinking as [to-tickets](../to-tickets/SKILL.md), but **in-conversation — do not create tracker tickets**.

Write the slice list out so the user can see the plan and the order. Each slice should be one gitmoji commit's worth of work.

## 2. Dispatch one subagent per slice

For each slice, spawn a subagent (Agent tool). Give it everything it needs so it doesn't re-explore from scratch:

- The slice goal and its acceptance check (how it'll know it's done).
- The relevant files and context **you already gathered** while planning — paths, the functions/patterns to reuse, the interfaces it must fit.
- The conventions to honour: [tdd](../tdd/SKILL.md) where automated tests fit, [comment-style](../comment-style/SKILL.md), and the repo's task runner for verification.
- Instruction to implement **and verify** (types/tests/lint green) before returning, and to report what it changed.

## 3. Run sequentially by default

Run slices **one at a time in dependency order** so they share the working tree without commit conflicts. Only run slices in parallel when they're genuinely independent — and then give each its own `isolation: "worktree"` so their edits don't collide.

## 4. Commit each slice

After a slice integrates and its checks pass, **commit it immediately** with a single gitmoji line per [gitmoji-commits](../gitmoji-commits/SKILL.md) — one functional purpose per commit. This is the per-slice auto-commit; don't batch slices into one giant commit, and don't wait to be asked.

## 5. Integrate and report

When every slice has landed, run the **full** typecheck/test suite to confirm the slices compose, then report a short summary: the slices, each commit, and anything left out of scope.

## Not the same as `/to-tickets`

This branch is the **synchronous, in-conversation** path for building a big change now. [to-tickets](../to-tickets/SKILL.md) remains the **asynchronous / AFK** path — it publishes ticket-shaped slices for agents to pick up later. Use that one when the work should be queued rather than built in this session.
