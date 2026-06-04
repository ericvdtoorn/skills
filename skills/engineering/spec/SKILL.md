---
name: spec
description: One-shot front door for a new feature — run /spec <feature> and it does the discovery, sizes the change, decides whether a grilling session is needed, runs it if so, then routes to building. Auto-decides at each gate and proceeds through to a committed implementation, surfacing its calls so you can veto. Use when you want to go from a feature idea to working code in a single flow, or say "spec this", "/spec <feature>".
---

# Spec

`/spec <feature>` takes a feature idea and carries it all the way to committed code. It's the front door above [grill-with-docs](../grill-with-docs/SKILL.md) and [implement](../implement/SKILL.md) — it decides how much process the change actually needs instead of making you choose up front.

**Autonomy:** auto-decide at each gate, **state the call, and keep going** through to a committed implementation. Don't stop and wait for an OK at each step — but make each decision visible in one line so the user can interject and veto. The point is that `/spec <feature>` just runs.

## 1. Discover

Explore the codebase for the area the feature touches before deciding anything. Find:

- The modules, files, and existing **functions/patterns to reuse** — prefer extending what's there over inventing parallel structures.
- The domain language and prior decisions: read `CONTEXT.md` (or `CONTEXT-MAP.md`) and any relevant ADRs under `docs/adr/`, and use that vocabulary from here on.
- The seams where the feature would be tested.

Fan this out across `Explore` subagents when the scope is uncertain or spans several areas.

## 2. Size

Classify the change with the [implement](../implement/SKILL.md) rubric — **BIG** (architectural / crosses module boundaries / many coordinated files / several slices) or **SMALL** (localised, single functional purpose). State the call in one line.

## 3. Decide whether to grill

Grilling resolves ambiguity; it's wasted on a change that has none. Grill (run [grill-with-docs](../grill-with-docs/SKILL.md)) when **any** hold:

- The request has more than one plausible interpretation, or its acceptance criteria are unclear.
- It introduces or reshapes domain concepts, or the terminology is fuzzy.
- It's **BIG** / architectural, or hard to reverse.
- Discovery surfaced a contradiction between what was asked and what the code/docs say.

**Skip grilling** when the change is concrete, small, and unambiguous — you already know exactly what to build and the only open questions are answerable from the code. State which way you're going and why, in one line, then proceed.

When you do grill, drive it to a resolved plan, capturing terms in `CONTEXT.md` and decisions in ADRs as `grill-with-docs` prescribes.

## 4. Route to building

Hand off to [implement](../implement/SKILL.md) with the size already decided. For a **BIG** change, first write a **short spec summary** inline — the goal, the agreed decisions, the vertical slices, and what's out of scope — so the implementation has a spec to work from. For a **SMALL** change, go straight to building. `implement` does the work and **commits with gitmoji** when each unit is done.

## What this is not

`/spec` builds **now, in this session**. When the feature should instead be written up and queued for AFK agents, that's [to-prd](../to-prd/SKILL.md) (publish a PRD) and [to-issues](../to-issues/SKILL.md) (break it into tickets) — a separate, asynchronous path.
