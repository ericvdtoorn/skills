---
name: grill-with-docs
description: Grilling session that challenges your plan against the existing domain model, sharpens terminology, and updates documentation (CONTEXT.md, ADRs) inline as decisions crystallise. Use when user wants to stress-test a plan against their project's language and documented decisions.
---

Run a [grill-me](../../productivity/grill-me/SKILL.md) session, using the [domain-modeling](../domain-modeling/SKILL.md) skill throughout — challenge the user's terms against the existing glossary, sharpen fuzzy language, and write `CONTEXT.md` entries and ADRs inline as decisions crystallise rather than batching them up.

## When the grilling resolves

Once the plan is settled, hand off to building. Classify the change's size with the [implement](../implement/SKILL.md) rubric and recommend running `/implement`, naming the likely branch — subagent-driven development for a big/architectural change, a direct main-agent implementation for a small one. The user can override the call.
