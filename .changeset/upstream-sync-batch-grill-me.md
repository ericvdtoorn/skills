---
"evantoor-skills": minor
---

Sync with upstream `mattpocock/skills` again.

**Installable as a Claude Code plugin.** The repo now carries a `.claude-plugin/marketplace.json`, so the set installs as a managed, always-current bundle:

```bash
claude plugin marketplace add ericvdtoorn/skills
claude plugin install evantoor-skills@evantoor
```

The README's install section is split by audience — Claude Code, Codex and other agents, and tinkerers who want editable files via `npx skills@latest add ericvdtoorn/skills` — with `/setup-evantoor-skills` promoted to a shared step 2. Pick one path; installing both leaves you with every skill twice.

**New in-progress draft.** `batch-grill-me` — a grilling session that asks the whole *frontier* (every decision whose prerequisites are settled) in one numbered round, rather than one question at a time. Each round's answers push the frontier outward. Facts still come from sub-agents, not from you, and a running exploration only blocks the questions downstream of it. Kept model-invocable, as with the rest of the set.
