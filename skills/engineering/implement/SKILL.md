---
name: implement
description: Turn an agreed plan or spec into working, committed code, routing by change size. Assesses whether the change is large (architectural / multi-module / many coordinated files) or small (localised touches), then drives subagent-driven development or a direct main-agent implementation accordingly — and commits the result with gitmoji. Use after grilling or speccing when it's time to build, or when the user says "implement this", "build it", "ship this".
---

# Implement

You have an agreed plan. Now build it — at the right size, and commit it when done.

Implementing a one-file tweak the same way you'd implement a new subsystem wastes effort in one direction and under-thinks it in the other. **Size decides the shape.**

## Size the change

Classify the change before touching code:

- **BIG → subagent-driven development.** Any of: changes architecture or crosses module boundaries; introduces a new subsystem; needs coordinated edits across many files; naturally splits into several vertical slices or several gitmoji commits.
- **SMALL → main-agent implementation.** Localised to one or a few files, no architectural change, expresses a single functional purpose — one or two gitmoji commits.

If it's genuinely ambiguous and the user is reachable, ask. Otherwise default to **SMALL if the whole change fits one gitmoji commit**, else **BIG** — and state the assumption before you start.

## Pick a branch

- **BIG** → [SUBAGENT.md](SUBAGENT.md). Decompose into vertical slices and drive a subagent per slice, committing each slice as it lands.
- **SMALL** → [MAIN.md](MAIN.md). Implement directly here and commit once at the end.

Getting the branch wrong is expensive: a big change crammed into the main agent becomes an unreviewable blob, and a small change wrapped in subagent orchestration is pure overhead.

## Rules that apply to both

1. **Honour the repo's conventions.** Follow [comment-style](../comment-style/SKILL.md) (no explanatory inline comments — extract a named function instead) and whatever the surrounding code already does.
2. **Verify before you commit.** Run the relevant types/tests/lint — through the repo's mise tasks where present — and don't commit on red.
3. **Always commit when a unit is done.** Use [gitmoji-commits](../gitmoji-commits/SKILL.md): a single-line message, one gitmoji, one functional purpose per commit. **Auto-commit — do not wait to be asked.** "Done" without a commit is not done.
